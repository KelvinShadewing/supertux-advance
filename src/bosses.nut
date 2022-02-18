::Boss <- class extends PhysAct {
	health = 100

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
	}
}

::Nolok <- class extends Boss {
	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 20)
	}

	function run() {
		base.run()
	}

	function _typeof() { return "Nolok" }
}