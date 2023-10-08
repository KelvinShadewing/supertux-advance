
//asset stuffs
print("Loading Frostlands overhauled PT2")

//Enemy
::sprBlitz <- newSprite("contrib/frostlands/gfx/enemies/mrblitz.png", 16, 16, 0, 0, 8, 9)
::sprBlitz2 <- newSprite("contrib/frostlands/gfx/enemies/dumbblitz.png", 16, 16, 0, 0, 8, 9)
::sprbsod <- newSprite("contrib/frostlands/gfx/enemies/bsod-Sheet.png", 23, 19, 0, 0, 11, 11)

//music

::musfreeze <- "contrib/frostlands/music/freezingpoint.ogg"
::musturn <- "contrib/frostlands/music/ji_turn.ogg"
::musball <- "contrib/frostlands/music/city-theme.ogg"
::mussal <- "contrib/frostlands/music/worldmap_old.ogg"
::musair <- "contrib/frostlands/music/fried-air.ogg"
::musSUW <- "contrib/frostlands/music/STK-subsea.ogg"
::musRS <- "contrib/frostlands/music/Rough-Start.ogg"

//visual assets
::bgSnowNever <- newSprite("contrib/frostlands/gfx/BG/Anever.png", 720, 240, 0, 0, 0, 0)
::bgGrassNever <- newSprite("contrib/frostlands/gfx/BG/Bnever.png", 1024, 240, 0, 0, 0, 0)
::bgRace <- newSprite("contrib/frostlands/gfx/BG/tuxracer.png", 520, 240, 0, 0, 0, 0)
::bgRace2 <- newSprite("contrib/frostlands/gfx/BG/tuxracer2.png", 520, 240, 0, 0, 0, 0)
::bgError <- newSprite("contrib/frostlands/gfx/BG/glitch.png", 1140, 240, 0, 0, 0, 0)
::sprC1 <- newSprite("contrib/frostlands/gfx/effects/star1.png", 7, 7, 0, 0, 3, 3)
::bgRedmond <- newSprite("contrib/frostlands/gfx/BG/Retro.png", 720, 240, 0, 0, 0, 0)
//snow
::bgAuroraHill <- newSprite("contrib/frostlands/gfx/BG/hills-aurora1.png", 720, 240, 0, 0, 0, 0)
::bgAuroraHill1 <- newSprite("contrib/frostlands/gfx/BG/hills-aurora2.png", 720, 240, 0, 0, 0, 0)
::bgStarHill <- newSprite("contrib/frostlands/gfx/BG/night-hill.png", 720, 240, 0, 0, 0, 0)
::bgStarHill2 <- newSprite("contrib/frostlands/gfx/BG/night-hill2.png", 720, 240, 0, 0, 0, 0)
::bgSnowday <- newSprite("contrib/frostlands/gfx/BG/Snow-day.png", 720, 240, 0, 0, 0, 0)
::bgSnowDusk <- newSprite("contrib/frostlands/gfx/BG/Snow-dusk.png", 720, 240, 0, 0, 0, 0)
::bgSnowstars2 <- newSprite("contrib/frostlands/gfx/BG/Snow-stars2.png", 720, 240, 0, 0, 0, 0)
::bgSnowstars3 <- newSprite("contrib/frostlands/gfx/BG/Snow-stars-moon.png", 720, 240, 0, 0, 0, 0)
::bgPlainHill <- newSprite("contrib/frostlands/gfx/BG/plain-hill.png", 720, 240, 0, 0, 0, 0)
::bgPlainill2 <- newSprite("contrib/frostlands/gfx/BG/plain-hill1.png", 720, 240, 0, 0, 0, 0)
//forest
::bgForestday <- newSprite("contrib/frostlands/gfx/BG/Forest-1.png", 720, 240, 0, 0, 0, 0)
::bgForesttree1<- newSprite("contrib/frostlands/gfx/BG/forest-2.png", 720, 240, 0, 0, 0, 0)
::bgForesttree2 <- newSprite("contrib/frostlands/gfx/BG/forest-3.png", 720, 240, 0, 0, 0, 0)
::bgOceanbg <- newSprite("contrib/frostlands/gfx/BG/ForestFsun.png", 720, 240, 0, 0, 0, 0)
::bgOceancloud <- newSprite("contrib/frostlands/gfx/BG/OceanCF.png", 720, 240, 0, 0, 0, 0)
//tropic
::bgFtropic <- newSprite("contrib/frostlands/gfx/BG/TropicalF.png", 720, 240, 0, 0, 0, 0)
::bgFtropic2 <- newSprite("contrib/frostlands/gfx/BG/TropicalFsun.png", 720, 240, 0, 0, 0, 0)
::bgFtropic3 <- newSprite("contrib/frostlands/gfx/BG/TropicalF2.png", 720, 240, 0, 0, 0, 0)
::bgFtropic0 <- newSprite("contrib/frostlands/gfx/BG/TropicalF0.png", 720, 240, 0, 0, 0, 0)
::bgFtropicM <- newSprite("contrib/frostlands/gfx/BG/tropics-mountans.png", 720, 240, 0, 0, 0, 0)

