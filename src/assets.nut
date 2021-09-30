/*======*\
| ASSETS |
\*======*/

//Main sprites
::sprFont <- newSprite("res/font.png", 6, 8, 0, 0, 0, 0)
::font <- newFont(sprFont, 0, 0, 0, 0)
::sprFont2 <- newSprite("res/font2.png", 12, 14, 0, 0, 0, 0)
::font2 <- newFont(sprFont2, 33, 0, 0, -4)
::sprDebug <- newSprite("res/debugkeys.png", 8, 8, 0, 0, 0, 0)
::sprTitle <- newSprite("res/title.png", 220, 55, 0, 0, 110, 0)

::sprTux <- newSprite("res/tux.png", 32, 32, 0, 0, 15, 19)
::sprTuxFire <- newSprite("res/tuxfire.png", 32, 32, 0, 0, 15, 19)
::sprTuxIce <- newSprite("res/tuxice.png", 32, 32, 0, 0, 15, 19)
::sprTuxAir <- newSprite("res/tuxair.png", 32, 32, 0, 0, 15, 19)
::sprTuxOverworld <- newSprite("res/tuxO.png", 14, 17, 0, 0, 7, 14)

//GUI
::sprHealth <- newSprite("res/heart.png",16, 16, 0, 0, 0, 0)
::sprEnergy <- newSprite("res/energy.png" 16, 16, 0, 0, 0, 0)
::sprLevels <- newSprite("res/levelicons.png", 16, 16, 0, 0, 8, 8)

//Blocks
::sprBoxIce <- newSprite("res/icebox.png", 16, 16, 0, 0, 0, 0)
::sprBoxItem <- newSprite("res/itembox.png", 16, 16, 0, 0, 0, 0)
::sprBoxRed <- newSprite("res/redbox.png", 16, 16, 0, 0, 0, 0)
::sprBoxEmpty <- newSprite("res/emptybox.png", 16, 16, 0, 0, 0, 0)
::sprSpring <- newSprite("res/spring.png", 16, 16, 0, 0, 0, 0)
::sprWoodBox <- newSprite("res/woodbox.png", 16, 16, 0, 0, 0, 0)
::sprIceBlock <- newSprite("res/iceblock.png", 16, 16, 0, 0, 0, 0)
::sprWoodChunks <- newSprite("res/woodchunks.png", 8, 8, 0, 0, 4, 4)
::sprBoxInfo <- newSprite("res/infobox.png", 16, 16, 0, 0, 0, 0)
::sprKelvinScarf <- newSprite("res/kelvinscarf.png", 16, 16, 0, 0, 0, 0)
::sprBoxBounce <- newSprite("res/bouncebox.png", 16, 16, 0, 0, 0, 0)

//NPCs
::sprRadGuin <- newSprite("res/radguin.png", 22, 32, 0, 0, 16, 32)

//Enemies
::sprSnake <- newSprite("res/snake.png", 16, 32, 0, 0, 8, 0)
::sprDeathcap <- newSprite("res/deathcap.png", 16, 16, 0, 0, 8, 9)
::sprGradcap <- newSprite("res/smartcap.png", 16, 18, 0, 0, 8, 11)
::sprNolok <- newSprite("res/nolok.png", 64, 64, 0, 0, 32, 40)
::sprSnowBounce <- newSprite("res/bouncysnow.png", 16, 16, 0, 0, 8, 8)
::sprCannon <- newSprite("res/cannon.png", 16, 16, 0, 0, 8, 8)
::sprCannonBob <- newSprite("res/cannonbob.png", 16, 16, 0, 0, 8, 8)
::sprOuchin <- newSprite("res/ouchin.png", 16, 16, 0, 0, 8, 8)
::sprCarlBoom <- newSprite("res/carlboom.png", 16, 16, 0, 0, 8, 8)
::sprBlueFish <- newSprite("res/fishblue.png", 28, 20, 0, 0, 16, 12)
::sprRedFish <- newSprite("res/fishred.png", 28, 20, 0, 0, 16, 12)

//Items
::sprMuffin <- newSprite("res/muffin.png", 16, 16, 0, 0, 8, 8)
::sprStar <- newSprite("res/starnyan.png", 16, 16, 0, 0, 8, 8)
::sprCoin <- newSprite("res/coin.png", 16, 16, 0, 0, 8, 8)
::sprFlowerFire <- newSprite("res/fireflower.png", 16, 16, 0, 0, 8, 8)
::sprFlowerIce <- newSprite("res/iceflower.png", 16, 16, 0, 0, 8, 8)
::sprAirFeather <- newSprite("res/airfeather.png", 16, 16, 0, 0, 8, 8)
::sprFlyRefresh <- newSprite("res/featherspin.png", 16, 16, 0, 0, 8, 8)

