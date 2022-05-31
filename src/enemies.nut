::Enemy <- class extends PhysAct {
	health = 1.0
	active = false
	frozen = 0
	icebox = -1
	nocount = false
	damageMult = null
	blinking = 0
	blinkMax = 10

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

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
	}

	function physics() {
		if(active) {

		}
		else {
			if(inDistance2(x, y, camx + (screenW() / 2), camy + (screenH() / 2), 240)) active = true
		}

		if(blinking > 0) blinking--

		base.physics()
	}

	function getHurt(_mag, _element, _cut, _blast) {
		if(blinking > 0) return

		local damage = _mag * damageMult[_element]
		if(_cut) damage *= damageMult["cut"]
		if(_blast) damage *= damageMult["blast"]

		health -= damage
		blinking = blinkMax
	}
}