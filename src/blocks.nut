/*============*\
| BLOCK SOURCE |
\*============*/

::WoodBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	slideshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 2, 8, 6, 0))
		slideshape = Rec(x, y - 1, 12, 8, 0)
	}

	function run() {
		if(gvPlayer != 0) {
			if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				mapDeleteSolid(mapshape)
				deleteActor(id)
				newActor(WoodChunks, x, y)
				playSound(sndBump, 0)
			}

			if(abs(gvPlayer.hspeed) >= 3 && gvPlayer.anim == gvPlayer.anSlide) if(hitTest(slideshape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				mapDeleteSolid(mapshape)
				deleteActor(id)
				newActor(WoodChunks, x, y)
				playSound(sndBump, 0)
			}
		}

		drawSprite(sprWoodBox, 0, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "WoodBlock" }
}

::IceBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	slideshape = 0
	fireshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 2, 8, 6, 0))
		slideshape = Rec(x, y - 1, 12, 8, 0)
		fireshape = Rec(x, y, 12, 12, 0)
	}

	function run() {
		if(gvPlayer != 0) {
			if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				mapDeleteSolid(mapshape)
				deleteActor(id)
				newActor(IceChunks, x, y)
				playSound(sndBump, 0)
			}

			if(abs(gvPlayer.hspeed) >= 3 && gvPlayer.anim == gvPlayer.anSlide) if(hitTest(slideshape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				mapDeleteSolid(mapshape)
				deleteActor(id)
				newActor(IceChunks, x, y)
				playSound(sndBump, 0)
			}
		}

		if(actor.rawin("Fireball")) foreach(i in actor["Fireball"])  if(hitTest(fireshape, i.shape)) {
			mapDeleteSolid(mapshape)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Poof, x, y)
			playSound(sndFlame, 0)
		}

		drawSprite(sprIceBlock, 0, x - 8 - camx, y - 8 - camy)
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

		drawSpriteEx(sprWoodChunks, 0, x - camx - h - 2, y - camy + v - 2, -a, 0, 1, 1, 1)
		drawSpriteEx(sprWoodChunks, 1, x - camx + h + 2, y - camy + v - 2, a, 0, 1, 1, 1)
		drawSpriteEx(sprWoodChunks, 2, x - camx - h - 2, y - camy + v + 2 + h, -a, 0, 1, 1, 1)
		drawSpriteEx(sprWoodChunks, 3, x - camx + h + 2, y - camy + v + 2 + h, a, 0, 1, 1, 1)

		timer--
		if(timer == 0) deleteActor(id)
	}
}

::ItemBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		item = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 2, 8, 6, 0))
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}

		if(game.difficulty == 2 && (item == 1 || item == 2)) full = false

		if(v <= -8) {
			vspeed = 0.5
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
			}
		}

		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
			gvPlayer.vspeed = 0
			full = false
			vspeed = -1
			playSound(sndBump, 0)
		}

		v += vspeed

		if(full || vspeed < 0) drawSprite(sprBoxItem, getFrames() / 16, x - 8 - camx, y - 8 - camy + v)
		else drawSprite(sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}
}

::TriggerBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	code = ""

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		code = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 2, 8, 6, 0))
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

		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
			gvPlayer.vspeed = 0
			full = false
			vspeed = -1
			playSound(sndBump, 0)
		}

		v += vspeed

		if(full || vspeed < 0) drawSprite(sprBoxRed, getFrames() / 16, x - 8 - camx, y - 8 - camy + v)
		else drawSprite(sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}
}

::InfoBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	text = ""

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		text = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 2, 8, 6, 0))
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer != 0) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndBump, 0)
				gvInfoBox = text
			}

			if(gvInfoBox == text) if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 64) gvInfoBox = ""
		}

		v += vspeed

		if(full || vspeed < 0) drawSprite(sprBoxInfo, getFrames() / 16, x - 8 - camx, y - 8 - camy + v)
		else drawSprite(sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
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

		if(gvPlayer != 0) {
			if(devcom) if(hitTest(shape, gvPlayer.shape)){
				gvInfoBox = text
			}

			if(gvInfoBox == text) {
				if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 64) gvInfoBox = ""
				else if(gvPlayer.invincible <= 1) gvPlayer.invincible = 10
			}
		}

		if(devcom) drawSprite(sprKelvinScarf, getFrames() / 16, x - 8 - camx, y - 8 - camy)
	}
}

::BounceBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	text = ""

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 2, 8, 6, 0))
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

		if(gvPlayer != 0) {
			shape.setPos(x, y + 2)
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
				gvPlayer.vspeed = 1
				vspeed = -1
				playSound(sndBump, 0)
			}

			shape.setPos(x, y - 1)
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed >= 0 && v == 0) if(full){
				gvPlayer.vspeed = -2.5
				if(getcon("jump", "hold")) gvPlayer.vspeed = -5
				vspeed = 1
				playSound(sndBump, 0)
			}

			if(gvInfoBox == text) if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 64) gvInfoBox = ""
		}

		v += vspeed

		if(full || vspeed < 0) drawSprite(sprBoxBounce, getFrames() / 16, x - 8 - camx, y - 8 - camy + v)
		else drawSprite(sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}
}

::Checkpoint <- class extends Actor {
	shape = null
	found = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 8, 8, 8, 0)
	}

	function run() {
		if(gvPlayer != 0 && found == false) if(hitTest(shape, gvPlayer.shape)) {
			foreach(i in actor["Checkpoint"]) {
				i.found = false
			}
			found = true
			game.check = true
			game.chx = x
			game.chy = y
			playSound(sndBell, 0)
		}

		if(found) drawSprite(sprCheckBell, getFrames() / 16, x - camx, y - camy)
		else drawSprite(sprCheckBell, 0, x - camx, y - camy)
	}

	function _typeof() { return "Checkpoint" }
}

::TNT <- class extends Actor {
	shape = null
	mapshape = null
	gothit = false
	hittime = 0.0
	frame = 0.0
	fireshape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		mapshape = mapNewSolid(Rec(x, y, 8, 8, 0))
		fireshape = Rec(x, y, 12, 12, 0)
	}

	function run() {
		if(gothit) {
			hittime++
			frame += 0.002 * hittime
			if(hittime >= 150) {
				mapDeleteSolid(mapshape)
				deleteActor(id)
				newActor(BadExplode, x, y)
			}
		}
		else {
			//Hit by player
			if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) {
				gothit = true
				playSound(sndFizz, 0)
			}
		}

		if(actor.rawin("Fireball")) foreach(i in actor["Fireball"]) if(hitTest(fireshape, i.shape)) {
			mapDeleteSolid(mapshape)
			deleteActor(id)
			newActor(BadExplode, x, y)
			deleteActor(i.id)
		}

		drawSprite(sprTNT, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNT" }
}

::C4 <- class extends Actor {
	shape = null
	mapshape = null
	gothit = false
	hittime = 0.0
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		mapshape = mapNewSolid(Rec(x, y, 8, 8, 0))
	}

	function run() {
		drawSprite(sprC4, frame, x - 8 - camx, y - 8 - camy)
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

		if(color != null) if(game.colorswitch[color]) {
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
	}

	function run() {
		drawSprite(sprColorBlock, (color * 2) + filled, x - camx, y - camy)
	}
}


::ColorSwitch <- class extends Actor {
	color = 0
	shape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr == null) color = 0
		else color = _arr

		shape = Rec(x, y, 16, 16, 0)
	}

	function run() {
		if(game.colorswitch[color]) drawSprite(sprColorSwitch, (color * 2) + 1, x - camx, y - camy)
		else {
			drawSprite(sprColorSwitch, color * 2, x - camx, y - camy)
			if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y < y - 16 && gvPlayer.vspeed > 0) {
				gvPlayer.vspeed = -1.5
				game.colorswitch[this.color] = true
				dostr("saveGame()")
			}
		}
	}
}