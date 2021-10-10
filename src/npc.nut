::NPC <- class extends Actor {
	shape = 0
	text = ""
	useflip = false
	flip = 0
	args = null
	sprite = 0
	sayfunc = null
	arr = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y - 16, 20, 16, 0)
	}

	function run() {

		if(text == "" && args != null) {
			local argv = split(args, ",")


			if(getroottable().rawin(argv[0])) sprite = getroottable()[argv[0]]
			useflip = argv[1].tointeger()

			sayfunc = argv[2]
			arr = []

			for(local i = 3; i < argv.len(); i++) {
				arr.push(gvLangObj["npc"][argv[i]])
			}
		}

		if(gvPlayer != 0 && sayfunc != null) {
			if(hitTest(shape, gvPlayer.shape) && getcon("up", "press") && this.rawin(sayfunc)) this[sayfunc]()

			if(gvInfoBox == text) if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 32) gvInfoBox = ""

			if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 32) {
				if(x > gvPlayer.x + 4) flip = 0
				if(x < gvPlayer.x - 4) flip = 1
			}
		}

		if(useflip) drawSpriteEx(sprite, 0, x - camx, y - camy, 0, flip, 1, 1, 1)
		else drawSpriteEx(sprite, flip, x - camx, y - camy, 0, 0, 1, 1, 1)
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
}