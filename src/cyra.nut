
::sprCyra <- newSprite("res/gfx/cyra_gfx/cyra.png", 74, 54, 0, 0, 32, 32)
::defCyra <- sprCyra
::sprCyraFire <- newSprite("res/gfx/cyra_gfx/cyrafire.png", 66, 42, 0, 0, 32, 29)
::defCyraFire <- sprCyraFire
::sprCyraIce <- newSprite("res/gfx/cyra_gfx/cyraice.png", 66, 42, 0, 0, 32, 29)
::defCyraIce <- sprCyraIce
::sprCyraAir <- newSprite("res/gfx/cyra_gfx/cyraair.png", 66, 42, 0, 0, 32, 29)
::defCyraAir <- sprCyraAir
::sprCyraEarth <- newSprite("res/gfx/cyra_gfx/cyraearth.png", 66, 42, 0, 0, 32, 29)
::defCyraEarth <- sprCyraEarth
::sprCyraOverworld <- newSprite("res/gfx/cyra_gfx/cyraO.png", 14, 20, 0, 0, 7, 17)
::defCyraOverworld <- sprCyraOverworld
::sprCyraDoll <- newSprite("res/gfx/cyra_gfx/cyradoll.png", 16, 16, 0, 0, 8, 8)
::defCyraDoll <- sprCyraDoll


::sprCyraSwordWave <- newSprite("res/gfx/cyra_gfx/swordwave.png", 28, 24, 0, 0, 14, 12)
::defCyraSwordWave <- sprCyraSwordWave

::sprCyraFireWave <- newSprite("res/gfx/cyra_gfx/firewave.png", 28, 24, 0, 0, 14, 12)
::defCyraFireWave <- sprCyraFireWave

::sprCyraFreezeWave <- newSprite("res/gfx/cyra_gfx/freezewave.png", 28, 24, 0, 0, 14, 12)
::defCyraFreezeWave <- sprCyraFreezeWave

//Sounds
::sndCyraSwordSwing <- loadSound("res/snd/cyra_snd/swordswing.ogg")
::sndCyraFireSwing <- loadSound("res/snd/cyra_snd/firewave.ogg")
::sndCyraTornado <- loadSound("res/snd/cyra_snd/windswing.ogg")

::gfxCyraReset <- function() {
	sprCyra = defCyra
	sprCyraOverworld = defCyraOverworld
	sprCyraDoll = defCyraDoll
}

//Load game text

::freeCyra <- function() {
	if(!game.characters.rawin("Cyra")) game.characters["Cyra"] <- true
	if(!game.friends.rawin("Cyra")) game.friends["Cyra"] <- true
}

gvCharacters.Cyra <- {
	over = "sprCyraOverworld"
	doll =  "sprCyraDoll"
	normal = "sprCyra"
	fire = "sprCyraFire"
	ice = "sprCyraIce"
	air = "sprCyra"
	earth = "sprCyra"
	wave = [8, 9]
}

/*=========*\
| cyra ACTOR |
\*=========*/

