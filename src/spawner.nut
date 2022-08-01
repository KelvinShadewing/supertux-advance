::Spawner <- class extends Actor {
	myob = -1
	timer = 60
	maxTime = 60
	myClass = ""
	infinite = false

	constructor(_x, _y, _arr) {
		base.constructor(_x, _y)
		local arg
		if(typeof _arr == "string") arg = split(_arr, ",")
		if(typeof _arr == "array") arg = _arr
		myClass = arg[0]
		if(1 in arg) if(canint(arg[1])) {
			maxTime = arg[1].tointeger()
			timer = arg[1].tointeger()
		}
		if(2 in arg) if(arg[2]) infinite = true

		if(myClass in getroottable()) {
			myob = newActor(getroottable()[myClass], x, y)
			if("nocount" in actor[myob]) actor[myob].nocount = true
		}
		else deleteActor(id)
	}

	function run() {
		//Only be active on screen
		if(x < camx) return
		if(y < camy) return
		if(x > camx + screenW()) return
		if(y > camy + screenH()) return

		if(infinite || !(myob in actor)) {
			timer--
			if(timer == 0) {
				timer = maxTime
				if(myClass in getroottable()) myob = newActor(getroottable()[myClass], x, y)
				if("nocount" in actor[myob]) actor[myob].nocount = true
			}
		}
	}
}