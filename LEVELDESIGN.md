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

* **bg** - Background tiles. Drawn behind actors.

* **solid** - Pink blocks define solid geometry for the level. The green blocks are used to make ladders.