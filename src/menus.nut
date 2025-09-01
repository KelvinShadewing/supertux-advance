///////////
// MENUS //
///////////

menu <- []
menuLast <- []
menuItemsPos <- [] // Positions of all menu items
cursor <- 0
cursorOffset <- 0
cursorTimer <- 30

menuLarge <- {
	w = 8
	w2 = 4
	h = 14
	ml = 8
	p = 16
	f = font2
	y = 40
}

menuSmall <- {
	w = 6
	w2 = 3
	h = 8
	ml = 16
	p = 16
	f = font
	y = 32
}

setMenu <- function(m) {
	menu = m
	cursor = 0
}

textMenu <- function(){
	// If no menu is loaded
	if(menu == []) return

	if(menu != menuLast) {
		cursor = 0
		cursorOffset = 0
	}
	menuLast = menu
	menuItemsPos = []

	// Draw options
	// If there are more items than can be displayed at once
	if(menu.items.len() > menu.size.ml) for(local i = cursorOffset; i < cursorOffset + menu.size.ml; i++) {
		// Detect if menu item is disabled (has no function). Display it with gray font if so.
		local currCol = "~0"
		if(menu.items[i].rawin("disabled") && menu.items[i].disabled == true)
			currCol = "~7"

		if(cursor == i) {
			currCol = "~j"
			drawSprite(
				menu.size.f, 16,
				(menu.rawin("left") && menu.left? menu.size.p : screenW() / 2) - (menu.rawin("left") && menu.left ? 0 : menu.items[i].name().len() * menu.size.w2) - (menu.size.w2 * 3),
				screenH() - menu.size.y - (menu.size.ml * menu.size.h) + ((i - cursorOffset) * menu.size.h))
			drawSprite(
				menu.size.f, 17,
				(menu.rawin("left") && menu.left ? menu.size.p : screenW() / 2) + (menu.rawin("left") && menu.left ? menu.items[i].name().len() * 8 : menu.items[i].name().len() * menu.size.w2) + (menu.size.w2),
				screenH() - menu.size.y - (menu.size.ml * menu.size.h) + ((i - cursorOffset) * menu.size.h))
			// Display option description
			local d = ""
			if(menu.items[i].rawin("desc"))
				d = menu.items[i].desc()
			if(typeof d == "string" && d != "" && d != null){
				setDrawColor(0x00000080)
				drawRec(0, screenH() - menu.size.h - 10, screenW(), 12, true)
				drawText(font, (screenW() / 2) - (d.len() * 3), screenH() - menu.size.h - 8, d)
			}

			if("draw" in menu.items[i])
				menu.items[i].draw()
		}

		local textX = ((menu.rawin("left") && menu.left) ? menu.size.p : screenW() / 2) - ((menu.rawin("left") && menu.left) ? 0 : menu.items[i].name().len() * menu.size.w2)
		local textY = screenH() - menu.size.y - (menu.size.ml * menu.size.h) + ((i - cursorOffset) * menu.size.h)

		drawText(menu.size.f, textX, textY, currCol + menu.items[i].name())
		menuItemsPos.append({index = i, x = textX, y = textY, len = menu.items[i].name().len() * menu.size.w})

		// Draw scroll indicators
		if(cursorOffset > 0) for(local i = 0; i < 4; i++) drawSprite(menu.size.f, 30, ((menu.rawin("left") && menu.left) ? menu.size.p : screenW() / 2 - 24) + (i * 12), screenH() - menu.size.y - (menu.size.h * (menu.size.ml + 1)))
		if(cursorOffset < menu.items.len() - menu.size.ml) for(local i = 0; i < 4; i++) drawSprite(menu.size.f, 31, ((menu.rawin("left") && menu.left) ? menu.size.p : screenW() / 2 - 24) + (i * 12), screenH() - menu.size.y)
	}
	// If all items can fit on screen at once
	else for(local i = 0; i < menu.items.len(); i++) {
		// Detect if menu item is disabled (has no function). Display it with gray font if so.
		local currCol = "~0"
		if(menu.items[i].rawin("disabled") && menu.items[i].disabled == true)
			currCol = "~7"

		if(cursor == i) {
			currCol = "~j"
			drawSprite(menu.size.f, 16,
				((menu.rawin("left") && menu.left) ? menu.size.p : screenW() / 2) - ((menu.rawin("left") && menu.left) ? 0 : menu.items[i].name().len() * menu.size.w2) - (menu.size.w2 * 3),
				screenH() - menu.size.y - (menu.items.len() * menu.size.h) + (i * menu.size.h))
			drawSprite(menu.size.f, 17,
				((menu.rawin("left") && menu.left) ? menu.size.p : screenW() / 2) + ((menu.rawin("left") && menu.left) ? menu.items[i].name().len() * menu.size.w : menu.items[i].name().len() * menu.size.w2) + (menu.size.w2),
				screenH() - menu.size.y - (menu.items.len() * menu.size.h) + (i * menu.size.h))
			local d = ""
			if(menu.items[i].rawin("desc"))
				d = menu.items[i].desc()
			if(typeof d == "string" && d != "" && d != null){
				setDrawColor(0x00000080)
				drawRec(0, screenH() - menu.size.h - 10, screenW(), 12, true)
				drawText(font, (screenW() / 2) - (d.len() * 3), screenH() - menu.size.h - 8, d)
			}

			if("draw" in menu.items[i])
				menu.items[i].draw()
		}

		local textX = ((menu.rawin("left") && menu.left) ? menu.size.p : screenW() / 2) - ((menu.rawin("left") && menu.left) ? 0 : menu.items[i].name().len() * menu.size.w2)
		local textY = screenH() - menu.size.y - (menu.items.len() * menu.size.h) + (i * menu.size.h)

		drawText(menu.size.f, textX, textY, currCol + menu.items[i].name())
		menuItemsPos.append({index = i, x = textX, y = textY, len = menu.items[i].name().len() * menu.size.w})
	}

	// Mouse cursor update + left click input check
	updateCursor()
	if(mouseRelease(0)) processCursorInput()

	// Keyboard input
	if(getcon("down", "press", false, 0, false) || (getcon("down", "hold", false, 0, false) && cursorTimer <= 0)) {
		cursor++
		if(cursor >= cursorOffset + menu.size.ml) cursorOffset++
		if(cursor >= menu.items.len()) {
			cursor = 0
			cursorOffset = 0
		}
		if(getcon("down", "press", false, 0, false)) cursorTimer = 40
		else cursorTimer = 10
		popSound(sndMenuMove, 0)
	}

	if(getcon("up", "press", false, 0, false) || (getcon("up", "hold", false, 0, false) && cursorTimer <= 0)) {
		cursor--
		if(cursor < cursorOffset) cursorOffset--
		if(cursor < 0) {
			cursor = menu.items.len() - 1
			if(menu.items.len() > menu.size.ml) cursorOffset = menu.items.len() - menu.size.ml
		}
		if(getcon("up", "press", false, 0, false)) cursorTimer = 40
		else cursorTimer = 10
		popSound(sndMenuMove, 0)
	}

	if(getcon("down", "hold", false, 1, false) || getcon("up", "hold", false, 1, false) || getcon("down", "hold", false, 2, false) || getcon("up", "hold", false, 2, false)) cursorTimer--

	if(getcon("jump", "press", false, 1, false) || getcon("accept", "press", false, 1, false) || getcon("jump", "press", false, 2, false) || getcon("accept", "press", false, 2, false)) {
		if(menu.items[cursor].rawin("disabled") && menu.items[cursor].disabled == true) return;
		popSound(sndMenuSelect, 0)
		menu.items[cursor].func()
	}

	if(getcon("pause", "press", false, 0, false)) {
		for(local i = 0; i < menu.items.len(); i++) {
				if(menu.rawin("back")) {
					menu.back()
					break
				}
		}
	}

	if(mouseWheelY() < 0 && cursorOffset < menu.items.len() - menu.size.ml) {
		cursorOffset++
		cursor++
	}
	if(mouseWheelY() > 0 && cursorOffset > 0) {
		cursorOffset--
		cursor--
	}
}

