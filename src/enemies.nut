::Enemy <- class extends PhysAct {
	health = 1.0
	active = false
	frozen = 0
	freezeTime = 600
	minFreezeTime = 0
	freezeSprite = -1
	icebox = -1
	nocount = false
	damageMult = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
		stomp = 1.0
		star = 10.0
	}
	blinking = 0.0
	blinkSpeed = 1.0
	blinkMax = 10.0
	touchDamage = 0.0
	element = "normal"
	sharpTop = false
	sharpSide = false
	held = false
	squish = false
	blast = false
	cut = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		if(active) {
			base.run()
			if(frozen > 0) frozen--

			//Check for weapon effects
			if(actor.rawin("WeaponEffect") && !blinking) foreach(i in actor["WeaponEffect"]) {
				//Skip weapons that don't hurt this enemy
				if(i.alignment == 2) continue
				if(i.owner == id) continue

				if(hitTest(shape, i.shape)) {
					if(gvPlayer) getHurt(gvPlayer, i.power, i.element, i.cut, i.blast)
					else getHurt(0, i.power, i.element, i.cut, i.blast)
					if(i.piercing == 0) deleteActor(i.id)
					else i.piercing--
				}
			}

			if(gvPlayer && health > 0) {
				if(hitTest(shape, gvPlayer.shape) && !frozen) { //8 for player radius
					if("invincible" in gvPlayer && gvPlayer.invincible > 0) hurtInvinc()
					else if(y > gvPlayer.y && vspeed < gvPlayer.vspeed && gvPlayer.canStomp && gvPlayer.placeFree(gvPlayer.x, gvPlayer.y + 2) && blinking == 0 && !sharpTop && !gvPlayer.swimming) {
						if(!squish) {
							if(getcon("jump", "hold", false, 1)) gvPlayer.vspeed = -8.0
							else gvPlayer.vspeed = -4.0
						}
						getHurt(gvPlayer, gvPlayer.stompDamage, "normal", false, false, true)
					}
					else if(("anim" in gvPlayer) && blinking == 0 && !sharpSide) {
						if(gvPlayer.inMelee) getHurt(gvPlayer, 1, "normal", false, false, false)
						else hurtPlayer(gvPlayer)
					}
					else hurtPlayer(gvPlayer)
				}
			}

			if(gvPlayer2) {
				if(hitTest(shape, gvPlayer2.shape) && !frozen) { //8 for player radius
					if("invincible" in gvPlayer2 && gvPlayer2.invincible > 0) hurtInvinc()
					else if(y > gvPlayer2.y && vspeed < gvPlayer2.vspeed && gvPlayer2.canStomp && gvPlayer2.placeFree(gvPlayer2.x, gvPlayer2.y + 2) && blinking == 0 && !sharpTop && !gvPlayer2.swimming) {
						if(!squish) {
							if(getcon("jump", "hold", false, 2)) gvPlayer2.vspeed = -8.0
							else gvPlayer2.vspeed = -4.0
						}
						getHurt(gvPlayer2, gvPlayer2.stompDamage, "normal", false, false, true)
					}
					else if(("anim" in gvPlayer2) && blinking == 0 && !sharpSide) {
						if(gvPlayer2.inMelee) getHurt(gvPlayer2, 1, "normal", false, false, false)
						else hurtPlayer(gvPlayer2)
					}
					else hurtPlayer(gvPlayer2)
				}
			}

			if(blinking > 0) blinking -= blinkSpeed
			if(blinking < 0) blinking = 0
		}
		else if(isOnScreen()) active = true
	}

	function hurtInvinc() {
		mapDeleteSolid(icebox)
		newActor(Poof, x, y)
		die()
		popSound(sndFlame, 0)
	}

	function die() {
		mapDeleteSolid(icebox)
		if(frozen) newActor(IceChunks, x, y)
		frozen = 0

		deleteActor(id)

		if(!nocount) game.enemies++
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(blinking > 0) return

		local damage = _mag * damageMult[_element]
		if(_cut) damage *= damageMult["cut"]
		if(_blast) damage *= damageMult["blast"]
		if(_stomp) damage *= damageMult["stomp"]

		health -= damage
		if(damage > 0) blinking = blinkMax

		if(health <= 0) {
			frozen = 0
			mapDeleteSolid(icebox)
			die()
			return
		}
		if(_element == "ice") frozen = minFreezeTime + (freezeTime * damageMult["ice"])
		if(_element == "fire") {
			newActor(Flame, x, y)
			popSound(sndFlame, 0)
		}
	}

	function hurtPlayer(target) {
		if(blinking || squish) return
		target.hurt = touchDamage * target.damageMult[element] * (cut ? target.damageMult["cut"] : 1) * (blast ? target.damageMult["blast"] : 1)
	}

	function holdMe(throwH = 2.0, throwV = 2.0) {
		if(frozen)
			return

		local target = findPlayer()
		if(target == null) {
			held = false
			return
		}

		if(target.anim == "slide" || target.anim == "ball" || target.inMelee) {
			target.holding = 0
			held = false
			return
		}

		if(target != null) {
			if((target.inMelee))
				held = false
			else if(hitTest(shape, target.shape)
			&& (getcon("shoot", "hold", false, target.playerNum) || getcon("spec1", "hold", false, target.playerNum))
			&& (target.holding == 0|| target.holding == id) && hspeed == 0) {
				y = target.y
				flip = target.flip
				if(flip == 0) x = target.x + 10
				else x = target.x - 10
				x += target.hspeed
				y += target.vspeed
				held = true
				target.holding = id
			}

			if(target.rawin("anClimb") && target.anim == target.anClimb && held) {
				target.holding = 0

				//escape from solid
				if(!placeFree(x, y)) {
					local escapedir = target.x <=> x
					while(!placeFree(x, y)) x += escapedir
				}
				shape.setPos(x, y)
				held = false
			}

			//escape from solid
			if(!placeFree(x, y)) {
				local escapedir = target.x <=> x
				while(!placeFree(x, y)) x += escapedir
			}
		}
		
		if("playerNum" in target && !getcon("shoot", "hold", false, target.playerNum) && !getcon("spec1", "hold", false, target.playerNum)) {
			if(held && target) {
				target.holding = 0
				x += target.hspeed * 2

				//escape from solid
				if(!placeFree(x, y)) {
					local escapedir = target.x <=> x
					while(!placeFree(x, y)) x += escapedir
				}

				if(getcon("up", "hold", false, target.playerNum) && held)
					vspeed = -throwV

				if(!getcon("down", "hold", false, target.playerNum)) hspeed = -throwH * (gvPlayer.x <=> x)
			}
			held = false
		}
	}

	function destructor() {
		mapDeleteSolid(icebox)
	}
}

::DeadNME <- class extends Actor {
	sprite = 0
	frame = 0
	hspeed = 0.0
	vspeed = 0.0
	angle = 0.0
	spin = 0
	flip = 0
	gravity = 0.2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		vspeed = -3.0
	}

	function run() {
		vspeed += gravity
		x += hspeed
		y += vspeed
		angle += spin
		if(y > gvMap.h + 32) deleteActor(id)
	}

	function draw() { drawSprite(sprite, frame, floor(x - camx), floor(y - camy), angle, flip, 1, 1, 1) }

	function _typeof() { return "DeadNME" }
}

//////////////////////
// SPECIFIC ENEMIES //
//////////////////////

::Deathcap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = bool(_arr)
	}

	function routine() {}
	function animation() {}

	function run() {
		base.run()

		if(active) {
			if(!moving) {
				if(gvPlayer && x > gvPlayer.x) flip = true
				moving = true
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(smart) if(placeFree(x - 6, y + 14) && !placeFree(x + 2, y + 14)) flip = false

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

						if(smart) if(placeFree(x + 6, y + 14) && !placeFree(x - 2, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()
			}

			if(!squish) shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(!active) return

		if(!squish) {
			if(frozen) {
				if(smart) drawSprite(sprGradcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSprite(sprDeathcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

				if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
				}
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else {
				if(smart) drawSprite(sprGradcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSprite(sprDeathcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			}
		}
		else {
			if(smart) drawSprite(sprGradcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			else drawSprite(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		}
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_element == "ice") {
			frozen = 600
			return
		}

		if(_mag <= 0)
			return

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			newActor(Flame, x, y - 1)
			die()
			popSound(sndFlame, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
			return
		}

		if("anim" in _by) {
			if(_by.inMelee && hitTest(shape, _by.shape)) {
				local c = newActor(DeadNME, x, y)
				if(smart) actor[c].sprite = sprGradcap
				else actor[c].sprite = sprDeathcap
				actor[c].vspeed = min(-fabs(_by.hspeed), -4)
				actor[c].hspeed = (_by.hspeed / 16)
				actor[c].spin = (_by.hspeed * 7)
				actor[c].angle = 180
				die()
				popSound(sndKick, 0)
				return
			}
		}

		if(!_stomp) {
			local c = newActor(DeadNME, x, y)
			if(smart) actor[c].sprite = sprGradcap
			else actor[c].sprite = sprDeathcap
			actor[c].vspeed = -4.0
			actor[c].spin = 4
			actor[c].angle = 180
			die()
			popSound(sndKick, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
		} else popSound(sndSquish, 0)

		if(_mag > 0) squish = true
		if(_mag > 0) blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		if(smart) actor[c].sprite = sprGradcap
		else actor[c].sprite = sprDeathcap
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		popSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "Deathcap" }
}

::PipeSnake <- class extends Enemy {
	ystart = 0
	timer = 30
	up = false
	flip = 1
	touchDamage = 2.0
	sharpTop = true
	damageMult = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
		stomp = 0.0
	}

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		ystart = y
		shape = Rec(x, y, 8, 12, 0)
		timer = (x * y) % 60
		flip = _arr
	}

	function physics() {}

	function run() {
		base.run()

		if(up && y > ystart - 32 && !frozen) y -= 2
		if(!up && y < ystart && !frozen) y += 2

		if(!frozen) timer--
		if(timer <= 0) {
			up = !up
			timer = 60
		}

		shape.setPos(x, y + 16)
		if(frozen) {
			//Create ice block
			local canice = true
			if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
			if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
			if(icebox == -1 && canice) {
				if(health > 0) icebox = mapNewSolid(shape)
			}


		}
		else {
			//Delete ice block
			if(icebox != -1) {
				newActor(IceChunks, x, y)
				mapDeleteSolid(icebox)
				icebox = -1
			}
		}
	}

	function draw() {
		if(flip == 1) drawSprite(sprSnake, (frozen ? 1 : getFrames() / 8), floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
		if(flip == -1) drawSprite(sprSnake, (frozen ? 1 : getFrames() / 8), floor(x - camx), floor(y - camy) + 32, 0, 2, 1, 1, 1)

		if(frozen > 0) {
			if(flip == 1) drawSprite(sprSnake, 0, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
			if(flip == -1) drawSprite(sprSnake, 0, floor(x - camx), floor(y - camy) + 32, 0, 2, 1, 1, 1)

			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapTall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy + 16)
				else drawSprite(sprIceTrapTall, 0, x - camx, y - camy + 16)
			}
			else drawSprite(sprIceTrapTall, 0, x - camx, y - camy + 16)
		}

		if(debug) {
			setDrawColor(0x008000ff)
			shape.draw()
			drawText(font, x - camx, y - camy, frozen.tostring())
		}
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_mag == 0) return
		if(_stomp) return

		if(_by != 0 && hitTest(shape, _by.shape)) {
			local didhurt = false
			if("anim" in _by) {
				if(_by.anim == "slide") didhurt = true
				if(_by.anim == "stomp") didhurt = true
			}
			if(!didhurt) hurtPlayer(_by)
		}

		if(_element == "fire") hurtFire()
		else if(_element == "ice") hurtIce()
		else if(_blast) hurtBlast()
		else {
			newActor(Poof, x, ystart - 8)
			newActor(Poof, x, ystart + 8)
			die()
			popSound(sndKick, 0)

			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
			}
		}
	}

	function hurtBlast() { hurtInvinc() }

	function hurtInvinc() {
		newActor(Poof, x, ystart - 6)
		newActor(Poof, x, ystart + 8)
		die()
		popSound(sndFlame, 0)

		if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
			}
	}

	function hurtFire() {
		newActor(Flame, x, ystart - 6)
		newActor(Flame, x, ystart + 8)
		die()
		popSound(sndFlame, 0)

		if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y) // Not resetting icebox here to avoid the ice box solid from remaining in place indefinitely.
			}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "Snake" }
}

::OrangeBounce <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		vspeed = -3.0
	}

	function physics() {}

	function run() {
		base.run()

		if(active) {
			local target = findPlayer()
			if(target && hspeed == 0) {
				if(x > target.x) hspeed = -0.5
				else hspeed = 0.5
			}

			if(!placeFree(x, y + 1)) vspeed = -3.0
			if(!placeFree(x + 2, y - 2) && !placeFree(x + 2, y)) hspeed = -fabs(hspeed)
			if(!placeFree(x - 2, y - 2) && !placeFree(x - 2, y)) hspeed = fabs(hspeed)
			vspeed += 0.1

			if(hspeed > 0) flip = 0
			else flip = 1

			if(!frozen) {
				if(placeFree(x + hspeed, y)) x += hspeed
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2
			}

			shape.setPos(x, y)

			//Draw
			if(frozen) {
				//Create ice block
				local canice = true
				if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
				if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
				if(icebox == -1 && canice) {
					if(health > 0) icebox = mapNewSolid(shape)
				}


			}
			else {
				//Delete ice block
				if(icebox != -1) {
					newActor(IceChunks, x, y)
					mapDeleteSolid(icebox)
					icebox = -1
					if(gvPlayer) if(x > gvPlayer.x) flip = true
					else flip = false
				}
			}
		}

		if(x < 0) hspeed = fabs(hspeed)
		if(x > gvMap.w) hspeed = -fabs(hspeed)
	}

	function draw() {
		drawSprite(sprOrangeBounce, getFrames() / 8, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

		if(frozen) {
			drawSprite(sprOrangeBounce, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if((_stomp || _element == "normal") && _mag > 0) {
			newActor(Poof, x, y)
			die()
			popSound(sndSquish, 0)

			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
			}
			return
		}
		if(_element == "ice") {
			hurtIce()
			return
		}

		if(gvPlayer && hitTest(shape, gvPlayer.shape) && _stomp) {
			newActor(Poof, x, y)
			if(_mag > 0) die()
			popSound(sndSquish, 0)
			if(getcon("jump", "hold", true, 1)) gvPlayer.vspeed = -8
			else gvPlayer.vspeed = -4
		}

		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape) && _stomp) {
			newActor(Poof, x, y)
			if(_mag > 0) die()
			popSound(sndSquish, 0)
			if(getcon("jump", "hold", true, 2)) gvPlayer2.vspeed = -8
			else gvPlayer2.vspeed = -4
		}

		if(_element == "fire") hurtFire()
		if(_element == "ice") hurtIce()
		if(_blast) hurtBlast()

		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
	}

	hurtFire = Deathcap.hurtFire

	function hurtIce() { frozen = 600 }

	function hurtBlast() { hurtInvinc() }

	function hurtInvinc() {
		newActor(Poof, x, y)
		die()
		popSound(sndFlame, 0)

		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
	}

	function _typeof() { return "OrangeBounce" }
}

