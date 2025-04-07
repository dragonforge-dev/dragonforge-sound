extends Node


signal volume_changed(audio_bus: CHANNEL, new_value: float)
signal now_playing(song: Song)
signal add_song_to_music_playlist(song: Song)


enum CHANNEL {
	Master,
	Music,
	SFX,
	UI,
	Ambient,
	Dialogue,
}


## Default sound for when a button is pressed.
@export var button_pressed_sound: AudioStream
## Default sound for when the volume level is changed in the UI.
@export var volume_confirm_sound: AudioStream


@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer


# Stores a reference for playing polyphonic sounds (more than one at the same time).
var sound_playback: AudioStreamPlaybackPolyphonic


## Loads any saved volume settings and sets up the generic sound player for use.
func _ready() -> void:
	for channel_name in CHANNEL:
		var value = Game.load_setting(channel_name)
		if value:
			AudioServer.set_bus_volume_linear(_channel_to_bus_index(CHANNEL[channel_name]), value)
	sound_player.play()
	sound_playback = sound_player.get_stream_playback()


## Plays a Song or AudioStream through the music channel. Throws an error if the
## passed object is not one of those two types, or if the Song's AudioStream
## value is not set.
func play_music(sound: Variant) -> void:
	if sound == AudioStream:
		var temp_sound = Song.new()
		temp_sound.song = sound
		sound = temp_sound
		sound.title = sound.song.resource_name
		sound.album = "Unknown"
	if sound is not Song:
		push_error("%s not a valid song file or AudioStream" % [sound.name])
	if sound.song == null:
		push_error("%s song is empty. No AudioStream assigned." % [sound.resource_path])
	
	print_rich("Song Playing: %s\nby %s" % [sound.title, sound.artist])
	print_rich("Album: %s\nAlbum Link %s" % [sound.album, sound.album_link])
	music_player.set_stream(sound.song)
	music_player.play()
	now_playing.emit(sound)


## Pauses the currently playing music.
## Returns the playback position where the stream was paused as a float.
func pause_music() -> float:
	music_player.stream_paused = true
	return music_player.get_playback_position()


## Unpauses the currently queued music.
func unpause_music() -> void:
	music_player.stream_paused = false


## Returns whether or not the music stream is paused.
func is_music_paused() -> bool:
	return music_player.stream_paused

## Plays an AudioStream through the SFX (Sound Effects) Channel.
## Returns the UID of the playback stream as an int.
func play_sound_effect(sound: AudioStream) -> int:
	return play(sound, CHANNEL.SFX)


## Plays an AudioStream through the UI Channel.
## Returns the UID of the playback stream as an int.
func play_ui_sound(sound: AudioStream) -> int:
	return play(sound, CHANNEL.UI)


## Plays the default click sound through the UI Channel.
## Returns the UID of the playback stream as an int.
func play_button_pressed_sound() -> int:
	return play_ui_sound(button_pressed_sound)


## Plays an AudioStream through the Ambient Channel.
## Returns the UID of the playback stream as an int.
func play_ambient_sound(sound: AudioStream) -> int:
	return play(sound, CHANNEL.Ambient)


## Plays an AudioStream through the Dialogue Channel.
func play_dialogue(sound: AudioStream) -> void:
	if sound == null:
			return
	dialogue_player.set_stream(sound)
	dialogue_player.play()


## Plays an AudioStream on the given CHANNEL, randomly varying the pitch of the
## sound by a factor of 10%. Returns the UID of the playback stream as an int.
func play(sound: AudioStream, channel: CHANNEL) -> int:
	if sound == null:
			return -1
	var channel_name = channel_to_string(channel)
	return sound_playback.play_stream(sound,
								0.0,
								0.0,
								randf_range(1.0, 1.1),
								AudioServer.PLAYBACK_TYPE_DEFAULT,
								channel_name
	)


## Stops the playback of a polyphonic sound given the UID of the sound playing.
func stop(uid: int) -> void:
	sound_playback.stop_stream(uid)

## Returns a String for the passed CHANNEL.
func channel_to_string(channel: CHANNEL) -> String:
	return CHANNEL.find_key(channel)


## Returns the bus index for the passed CHANNEL.
func _channel_to_bus_index(channel: CHANNEL) -> int:
	return AudioServer.get_bus_index(Sound.channel_to_string(channel))


## Sets the volume of the given CHANNEL using the float for the volume from 
### 0.0 (off) to 1.0 (full volume).
func set_channel_volume(channel: CHANNEL, new_value: float) -> void:
	AudioServer.set_bus_volume_linear(_channel_to_bus_index(channel), new_value)
	Game.save_setting(new_value, channel_to_string(channel))
	volume_changed.emit(channel, new_value)


## Returns the volume for the CHANNEL passed as a float from 0.0 (off) to 
## 1.0 (full volume).
func get_channel_volume(channel: CHANNEL) -> float:
	return AudioServer.get_bus_volume_linear(_channel_to_bus_index(channel))