::Cyra <- class extends Player {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
	baseFriction = 0.25
	accel = 0.5
	gravity = 0.0
	frame = 0.0
	flip = 0
	canMove = true //If player has control
	mspeed = 6 //Maximum running speed
	climbdir = 1.0
	blinking = 0 //Invincibility frames
	startx = 0.0
	starty = 0.0
	firetime = 0
	hurt = 0
	blast = true
	swimming = false
	endMode = false
	canStomp = false //If they can use jumping as an attack
	sprite = sprCyra
	invincible = 0
	shapeStand = 0
	shapeSlide = 0
	shapeClimb = 0
	tftime = -1 //Timer for transformation
	energy = 0.0
	hidden = false
	jumpBuffer = 0
	rspeed = 0.0 //Run animation speed
	slideframe = 0.0 //Because using just frame gets screwy for some reason
	wasInWater = false
	cooldown = 0
	antigrav = 0
	groundx = 0.0 //Remember last coordinates over solid ground
	groundy = 0.0
	held = null
	slashing = false
	slashTimer = 0.0
	comboStep = 0
	comboTimer = 0

	//Animations
	anim = [] //Animation frame delimiters: [start, end, speed]
	anStand = [0, 1, 2, 3]
	anSkid = [4, 5]
	anPush = [6, 7]
	anHurt = [6, 7]
	anDie = [12, 13]
	anDive = [14, 15]
	anCrouch = [14, 15]
	anGetUp = [15, 14]
	anWalk = [16, 17, 18, 19, 20, 21, 22, 23]
	anRun = [24, 25, 26, 27, 28, 29, 30, 31]
	anJumpU = [32, 33]
	anJumpT = [34, 35]
	anFall = null
	anFallN = [36, 37]
	anCrawl = [40, 41, 42, 43, 42, 41]
	anClimb = [44, 45, 46, 47, 46, 45]
	anSwimF = [48, 49, 50, 51]
	anSwimUF = [48, 49, 50, 51]
	anSwimDF = [48, 49, 50, 51]
	anSwimU = [48, 49, 50, 51]
	anSwimD = [48, 49, 50, 51]
	anWall = [52, 53]
	anFallW = [53]
	anSlide = [60, 61, 62, 63]
	animOffset = 0.0

	mySprNormal = null
	mySprFire = null
	mySprIce = null
	mySprAir = null
	mySprEarth = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		anim = anStand
		shapeStand = Rec(x, y, 5, 16, 0, 0, 0)
		shapeClimb = Rec(x, y, 5, 12, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		if(!gvPlayer) gvPlayer = this
		startx = _x.tofloat()
		starty = _y.tofloat()
		energy = stats.maxEnergy
		anFall = anFallN
		xprev = x
		yprev = y

		mySprNormal = sprCyra
		mySprFire = sprCyraFire
		mySprIce = sprCyraIce
		mySprAir = sprCyraAir
		mySprEarth = sprCyraEarth
	}

	function physics() {}
	function routine() {}
	function animation() {}

	//Elemental resistances
	damageMultN = {
		normal = 1.0
		fire = 0.5
		ice = 1.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.5
		blast = 1.0
	}
	damageMultF = {
		normal = 1.0
		fire = 0.0
		ice = 2.0
		earth = 1.0
		air = 1.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.5
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
		cut = 0.5
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
		cut = 0.5
		blast = 0.5
	}
	damageMultE = {
		normal = 1.0
		fire = 1.0
		ice = 1.0
		earth = 0.50
		air = 2.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.25
		blast = 1.0
	}

	function run() {
		base.run()

		//Side checks
		shapeSlide.setPos(x, y)
		shapeStand.setPos(x, y)
		if(shape == shapeStand && !placeFree(x, y)) {
			shape = shapeSlide
			if(anim == anStand || anim == anWalk || anim == anRun) anim = anCrawl
		}
		local freeDown = placeFree(x, y + 1)
		local freeDown2 = placeFree(x, y + 2)
		local freeLeft = placeFree(x - 1, y)
		local freeRight = placeFree(x + 1, y)
		local freeUp = placeFree(x, y - 1)
		local nowInWater = inWater(x, y)
		//Checks are done at the beginning and stored here so that they can be
		//quickly reused. Location checks will likely need to be done multiple
		//times per frame.

		//Recharge
		if(firetime > 0 && stats.weapon != "air" && (stats.weapon != "earth" || anim != anSlide)) {
			firetime--
		}

		if(firetime == 0 && energy < stats.maxEnergy) {
			energy++
			firetime = 40
		}

		if(stats.weapon == "normal") stats.maxEnergy = 0
		if(stats.weapon == "air") stats.maxEnergy = 4 + game.airBonus
		if(energy > stats.maxEnergy) energy = stats.maxEnergy

		/////////////
		// ON LAND //
		/////////////
		if((!inWater(x, y) || stats.weapon == "earth") && resTime <= 0) {
			swimming = false
			shapeStand.h = 12.0

			//Animation states
			animOffset = 0.0
			switch(anim) {
				case anStand:
					if(stats.weapon == "ice" && floor(frame) == 0) frame += 0.01
					else if(stats.weapon == "ice" || stats.weapon == "fire") frame += 0.1
					else if(stats.weapon == "air") frame += 0.05
					else frame += 0.05

					if(abs(rspeed) > 0.1) {
						anim = anWalk
						frame = 0.0
					}

					if(placeFree(x, y + 2) && !onPlatform()) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
					}

					if(zoomies > 0) {
						animOffset = 118
						frame += 0.1
					}

					if(slashing) {
						frame = 0.0
						switch(comboStep) {
							case 0:
								animOffset = 118.0 + slashTimer
								break
							case 1:
								animOffset = 58.0 + slashTimer
								break
							case 2:
								animOffset = 122.0 + slashTimer
								break
							case 3:
								animOffset = 127.0 + slashTimer
								break
						}
					}
					break

				case anWalk:
					frame += abs(rspeed) / 10
					if(abs(rspeed) <= 0.1 || fabs(hspeed) <= 0.1) anim = anStand
					if(abs(rspeed) > 2.4) anim = anRun

					if(placeFree(x, y + 2) && !onPlatform()) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
					}

					if(slashing) {
						animOffset = (6.0 * 8.0) + (floor(slashTimer) * 8.0)
					}
					break

				case anRun:
					if(slashing) {
						animOffset = (8.0 * 8.0) + (floor(slashTimer) * 8.0)
					}
				case anSkid:
					if(flip == 0 && hspeed < 0) {
						hspeed += 0.05
						anim = anSkid
					}
					else if(flip == 1 && hspeed > 0) {
						hspeed -= 0.05
						anim = anSkid
					}
					else anim = anRun

					if(anim == anSkid) frame += 0.2
					else if(stats.weapon == "ice") frame += abs(rspeed) / 16
					else frame += abs(rspeed) / 10
					if(abs(rspeed) < 2 && anim != anSkid) anim = anWalk

					if(placeFree(x, y + 2) && !onPlatform()) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = 0.0
					}

					if(slashing && anim != anRun) {
						frame = 0
						animOffset = (112 - 4) + slashTimer
					}
					break

				case anPush:
					break

				case anJumpU:
					if(frame < 0.0 + 1) frame += 0.1

					if(!freeDown || (onPlatform() && vspeed >= 0)) {
						anim = anStand
						frame = 0.0
					}

					if(vspeed > 0) {
						anim = anJumpT
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						animOffset = (61 - 32) + slashTimer
					}
					break

				case anJumpT:
					frame += 0.2
					if(!freeDown || (onPlatform() && vspeed >= 0)) {
						anim = anStand
						frame = 0.0
					}

					if(frame > anim.len() - 1) {
						anim = anFall
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						animOffset = (61 - 34) + slashTimer
					}
					break

				case anFall:
					frame += 0.1
					if(!freeDown || (onPlatform() && vspeed >= 0)) {
						anim = anStand
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						if(anFall == anFallW) animOffset = (115 - 53) + floor(slashTimer)
						else animOffset = (61 - 36) + slashTimer
					}
					break

				case anWall:
					frame += 0.3
					vspeed = 0

					if(floor(frame) > anim.len() - 1) {
						vspeed = -5.0
						if(flip == 0) hspeed = 3.0
						else hspeed = -3.0
						anim = anJumpU
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						animOffset = (115 - 52) + slashTimer
					}
					break

				case anDive:
					frame += 0.25

					if(floor(frame) > anim.len() - 1) {
						anim = anSlide
						shape = shapeSlide
					}
					break

				case anCrouch:
					frame += 0.25

					if(floor(frame) > anim.len() - 1) {
						if(stats.weapon == "earth" && getcon("shoot", "hold", true, playerNum)) anim = anSlide
						else anim = anCrawl
						shape = shapeSlide
					}
					break

				case anGetUp:
					frame -= 0.25

					if(floor(frame) < 0) {
						anim = anStand
						shape = shapeStand
					}
					break

				case anSlide:
					if(stats.weapon == "earth") slideframe += abs(hspeed / 8.0)
					else slideframe += abs(hspeed / 16.0)
					frame = slideframe

					if(!freeDown && hspeed != 0) if(floor(getFrames() % 8 - fabs(hspeed)) == 0 || fabs(hspeed) > 8) {
						if(stats.weapon == "fire") newActor(FlameTiny, x - (8 * (hspeed / fabs(hspeed))), y + 10)
						if(stats.weapon == "ice") newActor(Glimmer, x - (12 * (hspeed / fabs(hspeed))), y + 10)
					}
					break

				case anHurt:
					frame += 0.1
					if(floor(frame) > anim.len() - 1) {
						anim = anStand
						frame = 0.0
					}
					break

				case anSwimF:
					anim = anJumpT
					frame = 0.0
					break

				case anSwimUF:
				case anSwimU:
					anim = anJumpU
					frame = 0.0
					vspeed -= 1
					if(getcon("jump", "hold", true, playerNum) && vspeed > -4) vspeed = -6
					break

				case anSwimDF:
				case anSwimD:
					anim = anFall
					frame = 0.0
					break
			}

			if(slashing) slashTimer += 0.2
			if(slashTimer >= 3) {
				slashTimer = 0.0
				slashing = false
			}

			if(anim != anClimb) frame = wrap(abs(frame), 0.0, anim.len() - 1)

			//Sliding acceleration
			if(anim == anSlide || onIce()) {
				if(!placeFree(x, y + 4) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && stats.weapon == "ice"))) {
					if(placeFree(x + 4, y + 2)) hspeed += accel * 1.1
					if(placeFree(x - 4, y + 2)) hspeed -= accel * 1.1
					if(freeDown2)vspeed += 1.0
					//if(!placeFree(x + hspeed, y) && placeFree(x + hspeed, y - abs(hspeed / 2)) && anim == anSlide) vspeed -= 0.25
				}
				else if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2

				if(((!getcon("down", "hold", true, playerNum) || fabs(hspeed) < 0.05) && !freeDown && stats.weapon != "earth") || (fabs(hspeed) < 0.05 && (stats.weapon == "earth" && !getcon("shoot", "hold", true, playerNum))) || (stats.weapon == "earth" && !getcon("shoot", "hold", true, playerNum) && !getcon("down", "hold", true, playerNum))) if(anim == anSlide || anim == anDive) anim = anWalk
			}

			if(anim != anClimb && anim != anWall && !slashing) {
				if((getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum) && anim != anSlide && canMove) || (hspeed > 0.1 && anim == anSlide)) flip = 0
				if((getcon("left", "hold", true, playerNum) && !getcon("right", "hold", true, playerNum) && anim != anSlide && canMove) || (hspeed < -0.1 && anim == anSlide)) flip = 1
			}

			//Controls
			if(!freeDown2 || onPlatform() || anim == anClimb) {
				canJump = 16
				if(stats.weapon == "air" && energy < stats.maxEnergy) energy += 0.2
			}
			else {
				if(canJump > 0) canJump--
				if(stats.weapon == "air" && energy < 1) energy += 0.02
			}
			if(canMove) {
				if(stats.weapon == "ice") mspeed = 3.5
				else mspeed = 3.0
				if((getcon("run", "hold", true, playerNum) || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) && anim != anCrawl) {
					if(stats.weapon == "ice") mspeed = 3.5
					else mspeed = 3.0
				}
				if(anim == anCrawl) mspeed = 1.0
				if(nowInWater) mspeed *= 0.8
				if(zoomies > 0) mspeed *= 2.0

				//Moving left and right
				if(zoomies > 0) accel = 0.4
				else accel = 0.2

				if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(hspeed >= 2) {
						if(onIce()) hspeed += accel * 0.2
						else hspeed += accel * 0.4
					}
					else if(onIce()) hspeed += accel / 2.0
					else hspeed += accel
				}

				if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) {
					if(hspeed <= -2) {
						if(onIce()) hspeed -= accel * 0.2
						else hspeed -= accel * 0.4
					}
					else if(onIce()) hspeed -= accel / 2.0
					else hspeed -= accel
				}

				//Change run animation speed
				if(getcon("right", "hold", true, playerNum) && rspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(freeRight || placeFree(x + 1, y - 2)) {
					rspeed += 0.2
					if(rspeed < hspeed) rspeed = hspeed
				}
				if(getcon("left", "hold", true, playerNum) && rspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt && anim != anClimb && anim != anSkid) if(freeLeft || placeFree(x - 1, y - 2)) {
					rspeed -= 0.2
					if(rspeed > hspeed) rspeed = hspeed
				}
				if(rspeed > 0) rspeed -= 0.1
				if(rspeed < 0) rspeed += 0.1
				if((abs(rspeed) <= 0.5 || hspeed == 0) && !getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum)) rspeed = 0.0
				if(anim == anSlide) rspeed = hspeed

				//On a ladder
				if(anim == anClimb) {
				shape = shapeClimb
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

					//Check if still on ladder
					local felloff = true
					if(atLadder()) felloff = false
					if(felloff) {
						anim = anFall
						frame = 0.0
						if(getcon("up", "hold", true, playerNum)) vspeed = -2.5
					}

					//Change direction
					if(getcon("right", "press", true, playerNum) && canMove) flip = 0
					if(getcon("left", "press", true, playerNum) && canMove) flip = 1

					//Ping-pong animation
				}

				//Get on ladder
				if(((getcon("down", "hold", true, playerNum) && placeFree(x, y + 2)) || getcon("up", "hold", true, playerNum)) && anim != anHurt && anim != anClimb && (vspeed >= 0 || getcon("down", "press", true, playerNum) || getcon("up", "press", true, playerNum))) {
					if(atLadder()) {
						anim = anClimb
						frame = 0.0
						hspeed = 0
						vspeed = 0
						x = (x - (x % 16)) + 8
					}
				}

				//Jumping
				if(getcon("jump", "press", true, playerNum) || jumpBuffer > 0) {
					if(onPlatform() && !placeFree(x, y + 1) && getcon("down", "hold", true, playerNum)) {
						y++
						canJump = 32
						if(!placeFree(x, y) && !placeFree(x, y - 1)) y--
					}
					else if(canJump > 0) {
						jumpBuffer = 0
						if(anim == anClimb) vspeed = -3
						else if(stats.weapon == "air" || nowInWater) vspeed = -5.0
						else vspeed = -5.8
						didJump = true
						if(stats.weapon != "air") canJump = 0
						if(anim != anHurt && anim != anDive && (stats.weapon != "earth" || anim != anSlide)) {
							anim = anJumpU
							frame = 0.0
						}
						if(stats.weapon != "air") {
							stopSound(sndJump)
							playSound(sndJump, 0)
						}
						else {
							stopSound(sndFlap)
							playSound(sndFlap, 0)
						}
					}
					else if(freeDown && anim != anClimb && !placeFree(x - 2, y) && anim != anWall && hspeed <= 0 && tileGetSolid(x - 12, y - 12) != 40 && tileGetSolid(x - 12, y + 12) != 40 && tileGetSolid(x - 12, y) != 40) {
						flip = 0
						anim = anWall
						frame = 0.0
						playSound(sndWallkick, 0)
					}
					else if(freeDown && anim != anClimb && !placeFree(x + 2, y) && anim != anWall && hspeed >= 0 && tileGetSolid(x + 12, y - 12) != 40 && tileGetSolid(x + 12, y + 12) != 40 && tileGetSolid(x + 12, y) != 40) {
						flip = 1
						anim = anWall
						frame = 0.0
						playSound(sndWallkick, 0)
					}
					else if(floor(energy) > 0 && stats.weapon == "air" && getcon("jump", "press", true, playerNum)) {
						if(vspeed > 0) vspeed = 0.0
						if(vspeed > -4) vspeed -= 3.0
						didJump = true
						if(stats.weapon != "air") canJump = 0
						if(anim != anHurt && anim != anDive) {
							anim = anJumpU
							frame = 0.0
						}
						if(stats.weapon != "air") {
							stopSound(sndJump)
							playSound(sndJump, 0)
						}
						else {
							stopSound(sndFlap)
							playSound(sndFlap, 0)
						}
						energy--
					}
				}

				//Wall slide
				if((anim == anFallN || anim == anFallW) && ((getcon("left", "hold", true, playerNum) && !freeLeft) || (getcon("right", "hold", true, playerNum) && !freeRight))) {
					if(!freeLeft && !(onIce(x - 8, y) || onIce(x - 8, y - 16))) {
						if(vspeed > 0.5) vspeed = 0.5
						if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x - 4, y + 12)
						anFall = anFallW
						anim = anFallW
						flip = 0
					}
					if(!freeRight && !(onIce(x + 8, y) || onIce(x + 8, y - 16))) {
						if(vspeed > 0.5) vspeed = 0.5
						if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x + 4, y + 12)
						anFall = anFallW
						anim = anFallW
						flip = 1
					}
				} else {
					anFall = anFallN
					if(anim == anFallW) anim = anFallN
				}

				if(getcon("jump", "press", true, playerNum) && jumpBuffer <= 0 && freeDown) jumpBuffer = 8
				if(jumpBuffer > 0) jumpBuffer--

				if(getcon("jump", "release", true, playerNum) && vspeed < 0 && didJump)
				{
					didJump = false
					vspeed /= 2.5
				}

				//Going into slide
				if(((getcon("shoot", "hold", true, playerNum) && stats.weapon == "earth")) && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt && anim != anWall && anim != anCrouch && anim != anCrawl) {
					if(placeFree(x + 2, y + 1) || hspeed >= 1.5) {
						anim = anDive
						frame = 0.0
						flip = 0
						playSoundChannel(sndSlide, 0, 0)
					}

					if(placeFree(x - 2, y + 1) || hspeed <= -1.5) {
						anim = anDive
						frame = 0.0
						flip = 1
						playSoundChannel(sndSlide, 0, 0)
					}
				}

				//Crawling
				if(getcon("down", "hold", true, playerNum) && anim != anDive && anim != anSlide && anim != anJumpU && anim != anJumpT && anim != anFall && anim != anHurt && anim != anWall && (!freeDown2 || onPlatform()) && anim != anCrouch && anim != anCrawl) {
					anim = anCrouch
					frame = 0.0
					shape = shapeSlide
				}

				if(anim == anCrawl) {
					if(!getcon("down", "hold", true, playerNum) && placeFree(x, y - 6)) anim = anStand
					else {
						//Ping pong animation
						frame += (hspeed / 8.0)
						shape = shapeSlide
					}
				}
			}
			else rspeed = min(rspeed, abs(hspeed))

			//Movement
			if(!placeFree(x, y + 2) || onPlatform()) {
				if(anim == anSlide) {
					if(hspeed > 0) hspeed -= friction / 3.0
					if(hspeed < 0) hspeed += friction / 3.0
				} else {
					if(hspeed > 0) {
						if(!(mspeed > 2 && getcon("right", "hold", true, playerNum)) || anim == anCrawl || !canMove) hspeed -= friction
					}
					if(hspeed < 0) {
						if(!(mspeed > 2 && getcon("left", "hold", true, playerNum)) || anim == anCrawl || !canMove) hspeed += friction
					}
				}
			}
			else if(anim != anSlide) {
				if(hspeed > 0 && !getcon("right", "hold", true, playerNum)) hspeed -= friction / 3.0
				if(hspeed < 0 && !getcon("left", "hold", true, playerNum)) hspeed += friction / 3.0
			}

			if(fabs(hspeed) < friction) hspeed = 0.0
			if(placeFree(x, y + 2) && (vspeed < 2 || (vspeed < 5 && (stats.weapon != "air" || getcon("down", "hold", true, playerNum)) && !nowInWater)) && antigrav <= 0) vspeed += gravity
			else if(antigrav > 0) antigrav--
			if(!freeUp && vspeed < 0) vspeed = 0.0 //If Cyra bumped his head

			//Entering water
			if(nowInWater && !wasInWater) {
				wasInWater = true
				vspeed /= 2.0
				newActor(Splash, x, y)
			}
			if(!nowInWater && wasInWater) {
				wasInWater = false
				newActor(Splash, x, y)
			}


			if(anim == anSlide && !freeDown && vspeed >= 0 && placeFree(x + hspeed, y)) {
				//If Cyra hits the ground while sliding
				if(flip) hspeed -= vspeed / 2.5
				else hspeed += vspeed / 2.5
				vspeed = 0
			}

			//Max ground speed
			if(!freeDown){
				if(stats.weapon == "ice") {
					if(hspeed > 8) hspeed = 8
					if(hspeed < -8) hspeed = -8
				}
				else {
					if(hspeed > 6) hspeed = 6
					if(hspeed < -6) hspeed = -6
				}
			}

			//Gravity cases
			if(stats.weapon == "air" || nowInWater) gravity = 0.12
			else gravity = 0.25
			if(anim == anClimb || anim == anWall) gravity = 0


			if(canMove) switch(stats.weapon) {
				case "normal":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && cooldown == 0) {
						cooldown = 16
						local fx = 6
						local fy = 0
						if(anim == anCrouch) fy = 6
						if(anim == anCrawl) fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(SwordWaveCS, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 8
						else c.hspeed = -8
						c.vspeed = 0
						playSound(sndCyraSwordSwing, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break
				case "fire":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == anCrouch) fy = 6
						if(anim == anCrawl) fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(FireballCS, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 8
						else c.hspeed = -8
						c.vspeed = 0
						playSound(sndCyraFireSwing, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "ice":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == anCrouch) fy = 6
						if(anim == anCrawl) fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(FreezeWaveCS, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 8
						else c.hspeed = -8
						c.vspeed = 0
						playSound(sndCyraTornado, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "air":
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && cooldown == 0) {
						cooldown = 16
						local fx = 6
						local fy = 0
						if(anim == anCrouch) fy = 6
						if(anim == anCrawl) fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(SwordWaveCS, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 8
						else c.hspeed = -8
						c.vspeed = 0
						playSound(sndCyraTornado, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "earth":
					if(getcon("shoot", "press", true, playerNum) && (anim != anHurt)) {
						anim = anDive
						frame = 0.0
						playSoundChannel(sndSlide, 0, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					break
			}

			if(cooldown > 0) cooldown--
			if(comboTimer > 0) comboTimer--
			if(comboTimer == 0) comboStep = 0

			//Check solid ground position
			if(!placeFree(x, y + 1) && !onPlatform()) {
				groundx = x
				groundy = y
			}
		}
		//////////////
		// IN WATER //
		//////////////
		else {
			swimming = true
			shapeStand.h = 6.0
			if(stats.weapon == "air" && energy < 4) energy += 0.1
			if(!wasInWater) {
				wasInWater = true
				vspeed /= 2.0
				newActor(Splash, x, y)
			}
			anFall = anFallN
			if(anim == anFallW) anim = anFallN

			//Animation states
			switch(anim) {
				case anSwimF:
				case anSwimU:
				case anSwimD:
				case anSwimUF:
				case anSwimDF:
					frame += sqrt(abs(hspeed * hspeed) + abs(vspeed * vspeed)) / 12
					break
				case anHurt:
					frame += 0.2
					if(floor(frame) > anim.len() - 1) {
						anim = anFall
						frame = 0.0
					}
					break
				case anFall:
					frame += 0.01
					break
			}

			frame = wrap(abs(frame), 0.0, anim.len() - 1)

			//Swich swim directions
			if(anim != anHurt) {
				if(fabs(hspeed) < 0.3 && fabs(vspeed) < 0.2) anim = anFall //To be replaced with regular swim sprites later
				if(fabs(hspeed) > 0.3) anim = anSwimF
				if(vspeed > 0.2) anim = anSwimD
				if(vspeed < -0.2) anim = anSwimU
				if(fabs(hspeed) > 0.3 && vspeed > 0.2) anim = anSwimDF
				if(fabs(hspeed) > 0.3 && vspeed < -0.2) anim = anSwimUF
			}

			//Movement
			if(canMove) {
				mspeed = 2.0
				if(zoomies > 0) mspeed *= 2.0

				if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed += accel
				if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) hspeed -= accel
				if(getcon("down", "hold", true, playerNum) && vspeed < mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed += accel
				if(getcon("up", "hold", true, playerNum) && vspeed > -mspeed && anim != anWall && anim != anSlide && anim != anHurt) vspeed -= accel
			}

			//Friction
			if(hspeed > 0) hspeed -= friction / 2
			if(hspeed < 0) hspeed += friction / 2
			if(fabs(hspeed) < friction / 2) hspeed = 0.0
			if(vspeed > 0) vspeed -= friction / 2
			if(vspeed < 0) vspeed += friction / 2
			if(fabs(vspeed) < friction / 2) vspeed = 0.0
			if(vspeed > 4) vspeed -= 0.2

			//Change facing
			if(anim != anClimb && anim != anWall) {
				if(hspeed > 0.1) flip = 0
				if(hspeed < -0.1) flip = 1
			}

			//Attacks
			if(canMove) switch(stats.weapon) {
				case 1:
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = fireWeapon(Fireball, x + fx, y - 4, 1, id)
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -3
							}
						}
						if(getcon("down", "hold", true, playerNum)) {
							c.vspeed = 3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = 3
							}
						}

						c.hspeed += hspeed / 3
						c.vspeed += vspeed / 3

						energy--
						firetime = 60
					}
					break

				case 2:
					if(getcon("shoot", "press", true, playerNum) && anim != anSlide && anim != anHurt && energy > 0) {
						local fx = 6
						if(flip == 1) fx = -5
						local c = fireWeapon(Iceball, x + fx, y, 1, id)
						if(!flip) c.hspeed = 3
						else c.hspeed = -3
						playSound(sndFireball, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = -3
							}
						}
						if(getcon("down", "hold", true, playerNum)) {
							c.vspeed = 3
							if(hspeed != 0) c.hspeed *= 0.75
							else {
								c.hspeed = 0
								c.vspeed = 3
							}
						}

						c.hspeed += hspeed / 2
						c.vspeed += vspeed / 2

						energy--
						firetime = 60
					}
					break
			}
		}

		//Swap item
		if(canMove && getcon("swap", "press", true, playerNum)) swapitem()

		//Base movement
		shape.setPos(x, y)
		xprev = x
		yprev = y

		if(placeFree(x, y + vspeed)) y += vspeed
		else {
			vspeed /= 2
			if(fabs(vspeed) < 0.01) vspeed = 0
			//if(fabs(vspeed) > 1) vspeed -= vspeed / fabs(vspeed)
			if(placeFree(x, y + vspeed)) y += vspeed
		}

		if(hspeed != 0) {
			if(placeFree(x + hspeed, y)) { //Try to move straight
				for(local i = 0; i < 4; i++) if(!placeFree(x, y + 4) && placeFree(x + hspeed, y + 1) && !swimming && vspeed >= 0 && !placeFree(x + hspeed, y + 4)) {
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
						break
					}
				}

				//If no step was taken, slow down
				if(didstep == false && fabs(hspeed) >= 1) hspeed -= (hspeed / fabs(hspeed))
				else if(didstep == false && fabs(hspeed) < 1) hspeed = 0
			}
		}

		if(!gvCanWrap) {
			if(x < 4) x = 4
			if(x > gvMap.w - 4) x = gvMap.w - 4
		} else x = wrap(x, 0, gvMap.w)

		if(anim == anSlide || anim == anCrawl) shape = shapeSlide
		else shape = shapeStand
		shapeStand.setPos(x, y)
		shapeSlide.setPos(x, y)
		if(y > gvMap.h + 16) {
			die()
			return
		}
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
				break
			case -2:
				if(hspeed > 0) hspeed = 0
				break
		}

		//Set ice friction
		if(onIce()) friction = 0.01
		else friction = 0.1


		//Hurt
		if(onHazard(x, y)) hurt = 1 + game.difficulty
		if(onDeath(x, y)) stats.health = 0

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(stats.weapon == "earth" && anim == anSlide && energy > 0) {
					energy--
					firetime = 120
					newActor(Spark, x, y)
				}
				else {
					if(stats.health > 0) stats.health -= hurt
					if(flip == 0) hspeed = -2.0
					else hspeed = 2.0
					anim = anHurt
					frame = 0.0
				}
			}
			hurt = 0
		}
		else hurt = 0
		if(blinking > 0) blinking--
		if(stats.health == 0) {
			die()
			return
		}

		//Transformation flash
		if(tftime != -1) {
			if(tftime < 4) {
				if(!hidden) drawSpriteZ(1, sprTFflash, tftime, x - camx, y - camy)
				tftime += 0.25
			} else tftime = -1
		}

		hidden = false
	}

	function draw() {
		if(!hidden) {
			switch(stats.weapon) {
				case 0:
					sprite = mySprNormal
					damageMult = damageMultN
					canStomp = false
					break

				case 1:
					sprite = mySprFire
					damageMult = damageMultF
					canStomp = false
					break

				case 2:
					sprite = mySprIce
					damageMult = damageMultI
					canStomp = false
					break

				case 3:
					sprite = mySprAir
					damageMult = damageMultA
					canStomp = false
					break

				case 4:
					sprite = mySprEarth
					damageMult = damageMultE
					canStomp = true
					break
			}

			//Invincibility
			if(invincible > 0) invincible--
			if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))

			if(anim != null) {
				frame = wrap(frame, 0, anim.len() - 1)
				if(blinking == 0 || anim == anHurt) drawSpriteExZ(0, sprite, anim[floor(frame)] + animOffset, x - camx, y - camy, 0, flip, 1, 1, 1)
				else drawSpriteExZ(0, sprite, anim[floor(frame)] + animOffset, x - camx, y - camy, 0, flip, 1, 1, wrap(blinking, 0, 10).tofloat() / 10.0)
			}
			if(debug) {
				setDrawColor(0x008000ff)
				shape.draw()
			}

			//After image
			if((zoomies > 0) && getFrames() % 2 == 0) newActor(AfterImage, x, y, [sprite, anim[frame] + animOffset, 0, flip, 0, 1, 1])
		}

		drawLight(sprLightBasic, 0, x - camx, y - camy)
	}

	function atLadder() {
		//Save current location and move
		local ns = Rec(x + shape.ox, y + shape.oy, shape.w, shape.h, shape.kind)
		local cx = floor(x / 16)
		local cy = floor(y / 16)

		//Check that the solid layer exists
		local wl = null //Working layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				wl = gvMap.data.layers[i]
				break
			}
		}

		//Check against places in solid layer
		if(wl != null) {
			local tile = cx + (cy * wl.width)
			if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 29 || wl.data[tile] - gvMap.solidfid == 50) {
				gvMap.shape.setPos((cx * 16) + 8, (cy * 16) + 8)
				gvMap.shape.kind = 0
				gvMap.shape.w = 1.0
				gvMap.shape.h = 12.0
				if(hitTest(ns, gvMap.shape)) return true
			}
		}

		return false
	}

	function die() {
		if(resTime > 0) return
		if(stats.canres) {
			stats.health = game.maxHealth
			blinking = 120
			hspeed = 0.0
			vspeed = 0.0
			if(y > gvMap.h) {
				invincible = 300
				resTime = 300
				vspeed = -4.0
			}
			stats.canres = false
		}
		else {
			deleteActor(id)
			gvPlayer = false
			newActor(DeadPlayer, x, y, [sprite, anDie, playerNum])
			stats.health = 0
		}
	}

	function _typeof(){ return "Cyra" }
}

