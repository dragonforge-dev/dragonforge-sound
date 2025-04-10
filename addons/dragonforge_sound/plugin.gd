@tool
extends EditorPlugin


const AUTOLOAD_SOUND = "Sound"
const AUTOLOAD_MUSIC = "Music"
const RESOURCE = "Resource"
const ALBUM = "Album"
const SONG = "Song"
const SFX_PROJECT = "SFXProject"
const SOUND_EFFECT = "SoundEffect"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_SOUND, "res://addons/dragonforge_sound/sound.tscn")
	add_autoload_singleton(AUTOLOAD_MUSIC, "res://addons/dragonforge_sound/music.tscn")
	add_custom_type(ALBUM, RESOURCE, preload("res://addons/dragonforge_sound/resources/album.gd"), preload("res://addons/dragonforge_sound/assets/icons/album.png"))
	add_custom_type(SONG, RESOURCE, preload("res://addons/dragonforge_sound/resources/song.gd"), preload("res://addons/dragonforge_sound/assets/icons/song.svg"))
	add_custom_type(SFX_PROJECT, RESOURCE, preload("res://addons/dragonforge_sound/resources/sfx_project.gd"), preload("res://addons/dragonforge_sound/assets/icons/crate.svg"))
	add_custom_type(SOUND_EFFECT, RESOURCE, preload("res://addons/dragonforge_sound/resources/sound_effect.gd"), preload("res://addons/dragonforge_sound/assets/icons/sound-effect.svg"))
	# As of Godot 4.4 (Release), AudioBus loading functionality does not seem to work. Buses have to be added manually.
	#var audio_bus_layout: AudioBusLayout = load("res://addons/dragonforge_sound/resources/sound_component_bus_layout.tres")
	#AudioServer.set_bus_layout(audio_bus_layout)


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_MUSIC)
	remove_autoload_singleton(AUTOLOAD_SOUND)
	remove_custom_type(ALBUM)
	remove_custom_type(SONG)
	remove_custom_type(SFX_PROJECT)
	remove_custom_type(SOUND_EFFECT)
	# As of Godot 4.4 (Release), AudioBus loading functionality does not seem to work. Buses have to be added manually.
	#var audio_bus_layout: AudioBusLayout = load("res://addons/dragonforge_sound/resources/default_audio_bus_layout.tres")
	#AudioServer.set_bus_layout(audio_bus_layout)
