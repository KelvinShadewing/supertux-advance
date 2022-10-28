/*=======*\
| ENEMIES |
\*=======*/

// ::Enemy <- class extends PhysAct {
// 	health = 1
// 	hspeed = 0.0
// 	vspeed = 0.0
// 	active = false
// 	frozen = 0
// 	icebox = -1
// 	nocount = false //If enemy is exempt from completion tracking

// 	function run() {
// 		base.run()
// 		//Collision with player
// 		if(active) {
// 			if(gvPlayer) {
// 				if(hitTest(shape, gvPlayer.shape) && !frozen) { //8 for player radius
// 					if(gvPlayer.invincible > 0) hurtInvinc()
// 					else if(y > gvPlayer.y && vspeed < gvPlayer.vspeed && gvPlayer.canStomp && gvPlayer.placeFree(gvPlayer.x, gvPlayer.y + 2)) getHurt()
// 					else if(gvPlayer.rawin("anSlide")) {
// 						if(gvPlayer.anim == gvPlayer.anSlide) getHurt()
// 						else hurtPlayer()
// 					}
// 					else hurtPlayer()
// 				}
// 			}

// 			//Collision with fireball
// 			if(actor.rawin("Fireball")) foreach(i in actor["Fireball"]) {
// 				if(hitTest(shape, i.shape)) {
// 					hurtFire()
// 					deleteActor(i.id)
// 				}
// 			}
// 			if(actor.rawin("BadExplode")) foreach(i in actor["BadExplode"]) {
// 				if(hitTest(shape, i.shape)) {
// 					hurtFire()
// 				}
// 			}
// 			if(actor.rawin("FlameBreath")) foreach(i in actor["FlameBreath"]) {
// 				if(hitTest(shape, i.shape)) {
// 					hurtFire()
// 					deleteActor(i.id)
// 				}
// 			}
// 			if(actor.rawin("ExplodeF")) foreach(i in actor["ExplodeF"]) {
// 				if(hitTest(shape, i.shape) && i.frame < 3) {
// 					hurtFire()
// 				}
// 			}
// 			if(actor.rawin("Iceball")) foreach(i in actor["Iceball"]) {
// 				if(hitTest(shape, i.shape)) {
// 					hurtIce()
// 					deleteActor(i.id)
// 				}
// 			}
// 			if(actor.rawin("FireballK")) foreach(i in actor["FireballK"]) {
// 				if(hitTest(shape, i.shape)) {
// 					newActor(ExplodeF, i.x, i.y)
// 					deleteActor(i.id)
// 				}
// 			}
// 			if(actor.rawin("ExplodeN")) foreach(i in actor["ExplodeN"]) {
// 				if(hitTest(shape, i.shape) && i.frame < 3) {
// 					hurtBlast()
// 				}
// 			}
// 		}
// 		else {
// 			if(inDistance2(x, y, camx + (screenW() / 2), camy + (screenH() / 2), 240)) active = true
// 		}

// 		if(active && frozen > 0) {
// 			frozen--
// 			if(getFrames() % 15 == 0) {
// 				newActor(Glimmer, shape.x - (shape.w + 4) + randInt((shape.w * 2) + 8), shape.y - (shape.h + 4) + randInt((shape.h * 2) + 8))
// 				if(randInt(50) % 2 == 0) newActor(Glimmer, shape.x - (shape.w + 4) + randInt((shape.w * 2) + 8), shape.y - (shape.h + 4) + randInt((shape.h * 2) + 8))
// 			}

// 			//Shatter when slid into while frozen
// 			if(gvPlayer) if(gvPlayer.rawin("anSlide")) {
// 				if(gvPlayer.anim == gvPlayer.anSlide) {
// 					shape.setPos(x - 2, y)
// 					if(hitTest(shape, gvPlayer.shape) && gvPlayer.hspeed >= 1) {
// 						frozen = 0
// 						getHurt()
// 						mapDeleteSolid(icebox)
// 					}
// 					shape.setPos(x + 2, y)
// 					if(hitTest(shape, gvPlayer.shape) && gvPlayer.hspeed <= -1) {
// 						frozen = 0
// 						getHurt()
// 						mapDeleteSolid(icebox)
// 					}
// 					shape.setPos(x, y)
// 				}
// 			}
// 		}
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {} //Spiked enemies can just call hurtPlayer() here

// 	function hurtPlayer() { //Default player damage
// 		if(gvPlayer.blinking > 0) return
// 		if(gvPlayer.x < x) gvPlayer.hspeed = -1.0
// 		else gvPlayer.hspeed = 1.0
// 		gvPlayer.hurt = 1
// 	}

// 	function hurtFire() {} //If the object is hit by a fireball
// 	function hurtIce() {}

// 	function hurtInvinc() {
// 		newActor(Poof, x, y)
// 		deleteActor(id)
// 		playSound(sndFlame, 0)
// 	}

// 	function hurtBlast() { getHurt() }

// 	function destructor() {
// 		if(!nocount) game.enemies--
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 		if(gvPlayer) {
// 			if(gvPlayer.held == id) gvPlayer.held = null
// 		}
// 	}

// 	function _typeof() { return "Enemy" }
// }

// ::Deathcap <- class extends Enemy {
// 	frame = 0.0
// 	flip = false
// 	squish = false
// 	squishTime = 0.0
// 	smart = false
// 	moving = false

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x.tofloat(), _y.tofloat())
// 		shape = Rec(x, y, 6, 6, 0)

