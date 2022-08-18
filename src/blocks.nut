/*============*\
| BLOCK SOURCE |
\*============*/

::WoodBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	coins = 0
	v = 0.0
	vspeed = 0
	oldsolid = 0
	glimmerTimer = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y, 7, 9, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)

		if(_arr != null && _arr != "") coins = _arr.tointeger()
		game.maxCoins += coins
	}

	function run() {
		if(gvPlayer) {
			if(v == 0) {
				vspeed = 0
				if(coins <= 1) {
					if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y > y + 4) {
						gvPlayer.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						playSoundChannel(sndBump, 0, 2)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
					}

					if(gvPlayer.rawin("anSlide")) if(fabs(gvPlayer.hspeed) >= 4.5 && gvPlayer.anim == gvPlayer.anSlide) if(hitTest(slideshape, gvPlayer.shape)) {
						gvPlayer.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						playSoundChannel(sndBump, 0, 2)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
					}

					if(gvPlayer.rawin("anStomp")) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == gvPlayer.anStomp) {
						gvPlayer.vspeed = -2.0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						playSoundChannel(sndBump, 0, 2)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
					}
				}
				else {
					if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape)) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						playSoundChannel(sndBump, 0, 2)
					}

					if(gvPlayer.rawin("anSlide")) if((fabs(gvPlayer.hspeed) >= 4.5 || (game.weapon == 4 && gvPlayer.vspeed >= 2)) && gvPlayer.anim == gvPlayer.anSlide) if(hitTest(slideshape, gvPlayer.shape)) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						playSoundChannel(sndBump, 0, 2)
					}

					if(gvPlayer.rawin("anStomp")) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == gvPlayer.anStomp) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						playSoundChannel(sndBump, 0, 2)
					}
				}
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) {
			if(hitTest(shape, i.shape) && i.frame < 1 && vspeed == 0 && i.blast) {
				if(coins <= 1) {
					deleteActor(id)
					newActor(WoodChunks, x, y)
					stopSound(sndBump)
					playSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					if(coins > 0) newActor(CoinEffect, x, y - 16)
				}
				else {
					vspeed = -2
					coins--
					newActor(CoinEffect, x, y - 16)
					stopSound(sndBump)
					playSound(sndBump, 0)
				}
			}
		}

		if(v == -8) vspeed = 1
		v += vspeed

		drawSpriteZ(2, sprWoodBox, 0, x - 8 - camx, y - 8 - camy + v)
		if(coins > 0 && game.difficulty == 0) {
			if(glimmerTimer > 0) glimmerTimer--
			else {
				glimmerTimer = randInt(30)
				newActor(Glimmer, x - 8 + randInt(16), y  - 8 + randInt(16))
			}
		}
	}

	function _typeof() { return "WoodBlock" }
}

::IceBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	fireshape = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 7, 9, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)
		fireshape = Rec(x, y, 12, 12, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 40)
	}

	function run() {
		if(gvPlayer) {
			if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y > y + 4) {
				gvPlayer.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				playSound(sndBump, 0)
			}

			if((fabs(gvPlayer.hspeed) >= 3.5 || (game.weapon == 4 && gvPlayer.vspeed >= 2)) && gvPlayer.anim == gvPlayer.anSlide) if(hitTest(slideshape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				playSound(sndBump, 0)
			}

			if(gvPlayer.rawin("anStomp")) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == gvPlayer.anStomp) {
				gvPlayer.vspeed = -2.0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				playSound(sndBump, 0)
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"])  if(hitTest(fireshape, i.shape) && (i.element == "fire" || i.blast)) {
			tileSetSolid(x, y, oldsolid)
			deleteActor(id)
			deleteActor(i.id)

			if(i.element == "fire") {
				newActor(Poof, x, y)
				stopSound(sndFlame)
				playSound(sndFlame, 0)
			}

			if(i.blast) {
				newActor(IceChunks, x, y)
				stopSound(sndIceBreak)
				playSound(sndIceBreak, 0)
			}
		}
		drawSpriteZ(2, sprIceBlock, 0, x - 8 - camx, y - 8 - camy)
	}
}

::WoodChunks <- class extends Actor {
	h = 0.0
	v = 0.0
	vspeed = -3.0
	timer = 30
	a = 0

	function run() {
		vspeed += 0.2
		v += vspeed
		h += 1
		a += 4

		drawSpriteExZ(2, sprWoodChunks, 0, x - camx - h - 2, y - camy + v - 2, -a, 0, 1, 1, 1)
		drawSpriteExZ(2, sprWoodChunks, 1, x - camx + h + 2, y - camy + v - 2, a, 0, 1, 1, 1)
		drawSpriteExZ(2, sprWoodChunks, 2, x - camx - h - 2, y - camy + v + 2 + h, -a, 0, 1, 1, 1)
		drawSpriteExZ(2, sprWoodChunks, 3, x - camx + h + 2, y - camy + v + 2 + h, a, 0, 1, 1, 1)

		timer--
		if(timer == 0) deleteActor(id)
	}
}

::ItemBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		item = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}

		if(game.difficulty == 2 && (item == 1 || item == 2)) full = false

		if(v <= -8) {
			vspeed = 1
			switch(item){
				case 0:
					newActor(CoinEffect, x, y - 16)
					break

				case 1:
					if(game.difficulty == 3) {
						local c = actor[newActor(CannonBob, x, y - 4)]
						c.hspeed = ((gvPlayer.x - x) / 96)
					}
					else newActor(MuffinBlue, x, y - 16, true)
					break

				case 2:
					if(game.difficulty == 3) {
						local c = actor[newActor(CannonBob, x, y - 4)]
						c.hspeed = ((gvPlayer.x - x) / 96)
					}
					else newActor(MuffinRed, x, y - 16)
					break

				case 3:
					newActor(MuffinEvil, x, y - 16)
					break

				case 4:
					newActor(FlowerFire, x, y - 16)
					break

				case 5:
					if(game.difficulty >= 2) newActor(MuffinEvil, x, y - 16)
					else newActor(Starnyan, x, y - 16)
					break

				case 6:
					newActor(FlowerIce, x, y - 16)
					break

				case 7:
					newActor(AirFeather, x, y - 16)
					break

				case 8:
					//1up item
					newActor(OneUp, x, y - 16)
					break

				case 9:
					newActor(MuffinBomb, x, y - 16)
					break

				case 10:
					newActor(EarthShell, x, y - 16)
					break
			}
		}

		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
			gvPlayer.vspeed = 0
			full = false
			vspeed = -2
			playSound(sndBump, 0)
		}

		v += vspeed

		if(full || vspeed < 0) drawSpriteZ(2, sprBoxItem, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else drawSpriteZ(2, sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}
}

::TriggerBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	code = ""

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		code = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
			dostr(code)
		}

		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
			gvPlayer.vspeed = 0
			full = false
			vspeed = -1
			playSound(sndBump, 0)
		}

		v += vspeed

		if(full || vspeed < 0) drawSpriteZ(2, sprBoxRed, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else drawSpriteZ(2, sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}
}

::InfoBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	text = ""

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		text = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndBump, 0)
				gvInfoBox = text
			}

			if(gvInfoBox == text) if(!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)) gvInfoBox = ""
		}

		v += vspeed

		drawSpriteZ(2, sprBoxInfo, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
	}
}

::KelvinScarf <- class extends Actor {
	shape = 0
	text = ""

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		text = _arr

		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {

		if(gvPlayer) {
			if(devcom) if(hitTest(shape, gvPlayer.shape)){
				gvInfoBox = text
			}

			if(gvInfoBox == text) {
				if(!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)) gvInfoBox = ""
				else if(gvPlayer.invincible <= 1) gvPlayer.invincible = 10
			}
		}

		if(devcom) drawSpriteZ(2, sprKelvinScarf, getFrames() / 16, x - 8 - camx, y - 8 - camy)
	}
}

::BounceBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	text = ""

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 9, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v == 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}
		if(v >= 8) {
			vspeed = -0.5
		}

		if(gvPlayer) {
			shape.setPos(x, y + 2)
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
				gvPlayer.vspeed = 1
				vspeed = -1
				playSound(sndBump, 0)
			}

			shape.setPos(x, y - 1)
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed >= 0 && v == 0) if(full){
				gvPlayer.vspeed = -4
				if(getcon("jump", "hold")) gvPlayer.vspeed = -7.5
				vspeed = 1
				playSound(sndBump, 0)
			}

			if(gvInfoBox == text) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)) gvInfoBox = ""
		}

		v += vspeed

		drawSpriteZ(2, sprBoxBounce, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
	}
}

::Checkpoint <- class extends Actor {
	shape = null
	found = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 16, 10, 16, 0)
	}

	function run() {
		if(gvPlayer && found == false) if(hitTest(shape, gvPlayer.shape)) {
			foreach(i in actor["Checkpoint"]) {
				i.found = false
			}
			found = true
			game.check = true
			game.chx = x
			game.chy = y
			playSoundChannel(sndBell, 0, 4)
			if(game.difficulty < 3) {
				if(game.health < game.maxHealth) game.health += 4
				else if(game.subitem == 0) game.subitem = 5
			}
		}

		if(found) drawSprite(sprCheckBell, getFrames() / 8, x - camx, y - camy)
		else drawSprite(sprCheckBell, 0, x - camx, y - camy)
	}

	function _typeof() { return "Checkpoint" }
}

