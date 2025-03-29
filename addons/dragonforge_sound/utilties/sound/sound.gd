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


@export var default_button_pressed_sound: AudioStream
@export var volume_confirm_sound: AudioStream


@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer


var sound_player: AudioStreamPlayer
var sound_playback: AudioStreamPlaybackPolyphonic


func _ready() -> void:
	sound_player = $SoundPlayer
	sound_player.play()
	sound_playback = sound_player.get_stream_playback()
	for index in AudioServer.bus_count:
		print(AudioServer.get_bus_name(index))


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
	play(sound, CHANNEL.UI)


func play_button_pressed_sound():
	play(default_button_pressed_sound, CHANNEL.UI)


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
	print(channel_name)
	var channel_index = AudioServer.get_bus_index(channel_name)
	print(channel_index)
	var volume = db_to_linear(AudioServer.get_bus_volume_db(channel_index))
	for index in AudioServer.bus_count:
		print(AudioServer.get_bus_name(index))
	sound_playback.play_stream(sound, 
								0.0,
								volume,
								1.0,
								AudioServer.PLAYBACK_TYPE_DEFAULT,
								channel_name
	)


func channel_to_string(channel: CHANNEL):
	return CHANNEL.find_key(channel)
