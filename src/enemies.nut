/*=======*\
| ENEMIES |
\*=======*/

::Enemy <- class extends PhysAct {
	health = 1
	hspeed = 0.0
	vspeed = 0.0
	active = false
	frozen = 0
	icebox = -1
	nocount = false //If enemy is exempt from completion tracking

	function run() {
		//Collision with player
		if(active) {
			if(gvPlayer != 0) {
				if(hitTest(shape, gvPlayer.shape) && !frozen) { //8 for player radius
					if(gvPlayer.invincible > 0) hurtinvinc()
					else if(y > gvPlayer.y && vspeed < gvPlayer.vspeed && gvPlayer.canstomp) gethurt()
					else if(gvPlayer.rawin("anSlide")) {
						if(gvPlayer.anim == gvPlayer.anSlide) gethurt()
						else hurtplayer()
					}
					else hurtplayer()
				}
			}

			//Collision with fireball
			if(actor.rawin("Fireball")) foreach(i in actor["Fireball"]) {
				if(hitTest(shape, i.shape)) {
					hurtfire()
					deleteActor(i.id)
				}
			}
			if(actor.rawin("FlameBreath")) foreach(i in actor["FlameBreath"]) {
				if(hitTest(shape, i.shape)) {
					hurtfire()
					deleteActor(i.id)
				}
			}
			if(actor.rawin("Iceball")) foreach(i in actor["Iceball"]) {
				if(hitTest(shape, i.shape)) {
					hurtice()
					deleteActor(i.id)
				}
			}
		}
		else {
			if(distance2(x, y, camx + (screenW() / 2), camy + (screenH() / 2)) <= 180) active = true
		}

		if(active && frozen > 0) {
			frozen--
			if(getFrames() % 15 == 0) {
				newActor(Glimmer, shape.x - (shape.w + 4) + randInt((shape.w * 2) + 8), shape.y - (shape.h + 4) + randInt((shape.h * 2) + 8))
				if(randInt(50) % 2 == 0) newActor(Glimmer, shape.x - (shape.w + 4) + randInt((shape.w * 2) + 8), shape.y - (shape.h + 4) + randInt((shape.h * 2) + 8))
			}
		}
	}

	function gethurt() {} //Spiked enemies can just call hurtplayer() here

	function hurtplayer() { //Default player damage
		if(gvPlayer.blinking > 0) return
		if(gvPlayer.x < x) gvPlayer.hspeed = -1.0
		else gvPlayer.hspeed = 1.0
		gvPlayer.hurt = true
	}

	function hurtfire() {} //If the object is hit by a fireball
	function hurtice() { frozen = 600 }

	function hurtinvinc() {
		newActor(Poof, x, y)
		deleteActor(id)
		playSound(sndFlame, 0)
		if(!nocount) game.enemies--
	}

	function _typeof() { return "Enemy" }
}

::Deathcap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 4, 6, 0)
		if(gvPlayer != 0) if(x > gvPlayer.x) flip = true
		smart = _arr
	}

	function run() {
		base.run()

		if(active) {
			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) deleteActor(id)

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 0.5, y)) x -= 0.5
						else if(placeFree(x - 1.1, y - 0.5)) {
							x -= 0.5
							y -= 0.25
						} else if(placeFree(x - 1.1, y - 1.0)) {
							x -= 0.5
							y -= 0.5
						} else flip = false
						/*
						There's a simpler way to do this in theory,
						but it doesn't work in practice.
						It should be this:

						else if(placeFree(x - 1.0, y - 1.0)) {
							x -= 1.0
							y -= 1.0
						}

						But for whatever reason, this prevents any
						movement over a slope that looks like \_.
						Instead, they just turn around when they reach
						the bottom of a slope facing right.

						This weird trick of checking twice ahead works,
						though. Credit to Admiral Spraker for giving me
						the idea. Another fine example of (/d/d/d).
						*/

						if(smart) if(placeFree(x - 4, y + 8)) flip = false

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

						if(smart) if(placeFree(x + 4, y + 8)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					if(gvPlayer != 0) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
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
						if(gvPlayer != 0) if(x > gvPlayer.x) flip = true
						else flip = false
					}

					//Draw
					if(smart) drawSpriteEx(sprGradcap, wrap(getFrames() / 12, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
					else drawSpriteEx(sprDeathcap, wrap(getFrames() / 12, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) deleteActor(id)
				if(smart) drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			}

			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function hurtplayer() {
		if(squish) return
		base.hurtplayer()
	}

	function gethurt() {
		if(squish) return
		if(!nocount) game.enemies--

		if(gvPlayer.rawin("anSlide")) {
			if(gvPlayer.anim == gvPlayer.anSlide) {
				local c = newActor(DeadNME, x, y)
				actor[c].sprite = sprDeathcap
				actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
				actor[c].hspeed = (gvPlayer.hspeed / 16)
				actor[c].spin = (gvPlayer.hspeed * 6)
				actor[c].angle = 180
				deleteActor(id)
				playSound(sndKick, 0)
			}
			else if(getcon("jump", "hold")) gvPlayer.vspeed = -5
			else {
				gvPlayer.vspeed = -2
				playSound(sndSquish, 0)
			}
			if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
				gvPlayer.anim = gvPlayer.anJumpU
				gvPlayer.frame = gvPlayer.anJumpU[0]
			}
		}
		else if(keyDown(config.key.jump)) gvPlayer.vspeed = -5
		else gvPlayer.vspeed = -2
		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}

		squish = true
	}

	function hurtfire() {
		newActor(Flame, x, y - 1)
		deleteActor(id)
		playSound(sndFlame, 0)
		if(!nocount) game.enemies--
	}

	function _typeof() { return "Deathcap" }
}

