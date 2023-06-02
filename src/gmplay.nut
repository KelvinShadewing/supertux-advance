/*=========*\
| PLAY MODE |
\*=========*/

::gvInfoBox <- ""
::gvInfoLast <- ""
::gvInfoStep <- 0
::gvLangObj <- ""
::gvFadeInTime <- 255
::gvVoidFog <- true
::gvCanWrap <- false

::mapActor <- {} //Stores references to all actors created by the map

::startPlay <- function(level, newLevel = true, skipIntro = false) {
	if(!fileExists(level)) return

	//Clear actors and start creating new ones
	setFPS(60)
	gvPlayer = false
	gvPlayer2 = false
	gvBoss = false
	gvExitTimer = 0.0
	deleteAllActors()
	if(newLevel) {
		game.ps1.health = game.maxHealth
		game.ps2.health = game.maxHealth
		game.levelCoins = 0
		game.maxCoins = 0
		game.redCoins = 0
		game.maxRedCoins = 0
		game.secrets = 0
		game.maxSecrets = 0
		game.enemies = 0
		game.maxEnemies = 0
		gvInfoBox = ""
		gvLastSong = ""
		gfxReset()
		gvFadeInTime = 255
		gvNextLevel = ""
		gvVoidFog = true
		gvCanWrap = false
	}

	//Reset auto/locked controls
	autocon = clone(defAutocon)

	//Reset keys
	if(!game.check) {
		gvKeyCopper = false
		gvKeySilver = false
		gvKeyGold = false
		gvKeyMythril = false
	}

	//Load map to play
	if(gvMap != 0) gvMap.del()
	gvMap = Tilemap(level)

	gvHorizon = gvMap.h

	//Get tiles used to mark actors
	local actset = -1
	local tilef = 0
	local actnum = -1
	for(local i = 0; i < gvMap.tileset.len(); i++) {
		if(spriteName(gvMap.tileset[i]) == "actors.png") {
			actset = gvMap.tileset[i]
			tilef = gvMap.tilef[i]
			actnum = i
			break
		}
	}
	if(actset == -1) {
		print("Map does not use actors.png. No actors to load.")
		return
	}

	//Get layer for actors
	local actlayer = -1
	foreach(i in gvMap.data.layers) {
		if(i["type"] == "objectgroup" && i["name"] == "actor") {
			actlayer = i
			break
		}
	}

	if(actlayer == -1) {
		print("Map does not have an actor layer. No actors to load.")
		return
	}

	//Start making actors
	foreach(i in actlayer.objects) {
		//Tile actors
		if(i.rawin("gid")) {
			local n = i.gid - tilef
			local c = 0

			//Get the tile number and make an actor
			//according to the image used in actors.png
			switch(spriteName(gvMap.tileset[actnum])) {
				case "actors.png":
					c = createPlatformActors(n, i, c)
					break
				case "raceactors.png":
					c = createRacerActors(n, i, c)
					break
			}

			if(typeof c == "integer") mapActor[i.id] <- c
			else mapActor[i.id] <- c.id
		}

		//Rectangle actors
		if(!i.rawin("polygon") && !i.rawin("polyline") && !i.rawin("ellipse") && !i.rawin("point") && !i.rawin("gid")) if(i.name != "") {
			local c = 0
			local arg = split(i.name, ",")
			local n = arg[0]
			arg.remove(0)
			if(arg.len() == 1) arg = arg[0]
			else if(arg.len() == 0) arg = null
			if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") {
				print(i.x + " - " + i.y)
				c = newActor(getroottable()[n], i.x + (i.width / 2.0), i.y + (i.height / 2.0), arg)
				actor[c].w = i.width / 2.0
				actor[c].h = i.height / 2.0
				mapActor[i.id] <- c
			}
		}

		//Polygon actors
		if(i.rawin("polygon")) if(i.name != "") {
			local arg = split(i.name, ",")
			local n = arg[0]
			if(getroottable().rawin(n)) {
				//Create polygon to pass to object
				local poly = []
				for(local j = 0; j <= i.polygon.len(); j++) {
					if(j == i.polygon.len()) poly.push([i.x + i.polygon[0].x, i.y + i.polygon[0].y])
					else poly.push([i.x + i.polygon[j].x, i.y + i.polygon[j].y])
				}

				arg[0] = poly
				local c
				if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") {
					c = newActor(getroottable()[n], i.x, i.y, arg)
					mapActor[i.id] <- c
				}
			}
		}

		//Polygon actors
		if(i.rawin("polyline")) if(i.name != "") {
			local arg = split(i.name, ",")
			local n = arg[0]
			if(getroottable().rawin(n)) {
				//Create polygon to pass to object
				local poly = []
				for(local j = 0; j < i.polyline.len(); j++) poly.push([i.x + i.polyline[j].x, i.y + i.polyline[j].y])

				arg[0] = poly
				local c
				if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") {
					c = newActor(getroottable()[n], i.x, i.y, arg)
					mapActor[i.id] <- c
				}
			}
		}
	}

	//Other shape layers
	for(local i = 0; i < gvMap.data.layers.len(); i++) {
		if(gvMap.data.layers[i].type == "objectgroup") {
			local lana = gvMap.data.layers[i].name //Layer name
			for(local j = 0; j < gvMap.data.layers[i].objects.len(); j++) {
				local obj = gvMap.data.layers[i].objects[j]
				switch(lana) {
					case "trigger":
						if("polyline" in obj || "polygon" in obj || "ellipse" in obj) break
						local c = newActor(Trigger, obj.x + (obj.width / 2), obj.y + (obj.height / 2))
						actor[c].shape = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 0)
						actor[c].code = obj.name
						actor[c].w = obj.width / 2
						actor[c].h = obj.height / 2
						break
					case "water":
					if("polyline" in obj || "polygon" in obj || "ellipse" in obj) break
						local c = newActor(Water, obj.x + (obj.width / 2), obj.y + (obj.height / 2))
						actor[c].shape = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, (obj.height / 2) - 4, 5)
						break
					case "secret":
						if("polyline" in obj || "polygon" in obj || "ellipse" in obj) break
						local c = actor[newActor(SecretWall, obj.x, obj.y, obj.name)]
						c.dw = obj.width / 16
						c.dh = obj.height / 16
						c.shape = Rec(c.x + (c.dw * 8), c.y + (c.dh * 8), -4 + (c.dw * 8), -4 + (c.dh * 8), 5)
						break
				}
			}
		}
	}

	//Search for secret wall joiners
	for(local i = 0; i < gvMap.data.layers.len(); i++) {
		if(gvMap.data.layers[i].type == "objectgroup") {
			local lana = gvMap.data.layers[i].name //Layer name
			for(local j = 0; j < gvMap.data.layers[i].objects.len(); j++) {
				local obj = gvMap.data.layers[i].objects[j]
				switch(lana) {
					case "secret":
						if(!("polyline" in obj || "polygon" in obj)) break
						local poly = []

						if("polyline" in obj) for(local j = 0; j < obj.polyline.len(); j++) poly.push([obj.x + obj.polyline[j].x, obj.y + obj.polyline[j].y])
						else for(local j = 0; j < obj.polygon.len(); j++) poly.push([obj.x + obj.polygon[j].x, obj.y + obj.polygon[j].y])

						local c = newActor(SecretJoiner, obj.x, obj.y, poly)
						mapActor[obj.id] <- c
						break
				}
			}
		}
	}

	if(gvPlayer) {
		camx0 = gvPlayer.x - (gvScreenW / 2)
		camy0 = gvPlayer.y - (gvScreenH / 2)
	}
	else {
		camx0 = 0
		camy0 = 0
	}


	//If the map loading fails at any point, then it will not change
	//the mode and simply remain where it was. A message is printed
	//in the log if the map fails, so users can check why a level
	//refuses to run.

	//Execute level code
	print("Running level code...")
	if(gvMap.data.rawin("properties")) foreach(i in gvMap.data.properties) {
		if(i.name == "code") dostr(i.value)
		if(i.name == "author") gvMap.author = i.value
	}
	print("End level code")

	drawBG2 = drawBG
	drawWeather2 = drawWeather
	gvLightTarget2 = gvLightTarget
	gvLight = gvLightTarget
	gvLight2 = gvLightTarget2

	setDrawTarget(bgPause)
	drawImage(gvScreen, 0, 0)

	if(newLevel) { //Iris transition
		setDrawColor(0x000000ff)

		for(local i = 0.0; i <= 100; i += 4.0) {
			setDrawTarget(gvScreen)
			drawImage(bgPause, 0, 0)

			local di = i / 100.0
			local dx = (1.0 / 240.0) * gvScreenW.tofloat()
			local dy = (1.0 / 240.0) * gvScreenH.tofloat()

			if(config.light && gvGameMode == gmOverworld) drawAmbientLight()

			drawSprite(sprIris, 0, gvScreenW / 2, gvScreenH / 2, 0, 0, dx * (1.0 - di), dy * (1.0 - di))
			drawRec(0, 0, gvScreenW * (di / 2.0), gvScreenH, true)
			drawRec(gvScreenW, 0, -(gvScreenW * (di / 2.0)) - 2, gvScreenH, true)
			drawRec(0, 0, gvScreenW, gvScreenH * (di / 2.0), true)
			drawRec(0, gvScreenH, gvScreenW, -(gvScreenH * (di / 2.0)) - 2, true)

			resetDrawTarget()
			drawImage(gvScreen, 0, 0)
			update()

			if(getcon("pause", "press")) break
		}

		gvFadeInTime = 255
	}

	//Switch game mode to play
	if(skipIntro) gvGameMode = gmPlay
	else gvGameMode = gmLevelStart

	//update()
}