::TNT <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0
	fireshape = null
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		fireshape = Rec(x, y, 14, 12, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(gothit) {
			hittime += 2
			frame += 0.002 * hittime
			if(hittime >= 150) {
				tileSetSolid(x, y, 0)
				deleteActor(id)
				fireWeapon(ExplodeF, x, y, 0, id)
			}
		}
		else {
			//Hit by player
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) {
				gothit = true
				stopSound(sndFizz)
				playSound(sndFizz, 0)
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) if(hitTest(fireshape, i.shape) && (i.blast || i.element == "fire")) {
			if(i.rawin("frame") && i.blast) {
				if(i.frame >= 1) {
					tileSetSolid(x, y, oldsolid)
					deleteActor(id)
					fireWeapon(ExplodeF, x, y, 0, id)
					i.piercing--
				}
			}
			else {
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				fireWeapon(ExplodeF, x, y, 0, id)
				i.piercing--
			}
		}

		if(gothit) {
			if(hittime > 120) drawSpriteExZ(2, sprTNT, frame, x - 8 - camx + ((randInt(8) - 4) / 4) - ((2.0 / 150.0) * hittime), y - 8 - camy + ((randInt(8) - 4) / 4) - ((2.0 / 150.0) * hittime), 0, 0, 1.0 + ((0.25 / 150.0) * hittime), 1.0 + ((0.25 / 150.0) * hittime), 1)
			else drawSpriteZ(2, sprTNT, frame, x - 8 - camx + ((randInt(8) - 4) / 4), y - 8 - camy + ((randInt(8) - 4) / 4))
		}
		else drawSpriteZ(2, sprTNT, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNT" }
}

::C4 <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0
	fireshape = null
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
		fireshape = Rec(x, y, 16, 16, 0)
	}

	function run() {
		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) if(hitTest(fireshape, i.shape) && (i.blast && i.element == "fire")) {
			if(i.rawin("frame")) {
				if(i.frame >= 1) {
					tileSetSolid(x, y, oldsolid)
					deleteActor(id)
					newActor(ExplodeF, x, y)
					i.piercing--
				}
			}
			else {
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(ExplodeF, x, y)
				i.piercing--
			}
		}

		drawSpriteZ(2, sprC4, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNT" }
}

::ColorBlock <- class extends Actor {
	color = null
	filled = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr == null) color = 0
		else color = _arr

		if(color != null) if(game.colorswitch[color]) filltile()
	}

	function filltile() {
		//Get solid layer
		local wl = null //Working layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				wl = gvMap.data.layers[i]
				break
			}
		}

		//Find tile
		local cx = floor(x / 16)
		local cy = floor(y / 16)
		local tile = cx + (cy * wl.width)

		//Make tile solid
		if(tile >= 0 && tile < wl.data.len()) wl.data[tile] = gvMap.solidfid

		filled = 1
	}

	function run() {
		drawSpriteZ(2, sprColorBlock, (color * 2) + filled, x - camx, y - camy)
		if(color != null) if(game.colorswitch[color]) filltile()
	}

	function _typeof() { return "ColorBlock" }
}


::ColorSwitch <- class extends Actor {
	color = 0
	shape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr == null) color = 0
		else color = _arr.tointeger()

		shape = Rec(x, y, 16, 16, 0)
	}

	function run() {
		if(game.colorswitch[color]) drawSprite(sprColorSwitch, (color * 2) + 1, x - camx, y - camy)
		else {
			drawSprite(sprColorSwitch, color * 2, x - camx, y - camy)
			if(gvPlayer) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y < y - 16 && gvPlayer.vspeed > 0) {
				gvPlayer.vspeed = -1.5
				game.colorswitch[this.color] = true
				dostr("saveGame()")
				if(actor.rawin("ColorBlock")) foreach(i in actor["ColorBlock"]) {
					i.filltile()
				}
			}
		}
	}
}

::EvilBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
		slideshape = Rec(x, y - 1, 12, 8, 0)
	}

	function run() {
		if(gvPlayer) {
			if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(Poof, x, y)
				playSound(sndBump, 0)
				newActor(Darknyan, x, y - 16)
			}

		}

		drawSpriteZ(2, sprBoxItem, getFrames() / 16, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "EvilBlock" }
}

::EvilBlockB <- class extends Actor {
	shape = 0
	slideshape = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
		slideshape = Rec(x, y - 1, 12, 8, 0)
	}

	function run() {
		if(gvPlayer) {
			if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(Poof, x, y)
				playSound(sndBump, 0)
				newActor(MuffinBomb, x, y - 16)
			}

		}

		drawSpriteZ(2, sprBoxItem, getFrames() / 16, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "EvilBlockB" }
}

::BreakBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	tile = 0
	solidtile = 0
	layer = 0
	solidlayer = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
		slideshape = Rec(x, y - 1, 12, 8, 0)

		//Get graphic layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "fg") {
				layer = gvMap.data.layers[i]
				break
			}
		}

		//Find tile
		local cx = floor(x / 16)
		local cy = floor(y / 16)
		tile = cx + (cy * layer.width)

		//Get graphic layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				solidlayer = gvMap.data.layers[i]
				break
			}
		}
	}
}

::LockBlock <- class extends Actor {
	color = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(_arr == null) color = 0
		else color = _arr.tointeger()

		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
	}

	function run() {
		drawSpriteZ(2, sprLockBlock, color, x - camx, y - camy)

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 32)) {
			switch(color) {
				case 0:
					if(gvKeyCopper) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						playSound(sndBump, 0)
					}
					break
				case 1:
					if(gvKeySilver) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						playSound(sndBump, 0)
					}
					break
				case 2:
					if(gvKeyGold) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						playSound(sndBump, 0)
					}
					break
				case 3:
					if(gvKeyMythril) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						playSound(sndBump, 0)
					}
					break
			}
		}
	}
}

::BossDoor <- class extends Actor {
	dy = 0
	moving = false
	delay = 0
	opening = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(_arr != "") delay = _arr.tointeger()
	}

	function run() {
		if(gvWarning <= 10 && dy == 0) {
			moving = true
			tileSetSolid(x, y, 1)
			tileSetSolid(x, y - 16, 1)
			tileSetSolid(x, y - 32, 1)
			tileSetSolid(x, y - 48, 1)
		}
		if(moving && dy < 32 && !opening) {
			if(delay > 0) delay--
			else dy++
		}
		else if(opening && dy > 0) {
			dy--
			tileSetSolid(x, y, 0)
			tileSetSolid(x, y - 16, 0)
			tileSetSolid(x, y - 32, 0)
			tileSetSolid(x, y - 48, 0)
		}

		drawSpriteZ(4, sprBossDoor, 0, x - camx, y - camy - dy + 16)
		drawSpriteZ(4, sprBossDoor, 0, x - camx, y - camy - 80 + dy)
	}

	function _typeof() { return "BossDoor" }
}

::Fishy <- class extends Actor {
	shape = 0
	slideshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y + 2, 8, 8, 0)
		slideshape = Rec(x, y - 1, 12, 8, 0)
	}

	function run() {
		if(gvPlayer) {
			if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)) if(game.maxRedCoins == game.redCoins ){
				deleteActor(id)
				newActor(Poof, x, y)
				tileSetSolid(x, y, 0)
			}

		}

		drawSprite(sprFishBlock, 0, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "Fishy" }
}

::FireBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	fireshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		slideshape = Rec(x, y - 1, 12, 8, 0)
		fireshape = Rec(x, y, 16, 16, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"])  if(hitTest(fireshape, i.shape) && i.element == "fire") {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Flame, x, y)
			popSound(sndFlame, 0)
		}

		if(actor.rawin("Flame")) foreach(i in actor["Flame"]) if(inDistance2(x, y, i.x, i.y, 16) && i.frame >= 6) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			newActor(Flame, x, y)
			popSound(sndFlame, 0)
		}

		drawSprite(sprFireBlock, 0, x - 8 - camx, y - 8 - camy)
	}
}

::CharSwapper <- class extends Actor {
	shape = 0
	full = true
	character = "Tux"
	v = 0.0
	vspeed = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(_arr != null) character = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}

		if(gvPlayer && !hitTest(shape, gvPlayer.shape)) tileSetSolid(x, y, 1)

		if(v <= -8) {
			vspeed = 1

			local nx = gvPlayer.x
			local ny = gvPlayer.y
			local nf = gvPlayer.flip
			local nh = gvPlayer.hspeed
			local nv = gvPlayer.vspeed
			deleteActor(gvPlayer.id)
			gvPlayer = actor[newActor(getroottable()[character], nx, ny)]
			gvPlayer.tftime = 0
			gvPlayer.flip = nf
			gvPlayer.hspeed = nh
			gvPlayer.vspeed = nv
			tileSetSolid(x, y, 0)
			popSound(sndHeal, 0)
		}

		full = (game.characters.rawin(character) && gvPlayer && typeof gvPlayer != character)

		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
			gvPlayer.vspeed = 0
			vspeed = -2
			playSound(sndBump, 0)
		}

		v += vspeed

		if(full || vspeed < 0) {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, getroottable()[game.characters[character][1]], 0, x - camx, y - camy + v + 6)
		}
		else drawSpriteZ(2, sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}
}