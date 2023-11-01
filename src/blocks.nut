/*============*\
| BLOCK SOURCE |
\*============*/

::WoodBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	coins = 0
	v = 0.0
	vspeed = 0
	oldsolid = 0
	glimmerTimer = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y + 2, 7, 8, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)

		if(_arr != null && _arr != "") coins = _arr.tointeger()
		game.maxCoins += coins
	}

	function run() {
		if(gvPlayer) {
			if(v == 0) {
				vspeed = 0
				if(coins <= 1) {
					if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y > y + 4) {
						gvPlayer.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}

					if("anim" in gvPlayer && fabs(gvPlayer.hspeed) >= 4.5 && (gvPlayer.inMelee) && hitTest(slideshape, gvPlayer.shape)) {
						gvPlayer.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}

					if("anim" in gvPlayer) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == "stomp") {
						gvPlayer.vspeed = -2.0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}
				}
				else {
					if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape)) {
						gvPlayer.vspeed = 0
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}

					if("anim" in gvPlayer && (fabs(gvPlayer.hspeed) >= 4.5 || (gvPlayer.stats.weapon == "earth" && gvPlayer.vspeed >= 2)) && (gvPlayer.inMelee) && hitTest(slideshape, gvPlayer.shape)) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}

					if("anim" in gvPlayer) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == "stomp") {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
					}
				}
			}
		}

		if(gvPlayer2) {
			if(v == 0) {
				vspeed = 0
				if(coins <= 1) {
					if(gvPlayer2.vspeed < 0) if(hitTest(shape, gvPlayer2.shape) && gvPlayer2.y > y + 4) {
						gvPlayer2.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}

					if("anim" in gvPlayer2 && fabs(gvPlayer2.hspeed) >= 4.5 && (gvPlayer2.inMelee) && hitTest(slideshape, gvPlayer2.shape)) {
						gvPlayer2.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}

					if("anim" in gvPlayer2) if(hitTest(gvPlayer2.shape, shape) && gvPlayer2.anim == "stomp") {
						gvPlayer2.vspeed = -2.0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}
				}
				else {
					if(gvPlayer2.vspeed < 0) if(hitTest(shape, gvPlayer2.shape)) {
						gvPlayer2.vspeed = 0
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}

					if("anim" in gvPlayer2) if((fabs(gvPlayer2.hspeed) >= 4.5 || (gvPlayer2.stats.weapon == "earth" && gvPlayer2.vspeed >= 2)) && (gvPlayer2.inMelee)) if(hitTest(slideshape, gvPlayer2.shape)) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}

					if("anim" in gvPlayer2) if(hitTest(gvPlayer2.shape, shape) && gvPlayer2.anim == "stomp") {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
					}
				}
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) {
			if(((("altShape" in i && hitTest(shape, i.altShape)) || (!("altShape" in i) && hitTest(shape, i.shape)))) && vspeed == 0) {
				if(i.blast && !i.box) {
					if(coins <= 1) {
						deleteActor(id)
						newActor(WoodChunks, x, y)
						stopSound(sndBump)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
						break
					}
					else {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						stopSound(sndBump)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}
					if(i.piercing == 0) deleteActor(i.id)
					else i.piercing--
				}
			}
		}

		if(v == -8) vspeed = 1
		v += vspeed

		if(coins > 0 && game.difficulty == 0) {
			if(glimmerTimer > 0) glimmerTimer--
			else {
				glimmerTimer = randInt(30)
				newActor(Glimmer, x - 8 + randInt(16), y  - 8 + randInt(16))
			}
		}
	}

	function draw() { drawSpriteZ(2, sprWoodBox, 0, x - 8 - camx, y - 8 - camy + v) }

	function destructor() { fireWeapon(BoxHit, x, y - 8, 1, id) }

	function _typeof() { return "WoodBlock" }
}

::BrickBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	coins = 0
	v = 0.0
	vspeed = 0
	oldsolid = 0
	glimmerTimer = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y + 2, 7, 8, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)

		if(_arr != null && _arr != "") coins = _arr.tointeger()
		game.maxCoins += coins
	}

	function run() {
		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) {
			if((("altShape" in i && hitTest(shape, i.altShape)) || (!("altShape" in i) && hitTest(shape, i.shape))) && vspeed == 0) {
				if(i.blast && !i.box) {
					if(coins <= 1) {
						deleteActor(id)
						newActor(BrickChunks, x, y)
						popSound(sndCrumble)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
						break
					}
					else {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						stopSound(sndBump)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}
					if(i.piercing > 0)
						i.piercing--
					if(i.piercing == 0)
						deleteActor(i.id)
				}
			}
		}

		if(gvPlayer) {
			if(v == 0) {
				vspeed = 0
				if(coins <= 1) {
						if("anim" in gvPlayer) if(fabs(gvPlayer.hspeed) >= 8 && (gvPlayer.anim == "slide" || gvPlayer.anim == "ball")) if(hitTest(slideshape, gvPlayer.shape)) {
						gvPlayer.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}

					if("anim" in gvPlayer) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == "stomp") {
						gvPlayer.vspeed = -2.0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}
				}
				else {
					if("anim" in gvPlayer) if((fabs(gvPlayer.hspeed) >= 8 || (gvPlayer.stats.weapon == "earth" && gvPlayer.vspeed >= 2)) && gvPlayer.anim == "slide") if(hitTest(slideshape, gvPlayer.shape)) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}

					if("anim" in gvPlayer) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == "stomp") {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
					}
				}
			}
		}

		if(gvPlayer2) {
			if(v == 0) {
				vspeed = 0
				if(coins <= 1) {
						if("anim" in gvPlayer2) if(fabs(gvPlayer2.hspeed) >= 8 && (gvPlayer2.anim == "slide" || gvPlayer2.anim == "ball")) if(hitTest(slideshape, gvPlayer2.shape)) {
						gvPlayer2.vspeed = 0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						fireWeapon(BoxHit, x, y - 8, 1, id)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}

					if("anim" in gvPlayer2) if(hitTest(gvPlayer2.shape, shape) && gvPlayer2.anim == "stomp") {
						gvPlayer2.vspeed = -2.0
						deleteActor(id)
						newActor(WoodChunks, x, y)
						popSound(sndBump, 0)
						tileSetSolid(x, y, oldsolid)
						if(coins > 0) newActor(CoinEffect, x, y - 16)
						foreach(k, i in gvYetFoundItems) if(i == id)
							gvFoundItems[k] <- typeof this
					}
				}
				else {
					if("anim" in gvPlayer2) if((fabs(gvPlayer2.hspeed) >= 8 || (gvPlayer2.stats.weapon == "earth" && gvPlayer2.vspeed >= 2)) && gvPlayer2.anim == "slide") if(hitTest(slideshape, gvPlayer2.shape)) {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
						fireWeapon(BoxHit, x, y - 8, 1, id)
					}

					if("anim" in gvPlayer2) if(hitTest(gvPlayer2.shape, shape) && gvPlayer2.anim == "stomp") {
						vspeed = -2
						coins--
						newActor(CoinEffect, x, y - 16)
						popSound(sndBump, 0)
					}
				}
			}
		}

		if(v == -8) vspeed = 1
		v += vspeed
		if(v == 0) vspeed = 0

		if(coins > 0 && game.difficulty == 0) {
			if(glimmerTimer > 0) glimmerTimer--
			else {
				glimmerTimer = randInt(30)
				newActor(Glimmer, x - 8 + randInt(16), y  - 8 + randInt(16))
			}
		}
	}

	function draw() { drawSpriteZ(2, sprBrickBlock, 0, x - 8 - camx, y - 8 - camy + v) }

	function destructor() { fireWeapon(BoxHit, x, y - 8, 1, id) }

	function _typeof() { return "BrickBlock" }
}

::IceBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	fireshape = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 7, 9, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)
		fireshape = Rec(x, y, 12, 12, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 40)
	}

	function run() {
		if(gvPlayer) {
			if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y > y + 4) {
				gvPlayer.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				popSound(sndBump, 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}

			if((fabs(gvPlayer.hspeed) >= 3.5 || (gvPlayer.stats.weapon == "earth" && gvPlayer.vspeed >= 2)) && (gvPlayer.inMelee)) if(hitTest(slideshape, gvPlayer.shape)) {
				gvPlayer.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				popSound(sndBump, 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}

			if("anim" in gvPlayer) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == "stomp") {
				gvPlayer.vspeed = -2.0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				popSound(sndBump, 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}
		}

		if(gvPlayer2) {
			if(gvPlayer2.vspeed < 0) if(hitTest(shape, gvPlayer2.shape) && gvPlayer2.y > y + 4) {
				gvPlayer2.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				popSound(sndBump, 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}

			if((fabs(gvPlayer2.hspeed) >= 3.5 || (gvPlayer2.stats.weapon == "earth" && gvPlayer2.vspeed >= 2)) && (gvPlayer2.inMelee)) if(hitTest(slideshape, gvPlayer2.shape)) {
				gvPlayer2.vspeed = 0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				popSound(sndBump, 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}

			if("anim" in gvPlayer2) if(hitTest(gvPlayer2.shape, shape) && gvPlayer2.anim == "stomp") {
				gvPlayer2.vspeed = -2.0
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				newActor(IceChunks, x, y)
				popSound(sndBump, 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"])  if((("altShape" in i && hitTest(shape, i.altShape)) || (!("altShape" in i) && hitTest(shape, i.shape))) && (i.element == "fire" || i.blast) && !i.box && i.element != "ice") {
			tileSetSolid(x, y, oldsolid)
			deleteActor(id)
			i.piercing--
			if(i.piercing == 0) deleteActor(i.id)

			if(i.element == "fire") {
				newActor(Poof, x, y)
				stopSound(sndFlame)
				popSound(sndFlame, 0)
			}

			if(i.blast) {
				newActor(IceChunks, x, y)
				stopSound(sndIceBreak)
				popSound(sndIceBreak, 0)
			}
		}
	}

	function draw() { drawSpriteZ(2, sprIceBlock, 0, x - 8 - camx, y - 8 - camy) }

	function _typeof() { return "IceBlock" }
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

		timer--
		if(timer == 0) deleteActor(id)
	}

	function draw() {
		drawSpriteZ(2, sprWoodChunks, 0, x - camx - h - 2, y - camy + v - 2, -a, 0, 1, 1, 1)
		drawSpriteZ(2, sprWoodChunks, 1, x - camx + h + 2, y - camy + v - 2, a, 0, 1, 1, 1)
		drawSpriteZ(2, sprWoodChunks, 2, x - camx - h - 2, y - camy + v + 2 + h, -a, 0, 1, 1, 1)
		drawSpriteZ(2, sprWoodChunks, 3, x - camx + h + 2, y - camy + v + 2 + h, a, 0, 1, 1, 1)
	}
}

::BrickChunks <- class extends Actor {
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

		timer--
		if(timer == 0) deleteActor(id)
	}

	function draw() {
		drawSpriteZ(2, sprBrickChunks, 0, x - camx - h - 2, y - camy + v - 2, -a, 0, 1, 1, 1)
		drawSpriteZ(2, sprBrickChunks, 1, x - camx + h + 2, y - camy + v - 2, a, 0, 1, 1, 1)
		drawSpriteZ(2, sprBrickChunks, 2, x - camx - h - 2, y - camy + v + 2 + h, -a, 0, 1, 1, 1)
		drawSpriteZ(2, sprBrickChunks, 3, x - camx + h + 2, y - camy + v + 2 + h, a, 0, 1, 1, 1)
	}
}

::ItemBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	refill = 3600

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		item = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}

		if(game.difficulty == 2 && (item == 1 || item == 2)) full = false
		if(!full && item != 0)
			refill--
		if(refill == 0) {
			full = true
			refill = 3600
		}

		if(v <= -8) {
			vspeed = 1
			switch(item){
				case 0:
					newActor(CoinEffect, x, y - 16)
					foreach(k, i in gvYetFoundItems) if(i == id)
						gvFoundItems[k] <- typeof this
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

				case 9:
					newActor(MuffinBomb, x, y - 16)
					break

				case 10:
					newActor(EarthShell, x, y - 16)
					break

				case 11:
					newActor(ShockBulb, x, y - 16)
					break
				
				case 12:
					newActor(WaterLily, x, y - 16)
					break
			}
		}

		if(gvPlayer && hitTest(shape, gvPlayer.shape) && gvPlayer.vspeed < 0 && v == 0 && full){
			gvPlayer.vspeed = 0
			full = false
			vspeed = -2
			popSound(sndBump, 0)
			fireWeapon(BoxHit, x, y - 8, 1, id)
		}
		else if(gvPlayer2 && hitTest(shape, gvPlayer2.shape) && gvPlayer2.vspeed < 0 && v == 0 && full){
			gvPlayer2.vspeed = 0
			full = false
			vspeed = -2
			popSound(sndBump, 0)
			fireWeapon(BoxHit, x, y - 8, 1, id)
		}

		v += vspeed
	}

	function draw() {
		if(full || vspeed < 0) drawSpriteZ(2, sprBoxItem, (getFrames() / 12) + (x / 16) + (y / 4), x - 8 - camx, y - 8 - camy + v)
		else drawSpriteZ(2, sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}

	function _typeof() { return "ItemBlock" }
}

::TriggerBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	code = ""

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		code = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
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

		if(gvPlayer && hitTest(shape, gvPlayer.shape) && gvPlayer.vspeed < 0 && v == 0 && full){
			gvPlayer.vspeed = 0
			full = false
			vspeed = -1
			popSound(sndBump, 0)
		}
		else if(gvPlayer2 && hitTest(shape, gvPlayer2.shape) && gvPlayer2.vspeed < 0 && v == 0 && full){
			gvPlayer2.vspeed = 0
			full = false
			vspeed = -1
			popSound(sndBump, 0)
		}

		v += vspeed
	}

	function draw() {
		if(full || vspeed < 0) drawSpriteZ(2, sprBoxRed, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
		else drawSpriteZ(2, sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}

	function _typeof() { return "TriggerBlock" }
}

::InfoBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	text = ""
	arr = null

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		text = textLineLen(formatInfo(_arr), gvTextW)
		arr = _arr

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}
		if(v <= -8) {
			vspeed = 0.5
		}

		if(gvPlayer && hitTest(shape, gvPlayer.shape) && gvPlayer.vspeed < 0 && v == 0 && full){
			gvPlayer.vspeed = 0
			vspeed = -1
			popSound(sndBump, 0)
			text = textLineLen(formatInfo(arr), gvTextW)
			gvInfoBox = text
		}

		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape) && gvPlayer2.vspeed < 0 && v == 0 && full){
			gvPlayer2.vspeed = 0
			vspeed = -1
			popSound(sndBump, 0)
			text = textLineLen(formatInfo(arr), gvTextW)
			gvInfoBox = text
		}

		if(gvInfoBox == text && (gvPlayer && !gvPlayer2 && !inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)
			|| gvPlayer2 && !gvPlayer && !inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 64)
			|| gvPlayer && gvPlayer2 &&!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64) && !inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 64))) gvInfoBox = ""

		v += vspeed
	}

	function draw() { drawSpriteZ(2, sprBoxInfo, getFrames() / 8, x - 8 - camx, y - 8 - camy + v) }

	function _typeof() { return "InfoBlock" }
}