::PipeSnake <- class extends Enemy {
	ystart = 0
	timer = 60
	up = false
	flip = 1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		ystart = y
		shape = Rec(x, y, 8, 12, 0)
		timer = (x * y) % 60
		flip = _arr
	}

	function run() {
		base.run()

		if(up && y > ystart - 24 && !frozen) y--
		if(!up && y < ystart && !frozen) y++

		timer--
		if(timer <= 0) {
			up = !up
			timer = 120
		}

		shape.setPos(x, y + 16)
		if(frozen) {
			//Create ice block
			if(gvPlayer != 0) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
				icebox = mapNewSolid(shape)
			}

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

			if(flip == 1) drawSpriteEx(sprSnake, getFrames() / 20, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
			if(flip == -1) drawSpriteEx(sprSnake, getFrames() / 20, floor(x - camx), floor(y - camy) - 8, 0, 2, 1, 1, 1)
		}
	}

	function gethurt() {
		if(gvPlayer.anim != gvPlayer.anSlide) hurtplayer()
		else {
			newActor(Poof, x, ystart - 8)
			deleteActor(id)
			playSound(sndKick, 0)
			if(!nocount) game.enemies--
		}
	}

	function hurtfire() {
		newActor(Flame, x, ystart - 6)
		deleteActor(id)
		playSound(sndFlame, 0)
		if(!nocount) game.enemies--
	}

	function _typeof() { return "Snake" }
}

::Ouchin <- class extends Enemy {
	sf = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 8, 0)
		sf = randInt(8)
	}

	function run() {
		base.run()

		drawSprite(sprOuchin, sf + (getFrames() / 16), x - camx, y - camy)

		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) {
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

		if(frozen) {
			//Create ice block
			if(gvPlayer != 0) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
				icebox = mapNewSolid(shape)
			}

			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
		else {
			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
				icebox = -1
			}
		}
	}

	function gethurt() { hurtplayer() }

	function hurtfire() {}
}

