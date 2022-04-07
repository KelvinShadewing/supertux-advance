///////////
// MENUS //
///////////

::menu <- []
::menuLast <- []
::menuItemsPos <- [] //Positions of all menu items
::cursor <- 0
::cursorOffset <- 0
::cursorTimer <- 30
const menuMax = 10 //Maximum number of slots that can be shown on screen
const fontW = 8
const fontH = 14
::textMenu <- function(){
	//If no menu is loaded
	if(menu == []) return

	if(menu != menuLast) {
		cursor = 0
		cursorOffset = 0
	}
	menuLast = menu
	menuItemsPos = []

	//Draw options
	//The number
	if(menu.len() > menuMax) for(local i = cursorOffset; i < cursorOffset + menuMax; i++) {
		//Detect if menu item is disabled (has no function). Display it with gray font if so.
		local currFont = font2
		if(menu[i].rawin("disabled")) { currFont = font2G }

		if(cursor == i) {
			drawSprite(currFont, 97, (screenW() / 2) - (menu[i].name().len() * 4) - 16, screenH() - 24 - (menuMax * fontH) + ((i - cursorOffset) * fontH))
			drawSprite(currFont, 102, (screenW() / 2) + (menu[i].name().len() * 4) + 7, screenH() - 24 - (menuMax * fontH) + ((i - cursorOffset) * fontH))
			if(menu[i].rawin("desc"))
				drawText(font, (screenW() / 2) - (menu[i].desc().len() * 3), screenH() - fontH - 8, menu[i].desc())
		}

		local textX = (screenW() / 2) - (menu[i].name().len() * 4)
		local textY = screenH() - 24 - (menuMax * fontH) + ((i - cursorOffset) * fontH)

		drawText(currFont, textX, textY, menu[i].name())
		menuItemsPos.append({index = i, x = textX, y = textY, len = menu[i].name().len() * fontW})
	}
	else for(local i = 0; i < menu.len(); i++) {
		//Detect if menu item is disabled (has no function). Display it with gray font if so.
		local currFont = font2
		if(menu[i].rawin("disabled")) { currFont = font2G }

		if(cursor == i) {
			drawSprite(currFont, 97, (screenW() / 2) - (menu[i].name().len() * 4) - 16, screenH() - 24 - (menu.len() * fontH) + (i * fontH))
			drawSprite(currFont, 102, (screenW() / 2) + (menu[i].name().len() * 4) + 7, screenH() - 24 - (menu.len() * fontH) + (i * fontH))
			if(menu[i].rawin("desc"))
				drawText(font, (screenW() / 2) - (menu[i].desc().len() * 3), screenH() - fontH - 8, menu[i].desc())
		}

		local textX = (screenW() / 2) - (menu[i].name().len() * 4)
		local textY = screenH() - 24 - (menu.len() * fontH) + (i * fontH)

		drawText(currFont, textX, textY, menu[i].name())
		menuItemsPos.append({index = i, x = textX, y = textY, len = menu[i].name().len() * fontW})
	}

	//Mouse cursor update + left click input check
	updateCursor()
	if(mouseRelease(0)) processCursorInput()

	//Keyboard input
	if(getcon("down", "press") || (getcon("down", "hold") && cursorTimer <= 0)) {
		cursor++
		if(cursor >= cursorOffset + menuMax) cursorOffset++
		if(cursor >= menu.len()) {
			cursor = 0
			cursorOffset = 0
		}
		if(getcon("down", "press")) cursorTimer = 40
		else cursorTimer = 10
		soundPlay(sndMenuMove, 0)
	}

	if(getcon("up", "press") || (getcon("up", "hold") && cursorTimer <= 0)) {
		cursor--
		if(cursor < cursorOffset) cursorOffset--
		if(cursor < 0) {
			cursor = menu.len() - 1
			if(menu.len() > menuMax) cursorOffset = menu.len() - menuMax
		}
		if(getcon("up", "press")) cursorTimer = 40
		else cursorTimer = 10
		soundPlay(sndMenuMove, 0)
	}

	if(getcon("down", "hold") || getcon("up", "hold")) cursorTimer--

	if(getcon("jump", "press") || getcon("accept", "press")) {
		if(menu[cursor].rawin("disabled")) return;
		menu[cursor].func()
		soundPlay(sndMenuSelect, 0)
	}

	if(getcon("pause", "press")) {
		for(local i = 0; i < menu.len(); i++) {
				if(menu[i].rawin("back")) {
					menu[i]["back"]()
					break
				}
		}
	}

	if(mouseWheelY() < 0 && cursorOffset < menu.len() - menuMax) {
		cursorOffset++
		cursor++
	}
	if(mouseWheelY() > 0 && cursorOffset > 0) {
		cursorOffset--
		cursor--
	}
}

