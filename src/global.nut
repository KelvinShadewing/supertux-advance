/*================*\
| GLOBAL VARIABLES |
\*================*/

::gvMap <- 0
::gvGameMode <- 0
::game <- {
	score = 0,
	coins = 0,
	levelcoins = 0, //Total coins in the level
	lives = 0,
	health = 4,
	maxHealth = 4,
	tuxwep = 1,
	completed = [], //List of completed level names
	allcoins = [], //Levels that the player has gotten all enemies in
	allenemies = [], //Levels that the player has beaten all enemies in
	allsecrets = [] //Levels the player has found all secrets in
}
::gvPlayer <- 0; //Pointer to player actor
/*\
 # The game does not actually have
 # limited lives. instead, game.lives
 # tracks how many times the player
 # has died in total.
\*/

::strDifficulty <- [
	"Easy",
	"Normal",
	"Hard"
]

::config <- {
	difficulty = 0,
	key = {
		up = k_up,
		down = k_down,
		left = k_left,
		right = k_right,
		jump = k_z,
		shoot = k_x,
		run = k_lshift,
		sneak = k_lctrl
		pause = k_enter
	},
	playerchar = 0
}

::camx <- 0
::camy <- 0

//Debug variabls
::gvFPS <- 0
