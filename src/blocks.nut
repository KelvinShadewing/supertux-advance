::WoodBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	slideshape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 1, 8, 6, 0))
		slideshape = Rec(x, y, 12, 8, 0)
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

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 1, 8, 6, 0))
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
			switch(item){
				case 0:
					newActor(CoinEffect, x, y - 16)
					break

				case 1:
					newActor(MuffinBlue, x, y - 16)
					break

				case 2:
					newActor(MuffinRed, x, y - 16)
					break

				case 3:
					newActor(MuffinEvil, x, y - 16)
					break

				case 4:
					newActor(FlowerFire, x, y - 16)
					break

				case 5:
					newActor(Starnyan, x, y - 16)
					break

				case 6:
					newActor(FlowerIce, x, y - 16)
					break

				case 7:
					newActor(AirFeather, x, y - 16)
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

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 1, 8, 6, 0))
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

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y - 1, 8, 6, 0))
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
	mapshape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	text = ""

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {

		if(gvPlayer != 0) {
			if(devcom) if(hitTest(shape, gvPlayer.shape)){
				gvInfoBox = text
			}

			if(gvInfoBox == text) if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 64) gvInfoBox = ""
		}

		if(devcom) drawSprite(sprKelvinScarf, getFrames() / 16, x - 8 - camx, y - 8 - camy + v)
	}
}