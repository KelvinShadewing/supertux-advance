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
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)
		|| gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			newActor(CoinEffect, x, y)
		}
		else if("WeaponEffect" in actor) foreach(i in actor["WeaponEffect"]) if(inDistance2(x, y, i.x, i.y, 8) && i.box) {
			deleteActor(id)
			newActor(CoinEffect, x, y)
		}
		frame += 0.2
	}

	function draw() { drawSprite(sprCoin, frame, x - camx, y - camy) }

	function _typeof() { return "Item" }
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
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)
		|| gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			newActor(CoinEffect, x, y, 5)
		}
		else if("WeaponEffect" in actor) foreach(i in actor["WeaponEffect"]) if(inDistance2(x, y, i.x, i.y, 8) && i.box) {
			deleteActor(id)
			newActor(CoinEffect, x, y, 5)
		}
		frame += 0.2
	}

	function draw() { drawSprite(sprCoin5, frame, x - camx, y - camy) }

	function _typeof() { return "Item" }
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
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)
		|| gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			newActor(CoinEffect, x, y, 10)
		}
		else if("WeaponEffect" in actor) foreach(i in actor["WeaponEffect"]) if(inDistance2(x, y, i.x, i.y, 8) && i.box) {
			deleteActor(id)
			newActor(CoinEffect, x, y, 10)
		}
		frame += 0.2
	}

	function draw() { drawSprite(sprCoin10, frame, x - camx, y - camy) }

	function _typeof() { return "Item" }
}

::Berry <- class extends Actor{
	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			game.ps.berries++
			stopSound(sndGulp)
			playSound(sndGulp, 0)
		}
		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			game.ps2.berries++
			stopSound(sndGulp)
			playSound(sndGulp, 0)
		}
	}

	function draw() { drawSprite(sprBerry, 0, x - camx, y - camy + ((getFrames() / 16) % 2 == 0).tointeger()) }

	function _typeof() { return "Item" }
}

::Herring <- class extends Actor{
	frame = 0.0

	constructor(_x, _y, _arr = null)
	{
	base.constructor(_x, _y)
		frame = randFloat(4)
		game.maxRedCoins++
	}

	function run()
	{
		frame += 0.1
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)
		|| gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			playSoundChannel(sndFish, 0, 1)
			game.redCoins++
		}
	}

	function draw() { drawSprite(sprHerring, 0, x - camx, y - camy + ((getFrames() / 16) % 2 == 0).tointeger()) }

	function _typeof() { return "Item" }
}

::RedHerring <- class extends Actor{
	frame = 0.0

	constructor(_x, _y, _arr = null)
	{
	base.constructor(_x, _y)
		frame = randFloat(4)
		game.maxRedCoins++
	}

	function run()
	{
		frame += 0.1
		drawSprite(sprRedHerring, 0, x - camx, y - camy + ((getFrames() / 16) % 2 == 0).tointeger())
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)
		|| gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			playSoundChannel(sndFish, 0, 1)
			game.redCoins++
		}
	}

	function _typeof() { return "Item" }
}

::FlowerFire <- class extends Actor{

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 14)) {
			deleteActor(id)
			if(game.ps.weapon == "normal") {
				game.ps.weapon = "fire"
				game.ps.maxEnergy = 4 - game.difficulty + game.fireBonus
			}
			else {
				game.ps.subitem = game.ps.weapon
				game.ps.maxEnergy = 4 - game.difficulty + game.fireBonus
				game.ps.weapon = "fire"
			}
			popSound(sndHeal, 0)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 14)) {
			deleteActor(id)
			if(game.ps2.weapon == "normal") {
				game.ps2.weapon = "fire"
				game.ps2.maxEnergy = 4 - game.difficulty + game.fireBonus
			}
			else {
				game.ps2.subitem = game.ps2.weapon
				game.ps2.maxEnergy = 4 - game.difficulty + game.fireBonus
				game.ps2.weapon = "fire"
			}
			popSound(sndHeal, 0)
			if(gvPlayer2.rawin("tftime")) gvPlayer2.tftime = 0
		}
	}

	function draw() { drawSprite(sprFlowerFire, getFrames() / 16, x - camx, y - camy) }

	function _typeof() { return "Item" }
}