// Names are stored as functions because some need to change each time
// they're brought up again.
meMain <- {
	size = menuLarge
	items = [
		{
			name = function() {
				return gvLangObj["main-menu"]["new"]
			}
			func = function() {
				gvTimeAttack = false
				menu = meDifficulty
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["load"]
			}
			func = function() {
				gvTimeAttack = false
				selectLoadGame()
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["time-attack"]
			}
			func = function() {
				gvTimeAttack = true
				menu = meTimeAttack
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["battle"]
			}
			func = function() {
				gvTimeAttack = false
				menu = meBattleMode
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["contrib-levels"]
			}
			func = function() {
				gvTimeAttack = false
				selectContrib();
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["options"]
			}
			func = function() {
				menu = meOptions
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["extras"]
			}
			func = function() {
				menu = meExtras
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["quit"]
			}
			func = function() {
				gvQuit = 1
			}
		}
	]
}

meExtras <- {
	size = menuLarge
	back = function() {
		menu = meMain
	}
	items = [
		{
			name = function() { return gvLangObj["extras-menu"]["achievements"] }
			func = function() { selectAchievements() }
		},
		{
			name = function() { return gvLangObj["extras-menu"]["credits"] }
			func = function() { startCredits("res") }
		},
		{
			name = function() { return gvLangObj["menu-commons"]["back"] }
			func = function() { menu = meMain }
		}
	]
}

meTimeAttack <- {
	size = menuLarge
	back = function() {
		menu = meMain
	}
	items = [
		{
			name = function() {
				return gvLangObj["time-attack-menu"]["start-run"]
			}
			func = function() {
				cursor = 0; menu = meTimeAttackWorld
			}
		},
		{
			name = function() {
				return format(gvLangObj["time-attack-menu"]["player1"], gvCharacters[game.playerChar].shortname)
			}
			func = function() {
				pickCharInitialize(1, true)
				gvGameMode = pickChar
			}
		},
		{
			name = function() {
				return format(gvLangObj["time-attack-menu"]["player2"],
					(game.playerChar2 != 0 && game.playerChar2 != ""
						? gvCharacters[game.playerChar2].shortname
						: gvLangObj["menu-commons"]["noone"]))
			}
			func = function() {
				pickCharInitialize(2, true)
				gvGameMode = pickChar
			}
		},
		{
			name = function() {
				return gvLangObj["time-attack-menu"]["random-level"] + ": " + gvLangObj["menu-commons"][gvTARandomLevel ? "on" : "off"]
			}
			func = function() {
				gvTARandomLevel = !gvTARandomLevel
			}
		},
		{
			name = function() {
				return gvLangObj["time-attack-menu"]["random-char"] + ": " + gvLangObj["menu-commons"][gvTARandomPlayer ? "on" : "off"]
			}
			func = function() {
				gvTARandomPlayer = !gvTARandomPlayer
			}
		},
		{
			name = function() {
				return gvLangObj["time-attack-menu"]["random-item"] + ": " + gvLangObj["menu-commons"][gvTARandomItem ? "on" : "off"]
			}
			func = function() {
				gvTARandomItem = !gvTARandomItem
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				cursor = 0; menu = meMain
			}
		}
	]
}

