// If this doesn't get finished then uhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh damn
// General
::reloadAzzy <- function() {
    donut("contrib/azzy/script.nut")
}

// Cybergrind
::cybergrindReward <- 0;
::cybergrindWave <- 1;

::cybergrindEnemies <- [[Deathcap, 1, true, 0], [Owl, 2, null, 1]]; // class, wave requirement, args, ground type requirement
::cybergrindAllowedEnemies <- []; // index in cybergrindEnemies
::cybergrindCurrentEnemies <- [];
::cybergrindSpawnSpots <- [[216, 2025, 0], [400, 1905, 1], [400, 1920, 0]]; // x, y, location type (0 is ground, 1 is air, 2 is water)

::cybergrindCalculateWaveReward <- function() {
    cybergrindReward += 30 + (2 * cybergrindWave)
}

::cybergrindStart <- function() {
    cybergrindReward = 0;
    cybergrindWave = 1;
    game.colorswitch[0] = true;
    cybergrindSpawn()
}

::cybergrindSpawn <- function() {
    cybergrindCurrentEnemies.clear()
    local enemies = [];
    foreach (i in cybergrindSpawnSpots) {
        switch (i[2]) {
            case 0:
                cybergrindCurrentEnemies.append(newActor(cybergrindEnemies[0][0], i[0], i[1], cybergrindEnemies[0][2]));
                break;
            case 1:
                break;
            case 2:
                break;
        }
    }
}

::cybergrindProgress <- function() {
    cybergrindCalculateWaveReward()
    cybergrindWave += 1
    cybergrindAllowedEnemies.clear()
    cybergrindSpawn()
}

::cybergrindEnd <- function() {
    game.coins += cybergrindReward
    game.colorswitch[0] = false;
    cybergrindReward = 0;
    cybergrindWave = 1;
}

::cybergrindCheckProgress <- function() {
    local progress = true;
    local text = "WAVE: " + cybergrindWave;
    drawText(font2, (screenW() / 2) - (text.len() * 4), 50, text)
    foreach (i in cybergrindCurrentEnemies) {
        if (checkActor(i)) {
            progress = false;
        }
    }
    if (progress) {
        cybergrindProgress()
    }
}

// Blizzard damage
::blizzardTime <- 0

::damageByBlizzard <- function(modifier = 1) {
    if (blizzardTime > 180) {
        gvPlayer.hurt = 2 * modifier
        blizzardTime = 0
    }
    else {
        blizzardTime++;
    }
}