::CarlBoom <- class extends Enemy {
	burnt = false
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	hspeed = 0.0
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0, 0, 1)
		if(gvPlayer) if(x > gvPlayer.x) flip = true
	}

	function run() {
		base.run()

		if(active) {
			if(placeFree(x, y + 1) && !held) vspeed += 0.1
			if(placeFree(x, y + vspeed)) y += vspeed
			else vspeed /= 2

			if(!squish) {
				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(placeFree(x - 6, y + 14) && !placeFree(x, y + 2)) flip = false

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

						if(placeFree(x + 6, y + 14) && !placeFree(x, y + 2)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				if(held) squishTime += 0.1
				else squishTime += 1.5
				frame += 0.002 * squishTime
				if(getFrames() % 20 == 0) {
					local c
					if(!flip) c = actor[newActor(FlameTiny, x - 6, y - 8)]
					else c = actor[newActor(FlameTiny, x + 6, y - 8)]
					c.vspeed = -0.1
					c.hspeed = randFloat(0.2) - 0.1
				}

				if(frozen) {
					squish = false
					squishTime = 0
				}

				//Getting carried
				holdMe()

				//Move
				if(placeFree(x + hspeed, y)) x += hspeed
				else if(placeFree(x + hspeed, y - 2)) {
					x += hspeed
					y -= 1.0
				}
				if(placeFree(x, y + 1)) friction = 0.0
				else friction = 0.1
				if(fabs(hspeed) < 0.1) hspeed = 0.0

				//Explode
				if(squishTime >= 150) {
					die()
					fireWeapon(ExplodeF2, x, y, 0, id)
					if(gvPlayer) if(gvPlayer.holding == id) gvPlayer.holding = 0
				}
			}

			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(squish) drawSprite(sprCarlBoom, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
		else if(frozen) {
			drawSprite(sprCarlBoom, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else drawSprite(sprCarlBoom, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
	}

	function hurtBlast() {
		if(squish) return
		if(frozen) frozen = 0
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		squish = true

	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(!active) return
		if(held) return
		if(_element == "ice") {
			hurtIce()
			return
		}
		else if(_element == "fire" || _blast) {
			hurtFire()
			return
		}
		else if(squish) return

		if(_element != "fire" && _blast == false) popSound(sndFizz, 0)
		if(_stomp) {
			if(_by.anim == "jumpT" || _by.anim == "fall") {
				_by.anim = "jumpU"
				_by.frame = _by.an["jumpU"][0]
			}
		}

		if(_by != 0 && ("anim" in _by) && _by.anim == "slide") {
			vspeed = -abs(_by.hspeed) / 2.0
			hspeed = _by.hspeed <=> 0
		}

		squish = true
	}

	function hurtFire() {
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		if(!burnt) {
			fireWeapon(ExplodeF2, x, y - 1, 2, id)
			die()
			popSound(sndFlame, 0)

			burnt = true
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "CarlBoom" }
}

::BlueFish <- class extends Enemy {
	timer = 0
	frame = 0.0
	biting = false
	flip = 0
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 6, 0)
		hspeed = 0.5
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			if(!placeFree(x + (hspeed * 2), y)) hspeed = -hspeed
			if(!placeFree(x, y + (vspeed * 2))) vspeed = -vspeed
			flip = (hspeed < 0).tointeger()

			timer--
			if(timer <= 0) {
				timer = 240
				vspeed = -0.5 + randFloat(1)
			}
			if(!inWater(x, y)) vspeed += 0.1
			vspeed *= 0.99

			local target = null
			if(gvPlayer && gvPlayer2) {
				if(distance2(x, y, gvPlayer.x, gvPlayer.y) < distance2(x, y, gvPlayer2.x, gvPlayer2.y)) target = gvPlayer
				else target = gvPlayer2
			}
			else if(gvPlayer) target = gvPlayer
			else if(gvPlayer2) target = gvPlayer2

			if(target != null && hitTest(shape, target.shape)) biting = true
			if(frame >= 4) {
				biting = false
				frame = 0.0
			}

			if(y > gvMap.h) {
				if(vspeed > 0) vspeed = 0
				vspeed -= 0.1
			}

			if(x > gvMap.w) hspeed = -1.0
			if(x < 0) hspeed = 1.0

			if(placeFree(x + hspeed, y)) x += hspeed
			if(placeFree(x, y + vspeed)) y += vspeed
			shape.setPos(x, y)
		}
	}

	function draw() {
		if(biting) {
			drawSprite(sprBlueFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
			frame += 0.125
		}
		else drawSprite(sprBlueFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(("anim" in _by && _by.anim == "slide" && _by.stats.weapon == "earth") || (!_stomp || !_by.swimming))
			hurtFire()
	}

	function hurtFire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeadFish
		actor[c].vspeed = -0.5
		actor[c].flip = flip
		actor[c].hspeed = hspeed
		if(flip == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.02
		die()
		popSound(sndKick, 0)
		newActor(Poof, x + 8, y)
		newActor(Poof, x - 8, y)
		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function _typeof() { return "BlueFish" }
}

::RedFish <- class extends Enemy {
	timer = 0
	frame = 0.0
	biting = false
	flip = 0
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 6, 0)
		hspeed = 0.5
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			if(!placeFree(x + (hspeed * 2), y)) hspeed = -hspeed
			if(!placeFree(x, y + (vspeed * 2))) vspeed = -vspeed
			flip = (hspeed < 0).tointeger()

			timer--
			if(timer <= 0) {
				timer = 240
				vspeed = -0.5 + randFloat(1)
				if(hspeed == 0) hspeed = 1
				else hspeed *= 1 / fabs(hspeed)
			}
			if(!inWater(x, y)) vspeed += 0.1
			vspeed *= 0.99

			local target = null
			if(gvPlayer && gvPlayer2) {
				if(distance2(x, y, gvPlayer.x, gvPlayer.y) < distance2(x, y, gvPlayer2.x, gvPlayer2.y)) target = gvPlayer
				else target = gvPlayer2
			}
			else if(gvPlayer) target = gvPlayer
			else if(gvPlayer2) target = gvPlayer2

			if(target != null) {
				if(hitTest(shape, target.shape)) biting = true
				if(inDistance2(x, y, target.x, target.y, 128) && inWater(x, y)) {
					biting = true
					timer = 240

					//Chase player
					if(x < target.x && hspeed < 2) hspeed += 0.02
					if(x > target.x && hspeed > -2) hspeed -= 0.02

					if(y < target.y && vspeed < 2) vspeed += 0.02
					if(y > target.y && vspeed > -2) vspeed -= 0.02

					//Swim harder if far from the player
					if(inDistance2(x, y, target.x, target.y, 32)) {
						if(x < target.x && hspeed < 2) hspeed += 0.02
						if(x > target.x && hspeed > -2) hspeed -= 0.02

						if(y < target.y && vspeed < 2) vspeed += 0.02
						if(y > target.y && vspeed > -2) vspeed -= 0.02
					}
				}
			}


			if(frame >= 4) {
				biting = false
				frame = 0.0
			}

			if(y > gvMap.h) {
				if(vspeed > 0) vspeed = 0
				vspeed -= 0.1
			}

			if(x > gvMap.w) hspeed = -1.0
			if(x < 0) hspeed = 1.0

			if(placeFree(x + hspeed, y)) x += hspeed
			if(placeFree(x, y + vspeed)) y += vspeed
			shape.setPos(x, y)
		}
	}

	function draw() {
		if(biting) {
			drawSprite(sprRedFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
			frame += 0.125
		}
		else drawSprite(sprRedFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(("anim" in _by && _by.anim == "slide" && _by.stats.weapon == "earth") || (!_stomp || !_by.swimming))
			hurtFire()
	}

	function hurtFire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeadFish
		actor[c].vspeed = -0.5
		actor[c].flip = flip
		actor[c].hspeed = hspeed
		if(flip == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.02
		die()
		popSound(sndKick, 0)
		newActor(Poof, x + 8, y)
		newActor(Poof, x - 8, y)
		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function _typeof() { return "RedFish" }
}

::JellyFish <- class extends Enemy {
	timer = 0
	frame = 0.0
	pump = false
	fliph = 0
	flipv = 0
	touchDamage = 2.0
	element = "shock"

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 4, 0)
		hspeed = 0.5
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			if(!placeFree(x + hspeed, y)) hspeed = -hspeed
			if(!placeFree(x, y + vspeed)) vspeed = -vspeed

			if(hspeed > 0) fliph = 0
			if(hspeed < 0) fliph = 1
			if(vspeed > 0) flipv = 1
			if(vspeed < 0) flipv = 0
			if(hspeed )

			timer--
			if(timer <= 0) {
				timer = 30 + randInt(90)
				pump = true
			}

			if(pump) {
				if(frame < 3) frame += 0.1
				else frame += 0.05

				if(frame >= 4) {
					frame = 0.0
					pump = false
				}

				if(frame > 2 && frame < 3) {
					if(fliph == 0) hspeed = 1.0
					else hspeed = -1.0
					if(flipv == 0) vspeed = -1.0
					else vspeed = 1.0
				}
			}

			if(y > gvMap.h) {
				if(vspeed > 0) vspeed = 0
				vspeed -= 0.1
			}

			if(x > gvMap.w) hspeed = -1.0
			if(x < 0) hspeed = 1.0

			if(!inWater(x, y)) vspeed += 0.1
			vspeed *= 0.99
			hspeed *= 0.99

			if(placeFree(x + hspeed, y)) x += hspeed
			if(placeFree(x, y + vspeed)) y += vspeed
			shape.setPos(x, y)
		}
	}

	function draw() {
		drawSprite(sprJellyFish, frame, x - camx, y - camy, 0, fliph + (flipv * 2), 1, 1, 1)
		drawLightEx(sprLightIce, 0, x - camx, y - camy, 0, 0, 0.25, 0.25)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(("anim" in _by && _by.anim == "slide" && _by.stats.weapon == "earth") || (!_stomp || !_by.swimming))
			hurtFire()
	}

	function hurtFire() {
		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprJellyFish
		actor[c].vspeed = -0.2
		actor[c].flip = fliph + (flipv * 2)
		actor[c].hspeed = hspeed / 2
		if(fliph == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.01
		die()
		popSound(sndKick, 0)
		newActor(Poof, x, y)
	}

	function _typeof() { return "Jellyfish" }
}

::Clamor <- class extends Enemy {
	huntdir = 0
	timer = 0
	flip = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 6, 6, 0)
		if(_arr == "1") flip = 1

		if(flip == 0) huntdir = 1
		else huntdir = -1
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		local target = null
			if(gvPlayer && gvPlayer2) {
			if(distance2(x, y, gvPlayer.x, gvPlayer.y) < distance2(x, y, gvPlayer2.x, gvPlayer2.y)) target = gvPlayer
			else target = gvPlayer2
		}
		else if(gvPlayer) target = gvPlayer
		else if(gvPlayer2) target = gvPlayer2

		if(target != null) {
			if(inDistance2(x + (huntdir * 48), y - 32, target.x, target.y, 64) && timer == 0) {
				timer = 240
				newActor(ClamorPearl, x, y, null)
			}
		}

		if(timer > 0) timer--
	}

	function draw() { drawSprite(sprClamor, (timer < 30).tointeger(), x - camx, y - camy, 0, flip, 1, 1, 1) }

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if("anim" in _by) if(_by.anim == "slide" && _by.stats.weapon == "earth") hurtFire()
		if(_stomp && timer > 30) return
		if(_element == "fire") hurtFire()
		if(_element == "normal" || _blast) hurtBlast()
	}

	function hurtFire() {
		if(timer < 30) {
			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
			newActor(Poof, x, y - 1)
			die()
			popSound(sndFlame, 0)
		}
	}

	function hurtBlast() {
		newActor(Poof, x, y - 1)
		die()
	}

	function _typeof() { return "Clamor" }
}

::ClamorPearl <- class extends PhysAct {
	hspeed = 0
	vspeed = 0
	timer = 1200
	shape = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		if(!gvPlayer) {
			die()
			return
		}

		local aim = pointAngle(x, y, gvPlayer.x, gvPlayer.y)
		hspeed = lendirX(1, aim)
		vspeed = lendirY(1, aim)

		shape = Rec(x, y, 4, 4, 0)
	}

	function run() {
		x += hspeed
		y += vspeed
		shape.setPos(x, y)
		timer--

		if(timer == 0 || !placeFree(x, y)) deleteActor(id)

		if(gvPlayer && hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = 2
		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) gvPlayer2.hurt = 2

		if(!inWater(x, y)) vspeed += 0.2
	}

	function draw() { drawSprite(sprIceball, 0, x - camx, y - camy) }
}

