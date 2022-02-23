/*======*\
| ASSETS |
\*======*/

//Main sprites
::sprFont <- newSprite("res/gfx/font.png", 6, 8, 0, 0, 0, 0)
::font <- newFont(sprFont, 0, 0, true, 0)
::sprFont2 <- newSprite("res/gfx/font2.png", 12, 14, 0, 0, 0, 0)
::font2 <- newFont(sprFont2, 33, 0, true, -4)
::sprDebug <- newSprite("res/gfx/debugkeys.png", 8, 8, 0, 0, 0, 0)
::sprTitle <- newSprite("res/gfx/title.png", 220, 55, 0, 0, 110, 0)

::sprTux <- newSprite("res/gfx/tux.png", 32, 32, 0, 0, 15, 19)
::sprTuxFire <- newSprite("res/gfx/tuxfire.png", 32, 32, 0, 0, 15, 19)
::sprTuxIce <- newSprite("res/gfx/tuxice.png", 32, 32, 0, 0, 15, 19)
::sprTuxAir <- newSprite("res/gfx/tuxair.png", 32, 32, 0, 0, 15, 19)
::sprTuxEarth <- newSprite("res/gfx/tuxearth.png", 32, 32, 0, 0, 15, 19)
::sprTuxOverworld <- newSprite("res/gfx/tuxO.png", 14, 17, 0, 0, 7, 14)
::sprTuxDoll <- newSprite("res/gfx/tuxdoll.png", 16, 16, 0, 0, 8, 14)

::sprKonqi <- newSprite("res/gfx/konqi.png", 32, 32, 0, 0, 15, 19)
::sprKonqiFire <- newSprite("res/gfx/konqifire.png", 32, 32, 0, 0, 15, 19)
::sprKonqiIce <- newSprite("res/gfx/konqiice.png", 32, 32, 0, 0, 15, 19)
::sprKonqiAir <- newSprite("res/gfx/konqiair.png", 32, 32, 0, 0, 15, 19)
::sprKonqiEarth <- newSprite("res/gfx/konqiearth.png", 32, 32, 0, 0, 15, 19)
::sprKonqiOverworld <- newSprite("res/gfx/konqiO.png", 14, 20, 0, 0, 7, 17)
::sprKonqiDoll <- newSprite("res/gfx/konqidoll.png", 16, 16, 0, 0, 8, 14)

::sprMidi <- newSprite("res/gfx/midi.png", 32, 32, 0, 0, 15, 19)
::sprMidiOverworld <- newSprite("res/gfx/midiO.png", 14, 20, 0, 0, 7, 17)
::sprMidiDoll <- newSprite("res/gfx/mididoll.png", 16, 16, 0, 0, 8, 14)

//GUI
::sprHealth <- newSprite("res/gfx/heart.png",16, 16, 0, 0, 0, 0)
::sprEnergy <- newSprite("res/gfx/energy.png" 16, 16, 0, 0, 0, 0)
::sprLevels <- newSprite("res/gfx/levelicons.png", 16, 16, 0, 0, 8, 8)
::sprSubItem <- newSprite("res/gfx/itemcard.png", 20, 20, 0, 0, 10, 10)
::sprWarning <- newSprite("res/gfx/warning.png", 280, 72, 0, 0, 140, 36)

