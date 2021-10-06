# SuperTux Advance

## Intro

SupterTux Advance is a fan game of SuperTux written in Squirrel using [Brux GDK](https://github.com/kelvinshadewing/brux-gdk). The name comes from the graphical style, which uses a lower resolution display and a sprite style similar to Sonic Advance. Gameplay is not a 1 to 1 recreation of SuperTux, nor does it aim to be. It's meant to be a more fast-paced action platformer than a Mario clone. While the gameplay is designed with speedrunning in mind, it is not an essential skill; the game can be played and beaten casually.

Some assets from SuperTux will be used, with graphics being remixed to match the game's visual style.

## Community

We have a Discord server! https://discord.gg/PJsSmND5GP

## Story

Capturing Gnu was only the beginning of Nolok's plan. While Tux and his friends ran the Grand Prix to challenge Nolok for Gnu's life, Nolok was busy setting traps for Tux's other friends. Now he holds them hostage while he works on his ultimate weapon, the Sliva Cannon! Tux must storm each of Nolok's forts and rescue his friends. He may even make some new friends along the way. Can Tux defeat Nolok in time to end the Third World War? And who the heck is Kooh?! One of these questions will be answered in SuperTux Advance!

## Installation Destructions

Follow the install instructions for [Brux GDK](https://github.com/kelvinshadewing/brux-gdk), then run `tux.brx` with Brux.

## Controls

The controls menu hasn't been made yet. For now, remapping can be done in `global.nut`.

* Movement: arrow keys
* Jump: Z
* Shoot: X
* Run: left shift
* Sneak: left control
* Slide: down (while running)

## Tips

* You gain more speed from sliding off a drop than down a hill. Falling speed is translated into horizontal momentum upon landing. Use this to maximize your speed.
* Practice wall jumping. Hold jump against the wall and press away from it. This isn't just helpful at navigating levels, it can save you if you fall into a pit.
* Fireballs have long range, but a slow rate of fire. Use them tactically; don't rely on them for up-close combat. That's best left to jumping and sliding.
* Muffins found in [?] boxes will restore health. Blueberry restores 1 health points, and strawberry restores 4 health. Moldy green muffins will take health from you.
* On normal and easy mode, you'll recieve an extra life point after each boss. You don't get such boons on hard mode; you'll have to make do with the starting amount.
* Tux's fireballs won't be lost if you get hurt. You can also aim them up and down.
* You can swim in all directions, but fireballs will not work in water. Head for the surface if you get into trouble.
* If you're going for a speed run, slide just before leaving an edge for a small boost, then jump to preserve the momentum. There's no friction in the air, so keep off the ground as much as you can!

## FAQ

Q: The game crashed. The log says a function or identifier wasn't defined.

A: The game may need a newer version of Brux GDK. Download the nightly build from the link in the installation destructions.