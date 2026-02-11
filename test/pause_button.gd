extends Button


func _ready() -> void:
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	Sound.play_ui_sound(Sound.get_sound("button_pressed"))
	if get_tree().paused:
		get_tree().paused = false
		text = "Pause Game"
	else:
		get_tree().paused = true
		text = "Unpause Game"
