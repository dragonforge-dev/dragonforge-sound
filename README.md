[![Static Badge](https://img.shields.io/badge/Godot%20Engine-4.6.stable-blue?style=plastic&logo=godotengine)](https://godotengine.org/)
[![License](https://img.shields.io/github/license/dragonforge-dev/dragonforge-sound?logo=mit)](https://github.com/dragonforge-dev/dragonforge-sound/blob/main/LICENSE)
[![GitHub release badge](https://badgen.net/github/release/dragonforge-dev/dragonforge-sound/latest)](https://github.com/dragonforge-dev/dragonforge-sound/releases/latest)
[![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-sound)](https://img.shields.io/github/languages/code-size/dragonforge-dev/dragonforge-sound)

# Dragonforge Sound <img src="/addons/dragonforge_sound/assets/textures/icons/sound.svg" width="32" alt="Sound Project Icon"/>
This plugin manages volume levels for your entire game. It also centrally controls music for gameplay and a pause menu. It has functionality for fading music in and out, cross-fading music, displaying song and album info (for Ogg Vorbius and some Wav files), and playing UI sounds, and playing dialogue.
# Version 0.17
For use with **Godot 4.6.stable** and later.
## Dependencies
The following dependencies are included in the addons folder and are required for the template to function.
- [Dragonforge Disk (Save/Load) 0.7](https://github.com/dragonforge-dev/dragonforge-disk)
- [Dragonforge User Interface 0.2](https://github.com/dragonforge-dev/dragonforge-user-interface)
# Installation Instructions
1. Copy the `dragonforge_sound` folder from the `addons` folder into your project's `addons` folder.
2. If it does not exist already, copy the `dragonforge_disk` folder from the `addons` folder into your project's `addons` folder.
3. If it does not exist already, copy the `dragonforge_user_interface` folder from the `addons` folder into your project's `addons` folder.
4. Go to **Project -> Project Settings...**
5. Select the **plugins** tab.
6. Check the **On checkbox** under **Enabled** for **Dragonforge Disk** (must be enabled **before** the Sound plugin or you will get errors).
7. Check the **On checkbox** under **Enabled** for **Dragonforge User Interface**.
8. Check the **On checkbox** under **Enabled** for **Dragonforge Sound**.
9. Press the **Close** button.
10. Save your project.

**NOTE:** As of version 0.17, the plugin no longer adds the buses it needs. If you have an old version of the plugin, load the defaults and manually create the buses you need.

# Usage Instructions
Out of the box, this plugin has an Audio screen that supports volume controls for Main (Master Bus), Music, SFX, and Dialogue buses. However, due to a bug with Godot, you must create these buses yourself for now. If you're not using Dialogue, you do not need to make a Dialogue bus, but it is recommended you make the other three.

1. Click the **Audio** tab at the bottom of the editor.
2. Click the **Add Bus** button, and name the new bus **"SFX"**.
3. Click the **Add Bus** button, and name the new bus **"UI"**.
4. Click the **Add Bus** button, and name the new bus **Music**.

**NOTE:** Any buses you do not create will result in **Sound** and/or **Music** using the Master bus instead. Also, those volume controls will be missing from **Audio** screen as you cannot configure their volume controls seperately without separate audio buses.

# Class Descriptions
## Sound (Autoload) <img src="/addons/dragonforge_sound/assets/textures/icons/sound.svg" width="32" alt="Sound Autoload Icon"/>

### Signals
- `volume_changed(audio_bus: String, new_value: float)` Emitted when the volume for a bus is changed.

### Export Variables
- `enable_3d_look = false` When true, 3D look is on for the game. The right stick will look, as well as the mouse. In addition the mouse will be captured when the game is playing and freed when the game is paused. Defaults to `false` (off).

### Public Member Variables
- `ui_sounds: UISounds` Stores custom sounds for the UI Player that can be saved to a resource.

### Public Functions
- `get_sound(sound_name: StringName) -> AudioStream` Returns the [AudioStream] from [member ui_sounds] that matches [param sound_name]. Returns null if nothing is found.
- `play_ui_sound(stream: AudioStream) -> void` Plays an [AudioStream] through the UI Sound Player which is always active.
- `play_volume_confirm_sound(bus_name: String = "Master") -> void` Plays the default volume confirm sound therough the passed bus. Used for confirming volume changes in the Audio settings menu.
- `play_dialogue(stream: AudioStream) -> void` Plays an [AudioStream] through the Dialogue Player which is always active.
- `set_bus_volume(bus: String, new_value: float) -> void` Sets the volume of the given bus using the float for the volume from 0.0 (off) to 1.0 (full volume). Also stores the value in the settings file.
- `get_bus_volume(bus: String) -> float` Returns the volume for the bus passed as a float from 0.0 (off) to 1.0 (full volume).


## Music (Autoload) <img src="/addons/dragonforge_sound/assets/textures/icons/music.svg" width="32" alt="Music Icon"/>
The **Music** system has been separated from the **Sound** system to facilitate easier coding. It allows the fading of music in and out, as well as cross-fading of music, and supports a game music player and a pause menu music player that automatically switch on and off when the game is paused or unpaused using `get_tree().paused`.

### Signals
- `signal song_started` Emitted when a new song starts.
- `signal song_stopped` Emitted when a song is stopped.
- `signal song_finished` Emitted when a song is not looped and finishes without being stopped externally.
- `signal pause_song_finished` Emitted when the pause menu song is not looped and finishes without being stopped externally.
- `signal fade_out_finished` Emitted when a song is faded out, and the fade out finishes.

### Enums
```
enum Fade {
	## Not intended to be used, but will function the same as NONE.
	DEFAULT = 0,
	## No fading. The current song (if any) is stopped and this one is started.
	NONE = 1,
	## The previous song (if any) is stopped, and this one fades in.
	IN = 2,
	## The previous song fades out and this one is started from the beginning after the fade is complete.
	OUT = 3,
	## The previous song fades out while this song fades in over the fade_time.
	CROSS = 4,
	## The previous song (if any) fades out completely first using the fade_time, then this song fades in over the fade_time.
	OUT_THEN_IN = 5
}
```

### Public Functions
- `play(stream: AudioStream, fade: Fade = Fade.NONE, fade_time: float = DEFAULT_FADE_TIME) -> void` Plays an AudioStream through the music channel. If a Song resource is passed, the Song's own play() method is called (which calls this method with the embedded AudioStream and sends out the now_playing signal.) Fading uses the value passed. (Default is NONE.)
- `stop(fade: Fade = Fade.NONE, fade_time: float = DEFAULT_FADE_TIME) -> void` Stops the currently playing song. If fade_out is true, it fades out the currently playing song over the fade_time passed (default is 2 seconds).
- `pause() -> float` Pauses the currently playing music. Returns the playback position where the stream was paused as a float.
- `unpause() -> void` Unpauses the currently queued music.
- `is_paused() -> bool` Returns whether or not music is currently paused.
- `is_playing() -> bool` Returns whether or not music is currently playing.
- `fade_in(audio_stream_player: AudioStreamPlayer, audio_stream: AudioStream = null, fade_time: float = DEFAULT_FADE_TIME) -> void` Fades the [param audio_stream] in using the [param audio_stream_player] [AudioStreamPlayer] and the [param fade_time]. If no [param audio_stream] is given or [null] is passed, it is assumed that value was already set outside this function.
- `fade_out(audio_stream_player: AudioStreamPlayer, fade_time: float = DEFAULT_FADE_TIME) -> void` Fades out the currently playing stream on the [param audio_stream_player] [AudioStreamPlayer] using the [param fade_time]. Once the player is stopped, the volume is set to the default level for the passed [AudioStreamPlayer]'s bus.
- `cross_fade(audio_stream_player: AudioStreamPlayer, audio_stream: AudioStream, fade_time: float = DEFAULT_FADE_TIME) -> void` Cross fades the [param audio_stream] in while fading the existing stream playing in the [param audio_stream_player] [AudioStreamPlayer] using the [param fade_time].
- `get_song_info_bbcode() -> String` Returns the title, artist and album for the currently playing song if they are stored in the metadata of the song and the stream is of type [AudioStreamOggVorbis] or [AudioStreamWAV]. NOTE: [AudioStreamMP3] is not supported by Godot at this time.

## Paused Music
As of version 0.10, the Music player has two players - one for when the game is playing, and one for when the game is paused (*e.g. get_tree().is_paused()*). If a song is set when the game is paused, that song with be played and paused whenever the game is in a paused state. Likewise it can only be stopped when the game is in a paused state. Similarily, a song playing in the game will pause when the game is paused, and resume when the game is unpaused.

This was implemented due to issues trying to maintain and switch two different songs between the states. You do not have to do anything for this feature to work. It just does.

# Copyright
To clarify the information below, all the icons can be freely used and even customized by following the links. The music and sound effects are all copyrighted and you must buy a copy from the copyright holder to be able to use the files anywhere else. The good news is all of the resources are priced reasonably, and you'll get a lot of other really great content by supporting these creators. Direct links have been provided to allow you to buy any files in which you have interest.

## Icons
Icons provided by [SVG Repo](https://www.svgrepo.com/).

## Music
The music in the test program was created and copyright by Dragonforge Development 2025.

## Sound Effects
Anvil Hit 7 from [FilmCow Royalty Free Sound Effect Library](https://filmcow.itch.io/filmcow-sfx) by [FilmCow](https://filmcow.itch.io/)
Countdown (miscellaneous_8_karen.wav) from [Super Dialogue Audio Pack](https://dillonbecker.itch.io/sdap) by [Dillon Becker](https://dillonbecker.itch.io/)

# Localization
This project's UI has been created to work with localization. You can easily use localization by using the [Dragonforge Localization](https://github.com/dragonforge-dev/dragonforge-localization) plugin. The following labels exist and should be given translations:

- VOLUME
- MAIN
- MUSIC
- SOUND_EFFECTS
- DIALOGUE
- BACK