meTimeAttackWorld <- {
	left = true
	size = menuLarge
	back = function() {
		menu = meTimeAttack
	}
	items = [
		{
			name = function() {
				return gvLangObj["level"]["full-game"]
			}
			func = function() {
				game.path = "res/map/"
				gvTACourse = clone(gvStoryLevelList)
				menu = meDifficulty
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["fullgame"] }
		},
		{
			name = function() {
				return gvLangObj["level"]["overworld-0"]
			}
			func = function() {
				game.path = "res/map/"
				gvTACourse = [
					"aurora-learn",
					"aurora-crystal",
					"aurora-iceguy",
					"aurora-slip",
					"aurora-subsea",
					"aurora-tnt",
					"aurora-fishy",
					"aurora-sense",
					"aurora-branches",
					"aurora-frozen",
					"aurora-forest",
					"aurora-bridge",
					"aurora-wind",
					"aurora-steps",
					"aurora-fort"
				]
				menu = meDifficulty
			}
		},
		/*{
			name = function() { return gvLangObj["level"]["overworld-1"] }
			func = function() {
				game.path = "res/map/"
				gvTACourse = [
					"nessland-left",
					"nessland-attack",
					"nessland-earth",
					"nessland-mint",
					"nessland-owl",
					"nessland-shells",
					"nessland-henge",
					"nessland-situation",
					"nessland-fly",
					"nessland-cliffs",
					"nessland-well",
					"nessland-bedrock",
					"nessland-crush",
					"nessland-night",
					"nessland-hive"
				]
				menu = meDifficulty
			}
		},*/
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meTimeAttack
			}
		}
	]
}

meBattleMode <- {
	size = menuLarge
	back = function() {
		menu = meMain
		gvBattleMode = false
	}
	items = [
		{
			name = function() {
				return gvLangObj["battle-menu"]["start-battle"]
				disabled = (game.playerChar2 == "")
			}
			func = function() {
				if(game.playerChar2 != "") {
					gvBattleMode = true
					gvTARandomItem = false
					gvTARandomLevel = false
					gvTARandomPlayer = false
					menu = meBattleWorld
				}
			}
			desc = function() {
				if(game.playerChar2 == "")
					return gvLangObj["battle-menu"]["warning"]
			}
			disabled = false
		},
		{
			name = function() {
				return format(gvLangObj["time-attack-menu"]["player1"], gvCharacters[game.playerChar].shortname)
			}
			func = function() {
				pickCharInitialize(1, true)
				gvGameMode = pickChar
			}
		},
		{
			name = function() { return format(gvLangObj["time-attack-menu"]["player2"],
				(game.playerChar2 != 0 && game.playerChar2 != ""
				? gvCharacters[game.playerChar2].shortname
				: gvLangObj["menu-commons"]["noone"]))
			}
			func = function() {
				pickCharInitialize(2, true)
				gvGameMode = pickChar
			}
		},
		{
			name = function() {
				return format(gvLangObj["battle-menu"]["health"], str(16 + gvBattleHealth) + " HP")
			}
			func = function() {
				setMenu(meBattleHealth)
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				cursor = 0
				menu = meMain
			}
		}
	]
}

meBattleWorld <- {
	size = menuLarge
	left = true
	back = function() {
		menu = meBattleMode
		gvBattleMode = false
	}
	items = [
		{
			name = function() {
				return gvLangObj["level"]["battle-test"]
			}
			func = function() {
				startBattle(game.path + "battle-test.json")
			}
			draw = function() {
				drawBattlePreview(sprBattleTest)
			}
		},
		{
			name = function() {
				return gvLangObj["level"]["battle-castle"]
			}
			func = function() {
				startBattle(game.path + "battle-castle.json")
			}
			draw = function() {
				drawBattlePreview(sprBattleCastle)
			}
		},
		{
			name = function() {
				return gvLangObj["level"]["battle-henge"]
			}
			func = function() {
				startBattle(game.path + "battle-henge.json")
			}
			draw = function() {
				drawBattlePreview(sprBattleHenge)
			}
		},
		{
			name = function() {
				return gvLangObj["level"]["battle-desert"]
			}
			func = function() {
				startBattle(game.path + "battle-desert.json")
			}
			draw = function() {
				drawBattlePreview(sprBattleDesert)
			}
		},
		{
			name = function() {
				return gvLangObj["level"]["battle-hole"]
			}
			func = function() {
				startBattle(game.path + "battle-hole.json")
			}
			draw = function() {
				drawBattlePreview(sprBattleHole)
			}
		},
		{
			name = function() {
				return gvLangObj["level"]["battle-soccer"]
			}
			func = function() {
				startBattle(game.path + "battle-soccer.json")
			}
			draw = function() {
				drawBattlePreview(sprBattleSoccer)
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				gvBattleMode = false
				menu = meMain
			}
		}
	]
}

