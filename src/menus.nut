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
		name = function() { return gvLangObj["pause-menu"]["character"]},
		func = function() {  }
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
		name = function() { return gvLangObj["options-menu"]["speedrun"] + ": " + (config.showigt ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"]) },
		func = function() { config.showigt = !config.showigt}
	},
	{
		name = function() { return "Back" },
		func = function() { cursor = 0; menu = meMain; fileWrite("config.json", jsonWrite(config)) }
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
		name = function() { return "Cancel" },
		func = function() { cursor = 0; menu = meMain }
	}
]

::meNewGame <- [
	{
		name = function() {
			local m = "File 0"
			if(fileExists("save/0.json")) m += " [FILE EXISTS]"
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
			if(fileExists("save/1.json")) m += " [FILE EXISTS]"
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
			if(fileExists("save/2.json")) m += " [FILE EXISTS]"
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
			if(fileExists("save/3.json")) m += " [FILE EXISTS]"
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
		name = function() { return "Cancel" }
		func = function() { cursor = 0; menu = meMain }
	}
]

::meOverwrite <- [
	{
		name = function() { drawText(font2, screenW() / 2 - (15 * 4), screenH() / 2, "Overwrite save?"); return "No" }
		func = function() { menu = meNewGame; cursor = 0 }
	},
	{
		name = function() { return "Yes" }
		func = function() { newGame(game.file) }
	}
]

::meLoadGame <- []
//This menu is left empty intentionally; it will be created dynamically at runtime.