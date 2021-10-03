/*=========*\
| PLAY MODE |
\*=========*/

::gvInfoBox <- ""
::gvLangObj <- ""

::startPlay <- function(level)
{
	if(!fileExists(level)) return

	//Clear actors and start creating new ones
	gvPlayer = 0
	actor.clear()
	actlast = 0
	game.health = game.maxHealth
	game.levelcoins = 0
	game.maxcoins = 0
	game.secrets = 0
	game.enemies = 0
	game.check = false

	//Load map to play
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
		local n = i.gid - tilef

		//Get the tile number and make an actor
		//according to the image used in actors.png
		switch(n)
		{
			case 0:
				//newActor(Tux, i.x, i.y - 16)
				if(gvPlayer == 0 && getroottable().rawin(game.playerchar)) newActor(getroottable()[game.playerchar], i.x, i.y - 16)
				break

			case 1:
				newActor(Coin, i.x + 8, i.y - 8)
				break

			case 2:
				newActor(ItemBlock, i.x + 8, i.y - 8)
				game.maxcoins++
				break

			case 3:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 1
				break

			case 4:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 2
				break

			case 5:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 3
				break

			case 6:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 5
				break

			case 7:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 4
				break

			case 8:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 6
				break

			case 9:
				newActor(BadCannon, i.x + 8, i.y - 8)
				break

			case 10:
				newActor(PipeSnake, i.x, i.y)
				//Enemies are counted at level creation so ones created indefinitely don't count against achievements
				game.enemies++
				break

			case 11:
				local c = actor[newActor(PipeSnake, i.x, i.y - 16)]
				c.flip = -1
				game.enemies++
				break

			case 12:
				newActor(Deathcap, i.x + 8, i.y - 8)
				game.enemies++
				break

			case 13:
				local c = newActor(Deathcap, i.x + 8, i.y - 8)
				actor[c].smart = true
				game.enemies++
				break

			case 14:
				newActor(IceBlock, i.x + 8, i.y - 8)
				break

			case 15:
				newActor(WoodBlock, i.x + 8, i.y - 8)
				break

			case 16:
				newActor(Spring, i.x, i.y - 16)
				break

			case 17:
				local c = actor[newActor(Spring, i.x, i.y - 16)]
				c.dir = 1
				break

			case 18:
				local c = actor[newActor(Spring, i.x, i.y - 16)]
				c.dir = 2
				break

			case 19:
				local c = actor[newActor(Spring, i.x, i.y - 16)]
				c.dir = 3
				break

			case 20:
				newActor(Ouchin, i.x + 8, i.y - 8)
				break

			case 21:
				local c = actor[newActor(TriggerBlock, i.x + 8, i.y - 8)]
				c.code = i.name
				break

			case 22:
				local c = actor[newActor(InfoBlock, i.x + 8, i.y - 8)]
				if(i.name != "") c.text = gvLangObj["info"][i.name]
				break

			case 23:
				local c = actor[newActor(KelvinScarf, i.x + 8, i.y - 8)]
				if(i.name != "") c.text = gvLangObj["devcom"][i.name]
				break

			case 24:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 7
				break

			case 25:
				newActor(FlyRefresh, i.x + 8, i.y - 8)
				break

			case 26:
				newActor(CarlBoom, i.x + 8, i.y - 8)
				game.enemies++
				break

			case 27:
				newActor(SnowBounce, i.x + 8, i.y - 8)
				game.enemies++
				break

			case 28:
				newActor(BlueFish, i.x + 8, i.y - 8)
				game.enemies++
				break

			case 30:
				newActor(BounceBlock, i.x + 8, i.y - 8)
				break

			case 31:
				local c = actor[newActor(NPC, i.x, i.y)]
				c.args = i.name
				break

			case 32:
				newActor(Checkpoint, i.x + 8, i.y - 16)
				break

			case 33:
				local c = actor[newActor(ItemBlock, i.x + 8, i.y - 8)]
				c.item = 8
				break

			case 34:
				newActor(TNT, i.x + 8, i.y - 8)
				break
		}
	}

	if(gvPlayer != 0) {
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

	//Reset auto/locked controls
	autocon.up = false
	autocon.down = false
	autocon.left = false
	autocon.right = false

	update()
}

