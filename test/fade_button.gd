extends Button

@export var fade: Music.Fade

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	Sound.play_ui_sound(Sound.get_sound("button_pressed"))
	if Music.is_playing():
		Music.play(audio_stream_player.stream, fade)
	elif fade == Music.Fade.IN:
		Music.play(audio_stream_player.stream, fade)