::bgFtropicSunset <- newSprite("contrib/frostlands/gfx/BG/TropicalSF.png", 720, 240, 0, 0, 0, 0)
::bgFtropicSunset2 <- newSprite("contrib/frostlands/gfx/BG/TropicalSF2.png", 720, 240, 0, 0, 0, 0)

::bgFtropicNight <- newSprite("contrib/frostlands/gfx/BG/TropicalNF.png", 720, 240, 0, 0, 0, 0)
::bgFtropicNight2 <- newSprite("contrib/frostlands/gfx/BG/TropicalNF2.png", 720, 240, 0, 0, 0, 0)
::bgNightcloud <- newSprite("contrib/frostlands/gfx/BG/OceanNF.png", 720, 240, 0, 0, 0, 0)

//NPCS
::sprTinyFireGuinb <- newSprite("contrib/frostlands/gfx/NPC/ash.png", 13, 23, 0, 0, 6, 23)
::sprRKO <- newSprite("contrib/frostlands/gfx/NPC/Rico.png", 18, 46, 0, 0, 9, 46)
::sprmark <- newSprite("contrib/frostlands/gfx/NPC/mark.png", 66, 51, 0, 0, 33, 51)
::sprmarq <- newSprite("contrib/frostlands/gfx/NPC/marqies.png", 53, 40, 0, 0, 26, 40)
::sprEmarq <- newSprite("contrib/frostlands/gfx/NPC/evil.png", 60, 52, 0, 0, 30, 52)
::sprharo <- newSprite("contrib/frostlands/gfx/NPC/harold.png", 44, 43, 0, 0, 22, 43)
::sprTuckles2 <- newSprite("contrib/frostlands/gfx/NPC/tuckles2.png", 18, 34, 0, 0, 8, 34)
::sprFL <- newSprite("contrib/frostlands/gfx/NPC/flameC.png", 19, 52, 0, 0, 8, 52)
::sprterryB <- newSprite("contrib/frostlands/gfx/NPC/terry.png", 37, 51, 0, 0, 16, 51)
::sprNJ <- newSprite("contrib/frostlands/gfx/NPC/ninjarun.png", 19, 18, 0, 0, 19, 18)
::sprPX <- newSprite("contrib/frostlands/gfx/NPC/pix.png", 18, 16, 0, 0, 9, 16)
::sprGlitchy <- newSprite("contrib/frostlands/gfx/NPC/Glitchy.png", 37, 51, 0, 0, 16, 51)
::sprEyet <- newSprite("contrib/frostlands/gfx/NPC/eightman.png", 37, 51, 0, 0, 16, 51)
::sprTheo <- newSprite("contrib/frostlands/gfx/NPC/Theo.png", 21, 47, 0, 0, 10, 47)
::sprMPlayer <- newSprite("contrib/frostlands/gfx/NPC/minetest-player.png", 16, 33, 0, 0, 8, 33)
::sprWallBaller <- newSprite("contrib/frostlands/gfx/NPC/wall-crawler.png", 32, 32, 0, 0, 16, 32)
::sprOceanPants <- newSprite("contrib/frostlands/gfx/NPC/OceanPants.png", 20, 53, 0, 0, 10, 53)
::sprCone <- newSprite("contrib/frostlands/gfx/NPC/Cone.png", 37, 51, 0, 0, 16, 51)
::spribot <- newSprite("contrib/frostlands/gfx/NPC/itembot.png", 37, 51, 0, 0, 16, 51)
::sprfeesh <- newSprite("contrib/frostlands/gfx/NPC/lfish.png", 63, 44, 0, 0, 31, 44)

