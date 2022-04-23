//asset stuffs
print("Loading Frostlands")

//music

::musfreeze <- "contrib/frostlands/music/freezingpoint.ogg"
::musball <- "contrib/frostlands/music/city-theme.ogg"
::mussal <- "contrib/frostlands/music/salcon.ogg"

//visual assets
::bgAuroraALT <- newSprite("contrib/frostlands/gfx/BG/aurora-alt.png", 720, 240, 0, 0, 0, 0)
::bgSnowPlainALT <- newSprite("contrib/frostlands/gfx/BG/bgSnowPlain-alt.png", 720, 240, 0, 0, 0, 0)
::bgSnowNever <- newSprite("contrib/frostlands/gfx/BG/Anever.png", 720, 240, 0, 0, 0, 0)
::bgRace <- newSprite("contrib/frostlands/gfx/BG/tuxracer.png", 520, 240, 0, 0, 0, 0)
::sprC1 <- newSprite("contrib/frostlands/gfx/effects/star1.png", 7, 7, 0, 0, 3, 3)

//NPCS
::sprTinyFireGuinb <- newSprite("contrib/frostlands/gfx/NPC/tinyfireguinb.png", 13, 23, 0, 0, 6, 23)
::sprRKO <- newSprite("contrib/frostlands/gfx/NPC/Frost.png", 18, 46, 0, 0, 9, 46)
::sprmark <- newSprite("contrib/frostlands/gfx/NPC/mark.png", 67, 48, 0, 0, 32, 47)
::sprmarq <- newSprite("contrib/frostlands/gfx/NPC/marqies.png", 34, 40, 0, 0, 16, 40)
::sprharo <- newSprite("contrib/frostlands/gfx/NPC/harold.png", 44, 43, 0, 0, 22, 43)
::sprTuckles2 <- newSprite("contrib/frostlands/gfx/NPC/tuckles2.png", 18, 34, 0, 0, 8, 34)
::sprFL <- newSprite("contrib/frostlands/gfx/NPC/flameC.png", 18, 42, 0, 0, 8, 42)
::sprterryB <- newSprite("contrib/frostlands/gfx/NPC/terry-behind.png", 37, 51, 0, 0, 16, 51)
::sprNJ <- newSprite("contrib/frostlands/gfx/NPC/ninjarun.png", 19, 18, 0, 0, 19, 18)
::sprPX <- newSprite("contrib/frostlands/gfx/NPC/pix.png", 18, 16, 0, 0, 9, 16)

//OG style
::sprFlowerFireOG <- newSprite("contrib/frostlands/gfx/obj/fl-fireflower.png", 16, 16, 0, 0, 8, 8)
::sprFlowerIceOG <- newSprite("contrib/frostlands/gfx/obj/fl-iceflower.png", 16, 16, 0, 0, 8, 8)
::sprEarthShellOG <- newSprite("contrib/frostlands/gfx/obj/fl-earthshell.png", 16, 16, 0, 0, 8, 8)
::sprInfoBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-infobox.png", 16, 16, 0, 0, 0, 0)
::sprTriggerBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-redbox.png", 16, 16, 0, 0, 0, 0)
::sprItemBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-itembox.png", 16, 16, 0, 0, 0, 0)
::sprSnowballOG <- newSprite("contrib/frostlands/gfx/obj/fl-snowball.png", 16, 16, 0, 0, 8, 8)
::sprStarOG <- newSprite("contrib/frostlands/gfx/obj/fl-star.png", 16, 16, 0, 0, 8, 8)
::sprWoodBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-woodbox.png", 16, 16, 0, 0, 0, 0)
::sprWoodChunksOG <- newSprite("contrib/frostlands/gfx/obj/fl-woodchunks.png", 8, 8, 0, 0, 4, 4)
::sprCoinN1 <- newSprite("contrib/frostlands/gfx/obj/coin-n1.png", 16, 16, 0, 0, 8, 8)
::sprCoinN5 <- newSprite("contrib/frostlands/gfx/obj/coin-n5.png", 16, 16, 0, 0, 8, 8)
::sprCoinN10 <- newSprite("contrib/frostlands/gfx/obj/coin-n10.png", 16, 16, 0, 0, 8, 8)
::sprEmptyBoxOG <- newSprite("contrib/frostlands/gfx/obj/fl-emptybox.png", 16, 16, 0, 0, 0, 0)

::sprHealthFL <- newSprite("contrib/frostlands/gfx/fl-health.png", 16, 16, 0, 0, 0, 0)
::sprEnergyFl <- newSprite("contrib/frostlands/gfx/fl-energy.png", 16, 16, 0, 0, 0, 0)
::sprSubItemFL <- newSprite("contrib/frostlands/gfx/fl-itemcard.png", 20, 20, 0, 0, 10, 10)

::gfxOverrideFL <- function(never = false) {
	sprWoodBox = sprWoodBoxOG
	sprWoodChunks = sprWoodChunksOG


	sprFlowerFire = sprFlowerFireOG
	sprFlowerIce = sprFlowerIceOG
	sprEarthShell = sprEarthShellOG
	sprStar = sprStarOG

	sprBoxInfo = sprInfoBoxOG
	sprBoxItem = sprItemBoxOG
	sprBoxEmpty = sprEmptyBoxOG
	sprBoxRed = sprTriggerBoxOG

	sprHealth = sprHealthFL
	sprEnergy = sprEnergyFl
	sprSubItem = sprSubItemFL

	if(never) {
		sprCoin = sprCoinN1
		sprCoin5 = sprCoinN5
		sprCoin10 = sprCoinN10
		} 
}

//background shiz

::dbgAuroraF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraALT, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgNever <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowNever, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgSnowPlainF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowPlainALT, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

::dbgRace <- function() {
	drawSprite(bgRace, 0, 0, (screenH() / 2) - 120)
}

::TNTALT <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		drawSprite(sprC4, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNTALT" }
}

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
		else drawSpriteEx(sprC1, floor(frame), x - camx, y - camy, 0, 0, 1, 1, 1)
	}
}

print("Loaded Frostlands")