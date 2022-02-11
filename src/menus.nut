///////////
// MENUS //
///////////

::menu <- []
::cursor <- 0
::cursorOffset <- 0
const menuMax = 7 //Maximum number of slots that can be shown on screen
const fontH = 14
::textMenu <- function(){
	//If no menu is loaded
	if(menu == []) return

	//Draw options
	//The number
	if(menu.len() > menuMax) for(local i = cursorOffset; i < cursorOffset + menuMax; i++) {
		if(cursor == i) {
			drawSprite(font2, 97, (screenW() / 2) - (menu[i].name().len() * 4) - 16, screenH() - 8 - (menuMax * fontH) + ((i - cursorOffset) * fontH))
			drawSprite(font2, 102, (screenW() / 2) + (menu[i].name().len() * 4) + 7, screenH() - 8 - (menuMax * fontH) + ((i - cursorOffset) * fontH))
		}
		drawText(font2, (screenW() / 2) - (menu[i].name().len() * 4), screenH() - 8 - (menuMax * fontH) + ((i - cursorOffset) * fontH), menu[i].name())
	}
	else for(local i = 0; i < menu.len(); i++) {
		if(cursor == i) {
			drawSprite(font2, 97, (screenW() / 2) - (menu[i].name().len() * 4) - 16, screenH() - 8 - (menu.len() * fontH) + (i * fontH))
			drawSprite(font2, 102, (screenW() / 2) + (menu[i].name().len() * 4) + 7, screenH() - 8 - (menu.len() * fontH) + (i * fontH))
		}
		drawText(font2, (screenW() / 2) - (menu[i].name().len() * 4), screenH() - 8 - (menu.len() * fontH) + (i * fontH), menu[i].name())
	}

	//Keyboard input
	if(getcon("down", "press")) {
		cursor++
		if(cursor >= cursorOffset + menuMax) cursorOffset++
		if(cursor >= menu.len()) {
			cursor = 0
			cursorOffset = 0
		}
	}

	if(getcon("up", "press")) {
		cursor--
		if(cursor < cursorOffset) cursorOffset--
		if(cursor < 0) {
			cursor = menu.len() - 1
			if(menu.len() > menuMax) cursorOffset = menu.len() - menuMax
		}
	}

	if(getcon("jump", "press") || getcon("accept", "press")) {
		menu[cursor].func()
	}

	if(getcon("pause", "press")) {
		for(local i = 0; i < menu.len(); i++) {
				if(menu[i].rawin("back")) {
					menu[i]["back"]()
					break
				}
		}
	}
}

//Names are stored as functions because some need to change each time
//they're brought up again.
::meMain <- [
	{
		name = function() { return gvLangObj["main-menu"]["new"] },
		func = function() { cursor = 0; menu = meDifficulty }
	},
	{
		name = function() { return gvLangObj["main-menu"]["load"] },
		func = function() { cursor = 0; selectLoadGame() }
	},
	{
		name = function() { return gvLangObj["main-menu"]["contrib-levels"] },
		func = function() { cursor = 0; selectContrib(); }
	}
	{
		name = function() { return gvLangObj["main-menu"]["options"] },
		func = function() { cursor = 0; menu = meOptions }
	},
    	{
		name = function() { return gvLangObj["main-menu"]["credits"] },
		func = function() { cursor = 0; startCredits(); }
    	}	
	{
		name = function() { return gvLangObj["main-menu"]["quit"] },
		func = function() { gvQuit = 1 }
	}
]

::mePausePlay <- [
	{
		name = function() { return gvLangObj["pause-menu"]["continue"]},
		func = function() { gvGameMode = gmPlay }
	},
	{
		name = function() { return gvLangObj["pause-menu"]["restart"]},
		func = function() { gvIGT = 0; game.check = false; startPlay(gvMap.file) }
	}
	{
		name = function() { return gvLangObj["pause-menu"]["quit-level"]},
		func = function() { startOverworld(game.world); cursor = 0 }
	}
]

