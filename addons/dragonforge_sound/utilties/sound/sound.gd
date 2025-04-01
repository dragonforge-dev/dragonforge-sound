extends Node


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


@export var button_pressed_sound: AudioStream
@export var volume_confirm_sound: AudioStream


@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer
@onready var ui_sound_player: AudioStreamPlayer = $UISoundPlayer


var sound_player: AudioStreamPlayer
var sound_playback: AudioStreamPlaybackPolyphonic


func _ready() -> void:
	sound_player = $SoundPlayer
	sound_player.play()
	sound_playback = sound_player.get_stream_playback()


func play_music(sound: Variant):
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


func pause_music():
	music_player.stream_paused = true


func unpause_music():
	music_player.stream_paused = false


func play_sound_effect(sound: AudioStream):
	play(sound, CHANNEL.SFX)


func play_ui_sound(sound: AudioStream):
	var randomizer: AudioStreamRandomizer = ui_sound_player.stream
	randomizer.add_stream(0, sound)
	ui_sound_player.play()


func play_button_pressed_sound():
	play_ui_sound(button_pressed_sound)


func play_ambient_sound(sound: AudioStream):
	play(sound, CHANNEL.Ambient)


func play_dialogue(sound: AudioStream):
	if sound == null:
			return
	dialogue_player.set_stream(sound)
	dialogue_player.play()


func play(sound: AudioStream, channel: CHANNEL):
	if sound == null:
			return
	var channel_name = channel_to_string(channel)
	var channel_index = _channel_to_bus_index(channel)
	var volume = db_to_linear(AudioServer.get_bus_volume_db(channel_index))
	sound_playback.play_stream(sound, 
								0.0,
								volume,
								1.0,
								AudioServer.PLAYBACK_TYPE_DEFAULT,
								channel_name
	)


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


## Returns the volume for the CHANNEL passed as a float from 0.0 (off) to 
## 1.0 (full volume).
func get_channel_volume(channel: CHANNEL) -> float:
	return AudioServer.get_bus_volume_linear(_channel_to_bus_index(channel))
