///////////
// MENUS //
///////////

::menu <- []
::cursor <- 0
::textMenu <- function(){
	//If no menu is loaded
	if(menu == []) return

	//Draw options
	for(local i = 0; i < menu.len(); i++) {
		if(cursor == i) {
			drawSprite(font2, 97, (screenW() / 2) - (menu[i].name().len() * 4) - 16, screenH() - 8 - (menu.len() * 14) + (i * 14))
			drawSprite(font2, 102, (screenW() / 2) + (menu[i].name().len() * 4) + 7, screenH() - 8 - (menu.len() * 14) + (i * 14))
		}
		drawText(font2, (screenW() / 2) - (menu[i].name().len() * 4), screenH() - 8 - (menu.len() * 14) + (i * 14), menu[i].name())
	}

	//Keyboard input
	if(getcon("down", "press")) {
		cursor++
		if(cursor >= menu.len()) cursor = 0
	}

	if(getcon("up", "press")) {
		cursor--
		if(cursor < 0) cursor = menu.len() - 1
	}

	if(getcon("jump", "press") || getcon("pause", "press")) {
		menu[cursor].func()
	}
}

//Names are stored as functions because some need to change each time
//they're brought up again.
::meMain <- [
	{
		name = function() { return gvLangObj["main-menu"]["new"] },
		func = function() { game = clone(gameDefault); game.completed.clear(); game.allcoins.clear(); game.allenemies.clear(); game.allsecrets.clear(); startOverworld("res/map/overworld-0.json") }
	},
	{
		name = function() { return gvLangObj["main-menu"]["load"] },
		func = function() { return }
	},
	{
		name = function() { return gvLangObj["main-menu"]["options"] },
		func = function() { cursor = 0; menu = meOptions }
	},
	{
		name = function() { return gvLangObj["main-menu"]["quit"] },
		func = function() { gvQuit = 1 }
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
		name = function() { return "Back" },
		func = function() { cursor = 0; menu = meMain; fileWrite("config.json", jsonWrite(config)) }
	}
]

::meDifficulty <- [
	{
		name = function() { return gvLangObj["difficulty-levels"]["easy"] },
		func = function() { game.difficulty = 0; cursor = 0; menu = meOptions }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["normal"] },
		func = function() { game.difficulty = 1; cursor = 0; menu = meOptions }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["hard"] },
		func = function() { game.difficulty = 2; cursor = 0; menu = meOptions }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["super"] },
		func = function() { game.difficulty = 3; cursor = 0; menu = meOptions }
	}
]