//Dead enemy effect for enemies that get sent flying,
//like when hit with a melee attack
::DeadNME <- class extends Actor {
	sprite = 0
	frame = 0
	hspeed = 0.0
	vspeed = 0.0
	angle = 0.0
	spin = 0
	flip = 0
	gravity = 0.1

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

::CarlBoom <- class extends Enemy {

	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0, 0, 1)
		if(gvPlayer != 0) if(x > gvPlayer.x) flip = true
	}

	function run() {
		base.run()

		if(active) {
			if(!squish) {
				if(placeFree(x, y + 1)) vspeed += 0.1
				if(placeFree(x, y + vspeed)) y += vspeed
				else vspeed /= 2

				if(y > gvMap.h + 8) deleteActor(id)

				if(!frozen) {
					if(flip) {
						if(placeFree(x - 0.5, y)) x -= 0.5
						else if(placeFree(x - 1.1, y - 0.5)) {
							x -= 0.5
							y -= 0.25
						} else if(placeFree(x - 1.1, y - 1.0)) {
							x -= 0.5
							y -= 0.5
						} else flip = false
						/*
						There's a simpler way to do this in theory,
						but it doesn't work in practice.
						It should be this:

						else if(placeFree(x - 1.0, y - 1.0)) {
							x -= 1.0
							y -= 1.0
						}

						But for whatever reason, this prevents any
						movement over a slope that looks like \_.
						Instead, they just turn around when they reach
						the bottom of a slope facing right.

						This weird trick of checking twice ahead works,
						though. Credit to Admiral Spraker for giving me
						the idea. Another fine example of (/d/d/d).
						*/

						if(placeFree(x - 4, y + 8)) flip = false

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

						if(placeFree(x + 4, y + 8)) flip = true

						if(x >= gvMap.w) flip = true
					}
				}

				if(frozen) {
					//Create ice block
					if(gvPlayer != 0) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
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
						if(gvPlayer != 0) if(x > gvPlayer.x) flip = true
						else flip = false
					}

					//Draw
					drawSpriteEx(sprCarlBoom, wrap(getFrames() / 12, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				}
			}
			else {
				squishTime++
				frame += 0.002 * squishTime
				if(squishTime >= 150) {
					deleteActor(id)
					newActor(BadExplode, x, y)
					if(!nocount) game.enemies--
				}
				drawSpriteEx(sprCarlBoom, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)

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

	function hurtplayer() {
		if(squish) return
		base.hurtplayer()
	}

	function gethurt() {
		if(squish) return

		playSound(sndFizz, 0)
		if(getcon("jump", "hold")) gvPlayer.vspeed = -5
		else gvPlayer.vspeed = -2
		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}

		squish = true
	}

	function hurtfire() {
		newActor(BadExplode, x, y - 1)
		deleteActor(id)
		playSound(sndFlame, 0)
		if(!nocount) game.enemies--
	}

	function _typeof() { return "CarlBoom" }
}

::BadExplode <- class extends Actor{
	frame = 0.0
	shape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		playSound(sndExplodeF, 0)

		shape = Rec(x, y, 16, 16, 0)
	}

	function run() {
		drawSpriteEx(sprExplodeF, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
		frame += 0.1

		if(gvPlayer != 0) {
			if(hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = true
			if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
				if(x < gvPlayer.x) gvPlayer.hspeed += 0.3
				if(x > gvPlayer.x) gvPlayer.hspeed -= 0.3
				if(y >= gvPlayer.y) gvPlayer.vspeed -= 0.4
			}
		}
		if(frame >= 1) {
			if(actor.rawin("CarlBoom")) foreach(i in actor["CarlBoom"]) {
				if(hitTest(shape, i.shape)) {
					newActor(BadExplode, i.x, i.y)
					if(i.icebox != -1) mapDeleteSolid(i.icebox)
					if(!i.nocount) game.enemies--
					deleteActor(i.id)
				}
			}

			if(actor.rawin("WoodBlock")) foreach(i in actor["WoodBlock"]) {
				if(hitTest(shape, i.shape)) {
					newActor(WoodChunks, i.x, i.y)
					if(i.mapshape != -1) mapDeleteSolid(i.mapshape)
					deleteActor(i.id)
				}
			}

			if(actor.rawin("TNT")) foreach(i in actor["TNT"]) {
				if(hitTest(shape, i.shape)) {
					newActor(BadExplode, i.x, i.y)
					if(i.mapshape != -1) mapDeleteSolid(i.mapshape)
					deleteActor(i.id)
				}
			}
		}
		if(frame >= 5) deleteActor(id)
	}
}

::SnowBounce <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)
		if(gvPlayer != 0) {
			if(x > gvPlayer.x) hspeed = -0.5
			else hspeed = 0.5
		}
		else hspeed = 0.5

		vspeed = -2.5
	}

	function run() {
		base.run()

		if(active) {
			if(!placeFree(x, y + 1)) vspeed = -2.5
			if(!placeFree(x + 2, y)) hspeed = -0.5
			if(!placeFree(x - 2, y)) hspeed = 0.5
			vspeed += 0.05

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
				if(gvPlayer != 0) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
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
					if(gvPlayer != 0) if(x > gvPlayer.x) flip = true
					else flip = false
				}
			}
		}

		if(x < 0) hspeed = 0.5
		if(x > gvMap.w) hspeed = -0.5
	}

	function gethurt() {
		newActor(Poof, x, y)
		deleteActor(id)
		playSound(sndSquish, 0)
		if(keyDown(config.key.jump)) gvPlayer.vspeed = -5
		else gvPlayer.vspeed = -2
		if(!nocount) game.enemies--
	}

	function hurtfire() {
		newActor(Flame, x, y - 1)
		deleteActor(id)
		playSound(sndFlame, 0)
		if(!nocount) game.enemies--
	}
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

		if(gvPlayer != 0) {
			if(x > gvPlayer.x + 8 && frame > 0.5) frame -= 0.1
			if(x < gvPlayer.x - 8 && frame < 4.5) frame += 0.1

			if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 200 && timer == 0 && (frame < 1 || frame > 4)) {
				if(frame < 1) {
					local c = actor[newActor(CannonBob, x - 4, y - 4)]
					c.hspeed = ((gvPlayer.x - x) / 96)
					local d = (y - gvPlayer.y) / 64
					if(d > 2) d = 2
					if(y > gvPlayer.y) c.vspeed -= d
					newActor(Poof, x - 4, y - 4)
				}
				if(frame >= 4) {
					local c = actor[newActor(CannonBob, x + 4, y - 4)]
					c.hspeed = ((gvPlayer.x - x) / 96)
					local d = (y - gvPlayer.y) / 64
					if(d > 2) d = 2
					if(y > gvPlayer.y) c.vspeed -= d
					newActor(Poof, x + 4, y - 4)
				}
				if(frame >= 1 && frame <= 4) {
					local c = actor[newActor(CannonBob, x, y - 4)]
					c.hspeed = ((gvPlayer.x - x) / 96)
					local d = (y - gvPlayer.y) / 64
					if(d > 2) d = 2
					if(y > gvPlayer.y) c.vspeed -= d
					newActor(Poof, x, y - 4)
				}
				timer = 240
			}

			if(timer > 0) timer--
		}

		drawSprite(sprCannon, frame, x - camx, y - camy)
	}

	function _typeof() { return "BadCannon" }
}

