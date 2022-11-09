
::camx <- 0
::camy <- 0
::camxprev <- 0
::camyprev <- 0

::camx1 <- 0
::camy1 <- 0
::camx1prev <- 0
::camy1prev <- 0

::camx2 <- 0
::camy2 <- 0
::camx2prev <- 0
::camy2prev <- 0


::gvCamTarget <- false
::gvCamTarget2 <- false
::gvSplitScreen <- false

::updateCamera <- function() {
	//////////////
	// Camera 0 //
	//////////////

	if(gvCamTarget == null && gvPlayer) gvCamTarget = gvPlayer
	else if(gvCamTarget == null && gvPlayer2) gvCamTarget = gvPlayer2
	local px = 0
	local py = 0
	local ux = gvMap.w - gvScreenW
	local uy = gvMap.h - gvScreenH

	//Camera peek
	local lx = 0
	local ly = 0
	if(gvPlayer) {
		lx = ((joyAxis(0, config.joy.xPeek) / js_max.tofloat()) * gvScreenW / 2.5)
		ly = ((joyAxis(0, config.joy.yPeek) / js_max.tofloat()) * gvScreenH / 2.5)


		if(getcon("leftPeek", "hold")) lx = -(gvScreenW / 2.5)
		if(getcon("rightPeek", "hold")) lx = (gvScreenW / 2.5)
		if(getcon("upPeek", "hold")) ly = -(gvScreenH / 2.5)
		if(getcon("downPeek", "hold")) ly = (gvScreenH / 2.5)
	}

	if(gvCamTarget != null && gvCamTarget != false && gvPlayer) {
		if(gvPlayer) {
			if(gvCamTarget == gvPlayer) {
				if(debug && mouseDown(0)) {
					px = (gvCamTarget.x) - (gvScreenW / 2) + lx
					py = (gvCamTarget.y) - (gvScreenH / 2) + ly
				}
				else {
					px = (gvCamTarget.x + (gvPlayer.x - gvPlayer.xprev) * 32) - (gvScreenW / 2) + lx
					py = (gvCamTarget.y + (gvPlayer.y - gvPlayer.yprev) * 16) - (gvScreenH / 2) + ly
				}
			}
			else {
				local pw = max(gvScreenW, 320)
				local ph = max(gvScreenH, 240)
				local ptx = (gvCamTarget.x) - (gvScreenW / 2)
				local pty = (gvCamTarget.y) - (gvScreenH / 2)

				if(gvCamTarget.rawin("w")) if(abs(gvCamTarget.w) > pw / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) ptx = gvPlayer.x - (gvScreenW / 2) + lx
					else ptx = (gvPlayer.x + gvPlayer.hspeed * 32) - (gvScreenW / 2) + lx
				}
				if(gvCamTarget.rawin("h")) if(abs(gvCamTarget.h) > ph / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) pty = gvPlayer.y - (gvScreenH / 2) + ly
					else pty = (gvPlayer.y + gvPlayer.vspeed * 16) - (gvScreenH / 2) + ly
				}

				px = ptx
				py = pty
			}
		}
		else {
			px = (gvCamTarget.x) - (gvScreenW / 2)
			py = (gvCamTarget.y) - (gvScreenH / 2)
		}
	} else {
		px = camx
		py = camy
	}

	camx += (px - camx) / 16
	camy += (py - camy) / 16

	if(camx > ux) camx = ux
	if(camx < 0) camx = 0
	if(camy > uy) camy = uy
	if(camy < 0) camy = 0

	if(gvPlayer) gvCamTarget = gvPlayer

	//////////////
	// Camera 1 //
	//////////////
	
}

::grabCamera <- function(target) {
	if(target == gvPlayer && gvPlayer != false) gvCamTarget = this
	if(target == gvPlayer2 && gvPlayer2 != false) gvCamTarget2 = this
}