SoccerBall <- class extends PhysAct {
	freeDown = false;
	freeDown2 = false;
	freeLeft = false;
	freeRight = false;
	freeUp = false;
	wasInWater = false;
	nowInWater = false;
	rspeed = 0.0;
	frame = 0.0;
	sideRunning = false;
	gravity = 0.1;

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr);
		shape = Rec(x, y, 6, 6, 0);
	}

	function routine() {
		if (!freeDown2) rspeed = hspeed;
		frame += rspeed / 8;

		if (gvPlayer && hitTest(gvPlayer.shape, shape)) {
			local dir = pointAngle(gvPlayer.x, gvPlayer.y, x, y);

			if (distance2(hspeed, vspeed, gvPlayer.hspeed, gvPlayer.vspeed) > 2)
				popSound(sndBlurp);

			if (int(hspeed <=> 0) != int(x <=> gvPlayer.x))
				hspeed = gvPlayer.hspeed;
			hspeed += lendirX(1, dir) + gvPlayer.hspeed / 10.0;
			vspeed += lendirY(1, dir) + gvPlayer.vspeed / 20.0;
			vspeed -= 2.0;
			rspeed = hspeed;

			if (freeUp) y--;
		}

		if (gvPlayer2 && hitTest(gvPlayer2.shape, shape)) {
			local dir = pointAngle(gvPlayer2.x, gvPlayer2.y, x, y);

			if (
				distance2(hspeed, vspeed, gvPlayer2.hspeed, gvPlayer2.vspeed) >
				2
			)
				popSound(sndBlurp);

			if (int(hspeed <=> 0) != int(x <=> gvPlayer2.x))
				hspeed = gvPlayer2.hspeed;
			hspeed += lendirX(1, dir) + gvPlayer2.hspeed / 10.0;
			vspeed += lendirY(1, dir) + gvPlayer2.vspeed / 20.0;
			vspeed -= 2.0;
			rspeed = hspeed;

			if (freeUp) y--;
		}

		if (vspeed < -8) vspeed = -8.0;

		if (x < 0) {
			hspeed = 4.0;
			vspeed = -6.0;
		}

		if (x > gvMap.w) {
			hspeed = -4.0;
			vspeed = -6.0;
		}
	}

	function physics() {
		freeDown = placeFree(x, y + 1);
		freeDown2 = placeFree(x, y + 2);
		freeLeft = placeFree(x - 1, y);
		freeRight = placeFree(x + 1, y);
		freeUp = placeFree(x, y - 1);
		wasInWater = nowInWater;
		nowInWater = inWater(x, y);

		friction = 0.025;
		if (onIce()) friction /= 2.0;
		if (nowInWater) friction != 1.5;

		if (fabs(hspeed) < friction) hspeed = 0.0;
		if (
			(placeFree(x, y + 2) || vspeed < 0) &&
			(vspeed < 2 || (vspeed < 16 && !nowInWater)) &&
			!sideRunning
		)
			vspeed += vspeed > 5 ? gravity / vspeed : gravity;
		if (!placeFree(x, y - 1) && vspeed < 0) vspeed = 0.0;

		// Rolling
		if (
			(!placeFree(x, y + 8) || !placeFree(x - hspeed * 2, y + 8)) &&
			fabs(hspeed) < 16
		) {
			if (placeFree(x + max(4, hspeed), y + 1) && !onPlatform(hspeed)) {
				hspeed += 0.2;
			}
			if (placeFree(x + min(-4, hspeed), y + 1) && !onPlatform(hspeed)) {
				hspeed -= 0.2;
			}
		}

		if (nowInWater) gravity = 0.12;
		else gravity = 0.25;

		// Base movement
		shape.setPos(x, y);
		xprev = x;
		yprev = y;

		if (placeFree(x, y + vspeed)) y += vspeed;
		else if (sideRunning) {
			if (!placeFree(x - 4, y))
				for (local i = 0; i < abs(vspeed); i++) {
					if (placeFree(x + i, y + vspeed)) {
						y += vspeed;
						x += i;
						break;
					}
				}

			if (!placeFree(x + 4, y))
				for (local i = 0; i < abs(vspeed); i++) {
					if (placeFree(x + i, y + vspeed)) {
						y += vspeed;
						x += i;
						break;
					}
				}
		} else {
			if (fabs(vspeed) >= 2) popSound(sndBlurp);
			vspeed /= -1.5;
			if (fabs(vspeed) < 0.01) vspeed = 0;
			// if(fabs(vspeed) > 1) vspeed -= vspeed / fabs(vspeed)
			if (placeFree(x, y + vspeed)) y += vspeed;
		}

		if (hspeed != 0) {
			if (placeFree(x + hspeed, y)) {
				// Try to move straight
				x += hspeed;
			} else {
				local didstep = false;
				for (local i = 1; i <= 4; i++) {
					// Try to move up hill
					if (placeFree(x + hspeed, y - i)) {
						x += hspeed;
						y -= i;
						if (i > 2) {
							if (hspeed > 0) hspeed -= 0.2;
							if (hspeed < 0) hspeed += 0.2;
						}
						didstep = true;
						break;
					}
				}

				if (fabs(hspeed) >= 4 && !placeFree(x + hspeed, y) && y < yprev)
					vspeed -= 1.0;

				// If no step was taken, slow down
				if (didstep == false && fabs(hspeed) >= 1)
					hspeed -= hspeed / fabs(hspeed) / 2.0;
				else if (didstep == false && fabs(hspeed) < 1) hspeed = 0;
			}
		}

		// Escape when stuck
		if (hspeed == 0 && vspeed == 0 && !placeFree(x, y))
			for (local i = -90; i > -450; i--) {
				for (local j = 0; j < 64; j++) {
					if (placeFree(x + lendirX(j, i), y + lendirY(j, i))) {
						x += lendirX(j, i);
						y += lendirY(j, i);
						break;
					}
				}
			}

		shape.setPos(x, y);
		if (y < -100) y = -100.0;

		switch (escapeMoPlat(1, 1)) {
			case 1:
				if (vspeed < 0) vspeed = 0;
				break;
			case 2:
				if (hspeed < 0) hspeed = 0;
				break;
			case -1:
				if (vspeed > 0) vspeed = 0;
				break;
			case -2:
				if (hspeed > 0) hspeed = 0;
				break;
		}

		// Movement
		if (!placeFree(x, y + 2) || onPlatform()) {
			if (hspeed > 0) hspeed -= friction;
			if (hspeed < 0) hspeed += friction;
		}

		if (fabs(vspeed) < 0.1) vspeed = 0;
		if (fabs(hspeed) < 0.1) hspeed = 0;
	}

	function draw() {
		drawSprite(sprSoccerBall, frame, x - camx, y - camy);
	}

	function _typeof() {
		return "SoccerBall";
	}
};
