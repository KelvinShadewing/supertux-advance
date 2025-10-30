/*===============================*\
|                                 |
|  BRUX JSON MAP LOADER           |
|                                 |
|  LICENSE: AGPL                  |
|  AUTHOR: Kelvin Shadewing       |
|  DESC: For use in Brux GDK      |
|    games to load JSON maps.     |
|                                 |
\*===============================*/

// TODO:
// Some SuperTux Advance-specific code exists and should be ported to a separate file

////////////////
// TILED MAPS //
////////////////

const tile_flip_h = 0x80000000;
const tile_flip_v = 0x40000000;
const tile_rot_cw = 0x20000000;
const tile_mask = 0x1fffffff;

tileSearchDir <- ["."];

findFileName <- function (path) {
	if (typeof path != "string") return "";
	if (path.len() == 0) return "";

	for (local i = path.len() - 1; i >= 0; i--) {
		if (chint(path[i]) == "/" || chint(path[i]) == "\\")
			return path.slice(i + 1);
	}

	return path;
};

///////////////////
// ANIMATED TILE //
///////////////////

AnimTile <- class {
	frameID = null;
	frameList = null;
	frameTime = null;
	sprite = null;
	randomized = false;
	wx = 0;
	wy = 0;

	constructor(animList, _sprite) {
		frameID = animList.id;
		frameList = [];
		frameTime = [];
		if ("animation" in animList) {
			for (local i = 0; i < animList.animation.len(); i++) {
				frameList.push(animList.animation[i].tileid);
				if (i == 0) frameTime.push(animList.animation[i].duration);
				else
					frameTime.push(
						animList.animation[i].duration + frameTime[i - 1]
					);
			}
			if ("properties" in animList) {
				foreach (i in animList.properties) {
					if (i.name == "random") {
						randomized = true;
					}
				}
			}
		}
		sprite = _sprite;
	}

	function draw(
		x,
		y,
		angle = 0,
		flip = 0,
		sx = 1.0,
		sy = 1.0,
		alpha = 1.0,
		color = 0xffffffff
	) {
		local currentTime = wrap(
			getTicks() + (randomized ? ((wx * wy + wx + wy) * 1337 + 1337) / 2.0 : 0),
			0,
			frameTime.top()
		);
		for (local i = 0; i < frameList.len(); i++) {
			if (currentTime >= frameTime[i]) {
				if (i < frameTime.len() - 1) {
					if (currentTime < frameTime[i + 1]) {
						drawSprite(
							sprite,
							frameList[(i + 1) % frameList.len()],
							x,
							y,
							angle,
							flip,
							sx,
							sy,
							alpha,
							color
						);
						return;
					}
				} else if (currentTime <= frameTime[i] && i == 0) {
					drawSprite(
						sprite,
						frameList[(i + 1) % frameList.len()],
						x,
						y,
						0,
						0,
						1,
						1,
						alpha,
						color
					);
					return;
				}
			}
		}

		drawSprite(sprite, frameList.top(), x, y, 0, 0, 1, 1, alpha, color);
	}
};

///////////////////
// TILEMAP CLASS //
///////////////////

