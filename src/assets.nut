/*======*\
| ASSETS |
\*======*/

//Sprites
::sprFont <- newSprite("res/font.png", 6, 8, 0, 0, 0, 0, 0)
::font <- newFont(sprFont, 0, 0, 0, 0)
::sprFont2 <- newSprite("res/font2.png", 12, 14, 0, 0, 0, 0, 0)
::font2 <- newFont(sprFont2, 33, 0, 0, 0)
::sprDebug <- newSprite("res/debugkeys.png", 8, 8, 0, 0, 0, 0, 0)

::sprTux <- newSprite("res/tux.png", 32, 32, 0, 0, 15, 19, 0)

::sprBoxIce <- newSprite("res/icebox.png", 16, 16, 0, 0, 0, 0, 0)
::sprBoxItem <- newSprite("res/itembox.png", 16, 16, 0, 0, 0, 0, 0)
::sprBoxEmpty <- newSprite("res/emptybox.png", 16, 16, 0, 0, 0, 0, 0)

::sprSnake <- newSprite("res/snake.png", 16, 32, 0, 0, 8, 0, 0)
::sprDeathcap <- newSprite("res/deathcap.png", 16, 16, 0, 0, 8, 8, 0)

::sprMuffin <- newSprite("res/muffin.png", 16, 16, 0, 0, 0, 0, 0)
::sprStar <- newSprite("res/starnyan.png", 16, 16, 0, 0, 0, 0, 0)
::sprCoin <- newSprite("res/coin.png", 16, 16, 0, 0, 0, 0, 0)
::sprHealth <- newSprite("res/heart.png",32, 32, 0, 0, 0, 0, 0)

::sprSpark <- newSprite("res/spark.png", 12, 16, 0, 0, 6, 8, 0)

::fntMain <- newFont(sprFont, 33, 0, 0, -4)

//Tilesets
::tsIceCave <- newSprite("res/icecavetiles.png", 16, 16, 0, 0, 0, 0, 0)
::tsIgloo <- newSprite("res/igloo.png", 16, 16, 0, 0, 0, 0, 0)
::tsPipes <- newSprite("res/pipetiles.png", 16, 16, 0, 0, 0, 0, 0)
::tsGrass <- newSPrite("res/tsGrasstop.png", 16, 16, 0, 0, 0, 0, 0)

//Backgrounds
::bgCaveHoles <- newSprite("res/rockgapsBG.png", 400, 392, 0, 0, 0, 0, 0)
::bgIridia <- newSprite("res/iridia.png", 100, 56, 0, 0, 0, 0, 0)
::bgForest0 <- newSprite("res/parallax-forest-back-trees.png", 272, 180, 0, 0, 0, 0, 0)
::bgForest1 <- newSprite("res/parallax-forest-middle-trees.png", 272, 180, 0, 0, 0, 0, 0)
::bgForest2 <- newSprite("res/parallax-forest-lights.png", 272, 180, 0, 0, 0, 0, 0)
::bgForest3 <- newSprite("res/parallax-forest-front-trees.png", 272, 180, 0, 0, 0, 0, 0)
::bgAurora <- newSprite("res/aurora.png", 720, 240, 0, 0, 0, 0, 0)

//Maps
::mpTest <- "res/test.json"
//Maps won't be loaded all at once.
//The map will be unloaded when done and replaced
//with a new one when the level changes.
