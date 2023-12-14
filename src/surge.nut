/*==========*\
| MIDI ACTOR |
\*==========*/

::Surge <- class extends Player {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
	frame = 0.0
	flip = 0
	canMove = true //If player has control
	mspeed = 8 //Maximum running speed
	climbdir = 1.0
	blinking = 0 //Invincibility frames
	xstart = 0.0
	ystart = 0.0
	hurt = 0
	swimming = false
	inMelee = false
	canStomp = true //If they can use jumping as an attack
	stompDamage = 1
	invincible = 0
	shapeStand = 0
	shapeSlide = 0
	tftime = -1 //Timer for transformation
	hidden = false
	jumpBuffer = 0
	rspeed = 0.0 //Run animation speed
	slideframe = 0.0 //Because using just frame gets screwy for some reason
	wasInWater = false
	antigrav = 0
	groundx = 0.0 //Remember last coordinates over solid ground
	groundy = 0.0
	slippery = false
	accel = 0.2
	firetime = 0
	sprite = null
	chargeTimer = 0.0
	chargePoof = 0.0
	walkAngle = 0.0
	dirAngle = 0.0
	didAirSpecial = false
	homingTarget = null
	shockEffect = null
	sideRunning = false

	an = {
		stand = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 6, 6, 6, 6, 6, 6, 6, 6, 48, 49, 48, 49, 48, 49, 48, 49, 50, 51, 51, 51, 51, 50, 48]
		skid = [4, 5]
		crouch = [7]
		walk = [8, 9, 10, 11, 12, 13, 14, 15]
		jog = [16, 17, 18, 19, 20, 21, 22, 23]
		run = [24, 25, 26, 27, 28, 29, 30, 31]
		sprint = [32, 33, 34, 35, 36, 37, 38, 39]
		curl = [40, 41]
		ball = [42, 43, 44, 45]
		hurt = [46, 47]
		climb = [52, 53, 54, 55, 54, 53]
		wall = [56, 57]
		dead = [58, 59]
		charge = [7, 40, 41, 60, 61, 62, 63]
		jumpR = [42, 43, 44, 45, 76, 77, 78, 79]
		jumpU = [64, 65]
		jumpT = [66, 67]
		fall = null
		fallN = [68, 69]
		fallW = [56]
		crawl = [72, 73, 47, 75, 74, 73]
		win = [51]
		fly = [80, 81, 82, 83]
		stomp = [70, 71]
	}
	animOffset = 0.0

	freeDown = false
	freeDown2 = false
	freeLeft = false
	freeRight = false
	freeUp = false
	nowInWater = false
	wasInWater = false

// Damage Multipliers {
	damageMultN = {
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
		cut = 2.0
		blast = 1.0
	}
	damageMultF = {
		normal = 1.0
		fire = 0.5
		ice = 2.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 2.0
		blast = 1.0
	}
	damageMultI = {
		normal = 1.0
		fire = 2.0
		ice = 0.5
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 2.0
		blast = 1.0
	}
	damageMultA = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 2.0
		air = 0.5
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 2.0
		blast = 1.0
	}
	damageMultE = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 0.5
		air = 2.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 2.0
		blast = 1.0
	}
	damageMultS = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 0.5
		water = 2.0
		light = 1.0
		dark = 1.0
		cut = 2.0
		blast = 1.0
	}
	damageMultW = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 2.0
		water = 0.5
		light = 1.0
		dark = 1.0
		cut = 2.0
		blast = 1.0
	}
	damageMultL = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 0.5
		dark = 2.0
		cut = 2.0
		blast = 1.0
	}
	damageMultD = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 2.0
		dark = 0.5
		cut = 2.0
		blast = 1.0
	}