::gmLevelStart <- function() {
	setDrawTarget(gvScreen)
	setDrawColor(0x000000ff)
	drawRec(0, 0, gvScreenW, gvScreenH, true)

	if(gvLangObj["level"].rawin(gvMap.name)) drawText(font2, (gvScreenW / 2) - (gvLangObj["level"][gvMap.name].len() * 4), 8, gvLangObj["level"][gvMap.name])

	local charx = 0
	if(game.playerChar2 != 0 && game.playerChar2 != "") {
		charx = 32

		local runAnim = getroottable()[game.playerChar2].an["run"]
		switch(game.ps2.weapon) {
			case "normal":
				drawSprite(getroottable()[gvCharacters[game.playerChar2]["normal"]], runAnim[(getFrames() / 4) % runAnim.len()], (gvScreenW / 2) - charx, gvScreenH / 2)
				break
			case "fire":
				drawSprite(getroottable()[gvCharacters[game.playerChar2]["fire"]], runAnim[(getFrames() / 4) % runAnim.len()], (gvScreenW / 2) - charx, gvScreenH / 2)
				break
			case "ice":
				drawSprite(getroottable()[gvCharacters[game.playerChar2]["ice"]], runAnim[(getFrames() / 4) % runAnim.len()], (gvScreenW / 2) - charx, gvScreenH / 2)
				break
			case "air":
				drawSprite(getroottable()[gvCharacters[game.playerChar2]["air"]], runAnim[(getFrames() / 4) % runAnim.len()], (gvScreenW / 2) - charx, gvScreenH / 2)
				break
			case "earth":
				drawSprite(getroottable()[gvCharacters[game.playerChar2]["earth"]], runAnim[(getFrames() / 4) % runAnim.len()], (gvScreenW / 2) - charx, gvScreenH / 2)
				break
			default:
				drawSprite(getroottable()[gvCharacters[game.playerChar2]["normal"]], runAnim[(getFrames() / 4) % runAnim.len()], (gvScreenW / 2) - charx, gvScreenH / 2)
		}
	}

	local runAnim = getroottable()[game.playerChar].an["run"]
	switch(game.ps1.weapon) {
		case "normal":
			drawSprite(getroottable()[gvCharacters[game.playerChar]["normal"]], runAnim[(getFrames() / 4) % runAnim.len()], charx + gvScreenW / 2, gvScreenH / 2)
			break
		case "fire":
			drawSprite(getroottable()[gvCharacters[game.playerChar]["fire"]], runAnim[(getFrames() / 4) % runAnim.len()], charx + gvScreenW / 2, gvScreenH / 2)
			break
		case "ice":
			drawSprite(getroottable()[gvCharacters[game.playerChar]["ice"]], runAnim[(getFrames() / 4) % runAnim.len()], charx + gvScreenW / 2, gvScreenH / 2)
			break
		case "air":
			drawSprite(getroottable()[gvCharacters[game.playerChar]["air"]], runAnim[(getFrames() / 4) % runAnim.len()], charx + gvScreenW / 2, gvScreenH / 2)
			break
		case "earth":
			drawSprite(getroottable()[gvCharacters[game.playerChar]["earth"]], runAnim[(getFrames() / 4) % runAnim.len()], charx + gvScreenW / 2, gvScreenH / 2)
			break
		default:
			drawSprite(getroottable()[gvCharacters[game.playerChar]["normal"]], runAnim[(getFrames() / 4) % runAnim.len()], charx + gvScreenW / 2, gvScreenH / 2)
	}

	local author = gvLangObj["stats"]["author"] + ": " + gvMap.author
	drawText(font, (gvScreenW / 2) - author.len() * 3, gvScreenH - 64, author)

	local bt = gvLangObj["stats"]["time"] + ": "
	if(game.bestTime.rawin(gvMap.name + "-" + game.playerChar)) bt += formatTime(game.bestTime[gvMap.name + "-" + game.playerChar])
	else bt += "0:00.00"
	bt += " (" + gvCharacters[game.playerChar].shortname + ")"
	drawText(font, (gvScreenW / 2) - bt.len() * 3, gvScreenH - 56, bt)

	local bc = gvLangObj["stats"]["coins"] + ": "
	if(game.bestCoins.rawin(gvMap.name)) bc += game.bestCoins[gvMap.name] + " / " + game.maxCoins
	else bc += "0 / " + game.maxCoins
	drawText(font, (gvScreenW / 2) - bc.len() * 3, gvScreenH - 48, bc)

	local be = gvLangObj["stats"]["enemies"] + ": "
	if(game.bestEnemies.rawin(gvMap.name)) be += game.bestEnemies[gvMap.name] + " / " + game.maxEnemies
	else be += "0 / " + game.maxEnemies
	drawText(font, (gvScreenW / 2) - be.len() * 3, gvScreenH - 40, be)

	local bs = gvLangObj["stats"]["secrets"] + ": "
	if(game.bestSecrets.rawin(gvMap.name)) bs += game.bestSecrets[gvMap.name] + " / " + game.maxSecrets
	else bs += "0 / " + game.maxSecrets
	drawText(font, (gvScreenW / 2) - bs.len() * 3, gvScreenH - 32, bs)

	resetDrawTarget()
	drawImage(gvScreen, 0, 0)

	if(getcon("jump", "press") || getcon("shoot", "press") || getcon("pause", "press") || getcon("accept", "press")) gvGameMode = gmPlay
}

