ghostRecordOld <- null
ghostRecordNew <- null
ghostRecordName <- ""
gvPlayAsBeam <- false

loadGhostFile <- function(filename) {
	if(!fileExists(filename)) return [[0,0]]

	local file = fileRead(filename)
	local output = split(file, "\n")

	if(output.len() == 0) return [[0,0]]
	
	for(local i = 0; i < output.len(); i++) {
		output[i] = split(output[i], ",")
		output[i][0] = output[i][0].tointeger()
		output[i][1] = output[i][1].tointeger()
	}

	return output
}

BeamBug <- class extends Actor {
	step = 0
	xprev = 0
	yprev = 0
	lightTrail = null
	flip = 0
	turn = 0
	xav = 0
	hspeed = 0
	vspeed = 0

	function constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr)
		lightTrail = array(32, clone([_x, _y]))
		xprev = x
		yprev = y
	}

	function run() {
		for(local i = 31; i > 0; i--)
			lightTrail[i] = lightTrail[i - 1]
		lightTrail[0] = [x, y]

		xprev = x
		yprev = y
		x = ghostRecordOld[step][0]
		y = ghostRecordOld[step][1]
		hspeed = x - xprev
		vspeed = y - yprev
		if(step < ghostRecordOld.len() - 1)
			step++

		if(x > xprev)
			flip = 0
		if(x < xprev)
			flip = 1

		//xav reduces stuttering
		xav = wavg(xav, x - xprev, 0.2)
		turn = floor(min(fabs(xav) / 1.5, 3)) * 2

		if(gvNumPlayers == 0)
			gvCamTarget = this
	}

	function draw() {
		if(ghostRecordOld.len() <= 1)
			return

		for(local i = 31; i > 0; i--) {
			//Create color
			local r = 255
			local g = max(0, min(255, 128 + (255 - i * 15)))
			local b = max(0, 255 - i * 15)
			setDrawColor((r << 24) | (g << 16) | (b << 8) | max(0, min(255, 255 + (255 - i * 15))))
			if(inRange(distance2(lightTrail[i][0] - camx, lightTrail[i][1] - camy, lightTrail[i - 1][0] - camx, lightTrail[i - 1][1] - camy), 2, 128)) drawLineWide(lightTrail[i][0] - camx, lightTrail[i][1] - camy, lightTrail[i - 1][0] - camx, lightTrail[i - 1][1] - camy, 4 - (i / 8))
		}

		drawSprite(sprBeam, turn + ((getFrames() / 2) % 2), x - camx, y - camy + ((getFrames() / 4) % 2), 0, flip)
		drawLight(sprLightBasic, 0, x - camx, y - camy)

		if(debug || gvPlayAsBeam) {
			local s = str(hspeed) + "," + str(vspeed)
			drawText(font, x - camx - (s.len() * 3), y - camy - 16, s)
		}
	}

	function _typeof() { return "BeamBug" }
}