::mePauseOver <- [
	{
		name = function() { return gvLangObj["pause-menu"]["continue"]},
		func = function() { gvGameMode = gmOverworld }
	},
	{
		name = function() { return gvLangObj["pause-menu"]["save"]},
		func = function() { saveGame(); playSound(sndHeal, 0); gvGameMode = gmOverworld }
	},
	{
		name = function() { return gvLangObj["pause-menu"]["character"]},
		func = function() { pickChar() }
	},
	{
		name = function() { return gvLangObj["pause-menu"]["quit-game"]},
		func = function() { startMain(); cursor = 0 }
	}
]

::meOptions <- [
	{
		name = function() { return gvLangObj["options-menu"]["keyboard"] },
		func = function() { rebindKeys() }
	},
	{
		name = function() { return gvLangObj["options-menu"]["joystick"] },
		func = function() { rebindGamepad() }
	},
	{
		name = function() { return gvLangObj["options-menu"]["language"] },
		func = function() { selectLanguage() }
	},
	{
		name = function() { return gvLangObj["options-menu"]["timers"] },
		func = function() { cursor = 0; menu = meTimers }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["back"] },
		func = function() { cursor = 3; menu = meMain; fileWrite("config.json", jsonWrite(config)) }
		back = function() { cursor = 3; menu = meMain; fileWrite("config.json", jsonWrite(config)) }
	}
]

::meTimers <- [
	{
		name = function() { return gvLangObj["timers-menu"]["speedrun-timer-level"] + ": " + (config.showleveligt ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"]) },
		func = function() { config.showleveligt = !config.showleveligt }
	},
	{
		name = function() { return gvLangObj["timers-menu"]["speedrun-timer-global"] + ": " + (config.showglobaligt ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"]) },
		func = function() { config.showglobaligt = !config.showglobaligt }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["back"] },
		func = function() { cursor = 3; menu = meOptions }
		back = function() { cursor = 3; menu = meOptions }
	}
]

::meDifficulty <- [
	{
		name = function() { return gvLangObj["difficulty-levels"]["easy"] },
		func = function() { game.difficulty = 0; cursor = 0; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["normal"] },
		func = function() { game.difficulty = 1; cursor = 0; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["hard"] },
		func = function() { game.difficulty = 2; cursor = 0; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["super"] },
		func = function() { game.difficulty = 3; cursor = 0; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["cancel"] },
		func = function() { cursor = 0; menu = meMain }
		back = function() { cursor = 0; menu = meMain }
	}
]

::meNewGame <- [
	{
		name = function() {
			local m = "File 0"
			if(fileExists("save/0.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
			return m
		},
		func = function() {
			game.file = 0
			if(fileExists("save/0.json")) menu = meOverwrite
			else newGame(0)
			cursor = 0
		}
	},
	{
		name = function() {
			local m = "File 1"
			if(fileExists("save/1.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
			return m
		},
		func = function() {
			game.file = 1
			if(fileExists("save/1.json")) menu = meOverwrite
			else newGame(1)
			cursor = 0
		}
	},
	{
		name = function() {
			local m = "File 2"
			if(fileExists("save/2.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
			return m
		},
		func = function() {
			game.file = 2
			if(fileExists("save/2.json")) menu = meOverwrite
			else newGame(2)
			cursor = 0
		}
	},
	{
		name = function() {
			local m = "File 3"
			if(fileExists("save/3.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
			return m
		},
		func = function() {
			game.file = 3
			if(fileExists("save/3.json")) menu = meOverwrite
			else newGame(3)
			cursor = 0
		}
	},
	{
		name = function() { return gvLangObj["menu-commons"]["cancel"] }
		func = function() { cursor = 0; menu = meMain }
		back = function() { cursor = 0; menu = meMain }
	}
]

::meOverwrite <- [
	{
		name = function() { drawText(font2, screenW() / 2 - (15 * 4), screenH() / 2, "Overwrite save?"); return gvLangObj["menu-commons"]["no"] }
		func = function() { menu = meNewGame; cursor = 0 }
		back = function() { menu = meNewGame; cursor = 0 }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["yes"] }
		func = function() { newGame(game.file) }
	}
]

::meLoadGame <- []
//This menu is left empty intentionally; it will be created dynamically at runtime.
