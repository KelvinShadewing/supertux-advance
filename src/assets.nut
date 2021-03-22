/*======*\
| ASSETS |
\*======*/

//Sprites
::sprTux <- newSprite("res/tux.png", 32, 32, 0, 0, 16, 16, 0);
::sprBoxIce <- newSprite("res/icebox.png", 16, 16, 0, 0, 0, 0, 0);
::sprBoxItem <- newSprite("res/itembox.png", 16, 16, 0, 0, 0, 0, 0);
::sprMuffin <- newSprite("res/muffin.png", 16, 16, 0, 0, 0, 0, 0);
::sprSnake <- newSprite("res/snake.png", 16, 32, 0, 0, 8, 0, 0);
::sprStar <- newSprite("res/starnyan.png", 16, 16, 0, 0, 0, 0, 0);
::sprBoxEmpty <- newSprite("res/emptybox.png", 16, 16, 0, 0, 0, 0, 0);
::sprCoin <- newSprite("res/coin.png", 16, 16, 0, 0, 0, 0, 0);
::sprHealth <- newSprite("res/heart.png",32, 32, 0, 0, 0, 0, 0);

//Tilesets
::tsIceCave <- newSprite("res/icecavetiles.png", 16, 16, 0, 0, 0, 0, 0);
::tsIgloo <- newSprite("res/igloo.png", 16, 16, 0, 0, 0, 0, 0);

//Maps
::mpTest <- "res/test.json";
//Maps won't be loaded all at once.
//The map will be unloaded when done and replaced
//with a new one when the level changes.