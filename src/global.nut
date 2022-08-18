/*================*\
| GLOBAL VARIABLES |
\*================*/

::gvVersion <- "0.1.3 UNSTABLE"
::gvMap <- 0
::gvGameMode <- 0
::gvQuit <- false

::createNewGameObject <- function () {
	return { //Globals stored in this table will be saved
		difficulty = 0
		file = 0
		coins = 0
		levelCoins = 0
		maxCoins = 0 //Total coins in the level
		redCoins = 0
		maxRedCoins = 0
		secrets = 0
		maxSecrets = 0
		enemies = 0
		maxEnemies = 0
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
		bestCoins = {} //Most coins found per level
		bestEnemies = {} //Most enemies defeated per level
		bestSecrets = {} //Most secrets found per level
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
}

::game <- createNewGameObject()
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
	soundVolume = 64
	musicVolume = 64
	fullscreen = false
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
::gvFadeTime <- 0

//Temporary items
::gvKeyCopper <- false
::gvKeySilver <- false
::gvKeyGold <- false
::gvKeyMythril <- false