///////////////////////
// BASE PLAYER CLASS //
///////////////////////

//TODO:
//Base class for all players
//Child classes will use flags to determine what abilities can be used

::Player <- class extends PhysAct {
	//Basic variables
	anim = null
	sprite = 0
	frame = 0.0
	shapeStand = null
	shapeCrouch = null
	shapeSwim = null

	//Animation states defined in child classes
	anStand = null
	anWalk = null
	anJog = null
	anRun = null
	anJumpU = null
	anJumpT = null
	anFall = null
	anDive = null
	anSlide = null
	anCrawl = null
	anHurt = null

	//Ability flags
	canStomp = false //Mario-like jump attack
	canGroundPound = true //Ground stomp attack
	canSlide = false //Slide attack
	canMove = true //Movement unlocked, set to false during cutscenes or when player restrained
	held = null
	useMouse = false //Draw the cursor when playing as this character
	mouseSprite = sprCursor

	//Physics stats
	weight = 1.0
	jumpForce = 2.0
	walkSpeed = 1.0
	jogSpeed = 2.0
	runSpeed = 3.0
	accel = 0.2
	friction = 0.1
	swimming = false

	hurt = 0 //How much damage has been taken
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
	blinking = 0 //Number of iframes remaining
	coffeeTime = 0

	//Misc
	heldby = 0
	holding = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)

		if(!gvPlayer) gvPlayer = this
	}

	function run() {
		base.run()

		if(actor.rawin("WeaponEffect")) foreach(i in actor["WeaponEffect"]) {
			//Skip weapons that don't hurt the player
			if(i.alignment == 1) continue
			if(i.owner == id) continue

			if(hitTest(shape, i.shape)) {
				getHurt(i.power, i.element, i.cut, i.blast)
				if(i.piercing == 0) deleteActor(i.id)
				else i.piercing--
			}
		}

		if(coffeeTime > 0) coffeeTime--
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

	function swapitem() {
		if(game.subitem == 0) return
		local swap = game.subitem

		if(game.weapon == game.subitem) {
			if(game.maxEnergy < 4 - game.difficulty) {
				game.maxEnergy++
				game.subitem = 0
				tftime = 0
				playSound(sndHeal, 0)
			}
			return
		}

		if(swap < 5) {
			game.subitem = game.weapon
			game.weapon = 0
		}

		switch(swap) {
			case 1:
				newActor(FlowerFire, x + hspeed, y + vspeed)
				break
			case 2:
				newActor(FlowerIce, x + hspeed, y + vspeed)
				break
			case 3:
				newActor(AirFeather, x + hspeed, y + vspeed)
				break
			case 4:
				newActor(EarthShell, x + hspeed, y + vspeed)
				break
			case 5:
				if(game.health < game.maxHealth) {
					newActor(MuffinBlue, x + hspeed, y + vspeed)
					game.subitem = 0
				}
				break
			case 6:
				if(game.health < game.maxHealth) {
					newActor(MuffinRed, x + hspeed, y + vspeed)
					game.subitem = 0
				}
				break
			case 7:
				newActor(Starnyan, x + hspeed, y + vspeed)
				break
		}
	}
}