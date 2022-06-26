::Enemy <- class extends PhysAct {
	health = 1.0
	active = false
	frozen = 0
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
	}
	blinking = 0
	blinkMax = 10
	touchDamage = 0.0
	element = "normal"
	stompDamage = 1.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
	}

	function run() {
		base.run()
		if(active) {
			if(frozen > 0) frozen--
		}
		else {
			if(inDistance2(x, y, camx + (screenW() / 2), camy + (screenH() / 2), 240)) active = true
		}

		if(blinking > 0) blinking--

		//Check for weapon effects
		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) {
			//Skip weapons that don't hurt this enemy
			if(i.alignment == 2) continue
			if(i.owner == id) continue

			if(hitTest(shape, i.shape)) {
				getHurt(i.power, i.element, i.cut, i.blast)
				if(i.piercing == 0) deleteActor(i.id)
				else i.piercing--
			}
		}

		if(gvPlayer) {
			if(hitTest(shape, gvPlayer.shape) && !frozen) { //8 for player radius
				if(gvPlayer.invincible > 0) hurtInvinc()
				else if(y > gvPlayer.y && vspeed < gvPlayer.vspeed && gvPlayer.canStomp && gvPlayer.placeFree(gvPlayer.x, gvPlayer.y + 2)) getHurt(stompDamage, "normal", false, false)
				else if(gvPlayer.rawin("anSlide")) {
					if(gvPlayer.anim == gvPlayer.anSlide) getHurt(1, "normal", false, false)
					else hurtPlayer()
				}
				else hurtPlayer()
			}
		}
	}

	function hurtInvinc() {
		newActor(Poof, x, ystart - 6)
		newActor(Poof, x, ystart + 8)
		die()
		playSound(sndFlame, 0)
	}

	function die() {
		deleteActor(id)

		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, ystart - 6)
			icebox = -1
		}

		if(!nocount) game.enemies--
	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false) {
		if(blinking > 0) return

		local damage = _mag * damageMult[_element]
		if(_cut) damage *= damageMult["cut"]
		if(_blast) damage *= damageMult["blast"]

		health -= damage
		if(damage > 0) blinking = blinkMax

		if(health -= 0) {
			die()
			return
		}
		if(_element == "ice") frozen = 600 * damageMult["ice"]
	}

	function hurtPlayer() {
		gvPlayer.hurt = touchDamage * gvPlayer.damageMult[element]
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
		drawSpriteEx(sprite, frame, floor(x - camx), floor(y - camy), angle, flip, 1, 1, 1)
	}
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

		smart = _arr
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
					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
						icebox = mapNewSolid(shape)
					}

					//Draw
					if(smart) drawSpriteEx(sprGradcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
					else drawSpriteEx(sprDeathcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

					if(frozen <= 120) {
					if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
						else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
					}
					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						mapDeleteSolid(icebox)
						newActor(IceChunks, x, y)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}

					//Draw
					if(smart) drawSpriteEx(sprGradcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
					else drawSpriteEx(sprDeathcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) die()
				if(smart) drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			}

			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function hurtPlayer() {
		if(squish) return
		base.hurtPlayer()
	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false) {
		if(squish) return

		if(_blast) {
			hurtblast()
			return
		}

		if(_element == "fire") {
			newActor(Flame, x, y - 1)
			die()
			playSound(sndFlame, 0)

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

		if(gvPlayer.rawin("anSlide")) {
			if(gvPlayer.anim == gvPlayer.anSlide) {
				local c = newActor(DeadNME, x, y)
				actor[c].sprite = sprDeathcap
				actor[c].vspeed = -fabs(gvPlayer.hspeed)
				actor[c].hspeed = (gvPlayer.hspeed / 16)
				actor[c].spin = (gvPlayer.hspeed * 7)
				actor[c].angle = 180
				die()
				playSound(sndKick, 0)
			}
			else if(getcon("jump", "hold")) gvPlayer.vspeed = -8.0
			else {
				gvPlayer.vspeed = -4.0
				playSound(sndSquish, 0)
			}
			if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
				gvPlayer.anim = gvPlayer.anJumpU
				gvPlayer.frame = gvPlayer.anJumpU[0]
			}
		}
		else if(getcon("jump", "hold")) gvPlayer.vspeed = -8.0
		else gvPlayer.vspeed = -4.0
		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}

		squish = true
	}

	function hurtblast() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeathcap
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		die()
		playSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)
	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		die()
		stopSound(sndFlame)
		playSound(sndFlame, 0)

		if(randInt(20) == 0) {
			local a = actor[newActor(MuffinBlue, x, y)]
			a.vspeed = -2
		}
	}

	function hurtice() { frozen = 600 }

	function _typeof() { return "Deathcap" }
}