// Enemies
::dbgMakeYeti <- function() {
    newActor(EnemYeti, 100, 100, null)
}
::EnemYeti <- class extends Enemy {
	phantom = false //Allows the boss to phase through walls in their intro
	active = false
	routine = null
	hspeed = 0.0
	vspeed = 0.0
	flip = 0
	gravity = 0.1
	frame = 0.0
	blinking = 0.0
	blinkSpeed = 0.2
	canBeStomped = false
	ready = false
	//Animations
	anIdle = [0.0, 7.0, "idle"]
	anWalk = [8.0, 15.0, "walk"]
	anRun = [16.0, 23.0, "run"]
	anJump = [24.0, 27.0, "jump"]
	anFall = [28.0, 31.0, "fall"]
	anHurt = [32.0, 33.0, "hurt"]
	anDizzy = [34.0, 35.0, "dizzy"]
	anShake = [36.0, 39.0, "shake"]
	anThrow = [40.0, 43.0, "throw"]
	anCheer = [44.0, 47.0, "cheer"]

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
	}

	//Boss specific variables
	health = 10
	eventTimer = 0
	eventStage = 0
	hasThrown = false
	touchDamage = 2.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		shape = Rec(x, y, 14, 20, 0, 0, 4)
		routine = ruIntroCheer
		eventTimer = 160
	}

	function _typeof() { return "EnemYeti" }

	function turnToPlayer() {
		if(gvPlayer) {
			if(gvPlayer.x > x) flip = 0
			else flip = 1
		}
	}

	function physics() {
		//Movement
		if(placeFree(x + hspeed, y) || phantom) x += hspeed
		else for(local i = 0; i < fabs(hspeed * 1.5); i++) {
			if(placeFree(x + hspeed, y - i)) {
				x += hspeed
				y =- i
				break
			}
		}

		vspeed += gravity
		if(placeFree(x, y + vspeed) || routine == ruDefeated) y += vspeed
		else vspeed /= 4.0

		if(health <= 0 && routine != ruDefeated) {
			phantom = true
			vspeed = -2.0
			routine = ruDefeated
			if(flip == 0) hspeed = -1.0
			else hspeed = 1.0
		}

		shape.setPos(x, y)

		//Animation
		switch(anim) {
			case anWalk:
				frame += 0.1
				break
			case anIdle:
			case anDizzy:
				frame += 0.15
				break
			case anRun:
				frame += 0.3
				break
			case anThrow:
				frame += 0.1
				if(frame < anim[0] + 2) frame += 0.1
				if(frame > anim[1] + 1) anim = anIdle
				break
			case anCheer:
			case anHurt:
			case anShake:
				frame += 0.2
				break
			case anJump:
				if(frame < anim[1] + 1) frame += 0.2
				if(frame >= anim[1] + 1) {
					if(vspeed < 0) frame -= 0.2
					else {
						anim = anFall
						frame = anim[0]
					}
				}
				break
			case anFall:
				if(frame < anim[1]) frame += 0.1
				else frame -= 0.5
				break
		}
		if(anim != null) frame = wrap(frame, anim[0], anim[1])

		if(anim != anHurt) {
			if(hspeed > 0) flip = 0
			if(hspeed < 0) flip = 1
		}

		//Draw
		if(blinking == 0) drawSpriteEx(sprYeti, frame, x - camx, y - camy, 0, flip.tointeger(), 1, 1, 1)
		else drawSpriteEx(sprYeti, frame, x - camx, y - camy, 0, flip.tointeger(), 1, 1, max(wrap(blinking, 0, 1), (anim == anHurt).tointeger()))
		if(debug) {
			setDrawColor(0x008000ff)
			shape.draw()
		}

		//Set damage resistance
		if(routine == ruDizzy) damageMult.stomp = 4.0
		else damageMult.stomp = 1.0
		routine()
	}

	function ruIntroCheer() {
		ready = true
		eventTimer--
		if(eventTimer < 100) anim = anCheer
		else anim = anIdle
		if(eventTimer == 100) playSound(sndGrowl, 0)
		if(eventTimer == 0) {
			eventTimer = 60
			routine = ruIdle
		}
	}

	function ruIdle() {
		hspeed = 0.0
		anim = anIdle
		eventTimer--
		if(eventTimer == 0) {
			switch(eventStage) {
				case 0:
					eventStage++
					routine = ruJump
					eventTimer = 240
					break
				case 1:
					eventStage++
					routine = ruThrow
					eventTimer = 120
					anim = anThrow
					frame = anim[0]
					turnToPlayer()
					hasThrown = false
					break
				case 2:
					eventStage++
					routine = ruCharge
					turnToPlayer()
					break
				default:
					eventStage = 0
					eventTimer = 1
					break
			}
		}
	}

	function ruJump() {
		eventTimer--
		if(anim == anIdle) {
			anim = anJump
			frame = anim[0]
		}

		if(floor(frame) == anim[0] + 1 && anim == anJump) {
			vspeed = -4.0
			if(gvPlayer) {
				hspeed = (gvPlayer.x - x) / 64.0
			}
		}

		if(anim == anFall && !placeFree(x, y + 1)) {
			hspeed = 0.0
			vspeed = 0.0
			if(eventTimer > 0) {
				anim = anJump
				frame = anim[0]
				newActor(YetiShock, x, y + 32, ((40 - health).tofloat() / 20.0) + 1.0)
			}
			else {
				eventTimer = 60
				routine = ruIdle
				playSound(sndCrush, 0)
			}
		}
	}

	function ruThrow() {
		eventTimer--

		if(anim == anThrow && frame >= anim[0] + 1 && !hasThrown) {
			local c = actor[newActor(OrangeBounce, x, y - 16)]
			if(flip == 0) c.hspeed = 2.0
			else c.hspeed = -2.0
			hasThrown = true
		}

		if(eventTimer <= 0) {
			routine = ruIdle
			eventTimer = 60
		}
	}

	function ruCharge() {
		anim = anRun
		if(flip == 0) hspeed = 3.0
		else hspeed = -3.0

		local c = fireWeapon(MeleeHit, x, y, 1, id)
		c.shape = clone(shape)
		c.shape.setPos(x + hspeed * 2, y)

		if(!placeFree(x + hspeed, y)) {
			vspeed = -8.0
			hspeed = -hspeed / 3.0
			anim = anHurt
			frame = anim[0]
			routine = ruDizzy
			eventTimer = 240
			playSound(sndGrowl, 0)
			blinking = 0.0
		}
	}

	function ruDizzy() {
		canBeStomped = true
		eventTimer--
		if(anim == anHurt && !placeFree(x, y + 1)) {
			vspeed = 0.0
			hspeed = 0.0
			anim = anDizzy
		}
		if(eventTimer < 60) anim = anShake
		if(eventTimer <= 0) {
			routine = ruIdle
			eventTimer = 60
			canBeStomped = false
		}
	}

	function ruHurt() {
		anim = anHurt
		eventTimer--
		blinking = 12.0
		if(eventTimer <= 0) {
			eventTimer = 60
			routine = ruIdle
			canBeStomped = false
		}
		if(!placeFree(x, y + 1) && vspeed > 0) hspeed = 0.0
	}

	function ruDefeated() {
		eventTimer--
		phantom = true
		anim = anHurt
		gravity = 0.05
		blinking = 0
	}

	function hurtBlast() {
		if(health <= 0) return
		blinking = 12.0
		health -= 2
		playSound(sndBossHit, 0)
	}

	function hurtFire() { hurtBlast() }
	function hurtShock() { hurtBlast() }

	function hurtStomp() {
		if(health <= 0 || phantom) return
		routine = ruHurt
		eventTimer = 30
		canBeStomped = false
		vspeed = -2.0
		if(gvPlayer) {
			gvPlayer.vspeed = -2.0
			if(flip == 0) hspeed = -1.0
			else hspeed = 1.0
		}
		if(gvPlayer) if(gvPlayer.rawin("anStomp")) if(gvPlayer.anim == gvPlayer.anStomp) health -= 10
		if(health > 0) playSound(sndBossHit, 0)
		else playSound(sndDie, 0)
	}

	function hitPlayer() {
		if(blinking > 0 || phantom) return
		if(routine != ruDizzy) base.hitPlayer()
	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false, _stomp = false) {
		if(blinking > 0 || phantom) return

		local damage = _mag * damageMult[_element]
		if(_cut) damage *= damageMult["cut"]
		if(_blast) damage *= damageMult["blast"]
		if(_stomp) damage *= damageMult["stomp"]

		health -= damage
		if(damage > 0) blinking = blinkMax

		if(routine == ruDizzy && _stomp) {
			hurtStomp()
		}

		popSound(sndBossHit)
	}

	function die() {}
}
