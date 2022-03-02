::NPC <- class extends Actor {
	shape = 0
	text = ""
	useflip = 0
	flip = 0
	sprite = 0
	sayfunc = null
	arr = null
	talki = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y - 16, 20, 16, 0)
		flip = randInt(2)

		if(_arr != null) {
			local argv = split(_arr, ", ")

			if(getroottable().rawin(argv[0])) sprite = getroottable()[argv[0]]
			useflip = argv[1].tofloat()

			sayfunc = argv[2]
			arr = []

			for(local i = 3; i < argv.len(); i++) {
				arr.push(textLineLen(gvLangObj["npc"][argv[i]], 52))
			}
		}
	}

	function run() {
		if(gvPlayer && sayfunc != null) {
			if(hitTest(shape, gvPlayer.shape) && getcon("up", "press") && this.rawin(sayfunc)) this[sayfunc]()

			if(gvInfoBox == text) if(!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 32)) gvInfoBox = ""

			if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 32)) {
				if(x > gvPlayer.x + 2) flip = 1
				if(x < gvPlayer.x - 2) flip = 0
			}
		}

		if(useflip) drawSpriteEx(sprite, getFrames() * useflip, x - camx, y - camy, 0, flip, 1, 1, 1)
		else drawSpriteEx(sprite, flip, x - camx, y - camy, 0, 0, 1, 1, 1)
	}

	function say() {
		text = arr[talki]
		gvInfoBox = text
		talki++
		if(talki >= arr.len()) talki = 0
	}

	function sayRand() {
		text = arr[randInt(arr.len())]
		gvInfoBox = text
	}

	function sayChar() {
		switch(typeof gvPlayer) {
			case "Tux":
				text = arr[0]
				break
			case "Konqi":
				text = arr[1]
				break
			case "Midi":
				text = arr[2]
				break
			default:
				text = arr[3]
				break
		}
		gvInfoBox = text
	}

	function rescueKonqi() {
		sayChar()
		freeKonqi()
	}

	function rescueMidi() {
		sayChar()
		freeMidi()
	}

	function rescueFriend() {
		sayChar()
		//Find who to free based on sprite
		if(sprite == sprXue) if(!game.friends.rawin("Xue")) game.friends.Xue <- true
		if(sprite == sprGnu) if(!game.friends.rawin("Gnu")) game.friends.Gnu <- true
		if(sprite == sprPlasmaBreeze) if(!game.friends.rawin("PlasmaBreeze")) game.friends.PlasmaBreeze <- true
		if(sprite == sprRockyRaccoon) if(!game.friends.rawin("RockyRaccoon")) game.friends.RockyRaccoon <- true
		if(sprite == sprPygame) if(!game.friends.rawin("Pygame")) game.friends.Pygame <- true
		if(sprite == sprGaruda) if(!game.friends.rawin("Garuda")) game.friends.Garuda <- true
	}

	function _typeof() { return "NPC" }
}

::freeKonqi <- function() {
	if(!game.characters.rawin("Konqi")) game.characters["Konqi"] <- ["sprKonqiOverworld", "sprKonqiDoll", "sprKonqi", [8, 9]]
	if(!game.friends.rawin("Konqi")) game.friends["Konqi"] <- true
}

::freeMidi <- function() {
	if(!game.characters.rawin("Midi")) game.characters["Midi"] <- ["sprMidiOverworld", "sprMidiDoll", "sprMidi", [177, 236]]
	if(!game.friends.rawin("Midi")) game.friends["Midi"] <- true
}