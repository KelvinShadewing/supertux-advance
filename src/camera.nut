::camx <- 0
::camy <- 0
::camxprev <- 0
::camyprev <- 0

::camx0 <- 0
::camy0 <- 0
::camxprev0 <- 0
::camyprev0 <- 0

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
::gvSwapScreen <- false

::updateCamera <- function() {
	if(typeof gvMap != "Tilemap")
		return

	//////////////
	// Camera 0 //
	//////////////

	if(gvCamTarget == null && gvPlayer) gvCamTarget = gvPlayer
	else if(gvCamTarget == null && gvPlayer2) gvCamTarget = gvPlayer2
	if(gvCamTarget2 == null && gvPlayer2) gvCamTarget2 = gvPlayer2

	local px = 0
	local py = 0
	local ux = gvMap.w - gvScreenW
	local uy = gvMap.h - gvScreenH

	//Camera peek
	local lx = 0
	local ly = 0

	if(gvPlayer && gvPlayer2 && (!inDistance2(gvPlayer.x, gvPlayer.y, gvPlayer2.x, gvPlayer2.y, 240) || gvCamTarget != gvPlayer && gvCamTarget2 != gvPlayer2 && gvCamTarget != gvCamTarget2)) {
		if(gvSplitScreen == false) {
			if(gvPlayer.x > gvPlayer2.x)
				gvSwapScreen = true
			else
				gvSwapScreen = false
		}
		gvSplitScreen = true
	}
	if(gvPlayer && gvPlayer2 && inDistance2(gvPlayer.x, gvPlayer.y, gvPlayer2.x, gvPlayer2.y, 160) && (gvCamTarget == gvPlayer && gvCamTarget2 == gvPlayer2 || gvCamTarget == gvCamTarget2))
		gvSplitScreen = false
	if(!gvPlayer || !gvPlayer2 || gvNetPlay || gvBoss)
		gvSplitScreen = false

	if(gvPlayer) {
		if(config.stickcam && config.stickactive) {
			lx = ((joyAxis(config.joy.index, config.joy.xPeek) / js_max.tofloat()) * gvScreenW / 2.5)
			ly = ((joyAxis(config.joy.index, config.joy.yPeek) / js_max.tofloat()) * gvScreenH / 2.5)
		}

		if(getcon("leftPeek", "hold", false, 1))
			lx = -(gvScreenW / 2.5)
		if(getcon("rightPeek", "hold", false, 1))
			lx = (gvScreenW / 2.5)
		if(getcon("upPeek", "hold", false, 1))
			ly = -(gvScreenH / 2.5)
		if(getcon("downPeek", "hold", false, 1))
			ly = (gvScreenH / 2.5)
	}

	if(gvCamTarget != null && gvCamTarget != false && (gvPlayer || gvPlayer2)) {
		if(gvPlayer && gvPlayer2 && !gvSplitScreen) {
			if(debug && mouseDown(0)) {
				px = (gvCamTarget.x) - (gvScreenW / 2) + lx
				py = (gvCamTarget.y) - (gvScreenH / 2) + ly
			}
			else {
				if(config.lookAhead)
					px = (((gvPlayer.x + gvPlayer2.x) / 2.0) + (((gvPlayer.x - gvPlayer.xprev) + (gvPlayer2.x - gvPlayer2.xprev)) * 16)) - (gvScreenW / 2) + lx
				else
					px = (((gvPlayer.x + gvPlayer2.x) / 2.0)) - (gvScreenW / 2) + lx
				py = (((gvPlayer.y + gvPlayer2.y) / 2.0)) - (gvScreenH / 2) + ly
			}
		}
		else if(gvPlayer) {
			if(gvCamTarget == gvPlayer) {
				if(debug && mouseDown(0)) {
					px = (gvCamTarget.x) - (gvScreenW / 2) + lx
					py = (gvCamTarget.y) - (gvScreenH / 2) + ly
				}
				else {
					if(config.lookAhead) {
						px = (gvCamTarget.x + (gvPlayer.x - gvPlayer.xprev) * 32) - (gvScreenW / 2) + lx
						py = (gvCamTarget.y + (gvPlayer.y - gvPlayer.yprev) * 8) - (gvScreenH / 2) + ly
					}
					else {
						px = (gvCamTarget.x + (gvPlayer.x - gvPlayer.xprev) * 8) - (gvScreenW / 2) + lx
						py = (gvCamTarget.y + (gvPlayer.y - gvPlayer.yprev) * 8) - (gvScreenH / 2) + ly
					}
				}
			}
			else {
				local pw = max(gvScreenW, 320)
				local ph = max(gvScreenH, 240)
				local ptx = (gvCamTarget.x) - (gvScreenW / 2)
				local pty = (gvCamTarget.y) - (gvScreenH / 2)

				if(gvCamTarget.rawin("w")) if(abs(gvCamTarget.w) > pw / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) ptx = gvPlayer.x - (gvScreenW / 2) + lx
					else ptx = (gvPlayer.x + gvPlayer.hspeed * (config.lookAhead ? 32 : 8)) - (gvScreenW / 2) + lx
				}
				if(gvCamTarget.rawin("h")) if(abs(gvCamTarget.h) > ph / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) pty = gvPlayer.y - (gvScreenH / 2) + ly
					else pty = (gvPlayer.y + gvPlayer.vspeed * 8) - (gvScreenH / 2) + ly
				}

				px = ptx
				py = pty
			}
		}
		else if(gvPlayer2) {
			if(gvCamTarget == gvPlayer2) {
				if(debug && mouseDown(0)) {
					px = (gvCamTarget.x) - (gvScreenW / 2) + lx
					py = (gvCamTarget.y) - (gvScreenH / 2) + ly
				}
				else {
					if(config.lookAhead){
						px = (gvCamTarget.x + (gvPlayer2.x - gvPlayer2.xprev) * 32) - (gvScreenW / 2) + lx
						py = (gvCamTarget.y + (gvPlayer2.y - gvPlayer2.yprev) * 8) - (gvScreenH / 2) + ly
					}
					else {
						px = (gvCamTarget.x + (gvPlayer2.x - gvPlayer2.xprev) * 8) - (gvScreenW / 2) + lx
						py = (gvCamTarget.y + (gvPlayer2.y - gvPlayer2.yprev) * 8) - (gvScreenH / 2) + ly
					}
				}
			}
			else {
				local pw = max(gvScreenW, 320)
				local ph = max(gvScreenH, 240)
				local ptx = (gvCamTarget.x) - (gvScreenW / 2)
				local pty = (gvCamTarget.y) - (gvScreenH / 2)

				if(gvCamTarget.rawin("w")) if(abs(gvCamTarget.w) > pw / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) ptx = gvPlayer2.x - (gvScreenW / 2) + lx
					else ptx = (gvPlayer2.x + gvPlayer2.hspeed * (config.lookAhead ? 32 : 8)) - (gvScreenW / 2) + lx
				}
				if(gvCamTarget.rawin("h")) if(abs(gvCamTarget.h) > ph / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) pty = gvPlayer2.y - (gvScreenH / 2) + ly
					else pty = (gvPlayer2.y + gvPlayer2.vspeed * 8) - (gvScreenH / 2) + ly
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
		px = camx0
		py = camy0
	}

	{
		if(gvPlayer && gvPlayer2)
			camx0 += (px - camx0) / (config.lookAhead ? 16 : 8)
		else
			camx0 += (px - camx0) / (config.lookAhead ? 24 : 8)
		camy0 += (py - camy0) / 8
	}

	if(camx0 > ux) camx0 = ux
	if(camx0 < 0) camx0 = 0
	if(camy0 > uy) camy0 = uy
	if(camy0 < 0) camy0 = 0

	//////////////
	// Camera 1 //
	//////////////

	if(!gvNetPlay) ux = gvMap.w - gvScreenW / 2

	if(gvPlayer) {
		if(config.stickcam && config.stickactive) {
			lx = ((joyAxis(config.joy.index, config.joy.xPeek) / js_max.tofloat()) * gvScreenW / 2.5)
			ly = ((joyAxis(config.joy.index, config.joy.yPeek) / js_max.tofloat()) * gvScreenH / 2.5)
		}

		if(getcon("leftPeek", "hold", false, 1)) lx = -(gvScreenW / 2.5)
		if(getcon("rightPeek", "hold", false, 1)) lx = (gvScreenW / 2.5)
		if(getcon("upPeek", "hold", false, 1)) ly = -(gvScreenH / 2.5)
		if(getcon("downPeek", "hold", false, 1)) ly = (gvScreenH / 2.5)
	}

	if(gvCamTarget != null && gvCamTarget != false) {
		if(gvPlayer) {
			if(gvCamTarget == gvPlayer) {
				if(debug && mouseDown(0)) {
					px = (gvCamTarget.x) - (gvScreenW / 4) + lx
					py = (gvCamTarget.y) - (gvScreenH / 2) + ly
				}
				else {
					if(config.lookAhead){
						px = (gvPlayer.x + (gvPlayer.x - gvPlayer.xprev) * 32) - (gvScreenW / 4) + lx
						py = (gvPlayer.y + (gvPlayer.y - gvPlayer.yprev) * 8) - (gvScreenH / 2) + ly
					}
					else {
						px = (gvPlayer.x + (gvPlayer.x - gvPlayer.xprev) * 8) - (gvScreenW / 4) + lx
						py = (gvCamTarget.y + (gvPlayer.y - gvPlayer.yprev) * 8) - (gvScreenH / 2) + ly
					}
				}
			}
			else {
				local pw = max(gvScreenW, 320)
				local ph = max(gvScreenH, 240)
				local ptx = (gvCamTarget.x) - (gvScreenW / 4)
				local pty = (gvCamTarget.y) - (gvScreenH / 2)

				if(gvCamTarget.rawin("w")) if(abs(gvCamTarget.w) > pw / 4) {
					if(debug && (mouseDown(0) || mouseDown(1))) ptx = gvPlayer.x - (gvScreenW / 4) + lx
					else ptx = (gvPlayer.x + gvPlayer.hspeed * (config.lookAhead ? 32 : 8)) - (gvScreenW / 4) + lx
				}
				if(gvCamTarget.rawin("h")) if(abs(gvCamTarget.h) > ph / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) pty = gvPlayer.y - (gvScreenH / 2) + ly
					else pty = (gvPlayer.y + gvPlayer.vspeed * 8) - (gvScreenH / 2) + ly
				}

				px = ptx
				py = pty
			}
		}
		else {
			px = (gvCamTarget.x) - (gvScreenW / 4)
			py = (gvCamTarget.y) - (gvScreenH / 2)
		}
	} else {
		px = camx1
		py = camy1
	}

	{
		camx1 += (px - camx1) / (config.lookAhead ? 24 : 8)
		camy1 += (py - camy1) / 8
	}

	if(camx1 > ux) camx1 = ux
	if(camx1 < 0) camx1 = 0
	if(camy1 > uy) camy1 = uy
	if(camy1 < 0) camy1 = 0

	//////////////
	// Camera 2 //
	//////////////

	if(gvPlayer2) {
		if(config.stickcam && config.stickactive) {
			lx = ((joyAxis(config.joy2.index, config.joy2.xPeek) / js_max.tofloat()) * gvScreenW / 2.5)
			ly = ((joyAxis(config.joy2.index, config.joy2.yPeek) / js_max.tofloat()) * gvScreenH / 2.5)
		}

		if(getcon("leftPeek", "hold", false, 2)) lx = -(gvScreenW / 2.5)
		if(getcon("rightPeek", "hold", false, 2)) lx = (gvScreenW / 2.5)
		if(getcon("upPeek", "hold", false, 2)) ly = -(gvScreenH / 2.5)
		if(getcon("downPeek", "hold", false, 2)) ly = (gvScreenH / 2.5)
	}

	if(gvCamTarget2 != null && gvCamTarget2 != false) {
		if(gvPlayer2) {
			if(gvCamTarget2 == gvPlayer2) {
				if(debug && mouseDown(0)) {
					px = (gvPlayer2.x) - (gvScreenW / 4) + lx
					py = (gvPlayer2.y) - (gvScreenH / 2) + ly
				}
				else {
					if(config.lookAhead){
						px = (gvPlayer2.x + (gvPlayer2.x - gvPlayer2.xprev) * 32) - (gvScreenW / 4) + lx
						py = (gvPlayer2.y + (gvPlayer2.y - gvPlayer2.yprev) * 8) - (gvScreenH / 2) + ly
					}
					else {
						px = (gvPlayer2.x + (gvPlayer2.x - gvPlayer2.xprev) * 8) - (gvScreenW / 4) + lx
						py = (gvPlayer2.y + (gvPlayer2.y - gvPlayer2.yprev) * 8) - (gvScreenH / 2) + ly
					}
				}
			}
			else {
				local pw = max(gvScreenW, 320)
				local ph = max(gvScreenH, 240)
				local ptx = (gvCamTarget2.x) - (gvScreenW / 4)
				local pty = (gvCamTarget2.y) - (gvScreenH / 2)

				if(gvCamTarget2.rawin("w")) if(abs(gvCamTarget2.w) > pw / 4) {
					if(debug && (mouseDown(0) || mouseDown(1))) ptx = gvPlayer2.x - (gvScreenW / 4) + lx
					else ptx = (gvPlayer2.x + gvPlayer2.hspeed * (config.lookAhead ? 32 : 8)) - (gvScreenW / 4) + lx
				}
				if(gvCamTarget2.rawin("h")) if(abs(gvCamTarget2.h) > ph / 2) {
					if(debug && (mouseDown(0) || mouseDown(1))) pty = gvPlayer2.y - (gvScreenH / 2) + ly
					else pty = (gvPlayer2.y + gvPlayer2.vspeed * 8) - (gvScreenH / 2) + ly
				}

				px = ptx
				py = pty
			}
		}
		else {
			px = (gvCamTarget2.x) - (gvScreenW / 4)
			py = (gvCamTarget2.y) - (gvScreenH / 2)
		}
	} else {
		px = camx2
		py = camy2
	}

	{
		camx2 += (px - camx2) / (config.lookAhead ? 24 : 8)
		camy2 += (py - camy2) / 8
	}

	if(camx2 > ux) camx2 = ux
	if(camx2 < 0) camx2 = 0
	if(camy2 > uy) camy2 = uy
	if(camy2 < 0) camy2 = 0


	//Reset camera target
	if(gvPlayer) gvCamTarget = gvPlayer
	else if(gvPlayer2) gvCamTarget = gvPlayer2
	if(gvPlayer2) gvCamTarget2 = gvPlayer2
}