//Names are stored as functions because some need to change each time
//they're brought up again.
::meMain <- [
	{
		name = function() { return gvLangObj["main-menu"]["new"] },
		func = function() { menu = meDifficulty }
	},
	{
		name = function() { return gvLangObj["main-menu"]["load"] },
		func = function() { selectLoadGame() }
	},
	{
		name = function() { return gvLangObj["main-menu"]["contrib-levels"] },
		func = function() { selectContrib(); }
	}
	{
		name = function() { return gvLangObj["main-menu"]["options"] },
		func = function() { menu = meOptions }
	},
		{
		name = function() { return gvLangObj["main-menu"]["credits"] },
		func = function() { startCredits("res"); }
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
		func = function() { saveGame(); soundPlay(sndHeal, 0); gvGameMode = gmOverworld }
	},
	{
		name = function() { return gvLangObj["pause-menu"]["character"]},
		func = function() { pickChar() }
	},
	{
		name = function() { return gvLangObj["pause-menu"]["quit-game"]},
		func = function() { saveGame(); startMain(); cursor = 0 }
	}
]

::meOptions <- [
	{
		name = function() { return gvLangObj["options-menu"]["keyboard"] },
		desc = function() { return gvLangObj["options-menu-desc"]["keyboard"] },
		func = function() { menu = meKeybinds }
	},
	{
		name = function() { return gvLangObj["options-menu"]["joystick"] },
		desc = function() { return gvLangObj["options-menu-desc"]["joystick"] },
		func = function() { menu = meJoybinds }
	},
	{
		name = function() { return gvLangObj["options-menu"]["audio"] },
		desc = function() { return gvLangObj["options-menu-desc"]["audio"] },
		func = function() { menu = meAudio }
	},
	{
		name = function() {
			local msg = gvLangObj["options-menu"]["cursor"]
			if(config.showcursor) msg += gvLangObj["menu-commons"]["on"]
			else msg += gvLangObj["menu-commons"]["off"]
			return msg
		},
		desc = function() { return gvLangObj["options-menu-desc"]["cursor"] },
		func = function() { config.showcursor = !config.showcursor; fileWrite("config.json", jsonWrite(config)) }
	},
	{
		name = function() { return gvLangObj["options-menu"]["language"] },
		desc = function() { return gvLangObj["options-menu-desc"]["language"] },
		func = function() { selectLanguage() }
	},
	{
		name = function() { return gvLangObj["options-menu"]["timers"] },
		desc = function() { return gvLangObj["options-menu-desc"]["timers"] },
		func = function() { menu = meTimers }
	},
	{
		name = function() {
			local msg = gvLangObj["options-menu"]["light"]
			if(config.light) msg += gvLangObj["menu-commons"]["on"]
			else msg += gvLangObj["menu-commons"]["off"]
			return msg
		},
		desc = function() { return gvLangObj["options-menu-desc"]["light"] },
		func = function() { config.light = !config.light; fileWrite("config.json", jsonWrite(config)) }
	},
	{
		name = function() { return gvLangObj["options-menu"]["fullscreen"] },
		desc = function() { return gvLangObj["options-menu-desc"]["fullscreen"] },
		func = function() { toggleFullscreen() }
	},
	{
		name = function() {
			local msg = gvLangObj["options-menu"]["stickspeed"]
			if(config.stickspeed) msg += gvLangObj["menu-commons"]["on"]
			else msg += gvLangObj["menu-commons"]["off"]
			return msg
		},
		desc = function() { return gvLangObj["options-menu-desc"]["stickspeed"] },
		func = function() { config.stickspeed = !config.stickspeed; fileWrite("config.json", jsonWrite(config)) }
	},
	{
		name = function() {
			local msg = gvLangObj["options-menu"]["autorun"]
			if(config.autorun) msg += gvLangObj["menu-commons"]["on"]
			else msg += gvLangObj["menu-commons"]["off"]
			return msg
		},
		desc = function() { return gvLangObj["options-menu-desc"]["autorun"] },
		func = function() { config.autorun = !config.autorun; fileWrite("config.json", jsonWrite(config)) }
	},
	{
		name = function() {
			local msg = gvLangObj["options-menu"]["usefilter"]
			if(config.usefilter) msg += gvLangObj["menu-commons"]["on"]
			else msg += gvLangObj["menu-commons"]["off"]
			return msg
		},
		desc = function() { return gvLangObj["options-menu-desc"]["usefilter"] },
		func = function() { config.usefilter = !config.usefilter; fileWrite("config.json", jsonWrite(config)) }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["back"] },
		func = function() { cursor = 3; menu = meMain; fileWrite("config.json", jsonWrite(config)) }
		back = function() { cursor = 3; menu = meMain; fileWrite("config.json", jsonWrite(config)) }
	}

]

