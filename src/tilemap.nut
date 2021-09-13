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

	constructor(filename) {
		tileset = []
		tilef = []
		geo = []
		data = {}

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
						tileset.push(newSprite(filename, data.tilewidth, data.tileheight, data.tilesets[i].margin, data.tilesets[i].spacing, 0, 0))
						print("Added tileset " + shortname + ".")
					}
					else for(local j = 0; j < tileSearchDir.len(); j++) {
						if(fileExists(tileSearchDir[j] + "/" + shortname)) {
							print("Adding " + shortname + " from search path: " + tileSearchDir[j])
							tileset.push(newSprite(tileSearchDir[j] + "/" + shortname, data.tilewidth, data.tileheight, data.tilesets[i].margin, data.tilesets[i].spacing, 0, 0))
							break
						}
					}
				}

				tilef.push(data.tilesets[i].firstgid)
				if(data.tilesets[i].name == "solid") solidfid = data.tilesets[i].firstgid
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
							//print("Made trigger at (" + actor[c].x + ", " + actor[c].y + ") with code [" + actor[c].code + "]")
							//print(actor[c].shape)
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
						}
					}
				}
			}


			shape = (Rec(0, 0, 8, 8, 0))

			if(data.rawin("properties")) foreach(i in data.properties) {
				if(i.name == "code") dostr(i.value)
			}
		}
		else print("Map file " + filename + " does not exist!")
	}

	function drawTiles(x, y, mx, my, mw, mh, l) { //@mx through @mh are the rectangle of tiles that will be drawn
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
							drawSpriteEx(tileset[k], n - data.tilesets[k].firstgid, x + (j * data.tilewidth), y + (i * data.tileheight), 0, 0, 1, 1, data.layers[t].opacity)
							k = -1
							break
						}
					}
				}
			}
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