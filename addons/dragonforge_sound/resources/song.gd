@icon("res://addons/dragonforge_sound/assets/icons/song.svg")
class_name Song extends Resource


## The AudioStream containing the music track.
@export var song: AudioStream
## The human readable name of the song.
@export var title: String
## The album information for the song.
@export var album: Album


func play() -> void:
	Music.play(song)
	Music.now_playing.emit(self)
