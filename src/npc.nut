::NPC <- class extends Actor {
	shape = 0
	text = ""
	useflip = false
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
			useflip = argv[1].tointeger()

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

			if(gvInfoBox == text) if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 32) gvInfoBox = ""

			if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 32) {
				if(x > gvPlayer.x + 2) flip = 1
				if(x < gvPlayer.x - 2) flip = 0
			}
		}

		if(useflip) drawSpriteEx(sprite, 0, x - camx, y - camy, 0, flip, 1, 1, 1)
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

	function freeKonqi() {
		sayChar()
		if(!game.characters.rawin("Konqi")) game.characters.Konqi <- sprKonqiOverworld
		if(!game.friends.rawin("Konqi")) game.friends.Konqi <- true
	}

	function freeMidi() {
		sayChar()
		if(!game.characters.rawin("Midi")) game.characters.Midi <- sprMidiOverworld
		if(!game.friends.rawin("Midi")) game.friends.Midi <- true
	}

	function freeFriend() {
		sayChar()
		//Find who to free based on sprite
		if(sprite = sprXue) if(!game.friends.rawin("Xue")) game.friends.Xue <- true
	}

	function _typeof() { return "NPC" }
}