::CannonBob <- class extends Enemy {
	vspeed = -2

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		base.run()

		if(!frozen) {
			if(hspeed < 0) drawSpriteEx(sprCannonBob, getFrames() / 4, x - camx, y - camy, 0, 0, 1, 1, 1)
			else drawSpriteEx(sprCannonBob, getFrames() / 4, x - camx, y - camy, 0, 1, 1, 1, 1)

			vspeed += 0.05
			x += hspeed
			y += vspeed
			shape.setPos(x, y)

			if(y > gvMap.h) deleteActor(id)

			if(icebox != -1) {
				mapDeleteSolid(icebox)
				newActor(IceChunks, x, y)
				icebox = -1
				hspeed = 0
				vspeed = -1.0
			}
		}
		else {
			if(hspeed < 0) drawSpriteEx(sprCannonBob, 4, x - camx, y - camy, 0, 1, 1, 1, 1)
			else drawSpriteEx(sprCannonBob, 4, x - camx, y - camy, 0, 0, 1, 1, 1)

			//Create ice block
			if(gvPlayer != 0) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
				icebox = mapNewSolid(shape)
			}

			if(frozen <= 120) {
				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
			}
			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
		}
	}

	function gethurt() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprCannonBob
		actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
		actor[c].hspeed = (gvPlayer.hspeed / 16)
		deleteActor(id)
		playSound(sndKick, 0)
		if(getcon("jump", "hold")) gvPlayer.vspeed = -5
		else {
			gvPlayer.vspeed = -2
			playSound(sndSquish, 0)
		}
		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}
	}

	function _typeof() { return "CannonBob" }
}

::BlueFish <- class extends Enemy {
	timer = 0
	frame = 0.0
	biting = false
	flip = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 6, 0)
		hspeed = 0.5
	}

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

			if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) biting = true
			if(frame >= 4) {
				biting = false
				frame = 0.0
			}

			if(biting) {
				drawSpriteEx(sprBlueFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
				frame += 0.125
			}
			else drawSpriteEx(sprBlueFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)

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

	function gethurt() {}

	function hurtfire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeadFish
		actor[c].vspeed = -0.5
		actor[c].flip = flip
		actor[c].hspeed = hspeed
		if(flip == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.02
		deleteActor(id)
		playSound(sndKick, 0)
		game.enemies--
		newActor(Poof, x + 8, y)
		newActor(Poof, x - 8, y)
	}

	function _typeof() { return "BlueFish" }
}

