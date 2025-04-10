extends Node


signal volume_changed(audio_bus: CHANNEL, new_value: float)


const ERROR_MISSING_SOUND_EFFECT = preload("res://addons/dragonforge_sound/resources/error_missing_sound_effect.tres")


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


@onready var dialogue_player: AudioStreamPlayer = $DialoguePlayer
@onready var sound_player: AudioStreamPlayer = $SoundPlayer
## The UISoundPlayer continues to work even if the game is paused.
@onready var ui_sound_player: AudioStreamPlayer = $UISoundPlayer


# Stores a reference for playing polyphonic sounds (more than one at the same time).
var sound_playback: AudioStreamPlaybackPolyphonic
var ui_playback: AudioStreamPlaybackPolyphonic

## Loads any saved volume settings and sets up the generic sound player for use.
func _ready() -> void:
	for channel_name in CHANNEL:
		var value = Game.load_setting(channel_name)
		if value:
			AudioServer.set_bus_volume_linear(_channel_to_bus_index(CHANNEL[channel_name]), value)
	sound_player.play()
	sound_playback = sound_player.get_stream_playback()
	ui_sound_player.play()
	ui_playback = ui_sound_player.get_stream_playback()


## Plays an AudioStream through the SFX (Sound Effects) Channel.
## Returns the UID of the playback stream as an int.
func play_sound_effect(sound: Resource) -> int:
	return play(sound, CHANNEL.SFX)


## Plays an AudioStream through the UI Channel.
## Returns the UID of the playback stream as an int.
func play_ui_sound(sound: Resource) -> int:
	return play(sound, CHANNEL.UI)


## Plays the default click sound through the UI Channel.
## Returns the UID of the playback stream as an int.
func play_button_pressed_sound() -> int:
	return play_ui_sound(button_pressed_sound)


## Plays an AudioStream through the Ambient Channel.
## Returns the UID of the playback stream as an int.
func play_ambient_sound(sound: Resource) -> int:
	return play(sound, CHANNEL.Ambient)


## Plays an AudioStream through the Dialogue Channel.
func play_dialogue(sound: AudioStream) -> void:
	if sound == null:
			return
	dialogue_player.set_stream(sound)
	dialogue_player.play()


## Returns the UID of the playback stream it uses to play the passed AudioStream
## on the given CHANNEL.
func play(sound: Resource, channel: CHANNEL) -> int:
	if channel == CHANNEL.UI:
		return _play_polyphonic(ui_playback, sound, channel)
	else:
		return _play_polyphonic(sound_playback, sound, channel)


## Returns the UID of the playback stream it uses to play the passed AudioStream
## on the given CHANNEL using the passed AudioStreamPlaybackPolyphonic object.
func _play_polyphonic(playback: AudioStreamPlaybackPolyphonic, sound: Resource, channel: CHANNEL) -> int:
	if sound is SoundEffect:
		return sound.play(channel)
	if sound is Song:
		sound.play()
		return -1
	if sound == null:
		push_error("Cannot play sound %s. AudioStream is null." % [sound])
		ERROR_MISSING_SOUND_EFFECT.play()
	var channel_name = channel_to_string(channel)
	return playback.play_stream(sound,
								0.0,
								0.0,
								1.0,
								AudioServer.PLAYBACK_TYPE_DEFAULT,
								channel_name
	)


## Stops the playback of a polyphonic sound given the UID of the sound playing.
func stop(uid: int) -> void:
	sound_playback.stop_stream(uid)


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


## Returns a String for the passed CHANNEL.
func channel_to_string(channel: CHANNEL) -> String:
	return CHANNEL.find_key(channel)


## Returns the bus index for the passed CHANNEL.
func _channel_to_bus_index(channel: CHANNEL) -> int:
	return AudioServer.get_bus_index(Sound.channel_to_string(channel))