// 		smart = _arr
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(!moving) if(gvPlayer) if(x > gvPlayer.x) {
// 				flip = true
// 				moving = true
// 			}

// 			if(!squish) {
// 				if(placeFree(x, y + 1)) vspeed += 0.1
// 				if(placeFree(x, y + vspeed)) y += vspeed
// 				else vspeed /= 2

// 				if(y > gvMap.h + 8) deleteActor(id)

// 				if(!frozen) {
// 					if(flip) {
// 						if(placeFree(x - 1, y)) x -= 1.0
// 						else if(placeFree(x - 2, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else if(placeFree(x - 1, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else flip = false

// 						if(smart) if(placeFree(x - 6, y + 14)) flip = false

// 						if(x <= 0) flip = false
// 					}
// 					else {
// 						if(placeFree(x + 1, y)) x += 1.0
// 						else if(placeFree(x + 1, y - 1)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else if(placeFree(x + 2, y - 2)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else flip = true

// 						if(smart) if(placeFree(x + 6, y + 14)) flip = true

// 						if(x >= gvMap.w) flip = true
// 					}
// 				}

// 				if(frozen) {
// 					//Create ice block
// 					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 						icebox = mapNewSolid(shape)
// 					}

// 					//Draw
// 					if(smart) drawSpriteEx(sprGradcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 					else drawSpriteEx(sprDeathcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 					if(frozen <= 120) {
// 					if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 						else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 					}
// 					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 				}
// 				else {
// 					//Delete ice block
// 					if(icebox != -1) {
// 						mapDeleteSolid(icebox)
// 						newActor(IceChunks, x, y)
// 						icebox = -1
// 						if(gvPlayer) if(x > gvPlayer.x) flip = true
// 						else flip = false
// 					}

// 					//Draw
// 					if(smart) drawSpriteEx(sprGradcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 					else drawSpriteEx(sprDeathcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 				}
// 			}
// 			else {
// 				squishTime += 0.025
// 				if(squishTime >= 1) deleteActor(id)
// 				if(smart) drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 				else drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 			}

// 			shape.setPos(x, y)
// 			setDrawColor(0xff0000ff)
// 			if(debug) shape.draw()
// 		}
// 	}

// 	function hurtPlayer() {
// 		if(squish) return
// 		base.hurtPlayer()
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(squish) return


// 		if(gvPlayer.rawin("anSlide")) {
// 			if(gvPlayer.anim == gvPlayer.anSlide) {
// 				local c = newActor(DeadNME, x, y)
// 				actor[c].sprite = sprDeathcap
// 				actor[c].vspeed = -fabs(gvPlayer.hspeed)
// 				actor[c].hspeed = (gvPlayer.hspeed / 16)
// 				actor[c].spin = (gvPlayer.hspeed * 7)
// 				actor[c].angle = 180
// 				deleteActor(id)
// 				playSound(sndKick, 0)
// 			}
// 			else if(getcon("jump", "hold")) gvPlayer.vspeed = -8.0
// 			else {
// 				gvPlayer.vspeed = -4.0
// 				playSound(sndSquish, 0)
// 			}
// 			if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 				gvPlayer.anim = gvPlayer.anJumpU
// 				gvPlayer.frame = gvPlayer.anJumpU[0]
// 			}
// 		}
// 		else if(getcon("jump", "hold")) gvPlayer.vspeed = -8.0
// 		else gvPlayer.vspeed = -4.0
// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}

// 		squish = true
// 	}

// 	function hurtBlast() {
// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprDeathcap
// 		actor[c].vspeed = -4
// 		actor[c].hspeed = (4 / 16)
// 		actor[c].spin = (4 * 7)
// 		actor[c].angle = 180
// 		deleteActor(id)
// 		playSound(sndKick, 0)
// 		if(icebox != -1) mapDeleteSolid(icebox)

// 	}

// 	function hurtFire() {
// 		newActor(Flame, x, y - 1)
// 		deleteActor(id)
// 		playSound(sndFlame, 0)

// 		if(randInt(20) == 0) {
// 			local a = actor[newActor(MuffinBlue, x, y)]
// 			a.vspeed = -2
// 		}
// 	}

// 	function hurtIce() { frozen = 600 }

// 	function _typeof() { return "Deathcap" }
// }

// ::PipeSnake <- class extends Enemy {
// 	ystart = 0
// 	timer = 30
// 	up = false
// 	flip = 1

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		ystart = y
// 		shape = Rec(x, y, 8, 12, 0)
// 		timer = (x * y) % 60
// 		flip = _arr
// 	}

// 	function run() {
// 		base.run()

// 		if(up && y > ystart - 32 && !frozen) y -= 2
// 		if(!up && y < ystart && !frozen) y += 2

// 		timer--
// 		if(timer <= 0) {
// 			up = !up
// 			timer = 60
// 		}

// 		shape.setPos(x, y + 16)
// 		if(frozen) {
// 			//Create ice block
// 			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 				icebox = mapNewSolid(shape)
// 			}

// 			if(flip == 1) drawSpriteEx(sprSnake, 1, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
// 			if(flip == -1) drawSpriteEx(sprSnake, 1, floor(x - camx), floor(y - camy) - 8, 0, 2, 1, 1, 1)
// 			if(frozen <= 120) {
// 				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapTall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy + 16)
// 				else drawSprite(sprIceTrapTall, 0, x - camx, y - camy + 16)
// 			}
// 			else drawSprite(sprIceTrapTall, 0, x - camx, y - camy + 16)
// 		}
// 		else {
// 			//Delete ice block
// 			if(icebox != -1) {
// 				mapDeleteSolid(icebox)
// 				newActor(IceChunks, x, ystart - 6)
// 				icebox = -1
// 			}

// 			if(flip == 1) drawSpriteEx(sprSnake, getFrames() / 8, floor(x - camx), floor(y - camy), 0, 0, 1, 1, 1)
// 			if(flip == -1) drawSpriteEx(sprSnake, getFrames() / 8, floor(x - camx), floor(y - camy) + 32, 0, 2, 1, 1, 1)
// 		}
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(gvPlayer.anim != gvPlayer.anSlide) hurtPlayer()
// 		else {
// 			newActor(Poof, x, ystart - 8)
// 			newActor(Poof, x, ystart + 8)
// 			deleteActor(id)
// 			playSound(sndKick, 0)

// 			if(icebox != -1) {
// 				mapDeleteSolid(icebox)
// 				newActor(IceChunks, x, ystart - 6)
// 				icebox = -1
// 			}
// 		}
// 	}

// 	function hurtBlast() { hurtInvinc() }

// 	function hurtInvinc() {
// 		newActor(Poof, x, ystart - 6)
// 		newActor(Poof, x, ystart + 8)
// 		deleteActor(id)
// 		playSound(sndFlame, 0)

// 		if(icebox != -1) {
// 				mapDeleteSolid(icebox)
// 				newActor(IceChunks, x, ystart - 6)
// 				icebox = -1
// 			}
// 	}

// 	function hurtFire() {
// 		newActor(Flame, x, ystart - 6)
// 		newActor(Flame, x, ystart + 8)
// 		deleteActor(id)
// 		playSound(sndFlame, 0)

// 		if(icebox != -1) {
// 				mapDeleteSolid(icebox)
// 				newActor(IceChunks, x, ystart - 6) // Not resetting icebox here to avoid the ice box solid from remaining in place indefinitely.
// 			}
// 	}

// 	function hurtIce() { frozen = 600 }

// 	function _typeof() { return "Snake" }
// }

// ::Ouchin <- class extends Enemy {
// 	sf = 0.0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		shape = Rec(x, y, 8, 8, 0)
// 		sf = randInt(8)
// 	}

// 	function run() {
// 		base.run()

// 		drawSprite(sprOuchin, sf + (getFrames() / 16), x - camx, y - camy)

// 		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) {
// 			if(x > gvPlayer.x) {
// 				if(gvPlayer.placeFree(gvPlayer.x - 1, gvPlayer.y)) gvPlayer.x--
// 				gvPlayer.hspeed -= 0.1
// 			}

// 			if(x < gvPlayer.x) {
// 				if(gvPlayer.placeFree(gvPlayer.x + 1, gvPlayer.y)) gvPlayer.x++
// 				gvPlayer.hspeed += 0.1
// 			}

// 			if(y > gvPlayer.y) {
// 				if(gvPlayer.placeFree(gvPlayer.x, gvPlayer.y - 1)) gvPlayer.y--
// 				gvPlayer.vspeed -= 0.1
// 			}

// 			if(y < gvPlayer.y) {
// 				if(gvPlayer.placeFree(gvPlayer.x, gvPlayer.y + 1)) gvPlayer.y++
// 				gvPlayer.vspeed += 0.1
// 			}
// 		}

// 		if(frozen) {
// 			//Create ice block
// 			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 				icebox = mapNewSolid(shape)
// 			}

// 			if(frozen <= 120) {
// 				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 			}
// 			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 		}
// 		else {
// 			if(icebox != -1) {
// 				mapDeleteSolid(icebox)
// 				newActor(IceChunks, x, y)
// 				icebox = -1
// 			}
// 		}
// 	}

// 	function hurtPlayer() {
// 		base.hurtPlayer()
// 		if(gvPlayer) gvPlayer.hurt = 2
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(gvPlayer && !frozen) {
// 			hurtPlayer()
// 		}
// 	}

// 	function hurtFire() {}

// 	function hurtIce() { frozen = 600 }
// }

//Dead enemy effect for enemies that get sent flying,
//like when hit with a melee attack
// ::DeadNME <- class extends Actor {
// 	sprite = 0
// 	frame = 0
// 	hspeed = 0.0
// 	vspeed = 0.0
// 	angle = 0.0
// 	spin = 0
// 	flip = 0
// 	gravity = 0.2

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		vspeed = -3.0
// 	}

// 	function run() {
// 		vspeed += gravity
// 		x += hspeed
// 		y += vspeed
// 		angle += spin
// 		if(y > gvMap.h + 32) deleteActor(id)
// 		drawSpriteEx(sprite, frame, floor(x - camx), floor(y - camy), angle, flip, 1, 1, 1)
// 	}
// }

// ::CarlBoom <- class extends Enemy {
// 	burnt = false
// 	frame = 0.0
// 	flip = false
// 	squish = false
// 	squishTime = 0.0
// 	hspeed = 0.0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x.tofloat(), _y.tofloat())
// 		shape = Rec(x, y, 6, 6, 0, 0, 1)
// 		if(gvPlayer) if(x > gvPlayer.x) flip = true
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(placeFree(x, y + 1)) vspeed += 0.1
// 			if(placeFree(x, y + vspeed)) y += vspeed
// 			else vspeed /= 2

// 			if(!squish) {
// 				if(y > gvMap.h + 8) deleteActor(id)

// 				if(!frozen) {
// 					if(flip) {
// 						if(placeFree(x - 1, y)) x -= 1.0
// 						else if(placeFree(x - 2, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else if(placeFree(x - 1, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else flip = false

// 						if(placeFree(x - 6, y + 14)) flip = false

// 						if(x <= 0) flip = false
// 					}
// 					else {
// 						if(placeFree(x + 1, y)) x += 1.0
// 						else if(placeFree(x + 1, y - 1)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else if(placeFree(x + 2, y - 2)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else flip = true

// 						if(placeFree(x + 6, y + 14)) flip = true

// 						if(x >= gvMap.w) flip = true
// 					}
// 				}

// 				if(frozen) {
// 					//Create ice block
// 					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 						icebox = mapNewSolid(shape)
// 					}

// 					//Draw
// 					drawSpriteEx(sprCarlBoom, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 					if(frozen <= 120) {
// 					if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 						else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 					}
// 					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 				}
// 				else {
// 					//Delete ice block
// 					if(icebox != -1) {
// 						mapDeleteSolid(icebox)
// 						newActor(IceChunks, x, y)
// 						icebox = -1
// 						if(gvPlayer) if(x > gvPlayer.x) flip = true
// 						else flip = false
// 					}

// 					//Draw
// 					drawSpriteEx(sprCarlBoom, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 				}
// 			}
// 			else {
// 				squishTime += 1.5
// 				frame += 0.002 * squishTime
// 				drawSpriteEx(sprCarlBoom, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
// 				if(getFrames() % 20 == 0) {
// 					local c
// 					if(!flip) c = actor[newActor(FlameTiny, x - 6, y - 8)]
// 					else c = actor[newActor(FlameTiny, x + 6, y - 8)]
// 					c.vspeed = -0.1
// 					c.hspeed = randFloat(0.2) - 0.1
// 				}

// 				if(frozen) {
// 					squish = false
// 					squishTime = 0
// 				}

// 				//Get carried
// 				if(getcon("shoot", "hold") && gvPlayer) {
// 					if(hitTest(shape, gvPlayer.shape) && (gvPlayer.held == null || gvPlayer.held == id)) {
// 						if(gvPlayer.flip == 0) x = gvPlayer.x + 8
// 						else x = gvPlayer.x - 8
// 						y = gvPlayer.y
// 						vspeed = 0
// 						squishTime -= 1.0
// 						hspeed = gvPlayer.hspeed
// 						gvPlayer.held = id
// 						if(squishTime >= 150) gvPlayer.held = null
// 					}
// 					else if(gvPlayer.held == id) gvPlayer.held = null
// 				}

// 				//Move
// 				if(placeFree(x + hspeed, y)) x += hspeed
// 				else if(placeFree(x + hspeed, y - 2)) {
// 					x += hspeed
// 					y -= 1.0
// 				}
// 				if(!placeFree(x, y + 1)) hspeed *= 0.9
// 				if(fabs(hspeed) < 0.1) hspeed = 0.0

// 				//Explode
// 				if(squishTime >= 150) {
// 					deleteActor(id)
// 					newActor(BadExplode, x, y)
// 					if(gvPlayer) if(gvPlayer.held == id) gvPlayer.held = null
// 				}
// 			}

// 			shape.setPos(x, y)
// 			setDrawColor(0xff0000ff)
// 			if(debug) shape.draw()
// 		}
// 	}

// 	function hurtPlayer() {
// 		if(squish) return
// 		base.hurtPlayer()
// 	}

// 	function hurtBlast() {
// 		if(squish) return
// 		if(frozen) frozen = 0
// 		stopSound(sndFizz)
// 		playSound(sndFizz, 0)
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 		squish = true

// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(squish) return

// 		stopSound(sndFizz)
// 		playSound(sndFizz, 0)
// 		if(getcon("jump", "hold")) gvPlayer.vspeed = -8
// 		else gvPlayer.vspeed = -4
// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}

// 		squish = true
// 	}

// 	function hurtFire() {
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 		if(!burnt) {
// 			newActor(BadExplode, x, y - 1)
// 			deleteActor(id)
// 			playSound(sndFlame, 0)

// 			burnt = true
// 		}
// 	}

// 	function hurtIce() { frozen = 600 }

// 	function _typeof() { return "CarlBoom" }
// }

// ::BadExplode <- class extends Actor{
// 	frame = 0.0
// 	shape = 0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)

// 		stopSound(sndExplodeF)
// 		playSound(sndExplodeF, 0)

// 		shape = Cir(x, y, 16)
// 	}

// 	function run() {
// 		drawSpriteEx(sprExplodeF, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
// 		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 0.75 - (frame / 10.0), 0.75 - (frame / 10.0))
// 		frame += 0.2

// 		if(gvPlayer) {
// 			if(hitTest(shape, gvPlayer.shape)) {
// 				if(gvPlayer.blastResist) gvPlayer.hurt = 2
// 				else gvPlayer.hurt = 4
// 			}
// 			if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
// 				if(x < gvPlayer.x) gvPlayer.hspeed += 0.5
// 				if(x > gvPlayer.x) gvPlayer.hspeed -= 0.5
// 				if(y >= gvPlayer.y) gvPlayer.vspeed -= 0.8
// 			}
// 		}
// 		if(frame >= 1) {
// 			if(actor.rawin("TNT")) foreach(i in actor["TNT"]) {
// 				if(hitTest(shape, i.shape)) {
// 					newActor(BadExplode, i.x, i.y)
// 					tileSetSolid(i.x, i.y, 0)
// 					deleteActor(i.id)
// 				}
// 			}
// 			if(actor.rawin("TNTALT")) foreach(i in actor["TNTALT"]) {
// 				if(hitTest(shape, i.shape)) {
// 					newActor(BadExplode, i.x, i.y)
// 					deleteActor(i.id)
// 				}
// 			}
// 		}
// 		if(frame >= 5) deleteActor(id)
// 	}

// 	function _typeof() { return "BadExplode" }
// }

// ::OrangeBounce <- class extends Enemy {
// 	frame = 0.0
// 	flip = false
// 	squish = false
// 	squishTime = 0.0
// 	smart = false

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x.tofloat(), _y.tofloat())
// 		shape = Rec(x, y, 6, 6, 0)

// 		vspeed = -3.0
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(gvPlayer && hspeed == 0) {
// 				if(x > gvPlayer.x) hspeed = -0.5
// 				else hspeed = 0.5
// 			}

// 			if(!placeFree(x, y + 1)) vspeed = -3.0
// 			if(!placeFree(x + 2, y - 2) && !placeFree(x + 2, y)) hspeed = -fabs(hspeed)
// 			if(!placeFree(x - 2, y - 2) && !placeFree(x - 2, y)) hspeed = fabs(hspeed)
// 			vspeed += 0.1

// 			if(hspeed > 0) flip = 0
// 			else flip = 1

// 			if(!frozen) {
// 				if(placeFree(x + hspeed, y)) x += hspeed
// 				if(placeFree(x, y + vspeed)) y += vspeed
// 				else vspeed /= 2
// 			}

// 			shape.setPos(x, y)

// 			//Draw
// 			drawSpriteEx(sprOrangeBounce, getFrames() / 8, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 			if(frozen) {
// 				//Create ice block
// 				if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 					icebox = mapNewSolid(shape)
// 				}

// 				//Draw
// 				drawSpriteEx(sprOrangeBounce, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 				if(frozen <= 120) {
// 				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 				}
// 				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 			}
// 			else {
// 				//Delete ice block
// 				if(icebox != -1) {
// 					mapDeleteSolid(icebox)
// 					newActor(IceChunks, x, y)
// 					icebox = -1
// 					if(gvPlayer) if(x > gvPlayer.x) flip = true
// 					else flip = false
// 				}
// 			}
// 		}

// 		if(x < 0) hspeed = fabs(hspeed)
// 		if(x > gvMap.w) hspeed = -fabs(hspeed)
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		newActor(Poof, x, y)
// 		deleteActor(id)
// 		playSound(sndSquish, 0)
// 		if(keyDown(config.key.jump)) gvPlayer.vspeed = -8
// 		else gvPlayer.vspeed = -4

// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 	}

// 	hurtFire = Deathcap.hurtFire

// 	function hurtIce() { frozen = 600 }

// 	function _typeof() { return "OrangeBounce" }
// }

// ::BadCannon <- class extends Actor {
// 	frame = 3.5
// 	timer = 240

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		mapNewSolid(Rec(x, y, 8, 8, 0))
// 	}

// 	function run() {
// 		base.run()

// 		if(gvPlayer) {
// 			if(x > gvPlayer.x + 8 && frame > 0.5) frame -= 0.1
// 			if(x < gvPlayer.x - 8 && frame < 4.5) frame += 0.1

// 			if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 160) && timer == 0 && (frame < 1 || frame > 4)) {
// 				if(frame < 1) {
// 					local c = actor[newActor(CannonBob, x - 4, y - 4)]
// 					c.hspeed = ((gvPlayer.x - x) / 48)
// 					local d = (y - gvPlayer.y) / 64
// 					if(d > 2) d = 2
// 					if(y > gvPlayer.y) c.vspeed -= d
// 					newActor(Poof, x - 4, y - 4)
// 				}
// 				if(frame >= 4) {
// 					local c = actor[newActor(CannonBob, x + 4, y - 4)]
// 					c.hspeed = ((gvPlayer.x - x) / 48)
// 					local d = (y - gvPlayer.y) / 64
// 					if(d > 2) d = 2
// 					if(y > gvPlayer.y) c.vspeed -= d
// 					newActor(Poof, x + 4, y - 4)
// 				}
// 				if(frame >= 1 && frame <= 4) {
// 					local c = actor[newActor(CannonBob, x, y - 4)]
// 					c.hspeed = ((gvPlayer.x - x) / 48)
// 					local d = (y - gvPlayer.y) / 64
// 					if(d > 2) d = 2
// 					if(y > gvPlayer.y) c.vspeed -= d
// 					newActor(Poof, x, y - 4)
// 				}
// 				timer = 240
// 			}

// 			if(timer > 0) timer--
// 		}

// 		drawSprite(sprCannon, frame, x - camx, y - camy)
// 	}

// 	function _typeof() { return "BadCannon" }
// }

// ::CannonBob <- class extends Enemy {
// 	vspeed = -4
// 	sprite = 0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		shape = Rec(x, y, 6, 6, 0)

// 		if(_arr == null) sprite = sprCannonBob
// 		else sprite = _arr
// 	}

// 	function run() {
// 		base.run()

// 		if(!frozen) {
// 			if(hspeed < 0) drawSpriteEx(sprite, getFrames() / 4, x - camx, y - camy, 0, 0, 1, 1, 1)
// 			else drawSpriteEx(sprite, getFrames() / 4, x - camx, y - camy, 0, 1, 1, 1, 1)

// 			vspeed += 0.2
// 			x += hspeed
// 			y += vspeed
// 			shape.setPos(x, y)

// 			if(y > gvMap.h) deleteActor(id)

// 			if(icebox != -1) {
// 				mapDeleteSolid(icebox)
// 				newActor(IceChunks, x, y)
// 				icebox = -1
// 				hspeed = 0
// 				vspeed = -1.0
// 			}
// 		}
// 		else {
// 			if(hspeed < 0) drawSpriteEx(sprite, 4, x - camx, y - camy, 0, 1, 1, 1, 1)
// 			else drawSpriteEx(sprite, 4, x - camx, y - camy, 0, 0, 1, 1, 1)

// 			//Create ice block
// 			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 				icebox = mapNewSolid(shape)
// 			}

// 			if(frozen <= 120) {
// 				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 			}
// 			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 		}
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprite
// 		actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
// 		actor[c].hspeed = (gvPlayer.hspeed / 16)
// 		deleteActor(id)
// 		playSound(sndKick, 0)
// 		if(getcon("jump", "hold")) gvPlayer.vspeed = -5
// 		else {
// 			gvPlayer.vspeed = -2
// 			playSound(sndSquish, 0)
// 		}
// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 	}

// 	function hurtBlast() {
// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprite
// 		actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
// 		actor[c].hspeed = (gvPlayer.hspeed / 16)
// 		deleteActor(id)
// 		playSound(sndKick, 0)
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}

// 	}

// 	function hurtIce() { frozen = 600 }

// 	function _typeof() { return "CannonBob" }
// }

// ::BlueFish <- class extends Enemy {
// 	timer = 0
// 	frame = 0.0
// 	biting = false
// 	flip = 0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		shape = Rec(x, y, 8, 6, 0)
// 		hspeed = 0.5
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(!placeFree(x + (hspeed * 2), y)) hspeed = -hspeed
// 			if(!placeFree(x, y + (vspeed * 2))) vspeed = -vspeed
// 			flip = (hspeed < 0).tointeger()

// 			timer--
// 			if(timer <= 0) {
// 				timer = 240
// 				vspeed = -0.5 + randFloat(1)
// 			}
// 			if(!inWater(x, y)) vspeed += 0.1
// 			vspeed *= 0.99

// 			if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) biting = true
// 			if(frame >= 4) {
// 				biting = false
// 				frame = 0.0
// 			}

// 			if(biting) {
// 				drawSpriteEx(sprBlueFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
// 				frame += 0.125
// 			}
// 			else drawSpriteEx(sprBlueFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)

// 			if(y > gvMap.h) {
// 				if(vspeed > 0) vspeed = 0
// 				vspeed -= 0.1
// 			}

// 			if(x > gvMap.w) hspeed = -1.0
// 			if(x < 0) hspeed = 1.0

// 			if(placeFree(x + hspeed, y)) x += hspeed
// 			if(placeFree(x, y + vspeed)) y += vspeed
// 			shape.setPos(x, y)
// 		}
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(gvPlayer.rawin("anSlide")) if(gvPlayer.anim == gvPlayer.anSlide && game.weapon == 4) hurtFire()
// 	}

// 	function hurtFire() {
// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprDeadFish
// 		actor[c].vspeed = -0.5
// 		actor[c].flip = flip
// 		actor[c].hspeed = hspeed
// 		if(flip == 1) actor[c].spin = -1
// 		else actor[c].spin = 1
// 		actor[c].gravity = 0.02
// 		deleteActor(id)
// 		playSound(sndKick, 0)
// 		game.enemies--
// 		newActor(Poof, x + 8, y)
// 		newActor(Poof, x - 8, y)
// 		if(randInt(20) == 0) {
// 			local a = actor[newActor(MuffinBlue, x, y)]
// 			a.vspeed = -2
// 		}
// 	}

// 	function _typeof() { return "BlueFish" }
// }

// ::RedFish <- class extends Enemy {
// 	timer = 0
// 	frame = 0.0
// 	biting = false
// 	flip = 0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		shape = Rec(x, y, 8, 6, 0)
// 		hspeed = 0.5
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(!placeFree(x + (hspeed * 2), y)) hspeed = -hspeed
// 			if(!placeFree(x, y + (vspeed * 2))) vspeed = -vspeed
// 			flip = (hspeed < 0).tointeger()

// 			timer--
// 			if(timer <= 0) {
// 				timer = 240
// 				vspeed = -0.5 + randFloat(1)
// 				if(hspeed == 0) hspeed = 1
// 				else hspeed *= 1 / fabs(hspeed)
// 			}
// 			if(!inWater(x, y)) vspeed += 0.1
// 			vspeed *= 0.99

// 			if(gvPlayer) {
// 				if(hitTest(shape, gvPlayer.shape)) biting = true
// 				if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64) && inWater(x, y)) {
// 					biting = true
// 					timer = 240

// 					//Chase player
// 					if(x < gvPlayer.x && hspeed < 2) hspeed += 0.02
// 					if(x > gvPlayer.x && hspeed > -2) hspeed -= 0.02

// 					if(y < gvPlayer.y && vspeed < 2) vspeed += 0.02
// 					if(y > gvPlayer.y && vspeed > -2) vspeed -= 0.02

// 					//Swim harder if far from the player
// 					if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 32)) {
// 						if(x < gvPlayer.x && hspeed < 2) hspeed += 0.02
// 						if(x > gvPlayer.x && hspeed > -2) hspeed -= 0.02

// 						if(y < gvPlayer.y && vspeed < 2) vspeed += 0.02
// 						if(y > gvPlayer.y && vspeed > -2) vspeed -= 0.02
// 					}
// 				}
// 			}


// 			if(frame >= 4) {
// 				biting = false
// 				frame = 0.0
// 			}

// 			if(biting) {
// 				drawSpriteEx(sprRedFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
// 				frame += 0.125
// 			}
// 			else drawSpriteEx(sprRedFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)

// 			if(y > gvMap.h) {
// 				if(vspeed > 0) vspeed = 0
// 				vspeed -= 0.1
// 			}

// 			if(x > gvMap.w) hspeed = -1.0
// 			if(x < 0) hspeed = 1.0

// 			if(placeFree(x + hspeed, y)) x += hspeed
// 			if(placeFree(x, y + vspeed)) y += vspeed
// 			shape.setPos(x, y)
// 		}
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(gvPlayer.rawin("anSlide")) if(gvPlayer.anim == gvPlayer.anSlide && game.weapon == 4) hurtFire()
// 	}

// 	function hurtFire() {
// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprDeadFish
// 		actor[c].vspeed = -0.5
// 		actor[c].flip = flip
// 		actor[c].hspeed = hspeed
// 		if(flip == 1) actor[c].spin = -1
// 		else actor[c].spin = 1
// 		actor[c].gravity = 0.02
// 		deleteActor(id)
// 		playSound(sndKick, 0)
// 		game.enemies--
// 		newActor(Poof, x + 8, y)
// 		newActor(Poof, x - 8, y)
// 		if(randInt(20) == 0) {
// 			local a = actor[newActor(MuffinBlue, x, y)]
// 			a.vspeed = -2
// 		}
// 	}

// 	function _typeof() { return "RedFish" }
// }

// ::JellyFish <- class extends Enemy {
// 	timer = 0
// 	frame = 0.0
// 	pump = false
// 	fliph = 0
// 	flipv = 0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		shape = Rec(x, y, 4, 4, 0)
// 		hspeed = 0.5
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(!placeFree(x + hspeed, y)) hspeed = -hspeed
// 			if(!placeFree(x, y + vspeed)) vspeed = -vspeed

// 			if(hspeed > 0) fliph = 0
// 			if(hspeed < 0) fliph = 1
// 			if(vspeed > 0) flipv = 1
// 			if(vspeed < 0) flipv = 0
// 			if(hspeed )

// 			timer--
// 			if(timer <= 0) {
// 				timer = 30 + randInt(90)
// 				pump = true
// 			}

// 			if(pump) {
// 				if(frame < 3) frame += 0.1
// 				else frame += 0.05

// 				if(frame >= 4) {
// 					frame = 0.0
// 					pump = false
// 				}

// 				if(frame > 2 && frame < 3) {
// 					if(fliph == 0) hspeed = 1.0
// 					else hspeed = -1.0
// 					if(flipv == 0) vspeed = -1.0
// 					else vspeed = 1.0
// 				}
// 			}

// 			if(y > gvMap.h) {
// 				if(vspeed > 0) vspeed = 0
// 				vspeed -= 0.1
// 			}

// 			if(x > gvMap.w) hspeed = -1.0
// 			if(x < 0) hspeed = 1.0

// 			if(!inWater(x, y)) vspeed += 0.1
// 			vspeed *= 0.99
// 			hspeed *= 0.99

// 			drawSpriteEx(sprJellyFish, frame, x - camx, y - camy, 0, fliph + (flipv * 2), 1, 1, 1)
// 			drawLightEx(sprLightIce, 0, x - camx, y - camy, 0, 0, 0.25, 0.25)

// 			if(placeFree(x + hspeed, y)) x += hspeed
// 			if(placeFree(x, y + vspeed)) y += vspeed
// 			shape.setPos(x, y)
// 		}
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(gvPlayer.rawin("anSlide")) if(gvPlayer.anim == gvPlayer.anSlide && game.weapon == 4) hurtFire()
// 	}

// 	function hurtFire() {
// 		if(randInt(20) == 0) {
// 			local a = actor[newActor(MuffinBlue, x, y)]
// 			a.vspeed = -2
// 		}
// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprJellyFish
// 		actor[c].vspeed = -0.2
// 		actor[c].flip = fliph + (flipv * 2)
// 		actor[c].hspeed = hspeed / 2
// 		if(fliph == 1) actor[c].spin = -1
// 		else actor[c].spin = 1
// 		actor[c].gravity = 0.01
// 		deleteActor(id)
// 		playSound(sndKick, 0)
// 		game.enemies--
// 		newActor(Poof, x, y)
// 	}

// 	function _typeof() { return "BlueFish" }
// }

// ::Clamor <- class extends Enemy {
// 	huntdir = 0
// 	timer = 0
// 	flip = 0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)

// 		shape = Rec(x, y, 6, 6, 0)
// 		if(_arr == "1") flip = 1

// 		if(flip == 0) huntdir = 1
// 		else huntdir = -1
// 	}

// 	function run() {
// 		base.run()

// 		if(gvPlayer) {
// 			if(inDistance2(x + (huntdir * 48), y - 32, gvPlayer.x, gvPlayer.y, 64) && timer == 0) {
// 				timer = 240
// 				newActor(ClamorPearl, x, y, null)
// 			}
// 		}

// 		if(timer > 0) timer--

// 		drawSpriteEx(sprClamor, (timer < 30).tointeger(), x - camx, y - camy, 0, flip, 1, 1, 1)
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(gvPlayer.rawin("anSlide")) if(gvPlayer.anim == gvPlayer.anSlide && game.weapon == 4) hurtFire()
// 	}

// 	function hurtFire() {
// 		if(timer < 30) {
// 			if(randInt(20) == 0) {
// 				local a = actor[newActor(MuffinBlue, x, y)]
// 				a.vspeed = -2
// 			}
// 			newActor(Poof, x, y - 1)
// 			deleteActor(id)
// 			playSound(sndFlame, 0)

// 		}
// 	}

// 	function hurtBlast() {
// 		newActor(Poof, x, y - 1)
// 		deleteActor(id)

// 	}

// 	function _typeof() { return "Clamor" }
// }

// ::ClamorPearl <- class extends PhysAct {
// 	hspeed = 0
// 	vspeed = 0
// 	timer = 1200
// 	shape = null

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)

// 		if(!gvPlayer) {
// 			deleteActor(id)
// 			return
// 		}

// 		local aim = pointAngle(x, y, gvPlayer.x, gvPlayer.y)
// 		hspeed = lendirX(1, aim)
// 		vspeed = lendirY(1, aim)

// 		shape = Rec(x, y, 4, 4, 0)
// 	}

// 	function run() {
// 		x += hspeed
// 		y += vspeed
// 		shape.setPos(x, y)
// 		timer--

// 		if(timer == 0 || !placeFree(x, y)) deleteActor(id)

// 		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = 2

// 		drawSprite(sprIceball, 0, x - camx, y - camy)
// 		if(!inWater(x, y)) vspeed += 0.2
// 	}
// }

// ::GreenFish <- class extends Enemy {
// 	timer = 120
// 	frame = 0.0
// 	biting = false
// 	flip = 0
// 	canjump = false

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		shape = Rec(x, y, 8, 6, 0)
// 		hspeed = 1.0
// 		if(gvPlayer) if(x > gvPlayer.x) hspeed = -1.0
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			flip = (hspeed < 0).tointeger()

// 			timer--
// 			if(timer <= 0) {
// 				timer = 120
// 				if(vspeed > -0.5 && inWater(x, y)) vspeed = -0.5
// 				if(hspeed == 0) hspeed = 1
// 				else hspeed *= 1 / fabs(hspeed)
// 				canjump = true
// 			}
// 			if(!inWater(x, y)) vspeed += 0.1
// 			vspeed *= 0.99

// 			if(gvPlayer) {
// 				if(hitTest(shape, gvPlayer.shape)) biting = true
// 				if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 256) && inWater(x, y)) {
// 					biting = true

// 					//Chase player
// 					if(x < gvPlayer.x && hspeed < 2) hspeed += 0.02
// 					if(x > gvPlayer.x && hspeed > -2) hspeed -= 0.02

// 					if(y < gvPlayer.y && vspeed < 2) vspeed += 0.1
// 					if(y > gvPlayer.y && vspeed > -4) {
// 						if(canjump && !gvPlayer.inWater(gvPlayer.x, gvPlayer.y) && ((hspeed > 0 && gvPlayer.x > x) || (hspeed < 0 && gvPlayer.x < x))) {
// 							vspeed = -6
// 							canjump = false
// 						}

// 						vspeed -= 0.2
// 					}

// 					//Swim harder if far from the player
// 					if(!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64)) {
// 						if(x < gvPlayer.x && hspeed < 2) hspeed += 0.02
// 						if(x > gvPlayer.x && hspeed > -2) hspeed -= 0.02

// 						if(y < gvPlayer.y && vspeed < 2) vspeed += 0.02
// 						if(y > gvPlayer.y && vspeed > -2) vspeed -= 0.02
// 					}
// 				}
// 			}


// 			if(frame >= 4) {
// 				biting = false
// 				frame = 0.0
// 			}

// 			if(biting) {
// 				drawSpriteEx(sprGreenFish, 4 + frame, x - camx, y - camy, 0, flip, 1, 1, 1)
// 				frame += 0.125
// 			}
// 			else drawSpriteEx(sprGreenFish, wrap(getFrames() / 16, 0, 3), x - camx, y - camy, 0, flip, 1, 1, 1)

// 			if(y > gvMap.h) {
// 				if(vspeed > 0) vspeed = 0
// 				vspeed -= 0.1
// 			}

// 			if(x > gvMap.w) hspeed = -1.0
// 			if(x < 0) hspeed = 1.0


// 			x += hspeed
// 			y += vspeed

// 			shape.setPos(x, y)
// 		}
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(gvPlayer.rawin("anSlide")) if(gvPlayer.anim == gvPlayer.anSlide && game.weapon == 4) hurtFire()
// 	}

// 	function hurtFire() {
// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprDeadFish
// 		actor[c].vspeed = -0.5
// 		actor[c].flip = flip
// 		actor[c].hspeed = hspeed
// 		if(flip == 1) actor[c].spin = -1
// 		else actor[c].spin = 1
// 		actor[c].gravity = 0.02
// 		deleteActor(id)
// 		playSound(sndKick, 0)
// 		game.enemies--
// 		newActor(Poof, x + 8, y)
// 		newActor(Poof, x - 8, y)
// 		if(randInt(20) == 0) {
// 			local a = actor[newActor(MuffinBlue, x, y)]
// 			a.vspeed = -2
// 		}
// 	}

// 	function _typeof() { return "GreenFish" }
// }

// ::Icicle <- class extends Enemy {
// 	timer = 30
// 	counting = false

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)
// 		shape = Rec(x, y, 4, 6, 0)
// 	}

