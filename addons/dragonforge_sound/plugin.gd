@tool
extends EditorPlugin


const AUTOLOAD_SOUND = "Sound"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_SOUND, "res://addons/dragonforge_sound/sound.tscn")
	add_custom_type("Song", "Resource", preload("res://addons/dragonforge_sound/resources/song.gd"), preload("res://addons/dragonforge_sound/assets/icons/music-library.png"))
	# As of Godot 4.4 (Release), AudioBus loading functionality does not seem to work. Buses have to be added manually.
	#var audio_bus_layout: AudioBusLayout = load("res://addons/dragonforge_sound/resources/sound_component_bus_layout.tres")
	#AudioServer.set_bus_layout(audio_bus_layout)


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_SOUND)
	remove_custom_type("Song")
	# As of Godot 4.4 (Release), AudioBus loading functionality does not seem to work. Buses have to be added manually.
	#var audio_bus_layout: AudioBusLayout = load("res://addons/dragonforge_sound/resources/default_audio_bus_layout.tres")
	#AudioServer.set_bus_layout(audio_bus_layout)
