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

::ShopBlockEnergy <- class extends Actor {
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
		if(game.energyBonus >= 16) soldout = true
		price = (game.energyBonus + 1) * (640 * ((game.difficulty.tofloat() / 2) + 1))

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
				game.energyBonus += 1
				game.coins -= price
				game.ps.maxEnergy++
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprEnergy, getFrames() / 32, x - camx - 8, y - camy - 8 + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}

::ShopBlockStamina <- class extends Actor {
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
		if(game.staminaBonus >= 16) soldout = true
		price = (game.staminaBonus + 1) * (640 * ((game.difficulty.tofloat() / 2) + 1))

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
				game.staminaBonus += 1
				game.coins -= price
				game.ps.maxStamina++
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprStamina, getFrames() / 32, x - camx - 8, y - camy - 8 + v)
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

::ShopBlockSulphur <- class extends Actor {
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
		if(game.hasSulphur) soldout = true
		price = 100 + (100 * game.difficulty)

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
				game.coins -= price
				game.hasSulphur = 1
				local c = actor[newActor(SulphurNimbus, 0, y)]
				c.freed = 1
			}
		}

		if(gvPlayer2) {
			if(hitTest(shape, gvPlayer2.shape)) if(gvPlayer2.vspeed < 0 && v == 0) if(!soldout && game.coins >= price) {
				gvPlayer2.vspeed = 0
				vspeed = -1
				playSound(sndHeal, 0)
				game.coins -= price
				game.hasSulphur = 2
				local c = actor[newActor(SulphurNimbus, 0, y)]
				c.freed = 2
			}
		}

		v += vspeed
	}

	function draw() {
		local pricetag = chint(95).tostring() + price.tostring()
		if(soldout) drawSpriteZ(2, sprBoxEmpty, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			drawSpriteZ(2, sprActors, 108, x - camx, y - camy + v)
			drawText(font, x - camx - (pricetag.len() * 3), y - 16 - camy, pricetag)
		}
	}
}