meBattleHealth <- {
	size = menuLarge
	back = function() {
		menu = meBattleMode
	}
	items = [
		{
			name = function() {
				return "16 HP"
			}
			func = function() {
				gvBattleHealth = 0
				setMenu(meBattleMode)
			}
		},
		{
			name = function() {
				return "24 HP"
			}
			func = function() {
				gvBattleHealth = 8
				setMenu(meBattleMode)
			}
		},
		{
			name = function() {
				return "32 HP"
			}
			func = function() {
				gvBattleHealth = 16
				setMenu(meBattleMode)
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				gvBattleMode = false
				menu = meMain
			}
		}
	]
}

mePausePlay <- {
	size = menuLarge
	items = [
		{
			name = function() {
				return gvLangObj["pause-menu"]["continue"]
			}
			func = function() {
				gvGameMode = gmPlay
			}
		},
		{
			name = function() {
				return gvLangObj["pause-menu"]["restart"]
			}
			func = function() {
				gvIGT = 0;
				game.check = false;
				startPlay(gvMap.file, true, true)
			}
		},
		{
			name = function() { return gvLangObj["main-menu"]["options"]
			}
			func = function() { menu = meOptions }
		},
		{
			name = function() { return gvLangObj["pause-menu"]["quit-level"]
			}
			func = function() {
				if(gvBattleMode) {
					gvBattleMode = false
					local tp1 = game.playerChar
					local tp2 = game.playerChar2
					startMain()
					setMenu(meBattleMode)
					game.playerChar = tp1
					game.playerChar2 = tp2
				}
				else if(gvTimeAttack) startMain()
				else startOverworld(game.world)
			}
		}
	]
}

mePauseTimeAttack <- {
	size = menuLarge
	items = [
		{
			name = function() {
				return gvLangObj["pause-menu"]["continue"]
			}
			func = function() {
				gvGameMode = gmPlay
			}
		},
		{
			name = function() {
				return gvLangObj["pause-menu"]["restart"]
			}
			func = function() {
				gvIGT = 0; game.check = false;
				startPlay(gvMap.file, true, true)
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["options"]
			}
			func = function() {
				menu = meOptions
			}
		},
		{
			name = function() {
				return gvLangObj["pause-menu"]["restart-run"]
			}
			func = function() {
				newTimeAttack()
			}
		},
		{
			name = function() { return gvLangObj["pause-menu"]["end-run"]
			}
			func = function() {
				if(gvTimeAttack) startMain()
				else startOverworld(game.world)
			}
		}
	]
}

mePauseOver <- {
	size = menuLarge
	items = [
		{
			name = function() {
				return gvLangObj["pause-menu"]["continue"]
			}
			func = function() {
				gvGameMode = gmOverworld
			}
		},
		{
			name = function() {
				return gvLangObj["pause-menu"]["save"]
			}
			func = function() {
				saveGame()
				popSound(sndHeal, 0)
				gvGameMode = gmOverworld
			}
		},
		{
			name = function() {
				return gvLangObj["pause-menu"]["character"]
			}
			func = function() {
				pickCharInitialize()
				gvGameMode = pickChar
			}
			desc = function() {
				return game.playerChar
			}
		},
		{
			name = function() {
				return gvLangObj["pause-menu"]["character2"]
			}
			func = function() {
				pickCharInitialize(2)
				gvGameMode = pickChar
			}
			desc = function() {
				return game.playerChar2
			}
		},
		{
			name = function() {
				return gvLangObj["main-menu"]["options"]
			}
			func = function() {
				menu = meOptions
			}
		},
		{
			name = function() {
				return gvLangObj["pause-menu"]["quit-game"]
			}
			func = function() {
				saveGame(); startMain();
			}
		}
	]
}

meOptions <- {
	size = menuLarge
	back = function() {
		if(gvGameMode == gmPause) {
			if(gvPauseMode) menu = mePauseOver
			else if(gvTimeAttack) menu = mePauseTimeAttack
			else menu = mePausePlay
		}
		else menu = meMain
		fileWrite("config.json", jsonWrite(config))
	}
	items = [
		{
			name = function() {
				return gvLangObj["options-menu"]["graphics"]
			}
			func = function() {
				menu = meGraphics
			}
		},
		{
			name = function() { return gvLangObj["options-menu"]["speedrun"] },
			desc = function() { return gvLangObj["options-menu-desc"]["speedrun"] },
			func = function() { menu = meSpeedrun }
		},
		{
			name = function() { return gvLangObj["options-menu"]["input"] },
			func = function() { cursor = 0; menu = meInput }
		},
		{
			name = function() { return gvLangObj["options-menu"]["audio"] },
			func = function() { cursor = 0; menu = meAudio }
		},
		{
			name = function() { return gvLangObj["options-menu"]["language"] },
			desc = function() { return gvLangObj["options-menu-desc"]["language"] },
			func = function() { selectLanguage() }
		},
		{
			name = function() { return gvLangObj["options-menu"]["accessibility"] },
			func = function() { cursor = 0; menu = meAccessibility }
		},
		{
			name = function() { return gvLangObj["menu-commons"]["back"] },
			func = function() {
				if(gvGameMode == gmPause) {
					if(gvPauseMode) menu = mePauseOver
					else if(gvTimeAttack) menu = mePauseTimeAttack
					else menu = mePausePlay
				}
				else menu = meMain;
				fileWrite("config.json", jsonWrite(config))
			}
		}
	]
}

