/*=========*\
| PLAY MODE |
\*=========*/

::startPlay <- function(level)
{
	//Load map to play
	gvMap = Tilemap(level);

	//Clear actors and start creating new ones
	delete actor;
	::actor <- {};

	//Get tiles used to mark actors
	local actset = -1;
	local tilef = 0;
	for(local i = 0; i < gvMap.tileset.len(); i++)
	{
		if(spriteName(gvMap.tileset[i]) == "actors.png")
		{
			actset = gvMap.tileset[i];
			tilef = gvMap.tilef[i];
			break;
		}
	}
	if(actset == -1)
	{
		print("Map does not use actors.png. No actors to load.");
		return;
	}

	//Get layer for actors
	local actlayer = -1;
	foreach(i in gvMap.data.layers)
	{
		if(i["type"] == "objectgroup" && i["name"] == "actor")
		{
			actlayer = i;
			break;
		}
	}
	if(actlayer == -1)
	{
		print("Map does not have an actor layer. No actors to load.");
		return;
	}

	//Start making actors
	foreach(i in actlayer.objects)
	{
		local n = i.gid - tilef;

		//Get the tile number and make an actor
		//according to the image used in actors.png
		switch(n)
		{
			case 0:
				newActor(Tux, i.x, i.y - 16);
				break;
			case 1:
				newActor(Coin, i.x, i.y - 16);
				break;
		}
	}

	//Switch game mode to play
	gvGameMode = gmPlay;
	//If the map loading fails at any point, then it will not change
	//the mode and simply remain where it was. A message is printed
	//in the log if the map fails, so users can check why a level
	//refuses to run.
}

::gmPlay <- function()
{
	gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), 21, 13, "bg");
	runActors();
	gvMap.drawTiles(-camx, -camy, floor(camx / 16), floor(camy / 16), 21, 13, "fg");

	local px = 0;
	local py = 0;
	local ux = (gvMap.data.width * gvMap.data.tilewidth) - 320;
	local uy = (gvMap.data.height * gvMap.data.tileheight) - 180;
	if(game.player != 0)
	{
		px = round(game.player.x - 160);
		py = round(game.player.y - 90);
	}
	camx = floor(px + camx) / 2;
	camy = floor(py + camy) / 2;
	if(distance2(px, py, camx, camy) <= 2)
	{
		camx = px;
		camy = py;
	}

	if(camx > ux) camx = ux;
	if(camx < 0) camx = 0;
	if(camy > uy) camy = uy;
	if(camy < 0) camy = 0;
}
