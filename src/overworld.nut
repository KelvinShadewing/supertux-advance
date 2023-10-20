///////////////
// OVERWORLD //
///////////////

::gvLevel <- ""

::OverPlayer <- class extends PhysAct {
	//0 = right
	//1 = up
	//2 = left
	//3 = down
	canmove = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(game.owx == 0 && game.owy == 0) {
			x = _x
			y = _y
		}
		else {
			x = game.owx
			y = game.owy
		}

		shape = Rec(x, y, 1, 1, 0)
		gvPlayer = this
	}

	function run() {
		base.run()

		shape.setPos(x, y)
		game.owx = x
		game.owy = y

		if(!getcon("left", "hold", false, 0)
		&& !getcon("right", "hold", false, 0)
		&& !getcon("up", "hold", false, 0)
		&& !getcon("down", "hold", false, 0))
			canmove = true

		local level = ""
		local onstage = false
		local noclear = false

		if(actor.rawin("StageIcon")) {//Find what level was landed on
			foreach(i in actor["StageIcon"]) {
				if(hitTest(shape, i.shape)) {
					level = i.levelName
					onstage = true
					break
				}
			}
		}

		if(actor.rawin("TownIcon")) {//Find what level was landed on
			foreach(i in actor["TownIcon"]) {
				if(hitTest(shape, i.shape)) {
					level = i.levelName
					onstage = true
					noclear = true
					break
				}
			}
		}

		if(actor.rawin("WorldIcon")) {//Find what level was landed on
			foreach(i in actor["WorldIcon"]) {
				if(hitTest(shape, i.shape)) {
					level = i.world
					onstage = true
					noclear = true
					break
				}
			}
		}

		if(onstage) {
			if((x - 8) % 16 == 0) hspeed = 0
			if((y - 8) % 16 == 0) vspeed = 0
		}

		//Movement dir reminder
		//0 = right
		//1 = up
		//2 = left
		//3 = down

		if((x - 8) % 16 == 0 && (y - 8) % 16 == 0) {
			local opendirs = 0
			local nextdir = -1

			//Find next step
			//game.owd tracks the direction the player came from
			if((hspeed != 0 || vspeed != 0) && !debug) {
				if(game.owd == 0 && nextdir == -1) {
					if(!placeFree(x - 16, y)) {
						opendirs++
						nextdir = 2
					}
					if(!placeFree(x, y - 16)) {
						opendirs++
						nextdir = 1
					}
					if(!placeFree(x, y + 16)) {
						opendirs++
						nextdir = 3
					}
				}

				if(game.owd == 2 && nextdir == -1) {
					if(!placeFree(x + 16, y)) {
						opendirs++
						nextdir = 0
					}
					if(!placeFree(x, y - 16)) {
						opendirs++
						nextdir = 1
					}
					if(!placeFree(x, y + 16)) {
						opendirs++
						nextdir = 3
					}
				}

				if(game.owd == 3 && nextdir == -1) {
					if(!placeFree(x + 16, y)) {
						opendirs++
						nextdir = 0
					}
					if(!placeFree(x, y - 16)) {
						opendirs++
						nextdir = 1
					}
					if(!placeFree(x - 16, y)) {
						opendirs++
						nextdir = 2
					}
				}

				if(game.owd == 1 && nextdir == -1) {
					if(!placeFree(x + 16, y)) {
						opendirs++
						nextdir = 0
					}
					if(!placeFree(x, y + 16)) {
						opendirs++
						nextdir = 3
					}
					if(!placeFree(x - 16, y)) {
						opendirs++
						nextdir = 2
					}
				}
			}

			//Continue moving until place is found
			if(level == "" && opendirs == 1) {
				switch(nextdir) {
					case 0:
						vspeed = 0
						hspeed = 2
						game.owd = 2
						break
					case 1:
						vspeed = -2
						hspeed = 0
						game.owd = 3
						break
					case 2:
						vspeed = 0
						hspeed = -2
						game.owd = 0
						break
					case 3:
						vspeed = 2
						hspeed = 0
						game.owd = 1
						break
				}
			}

			if(opendirs != 1) {
				hspeed = 0
				vspeed = 0
			}

			//Move right
			if(canmove && getcon("right", "hold") && !getcon("left", "hold") && (!placeFree(x + 16, y) || debug) && hspeed <= 0 && vspeed == 0) {
				if(level == "" || game.owd == 0 || game.completed.rawin(level) || noclear) {
					hspeed = 2
					game.owd = 2
				}
			}

			//Move up
			if(canmove && getcon("up", "hold") && !getcon("down", "hold") && (!placeFree(x, y - 16) || debug) && hspeed == 0 && vspeed >= 0) {
				if(level == "" || game.owd == 1 || game.completed.rawin(level) || noclear) {
					vspeed = -2
					game.owd = 3
				}
			}

			//Move left
			if(canmove && getcon("left", "hold") && !getcon("right", "hold") && (!placeFree(x - 16, y) || debug) && hspeed >= 0 && vspeed == 0) {
				if(level == "" || game.owd == 2 || game.completed.rawin(level) || noclear) {
					hspeed = -2
					game.owd = 0
				}
			}

			//Move down
			if(canmove && getcon("down", "hold") && !getcon("up", "hold") && (!placeFree(x, y + 16) || debug) && hspeed == 0 && vspeed <= 0) {
				if(level == "" || game.owd == 3 || game.completed.rawin(level) || noclear) {
					vspeed = 2
					game.owd = 1
				}
			}
		}

		x += hspeed
		y += vspeed

		if(hspeed == 0 && vspeed == 0) {
			x -= x % 16
			x += 8

			y -= y % 16
			y += 8
		}

		if(hspeed == 0 && vspeed == 0) drawSpriteZ(2, getroottable()[gvCharacters[game.playerChar]["over"]], 0, x - camx, y - camy)
		else drawSpriteZ(2, getroottable()[gvCharacters[game.playerChar]["over"]], getFrames() / 8, x - camx, y - camy)
		
		gvLevel = level
	}

	function physics() {}

	function _typeof() { return "OverPlayer" }
}

