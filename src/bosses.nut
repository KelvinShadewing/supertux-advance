::Nolok <- class extends Enemy {
	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		shape = Rec(x, y, 8, 20)
	}

	function run() {
		base.run()
	}

	function _typeof() { return "Nolok" }
}