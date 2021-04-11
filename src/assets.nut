/*======*\
| ASSETS |
\*======*/

//Sprites
::sprFont <- newSprite("res/font.png", 6, 8, 0, 0, 0, 0, 0);
::font <- newFont(sprFont, 0, 0, 0, 0);
::sprFont2 <- newSprite("res/font2.png", 12, 14, 0, 0, 0, 0, 0);
::font2 <- newFont(sprFont2, 33, 0, 0, 0);
::sprDebug <- newSprite("res/debugkeys.png", 8, 8, 0, 0, 0, 0, 0);

::sprTux <- newSprite("res/tux.png", 32, 32, 0, 0, 15, 16, 0);

::sprBoxIce <- newSprite("res/icebox.png", 16, 16, 0, 0, 0, 0, 0);
::sprBoxItem <- newSprite("res/itembox.png", 16, 16, 0, 0, 0, 0, 0);
::sprBoxEmpty <- newSprite("res/emptybox.png", 16, 16, 0, 0, 0, 0, 0);

::sprSnake <- newSprite("res/snake.png", 16, 32, 0, 0, 8, 0, 0);

::sprMuffin <- newSprite("res/muffin.png", 16, 16, 0, 0, 0, 0, 0);
::sprStar <- newSprite("res/starnyan.png", 16, 16, 0, 0, 0, 0, 0);
::sprCoin <- newSprite("res/coin.png", 16, 16, 0, 0, 0, 0, 0);
::sprHealth <- newSprite("res/heart.png",32, 32, 0, 0, 0, 0, 0);

::fntMain <- newFont(sprFont, 33, 0, 0, -4);

//Tilesets
::tsIceCave <- newSprite("res/icecavetiles.png", 16, 16, 0, 0, 0, 0, 0);
::tsIgloo <- newSprite("res/igloo.png", 16, 16, 0, 0, 0, 0, 0);

//Maps
::mpTest <- "res/test.json";
//Maps won't be loaded all at once.
//The map will be unloaded when done and replaced
//with a new one when the level changes.