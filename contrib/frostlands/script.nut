//asset stuffs
print("Loading Frostlands")

::bgAuroraALT <- newSprite("contrib/frostlands/gfx/aurora-alt.png", 720, 240, 0, 0, 0, 0)
::bgSnowPlainALT <- newSprite("contrib/frostlands/gfx/bgSnowPlain-alt.png", 720, 240, 0, 0, 0, 0)

//background shiz

::dbgAuroraF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraALT, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgSnowPlainF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowPlainALT, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

/*
::EvilBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	coins = 0
	v = 0.0
	vspeed = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y, 7, 9, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)

		if(_arr != null && _arr != "") coins = _arr.tointeger()
		game.maxcoins += coins
	}

	function run() {
		if(gvPlayer) {
			if(v == 0) {
				vspeed = 0
				if(coins <= 1) {
					if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y > y + 4) {
						gvPlayer.vspeed = 0
						deleteActor(id)
						newActor(Darknyan, x, y - 16)
						newActor(Poof, x, y)
						playSoundChannel(sndBump, 0, 2)
						tileSetSolid(x, y, 0)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
					}
					if(gvPlayer.rawin("anStomp")) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == gvPlayer.anStomp) {
						gvPlayer.vspeed = -2.0
						deleteActor(id)
						newActor(Darknyan, x, y - 16)
						newActor(Poof, x, y)
						playSoundChannel(sndBump, 0, 2)
						tileSetSolid(x, y, 0)
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
					if(gvPlayer.rawin("anStomp")) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == gvPlayer.anStomp) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						playSoundChannel(sndBump, 0, 2)
					}
				}
			}
		}
		if(v == -8) vspeed = 1
		v += vspeed

		drawSprite(sprBoxItem, getFrames() / 9, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "WoodBlock" }
}

::EvilBlockB <- class extends Actor {
	shape = 0
	slideshape = 0
	coins = 0
	v = 0.0
	vspeed = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y, 7, 9, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)

		if(_arr != null && _arr != "") coins = _arr.tointeger()
		game.maxcoins += coins
	}

	function run() {
		if(gvPlayer) {
			if(v == 0) {
				vspeed = 0
				if(coins <= 1) {
					if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y > y + 4) {
						gvPlayer.vspeed = 0
						deleteActor(id)
						newActor(MuffinBomb, x, y - 8)
						newActor(Poof, x, y)
						playSoundChannel(sndBump, 0, 2)
						tileSetSolid(x, y, 0)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
					}
					if(gvPlayer.rawin("anStomp")) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == gvPlayer.anStomp) {
						gvPlayer.vspeed = -2.0
						deleteActor(id)
						newActor(MuffinBomb, x, y - 8)
						newActor(Poof, x, y)
						playSoundChannel(sndBump, 0, 2)
						tileSetSolid(x, y, 0)
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
					if(gvPlayer.rawin("anStomp")) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == gvPlayer.anStomp) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						playSoundChannel(sndBump, 0, 2)
					}
				}
			}
		}
		if(v == -8) vspeed = 1
		v += vspeed

		drawSprite(sprBoxItem, getFrames() / 9, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "WoodBlock" }
}


::FireBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	fireshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		slideshape = Rec(x, y - 1, 12, 8, 0)
		fireshape = Rec(x, y, 12, 12, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {

		if(actor.rawin("Fireball")) foreach(i in actor["Fireball"])  if(hitTest(fireshape, i.shape)) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Poof, x, y)
			playSound(sndFlame, 0)
		}

		if(actor.rawin("ExplodeF")) foreach(i in actor["ExplodeF"])  if(hitTest(fireshape, i.shape)) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Poof, x, y)
			playSound(sndFlame, 0)
		}

		drawSprite(sprFireBlock, 0, x - 8 - camx, y - 8 - camy)
	}
}

::TNTALT <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		drawSprite(sprC4, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNTALT" }
}
*/

print("Loaded Frostlands")