::RedFish <- class extends Enemy {
	timer = 0
	frame = 0.0
	biting = false
	flip = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 6, 0)
		hspeed = 0.5
	}

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
				else hspeed *= 1 / abs(hspeed)
			}
			if(!inWater(x, y)) vspeed += 0.1
			vspeed *= 0.99

			if(gvPlayer != 0) {
				if(hitTest(shape, gvPlayer.shape)) biting = true
				if(distance2(x, y, gvPlayer.x, gvPlayer.y) < 64 && inWater(x, y)) {
					biting = true
					timer = 240

					//Chase player
					if(x < gvPlayer.x && hspeed < 1) hspeed += 0.02
					if(x > gvPlayer.x && hspeed > -1) hspeed -= 0.02

					if(y < gvPlayer.y && vspeed < 1) vspeed += 0.02
					if(y > gvPlayer.y && vspeed > -1) vspeed -= 0.02

					//Swim harder if far from the player
					if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 32) {
						if(x < gvPlayer.x && hspeed < 1) hspeed += 0.02
						if(x > gvPlayer.x && hspeed > -1) hspeed -= 0.02

						if(y < gvPlayer.y && vspeed < 1) vspeed += 0.02
						if(y > gvPlayer.y && vspeed > -1) vspeed -= 0.02
					}
				}
			}


			if(frame >= 4) {
				biting = false
				frame = 0.0
			}

			if(biting) {
				drawSpriteEx(sprRedFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
				frame += 0.125
			}
			else drawSpriteEx(sprRedFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)

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

	function gethurt() {}

	function hurtfire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeadFish
		actor[c].vspeed = -0.5
		actor[c].flip = flip
		actor[c].hspeed = hspeed
		if(flip == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.02
		deleteActor(id)
		playSound(sndKick, 0)
		game.enemies--
		newActor(Poof, x + 8, y)
		newActor(Poof, x - 8, y)
	}

	function _typeof() { return "RedFish" }
}