::PipeSnake <- class extends Enemy {
	ystart = 0
	timer = 30
	up = false
	flip = 1
	touchDamage = 2.0
	stompDamage = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		ystart = y
		shape = Rec(x, y, 8, 12, 0)
		timer = (x * y) % 60
		flip = _arr
	}

	function run() {
		base.run()

		if(up && y > ystart - 32 && !frozen) y -= 2
		if(!up && y < ystart && !frozen) y += 2

		timer--
		if(timer <= 0) {
			up = !up
			timer = 60
		}

		shape.setPos(x, y + 16)
		if(frozen) {
			//Create ice block
			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
				icebox = mapNewSolid(shape)
			}

			if(flip == 1) drawSpriteEx(sprSnake, 0, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
			if(flip == -1) drawSpriteEx(sprSnake, 0, floor(x - camx), floor(y - camy) + 32, 0, 2, 1, 1, 1)

			if(flip == 1) drawSpriteEx(sprSnake, 1, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
			if(flip == -1) drawSpriteEx(sprSnake, 1, floor(x - camx), floor(y - camy) - 8, 0, 2, 1, 1, 1)
			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapTall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy + 16)
				else drawSprite(sprIceTrapTall, 0, x - camx, y - camy + 16)
			}
			else drawSprite(sprIceTrapTall, 0, x - camx, y - camy + 16)
		}
		else {
			//Delete ice block
			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, ystart - 6)
				icebox = -1
			}

			if(flip == 1) drawSpriteEx(sprSnake, getFrames() / 8, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
			if(flip == -1) drawSpriteEx(sprSnake, getFrames() / 8, floor(x - camx), floor(y - camy) + 32, 0, 2, 1, 1, 1)
		}

		if(debug) {
			setDrawColor(0x008000ff)
			shape.draw()
		}
	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false) {
		if(!gvPlayer) return
		if(_mag == 0) return

		if(hitTest(shape, gvPlayer.shape)) {
			local didhurt = false
			if(gvPlayer.rawin("anSlide")) if(gvPlayer.anim == gvPlayer.anSlide) didhurt = true
			if(gvPlayer.rawin("anStomp")) if(gvPlayer.anim == gvPlayer.anStomp) didhurt = true
			if(!didhurt) hurtPlayer()
		}

		if(_element == "fire") hurtFire()
		else if(_element == "ice") hurtIce()
		else if(_blast) hurtBlast()
		else {
			newActor(Poof, x, ystart - 8)
			newActor(Poof, x, ystart + 8)
			die()
			playSound(sndKick, 0)

			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, ystart - 6)
				icebox = -1
			}
		}
	}

	function hurtBlast() { hurtInvinc() }

	function hurtInvinc() {
		newActor(Poof, x, ystart - 6)
		newActor(Poof, x, ystart + 8)
		die()
		playSound(sndFlame, 0)

		if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, ystart - 6)
				icebox = -1
			}
	}

	function hurtFire() {
		newActor(Flame, x, ystart - 6)
		newActor(Flame, x, ystart + 8)
		die()
		playSound(sndFlame, 0)

		if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, ystart - 6) // Not resetting icebox here to avoid the ice box solid from remaining in place indefinitely.
			}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "Snake" }
}

