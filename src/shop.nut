::ShopBlockHealth <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	soldout = false

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.maxHealth >= 16 * 4) soldout = true
		local price = (game.maxHealth + 1) * (50 * (game.difficulty + 1))

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
				game.health += 4
				game.maxHealth += 4
				game.coins -= price
			}
		}

		v += vspeed

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

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.fireBonus >= 16) soldout = true
		local price = (game.fireBonus + 1) * (400 * ((game.difficulty.tofloat() / 2) + 1))

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
				if(game.weapon == 1) game.maxEnergy++
			}
		}

		v += vspeed

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

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.iceBonus >= 16) soldout = true
		local price = (game.iceBonus + 1) * (400 * ((game.difficulty.tofloat() / 2) + 1))

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
				if(game.weapon == 2) game.maxEnergy++
			}
		}

		v += vspeed

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

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.airBonus >= 4) soldout = true
		local price = (game.airBonus + 1) * (800 * ((game.difficulty.tofloat() / 2) + 1))

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
				if(game.weapon == 3) game.maxEnergy++
			}
		}

		v += vspeed

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

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(game.earthBonus >= 4) soldout = true
		local price = (game.earthBonus + 1) * (800 * ((game.difficulty.tofloat() / 2) + 1))

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
				if(game.weapon == 4) game.maxEnergy++
			}
		}

		v += vspeed

		local pricetag = chint(95).tostring() + price.tostring()

		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprEarthShell, getFrames() / 32, x - camx, y - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}