extends Button

@export var button_name: String

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	pressed.connect(_on_button_pressed)
	Music.song_started.connect(_on_song_started)
	Music.song_stopped.connect(_on_song_stopped)


func _on_button_pressed() -> void:
	Sound.play_ui_sound(Sound.get_sound("button_pressed"))
	if Music.is_playing():
		Music.stop()
		text = "Play " + button_name
	else:
		Music.play(audio_stream_player.stream)
		text = "Stop " + button_name


func _on_song_started() -> void:
	if get_tree().paused and process_mode == ProcessMode.PROCESS_MODE_WHEN_PAUSED:
		print("Song Started in pause mode")
		text = "Stop " + button_name
	elif not get_tree().paused and process_mode == ProcessMode.PROCESS_MODE_INHERIT:
		print("Song Started in play mode")
		text = "Stop " + button_name


func _on_song_stopped() -> void:
	if get_tree().paused and process_mode == ProcessMode.PROCESS_MODE_WHEN_PAUSED:
		print("Song Stopped in pause mode")
		text = "Play " + button_name
	elif not get_tree().paused and process_mode == ProcessMode.PROCESS_MODE_INHERIT:
		print("Song Stopped in play mode")
		text = "Play " + button_name
	