::KelvinScarf <- class extends Actor {
	shape = 0
	text = ""
	arr = null

	constructor(_x, _y, _arr = "") {
		base.constructor(_x, _y)
		text = textLineLen(formatInfo(_arr), gvTextW)
		arr = _arr

		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {
		if(!devcom || gvTimeAttack) return

		if(devcom) {
			if(gvPlayer && hitTest(shape, gvPlayer.shape)){
				text = textLineLen(formatInfo(arr), gvTextW)
				gvInfoBox = text
				if(gvPlayer.invincible <= 1) gvPlayer.invincible = 10
			}

			if(gvInfoBox == text && (gvPlayer && !gvPlayer2 && !inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)
			|| gvPlayer2 && !gvPlayer && !inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 64)
			|| gvPlayer && gvPlayer2 &&!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64) && !inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 64))) gvInfoBox = ""
		}
	}

	function draw() { if(devcom) drawSpriteZ(2, sprKelvinScarf, getFrames() / 16, x - 8 - camx, y - 8 - camy) }

	function _typeof() { return "KelvinScarf" }
}

::BounceBlock <- class extends Actor {
	shape = 0
	full = true
	v = 0.0
	vspeed = 0.0
	item = 0
	text = ""
	note = -1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 8, 9, 0)
		tileSetSolid(x, y, 1)

		if(canint(_arr))
			note = int(_arr)
		note = max(note, -1)
		note = min(note, 7)
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

		if(gvPlayer) {
			shape.setPos(x, y + 2)
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0 && v == 0) if(full){
				gvPlayer.vspeed = 1
				vspeed = -1
				popSound(sndPing[(note == -1 ? randInt(8) : note)], 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}

			shape.setPos(x, y - 1)
			if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed >= 0 && v == 0) if(full){
				gvPlayer.vspeed = -4
				if(getcon("jump", "hold", true, 1)) gvPlayer.vspeed = -8
				vspeed = 1
				popSound(sndPing[(note == -1 ? randInt(8) : note)], 0)
			}
		}

		if(gvPlayer2) {
			shape.setPos(x, y + 2)
			if(hitTest(shape, gvPlayer2.shape)) if(gvPlayer2.vspeed < 0 && v == 0) if(full){
				gvPlayer2.vspeed = 1
				vspeed = -1
				popSound(sndPing[(note == -1 ? randInt(8) : note)], 0)
				fireWeapon(BoxHit, x, y - 8, 1, id)
			}

			shape.setPos(x, y - 1)
			if(hitTest(shape, gvPlayer2.shape)) if(gvPlayer2.vspeed >= 0 && v == 0) if(full){
				gvPlayer2.vspeed = -4
				if(getcon("jump", "hold", true, 2)) gvPlayer2.vspeed = -8
				vspeed = 1
				popSound(sndPing[(note == -1 ? randInt(8) : note)], 0)
			}
		}

		v += vspeed


	}

	function draw() { drawSpriteZ(2, sprBoxBounce, getFrames() / 8, x - 8 - camx, y - 8 - camy + v) }

	function _typeof() { return "BounceBlock" }
}