Tilemap <- class {
	data = null;
	tileset = null;
	image = null;
	tilef = null;
	tilew = 0;
	tileh = 0;
	mapw = 0;
	maph = 0;
	geo = null; // List of solid shapes added after loading
	w = 0;
	h = 0;
	name = "";
	file = "";
	author = "";
	solidfid = 0; // First tile ID for the solid tileset
	shape = null; // Movable shape used for collision checking
	anim = null; // List of animated tiles
	solidLayer = null; // Tile layer used for collision checking
	plat = null; // List of platforms
	infinite = false;
	meta = null;

	constructor(filename) {
		tileset = [];
		image = {};
		tilef = [];
		geo = [];
		data = {};
		anim = {};
		meta = {};

		if (fileExists(filename)) {
			data = jsonRead(fileRead(filename));

			mapw = data.width;
			maph = data.height;
			tilew = data.tilewidth;
			tileh = data.tileheight;
			w = mapw * tilew;
			h = maph * tileh;

			file = filename;
			name = findFileName(filename);
			name = name.slice(0, -5);

			print("\nLoading map: " + name);

			for (local i = 0; i < data.tilesets.len(); i++) {
				// Check if tileset is not embedded
				if ("source" in data.tilesets[i])
					for (local j = 0; j < tileSearchDir.len(); j++) {
						local sourcefile = findFileName(
							data.tilesets[i].source
						);
						if (fileExists(tileSearchDir[j] + "/" + sourcefile)) {
							print("Found external tileset: " + sourcefile);
							local newgid = data.tilesets[i].firstgid;
							data.tilesets[i] = jsonRead(
								fileRead(tileSearchDir[j] + "/" + sourcefile)
							);
							data.tilesets[i].firstgid <- newgid;
							break;
						} else
							print(
								"Unable to find external tile: " +
									sourcefile +
									" in " +
									tileSearchDir[j]
							);
					}

				// Extract filename
				// print("Get filename")
				if (!("image" in data.tilesets[i]))
					print(jsonWrite(data.tilesets[i]));
				local filename = data.tilesets[i].image;
				local shortname = findFileName(filename);
				// print("Full map name: " + filename + ".")
				print("Searching for tileset: " + shortname);

				local tempspr = findSprite(shortname);
				// ("Temp sprite: " + shortname)

				local tsox = 0;
				local tsoy = 0;
				if ("tileoffset" in data.tilesets[i]) {
					if ("x" in data.tilesets[i].tileoffset)
						tsox = -data.tilesets[i].tileoffset.x;
					// Tiled uses a negative horizontal offset for some reason

					if ("y" in data.tilesets[i].tileoffset)
						tsoy = data.tilesets[i].tileoffset.y;
				}

				if (tempspr != 0) {
					tileset.push(tempspr);
					print("Found " + shortname);
				} else {
					// Search for file
					if (fileExists(filename)) {
						// print("Attempting to add full filename")
						tileset.push(
							newSprite(
								filename,
								data.tilesets[i].tilewidth,
								data.tilesets[i].tileheight,
								tsox,
								tsoy,
								data.tilesets[i].margin,
								data.tilesets[i].spacing
							)
						);
						print("Added tileset " + shortname + ".");
					} else
						for (local j = 0; j < tileSearchDir.len(); j++) {
							if (
								fileExists(tileSearchDir[j] + "/" + shortname)
							) {
								print(
									"Adding " +
										shortname +
										" from search path: " +
										tileSearchDir[j]
								);
								tileset.push(
									newSprite(
										tileSearchDir[j] + "/" + shortname,
										data.tilesets[i].tilewidth,
										data.tilesets[i].tileheight,
										tsox,
										tsoy,
										data.tilesets[i].margin,
										data.tilesets[i].spacing
									)
								);
								break;
							}
						}
				}

				tilef.push(data.tilesets[i].firstgid);
				if (data.tilesets[i].name == "solid")
					solidfid = data.tilesets[i].firstgid;

				// Add animations
				if (data.tilesets[i].rawin("tiles"))
					for (local j = 0; j < data.tilesets[i].tiles.len(); j++) {
						if ("animation" in data.tilesets[i].tiles[j])
							anim[
								data.tilesets[i].firstgid +
									data.tilesets[i].tiles[j].id
							] <- AnimTile(
								data.tilesets[i].tiles[j],
								tileset.top()
							);
					}
			}

			// print("Added " + spriteName(tileset[i]) + ".\n")

			shape = Rec(0, 0, 8, 8, 0);

			// Assign solid layer
			for (local i = 0; i < data.layers.len(); i++) {
				if (
					data.layers[i].type == "tilelayer" &&
					data.layers[i].name == "solid"
				) {
					solidLayer = data.layers[i];
					break;
				}
			}

			// Load image layers
			for (local i = 0; i < data.layers.len(); i++) {
				if (data.layers[i].type == "imagelayer") {
					local imageSource = findTexture(
						findFileName(data.layers[i].image)
					);
					if (imageSource <= 0) {
						for (local j = 0; j < tileSearchDir.len(); j++) {
							local sourcefile = findFileName(
								data.layers[i].image
							);
							if (
								fileExists(tileSearchDir[j] + "/" + sourcefile)
							) {
								print("Found external image: " + sourcefile);
								imageSource = loadImage(
									tileSearchDir[j] + "/" + sourcefile
								);
								break;
							} else
								print(
									"Unable to find external image: " +
										sourcefile +
										" in " +
										tileSearchDir[j]
								);
						}
					}
					image[data.layers[i].name] <- imageSource;
				}
			}
		} else print("Map file " + filename + " does not exist!");
	}

	function drawTiles(
		x,
		y,
		mx,
		my,
		mw,
		mh,
		l,
		a = -1,
		sx = 1,
		sy = 1,
		c = 0xffffffff,
		mask = null
	) {
		// @mx through @mh are the rectangle of tiles that will be drawn
		x = floor(x);
		y = floor(y);

		// Find layer
		local t = -1; // Target layer
		for (local i = 0; i < data.layers.len(); i++) {
			if (
				data.layers[i].type == "tilelayer" &&
				data.layers[i].name == l
			) {
				t = i;
				break;
			}
		}

		if (t == -1) {
			return; // Quit if no tile layer by that name was found
		}

		// Correct for layer offsets
		if ("offsetx" in data.layers[t]) {
			mx -= data.layers[t].offsetx;
			x += data.layers[t].offsetx;
		}
		mx = floor(mx / tilew);

		if ("offsety" in data.layers[t]) {
			my -= data.layers[t].offsety;
			y += data.layers[t].offsety;
		}
		my = floor(my / tilew);

		// Adjust for parallax
		if ("parallaxx" in data.layers[t] && data.layers[t].parallaxx != 0) {
			mx *= data.layers[t].parallaxx;
			mx = floor(mx);
			x *= data.layers[t].parallaxx;
		}
		if ("parallaxy" in data.layers[t] && data.layers[t].parallaxy != 0) {
			my *= data.layers[t].parallaxy;
			my = floor(my);
			y *= data.layers[t].parallaxy;
		}

		// Make sure values are in range
		if (data.layers[t].width < mx + mw) mw = data.layers[t].width - mx;
		if (data.layers[t].height < my + mh) mh = data.layers[t].height - my;
		if (mx < 0) mx = 0;
		if (my < 0) my = 0;
		if (mx > data.layers[t].width) mx = data.layers[t].width;
		if (my > data.layers[t].height) my = data.layers[t].height;

		for (local i = my; i < my + mh; i++) {
			for (local j = mx; j < mx + mw; j++) {
				if (
					typeof mask == "array" &&
					mask.len() >= data.layers[t].data.len() &&
					mask[i * data.layers[t].width + j] == 0
				)
					continue; // If the mask does not have the tile unlocked, skip it

				if (i * data.layers[t].width + j >= data.layers[t].data.len())
					return;
				local n = int(
					data.layers[t].data[i * data.layers[t].width + j]
				); // Number value of the tile
				if (n != 0) {
					local nm = n & tile_mask;
					local offx = 0;
					local offy = 0;
					local flip =
						(n & tile_flip_h ? 1 : 0) | (n & tile_flip_v ? 2 : 0);
					local offa = 0;

					switch (n & (tile_flip_h | tile_flip_v | tile_rot_cw)) {
						case tile_flip_h:
							offx = tilew * sx;
							break;
						case tile_flip_v:
							offy = tileh * sy;
							break;
						case tile_flip_h | tile_flip_v:
							offx = tilew * sx;
							offy = tileh * sy;
							break;
						case tile_rot_cw:
							offx = tilew * sx;
							offy = tileh * sy;
							offa = 90;
							break;
						case tile_rot_cw | tile_flip_h:
							offa = 90;
							flip = 2;
							break;
						case tile_rot_cw | tile_flip_v:
							offy = tileh * sy;
							offa = 270;
							flip = 0;
							break;
						case tile_rot_cw | tile_flip_h | tile_flip_v:
							offa = 270;
							flip = 2;
							offx = tilew * sx;
							offy = tileh * sy;
							break;
					}

					for (local k = data.tilesets.len() - 1; k >= 0; k--) {
						if (nm >= data.tilesets[k].firstgid) {
							if (anim.rawin(n) && tileset[k] == anim[n].sprite) {
								anim[n].wx = j;
								anim[n].wy = i;
								anim[n].draw(
									x + floor(j * data.tilewidth * sx) + offx,
									y + floor(i * data.tileheight * sy) + offy,
									offa,
									flip,
									sx,
									sy,
									a == -1 ? data.layers[t].opacity : a,
									c
								);
							} else {
								drawSprite(
									tileset[k],
									nm - data.tilesets[k].firstgid,
									x + floor(j * data.tilewidth * sx) + offx,
									y + floor(i * data.tileheight * sy) + offy,
									offa,
									flip,
									sx,
									sy,
									a == -1 ? data.layers[t].opacity : a,
									c
								);
							}
							k = -1;
							break;
						}
					}
				}
			}
		}
	}

	function drawImageLayer(l, x, y) {
		if (l in image) drawImage(image[l], x, y);
	}

	function del() {
		return; // Needs fix on Brux side

		for (local i = 0; i < tileset.len(); i++) {
			deleteSprite(tileset[i]);
		}
	}

	function setLayerProperty(l, p, v) {
		// Find layer
		local t = -1; // Target layer
		for (local i = 0; i < data.layers.len(); i++) {
			if (
				data.layers[i].type == "tilelayer" &&
				data.layers[i].name == l
			) {
				t = i;
				break;
			}
		}
		if (t == -1) {
			return; // Quit if no tile layer by that name was found
		}

		if (p in data.layers[t]) data.layers[t][p] = v;
	}

	function getLayerProperty(l, p) {
		// Find layer
		local t = -1; // Target layer
		for (local i = 0; i < data.layers.len(); i++) {
			if (
				data.layers[i].type == "tilelayer" &&
				data.layers[i].name == l
			) {
				t = i;
				break;
			}
		}
		if (t == -1) {
			return; // Quit if no tile layer by that name was found
		}

		if (p in data.layers[t]) return data.layers[t][p];
	}

	function _typeof() {
		return "Tilemap";
	}
};

