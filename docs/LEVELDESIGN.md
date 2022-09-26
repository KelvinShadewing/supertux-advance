# Level Design Guide

## Getting started

If you want to make your own levels, you should install [Tiled Map Editor](https://mapeditor.org). This is the editor used to make levels in SuperTux Advance. Levels should be saved in JSON format.

Map files are stored in `res/map` from the game's directory. Start by opening `template.json` in Tiled and then using "Save As" in the File menu to save it under a new name.

If you ever accidentally overwrite your template file, save a copy under a new name, then go into the template and go to "Map > Resize Map...". Click on "Remove objects outside map" and set both dimensions to 1, then resize it back up to whatever you want. This will return it to an empty map.

If you want to output minimized files, ones without the extra whitespace to make the file readable in a text editor, go to "Edit > Preferences... > General > Export Options" and click "Minimize output". Then use "File > Export" to save the minimized file.

You can sign your level by adding an `author` property to the map. Maps made by multiple designers should have their names in an alphabetically sorted, comma separated list.

## Start Code

You can have the level run a piece of code once it's done loading. This code will be run after all actors have been created as well. You can do this by going to "Map > Map properties". This will set the Properties panel to focus on the map itself. From here, create a custom property called `code`. By clicking the "..." button on the right side of the text entry field, you can open up a multi-line editor for easier coding.

## Layers

SuperTux Advance uses four object layers and three tile layers in its levels. Object names are used to make special properties visible from within the editor itself.

The object layers include:

* **trigger** - Areas that execute code while Tux is in them. The code is written in the object's name.

  Here are some example pieces of code you can put in. Bear in mind, though, that literally any Squirrel code may be used, and it will be executed every frame that has the player colliding with the trigger block.

  `gvPlayer.hidden = true` Makes the player invisible. They will automatically become visible again when they leave the trigger zone.

  `pipeFunnel()` This makes the player move towards the middle of the zone when down is held. This is to make pipes easier to enter. Zones with this code are best placed in blocks directly above pipes.

  `playerTeleport( x, y )` This makes the player teleport to the given coordinates `x` and `y`. While you can also change the player's location using the `x` and `y` variables found in `gvPlayer`, this function will also snap the camera, instead of leaving it to move to the player's new location.

  `drawBG = bg` Changes the background. Look in `bg.nut` and use the names of the funcitons found there.

  `songPlay(song)` Sets the level music. Replace `song` with one of the songs found in `assets.nut`.

  `game.maxCoins = x` Set the number of coins to get the level's coin achievement.

* **water** - Zones full of water. Because water is dynamically-sized as well, it uses recangles.

* **actor** - Actors are made using tile objects who's image matches the type of actor they create. Infoblocks and comment nodes must have names defined that match a respective entry in the language file. Actors that take other special properties will also use the name.

  Objects created on the actor layer are added to the `mapActor` table, using the built-in Tiled object ID. They can then be directly addressed using the format `actor[mapActor[id]]`, with `id` being the object ID defined by Tiled.

  Some actors require shapes to be defined within the map. For these, shape objects are used with the name set to the actor's class name. Arguments to be passed to the object follow the name, and are separated by commas without spaces.

* **secret** - This layer makes a special type of trigger zone that, when touched, will cause the corresponding tiles from the secret tile layer to disappear.

The tile layers include:

* **fg** - Foreground tiles. These are drawn on top of actors and water.

* **mg** - Midground tiles. Draw behind actors but above background. Used for extra decoration.

* **bg** - Background tiles. Drawn behind actors.

* **solid** - Pink blocks define solid geometry for the level. The green blocks are used to make ladders.

* **secret** - The tiles that appear over the `fg` layer and disappear when their respective secret trigger is touched. Without a secret zone laid over them, they will not be drawn at all. If you want tiles that are always above the player, use `fg`.

## Level Size

Level dimensions should have an area around 320x20 tiles. Levels don't need to be purely horizontal, but should have a similar area so that they aren't too long. I have no yet added support for multiple checkpoints, but it is planned. Still, levels should be short, since the achievements for them require it all to be done in a single pass.

While there are no intentionally-defined limits to map size, making maps above 5MB runs the risk of causing a segmentation fault. The cause of this issue is currently unkown, however, at that size with minimized output, you could fit all of Zebes from Super Metroid, which is certainly not needed for this game.

## NPCs

The NPC actor (bald human in the map editor) has several mandatory arguments that must be defined in this order: sprite, flip mode, talk function, and lines. The sprite is the name of the sprite to be used as its variable is defined in `assets.nut`. Flip mode 0 will use different frames, and 1 will make the sprite actually flip to follow the player. The following functions exist for talk modes:

* `say` - Makes the NPC say each of their lines in the order they are defined.

* `sayRand` - Will pick a random line from the following arguments to say each time the character is spoken to. Can be used with just one line if an NPC should say the same thing every time.

* `sayChar` - Says a different line for each playable character. Requires an entry for Tux, Konqi, Midi, and default, in that order. Default is used for modded characters.

Lines are all arguments following talk mode. There can be any number depending on the function being used. They should be the name of entries in the language file's `npc` field.

## Other Notes

Player dolls are items that revive you once you die, without having to go back to a checkpoint.

You can have multiple checkpoints in a level. Use this to your advantage if you want to create levels with multiple paths. Remember that everything resets when the player dies, so, for instance, enemies that are necessary to progress, like hopping on them to cross a gap, will respawn upon a new life. Be sure not to put enemies too close to a checkpoint.

External tilesets are not supported; you will have to embed tilesets. I'll work on supporting external tilesets in the future.

# Contributor Worlds

STA has a system that allows custom worlds to be created without having to add them to the main game. With a little creative scripting and some custom graphics, it is even possible to create an entirely new game! Information will be added to this section to help with the creation of contributor worlds.

## The Folder

The first thing you will need is your own folder for your world. It should be given a unique name to prevent conflicts with other worlds. The folder's name does not determine how it will appear in the game, so feel free to include any identifying information you need. Once you have decided on a name, you will need to add the following files and subfolders. Do not worry about the contents of these files/folders just yet; leave them empty for now.

```
contrib/
-> your-world-folder/
  -> gfx/
    -> (graphic files)
  -> info.json
  -> init.nut
  -> script.nut
  -> text.json
  -> world.json
  -> (level files)
```

Now we will go over each of these files.

`gfx` is the folder for your custom graphics. It is essential that your world's tileset images are stored here, as this is where the tilemap engine will search for them. You should try to give your tilesets unique names as well to prevent conflicts

`info.json` tells the game important information about your game so it can be added to the list. It should be structured thus:

```squirrel
{
  name : "Your World's Name",
  worldmap : "world.json"
}
```

Notice the worldmap needs to be defined. This is so that your world can actually have multiple overworld files to switch between, just like the base game does.

`init.nut` runs custom scripts as soon as STA is launched. There shouldn't be too much here, usually just a print statement to indicate your world was found successfully, and functions to add the world to various lists.

`script.nut` is where your world's important code will go. This includes things like loading the sprites your world needs, defining custom classes, overriding the player character, and anything else it needs to set up a new run. This script will be run the first time the world is loaded since the application was launched, and will not be run again until you close STA and reopen it.

`text.json` is your world's language file. You'll define things like level names, NPC dialog, and any other text that appears onscreen. Additional language files can be created alongside this file for users to create translations. Consult the language files in `lang/` for examples.

## Achievements

Your contrib world can have its own custom achievement system. To create achievements, you will need to define a function that checks the game state and add it to a list. In your `init.nut` script, you will define this function and add to to the `gvAchievements` table. For example:

```squirrel
gvAchievements.myAchievement <- function() {
  if(game.path != "contrib/myworld") return false
  return (achievementCondition == "whatever you're checking")
}
```

It is important to make sure your achievement checks that the game is currently running your world, otherwise it could be accidentally triggered by other worlds or the main game.

Next, you will need to define text for the achievement. This will go in your `text.json` file under the fields `achi-name` for the name that shows on the popup, and `achi-desc` for the text in the achievement menu.

```json
{
  "achi-name" : {
    "myAchievement" : "My Achievement"
  },

  "achi-desc" : {
    "myAchievement" : "Do the thing!"
  }
}
```

## Time Attack

Time Attack mode allows players to play through a world with each level being run consecutively without using the overworld map between levels. For this, you will need to add your world to the Time Attack list, but you will also need to link your levels together in the order they are intended to be played.

In your `init.nut` script, add the following function:

```squirrel
addTimeAttackWorld("My World", "folder-name", "first-level-without-extension")
```

The first argument is the name of your world as it appears in the TA menu. This can be different from the actual world's name if you want to, for example, create different TA routes or if your contrib world has separate islands. The second defines which contrib folder the world is in. Lastly, the filename for your TA's first level, without the `.json` extension.

Then, in your levels, you will need to add arguments to the `endGoal()` call in your end of level trigger spaces. The argument you will add is the name of the next level in the sequence, again without `.json`.

The final level of your TA should use the trigger `endGoal("timeattack-win")` to take the player to the time attack results screen.