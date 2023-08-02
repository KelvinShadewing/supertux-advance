
::sprCyra <- newSprite("res/gfx/cyra_gfx/cyra.png", 74, 54, 0, 0, 32, 33)
::defCyra <- sprCyra
::sprCyraFire <- newSprite("res/gfx/cyra_gfx/cyrafire.png", 74, 54, 0, 0, 32, 33)
::defCyraFire <- sprCyraFire
::sprCyraIce <- newSprite("res/gfx/cyra_gfx/cyraice.png", 74, 54, 0, 0, 32, 33)
::defCyraIce <- sprCyraIce
::sprCyraAir <- newSprite("res/gfx/cyra_gfx/cyraair.png", 74, 54, 0, 0, 32, 33)
::defCyraAir <- sprCyraAir
::sprCyraEarth <- newSprite("res/gfx/cyra_gfx/cyraearth.png", 74, 54, 0, 0, 32, 33)
::defCyraEarth <- sprCyraEarth
::sprCyraShock <- newSprite("res/gfx/cyra_gfx/cyrashock.png", 74, 54, 0, 0, 32, 33)
::defCyraShock <- sprCyraShock
::sprCyraWater <- newSprite("res/gfx/cyra_gfx/cyrawater.png", 74, 54, 0, 0, 32, 33)
::defCyraWater <- sprCyraWater
::sprCyraLight <- newSprite("res/gfx/cyra_gfx/cyralight.png", 74, 54, 0, 0, 32, 33)
::defCyraLight <- sprCyraLight
::sprCyraDark <- newSprite("res/gfx/cyra_gfx/cyradark.png", 74, 54, 0, 0, 32, 33)
::defCyraDark <- sprCyraDark
::sprCyraOverworld <- newSprite("res/gfx/cyra_gfx/cyraO.png", 14, 20, 0, 0, 7, 17)
::defCyraOverworld <- sprCyraOverworld
::sprCyraDoll <- newSprite("res/gfx/cyra_gfx/cyradoll.png", 16, 16, 0, 0, 8, 8)
::defCyraDoll <- sprCyraDoll
::sprKiki2 <- newSprite("res/gfx/kiki2.png", 74, 54, 0, 0, 32, 33)
::defKiki2 <- sprKiki2


::sprCyraSwordWave <- newSprite("res/gfx/cyra_gfx/swordwave.png", 28, 24, 0, 0, 14, 12)
::defCyraSwordWave <- sprCyraSwordWave

::sprCyraFireWave <- newSprite("res/gfx/cyra_gfx/firewave.png", 28, 24, 0, 0, 14, 12)
::defCyraFireWave <- sprCyraFireWave

::sprCyraFreezeWave <- newSprite("res/gfx/cyra_gfx/freezewave.png", 28, 24, 0, 0, 14, 12)
::defCyraFreezeWave <- sprCyraFreezeWave

::sprCyraElectricWave <- newSprite("res/gfx/cyra_gfx/electricwave.png", 28, 24, 0, 0, 14, 12)
::defCyraElectricWave <- sprCyraElectricWave

::sprWaterCrescent <- newSprite("res/gfx/water-crescent.png", 32, 16, 0, 0, 16, 8)
::defWaterCrescent <- sprWaterCrescent

//Sounds
::sndCyraSwordSwing <- loadSound("res/snd/cyra_snd/swordswing.ogg")
::sndCyraFireSwing <- loadSound("res/snd/cyra_snd/firewave.ogg")
::sndCyraTornado <- loadSound("res/snd/cyra_snd/windswing.ogg")
::sndCyraElectricSwing <- loadSound("res/snd/electricwave.ogg")

::gfxCyraReset <- function() {
	sprCyra = defCyra
	sprCyraOverworld = defCyraOverworld
	sprCyraDoll = defCyraDoll
}


::freeCyra <- function() {
	game.characters["Cyra"] <- true
	game.friends["Cyra"] <- true
	game.characters["Kiki2"] <- true
	game.friends["Kiki2"] <- true
}

gvCharacters.Cyra <- {
	name = "Guardian Cyra"
	shortname = "Cyra"
	over = "sprCyraOverworld"
	doll =  "sprCyraDoll"
	normal = "sprCyra"
	fire = "sprCyraFire"
	ice = "sprCyraIce"
	air = "sprCyraAir"
	earth = "sprCyraEarth"
	shock = "sprCyraShock"
	water = "sprCyraWater"
	dark = "sprCyraDark"
	light = "sprCyraLight"
	pick = [8, 107]
}

gvCharacters.Kiki2 <- {
	name = "Kiki the Cyber Squirrel (Type B)"
	shortname = "Kiki"
	over = "sprKikiOverworld"
	doll =  "sprKikiDoll"
	normal = "sprKiki2"
	fire = "sprKiki2"
	ice = "sprKiki2"
	air = "sprKiki2"
	earth = "sprKiki2"
	shock = "sprKiki2"
	water = "sprKiki2"
	dark = "sprKiki2"
	light = "sprKiki2"
	pick = [8, 107]
}

