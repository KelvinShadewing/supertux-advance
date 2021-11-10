# Level Design Guide

## Layers

SuperTux Advance uses four object layers and three tile layers in its levels. Object names are used to make special properties visible from within the editor itself.

The object layers include:

* **trigger** - Areas that execute code while Tux is in them. The code is written in the object's name.

* **water** - Zones full of water. Because water is dynamically-sized as well, it uses recangles.

* **actor** - Actors are made using tile objects who's image matches the type of actor they create. Infoblocks and comment nodes must have names defined that match a respective entry in the language file. Actors that take other special properties will also use the name.

* **platform** - Currently being reworked. Moving platforms will use a rectangle to define how far they can move, and a number in their name slot to indicate how many tiles wide the platform will be.

The tile layers include:

* **fg** - Foreground tiles. These are drawn on top of actors and water.

* **mg** - Midground tiles. Draw behind actors but above background. Used for extra decoration.

* **bg** - Background tiles. Drawn behind actors.

* **solid** - Pink blocks define solid geometry for the level. The green blocks are used to make ladders.

## Level Size

Level dimensions should have an area around 320x20 tiles. Levels don't need to be purely horizontal, but should have a similar area so that they aren't too long. I have no yet added support for multiple checkpoints, but it is planned. Still, levels should be short, since the achievements for them require it all to be done in a single pass.

## NPCs

The NPC actor (bald human in the map editor) has several mandatory arguments that must be defined in this order: sprite, flip mode, talk function, and lines. The sprite is the name of the sprite to be used as its variable is defined in `assets.nut`. Flip mode 0 will use different frames, and 1 will make the sprite actually flip to follow the player. The following functions exist for talk modes:

* `sayRand` - Will pick a random line from the following arguments to say each time the character is spoken to. Can be used with just one line if an NPC should say the same thing every time.

* `sayChar` - Says a different line for each playable character. Requires an entry for Tux, Konqi, Midi, and default, in that order.

Lines are all arguments following talk mode. There can be any number depending on the function being used. They should be the name of entries in the language file's `npc` field.