meGraphics <- {
	size = menuLarge
	back = function() {
		menu = meOptions
		fileWrite("config.json", jsonWrite(config))
	}
	items = [
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.light ? "on" : "off"]
				return format(gvLangObj["options-menu"]["light"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["light"]
				}
			func = function() {
				config.light = !config.light; fileWrite("config.json", jsonWrite(config))
				}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.weather ? "on" : "off"]
				return format(gvLangObj["options-menu"]["weather"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["weather"]
			}
			func = function() {
				config.weather = !config.weather; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.lookAhead ? "on" : "off"]
				return format(gvLangObj["options-menu"]["lookahead"], val)
			}
			desc = function() { return gvLangObj["options-menu-desc"]["lookahead"]
			}
			func = function() { config.lookAhead = !config.lookAhead }
		},
		{
			name = function() {
				return gvLangObj["options-menu"]["fullscreen"]
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["fullscreen"]
			}
			func = function() {
				toggleFullscreen(); config.fullscreen = !config.fullscreen
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.usefilter ? "on" : "off"]
				return format(gvLangObj["options-menu"]["usefilter"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["usefilter"]
			}
			func = function() {
				config.usefilter = !config.usefilter
				fileWrite("config.json", jsonWrite(config))
				updateDisplaySettings()
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.showTF ? "on" : "off"]
				return format(gvLangObj["options-menu"]["show-tf"], val)
			},
			desc = function() {
				return gvLangObj["options-menu-desc"]["show-tf"]
			}
			func = function() {
				config.showTF = !config.showTF
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.splitlock ? "on" : "off"]
				return format(gvLangObj["options-menu"]["lock-splitscreen"], val)
			}
			desc = function() {
				if(config.splitlock)
					return gvLangObj["options-menu-desc"]["lock-splitscreen-b"]
				else
					return gvLangObj["options-menu-desc"]["lock-splitscreen-a"]
			}
			func = function() {
				config.splitlock = !config.splitlock
			}
		},
		{
			name = function() {
				local val = ""
				switch(config.aspect) {
					case 0:
						val = gvLangObj["options-aspects"]["auto"]
						break
					case 1:
						val = gvLangObj["options-aspects"]["full"]
						break
					case 2:
						val = gvLangObj["options-aspects"]["wide"]
						break
					case 3:
						val = gvLangObj["options-aspects"]["ultra"]
				}

				return format(gvLangObj["options-menu"]["aspect"], val)
			}
			func = function() {
				setMenu(meScreenAspect)
			}
		},
		{
			name = function() {
				return format(gvLangObj["options-menu"]["scanlines"], ([
					gvLangObj["menu-commons"]["off"],
					gvLangObj["menu-commons"]["a"],
					gvLangObj["menu-commons"]["b"]
				])[int(config.scanlines)])
			}
			func = function() {
				config.scanlines = (int(config.scanlines) + 1) % 3
				fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meOptions
			}
		}
	]
}

meScreenAspect <- {
	size = menuLarge
	back = function() {
		menu = meOptions
	}
	items = [
	{
		name = function() {
			return gvLangObj["options-aspects"]["auto"]
		}
		func = function() {
			config.aspect = 0
			fileWrite("config.json", jsonWrite(config))
			deleteTexture(gvScreen)
			updateDisplaySettings()
		}
	},
	{
		name = function() {
			return gvLangObj["options-aspects"]["full"]
		}
		func = function() {
			config.aspect = 1
			fileWrite("config.json", jsonWrite(config))
			updateDisplaySettings()
		}
	},
	{
		name = function() {
			return gvLangObj["options-aspects"]["wide"]
		}
		func = function() {
			config.aspect = 2
			fileWrite("config.json", jsonWrite(config))
			updateDisplaySettings()
		}
	},
	{
		name = function() {
			return gvLangObj["options-aspects"]["ultra"]
		}
		func = function() {
			config.aspect = 3
			fileWrite("config.json", jsonWrite(config))
			updateDisplaySettings()
		}
	},
	{
		name = function() {
			return gvLangObj["menu-commons"]["back"]
		}
		func = function() {
			menu = meOptions
		}
	}
]
}

meAccessibility <- {
	size = menuLarge
	back = function() {
		menu = meOptions
	}
	items = [
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.light ? "on" : "off"]
				return format(gvLangObj["options-menu"]["light"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["light"]
			}
			func = function() {
				config.light = !config.light; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.weather ? "on" : "off"]
				return format(gvLangObj["options-menu"]["weather"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["weather"]
			}
			func = function() {
				config.weather = !config.weather; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.nearbars ? "on" : "off"]
				return format(gvLangObj["options-menu"]["nearbars"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["nearbars"]
			}
			func = function() {
				config.nearbars = !config.nearbars; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.bigItems ? "on" : "off"]
				return format(gvLangObj["options-menu"]["big-items"], val)
			},
			desc = function() {
				return gvLangObj["options-menu-desc"]["big-items"]
			}
			func = function() {
				config.bigItems = !config.bigItems; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meOptions
			}
		}
	]
}