::JellyFish <- class extends Enemy {
	timer = 0
	frame = 0.0
	pump = false
	fliph = 0
	flipv = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 4, 0)
		hspeed = 0.5
	}

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

			drawSpriteEx(sprJellyFish, frame, x - camx, y - camy, 0, fliph + (flipv * 2), 1, 1, 1)

			if(placeFree(x + hspeed, y)) x += hspeed
			if(placeFree(x, y + vspeed)) y += vspeed
			shape.setPos(x, y)
		}
	}

	function gethurt() {}

	function hurtfire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprJellyFish
		actor[c].vspeed = -0.2
		actor[c].flip = fliph + (flipv * 2)
		actor[c].hspeed = hspeed / 2
		if(fliph == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.01
		deleteActor(id)
		playSound(sndKick, 0)
		game.enemies--
		newActor(Poof, x, y)
	}

	function _typeof() { return "BlueFish" }
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

	function run() {
		base.run()

		if(gvPlayer != 0) {
			if(distance2(x + (huntdir * 48), y - 32, gvPlayer.x, gvPlayer.y) <= 64 && timer == 0) {
				timer = 240
				newActor(ClamorPearl, x, y, null)
			}
		}

		if(timer > 0) timer--

		drawSpriteEx(sprClamor, (timer < 30).tointeger(), x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function hurtfire() {
		if(timer < 30) {
			newActor(Poof, x, y - 1)
			deleteActor(id)
			playSound(sndFlame, 0)
			if(!nocount) game.enemies--
		}
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

		if(gvPlayer == 0) {
			deleteActor(id)
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

		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = true

		drawSprite(sprIceball, 0, x - camx, y - camy)
	}
}

::GreenFish <- class extends Enemy {
	timer = 120
	frame = 0.0
	biting = false
	flip = 0
	canjump = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 6, 0)
		hspeed = 0.5
		if(gvPlayer != 0) if(x > gvPlayer.x) hspeed = -0.5
	}

	function run() {
		base.run()

		if(active) {
			flip = (hspeed < 0).tointeger()

			timer--
			if(timer <= 0) {
				timer = 120
				if(vspeed > -0.5 && inWater(x, y)) vspeed = -0.5
				if(hspeed == 0) hspeed = 1
				else hspeed *= 1 / abs(hspeed)
				canjump = true
			}
			if(!inWater(x, y)) vspeed += 0.05
			vspeed *= 0.99

			if(gvPlayer != 0) {
				if(hitTest(shape, gvPlayer.shape)) biting = true
				if(distance2(x, y, gvPlayer.x, gvPlayer.y) < 256 && inWater(x, y)) {
					biting = true

					//Chase player
					if(x < gvPlayer.x && hspeed < 2) hspeed += 0.01
					if(x > gvPlayer.x && hspeed > -2) hspeed -= 0.01

					if(y < gvPlayer.y && vspeed < 2) vspeed += 0.05
					if(y > gvPlayer.y && vspeed > -4) {
						if(canjump && !gvPlayer.inWater(gvPlayer.x, gvPlayer.y) && ((hspeed > 0 && gvPlayer.x > x) || (hspeed < 0 && gvPlayer.x < x))) {
							vspeed = -4
							canjump = false
						}

						vspeed -= 0.2
					}

					//Swim harder if far from the player
					if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 64) {
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

			if(biting) {
				drawSpriteEx(sprGreenFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
				frame += 0.125
			}
			else drawSpriteEx(sprGreenFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)

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

	function gethurt() {}

	function hurtfire() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprDeadFish
		actor[c].vspeed = -0.5
		actor[c].flip = flip
		actor[c].hspeed = hspeed
		if(flip == 1) actor[c].spin = -1
		else actor[c].spin = 1
		actor[c].gravity = 0.02
		deleteActor(id)
		playSound(sndKick, 0)
		game.enemies--
		newActor(Poof, x + 8, y)
		newActor(Poof, x - 8, y)
	}

	function _typeof() { return "GreenFish" }
}

::Icicle <- class extends Enemy {
	timer = 30
	counting = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 4, 6, 0)
	}

	function run() {
		base.run()

		if(gvPlayer != 0) if(abs(y - gvPlayer.y) < 128 && y < gvPlayer.y && abs(x - gvPlayer.x) < 8 && !counting) {
			counting = true
			playSound(sndIcicle, 0)
		}

		if(counting && timer > 0) timer--
		if(timer <= 0) {
			if(inWater(x, y) && vspeed < 0.5) vspeed += 0.05
			else vspeed += 0.1
		}
		if(inWater(x, y) && vspeed > 0.5) vspeed = 0.1
		y += vspeed
		shape.setPos(x, y)

		if(!placeFree(x, y)) {
			deleteActor(id)
			newActor(IceChunks, x, y)
		}

		drawSprite(sprIcicle, 0, x + (timer % 2) - camx, y - 8 - camy)
	}

	function hurtfire() {
		deleteActor(id)
		newActor(Poof, x, y)
	}
}

::FlyAmanita <- class extends Enemy {
	range = 0
	dir = 0.5
	flip = 0

	constructor(_x, _y, _arr = 0) {
		base.constructor(_x, _y)
		range = _arr.tointeger() * 16
		shape = Rec(x, y, 6, 6, 0)
	}

	function run() {
		base.run()
		if(gvPlayer != 0) gvPlayer.x < x ? flip = 1 : flip = 0

		if(distance2(x, y, x, ystart) < 16) vspeed = ((1.0 / 16.0) * distance2(x, y, x, ystart)) * dir
		else if(distance2(x, y, x, ystart + range) < 16) vspeed = ((1.0 / 16.0) * distance2(x, y, x, ystart + range)) * dir
		else vspeed = dir

		vspeed += dir * 0.2

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
			y += vspeed
			drawSpriteEx(sprFlyAmanita, getFrames() / 4, x - camx, y - camy, 0, flip, 1, 1, 1)
		} else {
			drawSpriteEx(sprFlyAmanita, getFrames() / 4, x - camx, y - camy, 0, flip, 1, 1, 1)
			drawSprite(sprIceTrapSmall, 0, x - camx, y - camy)
		}

		shape.setPos(x, y)
	}

	function hurtplayer() {
		base.hurtplayer()
	}

	function gethurt() {
		if(!nocount) game.enemies--

		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprFlyAmanita
		actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
		actor[c].hspeed = (gvPlayer.hspeed / 16)
		actor[c].spin = (gvPlayer.hspeed * 6)
		actor[c].angle = 180
		deleteActor(id)
		playSound(sndKick, 0)

		if(getcon("jump", "hold")) gvPlayer.vspeed = -5
		else {
			gvPlayer.vspeed = -2
			playSound(sndSquish, 0)
		}

		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}

		else if(keyDown(config.key.jump)) gvPlayer.vspeed = -5
		else gvPlayer.vspeed = -2
		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
			gvPlayer.anim = gvPlayer.anJumpU
			gvPlayer.frame = gvPlayer.anJumpU[0]
		}
	}

	hurtfire = Deathcap.hurtfire
}