//OG style
::sprFlowerFireOG <- newSprite("contrib/frostlands/gfx/obj/fl-fireflower.png", 16, 16, 0, 0, 8, 8)
::sprFlowerIceOG <- newSprite("contrib/frostlands/gfx/obj/fl-iceflower.png", 16, 16, 0, 0, 8, 8)
::sprEarthShellOG <- newSprite("contrib/frostlands/gfx/obj/fl-earthshell.png", 16, 16, 0, 0, 8, 8)
::sprInfoBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-infobox.png", 16, 16, 0, 0, 0, 0)
::sprTriggerBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-redbox.png", 16, 16, 0, 0, 0, 0)
::sprItemBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-itembox.png", 16, 16, 0, 0, 0, 0)
::sprSnowballOG <- newSprite("contrib/frostlands/gfx/obj/fl-snowball.png", 16, 16, 0, 0, 8, 8)
::sprStarOG <- newSprite("contrib/frostlands/gfx/obj/fl-star.png", 16, 16, 0, 0, 8, 8)
::sprDarkOG <- newSprite("contrib/frostlands/gfx/obj/fl-darknyan.png", 16, 16, 0, 0, 8, 8)
::sprWoodBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-woodbox.png", 16, 16, 0, 0, 0, 0)
::sprWoodChunksOG <- newSprite("contrib/frostlands/gfx/obj/fl-woodchunks.png", 8, 8, 0, 0, 4, 4)
::sprCoinN1 <- newSprite("contrib/frostlands/gfx/obj/coin-n1.png", 16, 16, 0, 0, 8, 8)
::sprCoinN5 <- newSprite("contrib/frostlands/gfx/obj/coin-n5.png", 16, 16, 0, 0, 8, 8)
::sprCoinN10 <- newSprite("contrib/frostlands/gfx/obj/coin-n10.png", 16, 16, 0, 0, 8, 8)
::sprEmptyBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-emptybox.png", 16, 16, 0, 0, 0, 0)
::sprJumpyOG <- newSprite("contrib/frostlands/gfx/enemies/fl-jumpy.png", 16, 25, 0, 0, 8, 8)
::sprCoinOG <- newSprite("contrib/frostlands/gfx/obj/fl-coin.png", 16, 16, 0, 0, 8, 8)
::sprCoin5OG <- newSprite("contrib/frostlands/gfx/obj/fl-coin5.png", 16, 16, 0, 0, 8, 8)
::sprCoin10OG <- newSprite("contrib/frostlands/gfx/obj/fl-coin10.png", 16, 16, 0, 0, 8, 8)
::sprnewicons <- newSprite("contrib/frostlands/gfx/levelicons.png", 16, 16, 0, 0, 8, 8)
::sprBellfl <- newSprite("contrib/frostlands/gfx/obj/bell-fl.png", 16, 16, 0, 0, 8, 8)
::sprFLDevcom <- newSprite("contrib/frostlands/gfx/obj/kelvinscarf.png", 16, 16, 0, 0, 0, 0)
::sprFLBounce <- newSprite("contrib/frostlands/gfx/obj/fl-bouncebox.png", 16, 16, 0, 0, 0, 0)

