/*================*\
| GLOBAL VARIABLES |
\*================*/

::gvVersion <- "0.0.18"
::gvMap <- 0
::gvGameMode <- 0
::gvQuit <- false
::game <- { //Globals stored in this table will be saved
	difficulty = 0
	file = 0
	coins = 0
	levelCoins = 0
	maxCoins = 0 //Total coins in the level
	redcoins = 0
	levelredcoins = 0
	maxredcoins = 0
	secrets = 0
	enemies = 0
	health = 12
	maxHealth = 12
	weapon = 0
	maxEnergy = 0
	fireBonus = 0
	iceBonus = 0
	airBonus = 0
	earthBonus = 0
	subitem = 0
	completed = {} //List of completed level names
	allCoins = {} //Levels that the player has gotten all enemies in
	allEnemies = {} //Levels that the player has beaten all enemies in
	allSecrets = {} //Levels the player has found all secrets in
	bestTime = {} //Fastest time for a level
	igt = 0 //Global IGT, which increments throughout the game's runtime
	colorswitch = [
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false
	] //Color blocks activated by respective switches
	characters = { //List of unlocked characters
		Tux = ["sprTuxOverworld", "sprTuxDoll", "sprTux", [40, 41]]
		//Konqi = ["sprKonqiOverworld", "sprKonqiDoll", "sprKonqi", [8, 9]]
	}
	secretOrbs = [
		false,
		false,
		false,
		false,
		false,
		false,
		false,
		false
	]
	friends = {} //List of rescued friend characters
	playerChar = "Tux" //Current player character
	world = "res/map/overworld-0.json"
	owx = 0
	owy = 0
	owd = 0
	check = false //If a checkpoint has been activated
	chx = 0
	chy = 0
	berries = 0
	path = "res/map/"
	canres = false //If the player can respawn
	bossHealth = 0
}
::gameDefault <- clone(game)
::gvPlayer <- false; //Pointer to player actor
::gvBoss <- false; //Pointer to boss actor
/*\
 # When characters are unlocked, they will
 # be added to game.characters. Mods can
 # push a similar array to make their
 # custom characters playable.
\*/

::strDifficulty <- []

::config <- {
	key = {
		up = k_up
		down = k_down
		left = k_left
		right = k_right
		jump = k_z
		shoot = k_x
		run = k_lshift
		sneak = k_lctrl
		pause = k_escape
		swap = k_a
		accept = k_enter
		leftPeek = k_home
		rightPeek = k_end
		downPeek = k_pagedown
		upPeek = k_pageup
	}
	joy = {
		jump = 0
		shoot = 2
		run = 4
		sneak = 5
		pause = 7
		swap = 3
		accept = 0
		leftPeek = -1
		rightPeek = -1
		downPeek = -1
		upPeek = -1
	}
	autorun = false
	stickspeed = true
	playerChar = 0
	lang = "en"
	showleveligt = false
	showglobaligt = false
	light = true
	showcursor = true
	usefilter = false
	soundenabled = true
	musicenabled = true
}

::contribDidRun <- {}

::gvScreen <- 0
::gvPlayScreen <- 0
::camx <- 0
::camy <- 0
::camxprev <- 0
::camyprev <- 0
::gvTextW <- 0

//Debug variabls
::gvFPS <- 0

//Misc
::gvWeather <- 0
::gvIGT <- 0 //In-game time for the current level
::gvDoIGT <- true
::gvWarning <- 360.0
::gvCamTarget <- false

//Temporary items
::gvKeyCopper <- false
::gvKeySilver <- false
::gvKeyGold <- false
::gvKeyMythril <- false