::StageIcon <- class extends PhysAct {
	level = ""
	visible = true
	raceMode = false
	levelName = ""

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
		level = _arr
		levelName = level
	}

	function run() {
		if(visible && !raceMode) {
			if(game.completed.rawin(level)) drawSprite(sprLevels, 1, x - camx, y - camy)
			else drawSprite(sprLevels, 0, x - camx, y - camy)
		}

		if(game.allCoins.rawin(level)) drawSprite(sprLevels, 2, x - camx, y - camy)
		if(game.allEnemies.rawin(level)) drawSprite(sprLevels, 3, x - camx, y - camy)
		if(game.allSecrets.rawin(level)) drawSprite(sprLevels, 4, x - camx, y - camy)

		//Selected
		if(getcon("jump", "press") || getcon("accept", "press") || getcon("shoot", "press")) {
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape) && gvPlayer.hspeed == 0 && gvPlayer.vspeed == 0) if(level != "") {
				game.check = false
				gvDoIGT = true
				drawWeather = 0
				startPlay(game.path + level + ".json")
			}
		}
	}

	function _typeof() { return "StageIcon" }
}

::clearAllLevels <- function() {
	if(!actor.rawin("StageIcon")) return
	foreach(i in actor["StageIcon"]) game.completed[i.level] <- true
}

::TownIcon <- class extends PhysAct {
	level = ""
	visible = true
	levelName = ""

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
		level = _arr
		levelName = level
	}

	function run() {
		//Selected
		if(getcon("jump", "press") || getcon("accept", "press") || getcon("shoot", "press")) {
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape) && gvPlayer.hspeed == 0 && gvPlayer.vspeed == 0) if(level != "") {
				game.check = false
				gvDoIGT = false
				drawWeather = 0
				startPlay(game.path + level + ".json", true, true)
			}
		}
	}

	function _typeof() { return "TownIcon" }
}