////////////////////
// CYRA'S WEAPONS //
////////////////////

::SwordWaveCS <- class extends WeaponEffect{
	timer = 10
	angle = 0
	element = "normal"
	power = 1
	shape = 0
	blast = true
	piercing = 10

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 6)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!inWater(x, y)) vspeed += 0.1

		x += hspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, 0)

		shape.setPos(x, y)

	}
	function draw() {
		drawSpriteEx(sprCyraSwordWave, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprCyraSwordWave, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		popSound(sndBump)
		newActor(Poof, x, y)
	}
}


::FireballCS <- class extends WeaponEffect {
	timer = 15
	angle = 0
	element = "fire"
	power = 1
	blast = false
	piercing = 10

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 6)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!inWater(x, y)) vspeed += 0.1
		if(getFrames() % 3 == 0) {
			local c = actor[newActor(FlameTiny, x - 4 + randInt(8), y - 4 + randInt(8))]
			c.frame = 4
		}
		x += hspeed
		//y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, 0)

		shape.setPos(x, y)

	}
	function draw() {
		drawSpriteEx(sprCyraFireWave, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprCyraFireWave, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		fireWeapon(ExplodeF, x, y, alignment, owner)
	}
}


::FreezeWaveCS <- class extends WeaponEffect {
	timer = 15
	angle = 0
	element = "ice"
	power = 1
	blast = false
	piercing = 10

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Cir(x, y, 6)
	}

	function run() {
		timer--
		if(timer == 0) deleteActor(id)

		if(!inWater(x, y)) vspeed += 0.1
		if(getFrames() % 5 == 0) newActor(Glimmer, x - 4 + randInt(8), y - 4 + randInt(8))

		x += hspeed
		//y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, 0)

		shape.setPos(x, y)

	}
	function draw() {
		drawSpriteEx(sprCyraFreezeWave, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprCyraFreezeWave, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function destructor() {
		fireWeapon(ExplodeI, x, y, alignment, owner)
	}
}

