extends RichTextLabel


func _ready() -> void:
	Music.song_started.connect(_on_song_started)
	Music.song_stopped.connect(_on_song_stopped)


func _on_song_started() -> void:
	text = Music.get_song_info_bbcode()


func _on_song_stopped() -> void:
	text = ""