::GreenFish <- class extends Enemy {
	timer = 120
	frame = 0.0
	biting = false
	flip = 0
	canjump = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 6, 0)
		hspeed = 1.0
		if(gvPlayer) if(x > gvPlayer.x) hspeed = -1.0
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			flip = (hspeed < 0).tointeger()

			timer--
			if(timer <= 0) {
				timer = 120
				if(vspeed > -0.5 && inWater(x, y)) vspeed = -0.5
				if(hspeed == 0) hspeed = 1
				else hspeed *= 1 / fabs(hspeed)
				canjump = true
			}
			if(!inWater(x, y)) vspeed += 0.1
			vspeed *= 0.99

			local target = null
			if(gvPlayer && gvPlayer2) {
				if(distance2(x, y, gvPlayer.x, gvPlayer.y) < distance2(x, y, gvPlayer2.x, gvPlayer2.y)) target = gvPlayer
				else target = gvPlayer2
			}
			else if(gvPlayer) target = gvPlayer
			else if(gvPlayer2) target = gvPlayer2

			if(target != null) {
				if(hitTest(shape, target.shape)) biting = true
				if(inDistance2(x, y, target.x, target.y, 256) && inWater(x, y)) {
					biting = true

					//Chase player
					if(x < target.x && hspeed < 2) hspeed += 0.02
					if(x > target.x && hspeed > -2) hspeed -= 0.02

					if(y < target.y && vspeed < 2) vspeed += 0.1
					if(y > target.y && vspeed > -4) {
						if(canjump && !target.inWater(target.x, target.y) && ((hspeed > 0 && target.x > x) || (hspeed < 0 && target.x < x))) {
							vspeed = -6
							canjump = false
						}

						vspeed -= 0.2
					}

					//Swim harder if far from the player
					if(!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)) {
						if(x < gvPlayer.x && hspeed < 2) hspeed += 0.02
						if(x > gvPlayer.x && hspeed > -2) hspeed -= 0.02

						if(y < gvPlayer.y && vspeed < 2) vspeed += 0.02
						if(y > gvPlayer.y && vspeed > -2) vspeed -= 0.02
					}
				}
			}


			if(frame >= 4) {
				biting = false
				frame = 0.0
			}

			if(y > gvMap.h) {
				if(vspeed > 0) vspeed = 0
				vspeed -= 0.1
			}

			if(x > gvMap.w) hspeed = -1.0
			if(x < 0) hspeed = 1.0


			x += hspeed
			y += vspeed

			shape.setPos(x, y)
		}
	}

	function draw() {
		if(biting) {
			drawSprite(sprGreenFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
			frame += 0.125
		}
		else drawSprite(sprGreenFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(("anim" in _by && _by.anim == "slide" && _by.stats.weapon == "earth") || (!_stomp || !_by.swimming))
			hurtFire()
	}

	function hurtFire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeadFish
		actor[c].vspeed = -0.5
		actor[c].flip = flip
		actor[c].hspeed = hspeed
		if(flip == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.02
		die()
		popSound(sndKick, 0)
		newActor(Poof, x + 8, y)
		newActor(Poof, x - 8, y)
		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function _typeof() { return "GreenFish" }
}

::Ouchin <- class extends Enemy {
	sf = 0.0
	sharpTop = true
	sharpSide = true
	touchDamage = 2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 8, 0)
		sf = randInt(8)
	}

	function run() {
		base.run()

		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) {
			if(x > gvPlayer.x) {
				if(gvPlayer.placeFree(gvPlayer.x - 1, gvPlayer.y)) gvPlayer.x--
				gvPlayer.hspeed -= 0.1
			}

			if(x < gvPlayer.x) {
				if(gvPlayer.placeFree(gvPlayer.x + 1, gvPlayer.y)) gvPlayer.x++
				gvPlayer.hspeed += 0.1
			}

			if(y > gvPlayer.y) {
				if(gvPlayer.placeFree(gvPlayer.x, gvPlayer.y - 1)) gvPlayer.y--
				gvPlayer.vspeed -= 0.1
			}

			if(y < gvPlayer.y) {
				if(gvPlayer.placeFree(gvPlayer.x, gvPlayer.y + 1)) gvPlayer.y++
				gvPlayer.vspeed += 0.1
			}
		}

		if(gvPlayer2) if(hitTest(shape, gvPlayer2.shape)) {
			if(x > gvPlayer2.x) {
				if(gvPlayer2.placeFree(gvPlayer2.x - 1, gvPlayer2.y)) gvPlayer2.x--
				gvPlayer2.hspeed -= 0.1
			}

			if(x < gvPlayer2.x) {
				if(gvPlayer2.placeFree(gvPlayer2.x + 1, gvPlayer2.y)) gvPlayer2.x++
				gvPlayer2.hspeed += 0.1
			}

			if(y > gvPlayer2.y) {
				if(gvPlayer2.placeFree(gvPlayer2.x, gvPlayer2.y - 1)) gvPlayer2.y--
				gvPlayer2.vspeed -= 0.1
			}

			if(y < gvPlayer2.y) {
				if(gvPlayer2.placeFree(gvPlayer2.x, gvPlayer2.y + 1)) gvPlayer2.y++
				gvPlayer2.vspeed += 0.1
			}
		}

		if(frozen) {
			//Create ice block
			local canice = true
			if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
			if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
			if(icebox == -1 && canice) {
				if(health > 0) icebox = mapNewSolid(shape)
			}
		}
		else {
			//Delete ice block
			if(icebox != -1) {
				newActor(IceChunks, x, y)
				mapDeleteSolid(icebox)
				icebox = -1
			}
		}

		shape.setPos(x, y)
	}

	function draw() {
		drawSprite(sprOuchin, sf + (getFrames() / 16), x - camx, y - camy)

		if(frozen) {
			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_element == "fire") hurtFire()
		if(_element == "ice") hurtIce()
	}

	function hurtFire() {}

	function hurtIce() { frozen = 600 }
}

::BadCannon <- class extends Actor {
	frame = 3.5
	timer = 240

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		mapNewSolid(Rec(x, y, 8, 8, 0))
	}

	function run() {
		base.run()

		local target = null
		if(gvPlayer && gvPlayer2) {
			if(distance2(x, y, gvPlayer.x, gvPlayer.y) < distance2(x, y, gvPlayer2.x, gvPlayer2.y)) target = gvPlayer
			else target = gvPlayer2
		}
		else if(gvPlayer) target = gvPlayer
		else if(gvPlayer2) target = gvPlayer2

		if(target != null) {
			if(x > target.x + 8 && frame > 0.5) frame -= 0.1
			if(x < target.x - 8 && frame < 4.5) frame += 0.1

			if(inDistance2(x, y, target.x, target.y, 160) && timer == 0 && (frame < 1 || frame > 4)) {
				if(frame < 1) {
					local c = actor[newActor(CannonBob, x - 4, y - 4)]
					c.hspeed = ((target.x - x) / 48)
					local d = (y - target.y) / 64
					if(d > 2) d = 2
					if(y > target.y) c.vspeed -= d
					newActor(Poof, x - 4, y - 4)
				}
				if(frame >= 4) {
					local c = actor[newActor(CannonBob, x + 4, y - 4)]
					c.hspeed = ((target.x - x) / 48)
					local d = (y - target.y) / 64
					if(d > 2) d = 2
					if(y > target.y) c.vspeed -= d
					newActor(Poof, x + 4, y - 4)
				}
				if(frame >= 1 && frame <= 4) {
					local c = actor[newActor(CannonBob, x, y - 4)]
					c.hspeed = ((target.x - x) / 48)
					local d = (y - target.y) / 64
					if(d > 2) d = 2
					if(y > target.y) c.vspeed -= d
					newActor(Poof, x, y - 4)
				}
				timer = 240
			}

			if(timer > 0) timer--
		}
	}

	function draw() { drawSprite(sprCannon, frame, x - camx, y - camy) }

	function _typeof() { return "BadCannon" }
}

::CannonBob <- class extends Enemy {
	vspeed = -4
	sprite = 0
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 6, 6, 0)

		if(_arr == null) sprite = sprCannonBob
		else sprite = _arr
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(!frozen) {
			vspeed += 0.2
			x += hspeed
			y += vspeed
			shape.setPos(x, y)

			if(y > gvMap.h) die()

			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
				icebox = -1
				hspeed = 0
				vspeed = -1.0
			}
		}
		else {
			//Create ice block
			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
				if(health > 0) icebox = mapNewSolid(shape)
			}


		}
	}

	function draw() {
		if(frozen) {
			drawSprite(sprite, 4, x - camx, y - camy, 0, int(hspeed < 0), 1, 1, 1)

			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else drawSprite(sprite, getFrames() / 4, x - camx, y - camy, 0, int(hspeed < 0), 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_blast || _element == "fire") {
			hurtBlast()
			return
		}
		else if(_element == "ice") {
			hurtIce()
			return
		}

		if(_stomp) {
			local c = newActor(DeadNME, x, y)
			actor[c].sprite = sprite
			if(gvPlayer) {
				actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
				actor[c].hspeed = (gvPlayer.hspeed / 16)
			}
			else actor[c].vspeed = -4.0
			popSound(sndKick)

			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
			}

			die()
		}
	}

	function hurtBlast() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprite
		actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
		actor[c].hspeed = (gvPlayer.hspeed / 16)
		die()
		popSound(sndKick, 0)
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}

	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "CannonBob" }
}

::Icicle <- class extends Enemy {
	timer = 30
	counting = false
	touchDamage = 2.0
	element = "ice"
	dy = -16
	nocount = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 6, 0)
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		if(dy < 0) dy++
		base.run()

		if(gvPlayer) if(abs(y - gvPlayer.y) < 128 && y < gvPlayer.y && abs(x - gvPlayer.x) < 8 && !counting) {
			counting = true
			popSound(sndIcicle, 0)
		}

		if(counting && timer > 0) timer--
		if(timer <= 0) {
			if(inWater(x, y) && vspeed < 1.0) vspeed += 0.05
			else vspeed += 0.2
		}
		if(inWater(x, y) && vspeed > 0.5) vspeed = 0.1
		y += vspeed
		shape.setPos(x, y)

		if(!placeFree(x, y)) {
			die()
			if(game.difficulty < 2) newActor(IceChunks, x, y)
			else fireWeapon(ExplodeI, x, y, 0, 0)
		}

		if(vspeed > 0) fireWeapon(AfterIce, x, y, 1, id)
	}

	function draw() { drawSprite(sprIcicle, 0, x + (timer % 2) - camx, y - 8 - camy + dy) }

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_element == "fire") {
			die()
		newActor(Poof, x, y)
			return
		}
		else if(_element != "ice") {
			base.getHurt()
			newActor(IceChunks, x, y)
		}
	}
}

