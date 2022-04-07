/*=========*\
| PLAY MODE |
\*=========*/

::gvInfoBox <- ""
::gvLangObj <- ""

::mapActor <- {} //Stores references to all actors created by the map

::startPlay <- function(level)
{
	if(!fileExists(level)) return

	//Clear actors and start creating new ones
	setFPS(60)
	gvPlayer = false
	gvBoss = false
	actor.clear()
	actlast = 0
	game.health = game.maxHealth
	game.levelCoins = 0
	game.maxCoins = 0
	game.redcoins = 0
	game.levelredcoins = 0
	game.maxredcoins = 0
	game.secrets = 0
	game.enemies = 0
	gvInfoBox = ""
	gvLastSong = ""
	gfxReset()

	//Reset auto/locked controls
	autocon.up = false
	autocon.down = false
	autocon.left = false
	autocon.right = false

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

	//Get tiles used to mark actors
	local actset = -1
	local tilef = 0
	for(local i = 0; i < gvMap.tileset.len(); i++)
	{
		if(spriteName(gvMap.tileset[i]) == "actors.png")
		{
			actset = gvMap.tileset[i]
			tilef = gvMap.tilef[i]
			break
		}
	}
	if(actset == -1)
	{
		print("Map does not use actors.png. No actors to load.")
		return
	}

	//Get layer for actors
	local actlayer = -1
	foreach(i in gvMap.data.layers)
	{
		if(i["type"] == "objectgroup" && i["name"] == "actor")
		{
			actlayer = i
			break
		}
	}
	if(actlayer == -1)
	{
		print("Map does not have an actor layer. No actors to load.")
		return
	}

	//Start making actors
	foreach(i in actlayer.objects)
	{
		//Tile actors
		if(i.rawin("gid")) {
			local n = i.gid - tilef
			local c = 0

			//Get the tile number and make an actor
			//according to the image used in actors.png
			switch(n)
			{
				case 0:
					//newActor(Tux, i.x, i.y - 16)
					if(!gvPlayer && getroottable().rawin(game.playerChar)) {
						if(game.check == false) {
							c = actor[newActor(getroottable()[game.playerChar], i.x + 8, i.y - 16)]
						}
						else {
							c = actor[newActor(getroottable()[game.playerChar], game.chx, game.chy)]
						}
					}
					camx = c.x - (screenW() / 2)
					camy = c.y - (screenH() / 2)
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
					game.enemies++
					break

				case 11:
					c = newActor(PipeSnake, i.x, i.y - 16, -1)
					game.enemies++
					break

				case 12:
					c = newActor(Deathcap, i.x + 8, i.y - 8, false)
					game.enemies++
					break

				case 13:
					c = newActor(Deathcap, i.x + 8, i.y - 8, true)
					game.enemies++
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
					game.enemies++
					break

				case 27:
					c = newActor(SnowBounce, i.x + 8, i.y - 8)
					game.enemies++
					break

				case 28:
					c = newActor(BlueFish, i.x + 8, i.y - 8)
					game.enemies++
					break

				case 29:
					c = newActor(RedFish, i.x + 8, i.y - 8)
					game.enemies++
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
					game.enemies++
					break

				case 37:
					c = newActor(Clamor, i.x + 8, i.y - 8, i.name)
					game.enemies++
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
					game.enemies++
					break

				case 45:
					c = newActor(Icicle, i.x + 8, i.y - 8)
					break

				case 46:
					c = newActor(FlyAmanita, i.x + 8, i.y - 8, i.name)
					game.enemies++
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
					game.enemies++
					break

				case 66:
					c = newActor(Livewire, i.x + 8, i.y - 8)
					game.enemies++
					break

				case 67:
					c = newActor(Blazeborn, i.x + 8, i.y - 8)
					game.enemies++
					break

				case 68:
					c = newActor(Coin5, i.x + 8, i.y - 8)
					break

				case 69:
					c = newActor(Coin10, i.x + 8, i.y - 8)
					break

				case 70:
					c = newActor(RedCoin, i.x + 8, i.y - 8)
					break

				case 71:
					c = newActor(Fishy, i.x + 8, i.y - 8)
					break

				case 73:
					c = newActor(Jumpy, i.x + 8, i.y - 8, i.name)
					game.enemies++
					break

				case 75:
					c = newActor(EvilBlock, i.x + 8, i.y - 8)
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
			}

			if(typeof c == "integer") mapActor[i.id] <- c
			else mapActor[i.id] <- c.id
		}

		//Polygon actors
		if(i.rawin("polygon")) if(i.name != "") {
			local arg = split(i.name, ",")
			local n = arg[0]
			if(getroottable().rawin(n))
			{
				//Create polygon to pass to object
				local poly = []
				for(local j = 0; j <= i.polygon.len(); j++) {
					if(j == i.polygon.len()) poly.push([i.x + i.polygon[0].x, i.y + i.polygon[0].y])
					else poly.push([i.x + i.polygon[j].x, i.y + i.polygon[j].y])
				}

				arg[0] = poly
				if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") newActor(getroottable()[n], i.x, i.y, arg)
			}
		}

		//Polygon actors
		if(i.rawin("polyline")) if(i.name != "") {
			local arg = split(i.name, ",")
			local n = arg[0]
			if(getroottable().rawin(n))
			{
				//Create polygon to pass to object
				local poly = []
				for(local j = 0; j < i.polyline.len(); j++) poly.push([i.x + i.polyline[j].x, i.y + i.polyline[j].y])

				arg[0] = poly
				if(getroottable().rawin(n)) if(typeof getroottable()[n] == "class") newActor(getroottable()[n], i.x, i.y, arg)
			}
		}
	}

	if(gvPlayer) {
		camx = gvPlayer.x - (screenW() / 2)
		camy = gvPlayer.y - (screenH() / 2)
	}
	else {
		camx = 0
		camy = 0
	}

	//Switch game mode to play
	gvGameMode = gmPlay
	//If the map loading fails at any point, then it will not change
	//the mode and simply remain where it was. A message is printed
	//in the log if the map fails, so users can check why a level
	//refuses to run.

	//Execute level code
	print("Running level code...")
	if(gvMap.data.rawin("properties")) foreach(i in gvMap.data.properties) {
		if(i.name == "code") dostr(i.value)
	}
	print("End level code")

	update()
}