//}

	function constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		an = clone an
		damageMultF = clone damageMultF
		routine = ruNormal
		anim = "stand"
		shapeStand = Rec(x, y, 5, 10, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 4)
		xstart = _x.tofloat()
		ystart = _y.tofloat()
		an.fall = an.fallN
		xprev = x
		yprev = y
		routine = ruNormal
		damageMult = damageMultN
		sprite = sprSurge
	}

	function run() {
		freeDown = placeFree(x, y + 1)
		freeDown2 = placeFree(x, y + 2)
		freeLeft = placeFree(x - 1, y)
		freeRight = placeFree(x + 1, y)
		freeUp = placeFree(x, y - 1)
		wasInWater = nowInWater
		nowInWater = inWater(x, y)

		base.run()

		if(firetime <= 0 && stats.energy < stats.maxEnergy)
			stats.energy += 1.0 / 30.0

		if(!freeDown2 && stats.stamina < stats.maxStamina && (stats.weapon != "earth" || !blinking) && anim != "ball")
			stats.stamina += 0.25

		if(getcon("swap", "press", true, playerNum)) swapitem()

		magnetic = stats.weapon == "shock"
	}

	function physics() {
		//Set Friction
		friction = 0.05
		if(anim == "ball")
			friction = 0.025
		if(onIce())
			friction /= 2.0

		if(fabs(hspeed) < friction)
			hspeed = 0.0
		if((placeFree(x, y + 2) || vspeed < 0) && (vspeed < 2 || (vspeed < 16 && !nowInWater)) && antigrav <= 0 && !sideRunning)
			vspeed += (vspeed > 5 && anim != "stomp" ? gravity / vspeed : gravity)
		else if(antigrav > 0)
			antigrav--
		if(!placeFree(x, y - 1) && vspeed < 0)
			vspeed = 0.0

		//Rolling
		slippery = (anim == "ball" || onIce())
		if(slippery) {
			if((!placeFree(x, y + 8) || !placeFree(x - hspeed * 2, y + 8)) && (fabs(hspeed) < 16)) {
				if(placeFree(x + max(4, hspeed), y + 1) && !onPlatform(hspeed)) {
					hspeed += 0.2
				}
				if(placeFree(x + min(-4, hspeed), y + 1) && !onPlatform(hspeed)) {
					hspeed -= 0.2
				}
			}
		}

		if(vspeed > 0)
			didJump = false
		if(nowInWater || anim == "fly")
			gravity = 0.12
		else
			gravity = 0.25

		//Anim-based physics
		switch(anim) {
			case "climb":
				gravity = 0.0
				vspeed = 0.0
				break
				break
			case "ball":
				if(hspeed == 0 || getcon("up", "hold", true, playerNum) && placeFree(x, y - 4))
					anim = "stand"
				break
			case "fly":
				if(vspeed > (getcon("down", "hold", true, playerNum) ? 4 : 2))
					vspeed -= 0.2

				if(getcon("spec2", "press", true, playerNum)) {
					anim = "jumpR"
					didAirSpecial = false
				}
				break
			case "stomp":
				frame += 0.5
				hspeed /= 1.25
				vspeed = max(4, vspeed)
				gravity = 1.0
				if(!placeFree(x, y + 2) || inWater(x, y + vspeed)) {
					blinking = max(blinking, 8)
					fireWeapon(ExplodeW, x, y + 8, 1, id)
					popSound(sndBump)
					anim = "jumpR"
					didAirSpecial = false
					vspeed = -4
					canJump = 0
				}
		}

		//Base movement
		if(resTime > 0) {
			if(vspeed > 0)
				gravity = -0.05
			if(vspeed < 0)
				gravity = 0.05
			if(fabs(vspeed) < 0.1) {
				vspeed = 0.0
				gravity = 0.0
			}
		}

		shape.setPos(x, y)
		xprev = x
		yprev = y

		if(placeFree(x, y + vspeed)) y += vspeed
		else if(sideRunning) {
			if(!placeFree(x - 4, y)) for(local i = 0; i < abs(vspeed); i++) {
				if(placeFree(x + i, y + vspeed)) {
					y += vspeed
					x += i
					break
				}
			}

			if(!placeFree(x + 4, y)) for(local i = 0; i < abs(vspeed); i++) {
				if(placeFree(x + i, y + vspeed)) {
					y += vspeed
					x += i
					break
				}
			}
		}
		else {
			vspeed /= 2
			if(fabs(vspeed) < 0.01) vspeed = 0
			//if(fabs(vspeed) > 1) vspeed -= vspeed / fabs(vspeed)
			if(placeFree(x, y + vspeed)) y += vspeed
		}

		if(hspeed != 0) {
			if(placeFree(x + hspeed, y)) { //Try to move straight
				for(local i = 0; i < max(8, abs(hspeed * 3)); i++) if(!placeFree(x, y + max(6, abs(hspeed))) && placeFree(x, y + 1) && !swimming && vspeed >= 0 && !onPlatform(hspeed) && !onPlatform(hspeed, -1)) {
					y += 1
				}
				x += hspeed
			} else {
				local didstep = false
				for(local i = 1; i <= 8; i++){ //Try to move up hill
					if(placeFree(x + hspeed, y - i)) {
						x += hspeed
						y -= i
						if(i > 2) {
							if(hspeed > 0) hspeed -= 0.2
							if(hspeed < 0) hspeed += 0.2
						}
						didstep = true
						//if(slippery && !swimming && !placeFree(xprev, yprev + 2) && fabs(hspeed) > 4.0) vspeed -= 2.0
						break
					}
				}

				if(fabs(hspeed) >= 4 && (anim == "ball" || !placeFree(x + hspeed, y)) && y < yprev)
					vspeed -= 1.0

				//If no step was taken, slow down
				if(didstep == false && fabs(hspeed) >= 1) hspeed -= (hspeed / fabs(hspeed)) / 2.0
				else if(didstep == false && fabs(hspeed) < 1) hspeed = 0
			}
		}

		shape = shapeStand
		if(anim == "ball" || !placeFree(x, y) || anim == "charge")
			shape = shapeSlide
		
		shapeStand.setPos(x, y)
		shapeSlide.setPos(x, y)
		if(y < -100) y = -100.0

		switch(escapeMoPlat(1, 1)) {
			case 1:
				if(vspeed < 0) vspeed = 0
				break
			case 2:
				if(hspeed < 0) hspeed = 0
				break
			case -1:
				if(vspeed > 0) vspeed = 0
				if(anim == "stomp") {
					blinking = max(blinking, 8)
					fireWeapon(ExplodeW, x, y + 8, 1, id)
					popSound(sndBump)
					anim = "jumpR"
					didAirSpecial = false
					vspeed = -4
					canJump = 0
				}
				break
			case -2:
				if(hspeed > 0) hspeed = 0
				break
		}

		//Movement
		if((!placeFree(x, y + 1) || onPlatform())) {
			if(anim == "ball") {
				if(hspeed > 0)
					hspeed -= friction / 2.0
				if(hspeed < 0)
					hspeed += friction / 2.0
			} else {
				if(hspeed > 0) {
					if(!(mspeed > 2 && getcon("right", "hold", true, playerNum)) || anim == "hurt" || !canMove)
						hspeed -= friction
				}
				if(hspeed < 0) {
					if(!(mspeed > 2 && getcon("left", "hold", true, playerNum)) || anim == "hurt" || !canMove)
						hspeed += friction
				}
			}
		}
		else {
			if(hspeed > 0 && !getcon("right", "hold", true, playerNum) && anim != "ball")
				hspeed -= friction / 3.0
			if(hspeed < 0 && !getcon("left", "hold", true, playerNum) && anim != "ball")
				hspeed += friction / 3.0
		}

		//Rotation
		if((fabs(xprev - x) > 1) && anim == "walk" && !sideRunning) {
			if((yprev - y) / (xprev - x) < -0.25)
				dirAngle = -1.0
			if((yprev - y) / (xprev - x) > 0.25)
				dirAngle = 1.0

			if(xprev > x)
				dirAngle *= abs(pointAngle(x, y, xprev, yprev))
			if(xprev < x)
				dirAngle *= abs(pointAngle(xprev, yprev, x, y))

			if(dirAngle > 45)
				dirAngle = 45
			if(dirAngle < -45)
				dirAngle = -45
		}
		else if(sideRunning) {
			if(!freeRight)
				dirAngle = -90

			if(!freeLeft)
				dirAngle = 90
		}
		else
			dirAngle /= 2.0

		walkAngle = (dirAngle + walkAngle) / 2.0
	}

	function animation() {
		animOffset = 0.0

		switch(anim) {
			case "stand":
			case "skid":
			case "walk":
				if(anim == "stand")
					frame += 0.1
				frame += abs(rspeed) / (8 + abs(rspeed))

				if(flip == 0 && hspeed < 0 && !endMode && !(getcon("left", "hold", true, playerNum) && fabs(hspeed) < 2.0)) {
					if(!slippery)
						hspeed += 0.2
					else
						hspeed += 0.1
					anim = "skid"
				}
				else if(flip == 1 && hspeed > 0 && !endMode && !(getcon("right", "hold", true, playerNum) && fabs(hspeed) < 2.0)) {
					if(!slippery)
						hspeed -= 0.2
					else
						hspeed -= 0.1
					anim = "skid"
				}
				else
					anim = "walk"

				if(anim == "walk") {
					//Offset frame based on movement speed
					if(sideRunning)
						rspeed = fabs(vspeed)
					if(abs(rspeed) <= 0.1 && (fabs(hspeed) <= 0.1 || slippery)) 
						anim = "stand"
					else if(fabs(rspeed) < fabs(hspeed) && !slippery)
						rspeed = fabs(hspeed)
					
				}

				if(placeFree(x, y + 8) && !onPlatform() && fabs(vspeed) > 1 && (fabs(hspeed) < 4 || vspeed < 0) && !sideRunning) {
					if(vspeed >= 0) anim = "jumpT"
					else anim = "jumpU"
					frame = 0.0
				}

				if(abs(sideRunning ? vspeed : hspeed) > 2)
					animOffset = 8.0
				if(abs(sideRunning ? vspeed : hspeed) > 4)
					animOffset = 16.0
				if(abs(sideRunning ? vspeed : hspeed) > 6.2)
					animOffset = 24.0

				if((anim == "stand" || fabs(hspeed) <= 0.2) && getcon("spec2", "hold", true, playerNum)) {
					frame = 0.0
					animOffset = 0.0
					anim = "charge"
					chargeTimer = 0.0
				}
				break

			case "jumpU":
			case "jumpR":
				frame += 0.25
				if(anim == "jumpR") {
					frame += 0.25
					if(holding)
						anim = "jumpU"
				}
				else if(!freeLeft || !freeRight)
					anim = "walk"

				if((!placeFree(x, y + 4) || !placeFree(x - hspeed * 2, y + 4) || onPlatform()) && vspeed >= 0 && !antigrav) {
					anim = "stand"
					frame = 0.0
				}

				if(vspeed > 0 && anim != "jumpR") {
					anim = "jumpT"
					frame = 0.0
				}

				if(frame >= 10)
					frame -= 8
				break

			case "jumpT":
				frame += 0.2
				if((!placeFree(x, y + 4) || !placeFree(x - hspeed * 2, y + 4) || onPlatform()) && vspeed >= 0 && !antigrav) {
					anim = "stand"
					frame = 0.0
				}

				if(floor(frame) > an[anim].len() - 1) {
					anim = "fall"
					frame = 0.0
				}

				if(vspeed < 0) anim = "jumpU"
				break

			case "fall":
				frame += 0.25
				if((!placeFree(x, y + 4) || !placeFree(x - hspeed * 2, y + 4) || onPlatform()) && vspeed >= 0 && !antigrav) {
					anim = "stand"
					frame = 0.0
				}
				if(vspeed < 0) anim = "jumpU"
				break

			case "wall":
				frame += 0.3
				vspeed = 0

				if(floor(frame) > 1) {
					vspeed = -6.0
					if(getcon("down", "hold", true, playerNum))
						vspeed = -4.0
					local w = 4.0
					if(getcon("up", "hold", true, playerNum)) {
						w = 1.0
						vspeed = -7.0
					}
					else if(getcon("down", "hold", true, playerNum))
						w = 6.0
					if(flip == 0) hspeed = w
					else hspeed = -w
					if(holding)
						anim = "jumpU"
					else
						anim = "jumpR"
					frame = 0.0

					canJump = 0
				}

				if(!freeLeft) flip = 0
				if(!freeRight) flip = 1
				break

			case "hurt":
				frame += 0.1
				if(floor(frame) > 1) {
					anim = "stand"
				}
				break

			case "ball":
				if(frame < 2)
					frame += 0.25
				else
					frame += fabs(hspeed) / 8.0
				if(frame >= 6)
					frame -= 4

				if(hspeed > 0)
					flip = 0
				if(hspeed < 0)
					flip = 1
				break

			case "charge":
				local chargeThreshold = max(2, ceil(chargeTimer))

				if(chargeTimer < 10) {
					if(getcon("left", "press", true, playerNum)
					 ||getcon("right", "press", true, playerNum)
					 ||getcon("up", "press", true, playerNum)
					 ||getcon("down", "press", true, playerNum))
						chargeTimer += 0.4
					else
						chargeTimer += 0.1
					if(didAirSpecial)
						chargeTimer += 0.2
				}

				if(chargeTimer > chargeThreshold) {
					for(local i = 0; i <= 10; i++)
						stopSound(sndSurgeCharge[i])
					popSound(sndSurgeCharge[floor(chargeTimer)])
				}

				frame += max(0.25, chargeTimer / 8.0)
				chargePoof += chargeTimer / 16.0
				if(chargePoof > 1 && !freeDown) {
					chargePoof -= 1.0
					local c = actor[newActor(PoofTiny, x, y + 12)]
					if(flip == 0) {
						c.hspeed = -1.0 * (chargeTimer / 4.0)
						c.x -= 6
					}
					else {
						c.hspeed = 1.0 * (chargeTimer / 4.0)
						c.x += 6
					}
					c.vspeed = -randFloat(1)
					c.hspeed += randFloat(1)
					c.hspeed -= randFloat(1)
				}

				// if((((!freeDown2 || onPlatform()) && getcon("down", "hold", true, playerNum)) ) && anim != "ball" && anim != "jumpU" && anim != "jumpT" && anim != "fall" && anim != "hurt" && anim != "wall" && anim != "crawl" && !didAirSpecial) {
				// 	if((placeFree(x + 2, y + 1) || placeFree(x - 2, y + 1)) && !onPlatform() || hspeed >= 1.5) {
				// 		anim = "ball"
				// 		popSound(sndSurgeRoll)
				// 		if(flip == 0)
				// 			hspeed = chargeTimer
				// 		else
				// 			hspeed = -chargeTimer
				// 		chargeTimer = 0.0
				// 	}
				// }

				if(!getcon("spec2", "hold", true, playerNum) && !didAirSpecial || (stats.weapon == "earth" && didAirSpecial && !freeDown)) {
					anim = "ball"
					popSound(sndSurgeRoll)
					if(flip == 0)
						hspeed = max(hspeed, chargeTimer)
					else
						hspeed = min(hspeed, -chargeTimer)
					chargeTimer = 0.0
				}

				if(didAirSpecial && !getcon("jump", "hold", true, playerNum)) {
					anim = "jumpR"
					didAirSpecial = false
				}

				if(frame >= 7)
					frame -= 4
				break

			case "fly":
				if(stats.stamina > 0) {
					frame += 0.5
					stats.stamina -= 0.01 * (1 + game.difficulty)
					if(getcon("jump", "hold", true, playerNum) || getcon("up", "hold", true, playerNum)) {
						vspeed = max(-2, vspeed - 0.2)
						stats.stamina -= 0.01 * (1 + game.difficulty)
					}
				}
				else {
					animOffset = 4
					frame += 0.1
				}

				if(!placeFree(x, y + 1) && vspeed >= 0)
					anim = "stand"
				break
		}

		if(endMode && hspeed == 0)
			anim = "win"
		else if(anim == "win")
				anim = "stand"

		if(anim in an && an[anim] != null && anim != "hurt")
			frame = wrap(abs(frame), 0, an[anim].len() - 1)

		if(!wasInWater && nowInWater)
			vspeed /= 8.0
		if(wasInWater && !nowInWater)
			vspeed *= 2.0
	}

	function ruNormal() {
		//Recharge
		if(firetime > 0) {
			firetime--
		}

		//After image
		if(zoomies > 0 && getFrames() % 2 == 0 && an[anim] != null) {
			local c = actor[newActor(AfterImage, x, y, [sprite, an[anim][wrap(floor(frame), 0, an[anim].len() - 1)] + animOffset, 0, flip, 0, 1, 1])]
			c.angle = walkAngle
			if(anim == "ball")
				c.y += 8
		}

		//Invincibility
		if(invincible > 0) invincible--
		if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))

		inMelee = (anim == "ball" || anim == "jumpR" || anim == "charge")

		//Controls
		if((!placeFree(x - hspeed, y + 2) && vspeed >= 0) || !placeFree(x, y + 2) || anim == "climb" || onPlatform()) {
			canJump = 16
		}
		else {
			if(canJump > 0) canJump--
		}

		if(anim == "stomp")
			canJump = 0

		onWall = (anim == "wall" || an[anim] == an["fallW"])

		if(canMove) {
			mspeed = 6.0
			if(config.stickspeed) {
				local j = null
				if(playerNum == 1) j = config.joy
				if(playerNum == 2) j = config.joy2
				if(abs(joyX(j.index)) >  js_max * 0.1) mspeed = (3.0 * abs(joyX(j.index))) / float(js_max)
			}

			if(invincible) mspeed += 0.4
			if(nowInWater) mspeed *= 0.4
			if(zoomies > 0) mspeed *= 2.0

			//Moving left and right
			if(zoomies > 0)
				accel = 0.4
			else
				accel = 0.1
			if(anim == "charge")
				accel = 0.0

			if(!placeFree(x - hspeed, y + 2) && placeFree(x + hspeed, y + 2) && hspeed != 0 && fabs(hspeed) < 16) {
				mspeed *= 1.5
				accel *= 2.0
			}

			if(nowInWater)
				accel *= 0.6

			sideRunning = false

			if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != "wall" && anim != "ball" && anim != "hurt" && anim != "climb" && anim != "skid" && anim != "plantMine" && anim != "shootTop") {
				if(vspeed <= -4 && ["walk", "stand"].find(anim) != null && !placeFree(x + 2, y) && !placeFree(x + 4, y - 8)) {
					if(vspeed > -mspeed)
						vspeed -= accel
					vspeed += friction * 2.8
					sideRunning = true
					if(x == xprev)
						hspeed = 0
				}
				else if(hspeed > 1)
					hspeed += accel / fabs(hspeed)
				else hspeed += accel
			}

			if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != "wall" && anim != "ball" && anim != "hurt" && anim != "climb" && anim != "skid" && anim != "plantMine" && anim != "shootTop") {
				if(vspeed <= -4 && ["walk", "stand"].find(anim) != null && !placeFree(x - 2, y) && !placeFree(x - 4, y - 8)) {
					if(vspeed > -mspeed)
						vspeed -= accel
					vspeed += friction * 2.8
					sideRunning = true
					if(x == xprev)
						hspeed = 0
				}
				else if(hspeed < -1)
					hspeed -= accel / fabs(hspeed)
				else hspeed -= accel
			}

			if(resTime) {
				if(getcon("up", "hold", true, playerNum) && vspeed > -2)
					vspeed -= 0.2
				if(getcon("down", "hold", true, playerNum) && vspeed < 2)
					vspeed += 0.2
				anim = "jumpR"
			}

			//Change run animation speed
			if(getcon("right", "hold", true, playerNum) && rspeed < mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") if(freeRight || placeFree(x + 1, y - 2)) {
				if(hspeed >= 2) rspeed += accel / 2.0
				else rspeed += accel
				if(rspeed < hspeed) rspeed = hspeed
			}
			if(getcon("left", "hold", true, playerNum) && rspeed > -mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") if(freeLeft || placeFree(x - 1, y - 2)) {
				if(hspeed <= -2) rspeed += accel / 2.0
				else rspeed -= accel
				if(rspeed > hspeed) rspeed = hspeed
			}
			if(rspeed > 0) rspeed -= 0.1
			if(rspeed < 0) rspeed += 0.1
			if((abs(rspeed) <= 0.5 || hspeed == 0) && !getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum)) rspeed = 0.0
			if(anim == "ball") rspeed = hspeed

			//On a ladder
			if(anim == "climb") {
				vspeed = 0

				//Ladder controls
				if(getcon("up", "hold", true, playerNum)) if(placeFree(x, y - 2)) {
					frame -= climbdir / 8
					y -= 2
				}

				if(getcon("down", "hold", true, playerNum)) if(placeFree(x, y + 2)) {
					frame += climbdir / 8
					y += 2
				}

				if(getcon("left", "hold", true, playerNum) && atCrossLadder()) if(placeFree(x - 2, y)) {
					if(!getcon("up", "hold", true, playerNum) && !getcon("down", "hold", true, playerNum))
							frame -= climbdir / 8
					x -= 1
				}

				if(getcon("right", "hold", true, playerNum) && atCrossLadder()) if(placeFree(x + 2, y)) {
					if(!getcon("up", "hold", true, playerNum) && !getcon("down", "hold", true, playerNum))
							frame += climbdir / 8
					x += 1
				}

				//Check if still on ladder
				local felloff = true
				if(atLadder() || atCrossLadder()) felloff = false
				if(felloff) {
					anim = "fall"
					frame = 0.0
					if(getcon("up", "hold", true, playerNum)) vspeed = -2.5
				}
				else if(!atCrossLadder()) {
					x -= (x % 16 <=> 8)
				}

				//Change direction
				if(getcon("right", "press", true, playerNum) && canMove) flip = 0
				if(getcon("left", "press", true, playerNum) && canMove) flip = 1
			}

			//Get on ladder
			if(((getcon("down", "hold", true, playerNum) && placeFree(x, y + 2)) || getcon("up", "hold", true, playerNum)) && anim != "hurt" && anim != "climb" && (vspeed >= 0 || getcon("down", "press", true, playerNum) || getcon("up", "press", true, playerNum))) {
				if(atLadder() || atCrossLadder()) {
					anim = "climb"
					frame = 0.0
					hspeed = 0
					vspeed = 0
					x = round(x)
				}
			}

			//Jumping
			if(getcon("jump", "press", true, playerNum) && jumpBuffer <= 0 && freeDown && anim != "ledge") jumpBuffer = 8
			if(jumpBuffer > 0) jumpBuffer--

			if(getcon("jump", "press", true, playerNum) || jumpBuffer > 0) {
				if((onPlatform() || onPlatform(8) || onPlatform(-8)) && !placeFree(x, y + 1) && getcon("down", "hold", true, playerNum)) {
					y++
					canJump = 32
					if(!placeFree(x, y) && !placeFree(x, y - 1)) y--
					if(anim == "stand" || anim == "walk") anim = "jumpT"
				}
				else if(canJump > 0 || nowInWater) {
					jumpBuffer = 0
					if(anim == "climb" || nowInWater)
						vspeed = -3
					else
						vspeed = -(6.0 + min(fabs(hspeed) / 6.0, 4.0))
					didJump = true
					canJump = 0
					animOffset = 0.0
					if(anim != "hurt") {
						if(holding)
							anim = "jumpU"
						else
							anim = "jumpR"
						frame = 0.0
					}
					if(!freeDown2 || (freeRight && freeLeft && !nowInWater)) popSound(sndSurgeJump, 0)
				}
				else if(freeDown && anim != "climb" && anim != "ledge" && !placeFree(x - 2, y) && anim != "wall" && hspeed <= 0 && tileGetSolid(x - 12, y - 12) != 40 && tileGetSolid(x - 12, y + 12) != 40 && tileGetSolid(x - 12, y) != 40 && !didJump) {
					flip = 0
					anim = "wall"
					frame = 0.0
					playSound(sndWallkick, 0)
					canJump = 0
				}
				else if(freeDown && anim != "climb" && anim != "ledge"  && !placeFree(x + 2, y) && anim != "wall" && hspeed >= 0 && tileGetSolid(x + 12, y - 12) != 40 && tileGetSolid(x + 12, y + 12) != 40 && tileGetSolid(x + 12, y) != 40 && !didJump) {
					flip = 1
					anim = "wall"
					frame = 0.0
					playSound(sndWallkick, 0)
					canJump = 0
				}
			}

			//Wall slide
			if((anim == "fall" || anim == "jumpR" && vspeed > 0) && ((getcon("left", "hold", true, playerNum) && !freeLeft) || (getcon("right", "hold", true, playerNum) && !freeRight))) {
				if(!freeLeft && !(onIce(x - 8, y) || onIce(x - 8, y - 16))) {
					if(vspeed > 0.5) vspeed = 0.5
					if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x - 4, y + 12)
					an["fall"] = an["fallW"]
					anim = "fall"
					flip = 0
				}
				if(!freeRight && !(onIce(x + 8, y) || onIce(x + 8, y - 16))) {
					if(vspeed > 0.5) vspeed = 0.5
					if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x + 4, y + 12)
					an["fall"] = an["fallW"]
					anim = "fall"
					flip = 1
				}
			} else an["fall"] = an["fallN"]

			if(!getcon("jump", "hold", true, playerNum) && (vspeed < 0 || anim == "fall") && didJump) {
				didJump = false
				vspeed /= 2.5
			}

			if(getcon("down", "hold", true, playerNum) && anim != "hurt" && !placeFree(x - hspeed, y + 2) && fabs(hspeed) > 1 && anim != "ball") {
				anim = "ball"
				frame = 0.0
				popSound(sndSurgeRoll)
			}
		}
		else rspeed = min(rspeed, abs(hspeed))

		if(anim != "ledge" && anim != "wall" && !(anim == "fall" && an.fall == an.fallW)) {
			if((getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum) && anim != "ball" && canMove) || (hspeed > 0.1 && anim == "ball"))
				flip = 0
			if((getcon("left", "hold", true, playerNum) && !getcon("right", "hold", true, playerNum) && anim != "ball" && canMove) || (hspeed < -0.1 && anim == "ball"))
				flip = 1
		}

		//Damage
		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(stats.weapon == "earth" && anim == "ball" && stats.stamina > 0) {
					stats.stamina -= hurt
					if(stats.stamina < 0) stats.health += stats.stamina
				}
				else {
					if(stats.health > 0) stats.health -= hurt
					if(flip == 0) hspeed = -2.0
					else hspeed = 2.0
					anim = "hurt"
					frame = 0.0
				}
			}
			hurt = 0
		}
		else hurt = 0
		if(blinking > 0) blinking--

		//Defensive element
		switch(stats.weapon) {
			case "fire":
				damageMult = damageMultF
				break
			case "ice":
				damageMult = damageMultI
				break
			case "earth":
				damageMult = damageMultE
				break
			case "air":
				damageMult = damageMultA
				break
			case "shock":
				damageMult = damageMultS
				break
			case "water":
				damageMult = damageMultW
				break
			case "light":
				damageMult = damageMultL
				break
			case "dark":
				damageMult = damageMultD
				break
			default:
				damageMult = damageMultN
				break
		}

		//Attacks
		if(anim != "jumpR" && anim != "charge")
			didAirSpecial = false

		if(checkActor(shockEffect)) {
			actor[shockEffect].x = x
			actor[shockEffect].y = y - (anim == "jumpR" ? 0 : 4)
		}

		//Air moves
		if(canMove && (anim == "jumpR" || (anim == "jumpU" || anim == "jumpT" || anim == "fall") && stats.weapon == "air" && !onPlatform()) && !didAirSpecial && getcon("jump", "press", true, playerNum) && !didJump) switch(stats.weapon) {
			case "fire":
				vspeed = 0.0
				antigrav = 10
				if(flip == 0)
					hspeed = max(6, hspeed)
				if(flip == 1)
					hspeed = min(-6, hspeed)
				popSound(sndFlame)
				didAirSpecial = true
				break

			case "ice":
				local target = null
				foreach(i in actor) {
					if(!(i instanceof Enemy))
						continue
					if(flip == 0 && i.x < x - 32)
						continue
					if(flip == 1 && i.x > x + 32)
						continue
					if(!inDistance2(x, y, i.x, i.y, 128))
						continue
					if(i.notarget)
						continue
					if(target == null || distance2(x, y, i.x, i.y) < distance2(x, y, target.x, target.y))
						target = i
				}

				if(target != null) {
					antigrav = 60
					homingTarget = target.id
					didAirSpecial = true
					jumpBuffer = 0
					popSound(sndThrow)
				}
				break

			case "shock":
				shockEffect = fireWeapon(ExplodeT2, x, y, 1, id).id
				if(!getcon("down", "hold", true, playerNum)) {
					vspeed = -6.0
					anim = "jumpU"
				}
				actor[shockEffect].blast = false
				didJump = true
				canJump = 0
				didAirSpecial = true
				blinking = max(8, blinking)
				break

			case "air":
				anim = "fly"
				didAirSpecial = true
				popSound(sndFlyAway)
				break

			case "water":
				anim = "stomp"
				didAirSpecial = true
				break

			case "earth":
				anim = "charge"
				didAirSpecial = true
				break

			default:
				didAirSpecial = true
				shockEffect = fireWeapon(InstaShield, x, y, 1, id).id
				blinking = max(8, blinking)
		}
		
		if((anim == "ball" || anim == "jumpR" && didAirSpecial) && stats.weapon == "fire") {
			if(fabs(hspeed) > 2) {
				if(getFrames() % 4 == 0)
					fireWeapon(DashFlame, x + hspeed * 2, y + (anim == "ball" ? 4 : -2) + vspeed, 1, id)

				if(getFrames() % 4 == 0) {
					local c = actor[newActor(FlameTiny, x - 4 + randInt(8), y - 4 + randInt(8))]
					c.hspeed = -0.5 + randFloat(1)
					c.vspeed = -0.5 + randFloat(1)
				}

				damageMultF.fire = 0.0
			}
		}
		else
			damageMultF.fire = 0.5

		//Homing attack
		if(stats.weapon == "ice" && checkActor(homingTarget) && antigrav > 0) {
			local godir = pointAngle(x, y, actor[homingTarget].x, actor[homingTarget].y - 8)
			hspeed = lendirX(6, godir)
			vspeed = lendirY(6, godir)

			if(inDistance2(x, y, actor[homingTarget].x, actor[homingTarget].y, 32)) {
				fireWeapon(InstaShield, x, y, 1, id)
				blinking = max(8, blinking)
			}

			if(getFrames() % 2 == 0)
				newActor(AfterImage, xprev, yprev, [sprExplodeI, randInt(4) + 1, 0, 0, randInt(360), 1, 1, 4])
		}
		if(stats.weapon == "ice" && (!checkActor(homingTarget) || hitTest(shape, actor[homingTarget].shape) || anim != "jumpR" || !placeFree(x + hspeed, y + vspeed))) {
			antigrav = 0
			homingTarget = null
			didAirSpecial = false
		}
	}

	function draw() {
		if(hidden)
			return

		frame = wrap(frame, 0, an[anim].len() - 1)

		local choffset = 0
		if(anim == "ball" || anim == "charge" || anim == "jumpR")
			choffset = 6

		local yoff = 0
		if(anim == "ball")
			yoff = 8
		if(anim == "jumpR")
			yoff = 6

		if(anim == "ball" && stats.weapon == "earth")
			drawSpriteZ(2, sprStoneBall, an[anim][floor(frame)] + animOffset, x - camx, y - camy + 4, walkAngle, flip, 1, 1, (blinking && anim != "hurt" ? wrap(blinking, 0, 10).tofloat() / 10.0 : 1))
		else
			drawSpriteZ(2, sprite, an[anim][floor(frame)] + animOffset, x - camx + (walkAngle / 20.0), y - 2 - camy + yoff + fabs(walkAngle / 15.0), walkAngle, flip, 1, 1, (blinking && anim != "hurt" ? wrap(blinking, 0, 10).tofloat() / 15.0 : 1))

		//Transformation flash
		if(tftime != -1) {
			if(tftime < 4) {
				drawSpriteZ(3, sprTFflash, tftime, x - camx, y - camy)
				tftime += 0.25
			} else tftime = -1
		}

		//Shields
		switch(stats.weapon) {
			case "fire":
				drawSpriteZ(3, sprShieldFire, getFrames() / 2, x - camx, y - 4 - camy + choffset, 0, 0, 1, 1, fabs(0.5 - float(getFrames() % 60) / 60.0) * 2.0)
				break
			case "ice":
				drawSpriteZ(3, sprShieldIce, getFrames() / 3, x - camx, y - 4 - camy + choffset, 0, 0, 1, 1, fabs(0.5 - float(getFrames() % 60) / 60.0) * 2.0)
				break
			case "air":
				drawSpriteZ(3, sprShieldAir, getFrames() / 3, x - camx, y - 4 - camy + choffset, 0, 0, 1, 1, fabs(0.5 - float(getFrames() % 60) / 60.0) * 2.0)
				break
			case "earth":
				drawSpriteZ(3, sprExplodeE, getFrames() / 3, x - camx, y - camy + choffset, 0, 0, 1, 1, fabs(0.5 - float(getFrames() % 60) / 60.0) * 2.0)
				break
			case "water":
				drawSpriteZ(3, sprShieldWater, getFrames() / 3, x - camx, y - 4 - camy + choffset, 0, 0, 1, 1, fabs(0.5 - float(getFrames() % 60) / 60.0) * 2.0)
				break
			case "shock":
				drawSpriteZ(3, sprShieldShock, getFrames() / 3, x - camx, y - 4 - camy + choffset, 0, 0, 1, 1, fabs(0.5 - float(getFrames() % 60) / 60.0) * 2.0)
				break
		}

		drawLight(sprLightBasic, 0, x - camx, y - camy + choffset - 4)

		if(debug) {
			setDrawColor(0x008000ff)
			shape.draw()

			drawText(font, x - camx - 16, y - camy - 16, sideRunning.tostring())
		}
	}

	function die(skipres = false) {
		if(resTime > 0) return
		if(stats.canres && !skipres) {
			stats.health = game.maxHealth
			blinking = 120
			hspeed = 0.0
			vspeed = 0.0
			if(y > gvMap.h) {
				invincible = 300
				resTime = 300
				vspeed = -2.0
			}
			stats.canres = false
		}
		else {
			stats.health = 0
			deleteActor(id)
			if(playerNum == 1) gvPlayer = false
			if(playerNum == 2) gvPlayer2 = false
			newActor(DeadPlayer, x, y, [sprite, an["dead"], playerNum, flip])
		}
	}

	function _typeof(){ return "Surge" }
}

::Dashie <- class extends Surge {
	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		sprite = sprDashie
	}

	function _typeof(){ return "Dashie" }
}