meInput <- {
	size = menuLarge
	back = function() {
		menu = meOptions
		fileWrite("config.json", jsonWrite(config))
	}
	items = [
		{
			name = function() {
				return gvLangObj["options-menu"]["keyboard"]
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["keyboard"]
			}
			func = function() {
				menu = meKeybinds
			}
		},
		{
			name = function() {
				return gvLangObj["options-menu"]["joystick1"]
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["joystick"]
			}
			func = function() {
				menu = meJoyBinds
			}
		},
		{
			name = function() {
				return gvLangObj["options-menu"]["joystick2"]
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["joystick"]
			}
			func = function() {
				menu = meJoyBinds2
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.rumble ? "on" : "off"]
				return format(gvLangObj["options-menu"]["rumble"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["rumble"]
			}
			func = function() {
				config.rumble = !config.rumble; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.showcursor ? "on" : "off"]
				return format(gvLangObj["options-menu"]["cursor"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["cursor"]
			}
			func = function() {
				config.showcursor = !config.showcursor; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.stickspeed ? "on" : "off"]
				return format(gvLangObj["options-menu"]["stickspeed"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["stickspeed"]
			}
			func = function() {
				config.stickspeed = !config.stickspeed; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.stickactive ? "on" : "off"]
				return format(gvLangObj["options-menu"]["stickactive"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["stickactive"]
			}
			func = function() {
				config.stickactive = !config.stickactive; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				local val = gvLangObj["menu-commons"][config.stickcam ? "on" : "off"]
				return format(gvLangObj["options-menu"]["stickcam"], val)
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["stickcam"]
			}
			func = function() {
				config.stickcam = !config.stickcam; fileWrite("config.json", jsonWrite(config))
			}
		},
		{
			name = function() {
				return format(gvLangObj["options-menu"]["mapspeed"], gvLangObj["controls-menu"]["mapspeed"][config.mapspeed.tostring()])
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["mapspeed"]
			}
			func = function() {
				menu = meMapSpeed
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meOptions
			}
		}
	]
}

meMapSpeed <- {
	size = menuLarge
	back = function() {
		menu = meInput
	}
	items = [
		{
			name = function() {
				return gvLangObj["controls-menu"]["mapspeed"]["1"]
			}
			func = function() {
				config.mapspeed = 1; fileWrite("config.json", jsonWrite(config)); menu = meInput
			}
		},
		{
			name = function() {
				return gvLangObj["controls-menu"]["mapspeed"]["2"]
			}
			func = function() {
				config.mapspeed = 2; fileWrite("config.json", jsonWrite(config)); menu = meInput
			}
		},
		{
			name = function() {
				return gvLangObj["controls-menu"]["mapspeed"]["4"]
			}
			func = function() {
				config.mapspeed = 4; fileWrite("config.json", jsonWrite(config)); menu = meInput
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meInput
				fileWrite("config.json", jsonWrite(config))
			}
		}
	]
}

meAudio <- {
	size = menuLarge
	back = function() {
		menu = meOptions
		fileWrite("config.json", jsonWrite(config))
	}
	items = [
		{
			name = function() {
				return gvLangObj["options-menu"]["sound-volume"]
			}
			desc = function() {
				if(getcon("left", "press", false, 0, false) && getSoundVolume() > 0) {
					config.soundVolume -= 8
					setSoundVolume(config.soundVolume)
					popSound(sndMenuMove, 0)
				}
				if(getcon("right", "press", false, 0, false) && getSoundVolume() < 128) {
					config.soundVolume += 8
					setSoundVolume(config.soundVolume)
					popSound(sndMenuMove, 0)
				}

				local vol = "VOL: ["
				for(local i = 0; i < 16; i++) {
					if(i < getSoundVolume() / 8) vol += chint(8)
					else vol += chint(7)
				}
				vol += "] (<-/->)"
				return vol
			},
			func = function() {}
		},
		{
			name = function() {
				return gvLangObj["options-menu"]["music-volume"]
			}
			desc = function() {
				if(getcon("left", "press", false, 0, false) && getMusicVolume() > 0) {
					config.musicVolume -= 8
					setMusicVolume(config.musicVolume)
					popSound(sndMenuMove, 0)
				}
				if(getcon("right", "press", false, 0, false) && getMusicVolume() < 128) {
					config.musicVolume += 8
					setMusicVolume(config.musicVolume)
					popSound(sndMenuMove, 0)
				}

				local vol = "VOL: ["
				for(local i = 0; i < 16; i++) {
					if(i < getMusicVolume() / 8) vol += chint(8)
					else vol += chint(7)
				}
				vol += "] (<-/->)"
				return vol
			},
			func = function() {}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meOptions
			}
			back = function() {
				menu = meOptions
				fileWrite("config.json", jsonWrite(config))
			}
		}
	]
}

meKeybinds <- {
	size = menuLarge
	back = function() {
		menu = meInput
	}
	items = [
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["up"], getConName("up", true, false))
			}
			func = function() {
				rebindKeys(0)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["down"], getConName("down", true, false))
			}
			func = function() {
				rebindKeys(1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["left"], getConName("left", true, false))
			}
			func = function() {
				rebindKeys(2)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["right"], getConName("right", true, false))
			}
			func = function() {
				rebindKeys(3)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["jump"], getConName("jump", true, false))
			}
			func = function() {
				rebindKeys(4)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["shoot"], getConName("shoot", true, false))
			}
			func = function() {
				rebindKeys(5)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["spec1"], getConName("spec1", true, false))
			}
			func = function() {
				rebindKeys(6)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["spec2"], getConName("spec2", true, false))
			}
			func = function() {
				rebindKeys(7)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["pause"], getConName("pause", true, false))
			}
			func = function() {
				rebindKeys(8)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["item-swap"], getConName("swap", true, false))
			}
			func = function() {
				rebindKeys(9)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["menu-accept"], getConName("accept", true, false))
			}
			func = function() {
				rebindKeys(10)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-left-peek"], getConName("leftPeek", true, false))
			}
			func = function() {
				rebindKeys(11)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-right-peek"], getConName("rightPeek", true, false))
			}
			func = function() {
				rebindKeys(12)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-down-peek"], getConName("downPeek", true, false))
			}
			func = function() {
				rebindKeys(13)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-up-peek"], getConName("upPeek", true, false))
			}
			func = function() {
				rebindKeys(14)
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meInput
				fileWrite("config.json", jsonWrite(config))
			}
		}
	]
}

