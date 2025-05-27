# Dragonforge Sound
A Sound Autoload singleton to handle all sound for a game.
# Version 0.8
For use with **Godot 4.4.1-stable** and later.
# Installation Instructions
The first thing to do is add buses. This plugin will work with only a master bus, but you will lose some functionality. Most importantly, the ability to play sound effects when the game is paused. We recommend adding **Music**, **SFX**, **Ambient**, **UI**, and **Dialogue** buses follwing the steps below. However they do not have to be named exactly the same. If you already have buses with different names, you just need to load the **Sound** scene and change the exported variables to match the buses you use. The plugin will take care of the rest. If you are using your own buses, go ahead and move to the next section.
1. Click the **Audio** tab at the bottom of the screen.
2. Click the **Add Bus** button.
3. Name the new bus.

Once you have the buses configured, do the following:
1. Copy the **dragonforge_sound** folder from the **addons** folder into your project's **addons** folder.
2. Go to **Project -> Project Settings...**
3. Select the **plugins** tab.
4. Check the **On checkbox** under **Enabled** for **Dragonforge Sound**
5. Press the **Close** button.

# Usage Instructions
This plugin manages sound for an entire game. It is intended to be easy to use, to centrally control sound resources, and reduce the memory usage of sound in the game.

## Sound

### SoundEffect Resource ![Sound Effect Icon](res://addons/dragonforge_sound/assets/icons/sound_effect.svg){:height="16px" width="16px"}
The sound effect resource is a way to track information through an attached **SFXProject** resource. It holds an **AudioStream** to play the sound effect, as well as an optional **Title** and **SFXProject** which can hold information like an **Album** does for a **Song**.

#### play_only_one_sound = true
If the `play_only_one_sound` boolean is set to `true`, and the `stream` is an **AudioStreamPlaylist**, then every time this sound effect is player, it will play the next sound in sequence. If the **AudioStreamPlaylist** has its `shuffle` value set to `true`, then the sound played will be chosen randomly each time.

This feature can be used if - for example - you have a list of bespoke hammer sounds and you want a random one played each time the player swings a hammer. Making each stream inside the playlist an AudioStreamRandomizer would allow you even greater variablility by creating a random pitch each time.

### SFXProject Resource ![Sound Effect Project Icon](res://addons/dragonforge_sound/assets/icons/crate.svg){:height="16px" width="16px"}
Like an **Album** this stores details about where the sound effect comes from. It contains the project's name, the creator and a link to the project. This is intended just to help developers track their sound effects. Especially useful if multiple people are working on the project. Unlike the **Album** resource, the plugin's code does nothing with this information.

### Volume
The plugin loads and saves volume levels. By using the appropriate functions, you can hook these calls up to your UI. For more information on how to do that, check out the Dragonforge Game Template.

### Sound Effects

### UI Sound Effects

### Ambient Sound Effects

### Dialogue

### Using Custom Buses

## Music
The **Music** system has been separated from the **Sound** system to facilitate easier coding. Music can play regular Godot **AudioStream**s, but can also use its own **Song** resources. You can use either or both when playing music.

### Song Resource ![Song Icon](res://addons/dragonforge_sound/assets/icons/song.svg){:height="16px" width="16px"}
An **Song** resource contains information about a song. It includes an **AudioStream** containing the music itself, as well as the song's **Title** and **Album**. When a **Song** resource is played using the **Music** plugin, the song and album information is sent out as a signal that anything in your game can look for. This can be used for an in-game music displays for example.

### Album Resource ![Album Icon](res://addons/dragonforge_sound/assets/icons/album.png){:height="16px" width="16px"}
An **Album** resource contains information about an album, and can be linked to multiple songs. It contains the album's **Artist**, **Title** and an optional hyperlink url to the album online. This is intended both to help developers keep track of where their music came from, as well as make it easy to display that information in game jams or small indie games where you want to help people find the resources you used and give some advertising and credit to the song creators.

# Copyright
To clarify the information below, all the icons can be freely used and even customized by following the links. The music and sound effects are all copyrighted and you must buy a copy from the copyright holder to be able to use the files anywhere else. The good news is all of the resources are priced reasonably, and you'll get a lot of other really great content by supporting these creators. Direct links have been provided to allow you to buy any files in which you have interest.

## Icons
Icons provided by [SVG Repo](https://www.svgrepo.com/).
Album and Song Icons by [Solar Icons](https://www.svgrepo.com/author/Solar%20Icons/) [CC Attribution License](https://www.svgrepo.com/page/licensing/#CC%20Attribution)
Explosion Icon by [Nagoshiashumari](https://www.svgrepo.com/author/nagoshiashumari/) [GPL License](https://www.svgrepo.com/page/licensing/#GPL)
Crate Icon by [SVG Repo](https://www.svgrepo.com/) [CCO License](https://www.svgrepo.com/page/licensing/#CC0)

## Music
This music was licensed and paid for by Dragonforge Development which does not have redistribution rights. You may not use this music in any other game, tutorial, or for any other purpose - even if it free - without the express permission of the copyright holder.
OST 1 - Clear Waters Copyright by pegonthetrack & ELVGames from [Epic Medieval Music Pack I](https://elvgames.itch.io/epic-medieval-music-pack)

## Sound Effects
These sound effects were licensed and paid for by Dragonforge Development which does not have redistribution rights. You may not use these sound effect files in any other game, tutorial, or for any other purpose - even if it free - without the express permission of the copyright holder.
Dig, Mine Medium Rock, and Wood Chop Loose sounds from [Harvesting Sound FX Pack](https://ovanisound.com/products/harvesting-sound-fx-pack) by [Ovani Sound](https://ovanisound.com/)
Field Day Loop from [Environmental Ambiences Sound FX Pack Vol. 1](https://ovanisound.com/products/environmental-ambiences-sound-fx-pack-vol-1) by [Ovani Sound](https://ovanisound.com/)
Blacksmith Anvil Ting sound from [Medieval Fantasy Sound FX Pack Vol. 4](https://ovanisound.com/products/medieval-fantasy-sound-fx-pack-vol-4) by [Ovani Sound](https://ovanisound.com/)
