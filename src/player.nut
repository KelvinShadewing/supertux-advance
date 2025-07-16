///////////////////////
// BASE PLAYER CLASS //
///////////////////////

// TODO:
// Base class for all players
// Child classes will use flags to determine what abilities can be used

Player <- class extends PhysAct {
	playerNum = 0

	// Basic variables
	anim = null
	sprite = 0
	frame = 0.0
	shapeStand = null
	shapeCrouch = null
	shapeSwim = null
	resTime = 0
	endMode = false
	endSpeed = 0
	xstart = 0.0
	ystart = 0.0
	ehspeed = 0.0 // Environmental hspeed
	evspeed = 0.0 // Environmental vspeed

	// Ability flags
	canStomp = false // Mario-like jump attack
	stompDamage = 1
	canGroundPound = true // Ground stomp attack
	canSlide = false // Slide attack
	canMove = true // Movement unlocked, set to false during cutscenes or when player restrained
	held = null
	useMouse = false // Draw the cursor when playing as this character
	mouseSprite = sprCursor
	inMelee = false // In a state where the player damages enemies by touch
	magnetic = false
	advancedClimbing = false
	invincible = 0
	mustSink = false // If the player can die by going too far under water

	// Physics stats
	weight = 1.0
	jumpForce = 2.0
	walkSpeed = 1.0
	jogSpeed = 2.0
	runSpeed = 3.0
	accel = 0.2
	friction = 0.1
	baseFriction = 0.1
	swimming = false
	nowInWater = false
	wasInWater = false
	onWall = false
	wasOnGround = false

	freeUp = false
	freeDown = false
	freeLeft = false
	freeRight = false

	hurt = 0 // How much damage has been taken
	hurtType = "normal"
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
	blinking = 0 // Number of iframes remaining
	zoomies = 0
	stats = null
	hidden = false

	// Misc
	heldby = 0
	holding = 0
	otherPlayer = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		// Figure out which player this is
		if(!gvPlayer) {
			gvPlayer = this
			stats = game.ps
			playerNum = 1
		}
		else if(gvPlayer && !gvPlayer2) {
			gvPlayer2 = this
			stats = game.ps2
			playerNum = 2
		}

		if(stats.health <= 0 || game.difficulty < 1)
			stats.health = game.maxHealth

		xstart = _x
		ystart = _y
	}

	function physics() {
		if(ehspeed > 0 && !getcon("right", "hold", true, playerNum))
			ehspeed -= friction
		if(ehspeed < 0 && !getcon("left", "hold", true, playerNum))
			ehspeed += friction
		if(fabs(ehspeed) < friction)
			ehspeed = 0.0

		if(evspeed > 0)
			evspeed -= friction
		if(evspeed < 0)
			evspeed += friction
		if(fabs(evspeed) < friction)
			evspeed = 0.0

		if(placeFree(x, y + evspeed)) y += evspeed
		else {
			evspeed /= 2
			if(fabs(evspeed) < 0.01) evspeed = 0
			if(placeFree(x, y + evspeed)) y += evspeed
		}

		if(ehspeed != 0) {
			wasOnGround = (!placeFree(x, y + 2) || onPlatform())

			if(placeFree(x + ehspeed, y)) { // Try to move straight
				x += ehspeed
				if(wasOnGround) for(local i = 0; i < min(max(8, abs(ehspeed * 3)), 12); i++) if(!placeFree(x, y + min(max(8, abs(ehspeed * 3)), 12) - i) && placeFree(x, y + 1) && !swimming && vspeed >= 0 && !onPlatform(ehspeed) && !onPlatform(ehspeed, -1)) {
					y += 1
				}
			} else {
				local didstep = false
				for(local i = 1; i <= 8; i++){ // Try to move up hill
					if(placeFree(x + ehspeed, y - i)) {
						x += ehspeed
						y -= i
						if(i > 2) {
							if(ehspeed > 0) ehspeed -= 0.2
							if(ehspeed < 0) ehspeed += 0.2
						}
						didstep = true
						// if(slippery && !swimming && !placeFree(xprev, yprev + 2)) vspeed -= 2.0
						break
					}
				}

				// If no step was taken, slow down
				if(didstep == false && fabs(ehspeed) >= 1) ehspeed -= (ehspeed / fabs(ehspeed))
				else if(didstep == false && fabs(ehspeed) < 1) ehspeed = 0
			}
		}
	}

	function run() {
		base.run()

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) {
			// Skip weapons that don't hurt the player
			if(i.alignment == 1 && !gvBattleMode) continue
			if(i.owner == id) continue
			if(i.box) continue

			if(hitTest(shape, i.shape)) {
				getHurt(i.power, i.element, i.cut, i.blast)
				if(i.piercing == 0) deleteActor(i.id)
				else i.piercing--
			}
		}

		if(playerNum == 1)
			otherPlayer = gvPlayer2
		if(playerNum == 2)
			otherPlayer = gvPlayer

		if(gvBattleMode && otherPlayer && !blinking) {
			// Get stomped
			if(hitTest(shape, otherPlayer.shape)) {
					if("invincible" in otherPlayer && otherPlayer.invincible > 0) hurt = 10
					else if(y > otherPlayer.y && vspeed < otherPlayer.vspeed && otherPlayer.canStomp && otherPlayer.placeFree(otherPlayer.x, otherPlayer.y + 2) && blinking == 0 && !otherPlayer.swimming) {
						if(getcon("jump", "hold", false, otherPlayer.playerNum))
							otherPlayer.vspeed = -8.0
						else
							otherPlayer.vspeed = -4.0
						hurt = otherPlayer.stompDamage
					}
					else if(otherPlayer.inMelee)
						hurt = 1
				}
		}

		if(invincible) {
			stats.energy += 1.0
			stats.stamina += 1.0
		}

		if(zoomies > 0) zoomies--
		if(resTime > 0) resTime--

		if(y > gvMap.h && (resTime > 0  || inWater(x, y) && !mustSink)) {
			y = gvMap.h
			if(!placeFree(x, y)) {
				local xrange = 0
				while(true) {
					xrange++
					if(placeFree(x + xrange, y)) {
						x += xrange
						break
					}
					if(placeFree(x - xrange, y)) {
						x -= xrange
						break
					}
				}
			}
		}

		if(y > gvMap.h + 16 && !inWater(x, y) || stats.health <= 0) {
			die()
			return
		}

		if(y < -100) y = -100.0
		if((y < 0 || vspeed == 0 && !onPlatform()) && !placeFree(x, y)) {
			local xrange = 0
			while(true) {
				xrange++
				if(placeFree(x + xrange, y)) {
					x += xrange
					break
				}
				if(placeFree(x - xrange, y)) {
					x -= xrange
					break
				}
			}
		}
		// escapeSolid()

		if(endMode) {
			if(hspeed < endSpeed && endSpeed > 0 && (placeFree(x + 1, y) || placeFree(x + 1, y - 2))) {
				hspeed += accel
				rspeed += accel
			}
			if(hspeed > endSpeed && endSpeed < 0 && (placeFree(x - 1, y) || placeFree(x - 1, y - 2))) {
				hspeed -= accel
				rspeed -= accel
			}
		}


		// Stage hazards
		if(onHazard(x, y)) hurt = min((ceil(game.maxHealth / 10.0) * damageMult.cut), 4 + (game.difficulty * 2))
		if(onDeath(x, y)) die(true)


		// Leave level
		if(x < 4) {
			x = 4
			if(getcon("left", "hold", false, playerNum) && !endMode && !gvTimeAttack && !gvBattleMode) gvExitTimer += 1.0
			gvExitSide = 0
			hspeed /= 2.0
		}
		if(x > gvMap.w - 4) {
			x = gvMap.w - 4
			if(getcon("right", "hold", false, playerNum) && !endMode && !gvTimeAttack && !gvBattleMode) gvExitTimer += 1.0
			gvExitSide = 1
			hspeed /= 2.0
		}

		// Stats
		stats.maxEnergy = 4 + game.energyBonus
		stats.maxStamina = 4 + game.staminaBonus

		if(stats.energy > stats.maxEnergy)
			stats.energy = stats.maxEnergy

		if(stats.stamina > stats.maxStamina)
			stats.stamina = stats.maxStamina

		if((wasInWater && !nowInWater || nowInWater && !wasInWater) && abs(vspeed) >= 2) {
			local liquidBody = (nowInWater ? nowInWater : wasInWater)
			newActor(Splash, x, liquidBody.y, liquidBody.substance)
		}

		if(holding != 0 && !checkActor(holding))
			holding = 0
	}

	function getHurt(_mag = 1, _element = "normal", _cut = false, _blast = false) {
		if(blinking > 0) return

		local damage = _mag * damageMult[_element]
		if(_cut) damage *= damageMult["cut"]
		if(_blast) damage *= damageMult["blast"]

		hurt = damage
	}

	function checkHurt() {
		if(!blinking) {
			if(hurt) {

			}
		}
		else blinking--
	}

	function atLadder(_x = -1, _y = -1) {
		// Save current location and move
		local ns = Rec(x + shape.ox, y + shape.oy, shape.w, shape.h, shape.kind)
		if(_x != -1)
			ns.x = _x
		if(_y != -1)
			ns.y = _y
		local cx = floor(ns.x / 16)
		local cy = floor(ns.y / 16)

		// Check that the solid layer exists
		local wl = null // Working layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				wl = gvMap.data.layers[i]
				break
			}
		}

		// Check against places in solid layer
		if(wl != null) {
			local tile = cx + (cy * wl.width)
			if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 29 || wl.data[tile] - gvMap.solidfid == 50 || (wl.data[tile] - gvMap.solidfid == 79 && advancedClimbing) || (wl.data[tile] - gvMap.solidfid == 81 && advancedClimbing) || (wl.data[tile] - gvMap.solidfid == 82 && advancedClimbing)) {
				gvMap.shape.setPos((cx * 16) + 8, (cy * 16) + 8)
				gvMap.shape.kind = 0
				gvMap.shape.w = 4.0
				gvMap.shape.h = 12.0
				if(hitTest(ns, gvMap.shape)) return true
			}
		}

		return false
	}

	function atCrossLadder() {
		// Save current location and move
		local ns = Rec(x + shape.ox, y + shape.oy, shape.w, shape.h, shape.kind)
		local cx = floor(x / 16)
		local cy = floor(y / 16)

		// Check that the solid layer exists
		local wl = null // Working layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				wl = gvMap.data.layers[i]
				break
			}
		}

		// Check against places in solid layer
		if(wl != null) {
			local tile = cx + (cy * wl.width)
			if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 80 || (wl.data[tile] - gvMap.solidfid == 81 && advancedClimbing)) {
				gvMap.shape.setPos((cx * 16) + 8, (cy * 16) + 8)
				gvMap.shape.kind = 0
				gvMap.shape.w = 8.0
				gvMap.shape.h = 8.0
				if(hitTest(ns, gvMap.shape)) return true
			}
		}

		return false
	}

	function atWallLadder() {
		// Save current location and move
		local ns = Rec(x + shape.ox, y + shape.oy, shape.w, shape.h, shape.kind)
		local cx = floor(x / 16)
		local cy = floor(y / 16)

		// Check that the solid layer exists
		local wl = null // Working layer
		for(local i = 0; i < gvMap.data.layers.len(); i++) {
			if(gvMap.data.layers[i].type == "tilelayer" && gvMap.data.layers[i].name == "solid") {
				wl = gvMap.data.layers[i]
				break
			}
		}

		// Check against places in solid layer
		if(wl != null) {
			local tile = cx + (cy * wl.width)
			if(tile >= 0 && tile < wl.data.len()) if(wl.data[tile] - gvMap.solidfid == 35 || wl.data[tile] - gvMap.solidfid == 36) {
				gvMap.shape.setPos((cx * 16) + 8, (cy * 16) + 8)
				gvMap.shape.kind = 0
				gvMap.shape.w = 1.0
				gvMap.shape.h = 12.0
				if(hitTest(ns, gvMap.shape)) return true
			}
		}

		return false
	}

	function swapitem() {
		if(stats.subitem == 0) return
		local swap = stats.subitem

		if(stats.weapon == stats.subitem) {
			if(stats.maxEnergy < 4 - game.difficulty) {
				stats.maxEnergy++
				stats.subitem = 0
				tftime = 0
				popSound(sndHeal, 0)
			}
			return
		}

		switch(swap) {
			case "fire":
				stats.subitem = stats.weapon
				stats.weapon = "fire"
				popSound(sndHeal, 0)
				tftime = 0
				break
			case "ice":
				stats.subitem = stats.weapon
				stats.weapon = "ice"
				popSound(sndHeal, 0)
				tftime = 0
				break
			case "air":
				stats.subitem = stats.weapon
				stats.weapon = "air"
				popSound(sndHeal, 0)
				tftime = 0
				break
			case "earth":
				stats.subitem = stats.weapon
				stats.weapon = "earth"
				popSound(sndHeal, 0)
				tftime = 0
				break
			case "water":
				stats.subitem = stats.weapon
				stats.weapon = "water"
				popSound(sndHeal, 0)
				tftime = 0
				break
			case "shock":
				stats.subitem = stats.weapon
				stats.weapon = "shock"
				popSound(sndHeal, 0)
				tftime = 0
				break
			
			case "muffinBlue":
				if(stats.health < game.maxHealth) {
					stats.health += 4
					for(local i = 0; i < 4; i++) newActor(Heal, x - 16 + randInt(32), y - 16 + randInt(32))
					popSound(sndHeal, 0)
					stats.subitem = 0
				}
				break
			case "muffinRed":
				if(stats.health < game.maxHealth) {
					stats.health += 16
					for(local i = 0; i < 4; i++) newActor(Heal, x - 16 + randInt(32), y - 16 + randInt(32))
					popSound(sndHeal, 0)
					stats.subitem = 0
				}
				break
			case "star":
				invincible = 645
				playMusic(musInvincible, -1)
				gvLastSong = ""
				stats.subitem = 0
				break
			case "coffee":
				popSound(sndGulp, 0)
				zoomies += 60 * 16
				stats.subitem = 0
				break
		}
	}

	function atZipline(_x = 0, _y = 0) {
		local found = [31, 32, 33, 34, 35, 39].find(tileGetSolid(x + _x, y - shape.h + _y))
		if(found != null)
			found++
		return found
	}
}

DeadPlayer <- class extends Actor {
	vspeed = -4.0
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
		y += vspeed
		timer--
		if(timer == 0 && !gvPlayer && !gvPlayer2) {
			startPlay(gvMap.file, true, true)

			if(game.check == false) {
				if(playerNum == 1) game.ps.weapon = "normal"
				if(playerNum == 2) game.ps2.weapon = "normal"
				gvIGT = 0
			}
		}
	}

	function draw() {
		drawSprite(sprite, anim[wrap(getFrames() / 15, 0, anim.len() - 1)], floor(x - camx), floor(y - camy))
		drawLight(sprLightBasic, 0, x - camx, y - camy)
	}

	function _typeof() { return "DeadPlayer" }
}