////////////////
// TILED MAPS //
////////////////

::tileSearchDir <- ["."]

::findFileName <- function(path) {
	if(typeof path != "string") return ""
	if(path.len() == 0) return ""

	for(local i = path.len() - 1; i >= 0; i--) {
		if(chint(path[i]) == "/" || chint(path[i]) == "\\") return path.slice(i + 1)
	}

	return path
}

///////////////////
// ANIMATED TILE //
///////////////////

::AnimTile <- class {
	frameID = null
	frameList = null
	frameTime = null
	sprite = null

	constructor(animList, _sprite) {
		frameID = animList.id
		frameList = []
		frameTime = []
		for(local i = 0; i < animList.animation.len(); i++) {
			frameList.push(animList.animation[i].tileid)
			if(i == 0) frameTime.push(animList.animation[i].duration)
			else frameTime.push(animList.animation[i].duration + frameTime[i - 1])
		}
		sprite = _sprite
	}

	function draw(x, y, alpha) {
		local currentTime = wrap(getTicks(), 0, frameTime.top())
		for(local i = 0; i < frameList.len(); i++) {
			if(currentTime >= frameTime[i]) {
				if(i < frameTime.len() - 1) {
					if(currentTime < frameTime[i + 1]) {
						drawSpriteEx(sprite, frameList[i], floor(x), floor(y), 0, 0, 1, 1, alpha)
						return
					}
				}
				else if(currentTime <= frameTime[i] && i == 0) {
					drawSpriteEx(sprite, frameList[i], floor(x), floor(y), 0, 0, 1, 1, alpha)
					return
				}
			}
		}

		drawSpriteEx(sprite, frameList.top(), floor(x), floor(y), 0, 0, 1, 1, alpha)
	}
}

///////////////////
// TILEMAP CLASS //
///////////////////

