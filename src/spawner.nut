::Spawner <- class extends PhysAct {
	myob = -1
	timer = 60
	maxTime = 60
	myClass = ""
	infinite = false
	shape = null

	constructor(_x, _y, _arr) {
		base.constructor(_x, _y)
		local arg
		if(typeof _arr == "string") arg = split(_arr, ",")
		if(typeof _arr == "array") arg = _arr
		myClass = arg[0]
		if(1 in arg && canint(arg[1])) {
			maxTime = arg[1].tointeger()
			timer = arg[1].tointeger()
		}
		if(2 in arg && arg[2] != "0" && arg[2] != "false")
			infinite = true

		if(3 in arg)

		if(myClass in getroottable()) {
			myob = newActor(getroottable()[myClass], x, y)
			if("nocount" in actor[myob]) actor[myob].nocount = true
		}
		else deleteActor(id)
		shape = Rec(x, y, 8, 8, 0)
	}

	function run() {
		//Only be active on screen
		if(!isOnScreen()) return

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