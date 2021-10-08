/*======*\
| ASSETS |
\*======*/

//Main sprites
::sprFont <- newSprite("res/gfx/font.png", 6, 8, 0, 0, 0, 0)
::font <- newFont(sprFont, 0, 0, 0, 0)
::sprFont2 <- newSprite("res/gfx/font2.png", 12, 14, 0, 0, 0, 0)
::font2 <- newFont(sprFont2, 33, 0, 0, -4)
::sprDebug <- newSprite("res/gfx/debugkeys.png", 8, 8, 0, 0, 0, 0)
::sprTitle <- newSprite("res/gfx/title.png", 220, 55, 0, 0, 110, 0)

::sprTux <- newSprite("res/gfx/tux.png", 32, 32, 0, 0, 15, 19)
::sprTuxFire <- newSprite("res/gfx/tuxfire.png", 32, 32, 0, 0, 15, 19)
::sprTuxIce <- newSprite("res/gfx/tuxice.png", 32, 32, 0, 0, 15, 19)
::sprTuxAir <- newSprite("res/gfx/tuxair.png", 32, 32, 0, 0, 15, 19)
::sprTuxOverworld <- newSprite("res/gfx/tuxO.png", 14, 17, 0, 0, 7, 14)

//GUI
::sprHealth <- newSprite("res/gfx/heart.png",16, 16, 0, 0, 0, 0)
::sprEnergy <- newSprite("res/gfx/energy.png" 16, 16, 0, 0, 0, 0)
::sprLevels <- newSprite("res/gfx/levelicons.png", 16, 16, 0, 0, 8, 8)

//Blocks
::sprBoxIce <- newSprite("res/gfx/icebox.png", 16, 16, 0, 0, 0, 0)
::sprBoxItem <- newSprite("res/gfx/itembox.png", 16, 16, 0, 0, 0, 0)
::sprBoxRed <- newSprite("res/gfx/redbox.png", 16, 16, 0, 0, 0, 0)
::sprBoxEmpty <- newSprite("res/gfx/emptybox.png", 16, 16, 0, 0, 0, 0)
::sprSpring <- newSprite("res/gfx/spring.png", 16, 16, 0, 0, 0, 0)
::sprWoodBox <- newSprite("res/gfx/woodbox.png", 16, 16, 0, 0, 0, 0)
::sprIceBlock <- newSprite("res/gfx/iceblock.png", 16, 16, 0, 0, 0, 0)
::sprWoodChunks <- newSprite("res/gfx/woodchunks.png", 8, 8, 0, 0, 4, 4)
::sprBoxInfo <- newSprite("res/gfx/infobox.png", 16, 16, 0, 0, 0, 0)
::sprKelvinScarf <- newSprite("res/gfx/kelvinscarf.png", 16, 16, 0, 0, 0, 0)
::sprBoxBounce <- newSprite("res/gfx/bouncebox.png", 16, 16, 0, 0, 0, 0)
::sprCheckBell <- newSprite("res/gfx/bell.png", 16, 16, 0, 0, 8, 0)
::sprTNT <- newSprite("res/gfx/tnt.png", 16, 16, 0, 0, 0, 0)
::sprC4 <- newSprite("res/gfx/c4.png", 16, 16, 0, 0, 0, 0)

//NPCs
::sprRadGuin <- newSprite("res/gfx/radguin.png", 22, 32, 0, 0, 16, 32)

//Enemies
::sprSnake <- newSprite("res/gfx/snake.png", 16, 32, 0, 0, 8, 0)
::sprDeathcap <- newSprite("res/gfx/deathcap.png", 16, 16, 0, 0, 8, 9)
::sprGradcap <- newSprite("res/gfx/smartcap.png", 16, 18, 0, 0, 8, 11)
::sprNolok <- newSprite("res/gfx/nolok.png", 64, 64, 0, 0, 32, 40)
::sprSnowBounce <- newSprite("res/gfx/bouncysnow.png", 16, 16, 0, 0, 8, 8)
::sprCannon <- newSprite("res/gfx/cannon.png", 16, 16, 0, 0, 8, 8)
::sprCannonBob <- newSprite("res/gfx/cannonbob.png", 16, 16, 0, 0, 8, 8)
::sprOuchin <- newSprite("res/gfx/ouchin.png", 16, 16, 0, 0, 8, 8)
::sprCarlBoom <- newSprite("res/gfx/carlboom.png", 16, 16, 0, 0, 8, 8)
::sprBlueFish <- newSprite("res/gfx/fishblue.png", 28, 20, 0, 0, 16, 12)
::sprRedFish <- newSprite("res/gfx/fishred.png", 28, 20, 0, 0, 16, 12)