// 	function run() {
// 		base.run()

// 		if(gvPlayer) if(abs(y - gvPlayer.y) < 128 && y < gvPlayer.y && abs(x - gvPlayer.x) < 8 && !counting) {
// 			counting = true
// 			playSound(sndIcicle, 0)
// 		}

// 		if(counting && timer > 0) timer--
// 		if(timer <= 0) {
// 			if(inWater(x, y) && vspeed < 1.0) vspeed += 0.05
// 			else vspeed += 0.2
// 		}
// 		if(inWater(x, y) && vspeed > 0.5) vspeed = 0.1
// 		y += vspeed
// 		shape.setPos(x, y)

// 		if(!placeFree(x, y)) {
// 			deleteActor(id)
// 			newActor(IceChunks, x, y)
// 		}

// 		drawSprite(sprIcicle, 0, x + (timer % 2) - camx, y - 8 - camy)
// 	}

// 	function hurtFire() {
// 		deleteActor(id)
// 		newActor(Poof, x, y)
// 	}
// }

// ::FlyAmanita <- class extends Enemy {
// 	range = 0
// 	dir = 0.5
// 	flip = 0

// 	constructor(_x, _y, _arr = 0) {
// 		base.constructor(_x, _y)
// 		if(_arr == "") range = 0
// 		else if(typeof _arr == "array") range = _arr[0].tointeger()
// 		else range = _arr.tointeger() * 16
// 		shape = Rec(x, y, 6, 6, 0)
// 	}