::FlowerIce <- class extends Actor{

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 14)) {
			deleteActor(id)
			if(game.ps.weapon == "normal") {
				game.ps.weapon = "ice"
				game.ps.maxEnergy = 4 - game.difficulty + game.iceBonus
			}
			else {
				game.ps.subitem = game.ps.weapon
				game.ps.maxEnergy = 4 - game.difficulty + game.iceBonus
				game.ps.weapon = "ice"
			}
			popSound(sndHeal, 0)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 14)) {
			deleteActor(id)
			if(game.ps2.weapon == "normal") {
				game.ps2.weapon = "ice"
				game.ps2.maxEnergy = 4 - game.difficulty + game.iceBonus
			}
			else {
				game.ps2.subitem = game.ps2.weapon
				game.ps2.maxEnergy = 4 - game.difficulty + game.iceBonus
				game.ps2.weapon = "ice"
			}
			popSound(sndHeal, 0)
			if(gvPlayer2.rawin("tftime")) gvPlayer2.tftime = 0
		}
	}

	function draw() { drawSprite(sprFlowerIce, getFrames() / 16, x - camx, y - camy) }

	function _typeof() { return "Item" }
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

		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			if(game.ps.health < game.maxHealth) {
				game.ps.health += 4
				for(local i = 0; i < 4; i++) {
					newActor(Heal, gvPlayer.x - 16 + randInt(32), gvPlayer.y - 16 + randInt(32))
				}
			}
			else if(game.ps.subitem != "muffinRed" && (game.ps.subitem == 0 || willwrite)) game.ps.subitem = "muffinBlue"
			deleteActor(id)
			popSound(sndHeal, 0)
		}

		if(gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 16)) {
			if(game.ps2.health < game.maxHealth) {
				game.ps2.health += 4
				for(local i = 0; i < 4; i++) {
					newActor(Heal, gvPlayer2.x - 16 + randInt(32), gvPlayer2.y - 16 + randInt(32))
				}
			}
			else if(game.ps2.subitem != "muffinRed" && (game.ps2.subitem == 0 || willwrite)) game.ps2.subitem = "muffinBlue"
			deleteActor(id)
			popSound(sndHeal, 0)
		}
	}

	function draw() { drawSprite(sprMuffin, 0, x - camx, y - camy) }

	function _typeof() { return "Item" }
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

		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			if(game.ps.health < game.maxHealth) {
				game.ps.health += 16
				for(local i = 0; i < 4; i++) {
					newActor(Heal, gvPlayer.x - 16 + randInt(32), gvPlayer.y - 16 + randInt(32))
				}
			}
			else game.ps.subitem = "muffinRed"
			deleteActor(id)
			popSound(sndHeal, 0)
		}

		if(gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 16)) {
			if(game.ps2.health < game.maxHealth) {
				game.ps2.health += 16
				for(local i = 0; i < 4; i++) {
					newActor(Heal, gvPlayer2.x - 16 + randInt(32), gvPlayer2.y - 16 + randInt(32))
				}
			}
			else game.ps2.subitem = "muffinRed"
			deleteActor(id)
			popSound(sndHeal, 0)
		}
	}

	function draw() { drawSprite(sprMuffin, 1, x - camx, y - camy) }

	function _typeof() { return "Item" }
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
	}

	function draw() {drawSprite(sprMuffin, 2, x - camx, y - camy) }

	function _typeof() { return "Item" }
}

::OneDown <- class extends Actor{
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

		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			gvPlayer2.hurt = 16
		}
	}

	function _typeof() { return "Item" }
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

		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 16)) {
			gvPlayer2.hurt = 6
		}
	}

	function draw() { drawSprite(sprDarkStar, getFrames() / 10, x - camx, y - camy) }

	function _typeof() { return "Item" }
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
			playMusic(musInvincible, -1)
			gvLastSong = ""
		}

		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 16)) {
			gvPlayer2.invincible = 645
			deleteActor(id)
			playMusic(musInvincible, -1)
			gvLastSong = ""
		}
	}

	function draw() {
		drawSprite(sprStar, getFrames() / 10, x - camx, y - camy)
		drawLight(sprLightBasic, 0, x - camx, y - camy)
	}

	function _typeof() { return "Item" }
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

		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)){
			popSound(sndHeal, 0)
			if(game.ps.weapon == "normal") {
				game.ps.weapon = "air"
				game.ps.maxEnergy = 4 - game.difficulty + game.airBonus
			}
			else {
				game.ps.subitem = game.ps.weapon
				game.ps.maxEnergy = 4 - game.difficulty + game.airBonus
				game.ps.weapon = "air"
			}
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
			deleteActor(id)
		}
		if(gvPlayer2) if(hitTest(shape, gvPlayer2.shape)){
			popSound(sndHeal, 0)
			if(game.ps2.weapon == "normal") {
				game.ps2.weapon = "air"
				game.ps2.maxEnergy = 4 - game.difficulty + game.airBonus
			}
			else {
				game.ps2.subitem = game.ps2.weapon
				game.ps2.maxEnergy = 4 - game.difficulty + game.airBonus
				game.ps2.weapon = "air"
			}
			if(gvPlayer2.rawin("tftime")) gvPlayer2.tftime = 0
			deleteActor(id)
		}
	}

	function draw() { drawSprite(sprAirFeather, frame, x - camx, y - camy) }

	function _typeof() { return "Item" }
}