::meKeybinds <- [
	{
		name = function() { return gvLangObj["controls-menu"]["up"] + ": " + gvLangObj["key"][config.key.up.tostring()] },
		func = function() { rebindKeys(0) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["down"] + ": " + gvLangObj["key"][config.key.down.tostring()] },
		func = function() { rebindKeys(1) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["left"] + ": " + gvLangObj["key"][config.key.left.tostring()] },
		func = function() { rebindKeys(2) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["right"] + ": " + gvLangObj["key"][config.key.right.tostring()] },
		func = function() { rebindKeys(3) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["jump"] + ": " + gvLangObj["key"][config.key.jump.tostring()] },
		func = function() { rebindKeys(4) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["shoot"] + ": " + gvLangObj["key"][config.key.shoot.tostring()] },
		func = function() { rebindKeys(5) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["run"] + ": " + gvLangObj["key"][config.key.run.tostring()] },
		func = function() { rebindKeys(6) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["sneak"] + ": " + gvLangObj["key"][config.key.sneak.tostring()] },
		func = function() { rebindKeys(7) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["pause"] + ": " + gvLangObj["key"][config.key.pause.tostring()] },
		func = function() { rebindKeys(8) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["item-swap"] + ": " + gvLangObj["key"][config.key.swap.tostring()] },
		func = function() { rebindKeys(9) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["menu-accept"] + ": " + gvLangObj["key"][config.key.accept.tostring()] },
		func = function() { rebindKeys(10) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-left-peek"] + ": " + gvLangObj["key"][config.key.leftPeek.tostring()] },
		func = function() { rebindKeys(11) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-right-peek"] + ": " + gvLangObj["key"][config.key.rightPeek.tostring()] },
		func = function() { rebindKeys(12) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-down-peek"] + ": " + gvLangObj["key"][config.key.downPeek.tostring()] },
		func = function() { rebindKeys(13) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-up-peek"] + ": " + gvLangObj["key"][config.key.upPeek.tostring()] },
		func = function() { rebindKeys(14) }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["back"] },
		func = function() { menu = meOptions }
		back = function() { menu = meOptions }
	}
]

::meJoybinds <- [
	{
		name = function() { return gvLangObj["controls-menu"]["jump"] + ": " + (config.joy.jump != -1 ? config.joy.jump.tostring() : "") },
		func = function() { rebindGamepad(4) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["shoot"] + ": " + (config.joy.shoot != -1 ? config.joy.shoot.tostring() : "") },
		func = function() { rebindGamepad(5) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["run"] + ": " + config.joy.run.tostring() },
		func = function() { rebindGamepad(6) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["sneak"] + ": " + config.joy.sneak.tostring() },
		func = function() { rebindGamepad(7) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["pause"] + ": " + config.joy.pause.tostring() },
		func = function() { rebindGamepad(8) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["item-swap"] + ": " + config.joy.swap.tostring() },
		func = function() { rebindGamepad(9) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["menu-accept"] + ": " + config.joy.accept.tostring() },
		func = function() { rebindGamepad(10) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-left-peek"] + ": " + config.joy.leftPeek.tostring() },
		func = function() { rebindGamepad(11) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-right-peek"] + ": " + config.joy.rightPeek.tostring() },
		func = function() { rebindGamepad(12) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-down-peek"] + ": " + config.joy.downPeek.tostring() },
		func = function() { rebindGamepad(13) }
	},
	{
		name = function() { return gvLangObj["controls-menu"]["cam-up-peek"] + ": " + config.joy.upPeek.tostring() },
		func = function() { rebindGamepad(14) }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["back"] },
		func = function() { menu = meOptions }
		back = function() { menu = meOptions }
	}
]

::meAudio <- [
	{
		name = function() { return gvLangObj["audio-menu"]["sound"] + ": " + (config.soundenabled ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"]) },
		func = function() { config.soundenabled = !config.soundenabled }
	},
	{
		name = function() { return gvLangObj["audio-menu"]["music"] + ": " + (config.musicenabled ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"]) },
		func = function() { config.musicenabled = !config.musicenabled; config.musicenabled ? songPlay(musTheme, true) : stopMusic() }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["back"] },
		func = function() { cursor = 3; menu = meOptions }
		back = function() { cursor = 3; menu = meOptions }
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
		func = function() { game.difficulty = 0; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["normal"] },
		func = function() { game.difficulty = 1; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["hard"] },
		func = function() { game.difficulty = 2; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["difficulty-levels"]["super"] },
		func = function() { game.difficulty = 3; menu = meNewGame }
	},
	{
		name = function() { return gvLangObj["menu-commons"]["cancel"] },
		func = function() { menu = meMain }
		back = function() { menu = meMain }
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
		func = function() { menu = meMain }
		back = function() { menu = meMain }
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