::Checkpoint <- class extends Actor {
	shape = null
	found = false
	timer = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 16, 10, 16, 0)
	}

	function run() {
		if(found == false
		&& (gvPlayer && hitTest(shape, gvPlayer.shape)
		   || gvPlayer2 && hitTest(shape, gvPlayer2.shape))
		&& timer <= 0) {
			foreach(i in actor["Checkpoint"]) {
				i.found = false
			}

			found = true
			game.check = true
			game.chx = x
			game.chy = y
			popSound(sndBell, 0)

			if(game.difficulty < 3) {
				if(gvPlayer) {
					if(game.ps.health < game.maxHealth) game.ps.health += 4
					else if(game.ps.subitem == 0) game.ps.subitem = "muffinBlue"
				}

				if(gvPlayer2) {
					if(game.ps2.health < game.maxHealth) game.ps2.health += 4
					else if(game.ps2.subitem == 0) game.ps2.subitem = "muffinBlue"
				}
			}

			timer = 120

			if(gvNumPlayers > 1) {
				local c = null

				if(gvPlayer && !gvPlayer2) {
					c = actor[newActor(getroottable()[game.playerChar2], game.chx, game.chy)]
					c.tftime = 0
				}

				if(!gvPlayer && gvPlayer2) {
					c = actor[newActor(getroottable()[game.playerChar], game.chx, game.chy)]
					c.tftime = 0
				}
			}
		}

		timer--
	}

	function draw() {
		if(found) drawSprite(sprCheckBell, getFrames() / 8, x - camx, y - camy)
		else drawSprite(sprCheckBell, 0, x - camx, y - camy)
	}

	function _typeof() { return "Checkpoint" }
}

::TNT <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0
	fireshape = null
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		fireshape = Rec(x, y, 14, 12, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(gothit) {
			hittime += 2
			frame += 0.002 * hittime
			if(hittime >= 150) {
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				fireWeapon(ExplodeF2, x, y, 0, id)
			}
		}
		else {
			//Hit by player
			if(gvPlayer && hitTest(shape, gvPlayer.shape) || gvPlayer2 && hitTest(shape, gvPlayer2.shape)) {
				gothit = true
				stopSound(sndFizz)
				popSound(sndFizz, 0)
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"])
		if((("altShape" in i && hitTest(fireshape, i.altShape)) || (!("altShape" in i) && hitTest(fireshape, i.shape))) && (i.blast || i.element == "fire") && i.element != "ice" && i.element != "water") {
			hittime = max(hittime, 135 + game.difficulty)
			gothit = true
			break
		}
	}

	function draw() {
		if(gothit) {
			if(hittime > 120) drawSpriteZ(2, sprTNT, frame, x - 8 - camx + ((randInt(8) - 4) / 4) - ((2.0 / 150.0) * hittime), y - 8 - camy + ((randInt(8) - 4) / 4) - ((2.0 / 150.0) * hittime), 0, 0, 1.0 + ((0.25 / 150.0) * hittime), 1.0 + ((0.25 / 150.0) * hittime), 1)
			else drawSpriteZ(2, sprTNT, frame, x - 8 - camx + ((randInt(8) - 4) / 4), y - 8 - camy + ((randInt(8) - 4) / 4))
		}
		else drawSpriteZ(2, sprTNT, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNT" }
}

::C4 <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0
	fireshape = null
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
		fireshape = Rec(x, y, 16, 16, 0)
	}

	function run() {
		if(gothit) {
			hittime += 2
			frame += 0.002 * hittime
			if(hittime >= 150) {
				tileSetSolid(x, y, oldsolid)
				deleteActor(id)
				fireWeapon(ExplodeF2, x, y, 0, id)
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"])
		if((("altShape" in i && hitTest(fireshape, i.altShape)) || (!("altShape" in i) && hitTest(fireshape, i.shape))) && (i.blast && i.power > 1 && (i.element == "fire" || i.element == "shock"))) {
			hittime = max(hittime, 135 + game.difficulty)
			gothit = true
			break
		}
	}

	function draw() { drawSpriteZ(2, sprC4, frame, x - 8 - camx, y - 8 - camy) }

	function _typeof() { return "C4" }
}

::ColorBlock <- class extends Actor {
	color = null
	filled = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr == null) color = 0
		else color = _arr

		if(color != null) if(game.colorswitch[color]) filltile()
	}

	function filltile() {
		if(game.turnOffBlocks) return
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

	function run() {
		if(color != null) if(game.colorswitch[color]) filltile()
	}

	function draw() { drawSpriteZ(2, sprColorBlock, (color * 2) + filled, x - camx, y - camy) }

	function _typeof() { return "ColorBlock" }
}


::ColorSwitch <- class extends Actor {
	color = 0
	shape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr == null) color = 0
		else color = _arr.tointeger()

		shape = Rec(x, y, 16, 16, 0)
	}

	function run() {
		if(game.colorswitch[color] == true)
			return

		if(gvPlayer && hitTest(shape, gvPlayer.shape) && gvPlayer.y < y - 16 && gvPlayer.vspeed > 0) {
			gvPlayer.vspeed = -2
			game.colorswitch[color] = true
			dostr("saveGame()")
			if(actor.rawin("ColorBlock")) foreach(i in actor["ColorBlock"]) {
				i.filltile()
			}
		}

		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape) && gvPlayer2.y < y - 16 && gvPlayer2.vspeed > 0) {
			gvPlayer2.vspeed = -2
			game.colorswitch[color] = true
			dostr("saveGame()")
			if(actor.rawin("ColorBlock")) foreach(i in actor["ColorBlock"]) {
				i.filltile()
			}
		}
	}

	function draw() {
		if(game.colorswitch[color]) drawSprite(sprColorSwitch, (color * 2) + 1, x - camx, y - camy)
		else drawSprite(sprColorSwitch, color * 2, x - camx, y - camy)
	}

	function _typeof() { return "ColorSwitch" }
}

::EvilBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
		slideshape = Rec(x, y - 1, 12, 8, 0)
	}

	function run() {
		if(gvPlayer && gvPlayer.vspeed < 0 && hitTest(shape, gvPlayer.shape)) {
			gvPlayer.vspeed = 0
			tileSetSolid(x, y, oldsolid)
			deleteActor(id)
			newActor(Poof, x, y)
			popSound(sndBump, 0)
			newActor(Darknyan, x, y - 16)
		}
		else if(gvPlayer2 && gvPlayer2.vspeed < 0 && hitTest(shape, gvPlayer2.shape)) {
			gvPlayer2.vspeed = 0
			tileSetSolid(x, y, oldsolid)
			deleteActor(id)
			newActor(Poof, x, y)
			popSound(sndBump, 0)
			newActor(Darknyan, x, y - 16)
		}
	}

	function draw() { drawSpriteZ(2, sprBoxItem, getFrames() / 16, x - 8 - camx, y - 8 - camy) }

	function _typeof() { return "EvilBlock" }
}

::EvilBlockB <- class extends Actor {
	shape = 0
	slideshape = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
		slideshape = Rec(x, y - 1, 12, 8, 0)
	}

	function run() {
		if(gvPlayer && gvPlayer.vspeed < 0 && hitTest(shape, gvPlayer.shape)) {
			gvPlayer.vspeed = 0
			tileSetSolid(x, y, oldsolid)
			deleteActor(id)
			newActor(Poof, x, y)
			popSound(sndBump, 0)
			newActor(MuffinBomb, x, y - 16)
		}
		else if(gvPlayer2 && gvPlayer2.vspeed < 0 && hitTest(shape, gvPlayer2.shape)) {
			gvPlayer2.vspeed = 0
			tileSetSolid(x, y, oldsolid)
			deleteActor(id)
			newActor(Poof, x, y)
			popSound(sndBump, 0)
			newActor(MuffinBomb, x, y - 16)
		}
	}

	function draw() { drawSpriteZ(2, sprBoxItem, getFrames() / 16, x - 8 - camx, y - 8 - camy) }

	function _typeof() { return "EvilBlockB" }
}

::BreakBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	tile = 0
	solidtile = 0
	layer = 0
	solidlayer = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
		slideshape = Rec(x, y - 1, 12, 8, 0)

		//Get graphic layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "fg") {
				layer = gvMap.data.layers[i]
				break
			}
		}

		//Find tile
		local cx = floor(x / 16)
		local cy = floor(y / 16)
		tile = cx + (cy * layer.width)

		//Get solid layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				solidlayer = gvMap.data.layers[i]
				break
			}
		}
	}

	function _typeof() { return "BreakBlock" }
}

::LockBlock <- class extends Actor {
	color = 0
	oldsolid = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(_arr == null) color = 0
		else color = _arr.tointeger()

		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y, 32)
		|| gvPlayer2 && inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 32)) {
			switch(color) {
				case 0:
					if(gvKeyCopper) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						popSound(sndBump, 0)
					}
					break
				case 1:
					if(gvKeySilver) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						popSound(sndBump, 0)
					}
					break
				case 2:
					if(gvKeyGold) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						popSound(sndBump, 0)
					}
					break
				case 3:
					if(gvKeyMythril) {
						tileSetSolid(x, y, oldsolid)
						deleteActor(id)
						newActor(Poof, x, y)
						stopSound(sndBump)
						popSound(sndBump, 0)
					}
					break
			}
		}
	}

	function draw() { drawSpriteZ(2, sprLockBlock, color, x - camx, y - camy) }

	function _typeof() { return "LockBlock" }
}

::BossDoor <- class extends Actor {
	dy = 0
	moving = false
	delay = 0
	opening = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(_arr != "") delay = _arr.tointeger()
	}

	function run() {
		if(gvWarning <= 10 && dy == 0) {
			moving = true
			tileSetSolid(x, y, 1)
			tileSetSolid(x, y - 16, 1)
			tileSetSolid(x, y - 32, 1)
			tileSetSolid(x, y - 48, 1)
		}
		if(moving && dy < 32 && !opening) {
			if(delay > 0) delay--
			else dy++
		}
		else if(opening && dy > 0) {
			dy--
			tileSetSolid(x, y, 0)
			tileSetSolid(x, y - 16, 0)
			tileSetSolid(x, y - 32, 0)
			tileSetSolid(x, y - 48, 0)
		}
	}

	function draw() {
		drawSpriteZ(4, sprBossDoor, 0, x - camx, y - camy - dy + 16)
		drawSpriteZ(4, sprBossDoor, 0, x - camx, y - camy - 80 + dy)
	}

	function _typeof() { return "BossDoor" }
}

