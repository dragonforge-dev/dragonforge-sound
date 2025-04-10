@icon("res://addons/dragonforge_sound/assets/icons/sound-effect.svg")
class_name SoundEffect extends Resource


## An AudioStream for the sound effect(s).
##
## AudioStreamMP3 - Used for a single .mp3 sound effect.
## AudioStreamOggVorbis - Used for a single .ogg sound effect.
## AudioStreamWAV - Used for a single .wav sound effect.
## AudioStreamPlaylist - Used for multiple sound effects to be triggered in a
## sequence. If play_only_one_sound (below) is true, only one sound in the list
## will be played each time.
## AudioStreamSynchronized - Used to play a bunch of separate sound files
## together.
## AudioStreamInteractive - Used to play complex sounds together as one but at
## different start times.
## AudioStreamRandomizer - Allows for random pitches with sound effects. (For
## exampleto make a single mining sound less monotonous.)
@export var stream: AudioStream
## How much pitch variance should be in the sound effect(s) played.
## Default is 1.0 (None). Increasing this number increases variation.
## Recommended variance is between 1.05 and 1.2.
@export var play_only_one_sound: bool = false
## Human readable name for the sound effect.
@export var title: String
## The project/album information for the sound effect  Primarily for the
## to track where the effects were sourced.
@export var project: SFXProject


var iterator: int = 0


func play(channel: Sound.CHANNEL = Sound.CHANNEL.SFX) -> int:
	var stream_to_play: AudioStream = stream
	if stream is AudioStreamPlaylist and play_only_one_sound == true:
		if stream.shuffle == true:
			stream_to_play = _get_random_sound(stream)
		else:
			stream_to_play = _get_next_sound(stream)
	return Sound.play(stream, channel)


func _get_next_sound(playlist: AudioStreamPlaylist) -> AudioStream:
	var sound: AudioStream = playlist.get_list_stream(iterator)
	iterator += 1
	if iterator >= playlist.stream_count:
		iterator = 0
	return sound


func _get_random_sound(playlist: AudioStreamPlaylist) -> AudioStream:
	var random_index: int = randi_range(0, playlist.stream_count -1)
	return playlist.get_list_stream(random_index)