//Blocks
::sprVoid <- newSprite("res/gfx/void.png", 16, 32, 0, 0, 0, 0)
::sprBoxIce <- newSprite("res/gfx/icebox.png", 16, 16, 0, 0, 0, 0)
::sprBoxItem <- newSprite("res/gfx/itembox.png", 16, 16, 0, 0, 0, 0)
::sprBoxRed <- newSprite("res/gfx/redbox.png", 16, 16, 0, 0, 0, 0)
::sprBoxEmpty <- newSprite("res/gfx/emptybox.png", 16, 16, 0, 0, 0, 0)
::sprSpring <- newSprite("res/gfx/spring.png", 16, 16, 0, 0, 8, 8)
::sprSpringD <- newSprite("res/gfx/springd.png", 16, 16, 0, 0, 8, 8)
::sprWoodBox <- newSprite("res/gfx/woodbox.png", 16, 16, 0, 0, 0, 0)
::sprIceBlock <- newSprite("res/gfx/iceblock.png", 16, 16, 0, 0, 0, 0)
::sprWoodChunks <- newSprite("res/gfx/woodchunks.png", 8, 8, 0, 0, 4, 4)
::sprBoxInfo <- newSprite("res/gfx/infobox.png", 16, 16, 0, 0, 0, 0)
::sprKelvinScarf <- newSprite("res/gfx/kelvinscarf.png", 16, 16, 0, 0, 0, 0)
::sprBoxBounce <- newSprite("res/gfx/bouncebox.png", 16, 16, 0, 0, 0, 0)
::sprCheckBell <- newSprite("res/gfx/bell.png", 16, 16, 0, 0, 8, 0)
::sprTNT <- newSprite("res/gfx/tnt.png", 16, 16, 0, 0, 0, 0)
::sprC4 <- newSprite("res/gfx/c4.png", 16, 16, 0, 0, 0, 0)
::sprColorBlock <- newSprite("res/gfx/switchblocks.png", 16, 16, 0, 0, 0, 0)
::sprColorSwitch <- newSprite("res/gfx/colorswitches.png", 32, 32, 0, 0, 16, 16)
::sprLockBlock <- newSprite("res/gfx/lock.png", 16, 16, 0, 0, 8, 8)
::sprBossDoor <- newSprite("res/gfx/boss-door.png", 16, 32, 0, 0, 0, 0)

//NPCs
::sprRadGuin <- newSprite("res/gfx/radguin.png", 22, 32, 0, 0, 16, 32)
::sprPenny <- newSprite("res/gfx/penny.png", 14, 24, 0, 0, 7, 24)
::sprXue <- newSprite("res/gfx/xue.png", 20, 23, 0, 0, 12, 23)
::sprPlasmaBreeze <- newSprite("res/gfx/plasmabreeze.png", 30, 32, 0, 0, 15, 32)
::sprRockyRaccoon <- newSprite("res/gfx/rockyraccoon.png", 23, 27, 0, 0, 15, 26)
::sprTinyFireGuin <- newSprite("res/gfx/tinyfireguin.png", 13, 23, 0, 0, 6, 23)
::sprPygame <- newSprite("res/gfx/pygame.png", 32, 38, 0, 0, 16, 38)
::sprGnu <- newSprite("res/gfx/gnu.png", 29, 45, 0, 0, 15, 45)
::sprSam <- newSprite("res/gfx/sam.png", 12, 32, 0, 0, 6, 32)
::sprTuckles <- newSprite("res/gfx/tuckles.png", 18, 34, 0, 0, 8, 34)
::sprGaruda <- newSprite("res/gfx/garuda.png", 35, 36, 0, 0, 17, 36)

