/*============*\
| ITEMS SOURCE |
\*============*/

::Coin <- class extends Actor{
	frame = 0.0

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
		frame = randFloat(4)
		game.maxCoins++
	}

	function run()
	{
		frame += 0.2
		drawSprite(sprCoin, frame, x - camx, y - camy)
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			newActor(CoinEffect, x, y)
		}
	}

	function _typeof() { return "Coin" }
}

::Coin5 <- class extends Actor{
	frame = 0.0

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
		frame = randFloat(4)
		game.maxCoins = game.maxCoins + 5
	}

	function run()
	{
		frame += 0.2
		drawSprite(sprCoin5, frame, x - camx, y - camy)
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			newActor(CoinEffect, x, y, 5)
		}
	}

	function _typeof() { return "Coin" }
}

::Coin10 <- class extends Actor{
	frame = 0.0

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
		frame = randFloat(4)
		game.maxCoins = game.maxCoins + 10
	}

	function run()
	{
		frame += 0.2
		drawSprite(sprCoin10, frame, x - camx, y - camy)
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			newActor(CoinEffect, x, y, 10)
		}
	}

	function _typeof() { return "Coin" }
}

::Berry <- class extends Actor{
	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		drawSprite(sprBerry, 0, x - camx, y - camy + ((getFrames() / 16) % 2 == 0).tointeger())
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			game.berries++
			stopSound(sndGulp)
			soundPlay(sndGulp, 0)
		}
	}

	function _typeof() { return "Coin" }
}

::RedCoin <- class extends Actor{
	frame = 0.0

	constructor(_x, _y, _arr = null)
	{
	base.constructor(_x, _y)
		frame = randFloat(4)
		game.maxredcoins++
	}

	function run()
	{
		frame += 0.1
		drawSprite(sprHerring, 0, x - camx, y - camy + ((getFrames() / 16) % 2 == 0).tointeger())
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			soundPlayChannel(sndFish, 0, 1)
			game.levelredcoins++
		}
	}

	function _typeof() { return "Coin" }
}

::FlowerFire <- class extends Actor{

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		drawSprite(sprFlowerFire, getFrames() / 16, x - camx, y - camy)
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 14)) {
			deleteActor(id)
			if(game.weapon == 0) {
				game.weapon = 1
				game.maxEnergy = 4 - game.difficulty + game.fireBonus
			}
			else {
				game.subitem = game.weapon
				game.maxEnergy = 4 - game.difficulty + game.fireBonus
				game.weapon = 1
			}
			soundPlayChannel(sndHeal, 0, 1)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
	}

	function _typeof() { return "FlowerFire" }
}

::FlowerIce <- class extends Actor{

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		drawSprite(sprFlowerIce, getFrames() / 16, x - camx, y - camy)
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 14)) {
			deleteActor(id)
			if(game.weapon == 0) {
				game.weapon = 2
				game.maxEnergy = 4 - game.difficulty + game.iceBonus
			}
			else {
				game.subitem = game.weapon
				game.maxEnergy = 4 - game.difficulty + game.iceBonus
				game.weapon = 2
			}
			soundPlayChannel(sndHeal, 0, 1)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
	}

	function _typeof() { return "FlowerIce" }
}

