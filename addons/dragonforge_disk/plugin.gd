@tool
extends EditorPlugin


const AUTOLOAD_DISK = "Disk"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_DISK, "res://addons/dragonforge_disk/disk.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_DISK)
