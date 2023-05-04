/*==========*\
| MIDI ACTOR |
\*==========*/

::Midi <- class extends Player {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
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
	canStomp = true //If they can use jumping as an attack
	stompDamage = 0
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
	slippery = false
	accel = 0.2
	shootTimer = 0.0
	shooting = 0
	shootDir = 0
	boredom = 0
	chargeTimer = 0
	fallTimer = 0
	hurtThreshold = 4
	spinAlpha = 0.0
	hand = 0

	freeDown = false
	freeDown2 = false
	freeLeft = false
	freeRight = false
	freeUp = false
	nowInWater = false

	an = {
		stand = null
		standB = [0, 0, 0, 0, 0, 0, 0, 0, 238, 238, 238, 238, 238, 238, 238, 238, 0, 0, 0, 0, 180, 181, 180, 181, 180, 181, 180, 181, 0, 0, 0, 0, 0, 0, 0, 6, 87, 175, 175, 175, 175, 175, 175, 175, 175, 175, 175, 175, 175, 175, 175, 175, 175, 87, 6]
		standN = [1, 2, 3, 4]
		standW = [204, 204, 204, 205, 206, 206, 206, 207]
		standHold = [5]
		crouch = [6]
		crouchHold = [7]
		jump = null
		jumpU = [8, 9]
		jumpT = [10, 11]
		fall = null
		fallN = [12, 13]
		fallW = [162]
		hurt = null
		hurtLight = [14, 15]
		hurtHeavy = [166, 167]
		walk = [16, 17, 18, 19, 20, 21, 22, 23]
		run = [48, 49, 50, 51, 52, 53, 54, 55]
		shootAir = [64, 65, 66, 67]
		shootTop = [68, 69, 70, 71]
		climb = [72, 73, 74, 75, 74, 73]
		climb2 = [76, 77]
		attackAir = [78, 79, 80, 81]
		plantMine = [82, 83, 84, 85, 86, 87]
		attack = null
		shootF1 = [88, 89, 90, 91]
		shootF2 = [92, 93, 94, 95]
		shootU1 = [96, 97, 98, 99]
		shootU2 = [100, 101, 102, 103]
		shootUF1 = [104, 105, 106, 107]
		shootUF2 = [108, 109, 110, 111]
		shootDF1 = [112, 113, 114, 115]
		shootDF2 = [116, 117, 118, 119]
		shootAU1 = [120, 121, 122, 123]
		shootAU2 = [124, 125, 126, 127]
		shootAD1 = [128, 129, 130, 131]
		shootAD2 = [132, 133, 134, 135]
		attackD = [136, 137, 138, 139]
		attackU = [140, 141, 142, 143]
		attackSpin = [144, 145, 146, 147]
		shootMad = [148, 149, 150, 151]
		jumpR = [152, 153, 154, 155, 156, 157, 158, 159]
		ride = [160, 161]
		wall = [162, 163]
		skid = [164, 165]
		float = [168, 169]
		swim = [170, 171, 172, 173]
		sit = null
		sitChair = [174]
		sitGround = [175]
		lift = [176, 177] //"Elevator" for you 'murricans
		door = [178, 179]
		scratch = [180, 181]
		morphIn = [182, 183]
		morphOut = [183, 182]
		ball = [184, 185, 186, 187]
		ballV = [188, 189, 190, 191]
		ballD = [192, 193, 194, 195]
		ballH = [196, 197, 198, 199]
		ballT = [200, 201, 202, 203]
		climbWall = [208, 209, 210, 211, 210, 209]
		ledge = [212]
		hang = [213]
		shootHang = [214, 215, 216, 217]
		monkey = [218, 219, 220, 221, 222, 223]
		shootClimb = [224, 225, 226, 227]
		armShoot = [228, 229, 230, 231]
		landing = [232, 233, 234, 235]
		wave = [236, 237]
		pick = [238, 239]
	}
	animOffset = 0.0

	sprite = sprMidi
	aura = sprMidiAura
	auraColor = 0xffffffff

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
		cut = 1.5
		blast = 0.5
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
		cut = 1.5
		blast = 0.5
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
		cut = 1.5
		blast = 0.5
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
		cut = 1.5
		blast = 0.5
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
		cut = 1.5
		blast = 0.5
	}

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		an.stand = an.standN
		anim = "stand"
		shapeStand = Rec(x, y, 5, 12, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		startx = _x.tofloat()
		starty = _y.tofloat()
		energy = stats.maxEnergy
		an.fall = an.fallN
		xprev = x
		yprev = y
		routine = ruNormal
	}

	function physics() {
		if(vspeed > 0) didJump = false
		if(nowInWater) gravity = 0.12
		else gravity = 0.25
		
		switch(anim) {
			case "float":
			case "swim":
				gravity = 0.0
				break
			case "wall":
			case "climb":
			case "climbWall":
			case "shootClimb":
				gravity = 0.0
				vspeed = 0.0
				break
			case "ledge":
				gravity = 0.0
				if(!getcon("down", "hold", true, playerNum)) vspeed = 0.0
				y = (floor(y / 16.0) * 16.0) + 14.0
				if(freeRight && freeLeft) anim = "jumpT"
				break
			case "hurt":
				if(nowInWater) vspeed /= 9.0
				break
			case "monkey":
				gravity = 0.0
				vspeed = 0.0
				if(shooting) hspeed = 0.0
				if(hspeed > 1) hspeed = 1.0
				if(hspeed < -1) hspeed = -1.0

				//Line alignment
				local lineType = 0
				if(atZipline()) lineType = tileGetSolid(x, y - shape.h)
				else if(atZipline(0, -1)) lineType = tileGetSolid(x, y - shape.h - 1)
				else if(atZipline(0, 1)) lineType = tileGetSolid(x, y - shape.h + 1)

				y = (y - y % 16) + 4

				switch(lineType) {
					case 1: //Flat
						y = (y - y % 16) + 8
						break
				}
				break
		}

		if(fabs(hspeed) < friction) hspeed = 0.0
		if(placeFree(x, y + 2) && (vspeed < 2 || (vspeed < 5 && !nowInWater)) && antigrav <= 0) vspeed += gravity
		else if(antigrav > 0) antigrav--
		if(!placeFree(x, y - 1) && vspeed < 0) vspeed = 0.0

		//Sliding/ball physics
		slippery = (anim == "morphIn" || anim == "ball" || onIce())
		if(slippery) {
			if(!placeFree(x, y + 4) && (fabs(hspeed) < 10)) {
				if(placeFree(x + 4, y + 2) && !onPlatform(hspeed)) {
					if(getcon("left", "hold", true, playerNum)) hspeed += 0.2
					else hspeed += 0.3
					vspeed += 0.2
				}
				if(placeFree(x - 4, y + 2) && !onPlatform(hspeed)) {
					if(getcon("right", "hold", true, playerNum)) hspeed -= 0.2
					else hspeed -= 0.3
					vspeed += 0.2
				}
			}
		}

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
				for(local i = 0; i < 8; i++) if(!placeFree(x, y + max(4, abs(hspeed))) && placeFree(x + hspeed, y + 1) && !swimming && vspeed >= 0 && !placeFree(x + hspeed, y + max(4, abs(hspeed)))) {
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
						if(slippery && !swimming && !placeFree(xprev, yprev + 2) && fabs(hspeed) > 4.0) vspeed -= 2.0
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

		if(anim == "morphIn" || anim == "ball" || !placeFree(x, y)) shape = shapeSlide
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

		//Movement
		if((!placeFree(x, y + 1) || onPlatform())) {
			if(anim == "ball") {
				if(hspeed > 0 && !getcon("right", "hold", true, playerNum)) hspeed -= friction / 3.0
				if(hspeed < 0 && !getcon("left", "hold", true, playerNum)) hspeed += friction / 3.0
			} else {
				if(hspeed > 0) {
					if((!(mspeed > 2 && getcon("right", "hold", true, playerNum)) || anim == "hurt" || !canMove) && !nowInWater) hspeed -= friction
					else if(nowInWater) hspeed -= friction / 3.0
				}
				if(hspeed < 0) {
					if((!(mspeed > 2 && getcon("left", "hold", true, playerNum)) || anim == "hurt" || !canMove) && !nowInWater) hspeed += friction
					else if(nowInWater) hspeed += friction / 3.0
				}
			}
		}
		else {
			if(hspeed > 0 && !getcon("right", "hold", true, playerNum)) hspeed -= friction / 3.0
			if(hspeed < 0 && !getcon("left", "hold", true, playerNum)) hspeed += friction / 3.0
		}

		if(nowInWater) {
			if(vspeed > 0 && !getcon("down", "hold", true, playerNum)) vspeed -= friction / 4.0
			if(vspeed < 0 && !getcon("up", "hold", true, playerNum)) vspeed += friction / 4.0
		}
	}

	function animation() {
		animOffset = 0.0

		switch(anim) {
			case "stand":
				frame += 0.1
				if(zoomies) frame += 0.1
				if(getcon("down", "hold", true, playerNum)) an.stand = an.crouch
				else if(stats.health <= game.maxHealth / 4) {
					an.stand = an.standW
					boredom = 0
				}
				else if(boredom >= (60 * 8)) an.stand = an.standB
				else an.stand = an.standN

				boredom++

				if(abs(rspeed) > 0.1) {
					anim = "walk"
					frame = 0.0
				}

				if(freeDown2 && !onPlatform()) {
					anim = "jumpT"
					frame = 0.0
					break
				}

				if(fallTimer > (30)) {
					an.stand = an.standN
					frame += 0.08
					if(vspeed > 0) frame = 0.0
					animOffset = an.landing[0] - 1
					if(frame > 3.5) fallTimer = 0
				}

				if(shooting) {
					an.stand = an.standN
					frame = 0.0
					switch(shootDir) {
						case 0:
							animOffset = an.shootF1[0] + (4 * (shooting - 1)) + shootTimer
							break
						case 1:
							animOffset = an.shootU1[0] + (4 * (shooting - 1)) + shootTimer
							break
						case 2:
							animOffset = an.shootUF1[0] + (4 * (shooting - 1)) + shootTimer
							break
						case 3:
							animOffset = an.shootTop[0] + (4 * (shooting - 1)) + shootTimer
							hspeed = 0
							break
						case 4:
							animOffset = an.shootDF1[0] + (4 * (shooting - 1)) + shootTimer
							break
					}
					animOffset -= 1 //Account for starting frame in sheet
				}
				break

			case "skid":
			case "walk":
				frame += abs(rspeed) / 12

				if(flip == 0 && hspeed < 0) {
					hspeed += 0.05
					anim = "skid"
				}
				else if(flip == 1 && hspeed > 0) {
					hspeed -= 0.05
					anim = "skid"
				}
				else anim = "walk"

				if(anim == "walk") {
					//Offset frame based on movement speed and if shooting
					if(fabs(rspeed) > 2.0) animOffset = 16
					if(fabs(rspeed) > 3.6) animOffset = 32
					if(shooting) animOffset += 8
					if(abs(rspeed) <= 0.1 || fabs(hspeed) <= 0.1) anim = "stand"
				}

				if(placeFree(x, y + 2) && !onPlatform()) {
					if(vspeed >= 0) anim = "fall"
					else anim = "jump"
					frame = 0.0
				}
				break

			case "jumpU":
				anim = "jump"
			case "jump":
				if(fabs(hspeed) >= 2.8) an.jump = an.jumpR
				else an.jump = an.jumpU
				frame += 0.25
				if(an.jump == an.jumpR) frame += 0.25

				if(!placeFree(x, y + 2) || (onPlatform() && fabs(vspeed) < 0.1)) {
					anim = "stand"
					frame = 0.0
				}

				if(vspeed > 0) {
					anim = "jumpT"
					frame = 0.0
				}
				break

			case "jumpT":
				frame += 0.2
				if(!placeFree(x, y + 2) || (onPlatform() && fabs(vspeed) < 0.1)) {
					anim = "stand"
					frame = 0.0
				}

				if(floor(frame) > an[anim].len() - 1) {
					anim = "fall"
					frame = 0.0
				}

				if(vspeed < 0) anim = "jump"
				break

			case "fall":
				fallTimer++
				frame += 0.25
				if(!placeFree(x, y + 2) || (onPlatform() && fabs(vspeed) < 0.1)) {
					anim = "stand"
					frame = 0.0
				}
				if(vspeed < 0) anim = "jump"
				break

			case "wall":
				frame += 0.3
				vspeed = 0

				if(floor(frame) > 1) {
					vspeed = -6.0
					if(getcon("down", "hold", true, playerNum)) vspeed = -4.0
					local w = 4.0
					if(getcon("up", "hold", true, playerNum)) w = 2.0
					if(flip == 0) hspeed = w
					else hspeed = -w
					anim = "jump"
					frame = 0.0
				}

				if(!freeLeft) flip = 0
				if(!freeRight) flip = 1
				break

			case "hurt":
				frame += 0.1
				if(floor(frame) > 1) {
					if(nowInWater) anim = "float"
					else anim = "stand"
				}
				break

			case "float":
				frame += 0.05
				if(getcon("left", "hold", true, playerNum) || getcon("right", "hold", true, playerNum) || getcon("up", "hold", true, playerNum) || getcon("down", "hold", true, playerNum)) {
					anim = "swim"
					frame = 0.0
				}
				break

			case "swim":
				frame += 0.15
				if(!getcon("left", "hold", true, playerNum) && !getcon("right", "hold", true, playerNum) && !getcon("up", "hold", true, playerNum) && !getcon("down", "hold", true, playerNum)) anim = "float"

				if(routine == ruNormal) {
					if(vspeed < 0) anim = "jump"
					else anim = "jumpT"
					frame = 0.0
				}

				if(routine == ruBall) anim = "morphIn"
				break

			case "morphIn":
				frame += 0.25
				if(floor(frame) > 1) {
					routine = ruBall
					anim = "ball"
				}
				break

			case "morphOut":
				frame += 0.25
				if(floor(frame) > 1) {
					if(nowInWater) {
						routine = ruSwim
						anim = "float"
						vspeed /= 4.0
						hspeed /= 4.0
					}
					else {
						routine = ruNormal
						anim = "stand"
					}
				}
				break

			case "ball":
				slideframe += hspeed / 8.0
				slideframe = wrap(slideframe, 0, (hspeed < 0 ? 4 : 3))
				frame = slideframe
				break

			case "climb":
			case "climbWall":
			case "ledge":
				if(shooting) {
					frame = 0.0
					animOffset = an.shootClimb[0] - an[anim][0] + shootTimer
				}
				break

			case "shootTop":
				frame += 0.25
				if(hspeed != 0 || vspeed != 0) {
					anim == "stand"
					frame = 0
					break
				}
				if(frame >= an[anim].len()) anim = "stand"
				rspeed = 0
				break

			case "plantMine":
				frame += 0.25
				if(hspeed != 0 || vspeed != 0) {
					anim == "stand"
					frame = 0
					break
				}
				if(frame >= an[anim].len()) {
					anim = "stand"

					if("WeaponEffect" in actor) foreach(i in actor["WeaponEffect"]) if(i instanceof NutMine) deleteActor(i.id)

					local nutType = "normal"
					if(hand == 0) nutType = stats.weapon
					if(hand == 1) nutType = stats.subitem
					if(nutType != "fire" && nutType != "ice" && nutType != "air" && nutType != "earth") nutType = "normal"
					local c = fireWeapon(NutMine, x, y + 9, 1, id)

					if(c != null) {
						c.element = nutType
						energy--
						firetime = 90
					}
				}
				rspeed = 0
				break

			case "monkey":
				if(hspeed == 0) {
					frame = 0.0
					animOffset = an["hang"][0] - an[anim][0]
				}

				if(shooting) {
					frame = 0.0
					animOffset = an["shootHang"][0] - an[anim][0] + shootTimer
				}

				if(hspeed != 0) frame += 0.1

				if(!atZipline() && !atZipline(0, 1) && !atZipline(0, -1)) anim = "jump"

				break
		}

		if(anim in an && an[anim] != null && anim != "hurt") frame = wrap(abs(frame), 0, an[anim].len() - 1)

		if(shooting) shootTimer += 0.25
		if(shootTimer > 4) {
			shootTimer = 0.0
			shooting = 0
		}
		if(anim != "stand" || shooting) boredom = 0
		if(anim != "fall" && anim != "stand") fallTimer = 0

		if(anim == "fall" || anim == "jumpT" || anim == "jump"  || anim == "jumpU" || anim == "float" || anim == "swim") {
			if(shooting) {
				frame = 0.0
				switch(shootDir) {
					case 0:
					case 2:
					case 3:
						animOffset = an.shootAir[0] + shootTimer
						break
					case 1:
						animOffset = an.shootAU1[0] + (4 * (shooting - 1)) + shootTimer
						break
					case 4:
						animOffset = an.shootAD1[0] + (4 * (shooting - 1)) + shootTimer
						break
				}
				if(an[anim] != null) animOffset -= an[anim][0] //Account for starting frame in sheet
			}
		}
	}

	function run() {
		freeDown = placeFree(x, y + 1)
		freeDown2 = placeFree(x, y + 2)
		freeLeft = placeFree(x - 1, y)
		freeRight = placeFree(x + 1, y)
		freeUp = placeFree(x, y - 1)
		nowInWater = inWater(x, y)

		if(routine == ruSwim) canStomp = false
		else canStomp = true

		base.run()

		//Global actions
		if(canMove) {
			if(getcon("swap", "press", true, playerNum)) swapitem()
			if(getcon("shoot", "press", true, playerNum)) shootNut(0)
			if(getcon("spec1", "press", true, playerNum)) shootNut(1)

			if((getcon("shoot", "hold", true, playerNum) || getcon("spec1", "hold", true, playerNum)) && energy > 1) {
				chargeTimer++
				if(chargeTimer > 121 && energy < 3) chargeTimer--
				if(chargeTimer == 90 || chargeTimer == 180) tftime = 0
			}

			if(getcon("shoot", "release", true, playerNum) && energy > 1 && chargeTimer >= 90) shootNut(0, floor(chargeTimer / 90) + 1)

			if(getcon("spec1", "release", true, playerNum) && energy > 1 && chargeTimer >= 90) shootNut(1, floor(chargeTimer / 90) + 1)

			if(!getcon("shoot", "hold", true, playerNum) && !getcon("spec1", "hold", true, playerNum) || routine == ruBall) chargeTimer = 0

			if(chargeTimer > 180 && (getFrames()) % 4 == 0) {
				newActor(GoldCharge, x - 12 + randInt(24) y - 12 + randInt(24))
			}
		}

		local nrgBonus = float(game.fireBonus + game.iceBonus + game.airBonus + game.earthBonus) / 4.0
		stats.maxEnergy = 4 - game.difficulty + ceil(nrgBonus)

		//Recharge
		if(firetime > 0) {
			firetime--
		}

		if(firetime == 0 && energy < stats.maxEnergy && !shooting) {
			energy++
			firetime = 30
		}

		//After image
		if(zoomies > 0 && getFrames() % 2 == 0 && an[anim] != null) newActor(AfterImage, x, y, [sprite, an[anim][wrap(floor(frame), 0, an[anim].len() - 1)] + animOffset, 0, flip, 0, 1, 1])

		//Invincibility
		if(invincible > 0) invincible--
		if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))
	}

	function ruNormal() {
		//Controls
		if(!placeFree(x, y + 1) || anim == "climb" || onPlatform()) {
			canJump = 16
		}
		else {
			if(canJump > 0) canJump--
		}

		if(canMove) {
			mspeed = 4.0
			if(config.stickspeed) {
				local j = null
				if(playerNum == 1) j = config.joy
				if(playerNum == 2) j = config.joy2
				if(abs(joyX(j.index)) >  js_max * 0.1) mspeed = (3.0 * abs(joyX(j.index))) / float(js_max)
			}

			if(invincible) mspeed += 0.4
			if(nowInWater) mspeed *= 0.8
			if(zoomies > 0) mspeed *= 2.0

			//Moving left and right
			if(zoomies > 0) accel = 0.4
			else accel = 0.2

			if(anim == "ledge") {
				mspeed = 0
				accel = 0
				hspeed = 0
			}

			if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid" && anim != "plantMine" && anim != "shootTop") {
				if(hspeed >= 2) {
					if(slippery) hspeed += accel * 0.2
					else hspeed += accel * 0.4
				}
				else if(slippery) hspeed += accel / 2.0
				else hspeed += accel
			}

			if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid" && anim != "plantMine" && anim != "shootTop") {
				if(hspeed <= -2) {
					if(slippery) hspeed -= accel * 0.2
					else hspeed -= accel * 0.4
				}
				else if(slippery) hspeed -= accel / 2.0
				else hspeed -= accel
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
			if(anim == "slide") rspeed = hspeed

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

				//Check if still on ladder
				local felloff = true
				if(atLadder()) felloff = false
				if(felloff) {
					anim = "fall"
					frame = 0.0
					if(getcon("up", "hold", true, playerNum)) vspeed = -3.0
				}

				//Change direction
				if(getcon("right", "press", true, playerNum) && canMove) flip = 0
				if(getcon("left", "press", true, playerNum) && canMove) flip = 1
			}

			//Get on ladder
			if(((getcon("down", "hold", true, playerNum) && placeFree(x, y + 2)) || getcon("up", "hold", true, playerNum)) && anim != "hurt" && anim != "climb" && (vspeed >= 0 || getcon("down", "press", true, playerNum) || getcon("up", "press", true, playerNum))) {
				if(atLadder()) {
					anim = "climb"
					frame = 0.0
					hspeed = 0
					vspeed = 0
					x = (x - (x % 16)) + 8
				}
			}

			//Get on monkeybar
			if(((getcon("down", "hold", true, playerNum) && placeFree(x, y + 2)) || getcon("up", "hold", true, playerNum)) && anim != "hurt" && anim != "monkey" && (vspeed >= 0 || getcon("down", "press", true, playerNum) || getcon("up", "press", true, playerNum))) {
				if(atZipline() || atZipline(0, -vspeed)) {
					anim = "monkey"
					frame = 0.0
					hspeed = 0
					vspeed = 0
					x = (x - (x % 16)) + 8
				}
			}

			//Jumping
			if(getcon("jump", "press", true, playerNum) || jumpBuffer > 0) {
				if((onPlatform() || onPlatform(8) || onPlatform(-8)) && !placeFree(x, y + 1) && getcon("down", "hold", true, playerNum)) {
					y++
					canJump = 32
					if(!placeFree(x, y) && !placeFree(x, y - 1)) y--
					if(anim == "stand" || anim == "walk") anim = "jumpT"
				}
				else if(canJump > 0 && placeFree(x, y - 2) || anim == "ledge" || anim == "monkey") {
					jumpBuffer = 0
					if(anim == "climb") vspeed = -3
					vspeed = -6.4
					didJump = true
					canJump = 0
					if(anim != "hurt") {
						if(anim != "morphIn") anim = "jump"
						frame = 0.0
					}
					popSound(sndMidiJump, 0)
				}
				else if(freeDown && anim != "climb" && anim != "ledge" && !placeFree(x - 2, y) && anim != "wall" && hspeed <= 0 && tileGetSolid(x - 12, y - 12) != 40 && tileGetSolid(x - 12, y + 12) != 40 && tileGetSolid(x - 12, y) != 40 && !didJump) {
					flip = 0
					anim = "wall"
					frame = 0.0
					playSound(sndWallkick, 0)
				}
				else if(freeDown && anim != "climb" && anim != "ledge"  && !placeFree(x + 2, y) && anim != "wall" && hspeed >= 0 && tileGetSolid(x + 12, y - 12) != 40 && tileGetSolid(x + 12, y + 12) != 40 && tileGetSolid(x + 12, y) != 40 && !didJump) {
					flip = 1
					anim = "wall"
					frame = 0.0
					playSound(sndWallkick, 0)
				}
			}

			//Wall slide
			if((anim == "fall" || anim == "ledge") && ((getcon("left", "hold", true, playerNum) && !freeLeft) || (getcon("right", "hold", true, playerNum) && !freeRight))) {
				if(!freeLeft && !(onIce(x - 8, y) || onIce(x - 8, y - 16))) {
					if(tileGetSolid(x - 8, y - 16) == 0 && tileGetSolid(x - 8, y) == 1 && placeFree(x, y + 8)) {
						if(!getcon("down", "hold", true, playerNum)) vspeed = 0
						anim = "ledge"
						flip = 1
					}
					else {
						if(vspeed > 0.5) vspeed = 0.5
						if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x - 4, y + 12)
						an["fall"] = an["fallW"]
						anim = "fall"
						flip = 0
					}
				}
				if(!freeRight && !(onIce(x + 8, y) || onIce(x + 8, y - 16))) {
					if(tileGetSolid(x + 8, y - 16) == 0 && tileGetSolid(x + 8, y) == 1 && placeFree(x, y + 8)) {
						if(!getcon("down", "hold", true, playerNum)) vspeed = 0
						anim = "ledge"
						flip = 0
					}
					else {
						if(vspeed > 0.5) vspeed = 0.5
						if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x + 4, y + 12)
						an["fall"] = an["fallW"]
						anim = "fall"
						flip = 1
					}
				}
			} else an["fall"] = an["fallN"]

			if(getcon("jump", "press", true, playerNum) && jumpBuffer <= 0 && freeDown && anim != "ledge") jumpBuffer = 8
			if(jumpBuffer > 0) jumpBuffer--

			if(!getcon("jump", "hold", true, playerNum) && (vspeed < 0 || anim == "fall") && didJump)
			{
				didJump = false
				vspeed /= 2.5
			}

			if(getcon("spec2", "press", true, playerNum) && anim != "hurt") {
				if(anim == "ledge") vspeed = -4.0
				anim = "morphIn"
				frame = 0.0
			}
		}
		else rspeed = min(rspeed, abs(hspeed))
		
		if(anim != "ledge" && anim != "wall" && !(anim == "fall" && an.fall == an.fallW)) {
			if((getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum) && anim != "slide" && canMove) || (hspeed > 0.1 && anim == "slide")) flip = 0
			if((getcon("left", "hold", true, playerNum) && !getcon("right", "hold", true, playerNum) && anim != "slide" && canMove) || (hspeed < -0.1 && anim == "slide")) flip = 1
		}

		//Hurt
		if(onHazard(x, y)) hurt = 1 + game.difficulty
		if(onDeath(x, y)) stats.health = 0

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(stats.health > 0) stats.health -= hurt
				if(flip == 0) hspeed = -2.0
				else hspeed = 2.0
				if(hurt >= hurtThreshold) an.hurt = an.hurtHeavy
				else an.hurt = an.hurtLight
				if(anim != "morphIn") anim = "hurt"
				frame = 0.0
			}
			hurt = 0
		}
		else hurt = 0
		if(blinking > 0) blinking--
		if(stats.health == 0) {
			die()
			return
		}

		if(nowInWater || resTime > 0) {
			routine = ruSwim
			if(anim != "morphIn" && anim != "ball") anim = "float"
			vspeed /= 4.0
			hspeed /= 4.0
		}
	}

	function ruSwim() {
			//Controls
			if(canMove) {
				if(getcon("left", "hold", true, playerNum)) {
					if(hspeed > -1.2) hspeed -= accel / 2.0
					flip = 1
				}
				if(getcon("right", "hold", true, playerNum)) {
					if(hspeed < 1.2) hspeed += accel / 2.0
					flip = 0
				}
				if(getcon("up", "hold", true, playerNum) && vspeed > -1.2) vspeed -= accel / 2.0
				if(getcon("down", "hold", true, playerNum) && vspeed < 1.2) vspeed += accel / 2.0
				
				if(getcon("spec2", "press", true, playerNum) && anim != "hurt") {
					anim = "morphIn"
					frame = 0.0
				}
			}
		//Hurt
		if(onHazard(x, y)) hurt = 1 + game.difficulty
		if(onDeath(x, y)) stats.health = 0

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(stats.health > 0) stats.health -= hurt
				if(flip == 0) hspeed = -2.0
				else hspeed = 2.0
				if(hurt >= hurtThreshold) an.hurt = an.hurtHeavy
				else an.hurt = an.hurtLight
				if(anim != "morphIn") anim = "hurt"
				frame = 0.0
			}
			hurt = 0
		}
		else hurt = 0
		if(blinking > 0) blinking--
		if(stats.health == 0) {
			die()
			return
		}

		if(!nowInWater) {
			routine = ruNormal
			if(anim != "morphIn" && anim != "ball") anim = "stand"
			if(getcon("jump", "hold", true, playerNum)) vspeed -= 4.0
		}
	}

	function ruBall() {
		//Controls
		if(!placeFree(x, y + 1) || anim == "climb" || onPlatform()) {
			canJump = 16
		}
		else {
			if(canJump > 0) canJump--
		}

		if(canMove) {
			mspeed = 3.5
			if(config.stickspeed) {
				local j = null
				if(playerNum == 1) j = config.joy
				if(playerNum == 2) j = config.joy2
				if(abs(joyX(j.index)) >  js_max * 0.1) mspeed = (3.0 * abs(joyX(j.index))) / float(js_max)
			}

			if(invincible) mspeed += 0.4
			if(nowInWater) mspeed *= 0.8
			if(zoomies > 0) mspeed *= 2.0

			//Moving left and right
			if(zoomies > 0) accel = 0.4
			else accel = 0.2

			if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") {
				if(hspeed >= 2) {
					if(onIce(x, y + 1)) hspeed += accel * 0.2
					else hspeed += accel * 0.4
				}
				else if(onIce(x, y + 1)) hspeed += accel / 2.0
				else hspeed += accel
				flip = 0
			}

			if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") {
				if(hspeed <= -2) {
					if(onIce(x, y + 1)) hspeed -= accel * 0.2
					else hspeed -= accel * 0.4
				}
				else if(onIce(x, y + 1)) hspeed -= accel / 2.0
				else hspeed -= accel
				flip = 1
			}

			//Jumping
			if(getcon("jump", "press", true, playerNum) || jumpBuffer > 0) {
				if(onPlatform() && !placeFree(x, y + 1) && getcon("down", "hold", true, playerNum)) {
					y++
					canJump = 32
					if(!placeFree(x, y) && !placeFree(x, y - 1)) y--
				}
				else if(canJump > 0 && placeFree(x, y - 2)) {
					jumpBuffer = 0
					if(anim == "climb") vspeed = -3
					if(nowInWater) vspeed = -4.0
					else vspeed = -6.4
					didJump = true
					if(stats.weapon != "air") canJump = 0
					popSound(sndMidiJump, 0)
				}
			}

			if(getcon("jump", "press", true, playerNum) && jumpBuffer <= 0 && freeDown) jumpBuffer = 8
			if(jumpBuffer > 0) jumpBuffer--

			if(!getcon("jump", "hold", true, playerNum) && (vspeed < 0 || anim == "fall") && didJump)
			{
				didJump = false
				vspeed /= 2.5
			}
		}
		else rspeed = min(rspeed, abs(hspeed))

		//Unmorph
		if(getcon("spec2", "press", true, playerNum) && placeFree(x, y - 8) && anim == "ball") {
			anim = "morphOut"
			frame = 0.0
		}

		//Hurt
		if(onHazard(x, y)) hurt = 1 + game.difficulty
		if(onDeath(x, y)) stats.health = 0

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(stats.health > 0) stats.health -= hurt
				if(flip == 0) hspeed = -1.0
				else hspeed = 1.0
				frame = 0.0
			}
			hurt = 0
		}
		else hurt = 0
		if(blinking > 0) blinking--
		if(stats.health == 0) {
			die()
			return
		}
	}

	function ruMonkey() {

	}

	function draw() {
		if(!hidden) {
			if(anim in an && an[anim] != null) {
				frame = wrap(frame, 0, an[anim].len() - 1)

				//Aura
				if(stats.weapon != "normal") {
					switch(stats.weapon) {
						case "fire":
							auraColor = 0xf88000ff
							break
						case "ice":
							auraColor = 0x80d0f8ff
							break
					}
				}

				if(blinking == 0 || anim == "hurt") {
					if(anim == "climb" && shooting) drawSpriteZ(0, sprite, an[anim][floor(frame)] + animOffset, x - camx + (flip ? -2 : 2), y - camy, 0, (flip ? 0 : 1), 1, 1, 1)
					else drawSpriteZ(0, sprite, an[anim][floor(frame)] + animOffset, x - camx, y - camy, 0, (anim == "ball" ? 0 : flip), 1, 1, 1)
				}
				drawSpriteZ(0, sprite, an[anim][floor(frame)] + animOffset, x - camx, y - camy, 0, (anim == "ball" ? 0 : flip), 1, 1, wrap(blinking, 0, 10).tofloat() / 10.0)
			}
			if(shooting && anim == "walk") drawSpriteZ(0, sprite, an["armShoot"][min(3, shootTimer)], x - camx, y - camy, 0, flip)
			if(anim == "ball" && fabs(hspeed) > 4.2 && spinAlpha < 1.0) spinAlpha += 0.2
			if(spinAlpha > 0) spinAlpha -= 0.1
			if(spinAlpha < 0) spinAlpha = 0
			drawSpriteZ(0, sprBallSpin, floor((hspeed < 0 ? -frame : frame)), x - camx, y + 5 - camy, 0, int(hspeed < 0), 1, 1, spinAlpha)
			if(debug) {
				setDrawColor(0x008000ff)
				shape.draw()
			}

			if(chargeTimer >= 30 && chargeTimer < 180) drawSpriteZ(1, sprCharge, float(getFrames()) / (chargeTimer > 90 ? 2 : 4), x - camx, y - camy)

			//Transformation flash
			if(tftime != -1) {
				if(tftime < 4) {
					if(!hidden) drawSpriteZ(1, sprTFflash, tftime, x - camx, y - camy)
					tftime += 0.25
				} else tftime = -1
			}
		}

		drawLight(sprLightBasic, 0, x - camx, y - camy)
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
			stats.health = 0
			deleteActor(id)
			if(playerNum == 1) gvPlayer = false
			if(playerNum == 2) gvPlayer2 = false
			newActor(DeadMidi, x, y, [sprite, an["hurtHeavy"], playerNum, flip])
		}
	}

	function shootNut(_hand, _power = 1) {
		if(shooting || energy < 1) return
		popSound(sndThrow, 0)
		hand = _hand
		if(flip) shooting = 2 - hand
		else shooting = hand + 1

		_power = (min(_power, 3))

		local nutType = "normal"
		if(hand == 0) nutType = stats.weapon
		if(hand == 1) nutType = stats.subitem
		if(!["normal", "fire", "ice", "air", "earth", "shock"].find(nutType)) nutType = "normal"

		if(getcon("up", "hold", true, playerNum) && (getcon("left", "hold", true, playerNum) || getcon("right", "hold", true, playerNum))) shootDir = 2
		else if(getcon("down", "hold", true, playerNum) && (getcon("left", "hold", true, playerNum) || getcon("right", "hold", true, playerNum))) shootDir = 3
		else if(getcon("down", "hold", true, playerNum)) shootDir = 4
		else if(getcon("up", "hold", true, playerNum)) shootDir = 1
		else shootDir = 0

		if(shootDir == 4 && anim == "walk") hspeed = 0

		local c = null
		if(routine == ruBall) c = fireWeapon(WingNut, x, y + 4, 1, id)
		else if(!(shootDir == 4 && (!freeDown || onPlatform()) && routine == ruNormal && hspeed == 0) && anim != "plantMine") {
			if(!freeDown && shootDir == 3 && routine != ruSwim) {
				c = fireWeapon(TopNut, x, y - 2, 1, id)
				hspeed = 0
				anim = "shootTop"
				_power = 1
			}
			else c = fireWeapon(NutBomb, x, y - 2, 1, id)
			local d = (flip ? -1 : 1)
			if(anim == "ledge") d = -d

			switch(shootDir) {
				case 0:
					c.hspeed = (5 * d) + (hspeed / 2)
					if(!nowInWater) c.vspeed = -1
					break
				case 1:
					c.vspeed = -5 + (vspeed / 2)
					break
				case 2:
					c.hspeed = (4 * d) + (hspeed / 2)
					c.vspeed = -4.5
					break
				case 3:
					c.hspeed = (4 * d) + (hspeed / 2)
					c.vspeed = 3 + (vspeed / 2)
					break
				case 4:
					c.vspeed = 5 + (vspeed / 2)
					break
			}
		}
		else {
			frame = 0.0
			anim = "plantMine"
			_power = 1
		}

		if(c != null) {
			c.exElement = nutType
			c.exPower = _power
			energy -= _power
			firetime = 90
		}

		chargeTimer = 0
	}

	function _typeof(){ return "Midi" }
}