::gmPlay <- function() {
	//Exit timer
	if(gvExitTimer > 0)
		gvExitTimer -= 0.5
	if(gvExitTimer < 0)
		gvExitTimer = 0
	if(gvExitTimer > 30 && !gvTimeAttack)
		startOverworld(game.world)

	updateCamera()

	//Draw
	//Separate texture for game world allows post-processing effects without including HUD
	runActors()
	//Run level step code
	if("properties" in gvMap.data) foreach(i in gvMap.data.properties) {
		if(i.name == "run") dostr(i.value)
	}

	////////////////
	// CAMERA 0/1 //
	////////////////
	if(gvSplitScreen) {
		camx = camx1
		camy = camy1
	}
	else {
		camx = camx0
		camy = camy0
	}

	gvLightScreen = gvLightScreen1
	setDrawTarget(gvPlayScreen)
	runAmbientLight()
	runAmbientLight(true)

	if(drawBG != 0) drawBG()
	if(drawWeather != 0 && config.weather) drawWeather()
	camxprev = camx
	camyprev = camy

	gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "bg")
	gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "mg")
	if(gvMap.name != "shop" && gvVoidFog) for(local i = 0; i < (gvScreenW / 16) + 1; i++) {
		drawSprite(sprVoid, 0, 0 + (i * 16), gvMap.h - 32 - camy)
	}
	foreach(i in actor) if("draw" in i && typeof i.draw == "function" && typeof i != "Water") i.draw()
	drawZList(8)
	if(actor.rawin("Water")) foreach(i in actor["Water"]) { i.draw() }
	drawAmbientLight()
	if(config.light) gvMap.drawTilesMod(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "fg", 1, 1, 1, gvLight)
	else gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "fg")
	if(actor.rawin("SecretWall")) foreach(i in actor["SecretWall"]) { i.draw() }
	if(actor.rawin("SecretJoiner")) foreach(i in actor["SecretJoiner"]) { i.draw() }
	if(debug) gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16), floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "solid")

	//////////////
	// CAMERA 2 //
	//////////////
	if(gvSplitScreen) {
		camx = camx2
		camy = camy2

		gvLightScreen = gvLightScreen2
		setDrawTarget(gvPlayScreen2)

		if(drawBG2 != 0) drawBG2()
		if(drawWeather2 != 0 && config.weather) drawWeather2()
		camxprev = camx
		camyprev = camy

		gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "bg")
		gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "mg")
		if(gvMap.name != "shop" && gvVoidFog) for(local i = 0; i < (gvScreenW / 16) + 1; i++) {
			drawSprite(sprVoid, 0, 0 + (i * 16), gvMap.h - 32 - camy)
		}
		foreach(i in actor) if("draw" in i && typeof i.draw == "function") i.draw()
		drawZList(8)
		if(actor.rawin("Water")) foreach(i in actor["Water"]) { i.draw() }
		drawAmbientLight()
		if(config.light) gvMap.drawTilesMod(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "fg", 1, 1, 1, gvLight2)
		else gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "fg")
		if(actor.rawin("SecretWall")) foreach(i in actor["SecretWall"]) { i.draw() }
		if(actor.rawin("SecretJoiner")) foreach(i in actor["SecretJoiner"]) { i.draw() }
		if(debug) gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16), floor(camy / 16), (gvScreenW / 16) + 5, (gvScreenH / 16) + 2, "solid")
	}


	//Resume music after invincibility
	if(gvPlayer && gvPlayer2 && "invincible" in gvPlayer && "invincible" in gvPlayer2 && gvPlayer.invincible == 0 && gvPlayer2.invincible == 0
	|| gvPlayer && !gvPlayer2 && "invincible" in gvPlayer && gvPlayer.invincible == 0
	|| gvPlayer2 && !gvPlayer && "invincible" in gvPlayer2 && gvPlayer2.invincible == 0) songPlay(gvMusicName)

	//HUDs
	setDrawTarget(gvScreen)
	if(gvSwapScreen && gvSplitScreen) {
		drawImage(gvPlayScreen2, 0, 0)
		drawImage(gvPlayScreen, gvScreenW / 2, 0)
		drawSprite(sprDivBar, 0, gvScreenW / 2, 0)
	}
	else {
		drawImage(gvPlayScreen, 0, 0)
		if(gvSplitScreen) {
			drawImage(gvPlayScreen2, gvScreenW / 2, 0)
			drawSprite(sprDivBar, 0, gvScreenW / 2, 0)
		}
	}

	if(gvInfoBox != gvInfoLast) {
		gvInfoLast = gvInfoBox
		gvInfoStep = 0
	}

	if(gvInfoBox == "") {
		//Draw near-sighted stat bars
		if(config.nearbars) {
			if(!gvSplitScreen) {
				if(gvPlayer && "energy" in gvPlayer) drawFloatingStats(gvPlayer.x - camx0, gvPlayer.y - camy0, (1.0 / game.maxHealth) * game.ps1.health, 1, (1.0 / game.ps1.maxEnergy) * gvPlayer.energy)

				if(gvPlayer2 && "energy" in gvPlayer2) drawFloatingStats(gvPlayer2.x - camx0, gvPlayer2.y - camy0, (1.0 / game.maxHealth) * game.ps2.health, 1, (1.0 / game.ps2.maxEnergy) * gvPlayer2.energy)
			}
			else if(!gvSwapScreen) {
				if(gvPlayer && "energy" in gvPlayer) drawFloatingStats(gvPlayer.x - camx1, gvPlayer.y - camy1, (1.0 / game.maxHealth) * game.ps1.health, 1, (1.0 / game.ps1.maxEnergy) * gvPlayer.energy)

				if(gvPlayer2 && "energy" in gvPlayer2) drawFloatingStats(gvPlayer2.x - camx2 + (gvScreenW / 2), gvPlayer2.y - camy2, (1.0 / game.maxHealth) * game.ps2.health, 1, (1.0 / game.ps2.maxEnergy) * gvPlayer2.energy)
			}
			else {
				if(gvPlayer && "energy" in gvPlayer) drawFloatingStats(gvPlayer.x - camx1 + (gvScreenW / 2), gvPlayer.y - camy1, (1.0 / game.maxHealth) * game.ps1.health, 1, (1.0 / game.ps1.maxEnergy) * gvPlayer.energy)

				if(gvPlayer2 && "energy" in gvPlayer2) drawFloatingStats(gvPlayer2.x - camx2, gvPlayer2.y - camy2, (1.0 / game.maxHealth) * game.ps2.health, 1, (1.0 / game.ps2.maxEnergy) * gvPlayer2.energy)
			}
		}

		//Draw max energy
		for(local i = 0; i < 4 - game.difficulty; i++) {
			drawSprite(sprEnergy, 2, 8 + (16 * i), 24)
		}
		//Draw health
		if(game.ps1.health > game.maxHealth) game.ps1.health = game.maxHealth

		local fullhearts = floor(game.ps1.health / 4)

		for(local i = 0; i < game.maxHealth / 4; i++) {
			if(i < fullhearts) drawSprite(sprHealth, 4, 8 + (16 * i), 8)
			else if(i == fullhearts) drawSprite(sprHealth, ceil(game.ps1.health) % 4, 8 + (16 * i), 8)
			else drawSprite(sprHealth, 0, 8 + (16 * i), 8)
		}

		//Draw energy
		for(local i = 0; i < game.ps1.maxEnergy; i++) {
			if(gvPlayer) {
				if(gvPlayer.rawin("energy") && game.ps1.maxEnergy > 0) {
					if(i < floor(gvPlayer.energy)) switch(game.ps1.weapon) {
						case "normal":
							drawSprite(sprEnergy, 11, 8 + (16 * i), 24)
							break
						case "fire":
							drawSprite(sprEnergy, 3, 8 + (16 * i), 24)
							break
						case "ice":
							drawSprite(sprEnergy, 4, 8 + (16 * i), 24)
							break
						case "air":
							drawSprite(sprEnergy, 5, 8 + (16 * i), 24)
							break
						case "earth":
							drawSprite(sprEnergy, 6, 8 + (16 * i), 24)
							break
						case "water":
							drawSprite(sprEnergy, 7, 8 + (16 * i), 24)
							break
						case "shock":
							drawSprite(sprEnergy, 8, 8 + (16 * i), 24)
							break
						case "dark":
							drawSprite(sprEnergy, 9, 8 + (16 * i), 24)
							break
						case "light":
							drawSprite(sprEnergy, 10, 8 + (16 * i), 24)
							break
						default:
							drawSprite(sprEnergy, 1, 8 + (16 * i), 24)
							break
					}
					else drawSprite(sprEnergy, 0, 8 + (16 * i), 24)
				}
			}
		}

		//Draw second player stats
		if(gvNumPlayers >= 2) {
			//Draw max energy
			for(local i = 0; i < 4 - game.difficulty; i++) {
				drawSprite(sprEnergy, 2, 8 + (16 * i), 52)
			}
			//Draw health
			if(game.ps2.health > game.maxHealth) game.ps2.health = game.maxHealth

			local fullhearts = floor(game.ps2.health / 4)

			for(local i = 0; i < game.maxHealth / 4; i++) {
				if(i < fullhearts) drawSprite(sprHealth, 4, 8 + (16 * i), 36)
				else if(i == fullhearts) drawSprite(sprHealth, ceil(game.ps2.health) % 4, 8 + (16 * i), 36)
				else drawSprite(sprHealth, 0, 8 + (16 * i), 36)
			}

			//Draw energy
			for(local i = 0; i < game.ps2.maxEnergy; i++) {
				if(gvPlayer2) {
					if(gvPlayer2.rawin("energy") && game.ps2.maxEnergy > 0) {
						if(i < floor(gvPlayer2.energy)) switch(game.ps2.weapon) {
							case "normal":
								drawSprite(sprEnergy, 11, 8 + (16 * i), 52)
								break
							case "fire":
								drawSprite(sprEnergy, 3, 8 + (16 * i), 52)
								break
							case "ice":
								drawSprite(sprEnergy, 4, 8 + (16 * i), 52)
								break
							case "air":
								drawSprite(sprEnergy, 5, 8 + (16 * i), 52)
								break
							case "earth":
								drawSprite(sprEnergy, 6, 8 + (16 * i), 52)
								break
							case "water":
								drawSprite(sprEnergy, 7, 8 + (16 * i), 52)
								break
							case "shock":
								drawSprite(sprEnergy, 8, 8 + (16 * i), 52)
								break
							case "dark":
								drawSprite(sprEnergy, 9, 8 + (16 * i), 52)
								break
							case "light":
								drawSprite(sprEnergy, 10, 8 + (16 * i), 52)
								break
							default:
								drawSprite(sprEnergy, 1, 8 + (16 * i), 52)
								break
						}
						else drawSprite(sprEnergy, 0, 8 + (16 * i), 52)
					}
				}
			}
		}

		//Draw boss health
		if(gvBoss) {
			local fullhearts = floor(game.bossHealth / 4)
			if(game.bossHealth == 0) fullhearts = 0

			drawSprite(sprBossHealth, 6, gvScreenW - 23, gvScreenH - 88)
			drawSprite(sprSkull, 0, gvScreenW - 26, gvScreenH - 86)
			for(local i = 0; i < 10; i++) {
				if(i < fullhearts) drawSprite(sprBossHealth, 4, gvScreenW - 23, gvScreenH - 96 - (8 * i))
				else if(i == fullhearts && game.bossHealth > 0) drawSprite(sprBossHealth, game.bossHealth % 4, gvScreenW - 23, gvScreenH - 96 - (8 * i))
				else drawSprite(sprBossHealth, 0, gvScreenW - 23, gvScreenH - 96 - (8 * i))
			}
			drawSprite(sprBossHealth, 5, gvScreenW - 23, gvScreenH - 96 - (8 * 10))
		}

		//Draw coins & herrings
		drawSprite(sprCoin, 0, 16, gvScreenH - 16)
		if(game.maxCoins > 0) {
			if(gvTimeAttack && !config.completion) {
				if(levelEndRunner)
					drawText(font2, 24, gvScreenH - 23, game.coins.tostring())
				else
					drawText(font2, 24, gvScreenH - 23, (game.coins + game.levelCoins).tostring())
			}
			else
				drawText(font2, 24, gvScreenH - 23, game.levelCoins.tostring() + "/" + game.maxCoins.tostring())
			if(config.completion) {
				drawSprite(sprDeathcap, 0, 16, gvScreenH - 48)
				drawText(font2, 24, gvScreenH - 56, game.enemies.tostring() + "/" + game.maxEnemies.tostring())
				drawSprite(sprIcoSecret, 0, 16, gvScreenH - 32)
				drawText(font2, 24, gvScreenH - 40, game.secrets.tostring() + "/" + game.maxSecrets.tostring())
			}
		}
		else
			drawText(font2, 24, gvScreenH - 23, game.coins.tostring())
		//Herrings (redcoins)
		if(game.maxRedCoins > 0) drawSprite(sprHerring, 0, 16, gvScreenH - (config.completion ? 64 : 32))
		if(game.maxRedCoins > 0) drawText(font2, 24, gvScreenH - (config.completion ? 72 : 38), game.redCoins.tostring() + "/" + game.maxRedCoins.tostring())
		//Draw subitem
		drawSprite(sprSubItem, 0, gvScreenW - 18, 18)
		switch(game.ps1.subitem) {
			case "fire":
				drawSprite(sprFlowerFire, 0, gvScreenW - 18, 18)
				break
			case "ice":
				drawSprite(sprFlowerIce, 0, gvScreenW - 18, 18)
				break
			case "air":
				drawSprite(sprAirFeather, 0, gvScreenW - 18, 18)
				break
			case "earth":
				drawSprite(sprEarthShell, 0, gvScreenW - 18, 18)
				break
			case "muffinBlue":
				drawSprite(sprMuffin, 0, gvScreenW - 18, 18)
				break
			case "muffinRed":
				drawSprite(sprMuffin, 1, gvScreenW - 18, 18)
				break
			case "star":
				drawSprite(sprStar, 0, gvScreenW - 18, 18)
				break
			case "coffee":
				drawSprite(sprCoffee, 0, gvScreenW - 18, 17)
				break
		}
		if(gvNumPlayers >= 2) {
			drawSprite(sprSubItem, 1, gvScreenW - 18, 40)
			switch(game.ps2.subitem) {
				case "fire":
					drawSprite(sprFlowerFire, 0, gvScreenW - 18, 40)
					break
				case "ice":
					drawSprite(sprFlowerIce, 0, gvScreenW - 18, 40)
					break
				case "air":
					drawSprite(sprAirFeather, 0, gvScreenW - 18, 40)
					break
				case "earth":
					drawSprite(sprEarthShell, 0, gvScreenW - 18, 40)
					break
				case "muffinBlue":
					drawSprite(sprMuffin, 0, gvScreenW - 18, 40)
					break
				case "muffinRed":
					drawSprite(sprMuffin, 1, gvScreenW - 18, 40)
					break
				case "star":
					drawSprite(sprStar, 0, gvScreenW - 18, 40)
					break
				case "coffee":
					drawSprite(sprCoffee, 0, gvScreenW - 18, 39)
					break
			}
		}

		//Draw level IGT
		local timey = 0
		if(gvNumPlayers >= 2 && !gvNetPlay) timey = 32
		if(gvDoIGT && (config.showleveligt || gvTimeAttack) && levelEndRunner != 1) drawText(font2, 8, 32 + timey, formatTime(gvIGT))

		//Draw offscreen player
		if(!gvSplitScreen) {
			if(gvPlayer && gvPlayer.y < -8) {
				if(typeof gvPlayer in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer]["doll"]], enWeapons[game.ps1.weapon], gvPlayer.x - camx, 8 - (gvPlayer.y / 4))
			}
			if(gvPlayer2 && gvPlayer2.y < -8) {
				if(typeof gvPlayer2 in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer2]["doll"]], enWeapons[game.ps2.weapon], gvPlayer2.x - camx, 8 - (gvPlayer2.y / 4))
			}
		}
		else {
			if(gvSwapScreen) {
				if(gvPlayer && gvPlayer.y < -8) {
					if(typeof gvPlayer in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer]["doll"]], enWeapons[game.ps1.weapon], gvPlayer.x - camx1 + (gvScreenW / 2), 8 - (gvPlayer.y / 4))
				}
				if(gvPlayer2 && gvPlayer2.y < -8) {
					if(typeof gvPlayer2 in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer2]["doll"]], enWeapons[game.ps2.weapon], gvPlayer2.x - camx2, 8 - (gvPlayer2.y / 4))
				}
			}
			else {
				if(gvPlayer && gvPlayer.y < -8) {
					if(typeof gvPlayer in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer]["doll"]], enWeapons[game.ps1.weapon], gvPlayer.x - camx1, 8 - (gvPlayer.y / 4))
				}
				if(gvPlayer2 && gvPlayer2.y < -8) {
					if(typeof gvPlayer2 in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer2]["doll"]], enWeapons[game.ps2.weapon], gvPlayer2.x - camx2 + (gvScreenW / 2), 8 - (gvPlayer2.y / 4))
				}
			}
		}

		//Draw warning sign
		if(gvWarning < 180) {
			if(gvWarning == 0 || gvWarning == 90) {
				stopSound(sndWarning)
				playSound(sndWarning, 0)
			}
			drawSpriteEx(sprWarning, 0, gvScreenW / 2, gvScreenH / 2, 0, 0, 1, 1, abs(sin(gvWarning / 30.0)))
			gvWarning += 1.5
		}

		//Keys
		local kx = 10
		if(gvPlayer && "stats" in gvPlayer && gvPlayer.stats.canres) {
			if(typeof gvPlayer in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer]["doll"]], enWeapons[gvPlayer.stats.weapon], gvScreenW - kx, gvScreenH - 16)
			kx += 16
		}
		if(gvPlayer2 && "stats" in gvPlayer2 && gvPlayer2.stats.canres) {
			if(typeof gvPlayer2 in gvCharacters) drawSprite(getroottable()[gvCharacters[typeof gvPlayer2]["doll"]], enWeapons[gvPlayer2.stats.weapon], gvScreenW - kx, gvScreenH - 16)
			kx += 16
		}
		if(gvKeyCopper) {
			drawSprite(sprKeyCopper, 0, gvScreenW - kx, gvScreenH - 16)
			kx += 16
		}
		if(gvKeySilver) {
			drawSprite(sprKeySilver, 0, gvScreenW - kx, gvScreenH - 16)
			kx += 16
		}
		if(gvKeyGold) {
			drawSprite(sprKeyGold, 0, gvScreenW - kx, gvScreenH - 16)
			kx += 16
		}
		if(gvKeyMythril) {
			drawSprite(sprKeyMythril, 0, gvScreenW - kx, gvScreenH - 16)
			kx += 16
		}
		//Other items could be put in the row like this as well

		if(debug || config.showkeys || gvTimeAttack)
			displayKeys()
	}
	else {
		if(gvInfoStep < gvInfoBox.len()) gvInfoStep++
		local ln = 3
		for(local i = 0; i < gvInfoBox.len(); i++) {
			if(chint(gvInfoBox[i])  == "\n") ln++
		}
		setDrawColor(0x000000d0)
		drawRec(0, 0, gvScreenW, 8 * max(ln, 7), true)
		drawText(font, 8, 8, gvInfoBox.slice(0, gvInfoStep))
	}

	//Fade from black
	setDrawColor(gvFadeInTime)
	drawRec(0, 0, gvScreenW, gvScreenH, true)
	if(gvFadeInTime > 0) gvFadeInTime -= 10
	if(gvFadeInTime < 0) gvFadeInTime = 0

	drawDebug()

	if(levelEndRunner == 0 && (gvPlayer || gvPlayer2)) {
		gvIGT++
		game.igt++
	}

	//Draw global IGT
	if((config.showglobaligt || gvTimeAttack) && levelEndRunner != 1) {
		local gtd = formatTime(game.igt) //Game time to draw
		drawText(font2, (gvScreenW / 2) - (gtd.len() * 4), gvScreenH - 24, gtd)
	}

	checkAchievements()
	drawAchievements()

	//Draw exit timer
	local exside = (gvExitSide ? gvScreenW * 0.9 : gvScreenW * 0.1)
	if(gvExitTimer > 0) {
		drawSprite(sprExit, getFrames() / 16, exside, gvScreenH / 2, 0, gvExitSide)
		setDrawColor(0x101010ff)
		drawRec((exside) - 16, (gvScreenH / 2) + 12, 32, 4, true)
		setDrawColor(0xf8f8f8ff)
		drawRec((exside) - ((15.0 / 30.0) * gvExitTimer), (gvScreenH / 2) + 13,  ((31.0 / 30.0) * gvExitTimer), 2, true)
	}

	//Draw surface to screen
	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
	if(gvFadeTime > 0) {
		setDrawColor(min(255, gvFadeTime * 8))
		drawRec(0, 0, gvScreenW, gvScreenH, true)
	}

	//Unhide players
	if(gvPlayer && "hidden" in gvPlayer) gvPlayer.hidden = false
	if(gvPlayer2 && "hidden" in gvPlayer2) gvPlayer2.hidden = false

	//Handle berries
	if(game.ps1.berries > 0 && game.ps1.berries % 16 == 0) {
		if(game.ps1.health < game.maxHealth) {
			game.ps1.health++
			game.ps1.berries = 0
		}
		else game.ps1.berries--
	}
	if(game.ps2.berries > 0 && game.ps2.berries % 16 == 0) {
		if(game.ps2.health < game.maxHealth) {
			game.ps2.health++
			game.ps2.berries = 0
		}
		else game.ps2.berries--
	}

	if(game.ps1.health < 0) game.ps1.health = 0
	if(game.ps2.health < 0) game.ps2.health = 0
}