::MuffinBlue <- class extends PhysAct {
	flip = false
	willwrite = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 6, 7, 0)

		if(gvPlayer) {
			if(x < gvPlayer.x) flip = true
		}

		if(_arr != null) willwrite = _arr
	}

	function run() {
		if(placeFree(x, y + 1)) {
			if(inWater(x, y)) vspeed += 0.01
			else vspeed += 0.2
		}
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h + 8) deleteActor(id)

		if(flip) {
			if(placeFree(x - 1, y)) x -= 1.0
			else if(placeFree(x - 2, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else if(placeFree(x - 1, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else flip = false

			if(x <= 0) flip = false
		}
		else {
			if(placeFree(x + 1, y)) x += 1.0
			else if(placeFree(x + 1, y - 1)) {
				x += 1.0
				y -= 1.0
			} else if(placeFree(x + 2, y - 2)) {
				x += 1.0
				y -= 1.0
			} else flip = true

			if(x >= gvMap.w) flip = true
		}

		shape.setPos(x, y)

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 14)) {
			if(game.health < game.maxHealth) {
				game.health += 2
				for(local i = 0; i < 4; i++) {
					newActor(Heal, gvPlayer.x - 16 + randInt(32), gvPlayer.y - 16 + randInt(32))
				}
			}
			else if(game.subitem != 6 && (game.subitem == 0 || willwrite)) game.subitem = 5
			deleteActor(id)
			soundPlayChannel(sndHeal, 0, 1)
		}

		drawSprite(sprMuffin, 0, x - camx, y - camy)
	}
}

::MuffinRed <- class extends PhysAct {
	flip = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 7, 0)

		if(gvPlayer) {
			if(x < gvPlayer.x) flip = true
		}
	}

	function run() {
		if(placeFree(x, y + 1)) {
			if(inWater(x, y)) vspeed += 0.01
			else vspeed += 0.2
		}
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h + 8) deleteActor(id)

		if(flip) {
			if(placeFree(x - 1, y)) x -= 1.0
			else if(placeFree(x - 2, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else if(placeFree(x - 1, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else flip = false

			if(x <= 0) flip = false
		}
		else {
			if(placeFree(x + 1, y)) x += 1.0
			else if(placeFree(x + 1, y - 1)) {
				x += 1.0
				y -= 1.0
			} else if(placeFree(x + 2, y - 2)) {
				x += 1.0
				y -= 1.0
			} else flip = true

			if(x >= gvMap.w) flip = true
		}

		shape.setPos(x, y)

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 14)) {
			if(game.health < game.maxHealth - 3) {
				game.health += 8
				for(local i = 0; i < 4; i++) {
					newActor(Heal, gvPlayer.x - 16 + randInt(32), gvPlayer.y - 16 + randInt(32))
				}
			}
			else if(game.health < game.maxHealth) {
				game.health = game.maxHealth
				for(local i = 0; i < 4; i++) {
					newActor(Heal, gvPlayer.x - 16 + randInt(32), gvPlayer.y - 16 + randInt(32))
				}
			}
			else game.subitem = 6
			deleteActor(id)
			soundPlayChannel(sndHeal, 0, 1)
		}

		drawSprite(sprMuffin, 1, x - camx, y - camy)
	}
}

::MuffinEvil <- class extends PhysAct {
	flip = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 7, 0)

		if(gvPlayer) {
			if(x > gvPlayer.x) flip = true
		}
	}

	function run() {
		if(placeFree(x, y + 1)) vspeed += 0.2
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h + 8) deleteActor(id)

		if(flip) {
			if(placeFree(x - 1, y)) x -= 1.0
			else if(placeFree(x - 2, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else if(placeFree(x - 1, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else flip = false

			if(x <= 0) flip = false
		}
		else {
			if(placeFree(x + 1, y)) x += 1.0
			else if(placeFree(x + 1, y - 1)) {
				x += 1.0
				y -= 1.0
			} else if(placeFree(x + 2, y - 2)) {
				x += 1.0
				y -= 1.0
			} else flip = true

			if(x >= gvMap.w) flip = true
		}

		shape.setPos(x, y)

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 14)) {
			if(gvPlayer.blinking > 0) return
			if(gvPlayer.x < x) gvPlayer.hspeed = -1.0
			else gvPlayer.hspeed = 1.0
			gvPlayer.hurt = 1
			deleteActor(id)
		}

		drawSprite(sprMuffin, 2, x - camx, y - camy)
	}
}