::CameraGrabber <- class extends Actor {
	w = 0
	h = 0
	lock = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		lock = (_arr != null)
	}

	function run() {
		if(!gvSplitScreen) { //Single player camera
			if((gvPlayer
			&& gvPlayer.x >= x - w
			&& gvPlayer.y >= y - h
			&& gvPlayer.x <= x + w
			&& gvPlayer.y <= y + h)
			||  (gvPlayer2
			&& gvPlayer2.x >= x - w
			&& gvPlayer2.y >= y - h
			&& gvPlayer2.x <= x + w
			&& gvPlayer2.y <= y + h)) {
				gvCamTarget = this
				gvCamTarget2 = this
			}
		}
		else { //Multi player camera
			if(gvPlayer
			&& gvPlayer.x >= x - w
			&& gvPlayer.y >= y - h
			&& gvPlayer.x <= x + w
			&& gvPlayer.y <= y + h) gvCamTarget = this

			if(gvPlayer2
			&& gvPlayer2.x >= x - w
			&& gvPlayer2.y >= y - h
			&& gvPlayer2.x <= x + w
			&& gvPlayer2.y <= y + h) gvCamTarget2 = this
		}

		if(lock) {
			if(gvCamTarget == this) {
				if(!gvSplitScreen) {
					if(w >= gvScreenW / 2) {
						if(camx0 < x - w) camx0 = x - w
						if(camx0 + gvScreenW > x + w ) camx0 = x + w - gvScreenW
						if(camx1 < x - w) camx1 = x - w
						if(camx1 + gvScreenW > x + w ) camx1 = x + w - gvScreenW
					}
					else {
						camx0 = x - gvScreenW / 2
						camx1 = x - gvScreenW / 2
					}

					if(h >= gvScreenH / 2) {
						if(camy0 < y - h) camy0 = y - h
						if(camy0 + gvScreenH > y + h) camy0 = y + h - gvScreenH
						if(camy1 < y - h) camy1 = y - h
						if(camy1 + gvScreenH > y + h) camy1 = y + h - gvScreenH
					}
					else{
						camy0 = y - gvScreenH / 2
						camy1 = y - gvScreenH / 2
					}
				}
				else {
					if(w >= gvScreenW / 4) {
						if(camx1 < x - w) camx1 = x - w
						if(camx1 + gvScreenW / 2 > x + w ) camx1 = x + w - gvScreenW / 2
					}
					else
						camx1 = x - gvScreenW / 4

					if(h >= gvScreenH / 2) {
						if(camy1 < y - h) camy1 = y - h
						if(camy1 + gvScreenH > y + h) camy1 = y + h - gvScreenH
					}
					else
						camy1 = y - gvScreenH / 2
				}
			}

			if(gvCamTarget2 == this && !gvSplitScreen) {
				if(w >= gvScreenW / 4) {
					if(camx2 < x - w) camx2 = x - w
					if(camx2 + gvScreenW / 2 > x + w ) camx2 = x + w - gvScreenW / 2
				}
				else
					camx2 = x - gvScreenW / 4

				if(h >= gvScreenH / 2) {
					if(camy2 < y - h) camy2 = y - h
					if(camy2 + gvScreenH > y + h) camy2 = y + h - gvScreenH
				}
				else
					camy2 = y - gvScreenH / 2
			}
		}
	}

	function _typeof() { return "CameraGrabber" }
}

::CameraBlock <- class extends PhysAct {
	w = 0
	h = 0
	shape = null
}