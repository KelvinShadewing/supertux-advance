::Timeline <- class extends Actor {
	sequence = null
	step = 0
	done = false

	constructor(x, y, _arr = null) {
		base.constructor(x, y)

		sequence = _arr
	}

	function run() {
		if(sequence == null || done) {
			deleteActor(id)
			return
		}

		if(sequence.rawin(step)) sequence[step](this)
		step++
	}
}

::tlnTest <- {
	"0" : function(runner) {
		print("Started test timeline.")
	}

	"20" : function(runner) {
		print("20")
	}

	"40" : function(runner) {
		print("40")
		runner.done = true
	}
}