::FlyAmanita <- class extends Enemy {
	range = 0
	dir = 0.5
	flip = 0
	touchDamage = 2.0

	constructor(_x, _y, _arr = 0) {
		base.constructor(_x, _y)
		if(_arr == "") range = 0
		else if(typeof _arr == "array") range = _arr[0].tointeger()
		else range = _arr.tointeger() * 16
		shape = Rec(x, y, 6, 6, 0)
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()
		if(gvPlayer && !frozen) gvPlayer.x < x ? flip = 1 : flip = 0

		if(inDistance2(x, y, x, ystart, 16)) vspeed = ((1.0 / 8.0) * distance2(x, y, x, ystart)) * dir
		else if(inDistance2(x, y, x, ystart + range, 16)) vspeed = ((1.0 / 8.0) * distance2(x, y, x, ystart + range)) * dir
		else vspeed = dir * 2.0

		vspeed += dir * 0.2
		if(range == 0) vspeed = 0

		//Change direction
		if(range > 0) {
			if(y > ystart + range) dir = -0.5
			if(y < ystart) dir = 0.5
		}

		if(range < 0) {
			if(y > ystart) dir = -0.5
			if(y < ystart + range) dir = 0.5
		}

		if(!frozen) {
			//Delete ice block
			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
				icebox = -1
			}

			y += vspeed
		} else {
			//Create ice block
			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
				if(health > 0) icebox = mapNewSolid(shape)
			}
		}

		shape.setPos(x, y)
	}

	function draw() {
		if(frozen) {
			drawSprite(sprFlyAmanita, 0, x - camx, y - camy, 0, flip, 1, 1, 1)
			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else drawSprite(sprFlyAmanita, getFrames() / 4, x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_element == "fire") {
			hurtFire()
			return
		}
		else if(_element == "ice") {
			hurtIce()
			return
		}

		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}

		local c = newActor(DeadNME, x, y)

		if(!_stomp) {
			actor[c].sprite = sprFlyAmanita
			actor[c].vspeed = -4.0
			actor[c].spin = 6
			actor[c].angle = 180
			die()
			popSound(sndKick)
		}

		if(_by != 0 && hitTest(shape, _by.shape)) {
			actor[c].sprite = sprFlyAmanita
			actor[c].vspeed = -abs(_by.hspeed * 1.1)
			actor[c].hspeed = (_by.hspeed / 16)
			actor[c].spin = (_by.hspeed * 6)
			actor[c].angle = 180
			die()
			popSound(sndKick)

			if("playerNum" in _by && getcon("jump", "hold", false, _by.playerNum)) {
				_by.vspeed = -8
				popSound(sndSquish, 0)
			}
			else {
				_by.vspeed = -4
				popSound(sndSquish, 0)
			}

			if("playerNum" in _by && getcon("jump", "hold", false, _by.playerNum)) _by.vspeed = -5
			else _by.vspeed = -2
			if(_by.anim == "jumpT" || _by.anim == "fall") {
				_by.anim = "jumpU"
				_by.frame = _by.an["jumpU"][0]
			}
		}
	}

	hurtFire = Deathcap.hurtFire

	function hurtIce() { frozen = 600 }
}

::Jumpy <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	jump = -4.0
	touchDamage = 3.0
	sharpTop = true
	sharpSide = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0, 0, 2)

		if(_arr != null && _arr != "") jump = abs(_arr.tofloat()) * -1.0
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			if(gvPlayer && !frozen) {
				if(x > gvPlayer.x) flip = 1
				else flip = 0
			}

			if(!placeFree(x, y + 1)) vspeed = jump
			if(!placeFree(x + 0, y - 2) && !placeFree(x + 2, y)) hspeed = 0
			if(!placeFree(x - 0, y - 2) && !placeFree(x - 2, y)) hspeed = 0
			vspeed += 0.15

			if(!frozen) {
				if(placeFree(x + hspeed, y)) x += hspeed
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2
			}

			shape.setPos(x, y)

			if(frozen) {
				//Create ice block
				local canice = true
				if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
				if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
				if(icebox == -1 && canice) {
					if(health > 0) icebox = mapNewSolid(shape)
				}
			}
			else {
				//Delete ice block
				if(icebox != -1) {
					newActor(IceChunks, x, y)
					mapDeleteSolid(icebox)
					icebox = -1
					if(gvPlayer) if(x > gvPlayer.x) flip = true
					else flip = false
				}
			}
		}

		if(x < 0) hspeed = 0.0
		if(x > gvMap.w) hspeed = -0.0
	}

	function draw() {
		if(frozen) {
			drawSprite(sprJumpy, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else drawSprite(sprJumpy, (0 <=> round(vspeed / 2.0)) + 1, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_element == "fire") {
			hurtFire()
			return
		}
		else if(_element == "ice") {
			hurtIce()
			return
		}
		else base.getHurt(_by, _mag, _element, _cut, _blast)
	}

	function hurtBlast() {
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		newActor(Poof, x, y - 1)
		die()
		popSound(sndFlame, 0)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)
	}

	function hurtIce() { frozen = 600 }

	function die() {
		popSound(sndKick, 0)
		newActor(Poof, x, y)
		base.die()
	}
}

