::Tux <- class extends Player {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
	friction = 0.1
	gravity = 0.0
	frame = 0.0
	flip = 0
	canMove = true //If player has control
	mspeed = 4 //Maximum running speed
	climbdir = 1.0
	blinking = 0 //Invincibility frames
	startx = 0.0
	starty = 0.0
	firetime = 0
	hurt = 0
	swimming = false
	sliding = false
	endMode = false
	canStomp = true //If they can use jumping as an attack
	sprite = sprTux
	invincible = 0
	shapeStand = 0
	shapeSlide = 0
	tftime = -1 //Timer for transformation
	energy = 0.0
	hidden = false
	jumpBuffer = 0
	rspeed = 0.0 //Run animation speed
	slideframe = 0.0 //Because using just frame gets screwy for some reason
	wasInWater = false
	antigrav = 0
	groundx = 0.0 //Remember last coordinates over solid ground
	groundy = 0.0

	//Animations
	anStandN = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 77, 78, 79, 80, 79, 80, 79, 80, 79, 80, 79, 78, 77]
	anStandF = [0, 1, 2, 3]
	anStandI = [0, 1, 2, 3]
	anStandA = [0, 1, 2, 3]
	anStandE = [0, 1, 2, 3]
	anWalk = [8, 9, 10, 11, 12, 13, 14, 15]
	anRun = [16, 17, 18, 19, 20, 21, 22, 23]
	anDive = [24, 25]
	anSlide = [26, 27, 28, 29]
	anHurt = [30, 31]
	anJumpU = [32, 33]
	anJumpT = [34, 35]
	anFall = null
	anFallN = [36, 37]
	anFallW = [48]
	anSwimF = [52, 53, 54, 55]
	anSwimUF = [56, 57, 58, 59]
	andSwimDF = [60, 61, 62, 63]
	anSwimU = [64, 65, 66, 67]
	anSwimD = [68, 69, 70, 71]
	anSkid = [4, 5]
	anPush = [6, 7]

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		anim = anStand
		shapeStand = Rec(x, y, 5, 12, 0, 0, 0)
		shapeCrouch = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		energy = game.maxEnergy
		anFall = anFallN
		routine = ruNormal
	}

	function physics() {
		//Reset state variables
		swimming = false
		if(inWater(x, y) && game.weapon != 4) swimming = true
		sliding = false
		if(anim == anDive || anim == anSlide || onIce()) sliding = true

		local freeDown = placeFree(x, y + 1)
		local freeDown2 = placeFree(x, y + 2)
		local freeLeft = placeFree(x - 1, y)
		local freeRight = placeFree(x + 1, y)
		local freeUp = placeFree(x, y - 1)
		local nowInWater = inWater(x, y)

		//Side checks
		shapeCrouch.setPos(x, y)
		shapeStand.setPos(x, y)
		if(shape == shapeStand && !placeFree(x, y)) {
			shape = shapeCrouch
			if(anim == anStand || anim == anWalk || anim == anRun) anim = anCrawl
		}

		if(swimming) {
		}
		else { //Not swimming
			shapeStand.h = 12.0

			//Sliding acceleration
			if(sliding) {
				if(!placeFree(x, y + 4) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && game.weapon == 2))) {
					if(placeFree(x + 4, y + 2)) hspeed += 0.25
					if(placeFree(x - 4, y + 2)) hspeed -= 0.25
					if(freeDown2)vspeed += 1.0
					//if(!placeFree(x + hspeed, y) && placeFree(x + hspeed, y - abs(hspeed / 2)) && anim == anSlide) vspeed -= 0.25
				}
				else if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2

				
				
			}
		}

		base.physics()
	}

	function animation() {
		if(swimming) {
			switch(anim) {
				case anStand:
					if(game.weapon == 2 && floor(frame) == 0) frame += 0.01
					else if(game.weapon == 2 || game.weapon == 1) frame += 0.1
					else if(game.weapon == 3) frame += 0.05
					else frame += 0.05

					if(abs(rspeed) > 0.1) {
						anim = anWalk
						frame = anim[0]
					}

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}
					break

				case anWalk:
					frame += abs(rspeed) / 8
					if(abs(rspeed) <= 0.1 || fabs(hspeed) <= 0.1) anim = anStand
					if(abs(rspeed) > 2.4) anim = anRun

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}
					break

				case anRun:
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
					else if(game.weapon == 2) frame += abs(rspeed) / 16
					else frame += abs(rspeed) / 8
					if(abs(rspeed) < 2 && anim != anSkid) anim = anWalk

					if(placeFree(x, y + 2)) {
						if(vspeed >= 0) anim = anFall
						else anim = anJumpU
						frame = anim[0]
					}

					break

				case anPush:
					break

				case anJumpU:
					if(frame < anim[0] + 1) frame += 0.1

					if(!freeDown) {
						anim = anStand
						frame = 0.0
					}

					if(vspeed > 0) {
						anim = anJumpT
						frame = anim[0]
					}
					break

				case anJumpT:
					frame += 0.2
					if(!freeDown) {
						anim = anStand
						frame = 0.0
					}

					if(frame > anim[1]) {
						anim = anFall
						frame = anim[0]
					}
					break

				case anFall:
					frame += 0.1
					if(!freeDown) {
						anim = anStand
						frame = 0.0
					}
					break

				case anWall:
					frame += 0.3
					vspeed = 0

					if(floor(frame) > anim[1]) {
						vspeed = -5.0
						if(flip == 0) hspeed = 3.0
						else hspeed = -3.0
						anim = anJumpU
						frame = anim[0]
					}

					if(!freeLeft) flip = 0
					if(!freeRight) flip = 1
					break

				case anDive:
					frame += 0.25

					if(floor(frame) > anim[1]) {
						if(fabs(hspeed) < 0.5 && game.weapon != 4) anim = anCrawl
						else anim = anSlide
						shape = shapeCrouch
					}
					break

				case anSlide:
					if(game.weapon == 4) slideframe += abs(hspeed / 8.0)
					else slideframe += abs(hspeed / 24.0)
					frame = slideframe

					if(!freeDown && hspeed != 0) if(floor(getFrames() % 8 - fabs(hspeed)) == 0 || fabs(hspeed) > 8) {
						if(game.weapon == 1) newActor(FlameTiny, x - (8 * (hspeed / fabs(hspeed))), y + 10)
						if(game.weapon == 2) newActor(Glimmer, x - (12 * (hspeed / fabs(hspeed))), y + 10)
					}
					break

				case anHurt:
					frame += 0.1
					if(floor(frame) > anim[1]) {
						anim = anStand
						frame = anim[0]
					}
					break

				case anSwimF:
					anim = anJumpT
					frame = anim[0]
					break

				case anSwimUF:
				case anSwimU:
					if(fabs(hspeed) > 1.5) anim = anSlide
					else anim = anJumpU
					frame = anim[0]
					vspeed -= 1
					if(getcon("jump", "hold") && vspeed > -4) vspeed = -6
					break

				case anSwimDF:
				case anSwimD:
					anim = anFall
					frame = anim[0]
					break
			}
		}
		else {

		}
	}

	function ruNormal() {
		if(sliding) {
			if(((!getcon("down", "hold") && !autocon.down || fabs(hspeed) < 0.05) && !freeDown && game.weapon != 4) || (fabs(hspeed) < 0.05 && (game.weapon == 4 && !getcon("shoot", "hold"))) || (game.weapon == 4 && !getcon("shoot", "hold") && !getcon("down", "hold") && !autocon.down)) if(anim == anSlide || anim == anCrawl) {
				if(getcon("down", "hold") || autocon.down|| !placeFree(x, y - 8) || autocon.down) anim = anCrawl
				else anim = anWalk
			}

			if(getcon("jump", "press") || getcon("up", "press")) if(!getcon("shoot", "hold")) if(placeFree(x, y + 2) && placeFree(x, y - 2)) anim = anFall
		}
		//Recharge
		if(firetime > 0 && game.weapon != 3 && (game.weapon != 4 || anim != anSlide)) {
			firetime--
		}

		if(firetime == 0 && energy < game.maxEnergy) {
			energy++
			firetime = 60
		}

		if(game.weapon == 0) game.maxEnergy = 0
		if(game.weapon == 3) game.maxEnergy = 4 + game.airBonus
		if(energy > game.maxEnergy) energy = game.maxEnergy
	}

	function ruLocked() {}
}