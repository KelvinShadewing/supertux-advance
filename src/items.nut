/*============*\
| ITEMS SOURCE |
\*============*/

::Coin <- class extends Actor{
	frame = 0.0;

	constructor(_x, _y)
	{
		base.constructor(_x, _y)
		frame = randFloat(4)
		game.levelcoins++
	}

	function run()
	{
		frame += 0.1
		if(x > camx - 16 && x < camx + 320 && y > camy - 16 && y < camy + 180) drawSprite(sprCoin, frame, x - camx, y - camy)
		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y + 2) <= 16) {
			deleteActor(id)
			newActor(CoinEffect, x, y)
		}
	}

	function _typeof() { return "Coin" }
};

::MuffinBlue <- class extends PhysAct {
	flip = false

	constructor(_x, _y) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 7, 0)

		if(gvPlayer != 0) {
			if(x < gvPlayer.x) flip = true
		}
	}

	function run() {
		if(placeFree(x, y + 1)) vspeed += 0.1
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h + 8) deleteActor(id)

		if(flip) {
			if(placeFree(x - 0.5, y)) x -= 0.5
			else if(placeFree(x - 1.1, y - 0.5)) {
				x -= 0.5
				y -= 0.25
			} else if(placeFree(x - 1.1, y - 1.0)) {
				x -= 0.5
				y -= 0.5
			} else flip = false

			if(x <= 0) flip = false
		}
		else {
			if(placeFree(x + 1, y)) x += 0.5
			else if(placeFree(x + 1.1, y - 0.5)) {
				x += 0.5
				y -= 0.25
			} else if(placeFree(x + 1.1, y - 1.0)) {
				x += 0.5
				y -= 0.5
			} else flip = true

			if(x >= gvMap.w) flip = true
		}

		shape.setPos(x, y)

		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 16) {
			if(game.health < game.maxHealth) game.health++
			deleteActor(id)
			playSound(sndHeal, 0)
		}

		drawSprite(sprMuffin, 0, x - camx, y - camy)
	}
}

::MuffinRed <- class extends PhysAct {
	flip = false

	constructor(_x, _y) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 7, 0)

		if(gvPlayer != 0) {
			if(x < gvPlayer.x) flip = true
		}
	}

	function run() {
		if(placeFree(x, y + 1)) vspeed += 0.1
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h + 8) deleteActor(id)

		if(flip) {
			if(placeFree(x - 0.5, y)) x -= 0.5
			else if(placeFree(x - 1.1, y - 0.5)) {
				x -= 0.5
				y -= 0.25
			} else if(placeFree(x - 1.1, y - 1.0)) {
				x -= 0.5
				y -= 0.5
			} else flip = false

			if(x <= 0) flip = false
		}
		else {
			if(placeFree(x + 1, y)) x += 0.5
			else if(placeFree(x + 1.1, y - 0.5)) {
				x += 0.5
				y -= 0.25
			} else if(placeFree(x + 1.1, y - 1.0)) {
				x += 0.5
				y -= 0.5
			} else flip = true

			if(x >= gvMap.w) flip = true
		}

		shape.setPos(x, y)

		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 16) {
			if(game.health < game.maxHealth - 3) game.health += 4
			else game.health = game.maxHealth
			deleteActor(id)
			playSound(sndHeal, 0)
		}

		drawSprite(sprMuffin, 1, x - camx, y - camy)
	}
}

::MuffinEvil <- class extends PhysAct {
	flip = false

	constructor(_x, _y) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 7, 0)

		if(gvPlayer != 0) {
			if(x > gvPlayer.x) flip = true
		}
	}

	function run() {
		if(placeFree(x, y + 1)) vspeed += 0.1
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h + 8) deleteActor(id)

		if(flip) {
			if(placeFree(x - 0.5, y)) x -= 0.5
			else if(placeFree(x - 1.1, y - 0.5)) {
				x -= 0.5
				y -= 0.25
			} else if(placeFree(x - 1.1, y - 1.0)) {
				x -= 0.5
				y -= 0.5
			} else flip = false

			if(x <= 0) flip = false
		}
		else {
			if(placeFree(x + 1, y)) x += 0.5
			else if(placeFree(x + 1.1, y - 0.5)) {
				x += 0.5
				y -= 0.25
			} else if(placeFree(x + 1.1, y - 1.0)) {
				x += 0.5
				y -= 0.5
			} else flip = true

			if(x >= gvMap.w) flip = true
		}

		shape.setPos(x, y)

		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 16) {
			if(gvPlayer.blinking > 0) return
			if(gvPlayer.x < x) gvPlayer.hspeed = -1.0
			else gvPlayer.hspeed = 1.0
			gvPlayer.hurt = true
			deleteActor(id)
		}

		drawSprite(sprMuffin, 2, x - camx, y - camy)
	}
}