///////////////
// FUNCTIONS //
///////////////

mapNewSolid <- function (shape) {
	gvMap.geo.push(shape);
	return gvMap.geo.len() - 1;
};

mapDeleteSolid <- function (index) {
	if (
		index in gvMap.geo &&
		index >= 0 &&
		index < gvMap.geo.len() &&
		gvMap.geo.len() > 0
	) {
		gvMap.geo[index] = null;
	}
};

tileSetSolid <- function (tx, ty, st) {
	// Tile X, tile Y, solid type
	if (st < 0) return;
	local cx = floor(tx / 16);
	local cy = floor(ty / 16);
	local tile = cx + cy * gvMap.solidLayer.width;

	if (st == 0) {
		if (tile >= 0 && tile < gvMap.solidLayer.data.len())
			gvMap.solidLayer.data[tile] = 0;
	} else if (tile >= 0 && tile < gvMap.solidLayer.data.len())
		gvMap.solidLayer.data[tile] = gvMap.solidfid + (st - 1);
};

tileGetSolid <- function (tx, ty) {
	local tile = floor(tx / 16) + floor(ty / 16) * gvMap.solidLayer.width;

	if (tile >= 0 && tile < gvMap.solidLayer.data.len()) {
		if (gvMap.solidLayer.data[tile] == 0) return 0;
		else return gvMap.solidLayer.data[tile] - gvMap.solidfid + 1;
	}
};

loadTileMapWorld <- function (filename) {
	if (!fileExists(filename)) return {};

	local file = jsonRead(fileRead(filename));
	local nw = {};

	if ((!"maps") in file) return {};
	for (local i = 0; i < file.maps.len(); i++) {
		local name = findFileName(file.maps[i]["fileName"]);
		nw[name] <- [file.maps[i]["x"], file.maps[i]["y"]];
	}
};