::DeadMidi <- class extends Actor {
	vspeed = -4.0
	hspeed = 0.0
	timer = 150
	sprite = null
	frame = 0.0
	anim = null
	playerNum = 0
	flip = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(!gvPlayer && !gvPlayer2) stopMusic()
		playSound(sndDie, 0)
		sprite = _arr[0]
		anim = _arr[1]
		playerNum = _arr[2]
		flip = _arr[3]
		if(flip) hspeed = 0.75
		else hspeed = -0.75
	}

	function run() {
		vspeed += 0.1
		if(timer > 120) {
			y += vspeed
			x += hspeed
		}
		timer--
		if(timer == 0) {
			if(!gvPlayer && !gvPlayer2) {
				startPlay(gvMap.file, true, true)
				if(game.check == false) {
					gvIGT = 0
				}
			}
			if(game.check == false) {
				if(playerNum == 1) game.ps1.weapon = "normal"
				if(playerNum == 2) game.ps2.weapon = "normal"
			}
			
		}
	}

	function draw() {
		if(timer > 120) {
			drawSprite(sprite, anim[min((150 - timer) / 15, 1)], x - camx, y - camy, 0, flip)
			drawLight(sprLightBasic, 0, x - camx, y - camy)
		}
		else if(timer > 30) for(local i = 0; i < 8; i++) {
			drawSprite(sprExplodeF, wrap((getFrames() / 4) + i, 1, 4), x + lendirX((120 - timer), (i * 45) + 22.5) - camx, y + lendirY((120 - timer), (i * 45) + 22.5) - camy, 0, randInt(4), min(1, float(timer - 30.0) / 30.0), min(1, float(timer - 30.0) / 30.0))
			drawLight(sprLightFire, 0, x + lendirX((120 - timer), (i * 45) + 22.5) - camx, y + lendirY((120 - timer), (i * 45) + 22.5) - camy, 0, 0, min(0.3 + abs(sin((getFrames() + (i * 45)) / 8.0)) * 0.2, float(timer - 30.0) / 30.0), min(0.3 + abs(sin((getFrames() + (i * 45)) / 8.0)) * 0.2, float(timer - 30.0) / 30.0))
			drawSprite(sprExplodeF, wrap((getFrames() / 4) + i + 2, 1, 4), x + lendirX((120 - timer) * 0.75, (i * 45)) - camx, y + lendirY((120 - timer) * 0.75, (i * 45)) - camy, 0, randInt(4), min(1, float(timer - 30.0) / 30.0), min(1, float(timer - 30.0) / 30.0))
			drawLight(sprLightFire, 0, x + lendirX((120 - timer) * 0.75, (i * 45)) - camx, y + lendirY((120 - timer) * 0.75, (i * 45)) - camy, 0, 0, min(0.3 + abs(sin((getFrames() + (i * 45) + 22.5) / 8.0)) * 0.2, float(timer - 30.0) / 30.0), min(0.3 + abs(sin((getFrames() + (i * 45) + 22.5) / 8.0)) * 0.2, float(timer - 30.0) / 30.0))
		}
	}

	function _typeof() { return "DeadPlayer" }
}