::Tilemap <- class {
	data = null
	tileset = null
	tilef = null
	tilew = 0
	tileh = 0
	mapw = 0
	maph = 0
	geo = null
	w = 0
	h = 0
	name = ""
	file = ""
	solidfid = 0 //First tile ID for the solid tileset
	shape = null
	anim = null //List of animated tiles
	solidLayer = null

	constructor(filename) {
		tileset = []
		tilef = []
		geo = []
		data = {}
		anim = {}

		if(fileExists(filename)) {
			data = jsonRead(fileRead(filename))

			mapw = data.width
			maph = data.height
			tilew = data.tilewidth
			tileh = data.tileheight
			w = mapw * tilew
			h = maph * tileh

			file = filename
			name = findFileName(filename)
			name = name.slice(0, -5)

			print("\nLoading map: " + name)

			for(local i = 0; i < data.tilesets.len(); i++) {
				//Extract filename
				//print("Get filename")
				local filename = data.tilesets[i].image
				local shortname = findFileName(filename)
				//print("Full map name: " + filename + ".")
				print("Searching for tileset: " + shortname)

				local tempspr = findSprite(shortname)
				//("Temp sprite: " + shortname)

				if(tempspr != 0) {
					tileset.push(tempspr)
					print("Found " + shortname)
				}
				else { //Search for file
					if(fileExists(filename)) {
						//print("Attempting to add full filename")
						tileset.push(newSprite(filename, data.tilesets[i].tilewidth, data.tilesets[i].tileheight, data.tilesets[i].margin, data.tilesets[i].spacing, 0, data.tilesets[i].tileheight - data.tileheight))
						print("Added tileset " + shortname + ".")
					}
					else for(local j = 0; j < tileSearchDir.len(); j++) {
						if(fileExists(tileSearchDir[j] + "/" + shortname)) {
							print("Adding " + shortname + " from search path: " + tileSearchDir[j])
							tileset.push(newSprite(tileSearchDir[j] + "/" + shortname, data.tilesets[i].tilewidth, data.tilesets[i].tileheight, data.tilesets[i].margin, data.tilesets[i].spacing, 0, data.tilesets[i].tileheight - data.tileheight))
							break
						}
					}
				}

				tilef.push(data.tilesets[i].firstgid)
				if(data.tilesets[i].name == "solid") solidfid = data.tilesets[i].firstgid

				//Add animations
				if(data.tilesets[i].rawin("tiles")) for(local j = 0; j < data.tilesets[i].tiles.len(); j++) {
					anim[data.tilesets[i].firstgid + data.tilesets[i].tiles[j].id] <- AnimTile(data.tilesets[i].tiles[j], tileset.top())
				}
			}

			//print("Added " + spriteName(tileset[i]) + ".\n")

			for(local i = 0; i < data.layers.len(); i++) {
			if(data.layers[i].type == "objectgroup") {
				local lana = data.layers[i].name //Layer name
				for(local j = 0; j < data.layers[i].objects.len(); j++) {
					local obj = data.layers[i].objects[j]
					switch(lana) {
						case "trigger":
							local c = newActor(Trigger, obj.x + (obj.width / 2), obj.y + (obj.height / 2))
							actor[c].shape = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, obj.height / 2, 0)
							actor[c].code = obj.name
							break
						case "water":
							local c = newActor(Water, obj.x + (obj.width / 2), obj.y + (obj.height / 2))
							actor[c].shape = Rec(obj.x + (obj.width / 2), obj.y + (obj.height / 2), obj.width / 2, (obj.height / 2) - 4, 5)
							break
						case "vmp":
							local c = actor[newActor(PlatformV, obj.x + (obj.width / 2), obj.y + 8)]
							c.w = (obj.width / 2)
							c.r = obj.height - 16
							c.init = 1
							if(obj.name == "up") {
								c.mode = 2
								c.y = c.ystart + c.r
							}
							break
						case "secret":
							local c = actor[newActor(SecretWall, obj.x, obj.y, obj.name)]
							c.dw = obj.width / 16
							c.dh = obj.height / 16
							break
						}
					}
				}
			}


			shape = (Rec(0, 0, 8, 8, 0))

			//Add sky protection
			local l = -1
			for(local i = 0; i < data.layers.len(); i++) {
				if(data.layers[i].name == "solid") {
					l = data.layers[i]
					break
				}
			}
			if(l != -1) {
				for(local i = 0; i < l.width; i++) {
					if(l.data[i] != 0) geo.push(Rec((i * 16) + 8, -1000, 8, 1000, 0))
				}
			}

			for(local i = 0; i < data.layers.len(); i++) {
			if(data.layers[i].type == "tilelayer" && data.layers[i].name == "solid") {
				solidLayer = data.layers[i]
				break
			}
		}
		}
		else print("Map file " + filename + " does not exist!")
	}

	function drawTiles(x, y, mx, my, mw, mh, l, a = 1) { //@mx through @mh are the rectangle of tiles that will be drawn
		//Find layer
		local t = -1; //Target layer
		for(local i = 0; i < data.layers.len(); i++) {
			if(data.layers[i].type == "tilelayer" && data.layers[i].name == l) {
				t = i
				break
			}
		}
		if(t == -1) {
			return; //Quit if no tile layer by that name was found
		}

		//Make sure values are in range
		if(data.layers[t].width < mx + mw) mw = data.layers[t].width - mx
		if(data.layers[t].height < my + mh) mh = data.layers[t].height - my
		if(mx < 0) mx = 0
		if(my < 0) my = 0
		if(mx > data.layers[t].width) mx = data.layers[t].width
		if(my > data.layers[t].height) my = data.layers[t].height

		for(local i = my; i < my + mh; i++) {
			for(local j = mx; j < mx + mw; j++) {
				if(i * data.layers[t].width + j >= data.layers[t].data.len()) return
				local n = data.layers[t].data[(i * data.layers[t].width) + j]; //Number value of the tile
				if(n != 0) {
					for(local k = data.tilesets.len() - 1; k >= 0; k--) {
						if(n >= data.tilesets[k].firstgid) {
							if(anim.rawin(n)) {
								if(tileset[k] == anim[n].sprite) anim[n].draw(x + (j * data.tilewidth), y + (i * data.tileheight), data.layers[t].opacity * a)
								else drawSpriteEx(tileset[k], n - data.tilesets[k].firstgid, x + (j * data.tilewidth), y + (i * data.tileheight), 0, 0, 1, 1, data.layers[t].opacity * a)
							}
							else drawSpriteEx(tileset[k], n - data.tilesets[k].firstgid, x + (j * data.tilewidth), y + (i * data.tileheight), 0, 0, 1, 1, data.layers[t].opacity * a)
							k = -1
							break
						}
					}
				}
			}
		}
	}

	function del() {
		for(local i = 0; i < tileset.len(); i++) {
			deleteSprite(tileset[i])
		}
	}
}

::mapNewSolid <- function(shape) {
	gvMap.geo.push(shape)
	return gvMap.geo.len() - 1
}

::mapDeleteSolid <- function(index) {
	if(index >= 0 && index < gvMap.geo.len() && gvMap.geo.len() > 0) gvMap.geo[index] = null
}

::tileSetSolid <- function(tx, ty, st) { //Tile X, tile Y, solid type
	if(st < 0) return
	local cx = floor(tx / 16)
	local cy = floor(ty / 16)
	local tile = cx + (cy * gvMap.solidLayer.width)

	if(st == 0) {
		if(tile >= 0 && tile < gvMap.solidLayer.data.len()) gvMap.solidLayer.data[tile] = 0
	}
	else if(tile >= 0 && tile < gvMap.solidLayer.data.len()) gvMap.solidLayer.data[tile] = gvMap.solidfid + (st - 1)
}

::tileGetSolid <- function(tx, ty) {
	local tile = floor(tx / 16) + (floor(ty / 16) * gvMap.solidLayer.width)

	if(tile >= 0 && tile < gvMap.solidLayer.data.len()) {
		if(gvMap.solidLayer.data[tile] == 0) return 0
		else return (gvMap.solidLayer.data[tile] - gvMap.solidfid + 1)
	}
}