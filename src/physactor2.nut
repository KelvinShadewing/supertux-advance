PhysAct <- class extends Actor{
	hspeed = 0.0
	vspeed = 0.0
	box = [0, 0, 0, 0]
	xstart = 0.0
	ystart = 0.0
	xprev = 0.0
	yprev = 0.0
	shape = Rec(0, 0, 0, 0, 0)
	anim = null
	frame = 0.0
	sprite = 0
	z = 0
	phantom = false
	routine = null
	gravity = 0.0
	friction = 0.1
	anim = [0]

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		xstart = _x
		ystart = _y
	}

	function run() {
		physics()
		animation()
		if(routine != null) routine()
	}

	function setAnim(_anim) {
		anim = _anim
		frame = 0.0
	}

	function animation() {}

	function routine() {}

	function draw() {
		// drawSpriteZ(z, sprite, anim[frame % anim.len()], x - camx, y - camy, 0, flip, 1, 1, 1)
	}

	function isOnScreen() {
		local ns = null
		local ns2 = null

		if(gvNetPlay) {
			ns = Rec(camx1 + gvScreenW / 2, camy1 + gvScreenH / 2, gvScreenW / 2, gvScreenH / 2, 0)
			ns2 = Rec(camx2 + net.scw / 2, camy2 + net.sch / 2, net.scw / 2, net.sch / 2, 0)
			return hitTest(shape, ns) || hitTest(shape, ns2)
		}

		if(gvSplitScreen) {
			ns = Rec(camx1 + gvScreenW / 4, camy1 + gvScreenH / 2, gvScreenW / 4, gvScreenH / 2, 0)
			ns2 = Rec(camx2 + gvScreenW / 4, camy2 + gvScreenH / 2, gvScreenW / 4, gvScreenH / 2, 0)
			return hitTest(shape, ns) || hitTest(shape, ns2)
		}

		if(gvGameMode == gmOverworld) ns = Rec(camx + gvScreenW / 2, camy + gvScreenH / 2, gvScreenW / 2, gvScreenH / 2, 0)
		else ns = Rec(camx0 + gvScreenW / 2, camy0 + gvScreenH / 2, gvScreenW / 2, gvScreenH / 2, 0)
		return hitTest(shape, ns)
	}

	function findPlayer() {
		if(gvPlayer && gvPlayer2) {
			if(distance2(x, y, gvPlayer.x, gvPlayer.y) < distance2(x, y, gvPlayer2.x, gvPlayer2.y)) return gvPlayer
			else return gvPlayer2
		}
		else if(gvPlayer) return gvPlayer
		else if(gvPlayer2) return gvPlayer2
	}
}