::FishBlock <- class extends Actor {
	shape = 0
	slideshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y + 2, 8, 8, 0)
		slideshape = Rec(x, y - 1, 12, 8, 0)
	}

	function run() {
		if(gvPlayer) {
			if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)) if(game.maxRedCoins <= game.redCoins ){
				deleteActor(id)
				newActor(Poof, x, y)
				tileSetSolid(x, y, 0)
				popSound(sndBump, 0)
			}
		}

		if(gvPlayer2) {
			if(inDistance2(x, y, gvPlayer2.x, gvPlayer2.y, 64)) if(game.maxRedCoins <= game.redCoins ){
				deleteActor(id)
				newActor(Poof, x, y)
				tileSetSolid(x, y, 0)
				popSound(sndBump, 0)
			}
		}
	}

	function draw() { drawSprite(sprFishBlock, 0, x - 8 - camx, y - 8 - camy) }

	function _typeof() { return "FishBlock" }
}

::FireBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	fireshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		slideshape = Rec(x, y - 1, 12, 8, 0)
		fireshape = Rec(x, y, 16, 16, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {

		if(actor.rawin("WeaponEffect"))foreach(i in actor["WeaponEffect"]) if((("altShape" in i && hitTest(fireshape, i.altShape)) || (!("altShape" in i) && hitTest(fireshape, i.shape))) && i.element == "fire") {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			if(i.piercing == 0)
				deleteActor(i.id)
			else
				i.piercing--
			newActor(Flame, x, y)
			popSound(sndFlame, 0)
		}

		if(actor.rawin("Flame"))foreach(i in actor["Flame"])if(inDistance2(x, y, i.x, i.y, 16) && i.frame >= 6) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			newActor(Flame, x, y)
			popSound(sndFlame, 0)
		}
	}

	function draw() { drawSprite(sprFireBlock, 0, x - 8 - camx, y - 8 - camy) }

	function _typeof() { return "FireBlock" }
}

::CharSwapper <- class extends Actor {
	shape = 0
	full = true
	character = "Tux"
	v = 0.0
	vspeed = 0.0
	swapmode = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(_arr != null && _arr != "")
			character = _arr
		else if(game.playerChar2 != "") {
			character = game.playerChar2
			swapmode = true
		}
		else
			character = game.playerChar


		shape = Rec(x, y + 2, 8, 8, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		if(v > 0) {
			vspeed = 0
			v = 0
		}

		if(gvPlayer && !hitTest(shape, gvPlayer.shape)) tileSetSolid(x, y, 1)

		if(v <= -8) {
			vspeed = 1

			local nx = gvPlayer.x
			local ny = gvPlayer.y
			local nf = gvPlayer.flip
			local nh = gvPlayer.hspeed
			local nv = gvPlayer.vspeed
			local ns = gvPlayer.stats
			deleteActor(gvPlayer.id)
			gvPlayer = false
			newActor(getroottable()[character], nx, ny)
			gvPlayer.tftime = 0
			gvPlayer.flip = nf
			gvPlayer.hspeed = nh
			gvPlayer.vspeed = nv
			gvPlayer.stats = ns

			tileSetSolid(x, y, 0)
			popSound(sndHeal, 0)

			if(swapmode) {
				if(character == game.playerChar)
					character = game.playerChar2
				else
					character = game.playerChar
			}
		}

		full = (game.characters.rawin(character) && !(gvPlayer && typeof gvPlayer == character || gvPlayer2 && typeof gvPlayer2 == character))

		if(gvPlayer && hitTest(shape, gvPlayer.shape) && gvPlayer.vspeed < 0 && v == 0 && full){
			gvPlayer.vspeed = 0
			vspeed = -2
			v -= 2
			popSound(sndBump, 0)
		}

		v += vspeed
	}

	function draw() {
		if(full || vspeed < 0) {
			drawSpriteZ(2, sprBoxShop, getFrames() / 8, x - 8 - camx, y - 8 - camy + v)
			if(character in gvCharacters) drawSpriteZ(2, getroottable()[gvCharacters[character]["doll"]], 0, x - camx, y - camy + v)
		}
		else drawSpriteZ(2, sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy + v)
	}

	function _typeof() { return "CharSwapper" }
}

