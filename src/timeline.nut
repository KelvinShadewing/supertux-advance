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

::tlnWalkAndJump <- {
	"0" : function(runner) {
		gvAutoCon = true
		autocon.a.right = true
	}

	"1" : function(runner) {
		if(gvPlayer) {
			if(!gvPlayer.placeFree(gvPlayer.x + 4, gvPlayer.y))
				autocon.a.jump = true
			if(!gvPlayer.placeFree(gvPlayer.x, gvPlayer.y + 1) && gvPlayer.vspeed > 0)
				autocon.a.jump = false
		}

		if(autocon.a.jump && !autocon.a.wasJump)
			print("jumped")

		runner.step--
	}
}