//Items
::sprMuffin <- newSprite("res/gfx/muffin.png", 16, 16, 0, 0, 8, 8)
::sprStar <- newSprite("res/gfx/starnyan.png", 16, 16, 0, 0, 8, 8)
::sprCoin <- newSprite("res/gfx/coin.png", 16, 16, 0, 0, 8, 8)
::sprFlowerFire <- newSprite("res/gfx/fireflower.png", 16, 16, 0, 0, 8, 8)
::sprFlowerIce <- newSprite("res/gfx/iceflower.png", 16, 16, 0, 0, 8, 8)
::sprAirFeather <- newSprite("res/gfx/airfeather.png", 16, 16, 0, 0, 8, 8)
::sprFlyRefresh <- newSprite("res/gfx/featherspin.png", 16, 16, 0, 0, 8, 8)

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

//Tilesets
::tsActors <- newSprite("res/gfx/actors.png", 16, 16, 0, 0, 0, 0)
::tsIceCave <- newSprite("res/gfx/icecavetiles.png", 16, 16, 0, 0, 0, 0)
::tsIgloo <- newSprite("res/gfx/igloo.png", 16, 16, 0, 0, 0, 0)
::tsPipes <- newSprite("res/gfx/pipetiles.png", 16, 16, 0, 0, 0, 0)
::tsGrass <- newSprite("res/gfx/tsGrasstop.png", 16, 16, 0, 0, 0, 0)
::tsDark <- newSprite("res/gfx/darktiles.png", 16, 16, 0, 0, 0, 0)
::tsWoodPlat <- newSprite("res/gfx/woodplat.png", 16, 16, 0, 0, 0, 0)
::tsRopes <- newSprite("res/gfx/rope.png", 16, 16, 0, 0, 0, 0)
::tsSnow <- newSprite("res/gfx/tsSnow.png", 16, 16, 0, 0, 0, 0)
::tsSigns <- newSprite("res/gfx/signpost.png", 16, 16, 0, 0, 0, 0)
::tsGoal <- newSprite("res/gfx/goal.png", 16, 16, 0, 0, 0, 0)
::tsCastle <- newSprite("res/gfx/tsCastle.png", 16, 16, 0, 0, 0, 0)

//Backgrounds
::bgCaveHoles <- newSprite("res/gfx/rockgapsBG.png", 400, 392, 0, 0, 0, 0)
::bgIridia <- newSprite("res/gfx/iridia.png", 100, 56, 0, 0, 0, 0)
::bgAurora <- newSprite("res/gfx/aurora.png", 720, 240, 0, 0, 0, 0)
::bgRiverCity <- newSprite("res/gfx/rivercity.png", 380, 240, 0, 0, 0, 0)
::bgOcean <- newSprite("res/gfx/ocean.png", 480, 240, 0, 0, 0, 0)
::bgForest0 <- newSprite("res/gfx/forest0.png", 128, 180, 0, 0, 0, 0)
::bgForest1 <- newSprite("res/gfx/forest1.png", 128, 180, 0, 0, 0, 0)
::bgWoodedMountain <- newSprite("res/gfx/woodedmountain.png", 720, 240, 0, 0, 0, 0)
::bgStarSky <- newSprite("res/gfx/starysky.png", 240, 240, 0, 0, 0, 0)
::bgUnderwater <- newSprite("res/gfx/underwaterbg.png", 320, 240, 0, 0, 0, 0)
::bgCastle <- newSprite("res/gfx/castlebg.png", 320, 240, 0, 0, 0, 0)

//Sounds
::sndFireball <- loadSound("res/snd/fireball.wav")
::sndJump <- loadSound("res/snd/jump.wav")
::sndHurt <- loadSound("res/snd/hurt.wav")
::sndKick <- loadSound("res/snd/kick.wav")
::sndSquish <- loadSound("res/snd/squish.wav")
::sndCoin <- loadSound("res/snd/coin.wav")
::sndSlide <- loadSound("res/snd/slide.wav")
::sndFlame <- loadSound("res/snd/flame.wav")
::sndSpring <- loadSound("res/snd/trampoline.wav")
::sndDie <- loadSound("res/snd/die.ogg")
::sndWin <- loadSound("res/snd/win.wav")
::sndBump <- loadSound("res/snd/bump.wav")
::sndHeal <- loadSound("res/snd/heal.wav")
::sndFlap <- loadSound("res/snd/flap.wav")
::sndExplodeF <- loadSound("res/snd/explodeF.wav")
::sndFizz <- loadSound("res/snd/fizz.wav")

//Music
::gvMusic <- 0 //Stores the current music so that not too many large songs are loaded at once
::gvMusicName <- ""
::musDisko <- "res/snd/chipdisko.ogg"
::musCave <- "res/snd/cave.mp3"
::musOverworld <- "res/snd/overworld.mp3"
::musCity <- "res/snd/village-mixed.mp3"
::musCastle <- "res/snd/castle.wav"
::musRace <- "res/snd/blackdiamond.mp3"

//Saved separately so that it can be reused frequently
::musInvincible <- loadMusic("res/snd/invincible.wav")

::songPlay <- function(song) {
	gvMusicName = song
	deleteMusic(gvMusic)
	gvMusic = loadMusic(song)
	playMusic(gvMusic, -1)
}

//Maps
::mpTest <- "res/map/test.json"
//Maps won't be loaded all at once.
//The map will be unloaded when done and replaced
//with a new one when the level changes.