::WorldIcon <- class extends PhysAct {
	level = ""
	world = ""
	visible = true
	px = 0
	py = 0
	levelName = ""

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
		level = _arr
		levelName = level
	}

	function run() {
		if(world == "" && level != "") {
			local arr = split(level, ",")
			world = arr[0]
			px = arr[1].tointeger()
			py = arr[2].tointeger()
		}

		//Selected
		if(getcon("jump", "press") || getcon("accept", "press") || getcon("shoot", "press")) {
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape) && gvPlayer.hspeed == 0 && gvPlayer.vspeed == 0) if(world != "") {
				game.owx = px
				game.owy = py
				startOverworld(game.path + world + ".json")
			}
		}
	}

	function _typeof() { return "WorldIcon" }
}

::LockIcon <- class extends PhysAct {
	key = ""

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
		key = _arr
	}

	function run() {
		if(game.unblocked.rawin(key)) {
			tileSetSolid(x, y, 1)
			deleteActor(id)
		}
		else {
			tileSetSolid(x, y, 0)
			drawSprite(sprLevels, 5, x - camx, y - camy)
		}
	}

	function _typeof() { return "LockIcon" }
}

::startOverworld <- function(world) {
	//Clear actors and start creating new ones
	gvFadeInTime = 255
	setFPS(60)
	gvPlayer = false
	gvPlayer2 = false
	deleteAllActors()
	gvIGT = 0
	autocon = clone(defAutocon)
	gfxReset()
	gvLightScreen = gvLightScreen1
	gvSplitScreen = false
	gvYetFoundItems.clear()
	gvFoundItems.clear()
	gvAutoCon = false

	//Load map to play
	if(gvMap != 0) gvMap.del()
	gvMap = Tilemap(world)
	game.world = world

	//Get tiles used to mark actors
	local actset = -1
	local tilef = 0
	for(local i = 0; i < gvMap.tileset.len(); i++) {
		if(spriteName(gvMap.tileset[i]) == "overactors.png")
		{
			actset = gvMap.tileset[i]
			tilef = gvMap.tilef[i]
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
		if(i["type"] == "objectgroup" && i["name"] == "actor")
		{
			actlayer = i
			break
		}
	}

	if(actlayer == -1) {
		print("Map does not have an actor layer. No actors to load.")
		return
	}

	//Start making actors
	foreach(i in actlayer.objects)
	{
		local c

		if("gid" in i) {
			local n = i.gid - tilef

			//Get the tile number and make an actor
			//according to the image used in actors.png
			switch(n)
			{
				case 0:
					if(!gvPlayer) c = newActor(OverPlayer, i.x + 8, i.y - 8)
					camx = gvPlayer.x - gvScreenW / 2
					camy = gvPlayer.y - gvScreenH / 2
					break

				case 1:
					c = actor[newActor(StageIcon, i.x + 8, i.y - 8, i.name)]
					c.visible = i.visible
					break

				case 2:
					c = actor[newActor(WorldIcon, i.x + 8, i.y - 8, i.name)]
					break

				case 3:
					c = actor[newActor(TownIcon, i.x + 8, i.y - 8, i.name)]
					break

				case 4:
					c = newActor(LockIcon, i.x + 8, i.y - 8, i.name)
					break

				case 5:
					if(i.name == "") break
					local arg = split(i.name, ",")
					local n = arg[0]
					arg.remove(0)
					if(arg.len() == 1) arg = arg[0]
					else if(arg.len() == 0) arg = null
					if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") c = newActor(getroottable()[n], i.x + 8, i.y - 8, arg)
					break

				case 6:
					c = actor[newActor(StageIcon, i.x + 8, i.y - 8, i.name)]
					c.visible = i.visible
					c.raceMode = true
					break
			}
		}

		//Rectangle actors
		if(!i.rawin("polygon") && !i.rawin("polyline") && !i.rawin("ellipse") && !i.rawin("point") && !i.rawin("gid")) if(i.name != "") {
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
			}
		}

		if(typeof c == "integer") mapActor[i.id] <- c
		else mapActor[i.id] <- c.id
	}

	for(local i = 0; i < gvMap.data.layers.len(); i++) {
		if(gvMap.data.layers[i].type == "objectgroup") {
			local lana = gvMap.data.layers[i].name //Layer name
			for(local j = 0; j < gvMap.data.layers[i].objects.len(); j++) {
				local obj = gvMap.data.layers[i].objects[j]
				switch(lana) {
					case "trigger":
						local c = newActor(Trigger, obj.x + (obj.width / 2), obj.y + (obj.height / 2))
						actor[c].shape = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 0)
						actor[c].code = obj.name
						actor[c].w = obj.width / 2
						actor[c].h = obj.height / 2
						break
				}
			}
		}
	}

	gvGameMode = gmOverworld

	if(gvPlayer) {
		camx = gvPlayer.x - (screenW() / 2)
		camy = gvPlayer.y - (screenH() / 2)
	}
	else {
		camx = 0
		camy = 0
	}

	//Execute level code
	print("Running level code...")
	if(gvMap.data.rawin("properties")) foreach(i in gvMap.data.properties) {
		if(i.name == "code") dostr(i.value)
	}
	print("End level code")

	//Reset auto/locked controls
	autocon = clone(defAutocon)

	update()
}