::Crumbler <- class extends Actor {
	shape = 0
	timer = 0
	oldsolid = 0
	broken = false
	alpha = 1.0
	wasStepped = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)
		shape = Rec(x, y - 1, 8, 8, 0)
	}

	function run() {
		if(!broken) {
			if(alpha < 1.0) alpha += 0.1
			if((gvPlayer && hitTest(shape, gvPlayer.shape)
			|| gvPlayer2 && hitTest(shape, gvPlayer2.shape)) && !wasStepped) wasStepped = true
			if(wasStepped) timer += 2
			if(timer == 30) {
				broken = true
				tileSetSolid(x, y, oldsolid)
				timer = 0
				alpha = 0.0
				if(sprCrumbleRock == sprCrumbleIce) {
					newActor(IceChunks, x, y)
					popSound(sndIceBreak)
				} else {
					newActor(RockChunks, x, y)
					popSound(sndCrumble)
				}
			}
		}
		else {
			if(timer < 300) timer++
			if((gvPlayer && !gvPlayer2 && !hitTest(shape, gvPlayer.shape)
				|| gvPlayer2 && !gvPlayer && !hitTest(shape, gvPlayer2.shape)
				|| gvPlayer && gvPlayer2 && !hitTest(shape, gvPlayer.shape) && !hitTest(shape, gvPlayer2.shape))
			&& timer == 300) {
				broken = false
				tileSetSolid(x, y, 1)
				timer = 0
				wasStepped = false
			}
		}
	}

	function draw() { if(!broken) drawSpriteZ(7, sprCrumbleRock, timer / 8, x - camx, y - camy, 0, 0, 1, 1, alpha) }

	function _typeof() { return "Crumbler" }
}

::BuildCube <- class extends PhysAct {
	held = 0

	constructor(_x, _y, _arr = null) {
		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {

	}

	function draw() {
		drawSprite(sprCube, 0, x - camx, y - camy)
	}
}

::FlipBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	spinning = 0
	v = 0.0
	vspeed = 0
	oldsolid = 0
	glimmerTimer = 0
	spintime = 120

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		oldsolid = tileGetSolid(x, y)
		tileSetSolid(x, y, 1)

		shape = Rec(x, y + 2, 7, 8, 0)
		slideshape = Rec(x, y - 1, 16, 8, 0)
	}

	function run() {
		if(spinning > 0)
			spinning--
		if(spinning == 0 && (
			gvPlayer && !gvPlayer2 && !hitTest(shape, gvPlayer.shape)
			|| !gvPlayer && gvPlayer2 && !hitTest(shape, gvPlayer2.shape)
			|| gvPlayer && gvPlayer2 && !hitTest(shape, gvPlayer.shape) && !hitTest(shape, gvPlayer2.shape)
		))
			tileSetSolid(x, y, 1)
		if(gvPlayer) {
			if(spinning == 0) {
				if(gvPlayer.vspeed < 0) if(hitTest(shape, gvPlayer.shape) && gvPlayer.y > y + 4) {
					gvPlayer.vspeed = 0
					popSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					fireWeapon(BoxHit, x, y - 8, 1, id)
					spinning = spintime
				}

				if(fabs(gvPlayer.hspeed) >= 4.5 && (gvPlayer.inMelee) && hitTest(slideshape, gvPlayer.shape)) {
					gvPlayer.vspeed = 0
					popSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					fireWeapon(BoxHit, x, y - 8, 1, id)
					spinning = spintime
				}

				if("anim" in gvPlayer) if(hitTest(gvPlayer.shape, shape) && gvPlayer.anim == "stomp") {
					gvPlayer.vspeed = -2.0
					popSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					fireWeapon(BoxHit, x, y - 8, 1, id)
					spinning = spintime
				}
			}
		}

		if(gvPlayer2) {
			if(spinning == 0) {
				if(gvPlayer2.vspeed < 0) if(hitTest(shape, gvPlayer2.shape) && gvPlayer2.y > y + 4) {
					gvPlayer2.vspeed = 0
					popSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					fireWeapon(BoxHit, x, y - 8, 1, id)
					spinning = spintime
				}

				if(fabs(gvPlayer2.hspeed) >= 4.5 && (gvPlayer2.inMelee) && hitTest(slideshape, gvPlayer2.shape)) {
					gvPlayer2.vspeed = 0
					popSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					fireWeapon(BoxHit, x, y - 8, 1, id)
					spinning = spintime
				}

				if("anim" in gvPlayer2) if(hitTest(gvPlayer2.shape, shape) && gvPlayer2.anim == "stomp") {
					gvPlayer2.vspeed = -2.0
					popSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					fireWeapon(BoxHit, x, y - 8, 1, id)
					spinning = spintime
				}
			}
		}

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) {
			if(((("altShape" in i && hitTest(shape, i.altShape)) || (!("altShape" in i) && hitTest(shape, i.shape)))) && spinning == 0) {
				if(i.blast && !i.box && spinning == 0) {
					popSound(sndBump, 0)
					tileSetSolid(x, y, oldsolid)
					fireWeapon(BoxHit, x, y - 8, 1, id)
					spinning = spintime
				}
			}
		}
	}

	function draw() { drawSpriteZ(2, sprFlipBlock, spinning / 5.0, x - 8 - camx, y - 8 - camy + v) }

	function destructor() { fireWeapon(BoxHit, x, y - 8, 1, id) }

	function _typeof() { return "WoodBlock" }
}