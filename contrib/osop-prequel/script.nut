print("Loaded extras world")

//Music
::musGalacticKnight <- "contrib/osop-prequel/mus/galacticknight.ogg"
::musHellRevenge <- "contrib/osop-prequel/mus/HellishRevenge.ogg"

//NPCs
::sprMona<- newSprite("contrib/osop-prequel/gfx/mona.png", 18, 21, 0, 0, 9, 21)
::sprHubot <- newSprite("contrib/osop-prequel/gfx/hubot-v2.png", 26, 41, 0, 0, 13, 42)
::sprYumi <- newSprite("contrib/osop-prequel/gfx/yumi.png", 24, 34, 0, 0, 12, 36)

//Backgrounds
::bgSpace<- newSprite("contrib/osop-prequel/gfx/space-back.png", 424, 240, 0, 0, 0, 0)
::bgSpaceStars <- newSprite("contrib/osop-prequel/gfx/space-stars.png", 272, 160, 0, 0, 0, 0)

//Load Lifebar
::sprHealthOSoP <- newSprite("contrib/osop-prequel/gfx/osop-health.png", 16, 16, 0, 0, 0, 0)
::sprEnergyOSoP <- newSprite("contrib/osop-prequel/gfx/osop-energy.png", 16, 16, 0, 0, 0, 0)

::gfxOverrideOSoP <- function(never = false) {
	sprHealth = sprHealthOSoP
	sprEnergy = sprEnergyOSoP

}
// BG scripts

//Backgrounds
::dbgSpace <- function() {
	for(local i = 0; i < 32; i++) {
		for(local j = 0; j < 32; j++) {
			drawSprite(bgSpace, 0,  (i * 424), (j * 240))
		}
	}

	for(local i = 0; i < 4; i++) {
		for(local j = 0; j < 4; j++) {
			drawSprite(bgSpaceStars, 0, ((-camx / 4) % 272) + (i * 272), ((-camy / 4) % 160) + (j * 160))
		}
	}
}
//TEMPEND

print("Loaded Frostlands")
freeKonqi()
freeMidi()
freeCyra()
freePenny()
freeKatie()
freeKiki()
freeGDBot()