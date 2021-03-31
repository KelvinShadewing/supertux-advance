/*=============*\
| PHYSICS ACTOR |
\*=============*/

::PhysAct <- class extends Actor{
	hspeed = 0.0;
	vspeed = 0.0;
	shape = 0;

	constructor(_x, _y)
	{
		base.constructor(_x, _y);
	}

	function placeFree(_x, _y)
	{
		//Save current location and move
		local px = x;
		local py = y;
		x = _x;
		y = _y;
		local result = false;

		//Check shape against a layer from the current map
		//Find if requested layer exists
		local layer = -1;
		for(local i = 0; i < gvMap.geo.len(); i++)
		{
			if(gvMap.geo[i][0] == "solid") layer = i;
		}

		if(layer == -1)
		{
			x = px;
			y = py;
			return false;
		}

		//If it does, check against each shape on that layer
		for(local i = 0; i < gvMap.geo[layer][1].len(); i++)
		{
			if(hitTest(shape, gvMap.geo[layer][1][i])){
				result = true;
				break;
			}
		}

		//Return to current coordinates
		x = px;
		y = py;
		return result;
	}
}
