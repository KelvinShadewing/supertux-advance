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

		if(sequence.rawin(step.tostring())) sequence[step.tostring()](this)
		step++
	}

	function _typeof() { return "Timeline" }
}

::runTimeline <- function(sequence) { return newActor(Timeline, 0, 0, sequence) }

::stopTimeline <- function(tln) { if(typeof tln == "Timeline") deleteActor(tln.id) }

::tlnTest <- {
	"0" : function(runner) {
		print("Started test timeline.")
	}

	"20" : function(runner) {
		print("20")
	}

	"40" : function(runner) {
		print("40")
		print(jsonWrite(runner.sequence))
		print(jsonWrite(actor))
		runner.done = true
	}
}