::FlyRefresh <- class extends Actor{
	function run() {
		if(gvPlayer && inDistance2(gvPlayer.x, gvPlayer.y, x, y, 16) && gvPlayer.rawin("energy") && game.ps.weapon == "air") gvPlayer.energy++
		if(gvPlayer2 && inDistance2(gvPlayer2.x, gvPlayer2.y, x, y, 16) && gvPlayer2.rawin("energy") && game.ps2.weapon == "air") gvPlayer2.energy++
	}

	function draw() {
		drawSpriteEx(sprTinyWind, getFrames() / 8, x - camx, y - camy - 8, 0, 2, 1, 1, 0.25)
		drawSpriteEx(sprTinyWind, getFrames() / 8, x - camx, y - camy + 8, 0, 0, 1, 1, 0.25)
		drawSprite(sprFlyRefresh, getFrames() / 8, x - camx, y - camy)
	}

	function _typeof() { return "FlyRefresh" }
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

		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16) && !game.ps.canres) {
			game.ps.canres = true
			playSound(snd1up, 0)
			deleteActor(id)
		}

		if(gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 16) && !game.ps2.canres) {
			game.ps2.canres = true
			playSound(snd1up, 0)
			deleteActor(id)
		}
	}

	function draw() {
		if(gvNumPlayers == 1 && gvPlayer) drawSprite(getroottable()[gvCharacters[typeof gvPlayer]["doll"]], enWeapons[game.ps.weapon], x - camx, y - camy)
		else drawSprite(sprMysticDoll, 0, x - camx, y - camy)
	}

	function _typeof() { return "Item" }
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
			fireWeapon(ExplodeF, x, y, 0, id)
			deleteActor(id)
		}

		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 14)) {
			if(gvPlayer2.blinking > 0) return
			fireWeapon(ExplodeF, x, y, 0, id)
			deleteActor(id)
		}
	}

	function draw() { drawSprite(sprMuffin, 3, x - camx, y - camy) }

	function _typeof() { return "Item" }
}

::EarthShell <- class extends Actor{

	constructor(_x, _y, _arr = null)
	{
		base.constructor(_x, _y)
	}

	function run()
	{
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 14)) {
			deleteActor(id)
			if(game.ps.weapon == "normal") {
				game.ps.weapon = "earth"
				game.ps.maxEnergy = 4 - game.difficulty + game.earthBonus
			}
			else {
				game.ps.subitem = game.ps.weapon
				game.ps.maxEnergy = 4 - game.difficulty + game.earthBonus
				game.ps.weapon = "earth"
			}
			popSound(sndHeal, 0)
			if(gvPlayer.rawin("tftime")) gvPlayer.tftime = 0
		}
		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 14)) {
			deleteActor(id)
			if(game.ps2.weapon == "normal") {
				game.ps2.weapon = "earth"
				game.ps2.maxEnergy = 4 - game.difficulty + game.earthBonus
			}
			else {
				game.ps2.subitem = game.ps2.weapon
				game.ps2.maxEnergy = 4 - game.difficulty + game.earthBonus
				game.ps2.weapon = "earth"
			}
			popSound(sndHeal, 0)
			if(gvPlayer2.rawin("tftime")) gvPlayer2.tftime = 0
		}
	}

	function draw() { drawSprite(sprEarthShell, getFrames() / 16, x - camx, y - camy) }

	function _typeof() { return "Item" }
}

::SpecialBall <- class extends Actor {
	num = 0
	shape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Cir(x, y, 8)
		num = _arr
	}

	function run() {
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
			game.secretOrbs[num] = true
			deleteActor(id)
			endGoal()
		}
	}

	function draw() { drawSprite(sprSpecialBall, getFrames() / 4, x - camx, y - camy, 0, 0, 1, 1, (game.secretOrbs[num] ? 0.5 : 1)) }

	function _typeof() { return "Item" }
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
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y, 16)) {
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
			playSound(snd1up, 0)
		}

		else if(gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 16)) {
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
			playSound(snd1up, 0)
		}
	}

	function draw() {
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

	function _typeof() { return "Item" }
}

::CoffeeCup <- class extends Actor{
	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y + 2, 16)) {
			deleteActor(id)
			if(game.ps.subitem != "coffee") game.ps.subitem = "coffee"
			else gvPlayer.zoomies += 60 * 16
			popSound(sndGulp, 0)
		}
		if(gvPlayer2) if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y + 2, 16)) {
			deleteActor(id)
			if(game.ps2.subitem != "coffee") game.ps2.subitem = "coffee"
			else gvPlayer2.zoomies += 60 * 16
			popSound(sndGulp, 0)
		}
	}

	function draw() { drawSprite(sprCoffee, getFrames() / 8, x - camx, y - camy + ((getFrames() / 16) % 2 == 0).tointeger()) }

	function _typeof() { return "Item" }
}
