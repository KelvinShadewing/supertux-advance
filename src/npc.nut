::NPC <- class extends Actor {
	shape = 0
	text = ""
	useflip = false
	flip = 0
	args = null
	sprite = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y - 16, 16, 16, 0)
	}

	function run() {

		if(text == "" && args != null) {
			local argv = split(args, ",")

			text = gvLangObj["npc"][argv[0]]
			if(getroottable().rawin(argv[1])) sprite = getroottable()[argv[1]]
			useflip = argv[2].tointeger()
		}

		if(gvPlayer != 0) {
			if(hitTest(shape, gvPlayer.shape)){
				gvInfoBox = text
			}

			if(gvInfoBox == text) if(distance2(x, y, gvPlayer.x, gvPlayer.y) > 32) gvInfoBox = ""

			if(distance2(x, y, gvPlayer.x, gvPlayer.y) <= 32) {
				if(x > gvPlayer.x + 4) flip = 0
				if(x < gvPlayer.x - 4) flip = 1
			}
		}

		if(useflip) drawSpriteEx(sprite, 0, x - camx, y - camy, 0, flip, 1, 1, 1)
		else drawSpriteEx(sprite, flip, x - camx, y - camy, 0, 0, 1, 1, 1)
	}
}