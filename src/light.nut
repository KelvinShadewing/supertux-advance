::gvLightScreen <- 0
::gvLight <- 0xffffffff
::gvLightTarget <- 0xffffffff

::drawLight <- function(sprite, frame, x, y) {
	if(!config.light) return
	if(gvLightScreen == 0) return
	if(gvLight == 0xffffffff) return

	setDrawTarget(gvLightScreen)
	drawSprite(sprite, frame, x, y)
	setDrawTarget(gvPlayScreen)
}

::runAmbientLight <- function() {
	if(config.light) {
		if(gvLight != gvLightTarget) {
			local lr = (gvLight >> 24) & 0xFF
			local lg = (gvLight >> 16) & 0xFF
			local lb = (gvLight >> 8) & 0xFF
			local la = gvLight & 0xFF

			local tr = (gvLightTarget >> 24) & 0xFF
			local tg = (gvLightTarget >> 16) & 0xFF
			local tb = (gvLightTarget >> 8) & 0xFF
			local ta = gvLightTarget & 0xFF

			if(lr < tr) lr++
			if(lg < tg) lg++
			if(lb < tb) lb++
			if(la < ta) la++

			if(lr > tr) lr--
			if(lg > tg) lg--
			if(lb > tb) lb--
			if(la > ta) la--

			gvLight = (lr << 24) | (lg << 16) | (lb << 8) | 0xFF
		}

		setDrawTarget(gvLightScreen)
		setDrawColor(gvLight)
		drawRec(0, 0, screenW(), screenH(), true)
	}
	setDrawTarget(gvScreen)
}

::drawAmbientLight <- function() {
	if(config.light) drawImage(gvLightScreen, 0, 0)
}