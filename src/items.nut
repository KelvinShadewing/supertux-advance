/*============*\
| ITEMS SOURCE |
\*============*/

::Coin <- class extends Actor{
	frame = 0.0;

	constructor(_x, _y)
	{
		base.constructor(_x, _y);
		frame = randFloat(4);
	}

	function run()
	{
		frame += 0.1;
		if(x > camx - 16 && x < camx + 320 && y > camy - 16 && y < camy + 180) drawSprite(sprCoin, frame, x - camx, y - camy);
		if(game.player != 0) if(distance2(x + 8, y + 8, game.player.x, game.player.y) <= 16) deleteActor(id);
	}

	function _typeof() { return "Coin"; }
};