::gmPlay <- function()
{
	local px = 0
	local py = 0
	local ux = gvMap.w - screenW()
	local uy = gvMap.h - screenH()

	if(gvPlayer != 0)
	{
		px = (gvPlayer.x + gvPlayer.hspeed * 32) - (screenW() / 2)
		py = (gvPlayer.y + gvPlayer.vspeed * 8) - (screenH() / 2)
	} else {
		px = camx
		py = camy
	}

	camx += (px - camx) / 16
	camy += (py - camy) / 8

	if(camx > ux) camx = ux
	if(camx < 0) camx = 0
	if(camy > uy) camy = uy
	if(camy < 0) camy = 0

	drawBG()
	gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16), floor(camy / 16), 21, 17, "bg")
	gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16), floor(camy / 16), 21, 17, "mg")
	runActors()
	if(actor.rawin("Water")) foreach(i in actor["Water"]) { i.draw() }
	gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16), floor(camy / 16), 21, 17, "fg")
	if(actor.rawin("SecretWall")) foreach(i in actor["SecretWall"]) { i.draw() }
	if(debug) gvMap.drawTiles(floor(-camx), floor(-camy), floor(camx / 16), floor(camy / 16), 21, 17, "solid")

	if(gvInfoBox == "") {
		drawText(font2, screenW() - (gvMap.name.len() * 10) - 4, 8, gvMap.name)
		for(local i = 0; i < game.maxHealth; i++) {
			if(i < game.health) drawSprite(sprHealth, 1, 8 + (16 * i), 8)
			else drawSprite(sprHealth, 0, 8 + (16 * i), 8)
		}
		for(local i = 0; i < 4; i++) {
			if(gvPlayer != 0) {
				if(gvPlayer.rawin("flaps") && game.weapon == 3) {
					if(i < floor(gvPlayer.flaps)) drawSprite(sprEnergy, 1, 8 + (16 * i), 24)
					else drawSprite(sprEnergy, 0, 8 + (16 * i), 24)
				}

				if(gvPlayer.rawin("mana")) { //For Midi's bombs
					if(i < floor(gvPlayer.mana)) drawSprite(sprEnergy, 1, 8 + (16 * i), 24)
					else drawSprite(sprEnergy, 0, 8 + (16 * i), 24)
				}
			}
		}
		drawSprite(sprCoin, 0, 16, screenH() - 16)
		if(game.maxcoins > 0) drawText(font2, 24, screenH() - 23, game.levelcoins.tostring() + "/" + game.maxcoins.tostring())
		else drawText(font2, 24, screenH() - 23, game.coins.tostring())
		drawSprite(game.characters[game.playerchar], 0, screenW() - 16, screenH() - 12)
		drawText(font2, screenW() - 26 - (game.lives.tostring().len() * 8), screenH() - 23, game.lives.tostring())
	}
	else {
		local ln = 3
		for(local i = 0; i < gvInfoBox.len(); i++) {
			if(chint(gvInfoBox[i])  == "\n") ln++
		}
		setDrawColor(0x000000d0)
		drawRec(0, 0, 320, 8 * ln, true)
		drawText(font, 8, 8, gvInfoBox)

	}
	drawDebug()

	if(keyPress(k_escape)) startOverworld(game.world)
}

::playerTeleport <- function(_x, _y) { //Used to move the player and camera at the same time
	if(gvPlayer == 0) return
	if(gvMap == 0) return

	local ux = gvMap.w - screenW()
	local uy = gvMap.h - screenH()

	gvPlayer.x = _x.tofloat()
	gvPlayer.y = _y.tofloat()
	camx = _x.tofloat() - (screenW() / 2)
	camy = _y.tofloat() - (screenH() / 2)

	if(camx > ux) camx = ux
	if(camx < 0) camx = 0
	if(camy > uy) camy = uy
	if(camy < 0) camy = 0
}