::gmOverworld <- function() {
	setDrawTarget(gvScreen)

	gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "bg")
	gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "mg")
	gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "fg")
	if(debug) gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "solid")

	//Actor types are explicitly called this way to ensure the player is drawn on top
	//This was made before Z drawing was implemented, so it's not perfect
	runActors()
	foreach(i in actor) if("draw" in i && typeof i.draw == "function") i.draw()
	drawZList(8)

	runAmbientLight()

	if(gvPlayer)
		drawLight(sprLightBasic, 0, gvPlayer.x - camx, gvPlayer.y - camy - 8)

	drawAmbientLight()

	if(gvLevel != "") {
		drawText(font2, (screenW() / 2) - (gvLangObj["level"][gvLevel].len() * 4), 8, gvLangObj["level"][gvLevel])
		if(game.bestTime.rawin(gvLevel + "-" + game.playerChar)) {
			local pb = formatTime(game.bestTime[gvLevel + "-" + game.playerChar])
			local pbx = (pb.len() / 2) * 8
			drawText(font2, (screenW() / 2) - pbx, 24, pb)
		}
	}

	drawSprite(sprCoin, 0, 16, screenH() - 16)
	drawText(font2, 24, screenH() - 23, game.coins.tostring())

	if (game.colorswitch.find(true) != null) {
		if(getcon("spec1", "press")) {
			game.turnOffBlocks = !game.turnOffBlocks
			playSound(sndMenuSelect, 0)
		}

		local blockx = gvScreenW - 21
		local blocky = gvScreenH - 21
		local trueCount = 0
		for(local i = 7; i >= 0; i--) {
			if(game.colorswitch[i]) {
				trueCount++
				drawSprite(sprColorBlock, ((i * 2) + 1) - int(game.turnOffBlocks), blockx, blocky)
				blockx -= 8
				blocky -= (trueCount % 2 == 0 ? -8 : 8)
			}
		}
	}

	//Fade from black
	setDrawColor(gvFadeInTime)
	drawRec(0, 0, screenW(), screenH(), true)
	if(gvFadeInTime > 0) gvFadeInTime -= 10
	if(gvFadeInTime < 0) gvFadeInTime = 0

	drawDebug()

	game.igt++
	if(config.showglobaligt) {
		local gtd = formatTime(game.igt) //Game time to draw
		drawText(font2, (screenW() / 2) - (gtd.len() * 4), screenH() - 24, gtd)
	}

	checkAchievements()
	drawAchievements()

	//Draw surface to screen
	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
	if(gvFadeTime > 0) {
		setDrawColor(min(255, gvFadeTime * 8))
		drawRec(0, 0, screenW(), screenH(), true)
	}

	//Follow player
	local px = 0
	local py = 0
	local ux = gvMap.w - screenW()
	local uy = gvMap.h - screenH()

	if(gvPlayer)
	{
		px = (gvPlayer.x + gvPlayer.hspeed * 24) - (screenW() / 2)
		py = (gvPlayer.y + gvPlayer.vspeed * 16) - (screenH() / 2)
	} else {
		px = camx
		py = camy
	}

	camx += (px - camx) / 16
	camy += (py - camy) / 16

	if(camx > ux) camx = ux
	if(camx < 0) camx = 0
	if(camy > uy) camy = uy
	if(camy < 0) camy = 0
}

::irisOut <- function() {

}