::playerTeleport <- function(target = false, _x = 0, _y = 0) { //Used to move the player and camera at the same time
	if(!target) return
	if(gvMap == 0) return

	local ux = gvMap.w - gvScreenW
	local uy = gvMap.h - gvScreenH

	target.x = _x.tofloat()
	target.y = _y.tofloat()
	target.xprev = target.x
	target.yprev = target.y
	
	if(gvNumPlayers == 1) {
		camx0 = _x.tofloat() - (gvScreenW / 2)
		camy0 = _y.tofloat() - (gvScreenH / 2)

		if(camx0 > ux) camx = ux
		if(camx0 < 0) camx = 0
		if(camy0 > uy) camy = uy
		if(camy0 < 0) camy = 0
	}

	if(gvNumPlayers == 2) {
		if(!gvSplitScreen) {
			camx0 = _x.tofloat() - (gvScreenW / 2)
			camy0 = _y.tofloat() - (gvScreenH / 2)

			if(camx0 > ux) camx = ux
			if(camx0 < 0) camx = 0
			if(camy0 > uy) camy = uy
			if(camy0 < 0) camy = 0
		}

		if(gvPlayer && target == gvPlayer) {
			camx1 = _x.tofloat() - (gvScreenW / 4)
			camy1 = _y.tofloat() - (gvScreenH / 2)

			if(camx1 > ux) camx1 = ux
			if(camx1 < 0) camx1 = 0
			if(camy1 > uy) camy1 = uy
			if(camy1 < 0) camy1 = 0
		}

		if(gvPlayer2 && target == gvPlayer2) {
			camx2 = _x.tofloat() - (gvScreenW / 4)
			camy2 = _y.tofloat() - (gvScreenH / 2)

			if(camx2 > ux) camx2 = ux
			if(camx2 < 0) camx2 = 0
			if(camy2 > uy) camy2 = uy
			if(camy2 < 0) camy2 = 0
		}
	}
}

