::WoodBlock <- class extends Actor {
	shape = 0
	mapshape = 0

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 3, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y, 8, 8, 0))
	}

	function run() {
		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0){
			gvPlayer.vspeed = 0
			mapDeleteSolid(mapshape)
			deleteActor(id)
		}

		drawSprite(sprWoodBox, 0, x - 8 - camx, y - 8 - camy)
	}
}

::CoinBlock <- class extends Actor {
	shape = 0
	mapshape = 0
	full = true

	constructor(_x, _y) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 3, 8, 8, 0)
		mapshape = mapNewSolid(Rec(x, y, 8, 8, 0))
	}

	function run() {
		if(gvPlayer != 0) if(hitTest(shape, gvPlayer.shape)) if(gvPlayer.vspeed < 0) if(full){
			gvPlayer.vspeed = 0
			full = false
		}

		if(full) drawSprite(sprBoxItem, getFrames() / 16, x - 8 - camx, y - 8 - camy)
		else drawSprite(sprBoxEmpty, 0, x - 8 - camx, y - 8 - camy)
	}
}