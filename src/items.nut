/*============*\
| ITEMS SOURCE |
\*============*/

::Coin <- class extends Actor{
	frame = 0.0

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
		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y + 2) <= 14) {
			deleteActor(id)
			newActor(CoinEffect, x, y)
		}
	}

	function _typeof() { return "Coin" }
}

::FlowerFire <- class extends Actor{

	constructor(_x, _y)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		if(x > camx - 16 && x < camx + 320 && y > camy - 16 && y < camy + 180) drawSprite(sprFlowerFire, getFrames() / 16, x - camx, y - camy)
		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y + 2) <= 14) {
			deleteActor(id)
			game.weapon = 1
			playSound(sndHeal, 0)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
	}

	function _typeof() { return "FlowerFire" }
}

::FlowerIce <- class extends Actor{

	constructor(_x, _y)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		if(x > camx - 16 && x < camx + 320 && y > camy - 16 && y < camy + 180) drawSprite(sprFlowerIce, getFrames() / 16, x - camx, y - camy)
		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y + 2) <= 14) {
			deleteActor(id)
			game.weapon = 2
			playSound(sndHeal, 0)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
	}

	function _typeof() { return "FlowerIce" }
}

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

		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 14) {
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

		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 14) {
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

		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 14) {
			if(gvPlayer.blinking > 0) return
			if(gvPlayer.x < x) gvPlayer.hspeed = -1.0
			else gvPlayer.hspeed = 1.0
			gvPlayer.hurt = true
			deleteActor(id)
		}

		drawSprite(sprMuffin, 2, x - camx, y - camy)
	}
}

::Starnyan <- class extends PhysAct {
	hspeed = 0
	vspeed = -2

	constructor(_x, _y) {
		base.constructor(_x, _y)

		if(gvPlayer != 0) if(gvPlayer.x > x) hspeed = -1
		else hspeed = 1

		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		if(!placeFree(x, y + 1)) vspeed = -3
		if(!placeFree(x + 1, y)) hspeed = -1
		if(!placeFree(x - 1, y)) hspeed = 1
		vspeed += 0.1

		if(placeFree(x + hspeed, y)) x += hspeed
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2
		shape.setPos(x, y)

		if(gvPlayer != 0) if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 16) {
			gvPlayer.invincible = 60 * 25
			deleteActor(id)
			playMusic(musInvincible, -1)
		}

		drawSprite(sprStar, getFrames() / 10, x - camx, y - camy)
	}
}

::AirFeather <- class extends PhysAct {
	vspeed = -2.0
	hspeed = 0.0
	frame = 1.5

	constructor(_x, _y) {
		base.constructor(_x, _y)

		if(gvPlayer != 0) if(x > gvPlayer.x) frame = 3.5
		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		if(vspeed < 0.2) vspeed += 0.05

		if(floor(frame) == 0 || floor(frame) == 2) frame += 0.01
		else frame += 0.1

		if(frame >= 4.0) frame -= 4.0

		if(floor(frame) == 1) hspeed += 0.1
		if(floor(frame) == 3) hspeed -= 0.1

		x += hspeed
		y += vspeed
		shape.setPos(x, y)

		drawSprite(sprAirFeather, frame, x - camx, y - camy)

		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)){
			playSound(sndHeal, 0)
			game.weapon = 3
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
			deleteActor(id)
		}
	}
}