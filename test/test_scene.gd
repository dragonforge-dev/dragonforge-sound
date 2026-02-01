extends Control

@onready var audio: Screen = $HBoxContainer/Audio


func _ready() -> void:
	audio.show()