meJoyBinds <- {
	size = menuLarge
	back = function() {
		menu = meInput
		fileWrite("config.json", jsonWrite(config))
	}
	items = [
		{
			name = function() {
				return format(gvLangObj["options-menu"]["joymode"], config.joymode)
			}
			func = function() {
				local newMode = gvPadTypes.find(config.joymode)
				if(newMode == null)
					newMode = 0
				else
					newMode++

				newMode = wrap(newMode, 0, gvPadTypes.len() - 1)
				config.joymode = gvPadTypes[newMode]
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["jump"], config.joy.jump != -1 ? getConName("jump", false) : "")
			}
			func = function() {
				rebindGamepad(4)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["shoot"], config.joy.shoot != -1 ? getConName("shoot", false) : "")
			}
			func = function() {
				rebindGamepad(5)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["spec1"], config.joy.spec1 != -1 ? getConName("spec1", false) : "")
			}
			func = function() {
				rebindGamepad(6)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["spec2"], config.joy.spec2 != -1 ? getConName("spec2", false) : "")
			}
			func = function() {
				rebindGamepad(7)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["pause"], config.joy.shoot != -1 ? getConName("pause", false) : "")
			}
			func = function() {
				rebindGamepad(8)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["item-swap"], config.joy.swap != -1 ? getConName("swap", false) : "")
			}
			func = function() {
				rebindGamepad(9)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["menu-accept"], config.joy.accept != -1 ? getConName("accept", false) : "")
			}
			func = function() {
				rebindGamepad(10)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-left-peek"], config.joy.leftPeek != -1 ? getConName("leftPeek", false) : "")
			}
			func = function() {
				rebindGamepad(11)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-right-peek"], config.joy.rightPeek != -1 ? getConName("rightPeek", false) : "")
			}
			func = function() {
				rebindGamepad(12)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-down-peek"], config.joy.downPeek != -1 ? getConName("downPeek", false) : "")
			}
			func = function() {
				rebindGamepad(13)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-up-peek"], config.joy.upPeek != -1 ? getConName("upPeek", false) : "")
			}
			func = function() {
				rebindGamepad(14)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-peek-x"], config.joy.xPeek.tostring())
			}
			func = function() {
				rebindJoyPeek(0)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-peek-y"], config.joy.yPeek.tostring())
			}
			func = function() {
				rebindJoyPeek(1)
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meInput
				fileWrite("config.json", jsonWrite(config))
			}
		}
	]
}