::gmPlay <- function()
{
	if(gvCamTarget == null && gvPlayer) gvCamTarget = gvPlayer
	local px = 0
	local py = 0
	local ux = gvMap.w - screenW()
	local uy = gvMap.h - screenH()

	//Camera peek
	local lx = 0
	local ly = 0
	if(gvPlayer) {
		/* Temporarily disabled
		lx = ((joyH(0) / js_max.tofloat()) * screenW() / 2.5)
		ly = ((joyV(0) / js_max.tofloat()) * screenH() / 2.5)
		*/

		if(getcon("leftPeek", "hold")) lx = -(screenW() / 2.5)
		if(getcon("rightPeek", "hold")) lx = (screenW() / 2.5)
		if(getcon("upPeek", "hold")) ly = -(screenH() / 2.5)
		if(getcon("downPeek", "hold")) ly = (screenH() / 2.5)
	}

	if(gvCamTarget != null && gvCamTarget != false && gvPlayer)
	{
		if(gvPlayer) {
			if(gvCamTarget == gvPlayer) {
				if(debug && mouseDown(0)) {
					px = (gvCamTarget.x) - (screenW() / 2) + lx
					py = (gvCamTarget.y) - (screenH() / 2) + ly
				}
				else {
					px = (gvCamTarget.x + (gvPlayer.x - gvPlayer.xprev) * 32) - (screenW() / 2) + lx
					py = (gvCamTarget.y + (gvPlayer.y - gvPlayer.yprev) * 16) - (screenH() / 2) + ly
				}
			}
			else {
				local pw = max(screenW(), 320)
				local ph = max(screenH(), 240)
				local ptx = (gvCamTarget.x) - (screenW() / 2)
				local pty = (gvCamTarget.y) - (screenH() / 2)

				if(gvCamTarget.rawin("w")) if(abs(gvCamTarget.w) > pw / 2) {
					if(debug && mouseDown(0)) ptx = gvPlayer.x - (screenW() / 2) + lx
					else ptx = (gvPlayer.x + gvPlayer.hspeed * 32) - (screenW() / 2) + lx
				}
				if(gvCamTarget.rawin("h")) if(abs(gvCamTarget.h) > ph / 2) {
					if(debug && mouseDown(0)) pty = gvPlayer.y - (screenH() / 2) + ly
					else pty = (gvPlayer.y + gvPlayer.vspeed * 16) - (screenH() / 2) + ly
				}

				px = ptx
				py = pty
			}
		}
		else {
			px = (gvCamTarget.x) - (screenW() / 2)
			py = (gvCamTarget.y) - (screenH() / 2)
		}
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

	if(gvPlayer) gvCamTarget = gvPlayer

	//Draw
	//Separate texture for game world allows post-processing effects without including HUD
	runAmbientLight()
	setDrawTarget(gvPlayScreen)

	if(drawBG != 0) drawBG()
	if(drawWeather != 0) drawWeather()
	camxprev = camx
	camyprev = camy

	gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "bg")
	gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "mg")
	if(gvMap.name != "shop") for(local i = 0; i < (screenW() / 16) + 1; i++) {
		drawSprite(sprVoid, 0, 0 + (i * 16), gvMap.h - 32 - camy)
	}
	runActors()
	drawZList(8)
	if(actor.rawin("Water")) foreach(i in actor["Water"]) { i.draw() }
	drawAmbientLight()
	if(config.light) gvMap.drawTilesMod(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "fg", 1, gvLight)
	else gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16) - 3, floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "fg")
	if(actor.rawin("SecretWall")) foreach(i in actor["SecretWall"]) { i.draw() }
	if(debug) gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16), floor(camy / 16), (screenW() / 16) + 5, (screenH() / 16) + 2, "solid")

	//HUDs
	setDrawTarget(gvScreen)
	drawImage(gvPlayScreen, 0, 0)

	if(gvInfoBox == "") {
		//Draw max energy
		for(local i = 0; i < 4 - game.difficulty; i++) {
			drawSprite(sprEnergy, 2, 8 + (16 * i), 24)
		}
		//Draw health
		if(game.health > game.maxHealth) game.health = game.maxHealth

		local fullhearts = floor(game.health / 4)

		for(local i = 0; i < game.maxHealth / 4; i++) {
			if(i < fullhearts) drawSprite(sprHealth, 4, 8 + (16 * i), 8)
			else if(i == fullhearts) drawSprite(sprHealth, game.health % 4, 8 + (16 * i), 8)
			else drawSprite(sprHealth, 0, 8 + (16 * i), 8)
		}

		//Draw energy
		for(local i = 0; i < game.maxEnergy; i++) {
			if(gvPlayer) {
				if(gvPlayer.rawin("energy") && game.maxEnergy > 0) {
					if(i < floor(gvPlayer.energy)) drawSprite(sprEnergy, 1, 8 + (16 * i), 24)
					else drawSprite(sprEnergy, 0, 8 + (16 * i), 24)
				}
			}
		}

		//Draw boss health
		if(gvBoss) {
			local fullhearts = floor(game.bossHealth / 4)
			if(game.bossHealth == 0) fullhearts = 0

			drawSprite(sprBossHealth, 6, screenW() - 23, screenH() - 48)
			drawSprite(sprSkull, 0, screenW() - 26, screenH() - 46)
			for(local i = 0; i < 10; i++) {
				if(i < fullhearts) drawSprite(sprBossHealth, 4, screenW() - 23, screenH() - 64 - (16 * i))
				else if(i == fullhearts && game.bossHealth > 0) drawSprite(sprBossHealth, game.bossHealth % 4, screenW() - 23, screenH() - 64 - (16 * i))
				else drawSprite(sprBossHealth, 0, screenW() - 23, screenH() - 64 - (16 * i))
			}
			drawSprite(sprBossHealth, 5, screenW() - 23, screenH() - 64 - (16 * 10))
		}

		//Draw coins & herrings
		drawSprite(sprCoin, 0, 16, screenH() - 16)
		if(game.maxCoins > 0) drawText(font2, 24, screenH() - 23, game.levelCoins.tostring() + "/" + game.maxCoins.tostring())
		else drawText(font2, 24, screenH() - 23, game.coins.tostring())
		//Herrings (redcoins)
		if(game.maxredcoins > 0) drawSprite(sprHerring, 0, 16, screenH() - 40)
		if(game.maxredcoins > 0) drawText(font2, 24, screenH() - 46, game.levelredcoins.tostring() + "/" + game.maxredcoins.tostring())
		//Draw subitem
		drawSprite(sprSubItem, 0, screenW() - 18, 18)
		switch(game.subitem) {
			case 1:
				drawSprite(sprFlowerFire, 0, screenW() - 18, 18)
				break
			case 2:
				drawSprite(sprFlowerIce, 0, screenW() - 18, 18)
				break
			case 3:
				drawSprite(sprAirFeather, 0, screenW() - 18, 18)
				break
			case 4:
				drawSprite(sprEarthShell, 0, screenW() - 18, 18)
				break
			case 5:
				drawSprite(sprMuffin, 0, screenW() - 18, 18)
				break
			case 6:
				drawSprite(sprMuffin, 1, screenW() - 18, 18)
				break
			case 7:
				drawSprite(sprStar, 0, screenW() - 18, 18)
				break
			case 8:
				drawSprite(getroottable()[game.characters[game.playerChar][1]], 0, screenW() - 18, 24)
				break
		}

		//Draw level IGT
		if(gvDoIGT && config.showleveligt) drawText(font2, 8, 32, formatTime(gvIGT))

		//Draw offscreen player
		if(gvPlayer) if(gvPlayer.y < -8) {
			drawSprite(getroottable()[game.characters[game.playerChar][1]], game.weapon, gvPlayer.x - camx, 8 - (gvPlayer.y / 4))
		}

		//Draw warning sign
		if(gvWarning < 180) {
			if(gvWarning == 0 || gvWarning == 90) {
				stopChannel(4)
				soundPlayChannel(sndWarning, 0, 4)
			}
			drawSpriteEx(sprWarning, 0, screenW() / 2, screenH() / 2, 0, 0, 1, 1, abs(sin(gvWarning / 30.0)))
			gvWarning += 1.5
		}

		//Keys
		local kx = 10
		if(game.canres) {
			drawSprite(getroottable()[game.characters[game.playerChar][1]], game.weapon, screenW() - kx, screenH() - 10)
			kx += 16
		}
		if(gvKeyCopper) {
			drawSprite(sprKeyCopper, 0, screenW() - kx, screenH() - 16)
			kx += 16
		}
		if(gvKeySilver) {
			drawSprite(sprKeySilver, 0, screenW() - kx, screenH() - 16)
			kx += 16
		}
		if(gvKeyGold) {
			drawSprite(sprKeyGold, 0, screenW() - kx, screenH() - 16)
			kx += 16
		}
		if(gvKeyMythril) {
			drawSprite(sprKeyMythril, 0, screenW() - kx, screenH() - 16)
			kx += 16
		}
		//Other items could be put in the row like this as well
	}
	else {
		local ln = 3
		for(local i = 0; i < gvInfoBox.len(); i++) {
			if(chint(gvInfoBox[i])  == "\n") ln++
		}
		setDrawColor(0x000000d0)
		drawRec(0, 0, screenW(), 8 * ln, true)
		drawText(font, 8, 8, gvInfoBox)

	}
	drawDebug()

	if(levelEndRunner == 0) gvIGT++
	game.igt++

	//Draw global IGT
	if(config.showglobaligt) {
		local gtd = formatTime(game.igt) //Game time to draw
		drawText(font2, (screenW() / 2) - (gtd.len() * 4), screenH() - 24, gtd)
	}

	//Draw surface to screen
	resetDrawTarget()
	drawImage(gvScreen, 0, 0)

	//Handle berries
	if(game.berries > 0 && game.berries % 16 == 0 && game.health < game.maxHealth) {
		game.health++
		game.berries = 0
	}
	if(gvPlayer) if(game.berries == 64) {
		game.berries = 0
		newActor(Starnyan, gvPlayer.x, gvPlayer.y)
	}

	if(game.health < 0) game.health = 0
}

::playerTeleport <- function(_x, _y) { //Used to move the player and camera at the same time
	if(!gvPlayer) return
	if(gvMap == 0) return

	local ux = gvMap.w - screenW()
	local uy = gvMap.h - screenH()

	gvPlayer.x = _x.tofloat()
	gvPlayer.y = _y.tofloat()
	gvPlayer.xprev = gvPlayer.x
	gvPlayer.yprev = gvPlayer.y
	camx = _x.tofloat() - (screenW() / 2)
	camy = _y.tofloat() - (screenH() / 2)

	if(camx > ux) camx = ux
	if(camx < 0) camx = 0
	if(camy > uy) camy = uy
	if(camy < 0) camy = 0
}