// 	function run() {
// 		base.run()
// 		if(gvPlayer) gvPlayer.x < x ? flip = 1 : flip = 0

// 		if(inDistance2(x, y, x, ystart, 16)) vspeed = ((1.0 / 8.0) * distance2(x, y, x, ystart)) * dir
// 		else if(inDistance2(x, y, x, ystart + range, 16)) vspeed = ((1.0 / 8.0) * distance2(x, y, x, ystart + range)) * dir
// 		else vspeed = dir * 2.0

// 		vspeed += dir * 0.2
// 		if(range == 0) vspeed = 0

// 		//Change direction
// 		if(range > 0) {
// 			if(y > ystart + range) dir = -0.5
// 			if(y < ystart) dir = 0.5
// 		}

// 		if(range < 0) {
// 			if(y > ystart) dir = -0.5
// 			if(y < ystart + range) dir = 0.5
// 		}

// 		if(!frozen) {
// 			//Delete ice block
// 			if(icebox != -1) {
// 				mapDeleteSolid(icebox)
// 				newActor(IceChunks, x, y)
// 				icebox = -1
// 			}

// 			y += vspeed
// 			drawSpriteEx(sprFlyAmanita, getFrames() / 4, x - camx, y - camy, 0, flip, 1, 1, 1)
// 		} else {
// 			//Create ice block
// 			if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 				icebox = mapNewSolid(shape)
// 			}