/*==========*\
| CYRA ACTOR |
\*==========*/

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
	guardtime = 0
	hurt = 0
	blast = true
	swimming = false
	endMode = false
	canStomp = true //If they can use jumping as an attack
	sprite = sprCyra
	invincible = 0
	shapeStand = 0
	shapeSlide = 0
	shapeClimb = 0
	tftime = -1 //Timer for transformation
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
	an = {
		stand = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 95, 94, 94, 94, 95, 94, 94, 94, 95, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 96, 97, 98, 99, 98, 99, 98, 99, 98, 99, 98, 97, 96]
		standN = [0, 1, 2, 3]
		standW = [90, 90, 91, 91, 92, 92, 93, 93]
		skid = [4, 5]
		push = [6, 7]
		hurt = [6, 7]
		die = [7, 140, 141, 142, 143]
		dive = [14, 15]
		crouch = [14, 15]
		getUp = [15, 14]
		stomp = [86, 87, 88]
		stompL = [89, 89]
		walk = [16, 17, 18, 19, 20, 21, 22, 23]
		run = [24, 25, 26, 27, 28, 29, 30, 31]
		jump = [32, 33]
		jumpU = [32, 33]
		jumpT = [34, 35]
		fall = null
		fallN = [36, 37]
		crawl = [40, 41, 42, 43, 42, 41]
		climb = [44, 45, 46, 47, 46, 45]
		float = [38, 39]
		swimF = [48, 49, 50, 51]
		swimUF = [48, 49, 50, 51]
		swimDF = [48, 49, 50, 51]
		swimU = [48, 49, 50, 51]
		swimD = [48, 49, 50, 51]
		wall = [52, 53]
		fallW = [52]
		slide = [54, 55, 56, 57]
		rollingSlash = [132, 133, 134, 135, 136, 137, 138, 139]
	}
	animOffset = 0.0

	mySprNormal = null
	mySprFire = null
	mySprIce = null
	mySprAir = null
	mySprEarth = null
	mySprShock = null
	mySprWater = null
	mySprLight = null
	mySprDark = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		anim = "stand"
		shapeStand = Rec(x, y, 5, 16, 0, 0, 0)
		shapeClimb = Rec(x, y, 5, 12, 0, 0, 0)
		shapeSlide = Rec(x, y, 5, 6, 0, 0, 6)
		shape = shapeStand
		if(!gvPlayer) gvPlayer = this
		startx = _x.tofloat()
		starty = _y.tofloat()
		stats.energy = stats.maxEnergy
		an["fall"] = an["fallN"]
		xprev = x
		yprev = y

		mySprNormal = sprCyra
		mySprFire = sprCyraFire
		mySprIce = sprCyraIce
		mySprAir = sprCyraAir
		mySprEarth = sprCyraEarth
		mySprShock = sprCyraShock
		mySprWater = sprCyraWater
		mySprDark = sprCyraDark
		mySprLight = sprCyraLight
	}

	function physics() {}
	function routine() {}
	function animation() {}

	//Elemental resistances
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
		cut = 0.5
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
		earth = 0.5
		air = 2.0
		toxic = 1.0
		shock = 1.0
		water = 1.0
		light = 1.0
		dark = 1.0
		cut = 0.25
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
		cut = 0.5
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
		cut = 0.5
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
		cut = 0.5
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
		cut = 0.5
		blast = 1.0
	}

	function run() {
		base.run()

		inMelee = slashing

		//Side checks
		shapeSlide.setPos(x, y)
		shapeStand.setPos(x, y)
		if(shape == shapeStand && !placeFree(x, y)) {
			shape = shapeSlide
			if(anim == "stand" || anim == "walk" || anim == "run") anim = "crawl"
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
		if(firetime > 0 && stats.weapon != "air" && (stats.weapon != "earth" || anim != "statue")) {
			firetime--
		}

		if(guardtime > 0 && anim != "statue")
			guardtime--

		if(firetime <= 0 && stats.energy < stats.maxEnergy)
			stats.energy += 1.0 / 60.0

		if(slashing) slashTimer += 0.2
		if(slashTimer >= 3) {
			slashTimer = 0.0
			slashing = false
		}

		/////////////
		// ON LAND //
		/////////////
		if((!inWater(x, y) || stats.weapon == "earth") && resTime <= 0) {
			swimming = false
			shapeStand.h = 12.0

			if(anim == "stomp")
				stompDamage = 2.0
			else
				stompDamage = 0.0

			//Animation states
			animOffset = 0.0
			switch(anim) {
				case "stand":
					if(stats.weapon == "ice" && floor(frame) == 0) frame += 0.01
					else if(stats.weapon == "ice" || stats.weapon == "fire") frame += 0.1
					else if(stats.weapon == "air") frame += 0.05
					else frame += 0.05

					if(abs(rspeed) > 0.1) {
						anim = "walk"
						frame = 0.0
					}

					if(placeFree(x, y + 8) && !onPlatform() && fabs(vspeed) >= 1) {
						if(vspeed >= 0) anim = "fall"
						else anim = "jumpU"
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

				case "walk":
					frame += abs(rspeed) / 10
					if(abs(rspeed) <= 0.1 || fabs(hspeed) <= 0.1) anim = "stand"
					if(abs(rspeed) > 2.4) anim = "run"

					if(placeFree(x, y + 8) && !onPlatform() && fabs(vspeed) >= 1) {
						if(vspeed >= 0) anim = "fall"
						else anim = "jumpU"
						frame = 0.0
					}

					if(slashing) {
						animOffset = (16.0 * 3.0)
					}
					break

				case "run":
					if(slashing) {
						animOffset = (16.0 * 3.0)
					}
				case "skid":
					if(flip == 0 && hspeed < 0) {
						hspeed += 0.05
						anim = "skid"
					}
					else if(flip == 1 && hspeed > 0) {
						hspeed -= 0.05
						anim = "skid"
					}
					else anim = "run"

					if(anim == "skid") frame += 0.2
					else if(stats.weapon == "ice") frame += abs(rspeed) / 16
					else frame += abs(rspeed) / 10
					if(abs(rspeed) < 2 && anim != "skid") anim = "walk"

					if(placeFree(x, y + 8) && !onPlatform() && fabs(vspeed) >= 1) {
						if(vspeed >= 0) anim = "fall"
						else anim = "jumpU"
						frame = 0.0
					}

					if(slashing && anim != "run") {
						frame = 0
						animOffset = (112 - 4) + slashTimer
					}
					break

				case "stomp":
					if(frame <= an[anim].len() - 1) frame += 0.2

				case "push":
					break

				case "jumpU":
					if(frame < 0.0 + 1) frame += 0.1

					if((!placeFree(x, y + 4) || onPlatform()) && vspeed >= 0) {
						anim = "stand"
						frame = 0.0
					}

					if(vspeed > 0) {
						anim = "jumpT"
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						animOffset = (61 - 32) + slashTimer
					}
					break

				case "jumpT":
					frame += 0.2
					if((!placeFree(x, y + 4) || onPlatform()) && vspeed >= 0) {
						anim = "stand"
						frame = 0.0
					}

					if(frame > an[anim].len() - 1) {
						anim = "fall"
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						animOffset = (61 - 34) + slashTimer
					}
					break

				case "fall":
					frame += 0.1
					if((!placeFree(x, y + 4) || onPlatform()) && vspeed >= 0) {
						anim = "stand"
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						if(an["fall"] == an["fallW"]) animOffset = (116 - 53) + floor(slashTimer)
						else animOffset = (61 - 36) + slashTimer
					}
					break

				case "wall":
					frame += 0.3
					vspeed = 0

					if(floor(frame) > 1) {
						vspeed = -5.0
						if(getcon("down", "hold", true, playerNum)) vspeed = -3.0
						local w = 3.0
						if(getcon("up", "hold", true, playerNum)) w = 1.5
						if(flip == 0) hspeed = w
						else hspeed = -w
						anim = "jumpU"
						frame = 0.0
					}

					if(slashing) {
						frame = 0
						animOffset = (115 - 52) + slashTimer
					}
					break

				case "dive":
					frame += 0.25

					if(floor(frame) > an[anim].len() - 1) {
						anim = "slide"
						shape = shapeSlide
					}
					break

				case "crouch":
					frame += 0.25

					if(floor(frame) > an[anim].len() - 1) {
						if(stats.weapon == "earth" && getcon("spec2", "hold", true, playerNum)) anim = "slide"
						else anim = "crawl"
						shape = shapeSlide
					}
					break

				case "getUp":
					frame -= 0.25

					if(floor(frame) < 0) {
						anim = "stand"
						shape = shapeStand
					}
					break

				case "slide":
					if(stats.weapon == "earth") slideframe += abs(hspeed / 8.0)
					else slideframe += abs(hspeed / 16.0)
					frame = slideframe

					if(!freeDown && hspeed != 0) if(floor(getFrames() % 8 - fabs(hspeed)) == 0 || fabs(hspeed) > 8) {
						if(stats.weapon == "fire") newActor(FlameTiny, x - (8 * (hspeed / fabs(hspeed))), y + 10)
						if(stats.weapon == "ice") newActor(Glimmer, x - (12 * (hspeed / fabs(hspeed))), y + 10)
					}
					break

				case "hurt":
					frame += 0.1
					if(floor(frame) > an[anim].len() - 1) {
						anim = "stand"
						frame = 0.0
					}
					break

				case "swimF":
					anim = "jumpT"
					frame = 0.0
					break

				case "swimUF":
				case "swimU":
					anim = "jumpU"
					frame = 0.0
					vspeed -= 1
					if(getcon("jump", "hold", true, playerNum) && vspeed > -4) vspeed = -6
					break

				case "swimDF":
				case "swimD":
					anim = "fall"
					frame = 0.0
					break

				case "rollingSlash":
					frame = (slashTimer / 3.0) * 8.0
					if(!slashing) {
						anim = "fall"
						slashing = false
					}
					break
			}

			if(anim != "climb") frame = wrap(abs(frame), 0.0, an[anim].len() - 1)
			onWall = (anim == "wall" || an[anim] == an["fallW"])

			//Sliding acceleration
			if(anim == "slide" || onIce()) {
				if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && stats.weapon == "ice"))) {
					if(placeFree(x + 4, y + 1)) hspeed += accel * 1.1
					if(placeFree(x - 4, y + 1)) hspeed -= accel * 1.1
					if(freeDown2)vspeed += 1.0
					//if(!placeFree(x + hspeed, y) && placeFree(x + hspeed, y - abs(hspeed / 2)) && anim == "slide") vspeed -= 0.25
				}
				else if(!placeFree(x, y + 8) && (fabs(hspeed) < 8 || (fabs(hspeed) < 12 && vspeed > 0))) vspeed += 0.2

				if(((!getcon("down", "hold", true, playerNum) || fabs(hspeed) < 0.05) && !freeDown && stats.weapon != "earth") || (fabs(hspeed) < 0.05 && (stats.weapon == "earth" && !getcon("spec2", "hold", true, playerNum))) || (stats.weapon == "earth" && !getcon("spec2", "hold", true, playerNum) && !getcon("down", "hold", true, playerNum))) if(anim == "slide" || anim == "dive") anim = "walk"
			}

			if(anim != "climb" && anim != "wall" && !slashing) {
				if((getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum) && anim != "slide" && canMove) || (hspeed > 0.1 && anim == "slide")) flip = 0
				if((getcon("left", "hold", true, playerNum) && !getcon("right", "hold", true, playerNum) && anim != "slide" && canMove) || (hspeed < -0.1 && anim == "slide")) flip = 1
			}

			if(stats.weapon != "air" && stats.stamina < stats.maxStamina && blinking == 0.0 && guardtime <= 0)
				stats.stamina += 0.05

			//Controls
			if((!placeFree(x - hspeed, y + 2) || !placeFree(x, y + 2) || anim == "climb" || onPlatform()) && !onWall) {
				canJump = 16
				if(stats.weapon == "air" && stats.stamina < stats.maxStamina) stats.stamina += 0.2
			}
			else {
				if(canJump > 0) canJump--
				if(stats.weapon == "air" && stats.stamina < 1) stats.stamina += 0.02
			}
			if(canMove) {
				accel = 0.2
				if(stats.weapon == "ice") mspeed = 3.5
				else mspeed = 3.0
				if((getcon("run", "hold", true, playerNum) || (abs(joyX(0)) >= js_max * 0.9 || abs(joyY(0)) >= js_max * 0.9) && config.stickspeed) && anim != "crawl") {
					if(stats.weapon == "ice") mspeed = 3.5
					else mspeed = 3.0
				}
				if(anim == "crawl") mspeed = 1.0
				if(nowInWater) mspeed *= 0.8
				if(zoomies > 0) mspeed *= 2.0

				//Moving left and right
				if(zoomies > 0) accel = 0.4
				else accel = 0.2

				if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") {
					if(hspeed >= 2) {
						if(onIce()) hspeed += accel * 0.2
						else hspeed += accel * 0.4
					}
					else if(onIce()) hspeed += accel / 2.0
					else hspeed += accel
				}

				if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") {
					if(hspeed <= -2) {
						if(onIce()) hspeed -= accel * 0.2
						else hspeed -= accel * 0.4
					}
					else if(onIce()) hspeed -= accel / 2.0
					else hspeed -= accel
				}

				//Change run animation speed
				if(getcon("right", "hold", true, playerNum) && rspeed < mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") if(freeRight || placeFree(x + 1, y - 2)) {
					rspeed += 0.2
					if(rspeed < hspeed) rspeed = hspeed
				}
				if(getcon("left", "hold", true, playerNum) && rspeed > -mspeed && anim != "wall" && anim != "slide" && anim != "hurt" && anim != "climb" && anim != "skid") if(freeLeft || placeFree(x - 1, y - 2)) {
					rspeed -= 0.2
					if(rspeed > hspeed) rspeed = hspeed
				}
				if(rspeed > 0) rspeed -= 0.1
				if(rspeed < 0) rspeed += 0.1
				if((abs(rspeed) <= 0.5 || hspeed == 0) && !getcon("right", "hold", true, playerNum) && !getcon("left", "hold", true, playerNum)) rspeed = 0.0
				if(anim == "slide") rspeed = hspeed

				//On a ladder
				if(anim == "climb") {
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
						anim = "fall"
						frame = 0.0
						if(getcon("up", "hold", true, playerNum)) vspeed = -2.5
					}

					//Change direction
					if(getcon("right", "press", true, playerNum) && canMove) flip = 0
					if(getcon("left", "press", true, playerNum) && canMove) flip = 1
					
					
					if(slashing) {
						frame = 0
						animOffset = (112 - 52) + slashTimer
					}

					//Ping-pong animation
				}

				//Get on ladder
				if(((getcon("down", "hold", true, playerNum) && placeFree(x, y + 2)) || getcon("up", "hold", true, playerNum)) && anim != "anHurt" && anim != "climb" && (vspeed >= 0 || getcon("down", "press", true, playerNum) || getcon("up", "press", true, playerNum))) {
					if(atLadder()) {
						anim = "climb"
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
						if(anim == "climb") vspeed = -3
						else if(stats.weapon == "air" || nowInWater) vspeed = -5.0
						else vspeed = -5.8
						didJump = true
						if(stats.weapon != "air") canJump = 0
						if(anim != "hurt" && anim != "dive" && (stats.weapon != "earth" || anim != "slide")) {
							anim = "jumpU"
							frame = 0.0
						}
						if(!freeDown2 || freeRight && freeLeft) {
							if(stats.weapon != "air")
								popSound(sndJump)
							else
								popSound(sndFlap)
						}
					}
					else if(freeDown && anim != "climb" && !placeFree(x - 2, y) && anim != "wall" && hspeed <= 0 && tileGetSolid(x - 12, y - 12) != 40 && tileGetSolid(x - 12, y + 12) != 40 && tileGetSolid(x - 12, y) != 40) {
						flip = 0
						anim = "wall"
						frame = 0.0
						playSound(sndWallkick, 0)
					}
					else if(freeDown && anim != "climb" && !placeFree(x + 2, y) && anim != "wall" && hspeed >= 0 && tileGetSolid(x + 12, y - 12) != 40 && tileGetSolid(x + 12, y + 12) != 40 && tileGetSolid(x + 12, y) != 40) {
						flip = 1
						anim = "wall"
						frame = 0.0
						playSound(sndWallkick, 0)
					}
					else if(floor(stats.stamina) > 0 && stats.weapon == "air" && getcon("jump", "press", true, playerNum)) {
						if(vspeed > 0) vspeed = 0.0
						if(vspeed > -4) vspeed -= 3.0
						didJump = true
						if(stats.weapon != "air") canJump = 0
						if(anim != "hurt" && anim != "dive") {
							anim = "jumpU"
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
						stats.stamina--
					}
				}

				//Wall slide
				if(anim == "fall" && ((getcon("left", "hold", true, playerNum) && !freeLeft) || (getcon("right", "hold", true, playerNum) && !freeRight))) {
					if(!freeLeft && !(onIce(x - 8, y) || onIce(x - 8, y - 16))) {
						if(vspeed > 0.5) vspeed = 0.5
						if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x - 4, y + 12)
						an["fall"] = an["fallW"]
						flip = 0
					}
					if(!freeRight && !(onIce(x + 8, y) || onIce(x + 8, y - 16))) {
						if(vspeed > 0.5) vspeed = 0.5
						if(getFrames() / 4 % 4 == 0) newActor(PoofTiny, x + 4, y + 12)
						an["fall"] = an["fallW"]
						flip = 1
					}
				} else {
					an["fall"] = an["fallN"]
				}

				if(getcon("jump", "press", true, playerNum) && jumpBuffer <= 0 && freeDown) jumpBuffer = 8
				if(jumpBuffer > 0) jumpBuffer--

				if(getcon("jump", "release", true, playerNum) && vspeed < 0 && didJump)
				{
					didJump = false
					vspeed /= 2.5
				}

				//Going into slide
				if(((getcon("spec2", "hold", true, playerNum) && stats.weapon == "earth")) && anim != "dive" && anim != "slide" && anim != "jumpU" && anim != "jumpT" && anim != "fall" && anim != "hurt" && anim != "wall" && anim != "crouch" && anim != "crawl") {
					if(placeFree(x + 2, y + 1) || hspeed >= 1.5) {
						anim = "dive"
						frame = 0.0
						flip = 0
						playSoundChannel(sndSlide, 0, 0)
					}

					if(placeFree(x - 2, y + 1) || hspeed <= -1.5) {
						anim = "dive"
						frame = 0.0
						flip = 1
						playSoundChannel(sndSlide, 0, 0)
					}
				}

				//Crawling
				if(getcon("down", "hold", true, playerNum) && anim != "dive" && anim != "slide" && anim != "jumpU" && anim != "jumpT" && anim != "fall" && anim != "hurt" && anim != "wall" && (!freeDown2 || onPlatform()) && anim != "crouch" && anim != "crawl" && anim != "stomp") {
					anim = "crouch"
					frame = 0.0
					shape = shapeSlide
				}

				if(anim == "crawl") {
					if(!getcon("down", "hold", true, playerNum) && placeFree(x, y - 6)) anim = "stand"
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
				if(anim == "slide") {
					if(hspeed > 0) hspeed -= friction / 3.0
					if(hspeed < 0) hspeed += friction / 3.0
				} else {
					if(hspeed > 0) {
						if(!(mspeed > 2 && getcon("right", "hold", true, playerNum)) || anim == "crawl" || !canMove) hspeed -= friction
					}
					if(hspeed < 0) {
						if(!(mspeed > 2 && getcon("left", "hold", true, playerNum)) || anim == "crawl" || !canMove) hspeed += friction
					}
				}
			}
			else if(anim != "slide") {
				if(hspeed > 0 && !getcon("right", "hold", true, playerNum)) hspeed -= friction / 3.0
				if(hspeed < 0 && !getcon("left", "hold", true, playerNum)) hspeed += friction / 3.0
			}

			if(fabs(hspeed) < friction) hspeed = 0.0
			if((placeFree(x, y + 2) || vspeed < 0) && (vspeed < 2 || (vspeed < 16 && (stats.weapon != "air" || getcon("down", "hold", true, playerNum)) && !nowInWater) || (anim == "stomp" && vspeed < 8)) && antigrav <= 0)
				vspeed += (vspeed > 5 ? gravity / vspeed : gravity)
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


			if(anim == "slide" && !freeDown && vspeed >= 0 && placeFree(x + hspeed, y)) {
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
			if(anim == "climb" || anim == "wall") gravity = 0
			
			
			//Attacks
			if(canMove && (anim == "jumpT" || anim == "jumpU" || anim == "fall") && getcon("down", "press", true, playerNum) && placeFree(x, y + 8)) {
				hspeed = 0.0
				vspeed = 4.0
				anim = "stomp"
				frame = 0.0
			}
			if((!freeDown || vspeed < 0 || onPlatform()) && anim == "stomp") {
				anim = "jumpU"
				popSound(sndBump)
				fireWeapon(StompPoof, x + 8, y + 12, 1, id)
				fireWeapon(StompPoof, x - 8, y + 12, 1, id)
			}

			if(canMove && anim != "hurt" && getcon("shoot", "press", true, playerNum) && !slashing && freeDown2 && getcon("up", "hold", true, playerNum)) {
				slashing = true
				anim = "rollingSlash"
				local c = fireWeapon(RollingSlash, x, y, 1, id)
				c.element = stats.weapon
				slashTimer = 0.0
				firetime = 60
			}
			else if(canMove && !slashing) switch(stats.weapon) {
				case "normal":
					if(getcon("shoot", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
						stats.energy--
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break
				case "fire":
					if(getcon("shoot", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "ice":
					if(getcon("shoot", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "air":
					if(getcon("shoot", "press", true, playerNum) && anim != "slide" && anim != "hurt" && cooldown == 0) {
						cooldown = 16
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
					if(getcon("spec2", "press", true, playerNum) && (anim != "hurt")) {
						anim = "dive"
						frame = 0.0
						playSoundChannel(sndSlide, 0, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					if(getcon("shoot", "press", true, playerNum) && anim != "slide" && anim != "hurt" && cooldown == 0) {
						cooldown = 16
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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

				case "shock":
					if(getcon("shoot", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(ElectricWaveCS, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
						c.hspeed += hspeed
						playSound(sndCyraElectricSwing, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -5
							c.hspeed /= 3
						}
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "water":
					if(getcon("shoot", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(WaterCrescent, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 8
						else c.hspeed = -8
						c.vspeed = 0
						playSound(sndCyraTornado, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break
			}


			if(canMove && anim != "hurt" && getcon("spec1", "press", true, playerNum) && !slashing && freeDown2 && getcon("up", "hold", true, playerNum)) {
				slashing = true
				anim = "rollingSlash"
				local c = fireWeapon(RollingSlash, x, y, 1, id)
				c.element = stats.subitem
				slashTimer = 0.0
				firetime = 60
			}
			else if(canMove && !slashing) switch(stats.subitem) {
				case "normal":
					if(getcon("spec1", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
						stats.energy--
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break
				case "fire":
					if(getcon("spec1", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "ice":
					if(getcon("spec1", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "air":
					if(getcon("spec1", "press", true, playerNum) && anim != "slide" && anim != "hurt" && cooldown == 0) {
						cooldown = 16
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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
					if(getcon("spec2", "press", true, playerNum) && (anim != "hurt")) {
						anim = "dive"
						frame = 0.0
						playSoundChannel(sndSlide, 0, 0)
						if(flip == 0 && hspeed < 2) hspeed = 2
						if(flip == 1 && hspeed > -2) hspeed = -2
					}
					if(getcon("spec1", "press", true, playerNum) && anim != "slide" && anim != "hurt" && cooldown == 0) {
						cooldown = 16
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
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

				case "shock":
					if(getcon("spec1", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(ElectricWaveCS, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 5
						else c.hspeed = -5
						c.hspeed += hspeed
						playSound(sndCyraElectricSwing, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -5
							c.hspeed /= 3
						}
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
					}
					break

				case "water":
					if(getcon("spec1", "press", true, playerNum) && anim != "slide" && anim != "hurt" && stats.energy > 0 && cooldown == 0) {
						cooldown = 8
						local fx = 6
						local fy = 0
						if(anim == "crouch") fy = 6
						if(anim == "crawl") fy = 10
						if(flip == 1) fx = -5
						local c = fireWeapon(WaterCrescent, x + fx, y - 4 + fy, 1, id)
						if(!flip) c.hspeed = 8
						else c.hspeed = -8
						c.vspeed = 0
						playSound(sndCyraTornado, 0)
						if(getcon("up", "hold", true, playerNum)) {
							c.vspeed = -2.5
							c.hspeed /= 1.5
						}
						stats.energy--
						firetime = 60
						slashing = true
						comboTimer = 30
						if(comboStep < 3) comboStep++
						else comboStep = 0
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
			if(stats.weapon == "air" && stats.stamina < 4) stats.stamina += 0.1
			if(!wasInWater) {
				wasInWater = true
				vspeed /= 2.0
				newActor(Splash, x, y)
			}
			an["fall"] = an["float"]

			//Animation states
			animOffset = 0.0
			switch(anim) {
				case "swimF":
				case "swimU":
				case "swimD":
				case "swimUF":
				case "swimDF":
					frame += sqrt(abs(hspeed * hspeed) + abs(vspeed * vspeed)) / 12
					break
				case "hurt":
					frame += 0.2
					if(floor(frame) > an[anim].len() - 1) {
						anim = "fall"
						frame = 0.0
					}
					break
				case "fall":
					frame += 0.01
					break
				case "rollingSlash":
					frame = (slashTimer / 3.0) * 8.0
					if(!slashing) {
						anim = "fall"
						slashing = false
					}
					break
			}

			frame = wrap(abs(frame), 0.0, an[anim].len() - 1)

			//Swich swim directions
			if(anim != "hurt" && anim != "rollingSlash") {
				if(fabs(hspeed) < 0.3 && fabs(vspeed) < 0.2) anim = "fall" //To be replaced with regular swim sprites later
				if(fabs(hspeed) > 0.3) anim = "swimF"
				if(vspeed > 0.2) anim = "swimD"
				if(vspeed < -0.2) anim = "swimU"
				if(fabs(hspeed) > 0.3 && vspeed > 0.2) anim = "swimDF"
				if(fabs(hspeed) > 0.3 && vspeed < -0.2) anim = "swimUF"
			}

			//Movement
			if(canMove && anim != "rollingSlash" && anim != "hurt") {
				accel = 0.15
				mspeed = 2.0
				if(zoomies > 0) mspeed *= 2.0

				if(getcon("right", "hold", true, playerNum) && hspeed < mspeed && anim != "wall" && anim != "slide" && anim != "hurt") hspeed += accel
				if(getcon("left", "hold", true, playerNum) && hspeed > -mspeed && anim != "wall" && anim != "slide" && anim != "hurt") hspeed -= accel
				if(getcon("down", "hold", true, playerNum) && vspeed < mspeed && anim != "wall" && anim != "slide" && anim != "hurt") vspeed += accel
				if(getcon("up", "hold", true, playerNum) && vspeed > -mspeed && anim != "wall" && anim != "slide" && anim != "hurt") vspeed -= accel
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
			if(anim != "climb" && anim != "wall") {
				if(hspeed > 0.1) flip = 0
				if(hspeed < -0.1) flip = 1
			}

			//Attacks
			if(canMove && anim != "hurt" && getcon("shoot", "press", true, playerNum) && !slashing) {
				slashing = true
				hspeed /= 2.0
				vspeed /= 2.0
				anim = "rollingSlash"
				local c = fireWeapon(RollingSlash, x, y, 1, id)
				c.element = stats.weapon
				slashTimer = 0.0
				firetime = 60
			}
			if(canMove && anim != "hurt" && getcon("spec1", "press", true, playerNum) && !slashing) {
				slashing = true
				hspeed /= 2.0
				vspeed /= 2.0
				anim = "rollingSlash"
				local c = fireWeapon(RollingSlash, x, y, 1, id)
				c.element = stats.subitem
				slashTimer = 0.0
				firetime = 60
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
						break
					}
				}

				//If no step was taken, slow down
				if(didstep == false && fabs(hspeed) >= 1) hspeed -= (hspeed / fabs(hspeed))
				else if(didstep == false && fabs(hspeed) < 1) hspeed = 0
			}
		}

		if(anim == "slide" || anim == "crawl") shape = shapeSlide
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

		if(hurt > 0 && invincible == 0) {
			if(blinking == 0) {
				blinking = 60
				playSound(sndHurt, 0)
				if(stats.weapon == "earth" && anim == "slide" && stats.stamina > 0) {
					stats.stamina -= hurt
					guardtime = 180
					blinking = 120
					newActor(Spark, x, y)
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
		if(stats.health == 0) {
			die()
			return
		}
	}

	function draw() {
		if(!hidden) {
			switch(stats.weapon) {
				case "normal":
					sprite = mySprNormal
					damageMult = damageMultN
					break

				case "fire":
					sprite = mySprFire
					damageMult = damageMultF
					break

				case "ice":
					sprite = mySprIce
					damageMult = damageMultI
					break

				case "air":
					sprite = mySprAir
					damageMult = damageMultA
					break

				case "earth":
					sprite = mySprEarth
					damageMult = damageMultE
					break

				case "shock":
					sprite = mySprShock
					damageMult = damageMultS
					break

				case "water":
					sprite = mySprWater
					damageMult = damageMultW
					break

				case "dark":
					sprite = mySprDark
					damageMult = damageMultD
					break

				case "light":
					sprite = mySprLight
					damageMult = damageMultL
					break
			}

			//Invincibility
			if(invincible > 0) invincible--
			if(((invincible % 2 == 0 && invincible > 240) || (invincible % 4 == 0 && invincible > 120) || invincible % 8 == 0) && invincible > 0) newActor(Glimmer, x + 10 - randInt(20), y + 10- randInt(20))

			if(anim != null) {
				frame = wrap(frame, 0, an[anim].len() - 1)
				drawSpriteZ(2, sprite, an[anim][floor(frame)] + animOffset, x - camx, y - camy, 0, flip, 1, 1, (blinking ? wrap(blinking, 0, 10).tofloat() / 10.0 : 1))
				if((slashing || animOffset > 0) && (anim == "walk" || anim == "run"))
					drawSpriteZ(2, sprite, 80 + min(slashTimer, 3), x - camx, y - camy, 0, flip, 1, 1, (blinking ? wrap(blinking, 0, 10).tofloat() / 10.0 : 1))
				
			}
			if(debug) {
				setDrawColor(0x008000ff)
				shape.draw()
			}

			//After image
			if((zoomies > 0 || anim == "stomp" ) && getFrames() % 2 == 0)
				newActor(AfterImage, x, y, [sprite, an[anim][frame] + animOffset, 0, flip, 0, 1, 1])
		}

		drawLight(sprLightBasic, 0, x - camx, y - camy)

		//Transformation flash
		if(tftime != -1) {
			if(tftime < 4) {
				if(!hidden)
					drawSpriteZ(1, sprTFflash, tftime, x - camx, y - camy)
				tftime += 0.25
			} else tftime = -1
		}
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
			deleteActor(id)
			if(playerNum == 1) gvPlayer = false
			if(playerNum == 2) gvPlayer2 = false
			newActor(DeadCyra, x, y, [sprite, an["hurt"], playerNum])
			stats.health = 0
		}
	}

	function _typeof(){ return "Cyra" }
}

// Note: his death basically ends with him lying down dead.
::DeadCyra <- class extends Actor {
	hspeed = -2.0
	vspeed = -2.0
	timer = 150
	sprite = null
	frame = 0.0
	anim = null
	playerNum = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(!gvPlayer && !gvPlayer2) stopMusic()
		playSound(sndDie, 0)
		sprite = _arr[0]
		anim = _arr[1]
		playerNum = _arr[2]
	}

	function run() {
		vspeed += 0.1
		x += hspeed
		y += vspeed
		timer--
		if(timer == 0) {
			if(!gvPlayer && !gvPlayer2) {
				startPlay(gvMap.file, true, true)
				if(game.check == false) {
					gvIGT = 0
				}
			}

			if(game.check == false || game.difficulty > 0) {
				if(playerNum == 1) game.ps.weapon = "normal"
				if(playerNum == 2) game.ps2.weapon = "normal"
			}
		}
	}

	function draw() {
		drawSprite(sprite, anim[wrap(getFrames() / 15, 0, anim.len() - 1)], floor(x - camx), floor(y - camy))
		drawLight(sprLightBasic, 0, x - camx, y - camy)
	}

	function _typeof() { return "DeadPlayer" }
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

		x += hspeed
		y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed)

		shape.setPos(x, y)

	}
	function draw() {
		drawSpriteEx(sprCyraSwordWave, floor(frame), x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 2.0 / 8.0, 2.0 / 8.0)
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

		if(getFrames() % 3 == 0) {
			local c = actor[newActor(FlameTiny, x - 4 + randInt(8), y - 4 + randInt(8))]
			c.frame = 4
		}
		x += hspeed
		y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed)

		shape.setPos(x, y)

	}
	function draw() {
		drawSpriteEx(sprCyraFireWave, getFrames() / 2, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 2.0 / 8.0, 2.0 / 8.0)
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

		if(getFrames() % 5 == 0) newActor(Glimmer, x - 4 + randInt(8), y - 4 + randInt(8))

		x += hspeed
		y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed)

		shape.setPos(x, y)

	}
	function draw() {
		drawSpriteEx(sprCyraFreezeWave, getFrames() / 2, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprLightIce, 0, x - camx, y - camy, 0, 0, 2.0 / 8.0, 2.0 / 8.0)
	}

	function destructor() {
		fireWeapon(ExplodeI, x, y, alignment, owner)
	}
}


::ElectricWaveCS  <- class extends WeaponEffect {
	element = "shock"
	angle = 0
	timer = 15
	piercing = 10
	power = 1

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		shape = Rec(x, y, 3, 3, 0)
	}

	function physics() {
		//Shrink hitbox
		timer--
		if(timer == 0) deleteActor(id)
		if(!placeFree(x, y))
			deleteActor(id)

		hspeed *= 0.98
		vspeed *= 0.98

		x += hspeed
		y += vspeed

		angle = pointAngle(0, 0, hspeed, vspeed)

		shape.setPos(x, y)

		local target = null
		local tdist = 128.0

		//Find target
		foreach(i in actor) {
			if(i instanceof Enemy && distance2(x, y, i.x, i.y) <= tdist && i.health > 0 && !("squish" in i && i.squish) && !hitTest(shape, i.shape)) {
				tdist = distance2(x, y, i.x, i.y)
				target = i
			}
		}

		if(target != null) {
			hspeed *= 0.98
			vspeed *= 0.98
			hspeed += lendirX(0.8, pointAngle(x, y, target.x, target.y))
			vspeed += lendirY(0.8, pointAngle(x, y, target.x, target.y))
		}
	}

	function draw()  {
		drawSpriteEx(sprCyraElectricWave, getFrames() / 2, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 1.0 / 8.0, 1.0 / 8.0)
	}

	function animation() {}

	function destructor() {
		fireWeapon(ExplodeT, x, y, alignment, owner)
	}
}


::WaterCrescent <- class extends WeaponEffect {
	frame = 0.0
	timer = 50
	angle = 0
	element = "water"
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

		 hspeed *= 0.95
		 vspeed *= 0.95

		x += hspeed
		y += vspeed
		if(!placeFree(x, y)) {
			deleteActor(id)
		}

		if(y > gvMap.h) {
			deleteActor(id)
			newActor(Poof, x, y)
		}

		angle = pointAngle(0, 0, hspeed, vspeed)

		shape.setPos(x, y)

	}
	function draw() {
		drawSpriteEx(sprWaterCrescent, getFrames() / 1, x - camx, y - camy, angle, 0, 1, 1, 1)
		drawLightEx(sprLightFire, 0, x - camx, y - camy, 0, 0, 2.0 / 8.0, 2.0 / 8.0)
	}

	function destructor() {
		fireWeapon(ExplodeW, x, y, alignment, owner)
	}
}


::Kiki2 <- class extends Cyra {
	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y, _arr)

		mySprNormal = sprKiki2
		mySprFire = sprKiki2
		mySprIce = sprKiki2
		mySprAir = sprKiki2
		mySprEarth = sprKiki2
		mySprShock = sprKiki2
	}

	function _typeof() { return "Kiki2" }
}