::sprHealthFL <- newSprite("contrib/frostlands/gfx/fl-health.png", 16, 16, 0, 0, 0, 0)
::sprEnergyFl <- newSprite("contrib/frostlands/gfx/fl-energy.png", 16, 16, 0, 0, 0, 0)
::sprSubItemFL <- newSprite("contrib/frostlands/gfx/fl-itemcard.png", 20, 20, 0, 0, 10, 10)
::sprColorSwitchFL <- newSprite("contrib/frostlands/gfx/obj/colorswitches.png", 32, 32, 0, 0, 16, 16)
::sprColorBlockFL <- newSprite("contrib/frostlands/gfx/switchblocks.png", 16, 16, 0, 0, 0, 0)

::gfxOverrideFL <- function(never = false) {
	sprWoodBox = sprWoodBoxOG
	sprWoodChunks = sprWoodChunksOG


	sprFlowerFire = sprFlowerFireOG
	sprFlowerIce = sprFlowerIceOG
	sprEarthShell = sprEarthShellOG
	sprStar = sprStarOG
	sprDarkStar = sprDarkOG
	sprJumpy = sprJumpyOG

	sprBoxInfo = sprInfoBoxOG
	sprBoxItem = sprItemBoxOG
	sprBoxEmpty = sprEmptyBoxOG
	sprBoxRed = sprTriggerBoxOG
	sprCoin = sprCoinOG
	sprCoin5 = sprCoin5OG
	sprCoin10 = sprCoin10OG
	sprEnergy = sprEnergyFl
	sprSubItem = sprSubItemFL
	sprColorSwitch = sprColorSwitchFL
	sprColorBlock = sprColorBlockFL
	sprLevels = sprnewicons
	sprCheckBell = sprBellfl
	sprKelvinScarf = sprFLDevcom
	sprBoxBounce = sprFLBounce
	
	if(never) {
		sprCoin = sprCoinN1
		sprCoin5 = sprCoinN5
		sprCoin10 = sprCoinN10
	}
}

//custom backgrounds