// 			drawSpriteEx(sprFlyAmanita, 0, x - camx, y - camy, 0, flip, 1, 1, 1)
// 			if(frozen <= 120) {
// 				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 			}
// 			else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 		}

// 		shape.setPos(x, y)
// 	}

// 	function hurtPlayer() {
// 		base.hurtPlayer()
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {


// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}

// 		local c = newActor(DeadNME, x, y)
// 		actor[c].sprite = sprFlyAmanita
// 		actor[c].vspeed = -abs(gvPlayer.hspeed * 1.1)
// 		actor[c].hspeed = (gvPlayer.hspeed / 16)
// 		actor[c].spin = (gvPlayer.hspeed * 6)
// 		actor[c].angle = 180
// 		deleteActor(id)
// 		playSound(sndKick, 0)

// 		if(getcon("jump", "hold")) {
// 			gvPlayer.vspeed = -8
// 			playSound(sndSquish, 0)
// 		}
// 		else {
// 			gvPlayer.vspeed = -4
// 			playSound(sndSquish, 0)
// 		}

// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}

// 		else if(keyDown(config.key.jump)) gvPlayer.vspeed = -5
// 		else gvPlayer.vspeed = -2
// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}
// 	}

// 	hurtFire = Deathcap.hurtFire

// 	function hurtIce() { frozen = 600 }
// }

// ::Jumpy <- class extends Enemy {
// 	frame = 0.0
// 	flip = false
// 	squish = false
// 	squishTime = 0.0
// 	smart = false
// 	jump = -4.0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x.tofloat(), _y.tofloat())
// 		shape = Rec(x, y, 6, 6, 0, 0, 2)

// 		if(_arr != null && _arr != "") jump = abs(_arr.tofloat()) * -1.0
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(gvPlayer) {
// 				if(x > gvPlayer.x) flip = 1
// 				else flip = 0
// 			}

// 			if(!placeFree(x, y + 1)) vspeed = jump
// 			if(!placeFree(x + 0, y - 2) && !placeFree(x + 2, y)) hspeed = 0
// 			if(!placeFree(x - 0, y - 2) && !placeFree(x - 2, y)) hspeed = 0
// 			vspeed += 0.15

// 			if(!frozen) {
// 				if(placeFree(x + hspeed, y)) x += hspeed
// 				if(placeFree(x, y + vspeed)) y += vspeed
// 				else vspeed /= 2
// 			}

// 			shape.setPos(x, y)

// 			//Draw
// 			drawSpriteEx(sprJumpy, getFrames() / 8, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 			if(frozen) {
// 				//Create ice block
// 				if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 					icebox = mapNewSolid(shape)
// 				}

// 				//Draw
// 				drawSpriteEx(sprJumpy, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 				if(frozen <= 120) {
// 				if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 				}
// 				else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 			}
// 			else {
// 				//Delete ice block
// 				if(icebox != -1) {
// 					mapDeleteSolid(icebox)
// 					newActor(IceChunks, x, y)
// 					icebox = -1
// 					if(gvPlayer) if(x > gvPlayer.x) flip = true
// 					else flip = false
// 				}
// 			}
// 		}

// 		if(x < 0) hspeed = 0.0
// 		if(x > gvMap.w) hspeed = -0.0
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		gvPlayer.hurt = 3
// 	}

// 	function hurtBlast() {
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 		newActor(Poof, x, y - 1)
// 		deleteActor(id)
// 		playSound(sndFlame, 0)


// 	}

// 	function hurtFire() {
// 		newActor(Flame, x, y - 1)
// 		deleteActor(id)
// 		playSound(sndFlame, 0)

// 	}

// 	function hurtIce() { frozen = 600 }
// }

// ::Haywire <- class extends Enemy {
// 	burnt = false
// 	frame = 0.0
// 	flip = false
// 	squish = false
// 	squishTime = 0.0
// 	chasing = false
// 	mspeed = 1.0
// 	hspeed = 0.0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x.tofloat(), _y.tofloat())
// 		shape = Rec(x, y, 6, 6, 0, 0, 1)
// 		if(gvPlayer) if(x > gvPlayer.x) flip = true
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(!squish || chasing) {
// 				if(placeFree(x, y + 1)) vspeed += 0.2
// 				if(placeFree(x, y + vspeed)) y += vspeed
// 				else vspeed /= 2

// 				if(chasing) mspeed = fabs(hspeed)
// 				else mspeed = 0.75

// 				if(chasing) squishTime++
// 				if(squishTime >= 200 && chasing) {
// 					deleteActor(id)
// 					newActor(BadExplode, x, y)

// 				}

// 				if(y > gvMap.h + 8) deleteActor(id)

// 				if(!frozen) {
// 					if(flip) {
// 						if(placeFree(x - mspeed, y)) x -= mspeed
// 						else if(placeFree(x - (mspeed * 2), y - (mspeed * 2))) {
// 							x -= mspeed
// 							y -= 1.0
// 						} else if(placeFree(x - mspeed, y - (mspeed * 2))) {
// 							x -= mspeed
// 							y -= 1.0
// 						} else flip = false

// 						if(placeFree(x - 6, y + 14) && !placeFree(x, y + 2)) {
// 							if(!chasing) flip = false
// 							else vspeed = -4
// 						}

// 						if(x <= 0) flip = false
// 						if(hspeed > 0) flip = false
// 					}
// 					else {
// 						if(placeFree(x + mspeed, y)) x += mspeed
// 						else if(placeFree(x + mspeed, y - mspeed)) {
// 							x += mspeed
// 							y -= 1.0
// 						} else if(placeFree(x + (mspeed * 2), y - (mspeed * 2))) {
// 							x += mspeed
// 							y -= 1.0
// 						} else flip = true

// 						if(placeFree(x + 6, y + 14) && !placeFree(x, y + 2)) {
// 							if(!chasing) flip = true
// 							else vspeed = -4
// 						}

// 						if(x >= gvMap.w) flip = true
// 						if(hspeed < 0) flip = true
// 					}

// 					if(gvPlayer) if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 64 + (16 * game.difficulty))) squish = true
// 				}

// 				if(gvPlayer && chasing) {
// 					if(x < gvPlayer.x - 8) if(hspeed < (2.5 + ((2.0 / 200.0) * squishTime))) {
// 						hspeed += 0.1
// 						if(hspeed < 0) hspeed += 0.1
// 					}
// 					if(x > gvPlayer.x + 8) if(hspeed > -(2.5 + ((2.0 / 200.0) * squishTime))) {
// 						hspeed -= 0.1
// 						if(hspeed > 0) hspeed -= 0.1
// 					}

// 					if(!placeFree(x, y + 1) && y > gvPlayer.y + 16) vspeed = -5.0
// 				}

// 				if(frozen) {
// 					//Create ice block
// 					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 						icebox = mapNewSolid(shape)
// 					}

// 					//Draw
// 					drawSpriteEx(sprHaywire, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 					if(frozen <= 120) {
// 					if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 						else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 					}
// 					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 					chasing = false
// 					squishTime = 0.0
// 				}
// 				else {
// 					//Delete ice block
// 					if(icebox != -1) {
// 						mapDeleteSolid(icebox)
// 						newActor(IceChunks, x, y)
// 						icebox = -1
// 						if(gvPlayer) if(x > gvPlayer.x) flip = true
// 						else flip = false
// 					}

// 					//Draw
// 					if(chasing) {
// 						drawSpriteEx(sprHaywire, wrap(getFrames() / 6, 8, 11), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
// 						if(getFrames() % 8 == 0) {
// 							local c
// 							if(!flip) c = actor[newActor(FlameTiny, x - 6, y - 8)]
// 							else c = actor[newActor(FlameTiny, x + 6, y - 8)]
// 							c.vspeed = -0.1
// 							c.hspeed = randFloat(0.2) - 0.1
// 						}
// 					}
// 					else drawSpriteEx(sprHaywire, wrap(getFrames() / 10, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 				}
// 			}
// 			else {
// 				squishTime += 1.5
// 				if(chasing) frame += 0.25
// 				else frame += 0.075
// 				if(squishTime >= 90 && !chasing) {
// 					chasing = true
// 					squishTime = 0
// 					stopSound(sndFizz)
// 					playSound(sndFizz, 0)
// 				}
// 				if(squishTime >= 300 && chasing) {
// 					deleteActor(id)
// 					newActor(BadExplode, x, y)

// 				}
// 				if(!chasing) drawSpriteEx(sprHaywire, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
// 				else drawSpriteEx(sprHaywire, wrap(frame, 8, 11), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)

// 				if(frozen) {
// 					squish = false
// 					squishTime = 0
// 					chasing = false
// 				}
// 			}

// 			shape.setPos(x, y)
// 			setDrawColor(0xff0000ff)
// 			if(debug) shape.draw()
// 		}
// 	}

// 	function hurtPlayer() {
// 		if(squish && !chasing) return
// 		base.hurtPlayer()
// 	}

// 	function hurtBlast() {
// 		if(squish) return
// 		if(frozen) frozen = 0
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 			frozen = 0
// 			icebox = -1
// 		}
// 		squish = true
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(frozen > 0) return
// 		if(chasing) {
// 			hurtPlayer()
// 			return
// 		}
// 		if(squish) return

// 		if(getcon("jump", "hold")) gvPlayer.vspeed = -8
// 		else gvPlayer.vspeed = -4
// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}
// 		playSound(sndKick, 0)

// 		squish = true
// 	}

// 	function hurtFire() {
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 		if(!burnt) {
// 			newActor(BadExplode, x, y - 1)
// 			deleteActor(id)
// 			playSound(sndFlame, 0)

// 			burnt = true
// 		}
// 	}

// 	function hurtIce() { frozen = 600 }

// 	function _typeof() { return "Haywire" }
// }

// ::Sawblade <- class extends PathCrawler {
// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y, _arr)
// 		shape = Rec(x, y, 6, 6, 0)
// 	}

// 	function run() {
// 		base.run()
// 		drawSprite(sprSawblade, getFrames() / 2, x - camx, y - camy)
// 		drawLightEx(sprLightIce, 0, x - camx, y - camy, 0, 0, 0.125, 0.125)
// 		//drawText(font, x - camx + 16, y - camy, dir.tostring())
// 		shape.setPos(x, y)
// 		if(gvPlayer) if(hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = 2
// 	}
// }

// ::BadExplodeS <- class extends Actor {
// 	frame = 0.0
// 	shape = 0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x, _y)

// 		stopSound(sndExplodeF)
// 		playSound(sndExplodeF, 0)

// 		shape = Rec(x, y, 16, 16, 0)
// 	}

// 	function run() {
// 		drawSpriteEx(sprExplodeT, frame, x - camx, y - camy, randInt(360), 0, 1, 1, 1)
// 		frame += 0.1

// 		if(gvPlayer) {
// 			if(hitTest(shape, gvPlayer.shape)) gvPlayer.hurt = 8
// 			if(floor(frame) <= 1 && distance2(x, y, gvPlayer.x, gvPlayer.y) < 64) {
// 				if(x < gvPlayer.x) gvPlayer.hspeed += 0.1
// 				if(x > gvPlayer.x) gvPlayer.hspeed -= 0.1
// 				if(y >= gvPlayer.y) gvPlayer.vspeed -= 0.1
// 			}
// 		}
// 		if(frame >= 1) {
// 				if(actor.rawin("WoodBlock")) foreach(i in actor["WoodBlock"]) {
// 				if(hitTest(shape, i.shape)) {
// 					newActor(WoodChunks, i.x, i.y)
// 					tileSetSolid(i.x, i.y, 0)
// 					deleteActor(i.id)
// 				}
// 			}

// 		}
// 		if(frame >= 5) deleteActor(id)
// 	}
// }

// ::Livewire <- class extends Enemy {
// 	burnt = false
// 	frame = 0.0
// 	flip = false
// 	squish = false
// 	squishTime = 0.0

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x.tofloat(), _y.tofloat())
// 		shape = Rec(x, y, 6, 6, 0, 0, 1)
// 		if(gvPlayer) if(x > gvPlayer.x) flip = true
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(!squish) {
// 				if(placeFree(x, y + 1)) vspeed += 0.5
// 				if(placeFree(x, y + vspeed)) y += vspeed
// 				else vspeed /= 2

// 				if(y > gvMap.h + 8) deleteActor(id)

// 				if(!frozen) {
// 					if(flip) {
// 						if(placeFree(x - 1, y)) x -= 1.0
// 						else if(placeFree(x - 2, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else if(placeFree(x - 1, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else flip = false

// 						if(placeFree(x - 6, y + 14)) flip = false

// 						if(x <= 0) flip = false
// 					}
// 					else {
// 						if(placeFree(x + 1, y)) x += 1.0
// 						else if(placeFree(x + 1, y - 1)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else if(placeFree(x + 2, y - 2)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else flip = true

// 						if(placeFree(x + 6, y + 14)) flip = true

// 						if(x >= gvMap.w) flip = true
// 					}
// 				}

// 				if(frozen) {
// 					//Create ice block
// 					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 						icebox = mapNewSolid(shape)
// 					}

// 					//Draw
// 					drawSpriteEx(sprLivewire, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 					if(frozen <= 120) {
// 					if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 						else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 					}
// 					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 				}
// 				else {
// 					//Delete ice block
// 					if(icebox != -1) {
// 						mapDeleteSolid(icebox)
// 						newActor(IceChunks, x, y)
// 						icebox = -1
// 						if(gvPlayer) if(x > gvPlayer.x) flip = true
// 						else flip = false
// 					}

// 					//Draw
// 					drawSpriteEx(sprLivewire, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 				}
// 			}
// 			else {
// 				squishTime += 3
// 				frame += 0.01 * squishTime
// 				if(squishTime >= 180) {
// 					deleteActor(id)
// 					newActor(BadExplodeS, x, y)
// 					newActor(BadExplodeS, x, y + 24)
// 					newActor(BadExplodeS, x, y - 24)
// 					newActor(BadExplodeS, x + 24, y)
// 					newActor(BadExplodeS, x - 24, y)
// 					newActor(BadExplodeS, x + 20, y + 20)
// 					newActor(BadExplodeS, x + 20, y - 20)
// 					newActor(BadExplodeS, x - 20, y + 20)
// 					newActor(BadExplodeS, x - 20, y - 20)
// 					newActor(BadExplodeS, x + 20, y - 20)

// 				}
// 				drawSpriteEx(sprLivewire, wrap(frame, 4, 7), x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)


// 				if(frozen) {
// 					squish = false
// 					squishTime = 0
// 				}
// 			}

// 			shape.setPos(x, y)
// 			setDrawColor(0xff0000ff)
// 			if(debug) shape.draw()
// 		}
// 	}

// 	function hurtPlayer() {
// 		if(squish) return
// 		base.hurtPlayer()
// 	}

// 	function hurtBlast() {
// 		if(squish) return
// 		if(frozen) frozen = 0
// 		stopSound(sndFizz)
// 		playSound(sndFizz, 0)
// 		if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 		squish = true

// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(squish) return

// 		stopSound(sndFizz)
// 		playSound(sndFizz, 0)
// 		if(getcon("jump", "hold")) gvPlayer.vspeed = -8
// 		else gvPlayer.vspeed = -4
// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}

// 		squish = true
// 			local c
// 			if(icebox != -1) {
// 			mapDeleteSolid(icebox)
// 			newActor(IceChunks, x, y)
// 		}
// 		if(burnt) {
// 			burnt = true
// 		}
// 	}

// 	function hurtIce() { frozen = 120 }
// }

// ::Blazeborn <- class extends Enemy {
// 	frame = 0.0
// 	flip = false
// 	squish = false
// 	squishTime = 0.0
// 	smart = false
// 	moving = false
// 	element = "fire"

// 	constructor(_x, _y, _arr = null) {
// 		base.constructor(_x.tofloat(), _y.tofloat())
// 		shape = Rec(x, y, 6, 6, 0)

// 		smart = _arr
// 	}

// 	function run() {
// 		base.run()

// 		if(active) {
// 			if(!moving) if(gvPlayer) if(x > gvPlayer.x) {
// 				flip = true
// 				moving = true
// 			}

// 			if(!squish) {
// 				if(placeFree(x, y + 1)) vspeed += 0.2
// 				if(placeFree(x, y + vspeed)) y += vspeed
// 				else vspeed /= 2

// 				if(y > gvMap.h + 8) deleteActor(id)

// 				if(!frozen) {
// 					if(flip) {
// 						if(placeFree(x - 1, y)) x -= 2.0
// 						else if(placeFree(x - 2, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else if(placeFree(x - 1, y - 2)) {
// 							x -= 1.0
// 							y -= 1.0
// 						} else flip = false

// 						if(smart) if(placeFree(x - 6, y + 14)) flip = false

// 						if(x <= 0) flip = false
// 					}
// 					else {
// 						if(placeFree(x + 1, y)) x += 2.0
// 						else if(placeFree(x + 1, y - 1)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else if(placeFree(x + 2, y - 2)) {
// 							x += 1.0
// 							y -= 1.0
// 						} else flip = true

// 						if(smart) if(placeFree(x + 6, y + 14)) flip = true

// 						if(x >= gvMap.w) flip = true
// 					}
// 				}

// 				if(frozen) {
// 					//Create ice block
// 					if(gvPlayer) if(icebox == -1 && !hitTest(shape, gvPlayer.shape)) {
// 						newActor(Flame, x, y - 1)
// 						deleteActor(id)
// 						playSound(sndFlame, 0)
// 					}

// 					//Draw
// 					if(smart) drawSpriteEx(sprBlazeborn , 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 					else drawSpriteEx(sprBlazeborn, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

// 					if(frozen <= 120) {
// 					if(floor(frozen / 4) % 2 == 0) drawSprite(sprIceTrapSmall, 0, x - camx - 1 + ((floor(frozen / 4) % 4 == 0).tointeger() * 2), y - camy - 1)
// 						else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 					}
// 					else drawSprite(sprIceTrapSmall, 0, x - camx, y - camy - 1)
// 				}
// 				else {
// 					//Delete ice block
// 					if(icebox != -1) {
// 						mapDeleteSolid(icebox)
// 						newActor(IceChunks, x, y)
// 						icebox = -1
// 						if(gvPlayer) if(x > gvPlayer.x) flip = true
// 						else flip = false
// 					}

// 					//Draw
// 					if(smart) drawSpriteEx(sprBlazeborn, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 					else drawSpriteEx(sprBlazeborn, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 				}
// 			}
// 			else {
// 				squishTime += 0.025
// 				if(squishTime >= 1)
// 				if(smart) drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 				else drawSpriteEx(sprDeathcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
// 			}
// 			drawLightEx(sprLightFire, 0, x - camx, y - camy, randInt(360), 0, 0.5 + sin(getFrames().tofloat() / 2.5) * 0.05, 0.5 + sin(getFrames().tofloat() / 2.5) * 0.05)

// 			shape.setPos(x, y)
// 			setDrawColor(0xff0000ff)
// 			if(debug) shape.draw()
// 		}
// 	}

// 	function hurtPlayer() {
// 		if(squish) return
// 		gvPlayer.hurt = 3
// 	}

// 	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
// 		if(squish) return


// 		if(gvPlayer.rawin("anSlide")) {
// 			if(gvPlayer.anim == gvPlayer.anSlide) {
// 			}
// 			else if(getcon("jump", "hold")) gvPlayer.vspeed = -8.0
// 			else {
// 				gvPlayer.vspeed = -4.0
// 				playSound(sndSquish, 0)
// 			}
// 			if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 				gvPlayer.anim = gvPlayer.anJumpU
// 				gvPlayer.frame = gvPlayer.anJumpU[0]
// 			}
// 		}
// 		else if(getcon("jump", "hold")) gvPlayer.vspeed = -1.0
// 		else gvPlayer.vspeed = -4.0
// 		if(gvPlayer.anim == gvPlayer.anJumpT || gvPlayer.anim == gvPlayer.anFall) {
// 			gvPlayer.anim = gvPlayer.anJumpU
// 			gvPlayer.frame = gvPlayer.anJumpU[0]
// 		}
// 		gvPlayer.hurt = 3
// 		squish = false
// 	}

// 	function hurtBlast() {
// 		newActor(Poof, x, y)
// 		deleteActor(id)
// 		playSound(sndFlame, 0)
// 		if(icebox != -1) mapDeleteSolid(icebox)

// 	}

// 	function hurtFire() {
// 		deleteActor(id)
// 		newActor(BadExplode, x , y)
// 		newActor(Flame, x, y - 1)
// 	}

// 	function hurtIce() { frozen = 600 }

// 	function _typeof() { return "Blazeborn" }
// }

::Wildcap <- class extends Enemy {
	frame = 0.0
	flip = false
	squish = false
	squishTime = 0.0
	smart = false
	moving = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x.tofloat(), _y.tofloat())
		shape = Rec(x, y, 6, 6, 0)

		smart = _arr
	}

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
					if(smart) drawSpriteEx(sprWildcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
					else drawSpriteEx(sprWildcap, 0, floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)

					if(frozen <= 70) {
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
					if(smart) drawSpriteEx(sprWildcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
					else drawSpriteEx(sprWildcap, wrap(getFrames() / 8, 0, 3), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				}
			}
			else {
				squishTime += 0.025
				if(squishTime >= 1) deleteActor(id)
				if(smart) drawSpriteEx(sprWildcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
				else drawSpriteEx(sprWildcap, floor(4.8 + squishTime), floor(x - camx), floor(y - camy), 0, flip.tointeger(), 1, 1, 1)
			}

			shape.setPos(x, y)
			setDrawColor(0xff0000ff)
			if(debug) shape.draw()
		}
	}

	function hurtPlayer() {
		if(squish) return
		gvPlayer.hurt = 4
	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(squish) return


		if(gvPlayer.rawin("anSlide")) {
			if(gvPlayer.anim == gvPlayer.anSlide) {
				local c = newActor(DeadNME, x, y)
				gvPlayer.hurt = 1
				actor[c].sprite = sprWildcap
				actor[c].vspeed = -abs(gvPlayer.hspeed)
				actor[c].hspeed = (gvPlayer.hspeed / 16)
				actor[c].spin = (gvPlayer.hspeed * 7)
				actor[c].angle = 180
				deleteActor(id)
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

	function hurtBlast() {
		local c = newActor(DeadNME, x, y)
		actor[c].sprite = sprWildcap
		actor[c].vspeed = -4
		actor[c].hspeed = (4 / 16)
		actor[c].spin = (4 * 7)
		actor[c].angle = 180
		deleteActor(id)
		playSound(sndKick, 0)
		if(icebox != -1) mapDeleteSolid(icebox)

	}

	function hurtFire() {
		newActor(Flame, x, y - 1)
		deleteActor(id)
		playSound(sndFlame, 0)

		if(randInt(40) == 0) {
			local a = actor[newActor(MuffinRed, x, y)]
			a.vspeed = -2
		}
	}

	function hurtIce() { frozen = 600 }

	function _typeof() { return "Deathcap" }
}