meJoyBinds2 <- {
	size = menuLarge
	back = function() {
		menu = meInput
		fileWrite("config.json", jsonWrite(config))
	}
	items = [
		{
			name = function() {
				return format(gvLangObj["options-menu"]["joymode"], config.joymode)
			}
			func = function() {
				local newMode = gvPadTypes.find(config.joymode)
				if(newMode == null)
					newMode = 0
				else newMode++
				newMode = wrap(newMode, 0, gvPadTypes.len() - 1)
				config.joymode = gvPadTypes[newMode]
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["jump"], config.joy2.jump != -1 ? getConName("jump", false) : "")
			}
			func = function() {
				rebindGamepad(4, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["shoot"], config.joy2.shoot != -1 ? getConName("shoot", false) : "")
			}
			func = function() {
				rebindGamepad(5, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["spec1"], config.joy2.spec1 != -1 ? getConName("spec1", false) : "")
			}
			func = function() {
				rebindGamepad(6, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["spec2"], config.joy2.spec2 != -1 ? getConName("spec2", false) : "")
			}
			func = function() {
				rebindGamepad(7, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["pause"], config.joy2.shoot != -1 ? getConName("pause", false) : "")
			}
			func = function() {
				rebindGamepad(8, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["item-swap"], config.joy2.swap != -1 ? getConName("swap", false) : "")
			}
			func = function() {
				rebindGamepad(9, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["menu-accept"], config.joy2.accept != -1 ? getConName("accept", false) : "")
			}
			func = function() {
				rebindGamepad(10, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-left-peek"], config.joy2.leftPeek != -1 ? getConName("leftPeek", false) : "")
			}
			func = function() {
				rebindGamepad(11, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-right-peek"], config.joy2.rightPeek != -1 ? getConName("rightPeek", false) : "")
			}
			func = function() {
				rebindGamepad(12, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-down-peek"], config.joy2.downPeek != -1 ? getConName("downPeek", false) : "")
			}
			func = function() {
				rebindGamepad(13, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-up-peek"], config.joy2.upPeek != -1 ? getConName("upPeek", false) : "")
			}
			func = function() {
				rebindGamepad(14, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-peek-x"], config.joy2.xPeek.tostring())
			}
			func = function() {
				rebindJoyPeek(0, 1)
			}
		},
		{
			name = function() {
				return format(gvLangObj["controls-menu"]["cam-peek-y"], config.joy2.yPeek.tostring())
			}
			func = function() {
				rebindJoyPeek(1, 1)
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meInput
				fileWrite("config.json", jsonWrite(config))
			}
		}
	]
}

meSpeedrun <- {
	size = menuLarge
	back = function() {
		menu = meOptions
		fileWrite("config.json", jsonWrite(config))
	}
	items = [
		{
			name = function() {
				return format(gvLangObj["speedrun-menu"]["speedrun-timer-level"], config.showleveligt ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"])
			}
			func = function() {
				config.showleveligt = !config.showleveligt
			}
		},
		{
			name = function() {
				return format(gvLangObj["speedrun-menu"]["speedrun-timer-global"], config.showglobaligt ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"])
			}
			func = function() {
				config.showglobaligt = !config.showglobaligt
			}
		},
		{
			name = function() {
				return format(gvLangObj["options-menu"]["showkeys"], config.showkeys ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"])
			}
			func = function() {
				config.showkeys = !config.showkeys
			}
		},
		{
			name = function() {
				return format(gvLangObj["options-menu"]["completion"], config.completion ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"])
			}
			func = function() {
				config.completion = !config.completion
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["completion"]
			}
		},
		{
			name = function() {
				return format(gvLangObj["options-menu"]["usebeam"], config.useBeam ? gvLangObj["bool"]["on"] : gvLangObj["bool"]["off"])
			}
			func = function() {
				config.useBeam = !config.useBeam
			}
			desc = function() {
				return gvLangObj["options-menu-desc"]["usebeam"]
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["back"]
			}
			func = function() {
				menu = meOptions
			}
		}
	]
}

meDifficulty <- {
	size = menuLarge
	back = function() {
		menu = meMain
	}
	items = [
		{
			name = function() {
				return gvLangObj["difficulty-levels"]["easy"]
			}
			func = function() {
				game.difficulty = 0
				if(gvTimeAttack) newTimeAttack()
				else menu = meNewGame
			}
		},
		{
			name = function() {
				return gvLangObj["difficulty-levels"]["normal"]
			}
			func = function() {
				game.difficulty = 1
				if(gvTimeAttack) newTimeAttack()
				else menu = meNewGame
			}
		},
		{
			name = function() {
				return gvLangObj["difficulty-levels"]["hard"]
			}
			func = function() {
				game.difficulty = 2
				if(gvTimeAttack) newTimeAttack()
				else menu = meNewGame
			}
		},
		{
			name = function() {
				return gvLangObj["difficulty-levels"]["super"]
			}
			func = function() {
				game.difficulty = 3
				if(gvTimeAttack) newTimeAttack()
				else menu = meNewGame
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["cancel"]
			}
			func = function() {
				menu = meMain
			}
		}
	]
}

meNewGame <- {
	size = menuLarge
	back = function() {
		menu = meDifficulty
	}
	items = [
		{
			name = function() {
				local m = "File 0"
				if(fileExists("save/0.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
				return m
			}
			func = function() {
				game.file = 0
				if(fileExists("save/0.json")) menu = meOverwrite
				else menu = meNewGameOptions
			}
		},
		{
			name = function() {
				local m = "File 1"
				if(fileExists("save/1.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
				return m
			}
			func = function() {
				game.file = 1
				if(fileExists("save/1.json")) menu = meOverwrite
				else menu = meNewGameOptions
			}
		},
		{
			name = function() {
				local m = "File 2"
				if(fileExists("save/2.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
				return m
			}
			func = function() {
				game.file = 2
				if(fileExists("save/2.json")) menu = meOverwrite
				else menu = meNewGameOptions
			}
		},
		{
			name = function() {
				local m = "File 3"
				if(fileExists("save/3.json")) m += " " + gvLangObj["new-game-menu"]["file-exists"]
				return m
			}
			func = function() {
				game.file = 3
				if(fileExists("save/3.json")) menu = meOverwrite
				else menu = meNewGameOptions
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["cancel"]
			}
			func = function() {
				menu = meDifficulty
			}
		}
	]
}

meNewGameOptions <- {
	size = menuLarge
	back = function() {
		menu = meNewGame
	}
	items = [
		{
			name = function() {
				return gvLangObj["new-game-menu"]["begin"]
			}
			func = function() {
				newGame(game.file)
			}
		},
		{
			name = function() {
				return gvLangObj["time-attack-menu"]["random-level"] + ": " + gvLangObj["menu-commons"][gvTARandomLevel ? "on" : "off"]
			}
			func = function() {
				gvTARandomLevel = !gvTARandomLevel
			}
		},
		{
			name = function() {
				return gvLangObj["time-attack-menu"]["random-char"] + ": " + gvLangObj["menu-commons"][gvTARandomPlayer ? "on" : "off"]
			}
			func = function() {
				gvTARandomPlayer = !gvTARandomPlayer
			}
		},
		{
			name = function() {
				return gvLangObj["time-attack-menu"]["random-item"] + ": " + gvLangObj["menu-commons"][gvTARandomItem ? "on" : "off"]
			}
			func = function() {
				gvTARandomItem = !gvTARandomItem
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["cancel"]
			}
			func = function() {
				menu = meNewGame
			}
		}
	]
}

meOverwrite <- {
	size = menuLarge
	back = function() {
		menu = meNewGame
	},
	items = [
		{
			name = function() {
				drawText(menu.size.f, screenW() / 2 - (15 * 4), screenH() / 2, "Overwrite save?"); return gvLangObj["menu-commons"]["no"]
			}
			func = function() {
				menu = meNewGame
			}
		},
		{
			name = function() {
				return gvLangObj["menu-commons"]["yes"]
			}
			func = function() {
				menu = meNewGameOptions
			}
		}
	]
}

meLoadGame <- {}
// This menu is left empty intentionally; it will be created dynamically at runtime.
