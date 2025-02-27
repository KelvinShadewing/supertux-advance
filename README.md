# SuperTux Advance

## Intro

SuperTux Advance is a fan game of SuperTux written in Squirrel using [Brux GDK](https://codeberg.org/KelvinShadewing/brux-gdk). The name comes from the graphical style, which uses a lower resolution display and a sprite style similar to Sonic Advance. Gameplay is not a 1 to 1 recreation of SuperTux, nor does it aim to be. It's meant to be a more fast-paced action platformer than a Mario clone. While the gameplay is designed with speed running in mind, it is not an essential skill; the game can be played and beaten casually.

Some assets from SuperTux will be used, with graphics being remixed to match the game's visual style.

## Community

We have a Discord server! https://discord.gg/bcyC2Q6a9x

## Story

After being humiliated by Tux on the tracks, Nolok decides to get his revenge by kidnapping lots of his friends at once! Tux sets out once more, hoping to finally put an end to Nolok's schemes, only this time, he won't be doing it alone.

## Installation Destructions 
<!-- Destructions is not a typo of instructions: https://www.youtube.com/shorts/UeHp-DEkJqo -->

To open the game in the Brux GDK engine for development or contributions, follow the [Brux GDK installation instructions](https://codeberg.org/KelvinShadewing/brux-gdk), then run `game.brx` using Brux.

To download and play SuperTux Advance, download and unzip the [latest release from itch.io](https://kelvinshadewing.itch.io/supertux-advance). If on Windows, run the excecutable located at `/sta-0.2.48/sta/sta.exe` by double clicking it. If on linux, navigate to the `sta` subdirectory (e.g., `cd ~/Downloads/sta-0.2.48/sta`), install SDL2 (e.g., `sudo apt install libsdl2*`), then run the `sta` file (i.e., `./sta`).

## Controls

You can rebind the controls from the Options menu found on the title screen.

* Movement: arrow keys
* Jump: Z
* Shoot: X
* Slide: down (while running, Tux only)
* Special 1: C
* Special 2: Left Shift

## Tips

* You gain more speed from sliding off a drop than down a hill. Falling speed is translated into horizontal momentum upon landing. Use this to maximize your speed.
* Practice wall jumping. Press jump against the wall in the air. This isn't just helpful for navigating levels, it can save you if you fall into a pit.
* Fireballs have long range, but a slow rate of fire. Use them tactically; don't rely on them for up-close combat. That's best left to jumping and sliding.
* Muffins found in [?] boxes will restore health. Blueberry restores 1 health points, and strawberry restores 4 health. Moldy green muffins will take health from you.
* On easy mode, you'll receive an extra life point after each boss. You don't get such boons on normal mode; you'll have to make do with the starting amount. Hard and Super prevent healing, so be careful!
* Tux's fireballs won't be lost if you get hurt. You can also aim them up and down.
* You can swim in all directions, but fireballs will work differently in water. Head for the surface if you get into trouble.
* If you're going for a speed run, slide just before leaving an edge for a small boost, then jump to preserve the momentum. There's no friction in the air, so keep off the ground as much as you can!
* Blueberry muffins will not overwrite your sub item box if it contains a strawberry muffin.
* Green boxes with a picture of the item they produce will only do so if you have coins. Be careful, as there are no buy-backs!

## FAQ

*Q:* The game crashed. The log says a function or identifier wasn't defined.

**A:** The game may need a newer version of Brux GDK. Download the nightly build from the link in the installation instructions.

*Q:* Does this game have Mac support?

**A:** Not at the time of writing this, unfortunately.

*Q:* How do I deal with those spiked orbs in the second level?

**A:** Ouchins are invincible. Think of them like Gordos from Kirby.

*Q:* I found a glitch!

**A:** Great job! Report it in the "Issues" tab of the GitHub Repository! (Make sure you're playing the most recent version, too!)

*Q:* How do I know how long I can use the flying powerup before I stop flying?

**A:** There's a bar in the top left corner of the screen that shows how long you can fly.

*Q:* Why are there mods? Isn't this game open source?

**A:** Yes, and you're free to make whatever edits you want. Mods just make it easier to share your changes and allow others to remove those changes without having to manually pick them out of the game's source.

*Q:* Who is Midi?

**A:** Midi Waffle is the main character of another game I'm working on, Kyrodian Legends. He's also the mascot for Brux GDK!