//Effects
::sprSpark <- newSprite("res/spark.png", 12, 16, 0, 0, 6, 8)
::sprGlimmer <- newSprite("res/glimmer.png", 10, 10, 0, 0, 5, 5)
::sprFireball <- newSprite("res/fireball.png", 8, 8, 0, 0, 4, 4)
::sprIceball <- newSprite("res/iceball.png", 6, 6, 0, 0, 3, 3)
::sprPoof <- newSprite("res/poof.png", 16, 16, 0, 0, 8, 8)
::sprFlame <- newSprite("res/flame.png", 14, 20, 0, 0, 7, 12)
::sprFlameTiny <- newSprite("res/tinyflame.png", 8, 8, 0, 0, 4, 4)
::sprIceTrapSmall <- newSprite("res/icetrapsmall.png", 16, 16, 0, 0, 8, 8)
::sprIceTrapLarge <- newSprite("res/icetraplarge.png", 32, 32, 0, 0, 16, 16)
::sprIceTrapTall <- newSprite("res/icetraptall.png", 16, 32, 0, 0, 8, 16)
::sprIceChunks <- newSprite("res/icechunk.png", 8, 8, 0, 0, 4, 4)
::sprTinyWind <- newSprite("res/tinywind.png", 16, 16, 0, 0, 8, 8)
::sprTFflash <- newSprite("res/tfFlash.png", 32, 40, 0, 0, 16, 20)
::sprExplodeF <- newSprite("res/explodeF.png", 24, 24, 0, 0, 12, 12)
::sprExplodeI <- newSprite("res/explodeI.png", 30, 30, 0, 0, 15, 15)
::sprExplodeN <- newSprite("res/explodeN.png", 30, 30, 0, 0, 15, 15)
::sprExplodeT <- newSprite("res/explodeT.png", 32, 32, 0, 0, 16, 16)
::sprWaterSurface <- newSprite("res/watersurface.png" 16, 4, 0, 0, 0, 0)

//Tilesets
::tsActors <- newSprite("res/actors.png", 16, 16, 0, 0, 0, 0)
::tsIceCave <- newSprite("res/icecavetiles.png", 16, 16, 0, 0, 0, 0)
::tsIgloo <- newSprite("res/igloo.png", 16, 16, 0, 0, 0, 0)
::tsPipes <- newSprite("res/pipetiles.png", 16, 16, 0, 0, 0, 0)
::tsGrass <- newSprite("res/tsGrasstop.png", 16, 16, 0, 0, 0, 0)
::tsDark <- newSprite("res/darktiles.png", 16, 16, 0, 0, 0, 0)
::tsWoodPlat <- newSprite("res/woodplat.png", 16, 16, 0, 0, 0, 0)
::tsRopes <- newSprite("res/rope.png", 16, 16, 0, 0, 0, 0)
::tsSnow <- newSprite("res/tsSnow.png", 16, 16, 0, 0, 0, 0)
::tsSigns <- newSprite("res/signpost.png", 16, 16, 0, 0, 0, 0)
::tsGoal <- newSprite("res/goal.png", 16, 16, 0, 0, 0, 0)
::tsCastle <-

//Backgrounds
::bgCaveHoles <- newSprite("res/rockgapsBG.png", 400, 392, 0, 0, 0, 0)
::bgIridia <- newSprite("res/iridia.png", 100, 56, 0, 0, 0, 0)
::bgAurora <- newSprite("res/aurora.png", 720, 240, 0, 0, 0, 0)
::bgRiverCity <- newSprite("res/rivercity.png", 380, 240, 0, 0, 0, 0)
::bgOcean <- newSprite("res/ocean.png", 480, 240, 0, 0, 0, 0)
::bgForest0 <- newSprite("res/forest0.png", 128, 180, 0, 0, 0, 0)
::bgForest1 <- newSprite("res/forest1.png", 128, 180, 0, 0, 0, 0)
::bgWoodedMountain <- newSprite("res/woodedmountain.png", 720, 240, 0, 0, 0, 0)
::bgStarSky <- newSprite("res/starysky.png", 240, 240, 0, 0, 0, 0)
::bgUnderwater <- newSprite("res/underwaterbg.png", 320, 240, 0, 0, 0, 0)
::bgCastle <- newSprite("res/castlebg.png", 320, 240, 0, 0, 0, 0)

//Sounds
::sndFireball <- loadSound("res/fireball.wav")
::sndJump <- loadSound("res/jump.wav")
::sndHurt <- loadSound("res/hurt.wav")
::sndKick <- loadSound("res/kick.wav")
::sndSquish <- loadSound("res/squish.wav")
::sndCoin <- loadSound("res/coin.wav")
::sndSlide <- loadSound("res/slide.wav")
::sndFlame <- loadSound("res/flame.wav")
::sndSpring <- loadSound("res/trampoline.wav")
::sndDie <- loadSound("res/die.ogg")
::sndWin <- loadSound("res/win.wav")
::sndBump <- loadSound("res/bump.wav")
::sndHeal <- loadSound("res/heal.wav")
::sndFlap <- loadSound("res/flap.wav")
::sndExplodeF <- loadSound("res/explodeF.wav")
::sndFizz <- loadSound("res/fizz.wav")

//Music
::gvMusic <- 0 //Stores the current music so that not too many large songs are loaded at once
::gvMusicName <- ""
::musDisko <- "res/chipdisko.ogg"
::musCave <- "res/cave.mp3"
::musOverworld <- "res/overworld.mp3"
::musCity <- "res/village-mixed.mp3"
::musCastle <- "res/castle.wav"
::musRace <- "res/blackdiamond.mp3"

//Saved separately so that it can be reused frequently
::musInvincible <- loadMusic("res/invincible.wav")

::songPlay <- function(song) {
	gvMusicName = song
	deleteMusic(gvMusic)
	gvMusic = loadMusic(song)
	playMusic(gvMusic, -1)
}

//Maps
::mpTest <- "res/test.json"
//Maps won't be loaded all at once.
//The map will be unloaded when done and replaced
//with a new one when the level changes.
