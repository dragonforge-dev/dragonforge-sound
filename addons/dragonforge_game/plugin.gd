@tool
extends EditorPlugin


const AUTOLOAD_GAME_SAVE_LOAD = "Game"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_GAME_SAVE_LOAD, "res://addons/dragonforge_game/game.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_GAME_SAVE_LOAD)