::Haywire <- class extends Enemy {
	burnt = false
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	chasing = false
	mspeed = 1.0
	hspeed = 0.0
	touchDamage = 2.0
	anAgro = [4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 5, 5, 5, 5, 7, 7, 8, 9, 8, 9, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11, 10, 11]

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0, 0, 1)
		if(gvPlayer) if(x > gvPlayer.x) flip = true
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			if(placeFree(x, y + 1)) vspeed += 0.2
			if(placeFree(x, y + vspeed)) y += vspeed
			else vspeed /= 2
			if(!squish || chasing) {

				if(chasing) mspeed = fabs(hspeed)
				else mspeed = 0.75

				if(chasing) squishTime++
				if(squishTime >= 200 && chasing) {
					die()
					fireWeapon(ExplodeF2, x, y - 1, 0, id)
				}

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - mspeed, y)) x -= mspeed
						else if(placeFree(x - (mspeed * 2), y - (mspeed * 2))) {
							x -= mspeed
							y -= 1.0
						} else if(placeFree(x - mspeed, y - (mspeed * 2))) {
							x -= mspeed
							y -= 1.0
						} else flip = false

						if(placeFree(x - 8, y + 14) && !placeFree(x, y + 2)) {
							if(!chasing) flip = false
							else vspeed = -4
						}

						if(x <= 0) flip = false
						if(hspeed > 0) flip = false
					}
					else {
						if(placeFree(x + mspeed, y)) x += mspeed
						else if(placeFree(x + mspeed, y - mspeed)) {
							x += mspeed
							y -= 1.0
						} else if(placeFree(x + (mspeed * 2), y - (mspeed * 2))) {
							x += mspeed
							y -= 1.0
						} else flip = true

						if(placeFree(x + 8, y + 14) && !placeFree(x, y + 2)) {
							if(!chasing) flip = true
							else vspeed = -4
						}

						if(x >= gvMap.w) flip = true
						if(hspeed < 0) flip = true
					}

					local target = findPlayer()
					if(target != null) if(inDistance2(x, y, target.x, target.y, 8 + (16 * game.difficulty))) squish = true
				}

				local target = findPlayer()
				if(target != null && chasing) {
					if(x < target.x - 8) if(hspeed < (2.5 + ((2.0 / 200.0) * squishTime))) {
						hspeed += 0.1
						if(hspeed < 0) hspeed += 0.05
					}
					if(x > target.x + 8) if(hspeed > -(2.5 + ((2.0 / 200.0) * squishTime))) {
						hspeed -= 0.1
						if(hspeed > 0) hspeed -= 0.05
					}

					if(!placeFree(x, y + 1) && y > target.y + 16) vspeed = -5.0
				}
				else hspeed = 0.0

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}

					//Draw
					if(chasing) {
						if(getFrames() % 8 == 0) {
							local c
							if(!flip) c = actor[newActor(FlameTiny, x - 6, y - 8)]
							else c = actor[newActor(FlameTiny, x + 6, y - 8)]
							c.vspeed = -0.1
							c.hspeed = randFloat(0.2) - 0.1
						}
					}
				}
			}
			else {
				squishTime += 1.0
				frame += 0.25
				if(squishTime >= 180 - (game.difficulty * 30) && !chasing) {
					chasing = true
					squishTime = 0
					popSound(sndFizz, 0)
				}
				if(squishTime >= 300 && chasing) {
					die()
					fireWeapon(ExplodeF2, x, y, 0, id)
				}

				if(frozen) {
					squish = false
					squishTime = 0
					chasing = false
				}
			}

			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(frozen) {
			drawSprite(sprHaywire, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else if(chasing) drawSprite(sprHaywire, wrap(getFrames() / 4, 12, 15), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
		else if(squish && !chasing) drawSprite(sprHaywire, anAgro[wrap(frame, 0, anAgro.len() - 1)], x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
		else if(squish) drawSprite(sprHaywire, wrap(frame, 12, 15), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
		else drawSprite(sprHaywire, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
	}

	function hurtBlast() {
		if(squish) return
		if(frozen) frozen = 0
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
			frozen = 0
			icebox = -1
		}
		squish = true
	}

	function hurtPlayer(target) {
		if(blinking || squish && !chasing) return
		target.hurt = touchDamage * target.damageMult[element]
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_element == "fire") {
			hurtFire()
			return
		}
		else if(_element == "ice") {
			chasing = false
			squish = false
			squishTime = 0.0
			hurtIce()
			return
		}
		else if(_blast) {
			hurtBlast()
			return
		}
		if(frozen > 0) return
		if(squish) return

		if(!_stomp) vspeed = -2.0

		squish = true
	}

	function hurtFire() {
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		if(!burnt) {
			fireWeapon(ExplodeF2, x, y - 1, 0, id)
			die()
			popSound(sndFlame, 0)

			burnt = true
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "Haywire" }
}

::Sawblade <- class extends PathCrawler {
	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		base.run()
		//drawText(font, x - camx + 16, y - camy, dir.tostring())
		shape.setPos(x, y)
		if(gvPlayer && hitTest(shape, gvPlayer.shape)) gvPlayer.getHurt(2 + game.difficulty, "normal", true, false)
		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) gvPlayer2.getHurt(2 + game.difficulty, "normal", true, false)
	}

	function draw() {
		drawSprite(sprSawblade, getFrames() / 2, x - camx, y - camy)
		drawLightEx(sprLightIce, 0, x - camx, y - camy, 0, 0, 0.125, 0.125)
	}
}

::Livewire <- class extends Enemy {
	burnt = false
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	touchDamage = 2.0
	element = "shock"

	damageMult = {
		normal = 1.0
		fire = 0.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 0.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
		stomp = 1.0
		star = 10.0
	}

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0, 0, 1)
		if(gvPlayer) if(x > gvPlayer.x) flip = true
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.5
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(placeFree(x - 6, y + 14)) flip = false

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

						if(placeFree(x + 6, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 3
				frame += 0.01 * squishTime
				if(squishTime >= 180) {
					die()
					fireWeapon(ExplodeT2, x, y, 0, id)
				}
				drawSprite(sprLivewire, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)


				if(frozen) {
					squish = false
					squishTime = 0
				}
			}

			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(squish) drawSprite(sprLivewire, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
		else if(frozen) {
			drawSprite(sprLivewire, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else drawSprite(sprLivewire, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
	}

	function hurtBlast() {
		if(squish) return
		if(frozen) frozen = 0
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		squish = true
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_element == "ice") {
			hurtIce()
			return
		}

		if(_blast) {
			hurtBlast()
			return
		}

		if(_element == "fire")
			return

		popSound(sndFizz, 0)
		if(_stomp) {
			if(getcon("jump", "hold")) gvPlayer.vspeed = -8
			else gvPlayer.vspeed = -4
			if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
				gvPlayer.anim = gvPlayer.anJumpU
				gvPlayer.frame = gvPlayer.anJumpU[0]
			}
		}

		squish = true
			local c
			if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		if(burnt) {
			burnt = true
		}
	}

	function hurtIce() { frozen = 120 }
}

::Blazeborn <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false
	element = "fire"
	touchDamage = 2.0
	sharpTop = true
	sharpSide = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = bool(_arr)
	}

	function physics() {}
	function animation() {}
	function routine() {}

	function run() {
		base.run()

		if(active) {
			if(!moving) if(gvPlayer) if(x > gvPlayer.x) {
				flip = true
				moving = true
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.2
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 2.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(smart) if(placeFree(x - 6, y + 14)) flip = false

						if(x <= 0) flip = false
					}
					else {
						if(placeFree(x + 1, y)) x += 2.0
						else if(placeFree(x + 1, y - 1)) {
							x += 1.0
							y -= 1.0
						} else if(placeFree(x + 2, y - 2)) {
							x += 1.0
							y -= 1.0
						} else flip = true

						if(smart) if(placeFree(x + 6, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					newActor(Flame, x, y - 1)
					die()
					popSound(sndFlame, 0)
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1)
				if(smart) drawSprite(sprIvyRed, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSprite(sprIvyGreen, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			}


			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(frozen) {
			drawSprite(sprBlazeborn, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else drawSprite(sprBlazeborn, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

		drawLightEx(sprLightFire, 0, x - camx, y - camy, randInt(360), 0, 0.5 + sin(getFrames().tofloat() / 2.5) * 0.05, 0.5 + sin(getFrames().tofloat() / 2.5) * 0.05)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_element == "ice") {
			hurtIce()
			return
		}
		
		if(_element == "fire") {
			hurtFire()
			return
		}
		
		if(_mag > 0)
			hurtBlast()
	}

	function hurtBlast() {
		newActor(Poof, x, y)
		die()
		popSound(sndFlame, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		die()
		fireWeapon(ExplodeF2, x , y, 2, id)
		newActor(Flame, x, y - 1)
	}

	function hurtIce() {
		newActor(Poof, x, y)
		die()
	}

	function _typeof() { return "Blazeborn" }
}

::Wildcap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false
	touchDamage = 4.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = bool(_arr)
	}

	function routine() {}
	function animation() {}

	function run() {
		base.run()

		if(active) {
			if(!moving) if(gvPlayer) if(x > gvPlayer.x) {
				flip = true
				moving = true
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(smart) if(placeFree(x - 6, y + 14)) flip = false

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

						if(smart) if(placeFree(x + 6, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()
			}

			if(!squish) shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(frozen) {
			drawSprite(sprWildcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else if(squish) drawSprite(sprWildcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		else drawSprite(sprWildcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			newActor(Flame, x, y - 1)
			die()
			popSound(sndFlame, 0)

			if(randInt(30) == 0) {
				local a = actor[newActor(MuffinRed, x, y)]
				a.vspeed = -2
			}
			return
		}

		if(_element == "ice") {
			frozen = 600
			return
		}

		if("anim" in _by) {
			if(_by.anim == "slide" && hitTest(shape, _by.shape)) {
				_by.hurt = 1
				local c = newActor(DeadNME, x, y)
				if(smart) actor[c].sprite = sprWildcap
				else actor[c].sprite = sprWildcap
				actor[c].vspeed = min(-fabs(_by.hspeed), -4)
				actor[c].hspeed = (_by.hspeed / 16)
				actor[c].spin = (_by.hspeed * 7)
				actor[c].angle = 180
				die()
				popSound(sndKick, 0)
				return
			}
		}

		if(!_stomp) {
			local c = newActor(DeadNME, x, y)
			if(smart) actor[c].sprite = sprWildcap
			else actor[c].sprite = sprWildcap
			actor[c].vspeed = -4.0
			actor[c].spin = 4
			actor[c].angle = 180
			die()
			popSound(sndKick, 0)

			if(randInt(30) == 0) {
				local a = actor[newActor(MuffinRed, x, y)]
				a.vspeed = -2
			}
		} else popSound(sndSquish, 0)

		if(_mag > 0) squish = true
		if(_mag > 0) blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		if(smart) actor[c].sprite = sprWildcap
		else actor[c].sprite = sprWildcap
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		popSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)

		if(randInt(30) == 0) {
			local a = actor[newActor(MuffinRed, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "Wildcap" }
}

::Tallcap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 14, 0, 0, -6)

		smart = bool(_arr)
	}

	function routine() {}
	function animation() {}

	function run() {
		base.run()

		if(active) {
			if(!moving) if(gvPlayer) if(x > gvPlayer.x) {
				flip = true
				moving = true
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(smart) if(placeFree(x - 6, y + 14)) flip = false

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

						if(smart) if(placeFree(x + 6, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
		}
	}

	function draw() {
		if(frozen) {
			if(smart) drawSprite(sprSmartTallCap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			else drawSprite(sprTallCap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapTall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 7)
				else drawSprite(sprIceTrapTall, 0, x - camx, y - camy - 7)
			}
			else drawSprite(sprIceTrapTall, 0, x - camx, y - camy - 7)
		}
		else if(smart) drawSprite(sprSmartTallCap, getFrames() / 8, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		else drawSprite(sprTallCap, getFrames() / 8, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

		if(!squish) shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_element == "ice") {
			frozen = 600
			return
		}

		die()

		if(_mag > 0) squish = true
		if(_mag > 0) blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		if(smart) actor[c].sprite = sprSmartTallCap
		else actor[c].sprite = sprTallCap
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		popSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 600 }

	function die() {
		mapDeleteSolid(icebox)
		if(frozen) newActor(IceChunks, x, y)
		frozen = 0

		deleteActor(id)
		local c = actor[newActor(Deathcap, x, y - 14)]
		c.smart = smart
		c.nocount = nocount
		c.blinking = 10
		c.vspeed = -1.0
		newActor(Poof, x, y)
		popSound(sndSquish, 0)
	}

	function _typeof() { return "Tallcap" }
}

::Ivy <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)
		if(typeof _arr == "array" && _arr.len() > 0)
			smart = bool(_arr[0])
		else if(_arr == null || ("len" in _arr && _arr.len() == 0))
			smart = bool(_arr)
		else
			smart = false
	}

	function routine() {}
	function animation() {}

	function run() {
		base.run()

		if(active) {
			if(!moving) {
				if(gvPlayer && x > gvPlayer.x) flip = true
				moving = true
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(vspeed > 0.2) vspeed = 0.2
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(smart) if(placeFree(x - 6, y + 14) && !placeFree(x, y + 2)) flip = false

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

						if(smart) if(placeFree(x + 6, y + 14) && !placeFree(x, y + 2)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()
			}

			if(!squish) shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function draw() {
		if(!active) return

		if(!squish) {
			if(frozen) {
				if(smart) drawSprite(sprIvyRed, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSprite(sprIvyGreen, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

				if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
				}
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else {
				if(smart) {
				if(placeFree(x, y + 2)) drawSprite(sprIvyRed, wrap(getFrames() / 8, 4, 7), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSprite(sprIvyRed, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				}
				else{
				if(placeFree(x, y + 2)) drawSprite(sprIvyGreen, wrap(getFrames() / 8, 4, 7), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSprite(sprIvyGreen, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				}

			}
		}
		else {
		if(smart) drawSprite(sprIvyRed, floor(9.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		else drawSprite(sprIvyGreen, floor(9.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		}
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_element == "ice") {
			frozen = 600
			return
		}

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			newActor(Flame, x, y - 1)
			die()
			popSound(sndFlame, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
			return
		}

		if("anim" in _by) {
			if(_by.anim == "slide" && hitTest(shape, _by.shape)) {
				local c = newActor(DeadNME, x, y)
				if(smart) actor[c].sprite = sprIvyRed
				else actor[c].sprite = sprIvyGreen
				actor[c].vspeed = min(-fabs(_by.hspeed), -4)
				actor[c].hspeed = (_by.hspeed / 16)
				actor[c].spin = (_by.hspeed * 7)
				actor[c].angle = 180
				actor[c].frame = 8
				die()
				popSound(sndKick, 0)
				return
			}
		}

		if(!_stomp && _mag > 0) {
			local c = newActor(DeadNME, x, y)
			if(smart) actor[c].sprite = sprIvyRed
			else actor[c].sprite = sprIvyGreen
			actor[c].vspeed = -4.0
			actor[c].spin = 4
			actor[c].angle = 180
			actor[c].frame = 8
			die()
			popSound(sndKick, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
		} else popSound(sndSquish, 0)

		if(_mag > 0) squish = true
		if(_mag > 0) blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		if(smart) actor[c].sprite = sprIvyRed
		else actor[c].sprite = sprIvyGreen
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		actor[c].frame = 8
		die()
		popSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "Ivy" }
}

////////////////////
// V0.2.0 ENEMIES //
////////////////////

::Owl <- class extends Enemy {
	passenger = null
	pyOffset = 0
	pid = 0
	touchDamage = 2.0
	health = 4.0
	flip = 0
	canMoveH = true
	canMoveV = true
	freezeSprite = sprIceTrapLarge
	nocount = true
	blinkMax = 2
	target = null
	minFreezeTime = 300

	damageMult = {
		normal = 1.0
		fire = 2.0
		ice = 0.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
		stomp = 1.0
	}

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y)
		hspeed = 0.5

		local arg = []
		if(typeof _arr == "string") arg = split(_arr, ",")
		if(typeof _arr == "array") arg = _arr
		local narg = clone(arg)
		if(0 in narg) narg.remove(0)

		if(0 in arg) {
			if(getroottable().rawin(arg[0])) {
				if(getroottable()[arg[0]].rawin("shape")) passenger = actor[newActor(getroottable()[arg[0]], x, y, narg)]
				else passenger = actor[newActor(SkyDive, x, y)]
			}
			else passenger = actor[newActor(SkyDive, x, y)]
		}
		else passenger = actor[newActor(SkyDive, x, y)]

		pyOffset = passenger.shape.h
		pid = passenger.id

		shape = Rec(x, y, 8, 12, 0)
		routine = ruCarry
	}

	function run() {
		target = findPlayer()
		base.run()
		if(!active) if(checkActor(pid)) {
			passenger.x = x
			passenger.y = y + pyOffset + 12
			if(passenger.rawin("flip")) passenger.flip = flip
			passenger.vspeed = 0.0
		}

		if(frozen) {
			//Create ice block
			local canice = true
			if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
			if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
			if(icebox == -1 && canice) {
				if(health > 0) icebox = mapNewSolid(shape)
			}
		}
		else {
			//Delete ice block
			if(icebox != -1) {
				newActor(IceChunks, x, y)
				mapDeleteSolid(icebox)
				icebox = -1
				if(gvPlayer) if(x > gvPlayer.x) flip = true
				else flip = false
			}
		}
	}

	function physics() {
		local tempShape = shape
		canMoveH = !(frozen > 0)
		canMoveV = !(frozen > 0)

		//Check if owl can move
		if(!placeFree(x + hspeed, y)) canMoveH = false
		if(!placeFree(x, y + vspeed)) canMoveV = false

		if(checkActor(pid)) {
			shape = passenger.shape
			if(!placeFree(x + hspeed, y + 12 + pyOffset)) canMoveH = false
			if(!placeFree(x, y + 12 + pyOffset + vspeed)) canMoveV = false
			shape = tempShape
		}

		if(canMoveH) x += hspeed
		else hspeed = -hspeed

		if(canMoveV) y += vspeed / 2.0
		else vspeed = -vspeed / 2.0

		//Attach passenger to talons
		if(checkActor(pid)) {
			passenger.x = x
			passenger.y = y + pyOffset + 12
			if(passenger.rawin("flip")) passenger.flip = flip
			passenger.vspeed = 0.0
		}

		shape.setPos(x, y)
	}

	function animation() {
		if(frozen == 0) {
			if(hspeed > 0) flip = 0
			if(hspeed < 0) flip = 1
			if(target && !placeFree(x, y)) {
				if(x < target.x) flip = 0
				if(x > target.x) flip = 1
			}
		}
	}

	function draw() {
		if(frozen) {
			drawSpriteZ(1, sprOwlBrown, 0, x - camx, y - camy, 0, flip, 1, 1, 1)
			drawSpriteZ(1, sprIceTrapSmall, 0, x - camx, y - camy, 0, 0, 1, 1, 1)
		}
		else drawSpriteZ(1, sprOwlBrown, wrap(getFrames() / 6, 1, 4), x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function ruCarry() {
		if(target != null) {
			if(x > target.x && hspeed > -3) hspeed -= 0.05
			if(x < target.x && hspeed < 3) hspeed += 0.05
			if(y > target.y - 64 && vspeed > -1) vspeed -= 0.05
			if(y < target.y - 64 && vspeed < 1) vspeed += 0.05

			if(distance2(x, y, target.x, target.y) <= 96 && y < target.y && abs(x - target.x) < 8 && checkActor(pid)) {
				actor[pid].held = false
				pid = -1
				popSound(sndDrop)
			}
		}

		if(checkActor(pid) && "held" in actor[pid])
			actor[pid].held = true

		if(!checkActor(pid))
			routine = ruFlee
	}

	function ruFlee() {
		if(target) {
			if(x < target.x && hspeed > -3) hspeed -= 0.05
			if(x > target.x && hspeed < 3) hspeed += 0.05
			if(y < target.y && vspeed > -1) vspeed -= 0.05
			if(y > target.y && vspeed < 1) vspeed += 0.05
		}
	}

	function die() {
		base.die()
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprOwlBrown
		actor[c].vspeed = -5.0
		actor[c].spin = 30
		popSound(sndKick, 0)
		mapDeleteSolid(icebox)
	}
}

::MrIceguy <- class extends Enemy {
	element = "ice"
	slideTimer = 8
	hurtTimer = 600
	flip = 0
	damageMult = {
		normal = 1.0
		fire = 2.0
		ice = 0.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
		stomp = 0.0
	}
	health = 2.0
	touchDamage = 2.0
	friction = 0.0
	gravity = 0.15
	held = false
	target = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 8, 6, 0)
		routine = ruNormal

		if(gvPlayer) {
			hspeed = (gvPlayer.x <=> x).tofloat()
		} else hspeed = 1.0
	}

	function run() {
		target = findPlayer()
		base.run()
	}

	function physics() {
		if(placeFree(x, y + (0 <=> gravity)) && !phantom) vspeed += gravity
		if(placeFree(x, y + vspeed)) y += vspeed
		else {
			vspeed /= 2
			if(fabs(vspeed) < 0.01) vspeed = 0
			//if(fabs(vspeed) > 1) vspeed -= vspeed / fabs(vspeed)
			if(placeFree(x, y + vspeed)) y += vspeed
		}

		if(hspeed != 0) {
			if(placeFree(x + hspeed, y)) { //Try to move straight
				for(local i = 0; i < 4; i++) if(!placeFree(x, y + 4) && placeFree(x + hspeed, y + 1) && !inWater() && vspeed >= 0 && !placeFree(x + hspeed, y + 4)) {
					y += 1
				}
				x += hspeed
			} else {
				local didstep = false
				for(local i = 1; i <= max(4, abs(hspeed * 1.5)); i++){ //Try to move up hill
					if(placeFree(x + hspeed, y - i)) {
						x += hspeed
						y -= i
						if(i > 2) {
							if(hspeed > 0) hspeed -= 0.2
							if(hspeed < 0) hspeed += 0.2
						}
						didstep = true
						break
					}
				}

				//If no step was taken, slow down
				if(didstep == false && fabs(hspeed) >= 1) hspeed -= (hspeed / fabs(hspeed))
				else if(didstep == false && fabs(hspeed) < 1) hspeed = 0
			}
		}

		//Friction
		if(fabs(hspeed) > friction) {
			if(hspeed > 0) hspeed -= friction
			if(hspeed < 0) hspeed += friction
		} else hspeed = 0

		shape.setPos(x, y)
		xprev = x
		yprev = y
	}

	function animation() {
		if(hspeed > 0) flip = 0
		if(hspeed < 0) flip = 1

		if(y > gvMap.h + 32) die()
		if(health < 2) health++
	}

	function draw() {
		if(routine == ruNormal) drawSpriteZ(1, sprMrIceguy, (getFrames() / 8) % 4, x - camx, y - camy, 0, flip, 1, 1, 1.0)
		if(routine == ruSlide) drawSpriteZ(1, sprMrIceguy, 4 + (hurtTimer <= 30).tointeger(), x - camx, y - camy, 0, flip, 1, 1, 1.0)
		if(debug) shape.draw()
	}

	function ruNormal() {
		if(flip && hspeed > -1.5) hspeed -= 0.5
		else if(flip && hspeed < 1.5) hspeed += 0.5

		//Turn around
		if(!held && ((!placeFree(x + hspeed, y + 2) && !placeFree(x + hspeed, y - 4))
		|| x + hspeed < 0
		|| x + hspeed > gvMap.w
		|| placeFree(x + (8 * hspeed), y + 14) && !placeFree(x, y + 2))) {
			flip = (!flip).tointeger()
			hspeed = -hspeed
		}
		touchDamage = 2.0

		//Floating in water
		if(inWater(x, y)) {
			if(vspeed > -2) vspeed /= 2.0
			gravity = -0.1
		} else gravity = 0.1
	}

	function ruSlide() {
		if(fabs(hspeed) > 0) {
			if(getFrames() % 4 == 0) {
				if(hspeed > 0) hspeed -= 0.01
				if(hspeed < 0) hspeed += 0.01
			}

			if(slideTimer > 0) {
				slideTimer--
				touchDamage = 0.0
			}
			else touchDamage = 2.0
			hurtTimer = 600

			if(!placeFree(x, y + 1)) {
				if(placeFree(x - 2, y + 1)) hspeed -= 0.01
				if(placeFree(x + 2, y + 1)) hspeed += 0.01
			}

			local c = fireWeapon(MeleeHit, x + hspeed, y, 1, id)
			c.power = 2
		}

		if(fabs(hspeed) < 0.01) {
			hspeed = 0.0
			touchDamage = 0.0
			slideTimer = 8
			hurtTimer--
			health = 2.0
		}

		if(hurtTimer <= 0) {
			routine = ruNormal
			if(gvPlayer) {
			hspeed = (x <=> gvPlayer.x).tofloat()
			} else hspeed = 1.0
		}

		//Turn around
		if(!held && ((!placeFree(x + hspeed, y) && !placeFree(x + hspeed, y - 4))
		|| x + hspeed < 0
		|| x + hspeed > gvMap.w)) {
			flip = (!flip).tointeger()
			fireWeapon(StompPoof, x + (10 * (hspeed <=> 0)), y, 0, id)
			hspeed = -hspeed
			if(!held && isOnScreen()) popSound(sndIceblock)
		}

		//Getting carried
		holdMe()

		if(held) {
			blinking = 10
			slideTimer = 10
			vspeed = 0.0
			hurtTimer = 600
		}

		//Floating in water
		if(inWater(x, y)) {
			if(vspeed > -2) vspeed /= 2.0
			hspeed /= 1.01
			gravity = -0.1
		} else gravity = 0.1
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(blinking > 0) return
		base.getHurt(_by, _mag, _element, _cut, _blast, _stomp)

		if(routine == ruSlide) {
			if(hspeed != 0) hspeed = 0.0
			else if(gvPlayer) hspeed = (max(4.0, fabs(gvPlayer.hspeed * 1.5))) * (x <=> gvPlayer.x)
			popSound(sndKick)
		}
		else {
			hspeed = 0.0
			hurtTimer = 600
			routine = ruSlide
			popSound(sndSquish)
			if(!_stomp) vspeed = -2.0
		}
	}

	function hurtPlayer(pt) {
		if(held) return
		if(slideTimer > 0 && hspeed != 0 && routine == ruSlide) return

		if(routine == ruSlide && pt.vspeed >= 0) {
			if(hspeed == 0 || slideTimer > 0) {
				if(hspeed != 0) hspeed = 0.0
				else if(pt) hspeed = (max(4.0, fabs(pt.hspeed * 1.5))) * (x <=> pt.x)
				slideTimer = 10
				popSound(sndKick)
				return
			}
		}

		if(slideTimer <= 0 || routine == ruNormal) base.hurtPlayer(target)
	}

	function die() {
		base.die()
		newActor(IceChunks, x, y)
	}

	function _typeof() { return "MrIceguy" }
}

::SpikeCap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = true
	moving = false
	getupTime = 2.0
	touchDamage = 2.0
	sharpTop = true
	sharpSide = true

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = bool(_arr)
	}

	function routine() {}
	function animation() {}

	function run() {
		base.run()

		if(active) {
			if(!moving) {
				local target = findPlayer()

				if(target != null) if(inDistance2(x, y, target.x, target.y, 64)) {
					flip = x > target.x
					moving = true
				}
			}

			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) die()

				if(!frozen && moving && getupTime == 0) {
					if(flip) {
						if(placeFree(x - 1, y)) x -= 1.0
						else if(placeFree(x - 2, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else if(placeFree(x - 1, y - 2)) {
							x -= 1.0
							y -= 1.0
						} else flip = false

						if(placeFree(x - 6, y + 14)) flip = false

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

						if(placeFree(x + 6, y + 14)) flip = true

						if(x >= gvMap.w) flip = true
					}

				}
				else if(moving && getupTime > 0) {
					getupTime -= 0.2
					if(getupTime < 0) getupTime = 0
					local target = findPlayer()
					if(target != null) flip = x > target.x
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()
			}

			if(!squish) shape.setPos(x, y)
		}
	}

	function draw() {
		if(frozen) {
			drawSprite(sprSpikeCap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else if(moving && getupTime <= 0) drawSprite(sprSpikeCap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
		else drawSprite(sprSpikeCap, 6.0 - getupTime, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)


		setDrawColor(0xff0000ff)
		if(debug) shape.draw()
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_element == "fire") {
			hurtFire()
			return
		}

		if(_element == "ice") {
			hurtIce()
			return
		}

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			newActor(Flame, x, y - 1)
			die()
			popSound(sndFlame, 0)

			local c = newActor(DeadNME, x, y)
				actor[c].sprite = sprSpikeCap
				actor[c].vspeed = -4.0
				actor[c].spin = 1
				actor[c].frame = 7
				actor[c].flip = flip.tointeger()

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
			return
		}

		if(_element == "ice") {
			frozen = 600
			return
		}

		if("anim" in _by) {
			if(_by.anim == "slide" && hitTest(shape, _by.shape)) {
				local c = newActor(DeadNME, x, y)
				actor[c].sprite = sprSpikeCap
				actor[c].vspeed = min(-fabs(_by.hspeed), -4)
				actor[c].hspeed = (_by.hspeed / 16)
				actor[c].spin = (_by.hspeed * 7)
				actor[c].angle = 180
				die()
				popSound(sndKick, 0)
				return
			}
		}

		if(!_stomp && _mag > 0) {
			local c = newActor(DeadNME, x, y)
			actor[c].sprite = sprSpikeCap
			actor[c].vspeed = -4.0
			actor[c].spin = 4
			actor[c].angle = 180
			die()
			popSound(sndKick, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
		} else popSound(sndSquish, 0)

		if(_mag > 0) squish = true
		if(_mag > 0) blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprSpikeCap
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		popSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)

		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprSpikeCap
		actor[c].vspeed = -4
		actor[c].spin = 1
		actor[c].frame = 7

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "SpikeCap" }
}

::CaptainMorel <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false
	touchDamage = 2.0
	jumpPower = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = bool(_arr)
	}

	function routine() {}
	function animation() {}

	function run() {
		base.run()

		if(active) {
			if(!moving) {
				if(gvPlayer && x > gvPlayer.x) flip = true
				moving = true
			}

			if(placeFree(x, y + 1)) vspeed += 0.1
			if(placeFree(x, y + vspeed)) y += vspeed
			else vspeed /= 2

			if(!squish) {
				if(y > gvMap.h + 8) die()

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 2, y)) x -= 2.0
						else if(placeFree(x - 4, y - 2)) {
							x -= 2.0
							y -= 2.0
						} else if(placeFree(x - 2, y - 2)) {
							x -= 2.0
							y -= 2.0
						} else flip = false

						if(placeFree(x - 6, y + 14) && !placeFree(x + 2, y + 14)) vspeed = -jumpPower

						if(x <= 0) flip = false
					}
					else {
						if(placeFree(x + 2, y)) x += 2.0
						else if(placeFree(x + 2, y - 1)) {
							x += 2.0
							y -= 2.0
						} else if(placeFree(x + 4, y - 2)) {
							x += 2.0
							y -= 2.0
						} else flip = true

						if(placeFree(x + 6, y + 14) && !placeFree(x - 2, y + 14)) vspeed = -jumpPower

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					local canice = true
					if(gvPlayer && hitTest(shape, gvPlayer.shape)) canice = false
					if(gvPlayer2 && hitTest(shape, gvPlayer2.shape)) canice = false
					if(icebox == -1 && canice) {
						if(health > 0) icebox = mapNewSolid(shape)
					}
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						newActor(IceChunks, x, y)
						mapDeleteSolid(icebox)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()

			}

			if(!squish) shape.setPos(x, y)
		}
	}

	function draw() {
		if(frozen) {
			drawSprite(sprCaptainMorel, 0 + (flip.tointeger() * 9), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen <= 120) {
			if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else if(squish) drawSprite(sprCaptainMorel, floor(7.8 + squishTime) + (flip.tointeger() * 9), floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
		else if(placeFree(x, y + 2)) drawSprite(sprCaptainMorel, (0 <=> round(vspeed / 2.0)) + 5 + (flip.tointeger() * 9), floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
		else drawSprite(sprCaptainMorel, wrap(getFrames() / 8, 0, 3) + (flip.tointeger() * 9), floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)

		setDrawColor(0xff0000ff)
		if(debug) shape.draw()
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return

		if(_element == "ice") {
			frozen = 600
			return
		}

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			newActor(Flame, x, y - 1)
			die()
			popSound(sndFlame, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
			return
		}

		if("anim" in _by) {
			if(_by.anim == "slide" && hitTest(shape, _by.shape)) {
				local c = newActor(DeadNME, x, y)
				actor[c].sprite = sprCaptainMorel
				actor[c].vspeed = min(-fabs(_by.hspeed), -4)
				actor[c].hspeed = (_by.hspeed / 16)
				actor[c].spin = (_by.hspeed * 7)
				actor[c].angle = 180
				die()
				popSound(sndKick, 0)
				return
			}
		}

		if(!_stomp && _mag > 0) {
			local c = newActor(DeadNME, x, y)
			actor[c].sprite = sprCaptainMorel
			actor[c].vspeed = -4.0
			actor[c].spin = 4
			actor[c].angle = 180
			die()
			popSound(sndKick, 0)

			if(randInt(20) == 0) {
				local a = actor[newActor(MuffinBlue, x, y)]
				a.vspeed = -2
			}
		} else popSound(sndSquish, 0)

		if(_mag > 0) squish = true
		if(_mag > 0) blinking = 120
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprCaptainMorel
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		popSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		popSound(sndFlame, 0)

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "CaptainMorel" }
}

::Crusher <- class extends Enemy {
	damageMult = {
		normal = 0.0
		fire = 0.0
		ice = 0.0
		earth = 0.0
		air = 0.0
		toxic = 0.0
		shock = 0.0
		water = 0.0
		light = 0.0
		dark = 0.0
		cut = 0.0
		blast = 0.0
		stomp = 0.0
		star = 0.0
	}
	platform = null
	gravity = 0
	scanShape = null
	waiting = 0
	canFall = true
	sharpSide = true
	touchDamage = 2
	nocount = true
	sprite = 0
	blinkMax = 60

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		platform = actor[newActor(MoPlat, x, y, [[[0, 0], [0, 0]], 0, 2, 0])]
		if(_arr != null && getroottable().rawin(_arr)) sprite = getroottable()[_arr]

		if(randInt(200) == 0) sprite = sprDukeCrusher

		local checkShape = Rec(x, y - 8, 15, 8, 0)
		shape = checkShape
		for(local i = 0; i < 1000; i++) {
			checkShape.setPos(x, y + 8 + (i * 16))
			if(!placeFree(checkShape.x, checkShape.y)) {
				scanShape = Rec(x, y + (i * 8), 24, 8 + (i * 8), 0)
				break
			}
		}
		if(scanShape == null) scanShape = Rec(x, y + (8000), 24, (8000), 0)
		shape = Rec(x, y, 15, 8, 0, 0, 8)
	}

	function run() {
		base.run()

		if(y < ystart) {
			y = ystart
			vspeed = 0
			canFall = true
		}

		//Detect the player underneath
		if(gvPlayer && hitTest(gvPlayer.shape, scanShape) && gvPlayer.y > y && canFall) {
			gravity = 0.25
			vspeed = 1.0
			canFall = false
		}

		//Landing
		if(!placeFree(x, y + 1) && waiting == 0) {
			waiting = 60
			gravity = 0
			if(vspeed > 0) {
				newActor(Poof, x - 12, y + 12, 7)
				newActor(Poof, x + 12, y + 12, 7)
				fireWeapon(ExplodeHiddenF, x, y + 12, 0, id)
			}
			vspeed = 0
		}

		if(waiting > 0) {
			waiting--
			if(waiting == 0) vspeed = -1.0
		}

		//Attach platform
		platform.y = y - 12

		//Speed limit
		if(vspeed > 16) vspeed = 16.0
		if(vspeed > 4) newActor(AfterImage, x, y, [sprite, 1, 0, 0, 0, 1, 1])
	}

	function draw() {
		if(sprite) drawSpriteZ(6, sprite, (vspeed > 0).tointeger(), x - camx, y - camy)
		else drawSpriteZ(6, sprBearyl, (vspeed > 0).tointeger(), x - camx, y - camy)
		if(debug) {
			setDrawColor(0xff0000ff)
			shape.draw()
		}
	}

	function hurtInvinc() {}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {}

	function _typeof() { return "Crusher" }
}

::Wheeler <- class extends Enemy {
	touchDamage = 2
	sharpSide = true
	sharpTop = true
	gravity = 0.2
	bladesOut = 0
	flip = 0
	mspeed = 4
	turning = 0.0
	friction = 0.0
	minFreezeTime = 600
	freezeSprite = sprIceTrapSmall
	frame = 0

	damageMult = {
		normal = 1.0
		fire = 1.0
		ice = 0.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
		stomp = 1.0
		star = 10.0
	}

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 7, 7)
	}

	function run() {
		bladesOut = (gvPlayer && inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)).tointeger() * 4
		if(gvPlayer) flip = (x > gvPlayer.x).tointeger()

		if(gvPlayer) {
			//Accelerate towards player
			if(x - 16 > gvPlayer.x && hspeed > -mspeed) {
				hspeed -= 0.2
			}
			if(x + 16 < gvPlayer.x && hspeed < mspeed) {
				hspeed += 0.2
			}

			//Turning animation trigger
			if(turning < 3 && ( flip == 1 && hspeed > 0 || flip == 0 && hspeed < 0)) turning = 4.0
		}

		if(frozen) {
			hspeed = 0
			vspeed = 0

			//Create ice block
			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
				if(health > 0) icebox = mapNewSolid(shape)
			}
		}
		else if(icebox != -1) {
			newActor(IceChunks, x, y)
			mapDeleteSolid(icebox)
			icebox = -1
		}


		//Draw
		frame = 0
		if(!frozen) frame = getFrames() / 2
		if(turning > 0) turning -= 0.25


		base.run()
		shape.setPos(x, y)
	}

	function draw() {
		if(turning > 0) drawSprite(sprWheelerHamster, 8.0 + (4.0 - turning), x - camx, y - camy, 0, flip, 1, 1, 1)
		else drawSprite(sprWheelerHamster, wrap(frame, 0, 3) + bladesOut, x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(_element == "ice") {
			frozen = 600
			return
		}
		
		base.getHurt(_by, _mag, _element, _cut, _blast, _stomp)
	}

	function physics() {
		if(placeFree(x, y + (0 <=> gravity)) && !phantom) vspeed += gravity
		if(placeFree(x, y + vspeed)) y += vspeed
		else {
			vspeed /= 2
			if(fabs(vspeed) < 0.01) vspeed = 0
			//if(fabs(vspeed) > 1) vspeed -= vspeed / fabs(vspeed)
			if(placeFree(x, y + vspeed)) y += vspeed
		}

		if(hspeed != 0) {
			if(placeFree(x + hspeed, y)) { //Try to move straight
				for(local i = 0; i < 4; i++) if(!placeFree(x, y + 4) && placeFree(x + hspeed, y + 1) && !inWater() && vspeed >= 0 && !placeFree(x + hspeed, y + 4)) {
					y += 1
				}
				x += hspeed
			} else {
				local didstep = false
				for(local i = 1; i <= max(4, abs(hspeed * 1.5)); i++){ //Try to move up hill
					if(placeFree(x + hspeed, y - i)) {
						x += hspeed
						y -= i
						if(i > 2) {
							if(hspeed > 0) hspeed -= 0.1
							if(hspeed < 0) hspeed += 0.1
						}
						didstep = true
						break
					}
				}

				//If no step was taken, slow down
				if(didstep == false && fabs(hspeed) >= 1) hspeed -= (hspeed / fabs(hspeed))
				else if(didstep == false && fabs(hspeed) < 1) hspeed = 0
			}
		}

		//Friction
		if(fabs(hspeed) > friction) {
			if(hspeed > 0) hspeed -= friction
			if(hspeed < 0) hspeed += friction
		} else hspeed = 0

		shape.setPos(x, y)
		xprev = x
		yprev = y
	}

	function die() {
		base.die()
		newActor(Poof, x, y)
		local c
		//Top Left
		c = actor[newActor(DeadNME, x, y)]
		c.sprite = sprWheelerHamster
		c.hspeed = -1.0
		c.vspeed = -3.0
		c.frame = 12
		c.gravity = 0.1
		//Top Right
		c = actor[newActor(DeadNME, x, y)]
		c.sprite = sprWheelerHamster
		c.hspeed = 1.0
		c.vspeed = -3.0
		c.frame = 13
		c.gravity = 0.1
		//Bottom Left
		c = actor[newActor(DeadNME, x, y)]
		c.sprite = sprWheelerHamster
		c.hspeed = -1.0
		c.vspeed = -1.0
		c.frame = 14
		c.gravity = 0.1
		//Bottom Right
		c = actor[newActor(DeadNME, x, y)]
		c.sprite = sprWheelerHamster
		c.hspeed = 1.0
		c.vspeed = -1.0
		c.frame = 15
		c.gravity = 0.1
	}

	function _typeof() { return "Wheeler" }
}

::SkyDive <- class extends Enemy {
	flip = 0
	onGround = false
	accel = 0.0
	mspeed = 1.5
	held = false

	function constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 6, 10)
	}

	function run() {
		base.run()

		onGround = !placeFree(x, y + 1)
		shape.setPos(x, y)
		if(onGround && vspeed > 2 || health <= 0) {
			deleteActor(id)
			fireWeapon(ExplodeF, x, y, 0, 0)
			local c = fireWeapon(FireballK, x, y - 4, 0, 0)
			c.hspeed = -2.0 - game.difficulty
			c.vspeed = -1.5
			c = fireWeapon(FireballK, x, y - 4, 0, 0)
			c.hspeed = 2.0 + game.difficulty
			c.vspeed = -1.5
		}
		if(!onGround) vspeed += 0.2
		else vspeed = 0.0

		local target = findPlayer()
		if(target) {
			if(target.x - 16 > x) {
				accel = 0.11
				flip = 0
			}
			if(target.x + 16 < x) {
				accel = -0.11
				flip = 1
			}
		}
		hspeed += accel
		if(hspeed > mspeed) hspeed = mspeed
		if(hspeed < -mspeed) hspeed = -mspeed
		if(placeFree(x + hspeed, y)) x += hspeed
		else if(placeFree(x + hspeed, y - 1)) {
			x += hspeed
			y--
		}

		if(y > gvMap.h) deleteActor(id)
	}

	function draw() {
		if(!placeFree(x, y + 4) && !held) drawSprite(sprSkyDive, wrap(getFrames() / 4, 3, 6), x - camx, y - camy, 0, flip)
		else drawSprite(sprSkyDive, min(abs(vspeed), 2), x - camx, y - camy, 0, flip)

		if(debug) {
			setDrawColor(0xff0000ff)
			drawLine(x - 8 - camx, y - camy, x + 8 - camx, y - camy)
			drawLine(x - camx, y - 8 - camy, x - camx, y + 8 - camy)
		}
	}

	function _typeof() { return "SkyDive" }
}

::Puffranah <- class extends Enemy {
	anim = "normal"
	an = {
		normal = [0, 1, 2, 3]
		inhale = [4, 5, 6, 7]
		gulp = [8, 9, 10, 11]
		full = [12, 13, 14, 15]
		burp = [11, 10, 9, 8, 7, 6, 5, 4]
	}
	eatShape = null
	swimTimer = 0
	caught = false
	struggle = 0
	target = null
	frame = 0.0
	flip = 0
	touchDamage = 1.0
	health = 4
	blinkMax = 30.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 16, 16)
		eatShape = Cir(x, y, 8)

		hspeed = 0.5
		vspeed = randFloat(1.0) - 0.5

		swimTimer = randInt(480) + 120
	}

	function run() {
		base.run()

		target = findPlayer()
		if(target == null)
			caught = false

		if(target != null && target.hidden)
			target = null

		touchDamage = (anim == "full" ? 1.0 : 0.0)

		switch(anim) {
			case "normal":
				frame += 0.1

				swimTimer--

				if(swimTimer == 0) {
					vspeed = -0.5 + randFloat(1)
					if(hspeed == 0)
						hspeed = 1
					else
						hspeed *= 1 / fabs(hspeed)
					
					swimTimer = randInt(480) + 120
				}

				if(target != null && inDistance2(x, y, target.x, target.y, 96)) {
					if(target.x > x)
						hspeed += 0.1
					if(target.x < x)
						hspeed -= 0.1
					
					if(target.y > y)
						vspeed += 0.1
					if(target.y < y)
						vspeed -= 0.1

					swimTimer = 60
				}

				if(target != null && inDistance2(x, y, target.x, target.y, 56) && fabs(y - target.y) <= 8.0) {
					frame = 0.0
					anim = "inhale"
				}

				break

			case "inhale":
				vspeed /= 2.0

				if(frame < 3)
					frame += 0.25
				else if(target != null && inDistance2(x, y, target.x, target.y, 64)
				&& ((flip == 0 && target.x > x) || (flip == 1 && target.x < x))) {
					if(getFrames() % 4 == 0) fireWeapon(DragBubble, x + randInt(16) - 8 + randInt(32) * (flip == 0 ? 2 : -2), y + randInt(16) - 8, 2, id)
				}
				else {
					frame = 4.0
					anim = "burp"
				}

				if(target != null && hitTest(eatShape, target.shape)) {
					caught = true
					struggle = 8 + (8 * game.difficulty)
					frame = 0.0
					anim = "gulp"
					target.canMove = false
				}

				break

			case "gulp":
				if(target != null && "hidden" in target)
					target.hidden = true

				if(frame < 3.0)
					frame += 0.25
				else {
					frame = 0.0
					anim = "full"
				}

				if(target == null || !inDistance2(x, y, target.x, target.y, 64)) {
					frame = 4.0
					anim = "burp"
				}

				break

			case "full":
				swimTimer--
				frame += 0.1

				if(swimTimer == 0) {
					vspeed = -0.5 + randFloat(1)
					if(hspeed == 0)
						hspeed = 1
					else
						hspeed *= 1 / fabs(hspeed)

					swimTimer = randInt(480) + 120
				}

				if(getcon("left", "press", true)
				|| getcon("right", "press", true)
				|| getcon("up", "press", true)
				|| getcon("down", "press"))
					struggle--

				if(target == null || struggle <= 0) {
					caught = false
					frame = 0.0
					anim = "burp"
					if(target != null) {
						target.hspeed = (flip == 0 ? 4.0 : -4.0)
						target.canMove = true
					}
				}

				break

			case "burp":
				if(frame < 7)
					frame += 0.25
				else {
					frame = 0.0
					anim = "normal"
				}
				hspeed /= 1.1
				
				break
		}

		frame = wrap(frame, 0, an[anim].len() - 1)

		if(!inWater(x, y))
			vspeed += 0.5

		if(placeFree(x + hspeed, y))
			x += hspeed
		else
			hspeed = -hspeed

		local mspeed = 2.0

		if(hspeed > mspeed)
			hspeed = mspeed
		if(hspeed < -mspeed)
			hspeed = -mspeed

		if(vspeed > mspeed)
			vspeed = mspeed
		if(vspeed < -mspeed)
			vspeed = -mspeed

		if(x < 0)
			hspeed = 0.5
		if(x > gvMap.w)
			hspeed = -0.5

		if(placeFree(x, y + vspeed))
			y += vspeed
		else
			vspeed = -vspeed

		if(y < 0)
			vspeed = 0.5
		if(y > gvMap.h)
			vspeed = -0.5

		if(hspeed > 0) flip = 0
		if(hspeed < 0) flip = 1

		shape.setPos(x, y)
		eatShape.setPos(x, y)

		if(target != null && caught && health > 0) {
			target.x = x
			target.y = y
			target.hspeed = 0.0
			target.vspeed = 0.0
			target.hidden = true
		}

		if(health <= 0)
			hurtFire()
	}

	function draw() {
		drawSpriteZ(4, sprPuffranah, an[anim][wrap(frame, 0, an[anim].len() - 1)], x - camx, y - camy, 0, flip, 1, 1, (blinking > 0 ? blinking / 10.0 : 1))

		if(debug) {
			drawText(font, x - camx, y + 24 - camy, anim + "\n" + frame.tostring() + "\n" + health.tostring())

			setDrawColor(0xf80000ff)
			drawCircle(x - camx, y - camy, 96, false)
			drawCircle(x - camx, y - camy, 56, false)
		}
	}

	function hurtFire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeadFish
		actor[c].vspeed = -0.5
		actor[c].flip = flip
		actor[c].hspeed = hspeed
		if(flip == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.02
		die()
		popSound(sndKick, 0)
		newActor(Poof, x + 8, y)
		newActor(Poof, x - 8, y)
		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function die() {
		base.die()
		if(target != null)
			target.canMove = true
	}

	function physics() {}
}

::Struffle <- class extends Enemy {
	anim = "stand"
	an = {
		stand = [0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 2, 0, 2]
		bounce = [4, 5, 6, 7]
		hurt = [3, 3, 3, 3]
		walk = [8, 9, 10, 11, 12, 13, 14, 15]
	}
	flip = 0
	frame = 0.0

	damageMult = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 1.0
		blast = 1.0
		stomp = 1.0
		star = 10.0
	}

	health = 4
	blinkMax = 30
	walkTimer = 10
	touchDamage = 2
	friction = 0
	gravity = 0.1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 7, 12, 0, 0, 3)
	}

	function run() {
		base.run()

		if(active) {
			switch(anim) {
				case "stand":
					frame += 0.1
					walkTimer--
					if(walkTimer <= 0) {
						anim = "walk"
						walkTimer = 600

						if(gvPlayer)
							hspeed = 1.5 * (gvPlayer.x > x ? 1 : -1)
						else
							hspeed = choose(1.5, -1.5)
					}

					break

				case "walk":
					frame += 0.2
					walkTimer--

					if(walkTimer <= 0) {
						walkTimer = 300
						anim = "stand"
						hspeed = 0
					}
					
					break

				case "bounce":
				case "hurt":
					hspeed = 0
					frame += 0.2
					if(frame >= 4) {
						frame = 0.0
						anim = "stand"
						walkTimer = 60
					}

					if(anim == "hurt") {
						if(flip == 0 && placeFree(x - 0.5, y))
							x -= 0.5
						if(flip == 1 && placeFree(x + 0.5, y))
							x += 0.5
					}

					break
			}

			frame = wrap(frame, 0, an[anim].len() - 1)

			if(hspeed > 0)
				flip = 0
			if(hspeed < 0)
				flip = 1

			if(!placeFree(x, y + 16)) {
				if(placeFree(x + 12, y + 16))
					hspeed = -hspeed
				if(placeFree(x - 12, y + 16))
					hspeed = -hspeed
			}
			if(!placeFree(x + hspeed, y - 10))
				hspeed = -hspeed
			shape.setPos(x, y)

			if(isOnScreen() && randInt(1000) == 1)
				popSound(sndPigSnort)
		}
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		flip = int(x > _by.x)
		anim = "hurt"
		frame = 0.0
		if(!_stomp) {
			base.getHurt(_by, _mag, _element, _cut, _blast, _stomp)
			frame = 0.0
			anim = "hurt"
			popSound(sndPigSqueal)
		}
		else if(_stomp && gvPlayer) {
			if(gvPlayer.anim == "stomp" || gvPlayer.anim == "statue"){
				base.getHurt(_by, 2, _element, _cut, _blast, _stomp)
				frame = 0.0
				anim = "hurt"
				popSound(sndPigSqueal)
			}
			else {
				gvPlayer.vspeed = -8.0
				frame = 0.0
				anim = "bounce"
				popSound(sndPigSnort)
				popSound(sndSpring)
			}
		}
	}

	function draw() {
		drawSprite(sprStruffle, an[anim][wrap(frame, 0, an[anim].len() - 1)], x - camx, y - camy, 0, flip, 1, 1, (blinking ? blinking / 10.0 : 1))
		
		if(debug)
			shape.draw()
	}

	function die() {
		base.die()
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprStruffle
		actor[c].vspeed = -4.0
		actor[c].flip = flip
		actor[c].frame = 3
		if(flip == 1) actor[c].spin = 0.5
		else actor[c].spin = -0.5
		actor[c].gravity = 0.2
		popSound(sndKick, 0)
		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}
}

::Crystallo <- class extends Enemy {
	mode = 0
	flip = 0
	sharpSide = true
	touchDamage = 2
	cut = true
	accel = 0.0
	walkTimer = 30
	frame = 0.0
	gravity = 0.2
	waking = false
	health = 4
	blinkMax = 30
	friction = 0.0

	anim = "stand"
	an = {
		stand = [0]
		walk = [0, 1, 2, 3]
		squish = [4, 5, 5, 5, 5]
		sleep = [6, 7, 8, 7, 8, 7, 7, 7]
		jump = [9, 10, 11]
		drop = [12, 13, 14, 15, 16, 17, 18, 17, 18, 19]
		fall = [19]
	}

	constructor(_x, _y, _arr = 0) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 10, 6, 0)
		mode = _arr
		if(mode == 2)
			anim = "sleep"
	}

	function run() {
		base.run()

		if(!active)
			return

		if(hspeed > 0)
			flip = 0
		if(hspeed < 0)
			flip = 1

		if(mode == 1 && anim != "fall") gravity = -0.1
		if(mode == 0) gravity = 0.1

		switch(anim) {
			case "stand":
			case "walk":
				if(hspeed != 0)
					anim = "walk"

				frame += 0.1
				walkTimer--

				if(gvPlayer && mode == 1 && fabs(x - gvPlayer.x) < 16 && y < gvPlayer.y && fabs(y - gvPlayer.y) < 128) {
					frame = 0.0
					anim = "drop"
				}
				break

			case "sleep":
				gravity = 0.0
				if(gvPlayer && inDistance2(gvPlayer.x, gvPlayer.y, x, y, 64))
					waking = true
				if(waking)
					frame += 0.2
				if(frame > an[anim].len() - 2) {
					vspeed = -3.0
					if(gvPlayer)
						accel = 0.1 * (gvPlayer.x <=> x)
					frame = 0.0
					anim = "jump"
					mode = 0
				}
				break

			case "jump":
				if(frame < an[anim].len() - 1)
					frame += 0.1
				if(!placeFree(x, y + 1)) {
					hspeed = 0.0
					accel = 0.0
					anim = "stand"
					walkTimer = 10
				}
				break

			case "drop":
				if(frame <= an[anim].len() - 1)
					frame += 0.3
				else
					anim = "fall"
				hspeed = 0.0
				accel = 0.0
				break

			case "fall":
				gravity = 0.1
				vspeed += gravity
				hspeed = 0.0
				frame = 0.0
				if(!placeFree(x, y + 1)) {
					hspeed = 0.0
					accel = 0.0
					anim = "squish"
					frame = 0.0
					popSound(sndCrumble)
					mode = 0
				}
				break

			case "squish":
				touchDamage = 0.0
				frame += 0.1
				hspeed = 0.0
				accel = 0.0
				if(frame >= an[anim].len() - 1)
					die()
				break
		}

		frame = wrap(frame, 0, an[anim].len() - 1)
		if(frame < 0) frame = 0

		if(fabs(hspeed) < 1.25)
			hspeed += accel
		if(fabs(hspeed) > 1.25)
			hspeed -= accel
		if(walkTimer <= 0) {
			walkTimer = 120
			if(accel < 0)
				accel = 0.05
			else
				accel = -0.05
		}

		if(!placeFree(x, y + (1 * (gravity <=> 0))) && placeFree(x + (hspeed * 4), y + (8 * (gravity <=> 0)))
		|| !placeFree(x + (hspeed * 2), y) && !placeFree(x + (hspeed * 2), y - (8 * (gravity <=> 0)))) {
			hspeed = -hspeed
			accel = -accel
			walkTimer = 240
		}

		if(placeFree(x, y - 2) && mode == 1)
			mode = 0

		if(health <= 0 && anim != "squish") {
			frame = 0.0
			anim = "squish"
			popSound(sndCrumble)
		}
	}

	function draw() {
		drawSprite(sprCrystallo, an[anim][wrap(frame, 0, an[anim].len() - 1)], x - camx, y - camy, 0, flip + (mode == 1 && anim != "squish" ? 2 : 0), 1, 1, (blinking ? blinking / 10.0 : 1))

		if(debug) {
			drawText(font, x - camx, y - camy + (mode == 1 ? 8 : -24), anim + ":" + frame + "\n" + gravity + ":" + vspeed)
		}
	}

	function getHurt(_by = 0, _mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(blinking > 0)
			return
		if(anim == "squish")
			return

		local damage = _mag * damageMult[_element]
		if(_cut) damage *= damageMult["cut"]
		if(_blast) damage *= damageMult["blast"]
		if(_stomp) damage *= damageMult["stomp"]

		health -= damage
		if(damage > 0) blinking = blinkMax

		if(health <= 0) {
			frozen = 0
			mapDeleteSolid(icebox)
			frame = 0.0
			anim = "squish"
			return
			popSound(sndCrumble)
		}
		if(_element == "ice") frozen = minFreezeTime + (freezeTime * damageMult["ice"])
		if(_element == "fire") {
			newActor(Flame, x, y)
			popSound(sndFlame, 0)
		}
	}

	function _typeof() { return "Crystallo" }
}