//Enemies
::sprSnake <- newSprite("res/gfx/snake.png", 16, 32, 0, 0, 8, 0)
::sprDeathcap <- newSprite("res/gfx/deathcap.png", 16, 16, 0, 0, 8, 9)
::sprGradcap <- newSprite("res/gfx/smartcap.png", 16, 18, 0, 0, 8, 11)
::sprNolok <- newSprite("res/gfx/nolok.png", 64, 64, 0, 0, 32, 40)
::sprSnowBounce <- newSprite("res/gfx/orange.png", 16, 16, 0, 0, 8, 8)
::sprCannon <- newSprite("res/gfx/cannon.png", 16, 16, 0, 0, 8, 8)
::sprCannonBob <- newSprite("res/gfx/cannonbob.png", 16, 16, 0, 0, 8, 8)
::sprOuchin <- newSprite("res/gfx/ouchin.png", 16, 16, 0, 0, 8, 8)
::sprCarlBoom <- newSprite("res/gfx/carlboom.png", 16, 16, 0, 0, 8, 8)
::sprBlueFish <- newSprite("res/gfx/fishblue.png", 28, 20, 0, 0, 16, 12)
::sprRedFish <- newSprite("res/gfx/fishred.png", 28, 20, 0, 0, 16, 12)
::sprGreenFish <- newSprite("res/gfx/fishgreen.png", 28, 20, 0, 0, 16, 12)
::sprDeadFish <- newSprite("res/gfx/deadfish.png", 23, 14, 0, 0, 14, 7)
::sprJellyFish <- newSprite("res/gfx/jellyfish.png", 16, 16, 0, 0, 8, 8)
::sprClamor <- newSprite("res/gfx/clamor.png", 16, 16, 0, 0, 8, 8)
::sprIcicle <- newSprite("res/gfx/icicle.png", 10, 16, 0, 0, 5, 4)
::sprBounceCap <- newSprite("res/gfx/bouncecap.png", 16, 16, 0, 0, 8, 8)
::sprFlyAmanita <- newSprite("res/gfx/flyamanita.png", 20, 20, 0, 0, 10, 10)
::sprJumpy <- newSprite("res/gfx/bouncecap.png", 16, 16, 0, 0, 8, 8)
::sprDarkStar <- newSprite("res/gfx/darknyan.png", 16, 16, 0, 0, 8, 8)
::sprHaywire <- newSprite("res/gfx/haywire.png", 16, 16, 0, 0, 8, 8)
::sprSawblade <- newSprite("res/gfx/sawblade.png", 16, 16, 0, 0, 8, 8)
::sprLivewire <- newSprite("res/gfx/Livewire.png", 16, 16, 0, 0, 8, 8)
::sprBLZBRN <- newSprite("res/gfx/Blazeborn.png", 16, 16, 0, 0, 8, 9)

//Items
::sprMuffin <- newSprite("res/gfx/muffin.png", 16, 16, 0, 0, 8, 8)
::sprStar <- newSprite("res/gfx/starnyan.png", 16, 16, 0, 0, 8, 8)
::sprCoin <- newSprite("res/gfx/coin.png", 16, 16, 0, 0, 8, 8)
::sprCoin5 <- newSprite("res/gfx/5coin.png", 16, 16, 0, 0, 8, 8)
::sprCoin10 <- newSprite("res/gfx/10coin.png", 16, 16, 0, 0, 8, 8)
::sprFlowerFire <- newSprite("res/gfx/fireflower.png", 16, 16, 0, 0, 8, 8)
::sprFlowerIce <- newSprite("res/gfx/iceflower.png", 16, 16, 0, 0, 8, 8)
::sprAirFeather <- newSprite("res/gfx/airfeather.png", 16, 16, 0, 0, 8, 8)
::sprFlyRefresh <- newSprite("res/gfx/featherspin.png", 16, 16, 0, 0, 8, 8)
::sprEarthShell <- newSprite("res/gfx/earthshell.png", 16, 16, 0, 0, 8, 8)
::sprBerry <- newSprite("res/gfx/strawberry.png", 10, 12, 0, 0, 5, 6)
::sprKeyCopper <- newSprite("res/gfx/key-copper.png", 16, 16, 0, 0, 8, 8)
::sprKeySilver <- newSprite("res/gfx/key-silver.png", 16, 16, 0, 0, 8, 8)
::sprKeyGold <- newSprite("res/gfx/key-gold.png", 16, 16, 0, 0, 8, 8)
::sprKeyMythril <- newSprite("res/gfx/key-mythril.png", 16, 16, 0, 0, 8, 8)

