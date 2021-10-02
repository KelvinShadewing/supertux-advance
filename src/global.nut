/*================*\
| GLOBAL VARIABLES |
\*================*/

::gvMap <- 0
::gvGameMode <- 0
::gvQuit <- false
::game <- {
	score = 0
	coins = 0
	levelcoins = 0
	maxcoins = 0 //Total coins in the level
	secrets = 0
	enemies = 0
	lives = 0
	health = 4
	maxHealth = 4
	weapon = 0
	completed = {} //List of completed level names
	allcoins = {} //Levels that the player has gotten all enemies in
	allenemies = {} //Levels that the player has beaten all enemies in
	allsecrets = {} //Levels the player has found all secrets in
	characters = { //List of unlocked characters
		Tux = sprTuxOverworld
	}
	playerchar = "Tux" //Current player character
	world = "res/overworld-0.json"
	owx = 0
	owy = 0
	owd = 0
	check = false //If a checkpoint has been activated
	chx = 0
	chy = 0
}
::gameDefault <- clone(game)
::gvPlayer <- 0; //Pointer to player actor
/*\
 # The game does not actually have
 # limited lives. instead, game.lives
 # tracks how many times the player
 # has died in total.
 #
 # When characters are unlocked, they will
 # be added to game.characters. Mods can
 # push a similar array to make their
 # custom characters playable.
\*/

::strDifficulty <- []

::config <- {
	difficulty = 0
	key = {
		up = k_up
		down = k_down
		left = k_left
		right = k_right
		jump = k_z
		shoot = k_x
		run = k_lshift
		sneak = k_lctrl
		pause = k_enter
	},
	joy = {
		jump = 0
		shoot = 2
		run = 4
		sneak = 5
		pause = 7
	}
	playerchar = 0
	lang = "en"
}

::camx <- 0
::camy <- 0

//Debug variabls
::gvFPS <- 0