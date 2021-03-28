/*=========*\
| PLAY MODE |
\*=========*/

::startPlay <- function(level)
{
	//Switch game mode to play
	gvGameMode = gmPlay;

	//Load map to play
	gvMap = Tilemap(level);

	//Clear actors and start creating new ones
	delete actor;
	::actor <- {};

	//Get tiles used to mark actors
	local actset = -1;
	local tilef = 0;
	for(local i = 0; i < gvMap.tilesets.len(); i++)
	{
		if(spriteName(gvMap.tilesets[i]) == "actors.png")
		{
			actset = gvMap.tilesets[i];
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
	local actlayer <- -1;
	foreach(i in gvMap.data.layers)
	{
		if(i["type"] == "objectgroup" && i["name"] == "actors")
		{
			actlayer = i;
			break;
		}
	}
	if(actlayer == 1)
	{
		print("Map does not have an actor layer. No actors to load.");
		return;
	}

	//
}

::gmPlay <- function()
{

}