//Effects
::sprSpark <- newSprite("res/gfx/spark.png", 12, 16, 0, 0, 6, 8)
::sprGlimmer <- newSprite("res/gfx/glimmer.png", 10, 10, 0, 0, 5, 5)
::sprFireball <- newSprite("res/gfx/fireball.png", 8, 8, 0, 0, 4, 4)
::sprIceball <- newSprite("res/gfx/iceball.png", 6, 6, 0, 0, 3, 3)
::sprPoof <- newSprite("res/gfx/poof.png", 16, 16, 0, 0, 8, 8)
::sprFlame <- newSprite("res/gfx/flame.png", 14, 20, 0, 0, 7, 12)
::sprFlameTiny <- newSprite("res/gfx/tinyflame.png", 8, 8, 0, 0, 4, 4)
::sprIceTrapSmall <- newSprite("res/gfx/icetrapsmall.png", 16, 16, 0, 0, 8, 8)
::sprIceTrapLarge <- newSprite("res/gfx/icetraplarge.png", 32, 32, 0, 0, 16, 16)
::sprIceTrapTall <- newSprite("res/gfx/icetraptall.png", 16, 32, 0, 0, 8, 16)
::sprIceChunks <- newSprite("res/gfx/icechunk.png", 8, 8, 0, 0, 4, 4)
::sprTinyWind <- newSprite("res/gfx/tinywind.png", 16, 16, 0, 0, 8, 8)
::sprTFflash <- newSprite("res/gfx/tfFlash.png", 32, 40, 0, 0, 16, 20)
::sprExplodeF <- newSprite("res/gfx/explodeF.png", 24, 24, 0, 0, 12, 12)
::sprExplodeI <- newSprite("res/gfx/explodeI.png", 30, 30, 0, 0, 15, 15)
::sprExplodeN <- newSprite("res/gfx/explodeN.png", 30, 30, 0, 0, 15, 15)
::sprExplodeT <- newSprite("res/gfx/explodeT.png", 32, 32, 0, 0, 16, 16)
::sprWaterSurface <- newSprite("res/gfx/watersurface.png" 16, 4, 0, 0, 0, 0)
::sprHeal <- newSprite("res/gfx/heal.png", 7, 7, 0, 0, 3, 3)
::sprSplash <- newSprite("res/gfx/splash.png", 21, 17, 0, 0, 12, 16)

//Backgrounds
::bgPause <- 0
::bgCaveHoles <- newSprite("res/gfx/rockgapsBG.png", 400, 392, 0, 0, 0, 0)
::bgIridia <- newSprite("res/gfx/iridia.png", 100, 56, 0, 0, 0, 0)
::bgAurora <- newSprite("res/gfx/aurora.png", 720, 240, 0, 0, 0, 0)
::bgAuroraNight <- newSprite("res/gfx/aurora-night.png", 720, 240, 0, 0, 0, 0)
::bgRiverCity <- newSprite("res/gfx/rivercity.png", 380, 240, 0, 0, 0, 0)
::bgOcean <- newSprite("res/gfx/ocean.png", 480, 240, 0, 0, 0, 0)
::bgForest0 <- newSprite("res/gfx/forest0.png", 128, 180, 0, 0, 0, 0)
::bgForest1 <- newSprite("res/gfx/forest1.png", 128, 180, 0, 0, 0, 0)
::bgWoodedMountain <- newSprite("res/gfx/woodedmountain.png", 720, 240, 0, 0, 0, 0)
::bgStarSky <- newSprite("res/gfx/starysky.png", 240, 240, 0, 0, 0, 0)
::bgUnderwater <- newSprite("res/gfx/underwaterbg.png", 320, 240, 0, 0, 0, 0)
::bgCastle <- newSprite("res/gfx/castlebg.png", 320, 240, 0, 0, 0, 0)
::bgSnowPlain <- newSprite("res/gfx/bgSnowPlain.png", 720, 240, 0, 0, 0, 0)
::bgSnowNight <- newSprite("res/gfx/bgSnowNight.png", 800, 240, 0, 0, 0, 0)
::bgIceForest <- newSprite("res/gfx/iceforest.png", 640, 240, 0, 0, 0, 0)
::bgIceForest0 <- newSprite("res/gfx/iceforest0.png", 800, 320, 0, 0, 0, 0)
::bgIceForest1 <- newSprite("res/gfx/iceforest1.png", 640, 256, 0, 0, 0, 0)
::bgIceForest2 <- newSprite("res/gfx/iceforest2.png", 480, 192, 0, 0, 0, 0)

