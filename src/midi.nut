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

	an = {
		stand = null
		standWait = [0]
		standNormal = [1, 2, 3, 4]
		standWeak = [204, 204, 204, 240, 205, 205, 206, 206, 206, 206, 207, 207]
		standHold = [5]
		crouch = [6]
		crouchHold = [7]
		jumpU = [8, 9]
		jumpT = [10, 11]
		fall = null
		fallNormal = [12, 13]
		hurt = null
		hurtLight = [14, 15]
		hurtHeavy = [166, 167]
		walk = [16, 17, 18, 19, 20, 21, 22, 23]
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

	nowInWater = false

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
	}

	function physics() {
		switch(anim) {
			case "wall":
			case "climb":
			case "climbWall":
			case "monkey":
			case "shootClimb":
				gravity = 0.0
				vspeed = 0.0
				break
			case "ledge":
				gravity = 0.0
				if(!getcon("down", "hold", true, playerNum)) vspeed = 0.0
				break
		}

		slippery = (anim == "morphIn" || anim == "ball" || onIce())
		if(slippery) {
			if(!placeFree(x, y + 4) && (fabs(hspeed) < 8)) {
				if(placeFree(x + 4, y + 2)) hspeed += 0.25
				if(placeFree(x - 4, y + 2)) hspeed -= 0.25
				vspeed += 1.0
			}
			else if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2
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
						if(slippery && !swimming && !placeFree(xprev, yprev + 2)) vspeed -= 2.0
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

		if(anim == "morphIn" || anim == "ball") shape = shapeSlide
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
	}

	function animation() {
		animOffset = 0.0

		switch(anim) {
			case "stand":
				frame += 0.05
				if(stats.health <= game.maxHealth / 4) an.stand = an.standWeak
				else if(boredom >= (60 * 8)) an.stand = an.standWait
				else an.stand = an.standNormal

				boredom++

				if(abs(rspeed) > 0.1) {
					anim = "walk"
					frame = 0.0
				}

				if(shooting) {
					frame = 0.0
					switch(shootDir) {
						case 0:
							animOffset = 88 + (4 * (shooting - 1))
					}
				}
				break

			case "walk":
		}
	}

	function run() {
		base.run()

		//Invincibility
		if(invincible > 0) invincible--
		if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))

		hidden = false
	}

	function ruNormal() {
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
				anim = "hurt"
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
	function ruSwim() {
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
				anim = "hurt"
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
	function ruBall() {
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

	function draw() {}
}