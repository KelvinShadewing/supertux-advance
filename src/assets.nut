/*======*\
| ASSETS |
\*======*/

//Main sprites
::sprFont <- newSprite("res/font.png", 6, 8, 0, 0, 0, 0)
::font <- newFont(sprFont, 0, 0, 0, 0)
::sprFont2 <- newSprite("res/font2.png", 12, 14, 0, 0, 0, 0)
::font2 <- newFont(sprFont2, 33, 0, 0, 0)
::sprDebug <- newSprite("res/debugkeys.png", 8, 8, 0, 0, 0, 0)

::sprTux <- newSprite("res/tux.png", 32, 32, 0, 0, 15, 19)

//Blocks
::sprBoxIce <- newSprite("res/icebox.png", 16, 16, 0, 0, 0, 0)
::sprBoxItem <- newSprite("res/itembox.png", 16, 16, 0, 0, 0, 0)
::sprBoxEmpty <- newSprite("res/emptybox.png", 16, 16, 0, 0, 0, 0)
::sprSpring <- newSprite("res/spring.png", 16, 16, 0, 0, 0, 0)
::sprWoodBox <- newSprite("res/woodbox.png", 16, 16, 0, 0, 0, 0)

//Enemies
::sprSnake <- newSprite("res/snake.png", 16, 32, 0, 0, 8, 0)
::sprDeathcap <- newSprite("res/deathcap.png", 16, 16, 0, 0, 8, 8)
::sprNolok <- newSprite("res/nolok.png", 64, 64, 0, 0, 32, 40)
::sprSnowBounce <- newSprite("res/bouncysnow.png", 16, 16, 0, 0, 8, 8)
::sprCannonBob <- newSprite("res/cannonbob.png", 16, 16, 0, 0, 8, 8)
::sprOuchin <- newSprite("res/ouchin.png", 16, 16, 0, 0, 8, 8)

//Items
::sprMuffin <- newSprite("res/muffin.png", 16, 16, 0, 0, 0, 0)
::sprStar <- newSprite("res/starnyan.png", 16, 16, 0, 0, 0, 0)
::sprCoin <- newSprite("res/coin.png", 16, 16, 0, 0, 0, 0)
::sprHealth <- newSprite("res/heart.png",16, 16, 0, 0, 0, 0)

//Effects
::sprSpark <- newSprite("res/spark.png", 12, 16, 0, 0, 6, 8)
::sprFireball <- newSprite("res/fireball.png", 8, 8, 0, 0, 4, 4)
::sprPoof <- newSprite("res/poof.png", 16, 16, 0, 0, 8, 8)

//Tilesets
::tsIceCave <- newSprite("res/icecavetiles.png", 16, 16, 0, 0, 0, 0)
::tsIgloo <- newSprite("res/igloo.png", 16, 16, 0, 0, 0, 0)
::tsPipes <- newSprite("res/pipetiles.png", 16, 16, 0, 0, 0, 0)
::tsGrass <- newSprite("res/tsGrasstop.png", 16, 16, 0, 0, 0, 0)
::tsDark <- newSprite("res/darktiles.png", 16, 16, 0, 0, 0, 0)
::tsWoodPlat <- newSprite("res/woodplat.png", 16, 16, 0, 0, 0, 0)

//Backgrounds
::bgCaveHoles <- newSprite("res/rockgapsBG.png", 400, 392, 0, 0, 0, 0)
::bgIridia <- newSprite("res/iridia.png", 100, 56, 0, 0, 0, 0)
::bgAurora <- newSprite("res/aurora.png", 720, 240, 0, 0, 0, 0)
::bgRiverCity <- newSprite("res/rivercity.png", 380, 240, 0, 0, 0, 0)
::bgForest0 <- newSprite("res/forest0.png", 255, 180, 0, 0, 0, 0)
::bgForest1 <- newSprite("res/forest1.png", 255, 180, 0, 0, 0, 0)
::bgWoodedMountain <- newSprite("res/woodedmountain.png", 720, 240, 0, 0, 0, 0)

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

//Maps
::mpTest <- "res/test.json"
//Maps won't be loaded all at once.
//The map will be unloaded when done and replaced
//with a new one when the level changes.
