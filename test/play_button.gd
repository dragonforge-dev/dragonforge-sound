extends Button

@export var button_name: String

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	Sound.play_ui_sound(Sound.get_sound("button_pressed"))
	if audio_stream_player.playing:
		audio_stream_player.stop()
		text = "Play " + button_name
	else:
		audio_stream_player.play()
		text = "Stop " + button_name