::SnowBounce <- class extends Enemy {
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
			if(gvPlayer && hspeed == 0) {
				if(x > gvPlayer.x) hspeed = -0.5
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
			drawSpriteEx(sprSnowBounce, getFrames() / 8, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

			if(frozen) {
				//Create ice block
				if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
					icebox = mapNewSolid(shape)
				}

				//Draw
				drawSpriteEx(sprSnowBounce, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

				if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
				}
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else {
				//Delete ice block
				if(icebox != -1) {
					mapDeleteSolid(icebox)
					newActor(IceChunks, x, y)
					icebox = -1
					if(gvPlayer) if(x > gvPlayer.x) flip = true
					else flip = false
				}
			}
		}

		if(x < 0) hspeed = fabs(hspeed)
		if(x > gvMap.w) hspeed = -fabs(hspeed)
	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false) {

		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) {
			newActor(Poof, x, y)
			die()
			playSound(sndSquish, 0)
			if(keyDown(config.key.jump)) gvPlayer.vspeed = -8
			else gvPlayer.vspeed = -4
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
		playSound(sndFlame, 0)

		if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, ystart - 6)
				icebox = -1
			}
	}

	function _typeof() { return "SnowBounce" }
}

::CarlBoom <- class extends Enemy {
	burnt = false
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	hspeed = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0, 0, 1)
		if(gvPlayer) if(x > gvPlayer.x) flip = true
	}

	function run() {
		base.run()

		if(active) {
			if(placeFree(x, y + 1)) vspeed += 0.1
			if(placeFree(x, y + vspeed)) y += vspeed
			else vspeed /= 2

			if(!squish) {
				if(y > gvMap.h + 8) deleteActor(id)

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
					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
						icebox = mapNewSolid(shape)
					}

					//Draw
					drawSpriteEx(sprCarlBoom, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

					if(frozen <= 120) {
					if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
						else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
					}
					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
				}
				else {
					//Delete ice block
					if(icebox != -1) {
						mapDeleteSolid(icebox)
						newActor(IceChunks, x, y)
						icebox = -1
						if(gvPlayer) if(x > gvPlayer.x) flip = true
						else flip = false
					}

					//Draw
					drawSpriteEx(sprCarlBoom, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				}
			}
			else {
				squishTime += 1.5
				frame += 0.002 * squishTime
				drawSpriteEx(sprCarlBoom, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
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

				//Get carried
				if(getcon("shoot", "hold") && gvPlayer) {
					if(hitTest(shape, gvPlayer.shape) && (gvPlayer.held == null || gvPlayer.held == id)) {
						if(gvPlayer.flip == 0) x = gvPlayer.x + 8
						else x = gvPlayer.x - 8
						y = gvPlayer.y
						vspeed = 0
						squishTime -= 1.0
						hspeed = gvPlayer.hspeed
						gvPlayer.held = id
						if(squishTime >= 150) gvPlayer.held = null
					}
					else if(gvPlayer.held == id) gvPlayer.held = null
				}

				//Move
				if(placeFree(x + hspeed, y)) x += hspeed
				else if(placeFree(x + hspeed, y - 2)) {
					x += hspeed
					y -= 1.0
				}
				if(!placeFree(x, y + 1)) hspeed *= 0.9
				if(fabs(hspeed) < 0.1) hspeed = 0.0

				//Explode
				if(squishTime >= 150) {
					deleteActor(id)
					newActor(BadExplode, x, y)
					if(gvPlayer) if(gvPlayer.held == id) gvPlayer.held = null
				}
			}

			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function hurtPlayer() {
		if(squish) return
		base.hurtPlayer()
	}

	function hurtBlast() {
		if(squish) return
		if(frozen) frozen = 0
		stopSound(sndFizz)
		playSound(sndFizz, 0)
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		squish = true

	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false) {
		if(squish) return

		stopSound(sndFizz)
		playSound(sndFizz, 0)
		if(getcon("jump", "hold")) gvPlayer.vspeed = -8
		else gvPlayer.vspeed = -4
		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}

		squish = true
	}

	function hurtFire() {
		if(icebox != -1) {
			mapDeleteSolid(icebox)
			newActor(IceChunks, x, y)
		}
		if(!burnt) {
			newActor(BadExplode, x, y - 1)
			die()
			playSound(sndFlame, 0)

			burnt = true
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "CarlBoom" }
}