::dbgForestF <- function() {
	gvLightBG = true
	for(local i = 0; i < 2; i++) {
		drawSprite(bgForestday, 0, ((-camx / 16) % 720) + (i * 720), screenH() - 240)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgForesttree2, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgForesttree1 0, ((-camx / 4) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgAuroraF <- function() {
	gvLightBG = true
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowday, 0, ((-camx / 16) % 720) + (i * 720), screenH() - 240)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraHill1, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraHill, 0, ((-camx / 4) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgNever <- function() {
	gvLightBG = true
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowNever, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgRedmond <- function() {
	gvLightBG = true
	for(local i = 0; i < 2; i++) {
		drawSprite(bgRedmond, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}


::dbgSnowPlainF <- function() {
	gvLightBG = true
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowDusk, 0, ((-camx / 16) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgPlainill2, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgPlainHill, 0, ((-camx / 6) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

::dbgNightalt <- function() {
	gvLightBG = true
	drawSprite(bgSnowstars2, 0, 0, (screenH() / 2) - 120)
	for(local i = 0; i < 2; i++) {
		drawSprite(bgStarHill, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgStarHill2, 0, ((-camx / 6) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

::dbgRace <- function() {
	gvLightBG = true
	drawSprite(bgRace, 0, 0, (screenH() / 2) - 120)
}


::dbgglitch <- function() {
	gvLightBG = true
	drawSprite(bgError, 0, 0, (screenH() / 2) - 120)
}

::dbgtropicf <- function() {
	gvLightBG = true
	drawSprite(bgFtropic2, 0, 0, (screenH() / 2) - 120)
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropic0, 0, ((-camx / 32) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropic, 0, ((-camx / 16) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropic3, 0, ((-camx / 10) % 720) + (i * 720), (screenH() / 2) - 80)
	}

}

::dbgtropicFS <- function() {
	gvLightBG = true
	drawSprite(bgOceanbg, 0, 0, (screenH() / 2) - 120)
	for(local i = 0; i < 2; i++) {
		drawSprite(bgOceancloud, 0, ((-camx / 32) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropicSunset, 0, ((-camx / 16) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropicSunset2, 0, ((-camx / 10) % 720) + (i * 720), (screenH() / 2) - 80)
	}

}

::dbgtropicNS <- function() {
	gvLightBG = true
	drawSprite(bgSnowstars2, 0, 0, (screenH() / 2) - 120)
	for(local i = 0; i < 2; i++) {
		drawSprite(bgNightcloud, 0, ((-camx / 32) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropicNight, 0, ((-camx / 16) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropicNight2, 0, ((-camx / 10) % 720) + (i * 720), (screenH() / 2) - 80)
	}

}



::dbgOceanF <- function() {
	gvLightBG = true
	drawSprite(bgOceanbg, 0, 0, (screenH() / 2) - 120)
	for(local i = 0; i < 2; i++) {
		drawSprite(bgOceancloud, 0, ((-camx / 32) % 720) + (i * 720), (screenH() / 2) - 60)
	}

}

::dbgtropicS <- function() {
	gvLightBG = true
	drawSprite(bgFtropic2, 0, 0, (screenH() / 2) - 120)
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropic0, 0, ((-camx / 32) % 720) + (i * 720), (screenH() / 2) - 120)
	}
	for(local i = 0; i < 2; i++) {
		drawSprite(bgFtropicM, 0, ((-camx / 10) % 720) + (i * 720), (screenH() / 2) - 80)
	}

}

//Objec lol 

::Spakle <- class extends Actor{
	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run() {
		if(getFrames() % 3 == 0){
			newActor(c1, x - 16 + randInt(32), y - 16 + randInt(100))
		}
	}
}

::c1 <- class extends Actor {
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		if(frame < 1) frame += 0.02
		frame += 0.05
		y -= 0.5
		if(frame >= 3) deleteActor(id)
	}

	function draw() { drawSpriteEx(sprC1, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1) }
}

::Towershop <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false
	price = 0

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.maxHealth >= 4 * 4) soldout = true
		price = (game.maxHealth + 1) * (200 * (game.difficulty + 1))

		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.maxHealth += 4
				game.coins -= price
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprHealth, getFrames() / 32, x - 8 - camx, y - 8 - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}


//enemies

::Blitz <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = true
	moving = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = _arr
	}

	function routine() {}
	function animation() {}
	function run() {
		base.run()
		smart = true
		if(gvPlayer && abs(x - gvPlayer.x) <= 220 && frozen <= 0 && squish == false && abs(y - gvPlayer.y) <= 160) {
			if(getFrames() % 120 == 0){
				local c = actor[newActor(CannonBob, x - 4, y - 4)]
							c.hspeed = ((gvPlayer.x - x) / 48)
							local d = (y - gvPlayer.y) / 64
			}
		}
		if(active) {
			if(!moving) if(gvPlayer) if(x > gvPlayer.x) {
				flip = true
				moving = true
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(smart) if(placeFree(x - 6, y + 14)) flip = false

						if(x <= 0) flip = false
					}
					else {
						if(placeFree(x + 1, y)) x += 1.0
						else if(placeFree(x + 1, y - 1)) {
							x += 1.0
							y -= 1.0
						} else if(placeFree(x + 2, y - 2)) {
							x += 1.0
							y -= 1.0
						} else flip = true

						if(smart) if(placeFree(x + 6, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()
			}

			if(!squish) shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		local myspr = sprBlitz2
		if(smart) myspr = sprBlitz
		if(frozen) {

			drawSpriteEx(myspr, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else if(squish) drawSpriteEx(myspr, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		else drawSpriteEx(myspr, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
	}

	function hurtPlayer(target) {
		if(squish) return
		base.hurtPlayer(target)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			newActor(Flame, x, y - 1)
			die()
			playSound(sndFlame, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
			return
		}

		if(_element == "ice") {
			frozen = 300
			return
		}

		if(gvPlayer.rawin("anSlide")) {
			if(gvPlayer.anim == gvPlayer.anSlide && hitTest(shape, gvPlayer.shape)) {
				local c = newActor(DeadNME, x, y)
				if(smart) actor[c].sprite = sprBlitz
				else actor[c].sprite = sprBlitz2
				actor[c].vspeed = min(-fabs(gvPlayer.hspeed), -4)
				actor[c].hspeed = (gvPlayer.hspeed / 16)
				actor[c].spin = (gvPlayer.hspeed * 7)
				actor[c].angle = 180
				die()
				playSound(sndKick, 0)
				return
			}
		}

		if(!_stomp) {
			local c = newActor(DeadNME, x, y)
			if(smart) actor[c].sprite = sprBlitz
			else actor[c].sprite = sprBlitz2
			actor[c].vspeed = -4.0
			actor[c].spin = 4
			actor[c].angle = 180
			die()
			popSound(sndKick, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
		} else popSound(sndSquish, 0)

		squish = true
		blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		if(smart) actor[c].sprite = sprBlitz
		else actor[c].sprite = sprBlitz
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		playSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		stopSound(sndFlame)
		playSound(sndFlame, 0)

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 0 }

	function _typeof() { return "Deathcap" }
}

::bsod <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = _arr
	}

	function routine() {}
	function animation() {}

	function run() {
		base.run()
		smart = true

		if(active) {
			if(!moving) {
				if(gvPlayer && x > gvPlayer.x) flip = true
				moving = true
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(smart) if(placeFree(x - 6, y + 14) && !placeFree(x + 2, y + 14)) flip = false

						if(x <= 0) flip = false
					}
					else {
						if(placeFree(x + 1, y)) x += 1.0
						else if(placeFree(x + 1, y - 1)) {
							x += 1.0
							y -= 1.0
						} else if(placeFree(x + 2, y - 2)) {
							x += 1.0
							y -= 1.0
						} else flip = true

						if(smart) if(placeFree(x + 6, y + 14) && !placeFree(x - 2, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()
			}

			if(!squish) shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(frozen) {
			if(smart) drawSpriteEx(sprbsod, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			else drawSpriteEx(sprbsod, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else if(squish) drawSpriteEx(sprbsod, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		else drawSpriteEx(sprbsod, wrap(getFrames() / 12, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
	}

	function hurtPlayer(target) {
		if(blinking) return
		if(squish) return
		base.hurtPlayer(target)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			fireWeapon(ExplodeT, x + randInt(16) - randInt(16) y + randInt(16) - randInt(16), 0, id)
			die()
			return
		}

		if(_element == "ice") {
			fireWeapon(ExplodeT, x + randInt(16) - randInt(16) y + randInt(16) - randInt(16), 0, id)
			die()
			return
		}

		if(gvPlayer.rawin("anSlide")) {
			if(gvPlayer.anim == gvPlayer.anSlide && hitTest(shape, gvPlayer.shape)) {
				local c = newActor(DeadNME, x, y)
				if(smart) actor[c].sprite = sprbsod
				else actor[c].sprite = sprbsod
				actor[c].vspeed = min(-fabs(gvPlayer.hspeed), -4)
				actor[c].hspeed = (gvPlayer.hspeed / 16)
				actor[c].spin = (gvPlayer.hspeed * 7)
				actor[c].angle = 180
				die()
				popSound(sndKick, 0)
				return
			}
		}

		if(!_stomp) {
			local c = newActor(DeadNME, x, y)
			if(smart) actor[c].sprite = sprbsod
			else actor[c].sprite = sprbsod
			actor[c].vspeed = -4.0
			actor[c].spin = 4
			actor[c].angle = 180
			die()
			popSound(sndKick, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
		} else popSound(sndSquish, 0)

		squish = true
		blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		if(smart) actor[c].sprite = sprbsod
		else actor[c].sprite = sprbsod
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		popSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 0 }

	function _typeof() { return "Deathcap" }
}


//hi kelvin lol
//Hi, Frost. ;P

print("Loaded Frostlands")