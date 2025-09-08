//////////////////
// MISC OBJECTS //
//////////////////

GrabbableObject <- class extends PhysAct {
	weight = 1.0;
	wasInWater = false;
	nowInWater = false;
	held = false;
	flip = 0;
	bouncy = 1.0;

	function physics() {
		handleConveyor();

		local freeDown = placeFree(x, y + 1);
		local freeDown2 = placeFree(x, y + 2);
		local freeLeft = placeFree(x - 1, y);
		local freeRight = placeFree(x + 1, y);
		local freeUp = placeFree(x, y - 1);
		wasInWater = nowInWater;
		nowInWater = inWater(x, y);

		if (fabs(hspeed) < friction) hspeed = 0.0;
		if (
			(placeFree(x, y + 2) || vspeed < 0) &&
			(vspeed < 2 || (vspeed < 16 && !nowInWater))
		)
			vspeed += (vspeed > 5 ? gravity / vspeed : gravity) * weight;
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
		else {
			vspeed /= -1.5;
			vspeed *= bouncy;
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
			if (hspeed > 0) hspeed -= friction * (onIce() ? 0.5 : 1.0);
			if (hspeed < 0) hspeed += friction * (onIce() ? 0.5 : 1.0);
		}

		if (fabs(vspeed) < 0.1) vspeed = 0;
		if (fabs(hspeed) < 0.1) hspeed = 0;
	}

	function holdMe(throwF = 2.0) {
		local target = findPlayer();
		if (target == null) {
			held = false;
			return;
		}

		if (target.anim == "slide" || target.anim == "ball" || target.inMelee) {
			target.holding = 0;
			held = false;
			return;
		}

		if (target != null) {
			if (target.inMelee) held = false;
			else if (
				hitTest(shape, target.shape) &&
				(getcon("shoot", "hold", false, target.playerNum) ||
					getcon("spec1", "hold", false, target.playerNum)) &&
				(target.holding == 0 || target.holding == id)
			) {
				y = target.y;
				flip = target.flip;
				if (flip == 0) x = target.x + 10;
				else x = target.x - 10;
				x += target.hspeed + target.ehspeed;
				y += target.vspeed + target.evspeed;
				held = true;
				target.holding = id;
			}

			if (
				target.rawin("anClimb") &&
				target.anim == target.anClimb &&
				held
			) {
				target.holding = 0;

				// escape from solid
				local escapedir = x <=> target.x;
				y = target.y;
				x = target.x;
				for (local i = 0; i < shape.w; i++) {
					if (placeFree(x + i * escapedir, y)) x += escapedir;
				}
				shape.setPos(x, y);
				held = false;
			}

			// escape from solid
			if (!placeFree(x, y) && held) {
				local escapedir = x <=> target.x;
				y = target.y;
				x = target.x;
				for (local i = 0; i < shape.w; i++) {
					if (placeFree(x + i * escapedir, y)) x += escapedir;
				}
			}
		}

		if (
			"playerNum" in target &&
			!getcon("shoot", "hold", false, target.playerNum) &&
			!getcon("spec1", "hold", false, target.playerNum)
		) {
			if (held && target) {
				target.holding = 0;
				x += target.hspeed * 2;

				// escape from solid
				if (!placeFree(x, y)) {
					local escapedir = x <=> target.x;
					y = target.y;
					x = target.x;
					for (local i = 0; i < shape.w; i++) {
						if (placeFree(x + i * escapedir, y)) x += escapedir;
					}
				}

				local throwH = x <=> target.x;
				local throwV = 0;
				if (getcon("up", "hold", false, target.playerNum) && held) {
					throwV = -1;
					if (
						!getcon("left", "hold", false, target.playerNum) &&
						!getcon("right", "hold", true, target.playerNum)
					)
						throwH = 0;
				}
				if (getcon("down", "hold", false, target.playerNum) && held) {
					throwV = 1;
					if (
						!getcon("left", "hold", false, target.playerNum) &&
						!getcon("right", "hold", true, target.playerNum)
					)
						throwH = 0;
				}
				if (getcon("left", "hold", false, target.playerNum) && held)
					throwH = -1;
				if (getcon("right", "hold", false, target.playerNum) && held)
					throwH = 1;

				local throwD = pointAngle(0, 0, throwH, throwV);

				hspeed = lendirX(throwF, throwD) + target.hspeed / 2.0;
				vspeed = lendirY(throwF, throwD) + target.vspeed / 4.0;
			}
			held = false;
		}
	}

	function run() {
		base.run();
		holdMe();
		if (held) {
			hspeed = 0;
			vspeed = 0;
		}
	}
};

NectarBottle <- class extends GrabbableObject {
	friction = 0.2;
	bouncy = 0.2;
	weight = 0.5;

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr);
		shape = Rec(x, y, 7, 7, 0);
	}

	function run() {
		base.run();

		local liquid = inWater(x, y);
		if (liquid && liquid.substance == "acid") {
			actor[liquid.id].substance = "honey";
			deleteActor(id);
			newActor(Poof, x, y);
			popSound(sndIceBreak);
		}
	}

	function draw() {
		drawSprite(sprNectarBottle, 0, x - camx, y - camy);
		if (debug) {
			drawText(font, x - camx, y - camy, jsonWrite(inWater()));
		}
	}
};