//Weather
::weRain <- newSprite("res/gfx/rainfall.png", 64, 64, 0, 0, 0, 0)
::weSnow <- newSprite("res/gfx/snowfall.png", 64, 64, 0, 0, 0, 0)

//Lights
::sprLightBasic <- newSprite("res/gfx/light-player-basic.png", 48, 48, 0, 0, 24, 24)
spriteSetBlendMode(sprLightBasic, bm_add)
::sprLightFire <- newSprite("res/gfx/light-fire.png", 128, 128, 0, 0, 64, 64)
spriteSetBlendMode(sprLightFire, bm_add)
::sprLightIce <- newSprite("res/gfx/light-ice.png", 128, 128, 0, 0, 64, 64)
spriteSetBlendMode(sprLightIce, bm_add)

//Sounds
::sndFireball <- loadSound("res/snd/fireball.ogg")
::sndJump <- loadSound("res/snd/jump.ogg")
::sndHurt <- loadSound("res/snd/hurt.ogg")
::sndKick <- loadSound("res/snd/kick.ogg")
::sndSquish <- loadSound("res/snd/squish.ogg")
::sndCoin <- loadSound("res/snd/coin.ogg")
::sndSlide <- loadSound("res/snd/slide.ogg")
::sndFlame <- loadSound("res/snd/flame.ogg")
::sndSpring <- loadSound("res/snd/trampoline.ogg")
::sndDie <- loadSound("res/snd/die.ogg")
::sndWin <- loadSound("res/snd/win.ogg")
::sndBump <- loadSound("res/snd/bump.ogg")
::sndHeal <- loadSound("res/snd/heal.ogg")
::sndFlap <- loadSound("res/snd/flap.ogg")
::sndExplodeF <- loadSound("res/snd/explodeF.ogg")
::sndFizz <- loadSound("res/snd/fizz.ogg")
::sndBell <- loadSound("res/snd/bell.ogg")
::sndIcicle <- loadSound("res/snd/icicle.ogg")
::sndIceBreak <- loadSound("res/snd/icebreak.ogg")
::snd1up <- loadSound("res/snd/1up.ogg")
::sndWallkick <- loadSound("res/snd/wallkick.ogg")
::sndWarning <- loadSound("res/snd/warning.ogg")
::sndGulp <- loadSound("res/snd/gulp.ogg")

//Music
::gvMusic <- 0 //Stores the current music so that not too many large songs are loaded at once
::gvMusicName <- ""
::gvLastSong <- ""

::musTheme <- "res/snd/supertuxtheme.ogg"
::musDisko <- "res/snd/chipdisko.ogg"
::musCave <- "res/snd/cave.ogg"
::musOverworld <- "res/snd/overworld.ogg"
::musCity <- "res/snd/village-mixed.ogg"
::musCastle <- "res/snd/castle.ogg"
::musRace <- "res/snd/blackdiamond.ogg"
::musDeluge <- "res/snd/deluge.ogg"
::musSnowTown <- "res/snd/winter_wonderland.ogg"
::musAirship <- "res/snd/airship.ogg"
::musPuzzle <- "res/snd/puzzle.ogg"
::musIceland <- "res/snd/iceland.ogg"
::musretro2<- "res/snd/retro-2.ogg"


//Saved separately so that it can be reused frequently
::musInvincible <- loadMusic("res/snd/invincible.ogg")

::songPlay <- function(song) {
	gvMusicName = song
	if(gvMusicName == gvLastSong) return

	deleteMusic(gvMusic)
	gvMusic = loadMusic(song)
	playMusic(gvMusic, -1)

	gvLastSong = song
}
