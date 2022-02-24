//asset stuffs
print("Loading Frostlands")

::bgAuroraALT <- newSprite("contrib/frostlands/gfx/aurora-alt.png", 720, 240, 0, 0, 0, 0)
::bgSnowPlainALT <- newSprite("contrib/frostlands/gfx/bgSnowPlain-alt.png", 720, 240, 0, 0, 0, 0)

::sprFireBlock <- newSprite("res/gfx/Fireblock.png", 16, 16, 0, 0, 0, 0)

::sprmark <- newSprite("contrib/frostlands/gfx/mark.png", 67, 48, 0, 0, 32, 47)
::sprmarq <- newSprite("contrib/frostlands/gfx/marqies.png", 34, 40, 0, 0, 32, 40)
//background shiz

::dbgAuroraF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgAuroraALT, 0, ((-camx / 8) % 720) + (i * 720), screenH() - 240)
	}
}

::dbgSnowPlainF <- function() {
	for(local i = 0; i < 2; i++) {
		drawSprite(bgSnowPlainALT, 0, ((-camx / 8) % 720) + (i * 720), (screenH() / 2) - 120)
	}
}

::FireBlock <- class extends Actor {
	shape = 0
	slideshape = 0
	fireshape = 0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y + 2, 8, 8, 0)
		slideshape = Rec(x, y - 1, 12, 8, 0)
		fireshape = Rec(x, y, 16, 16, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {

		if(actor.rawin("Fireball")) foreach(i in actor["Fireball"])  if(hitTest(fireshape, i.shape)) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Poof, x, y)
			playSound(sndFlame, 0)
		}

		if(actor.rawin("ExplodeF")) foreach(i in actor["ExplodeF"])  if(hitTest(fireshape, i.shape)) {
			tileSetSolid(x, y, 0)
			deleteActor(id)
			deleteActor(i.id)
			newActor(Poof, x, y)
			playSound(sndFlame, 0)
		}

		drawSprite(sprFireBlock, 0, x - 8 - camx, y - 8 - camy)
	}
}

::TNTALT <- class extends Actor {
	shape = null
	gothit = false
	hittime = 0.0
	frame = 0.0

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y, 10, 10, 0)
		tileSetSolid(x, y, 1)
	}

	function run() {
		drawSprite(sprC4, frame, x - 8 - camx, y - 8 - camy)
	}

	function _typeof() { return "TNTALT" }
}

print("Loaded Frostlands")