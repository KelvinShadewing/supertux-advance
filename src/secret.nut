::SecretWall <- class extends Actor {
	found = false
	alpha = 1.0
	dw = 0
	dh = 0
	shape = null
	rehide = false

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr == "1") rehide = true
		if(!rehide) game.maxSecrets++
	}

	function run() {
		if(shape == null && dw != 0 && dh != 0) shape = Rec(x + (dw * 8), y + (dh * 8), -4 + (dw * 8), -4 + (dh * 8), 5)

		if(shape != null && gvPlayer && hitTest(shape, gvPlayer.shape)) {
			if(!found) {
				found = true
				if(!rehide) {
					game.secrets++
					popSound(sndSecret)
				}
			}
		}
		else if(shape != null && gvPlayer2 && hitTest(shape, gvPlayer2.shape)) {
			if(!found) {
				found = true
				if(!rehide) {
					game.secrets++
					popSound(sndSecret)
				}
			}
		}
		else if(rehide) found = false
		if(found && alpha > 0) alpha -= 0.1
		if(!found && alpha < 1) alpha += 0.1
		if(alpha <= 0 && !rehide) deleteActor(id)
	}

	function draw() {
		local light = 0
		if(gvLightScreen == gvLightScreen1) light = gvLight
		if(gvLightScreen == gvLightScreen2) light = gvLight2
		if(config.light) gvMap.drawTilesMod(floor(-camx), floor(-camy), x / 16, y / 16, dw, dh, "secret", alpha, 1, 1, light)
		else gvMap.drawTiles(floor(-camx), floor(-camy), x / 16, y / 16, dw, dh, "secret", alpha)
		if(debug) {
			drawText(font, x + 2 - camx, y + 2 - camy, "X: " + x + "\nY: " + y + "\nW: " + dw + "\nH: " + dh + "\nA: " + alpha)
			setDrawColor(0xffffffff)
			if(shape != null) shape.draw()
		}
	}

	function _typeof() { return "SecretWall" }
}

::SecretJoiner <- class extends Actor {
	found = false
	alpha = 1.0
	dw = null
	dh = null
	dx = null
	dy = null
	shape = null
	rehide = false
	path = false

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y)
		shape = []
		dw = []
		dh = []
		dx = []
		dy = []
		path = _arr

		local idsToDelete = []

		//Iterate through points in polyline
		if("SecretWall" in actor && actor["SecretWall"].len() > 0) for(local i = 0; i < path.len(); i++) {
			foreach(j in actor["SecretWall"]) {
				if(j.shape.pointIn(path[i][0], path[i][1])) {
					//Add the secret wall to the list
					shape.push(j.shape)
					idsToDelete.push(j.id)
					if(j.rehide) rehide = true
					dx.push(j.x)
					dy.push(j.y)
					dw.push(j.dw)
					dh.push(j.dh)
					if(!j.rehide) game.maxSecrets--
				}
			}
		}

		print("Found " + idsToDelete.len() + " secrets to delete")

		//Clean up actors
		if(idsToDelete.len() > 0) {
			for(local i = 0; i < idsToDelete.len(); i++) deleteActor(idsToDelete[i])
			if(!rehide) game.maxSecrets++
		}
	}

	function run() {
		local scanFound = false

		if(gvPlayer) {
			for(local i = 0; i < shape.len(); i++) {
				if(hitTest(shape[i], gvPlayer.shape)) scanFound = true
			}
		}
		if(gvPlayer2) {
			for(local i = 0; i < shape.len(); i++) {
				if(hitTest(shape[i], gvPlayer2.shape)) scanFound = true
			}
		}

		if(scanFound) {
			if(!rehide && !found) {
				game.secrets++
				popSound(sndSecret)
			}
			found = true
		}
		else if(rehide) found = false
		if(found && alpha > 0) alpha -= 0.1
		if(!found && alpha < 1) alpha += 0.1
		if(alpha <= 0 && !rehide) deleteActor(id)
	}

	function draw() {
		//Draw secret tiles
		for(local i = 0; i < shape.len(); i++) {
			if(config.light) gvMap.drawTilesMod(floor(-camx), floor(-camy), dx[i] / 16, dy[i] / 16, dw[i], dh[i], "secret", alpha, 1, 1, gvLight)
			else gvMap.drawTiles(floor(-camx), floor(-camy), dx[i] / 16, dy[i] / 16, dw[i], dh[i], "secret", alpha)
		}

		if(debug) {
			//Draw path
			for(local i = 0; i < path.len() - 1; i++) {
				setDrawColor(0xffffffff)
				drawLine(path[i][0] - camx, path[i][1] - camy, path[i + 1][0] - camx, path[i + 1][1] - camy)
			}

			//Draw rectangles
			for(local i = 0; i < path.len(); i++) {
				drawText(font, dx[i] + 2 - camx, dy[i] + 2 - camy, "X: " + dx[i] + "\nY: " + dy[i] + "\nW: " + dw[i] + "\nH: " + dh[i] + "\nA: " + alpha)
				shape[i].draw()
			}
		}

	}

	function _typeof() { return "SecretJoiner" }
}