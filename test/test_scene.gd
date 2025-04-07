extends Control


@onready var blacksmithing: AudioStream = load("res://test/Blacksmith Anvil Ting B.wav")
@onready var chop_wood: AudioStream = load("res://test/Wood Chop Loose A.wav")
@onready var daytime_field: AudioStream = load("res://test/Field Day Loop.wav")
@onready var clear_waters: Song = load("res://test/clear_waters.tres")
@onready var ambient_sound_button: Button = $"Panel/MarginContainer/VBoxContainer/Ambient Sound Button"
@onready var music_button: Button = $"Panel/MarginContainer/VBoxContainer/Music Button"


var ambient_sound_uid: int


func _on_ui_click_button_pressed() -> void:
	Sound.play_button_pressed_sound()


func _on_blacksmithing_button_pressed() -> void:
	Sound.play_sound_effect(blacksmithing)


func _on_chop_wood_button_pressed() -> void:
	Sound.play_sound_effect(chop_wood)


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
		if Sound.is_music_paused():
			Sound.unpause_music()
		else:
			Sound.play_music(clear_waters)
	else:
		music_button.text = "Play Music"
		Sound.pause_music()
