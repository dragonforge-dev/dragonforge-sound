@tool
extends EditorPlugin

const AUTOLOAD_SOUND = "Sound"

func _enter_tree() -> void:
	var audio_bus_layout: AudioBusLayout = ResourceLoader.load("res://addons/dragonforge_dev_sound/resources/sound_component_bus_layout.tres")
	if audio_bus_layout:
		print("Resource Loaded")
	AudioServer.set_bus_layout(audio_bus_layout)
	for index in AudioServer.bus_count:
		print(AudioServer.get_bus_name(index))
	#var bus_list: Array[String] = [
		#"Music",
		#"SFX",
		#"Ambient",
		#"UI",
		#"Dialogue"
	#]
	#for bus_name in bus_list:
		#if AudioServer.get_bus_index(bus_name) == -1:
			#var new_bus_number = AudioServer.bus_count
			#AudioServer.add_bus(new_bus_number)
			#AudioServer.set_bus_name(new_bus_number, bus_name)
			#print("Adding bus %s: %s" % [new_bus_number, bus_name])
	add_autoload_singleton(AUTOLOAD_SOUND, "res://addons/dragonforge_dev_sound/utilties/sound/sound.tscn")
	add_custom_type("Song", "Resource", preload("res://addons/dragonforge_dev_sound/resources/song.gd"), preload("res://addons/dragonforge_dev_sound/assets/icons/music-library.png"))


func _exit_tree() -> void:
	for index in AudioServer.bus_count:
		print(AudioServer.get_bus_name(index))
	var audio_bus_layout: AudioBusLayout = ResourceLoader.load("res://addons/dragonforge_dev_sound/resources/default_audio_bus_layout.tres")
	AudioServer.set_bus_layout(audio_bus_layout)
	remove_autoload_singleton(AUTOLOAD_SOUND)
	remove_custom_type("Song")