::Onedown <- class extends Actor{
	frame = 0.0

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
		frame = randFloat(4)
	}

	function run()
	{
		if(getFrames() % 20 == 0){
		newActor(FlameTiny, x - 8 + randInt(16), y - 8 + randInt(16))
		}
		frame += 0.2
		drawSprite(spr1down, frame, x - camx, y - camy)
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			gvPlayer.hurt = 16
		}
	}

	function _typeof() { return "Coin" }
}

::Darknyan <- class extends PhysAct {
	hspeed = 0
	vspeed = -3

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(gvPlayer) if(gvPlayer.x > x) hspeed = -2
		else hspeed = 2

		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		if(!placeFree(x, y + 2)) vspeed = -5
		if(!placeFree(x + 2, y)) hspeed = -2
		if(!placeFree(x - 2, y)) hspeed = 2
		vspeed += 0.2

		if(placeFree(x + hspeed, y)) x += hspeed
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2
		shape.setPos(x, y)

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			gvPlayer.hurt = 6
		}

		drawSprite(sprDarkStar, getFrames() / 10, x - camx, y - camy)
	}
}

::Starnyan <- class extends PhysAct {
	hspeed = 0
	vspeed = -4

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(gvPlayer) if(gvPlayer.x > x) hspeed = -2
		else hspeed = 2

		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		if(!placeFree(x, y + 2)) vspeed = -5
		if(!placeFree(x + 2, y)) hspeed = -2
		if(!placeFree(x - 2, y)) hspeed = 2
		vspeed += 0.25

		if(placeFree(x + hspeed, y)) x += hspeed
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2
		shape.setPos(x, y)

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			gvPlayer.invincible = 645
			deleteActor(id)
			musicPlay(musInvincible, -1)
			gvLastSong = ""
		}

		drawSprite(sprStar, getFrames() / 10, x - camx, y - camy)
	}
}

::AirFeather <- class extends PhysAct {
	vspeed = -2.0
	hspeed = 0.0
	frame = 1.5

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(gvPlayer) if(x > gvPlayer.x) frame = 3.5
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

		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)){
			soundPlayChannel(sndHeal, 0, 1)
			if(game.weapon == 0) {
				game.weapon = 3
				game.maxEnergy = 4 - game.difficulty + game.airBonus
			}
			else {
				game.subitem = game.weapon
				game.maxEnergy = 4 - game.difficulty + game.airBonus
				game.weapon = 3
			}
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
			deleteActor(id)
		}
	}
}

::FlyRefresh <- class extends Actor{
	function run() {
		if(gvPlayer) if(inDistance2(gvPlayer.x, gvPlayer.y, x, y, 16)) if(gvPlayer.rawin("energy") && game.weapon == 3) gvPlayer.energy = 4

		drawSpriteEx(sprTinyWind, getFrames() / 8, x - camx, y - camy - 8, 0, 2, 1, 1, 0.25)
		drawSpriteEx(sprTinyWind, getFrames() / 8, x - camx, y - camy + 8, 0, 0, 1, 1, 0.25)
		drawSprite(sprFlyRefresh, getFrames() / 8, x - camx, y - camy)
	}
}

::OneUp <- class extends PhysAct {
	hspeed = 0
	vspeed = -2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(gvPlayer) if(gvPlayer.x > x) hspeed = -1
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

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			game.canres = true
			soundPlay(snd1up, 0)
			deleteActor(id)
		}

		drawSprite(getroottable()[game.characters[game.playerChar][1]], game.weapon, x - camx, y + 8 - camy)
	}
}

