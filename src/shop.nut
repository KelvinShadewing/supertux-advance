::ShopBlockHealth <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false
	price = 0

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.maxHealth >= 16 * 4) soldout = true
		price = (game.maxHealth + 1) * (50 * (game.difficulty + 1))

		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.maxHealth += 4
				game.coins -= price
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprHealth, getFrames() / 32, x - 8 - camx, y - 8 - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}

::ShopBlockFire <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false
	price = 0

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.fireBonus >= 16) soldout = true
		price = (game.fireBonus + 1) * (400 * ((game.difficulty.tofloat() / 2) + 1))

		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.fireBonus += 1
				game.coins -= price
				if(game.ps1.weapon == "fire") game.ps1.maxEnergy++
				if(game.ps2.weapon == "fire") game.ps2.maxEnergy++
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprFlowerFire, getFrames() / 32, x - camx, y - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}

::ShopBlockIce <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false
	price = 0

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.iceBonus >= 16) soldout = true
		price = (game.iceBonus + 1) * (400 * ((game.difficulty.tofloat() / 2) + 1))

		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.iceBonus += 1
				game.coins -= price
				if(game.ps1.weapon == "ice") game.ps1.maxEnergy++
				if(game.ps2.weapon == "ice") game.ps2.maxEnergy++
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprFlowerIce, getFrames() / 32, x - camx, y - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}

::ShopBlockAir <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false
	price = 0

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.airBonus >= 4) soldout = true
		price = (game.airBonus + 1) * (800 * ((game.difficulty.tofloat() / 2) + 1))

		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.airBonus += 1
				game.coins -= price
				if(game.ps1.weapon == "air") game.ps1.maxEnergy++
				if(game.ps2.weapon == "air") game.ps2.maxEnergy++
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprAirFeather, getFrames() / 32, x - camx, y - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}

::ShopBlockEarth <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false
	price = 0

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.earthBonus >= 4) soldout = true
		price = (game.earthBonus + 1) * (800 * ((game.difficulty.tofloat() / 2) + 1))

		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.earthBonus += 1
				game.coins -= price
				if(game.ps1.weapon == "earth") game.ps1.maxEnergy++
				if(game.ps2.weapon == "earth") game.ps2.maxEnergy++
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprEarthShell, getFrames() / 32, x - camx, y - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}

::ShopBlockWorld <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false
	price = 0
	basePrice = 0
	state = ""
	limit = 0
	name = ""

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
		state = _arr[0]
		basePrice = int(_arr[1])
		limit = int(_arr[2])
		name = _arr[3]
	}

	function run() {
		if(game.state[state] >= limit) soldout = true
		price = (game.state[state] + 1) * basePrice

		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.state[state]++
				game.coins -= price
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
			drawText(font, x - camx - (name.len() * 3), y - 24 - camy, name)
		}
	}
}