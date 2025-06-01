extends Control

const FIELD_WORKSHOP = preload("res://test/field_workshop.tres")
const MINING = preload("res://test/mining.tres")
const DIGGING = preload("res://test/digging.tres")
const ANVIL_RANDOM_PITCH = preload("res://test/anvil_random_pitch.tres")
const LOGGING_RANDOM_PITCH = preload("res://test/logging_random_pitch.tres")

@export var hero_song: Song

var ambient_sound_uid: int
var consecutive_sound_uid: int

@onready var chop_wood: AudioStream = load("res://test/Wood Chop Loose A.wav")
@onready var daytime_field: AudioStream = preload("res://test/Field Day Loop.wav")
@onready var clear_waters: Song = load("res://test/clear_waters.tres")
@onready var ambient_sound_button: Button = $"Panel/MarginContainer/VBoxContainer/Ambient Sound Button"
@onready var music_button: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/Music Button"
@onready var hero_music_button: Button = $"Panel/MarginContainer/VBoxContainer/Hero Music Button"
@onready var consecutive_button: Button = $"Panel/MarginContainer/VBoxContainer/Consecutive Button"
@onready var stop_music_button: Button = $"Panel/MarginContainer/VBoxContainer/HBoxContainer/Stop Music Button"


func _ready() -> void:
	for index in AudioServer.bus_count:
		print(AudioServer.get_bus_name(index))


func _on_ui_click_button_pressed() -> void:
	Sound.play_button_pressed_sound()


func _on_blacksmithing_button_pressed() -> void:
	ANVIL_RANDOM_PITCH.play()


func _on_chop_wood_button_pressed() -> void:
	LOGGING_RANDOM_PITCH.play()


func _on_ambient_sound_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ambient_sound_button.text = "Stop Ambient Sounds"
		ambient_sound_uid = Sound.play_ambient_sound(daytime_field)
	else:
		ambient_sound_button.text = "Play Ambient Sounds"
		Sound.stop(ambient_sound_uid)


func _on_music_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		music_button.text = "Pause Music"
		stop_music_button.show()
		if Music.is_paused():
			Music.unpause()
		else:
			clear_waters.play()
	else:
		music_button.text = "Play Music"
		Music.pause()
		stop_music_button.hide()


func _on_stop_music_button_pressed() -> void:
	Music.stop()
	stop_music_button.hide()
	music_button.text = "Play Music"
	music_button.set_pressed_no_signal(false)


func _on_consecutive_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		consecutive_button.text = "Stop Consecutive Sounds"
		consecutive_sound_uid = Sound.play_ambient_sound(FIELD_WORKSHOP)
	else:
		consecutive_button.text = "Play Consecutive Sounds"
		Sound.stop(consecutive_sound_uid)


func _on_playlist_button_pressed() -> void:
	MINING.play()


func _on_random_playlist_button_pressed() -> void:
	DIGGING.play()


func _on_pause_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_hero_music_button_pressed() -> void:
	hero_song.play()