::MuffinBomb <- class extends PhysAct {
	flip = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 7, 0)

		if(gvPlayer) {
			if(x > gvPlayer.x) flip = true
		}
	}

	function run() {
		if(placeFree(x, y + 1)) {
			if(inWater(x, y)) vspeed += 0.01
			else vspeed += 0.2
		}
		if(placeFree(x, y + vspeed)) y += vspeed
		else vspeed /= 2

		if(y > gvMap.h + 8) deleteActor(id)

		if(flip) {
			if(placeFree(x - 1, y)) x -= 1.0
			else if(placeFree(x - 2, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else if(placeFree(x - 1, y - 2)) {
				x -= 1.0
				y -= 1.0
			} else flip = false

			if(x <= 0) flip = false
		}
		else {
			if(placeFree(x + 1, y)) x += 1.0
			else if(placeFree(x + 1, y - 1)) {
				x += 1.0
				y -= 1.0
			} else if(placeFree(x + 2, y - 2)) {
				x += 1.0
				y -= 1.0
			} else flip = true

			if(x >= gvMap.w) flip = true
		}

		shape.setPos(x, y)

		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 14)) {
			if(gvPlayer.blinking > 0) return
			if(gvPlayer.x < x) gvPlayer.hspeed = -1.0
			else gvPlayer.hspeed = 1.0
			newActor(BadExplode, x, y)
			deleteActor(id)
		}

		drawSprite(sprMuffin, 3, x - camx, y - camy)
	}
}

::EarthShell <- class extends Actor{

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		drawSprite(sprEarthShell, getFrames() / 16, x - camx, y - camy)
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 14)) {
			deleteActor(id)
			if(game.weapon == 0) {
				game.weapon = 4
				game.maxEnergy = 4 - game.difficulty + game.earthBonus
			}
			else {
				game.subitem = game.weapon
				game.maxEnergy = 4 - game.difficulty + game.earthBonus
				game.weapon = 4
			}
			soundPlayChannel(sndHeal, 0, 1)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
	}

	function _typeof() { return "EarthShell" }
}

::SpecialBall <- class extends Actor {
	num = 0
	shape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Cir(x, y, 8)
		num = _arr
		if(game.secretOrbs[num]) deleteActor(id)
	}

	function run() {
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			game.secretOrbs[num] = true
			deleteActor(id)
		}

		drawSprite(sprSpecialBall, getFrames() / 4, x - camx, y - camy)
	}
}

::CoinRing <- class extends Actor {
	r = 0.0 //Radius
	c = 0.0 //Count
	s = 0.0 //Speed
	a = 0.0 //Angle
	l = null //List

	constructor(_x, _y, _arr = null) {
		x = _x
		y = _y
		base.constructor(_x, _y)
		r = _arr[0].tofloat()
		c = _arr[1].tointeger()
		s = _arr[2].tofloat()
		l = []
		for(local i = 0; i < c; i++) {
			l.push(newActor(Coin, x, y))
		}
	}

	function run() {
		local cl = c //Coins left
		a += s / 60.0
		for(local i = 0; i < c; i++) {
			if(checkActor(l[i])) {
				actor[l[i]].x = x + r * cos((i * 2 * pi / c) + a)
				actor[l[i]].y = y + r * sin((i * 2 * pi / c) + a)
			}
			else cl--
		}
		if(cl == 0) deleteActor(id)
	}
}

::MagicKey <- class extends Actor {
	color = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr != null) color = _arr.tointeger()
	}

	function run() {
		//Pickup
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			deleteActor(id)
			switch(color) {
				case 0:
					gvKeyCopper = true
					break
				case 1:
					gvKeySilver = true
					break
				case 2:
					gvKeyGold = true
					break
				case 3:
					gvKeyMythril = true
					break
				default:
					gvKeyCopper = true
					break
			}
			soundPlay(snd1up, 0)
		}

		//Draw
		switch(color) {
			case 0:
				drawSprite(sprKeyCopper, getFrames() / 8, x - camx, y - camy)
				break
			case 1:
				drawSprite(sprKeySilver, getFrames() / 8, x - camx, y - camy)
				break
			case 2:
				drawSprite(sprKeyGold, getFrames() / 8, x - camx, y - camy)
				break
			case 3:
				drawSprite(sprKeyMythril, getFrames() / 8, x - camx, y - camy)
				break
			default:
				drawSprite(sprKeyCopper, getFrames() / 8, x - camx, y - camy)
				break
		}
	}
}

