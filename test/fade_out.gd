extends Button

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	Sound.play_ui_sound(Sound.get_sound("button_pressed"))
	if Music.is_playing():
		Music.stop(Music.Fade.OUT)