::TimeAttackSign <- class extends Actor {
	function draw() {
		local str = gvLangObj["stats"]["final-time"]
		local time = formatTime(game.igt)
		drawText(font2, (gvScreenW / 2) - (str.len() * 4), 64, str)
		drawText(font2, (gvScreenW / 2) - (time.len() * 4), 80, time)
	}
}

::createPlatformActors <- function(n, i, c) {
	switch(n) {
		case 0:
			gvNumPlayers = 0
			if(!gvPlayer && getroottable().rawin(game.playerChar)) {
				if(game.check == false) {
					c = actor[newActor(getroottable()[game.playerChar], i.x + 8, i.y - 16)]
				}
				else {
					c = actor[newActor(getroottable()[game.playerChar], game.chx, game.chy)]
				}
				gvNumPlayers++
			}
			if(!gvPlayer2 && game.playerChar2 != "" && getroottable().rawin(game.playerChar2)) {
				if(game.check == false) {
					c = actor[newActor(getroottable()[game.playerChar2], i.x + 8, i.y - 16)]
				}
				else {
					c = actor[newActor(getroottable()[game.playerChar2], game.chx, game.chy)]
				}
				gvNumPlayers++
			}

			camx = c.x - (gvScreenW / 2)
			camy = c.y - (gvScreenH / 2)
			if(gvPlayer) gvCamTarget = gvPlayer
			break

		case 1:
			c = newActor(Coin, i.x + 8, i.y - 8)
			break

		case 2:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 0)
			game.maxCoins++
			break

		case 3:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 1)
			break

		case 4:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 2)
			break

		case 5:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 3)
			break

		case 6:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 5)
			break

		case 7:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 4)
			break

		case 8:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 6)
			break

		case 9:
			c = newActor(BadCannon, i.x + 8, i.y - 8)
			break

		case 10:
			c = newActor(PipeSnake, i.x, i.y, 1)
			//Enemies are counted at level creation so ones created indefinitely don't count against achievements
			game.maxEnemies++
			break

		case 11:
			c = newActor(PipeSnake, i.x, i.y - 16, -1)
			game.maxEnemies++
			break

		case 12:
			c = newActor(Deathcap, i.x + 8, i.y - 8, false)
			game.maxEnemies++
			break

		case 13:
			c = newActor(Deathcap, i.x + 8, i.y - 8, true)
			game.maxEnemies++
			break

		case 14:
			c = newActor(IceBlock, i.x + 8, i.y - 8)
			break

		case 15:
			c = newActor(WoodBlock, i.x + 8, i.y - 8, i.name)
			break

		case 16:
			c = actor[newActor(Spring, i.x + 8, i.y - 8, 0)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 17:
			c = actor[newActor(Spring, i.x + 8, i.y - 8, 1)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 18:
			c = actor[newActor(Spring, i.x + 8, i.y - 8, 2)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 19:
			c = actor[newActor(Spring, i.x + 8, i.y - 8, 3)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 20:
			c = newActor(Ouchin, i.x + 8, i.y - 8)
			break

		case 21:
			c = newActor(TriggerBlock, i.x + 8, i.y - 8, i.name)
			break

		case 22:
			if(gvLangObj["info"].rawin(i.name)) c = newActor(InfoBlock, i.x + 8, i.y - 8, textLineLen(gvLangObj["info"][i.name], gvTextW))
			else c = newActor(InfoBlock, i.x + 8, i.y - 8, "")
			break

		case 23:
			if(gvLangObj["devcom"].rawin(i.name)) c = newActor(KelvinScarf, i.x + 8, i.y - 8, textLineLen(gvLangObj["devcom"][i.name], gvTextW))
			else c = newActor(KelvinScarf, i.x + 8, i.y - 8, "")
			break

		case 24:
			c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
			c.item = 7
			break

		case 25:
			c = newActor(FlyRefresh, i.x + 8, i.y - 8)
			break

		case 26:
			c = newActor(CarlBoom, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 27:
			c = newActor(OrangeBounce, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 28:
			c = newActor(BlueFish, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 29:
			c = newActor(RedFish, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 30:
			c = newActor(BounceBlock, i.x + 8, i.y - 8)
			break

		case 31:
			c = actor[newActor(NPC, i.x + 8, i.y, i.name)]
			break

		case 32:
			c = newActor(Checkpoint, i.x + 8, i.y - 16)
			break

		case 33:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 8)
			break

		case 34:
			c = newActor(TNT, i.x + 8, i.y - 8)
			break

		case 35:
			c = newActor(C4, i.x + 8, i.y - 8)
			break

		case 36:
			c = newActor(JellyFish, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 37:
			c = newActor(Clamor, i.x + 8, i.y - 8, i.name)
			game.maxEnemies++
			break

		case 38:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 9)
			break

		case 39:
			c = newActor(ItemBlock, i.x + 8, i.y - 8, 10)
			break

		case 40:
			c = actor[newActor(SpringD, i.x + 8, i.y - 8, 0)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 41:
			c = actor[newActor(SpringD, i.x + 8, i.y - 8, 1)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 42:
			c = actor[newActor(SpringD, i.x + 8, i.y - 8, 2)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 43:
			c = actor[newActor(SpringD, i.x + 8, i.y - 8, 3)]
			if(i.name != "") c.power = i.name.tofloat()
			break

		case 44:
			c = newActor(GreenFish, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 45:
			c = newActor(Icicle, i.x + 8, i.y - 8)
			break

		case 46:
			c = newActor(FlyAmanita, i.x + 8, i.y - 8, i.name)
			game.maxEnemies++
			break

		case 48:
			c = newActor(MagicKey, i.x + 8, i.y - 8, 0)
			break

		case 49:
			c = newActor(MagicKey, i.x + 8, i.y - 8, 1)
			break

		case 50:
			c = newActor(MagicKey, i.x + 8, i.y - 8, 2)
			break

		case 51:
			c = newActor(MagicKey, i.x + 8, i.y - 8, 3)
			break

		case 52:
			c = newActor(LockBlock, i.x + 8, i.y - 8, 0)
			break

		case 53:
			c = newActor(LockBlock, i.x + 8, i.y - 8, 1)
			break

		case 54:
			c = newActor(LockBlock, i.x + 8, i.y - 8, 2)
			break

		case 55:
			c = newActor(LockBlock, i.x + 8, i.y - 8, 3)
			break

		case 56:
			c = newActor(ColorBlock, i.x, i.y - 16, 0)
			break

		case 57:
			c = newActor(ColorBlock, i.x, i.y - 16, 1)
			break

		case 58:
			c = newActor(ColorBlock, i.x, i.y - 16, 2)
			break

		case 59:
			c = newActor(ColorBlock, i.x, i.y - 16, 3)
			break

		case 60:
			c = newActor(ColorBlock, i.x, i.y - 16, 4)
			break

		case 61:
			c = newActor(ColorBlock, i.x, i.y - 16, 5)
			break

		case 62:
			c = newActor(ColorBlock, i.x, i.y - 16, 6)
			break

		case 63:
			c = newActor(ColorBlock, i.x, i.y - 16, 7)
			break

		case 64: //Custom actor gear
			if(i.name == "") break
			local arg = split(i.name, ",")
			local n = arg[0]
			arg.remove(0)
			if(arg.len() == 1) arg = arg[0]
			else if(arg.len() == 0) arg = null
			if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") c = newActor(getroottable()[n], i.x + 8, i.y - 8, arg)
			break

		case 65:
			c = newActor(Haywire, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 66:
			c = newActor(Livewire, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 67:
			c = newActor(Blazeborn, i.x + 8, i.y - 8)
			game.maxEnemies++
			break

		case 68:
			c = newActor(Coin5, i.x + 8, i.y - 8)
			break

		case 69:
			c = newActor(Coin10, i.x + 8, i.y - 8)
			break

		case 70:
			c = newActor(Herring, i.x + 8, i.y - 8)
			break

		case 71:
			c = newActor(FishBlock, i.x + 8, i.y - 8)
			break

		case 73:
			c = newActor(Jumpy, i.x + 8, i.y - 8, i.name)
			game.maxEnemies++
			break

		case 75:
			c = newActor(EvilBlock, i.x + 8, i.y - 8)
			break

		case 76:
			c = newActor(Crumbler, i.x + 8, i.y - 8)
			break

		case 77:
			c = newActor(SpecialBall, i.x + 8, i.y - 8, i.name.tointeger())
			break

		case 78:
			c = newActor(Berry, i.x + 8, i.y - 8)
			break

		case 79:
			c = newActor(BossDoor, i.x, i.y - 16, i.name)
			break

		case 80:
			c = newActor(MrIceguy, i.x + 8, i.y - 8, i.name)
			game.maxEnemies++
			break

		case 81:
			c = newActor(Owl, i.x + 8, i.y - 8, i.name)
			game.maxEnemies++
			break

		case 85:
			c = newActor(Spawner, i.x + 8, i.y - 8, i.name)
			break

		case 86:
			c = newActor(CharSwapper, i.x + 8, i.y - 8, i.name)
			break

		case 87:
			c = newActor(SpikeCap, i.x + 8, i.y - 8, i.name)
			break

		case 88:
			c = newActor(SpikeCap, i.x + 8, i.y - 8, i.name)
			actor[c].moving = true
			break

		case 89:
			c = newActor(Tallcap, i.x + 8, i.y - 24, false)
			break

		case 90:
			c = newActor(Tallcap, i.x + 8, i.y - 24, true)
			break

		case 91:
			c = newActor(CaptainMorel, i.x + 8, i.y - 8)
			break

		case 92:
			c = newActor(CoffeeCup, i.x + 8, i.y - 8)
			break

		case 93:
			c = newActor(BoostRing, i.x + 8, i.y - 8, i.name)
			break

		case 94:
			c = newActor(Crusher, i.x + 8, i.y - 8, i.name)
			break

		case 95:
			c = newActor(Wheeler, i.x + 8, i.y - 8, i.name)
			break

		case 96:
			c = newActor(FireBlock, i.x + 8, i.y - 8, i.name)
			break

		case 102:
			c = newActor(Ivy, i.x + 8, i.y - 8, false)
			break

		case 103:
			c = newActor(Ivy, i.x + 8, i.y - 8, true)
			break
	}

	return c
}

::createRacerActors <- function(n, i, c) {
	switch(n) {
		case 0:
			c = newActor(TuxRacer, i.x + 8, i.y - 8)
			break

		case 2:
			c = newActor(Herring, i.x + 8, i.y - 8)
			break

		case 3:
			if(i.name == "") break
			local arg = split(i.name, ",")
			local n = arg[0]
			arg.remove(0)
			if(arg.len() == 1) arg = arg[0]
			else if(arg.len() == 0) arg = null
			if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") c = newActor(getroottable()[n], i.x + 8, i.y - 8, arg)
			break
	}

	return c
}
