/*================*\
| GLOBAL VARIABLES |
\*================*/

::gvVersion <- "0.2.42 (UNSTABLE)"
::gvMap <- 0
::gvGameMode <- 0
::gvQuit <- false
::gvNetPlay <- false

::createNewGameObject <- function () {
	return { //Globals stored in this table will be saved
		difficulty = 0
		file = -1
		coins = 0
		levelCoins = 0
		maxCoins = 0 //Total coins in the level
		redCoins = 0
		maxRedCoins = 0
		secrets = 0
		maxSecrets = 0
		enemies = 0
		maxEnemies = 0
		maxHealth = 12
		energyBonus = 0
		staminaBonus = 0
		completed = {} //List of completed level names
		unblocked = {} //List of unblocked obstacles on map
		allCoins = {} //Levels that the player has gotten all enemies in
		allEnemies = {} //Levels that the player has beaten all enemies in
		allSecrets = {} //Levels the player has found all secrets in
		bestTime = {} //Fastest time for a level
		bestCoins = {} //Most coins found per level
		bestEnemies = {} //Most enemies defeated per level
		bestSecrets = {} //Most secrets found per level
		bestStrokes = {} //For Neverball
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
		turnOffBlocks = false,
		characters = { //List of unlocked characters
			Tux = true
			Penny = true
			Lutris = true
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
		levelEvents = {} //Events that have occured in individual levels
		friends = {} //List of rescued friend characters
		playerChar = "Tux" //Current player character
		playerChar2 = 0
		world = "res/map/overworld-0.json"
		owx = 0
		owy = 0
		owd = 0
		check = false //If a checkpoint has been activated
		chx = 0
		chy = 0
		path = "res/map/"
		bossHealth = 0
		ps = {
			health = 0
			weapon = "normal"
			subitem = 0
			canres = false
			berries = 0
			maxEnergy = 4
			maxStamina = 4
			energy = 4
			stamina = 4
			abilities = {}
		}
		ps2 = {
			health = 0
			weapon = "normal"
			subitem = 0
			canres = false
			berries = 0
			maxEnergy = 4
			maxStamina = 4
			energy = 4
			stamina = 4
			abilities = {}
		}
		state = {}
		hasSulphur = 0
	}
}

::gvCharacters <- {
	Tux = {
		name = "Tux the Penguin"
		shortname = "Tux"
		over = "sprTuxOverworld"
		doll = "sprTuxDoll"
		normal = "sprTux"
		fire = "sprTuxFire"
		ice = "sprTuxIce"
		air = "sprTuxAir"
		earth = "sprTuxEarth"
		shock = "sprTuxShock"
		water = "sprTuxWater"
		light = "sprTux"
		dark = "sprTux"
		pick = [40, 41]
	}
	Penny = {
		name = "Penny the Penguin"
		shortname = "Penny"
		over = "sprPennyOverworld"
		doll = "sprPennyDoll"
		normal = "sprPenny"
		fire = "sprPennyFire"
		ice = "sprPennyIce"
		air = "sprPennyAir"
		earth = "sprPennyEarth"
		shock = "sprPenny"
		water = "sprPenny"
		light = "sprPenny"
		dark = "sprPenny"
		pick = [40, 41]
	}
	Lutris = {
		name = "Lutris the Otter"
		shortname = "Lutris"
		over = "sprLutrisOverworld"
		doll = "sprLutrisDoll"
		normal = "sprLutris"
		fire = "sprLutris"
		ice = "sprLutris"
		air = "sprLutris"
		earth = "sprLutris"
		shock = "sprLutris"
		water = "sprLutris"
		light = "sprLutris"
		dark = "sprLutris"
		pick = [40, 41]
	}
	Konqi = {
		name = "Konqi the Dragon"
		shortname = "Konqi"
		over = "sprKonqiOverworld"
		doll =  "sprKonqiDoll"
		normal = "sprKonqi"
		fire = "sprKonqiFire"
		ice = "sprKonqiIce"
		air = "sprKonqiAir"
		earth = "sprKonqiEarth"
		shock = "sprKonqi"
		water = "sprKonqi"
		light = "sprKonqi"
		dark = "sprKonqi"
		pick = [8, 52]
	}
	Katie = {
		name = "Katie the Dragon"
		shortname = "Katie"
		over = "sprKatieOverworld"
		doll =  "sprKatieDoll"
		normal = "sprKatie"
		fire = "sprKatieFire"
		ice = "sprKatieIce"
		air = "sprKatieAir"
		earth = "sprKatieEarth"
		shock = "sprKatie"
		water = "sprKatie"
		light = "sprKatie"
		dark = "sprKatie"
		pick = [8, 52]
	}
	Midi = {
		name = "Midi Waffle"
		shortname = "Midi"
		over = "sprMidiOverworld"
		doll = "sprMidiDoll"
		normal = "sprMidi"
		fire = "sprMidi"
		ice = "sprMidi"
		air = "sprMidi"
		earth = "sprMidi"
		shock = "sprMidi"
		water = "sprMidi"
		light = "sprMidi"
		dark = "sprMidi"
		pick = [177, 239]
	}
	Kiki = {
		name = "Kiki the Cyber Squirrel"
		shortname = "Kiki"
		over = "sprKikiOverworld"
		doll = "sprKikiDoll"
		normal = "sprKiki"
		fire = "sprKiki"
		ice = "sprKiki"
		air = "sprKiki"
		earth = "sprKiki"
		shock = "sprKiki"
		water = "sprKiki"
		light = "sprKiki"
		dark = "sprKiki"
		pick = [177, 239]
	}
	Surge = {
		name = "Surge the Rabbit"
		shortname = "Surge"
		over = "sprSurgeOverworld"
		doll = "sprSurgeDoll"
		normal = "sprSurge"
		fire = "sprSurge"
		ice = "sprSurge"
		air = "sprSurge"
		earth = "sprSurge"
		shock = "sprSurge"
		water = "sprSurge"
		light = "sprSurge"
		dark = "sprSurge"
		pick = [48, 51]
	}
	Dashie = {
		name = "Dashie the Cyber Rabbit"
		shortname = "Dashie"
		over = "sprDashieOverworld"
		doll = "sprDashieDoll"
		normal = "sprDashie"
		fire = "sprDashie"
		ice = "sprDashie"
		air = "sprDashie"
		earth = "sprDashie"
		shock = "sprDashie"
		water = "sprDashie"
		light = "sprDashie"
		dark = "sprDashie"
		pick = [48, 51]
	}
	Neverball = {
		name = "Never Ball"
		shortname = "Never"
		over = "sprNeverball"
		doll = "sprNeverball"
		normal = "sprNeverball"
		fire = "sprNeverball"
		ice = "sprNeverball"
		air = "sprNeverball"
		earth = "sprNeverball"
		shock = "sprNeverball"
		water = "sprNeverball"
		light = "sprNeverball"
		dark = "sprNeverball"
		pick = [0, 0]
	}
}

::game <- createNewGameObject()
::gvPlayer <- false //Pointer to player actor
::gvPlayer2 <- false //Pointer to second player
::gvNumPlayers <- 0 //Number of players at start of level
::gvBoss <- false //Pointer to boss actor
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
		spec1 = k_c
		spec2 = k_lshift
		pause = k_escape
		swap = k_a
		accept = k_enter
		leftPeek = k_home
		rightPeek = k_end
		downPeek = k_pagedown
		upPeek = k_pageup
	}
	joy = {
		index = 0
		jump = 0
		shoot = 2
		spec1 = 4
		spec2 = 5
		pause = 7
		swap = 3
		accept = 0
		leftPeek = -1
		rightPeek = -1
		downPeek = -1
		upPeek = -1
		xPeek = -1
		yPeek = -1
	}
	joy2 = {
		index = 0
		jump = 0
		shoot = 2
		spec1 = 4
		spec2 = 5
		pause = 7
		swap = 3
		accept = 0
		leftPeek = -1
		rightPeek = -1
		downPeek = -1
		upPeek = -1
		xPeek = -1
		yPeek = -1
	}
	joymode = "XBox"
	autorun = false
	stickspeed = false
	stickactive = true
	stickcam = true
	lang = "en"
	showleveligt = false
	showglobaligt = false
	light = true
	showcursor = true
	usefilter = false
	soundVolume = 64
	musicVolume = 64
	fullscreen = false
	lookAhead = false
	weather = true
	splitlock = false
	//Accessibility options
	nearbars = false //Health/energy bars that follow the player
	showkeys = false
	completion = false
	useBeam = false
	bigItems = false
	useOutlines = false
	showTF = true
	aspect = 0
}

::contribDidRun <- {}

//Screen related variables
::gvScreen <- 0
::gvPlayScreen <- 0
::gvPlayScreen2 <- 0
::gvTempScreen <- 0
::gvTextW <- 0
::gvScreenW <- 0
::gvScreenH <- 0
::gvScreen2W <- 0
::gvScreen2H <- 0
::gvScreenGhost <- 0

//Debug variabls
::gvFPS <- 0

//Misc
::gvWeather <- 0
::gvIGT <- 0 //In-game time for the current level
::gvDoIGT <- true
::gvWarning <- 360.0
::gvFadeTime <- 0
::gvExitTimer <- 0.0
::gvExitSide <- 0

//Temporary items
::gvKeyCopper <- false
::gvKeySilver <- false
::gvKeyGold <- false
::gvKeyMythril <- false
::enWeapons <- {
	normal = 0
	fire = 1
	ice = 2
	air = 3
	earth = 4
	shock = 5
	water = 6
	light = 7
	dark = 8
	toxic = 9
}

::myTarget <- null