/*=========*\
| TUX ACTOR |
\*=========*/

::Tux <- class extends PhysAct{
	canJump = 16;
	didJump = false; //Checks if up speed can be slowed by letting go of jump
	friction = 0.2;
	gravity = 0.0;
	frame = 0.0;
	flip = 0;
	canMove = true; //If player has control
	mspeed = 4; //Maximum running speed
	climbf = 0;

	//Animations
	anim = []; //Animation frame delimiters: [start, end, speed]
	anStand = [0.0, 0.0];
	anWalk = [8.0, 15.0];
	anRun = [16.0, 23.0];
	anDive = [24.0, 25.0];
	anSlide = [26.0, 29.0];
	anHurt = [30.0, 31.0];
	anJumpU = [32.0, 33.0];
	anJumpT = [34.0, 35.0];
	anFall = [36.0, 37.0];
	anClimb = [44.0, 47.0];
	anWall = [48.0, 49.0];

	constructor(_x, _y)
	{
		base.constructor(_x, _y);
		anim = anStand;
		shape = Polygon(x, y, [[2, 14], [7, 10], [7, -3], [2, -8], [-2, -8], [-7, -3], [-7, 10], [-2, 14]]);
		gvPlayer = this;
	}

	function run()
	{
		//Side checks
		local freeDown = placeFree(x, y + 1);
		local freeLeft = placeFree(x - 1, y);
		local freeRight = placeFree(x + 1, y);
		local freeUp = placeFree(x, y - 1);
		//Checks are done at the beginning and stored here so that they can be
		//quickly reused. Location checks will likely need to be done multiple
		//times per frame.

		//Animation states
		switch(anim)
		{
			case anStand:
				frame = 0.0;
				if(hspeed != 0)
				{
					anim = anWalk;
					frame = anim[0];
				}
				if(placeFree(x, y + 2))
				{
					if(vspeed >= 0) anim = anFall;
					else anim = anJumpU;
					frame = anim[0];
				}
				break;
			case anWalk:
				frame += abs(hspeed) / 8;
				if(hspeed == 0) anim = anStand;
				if(abs(hspeed) > 4) anim = anRun;
				if(placeFree(x, y + 2))
				{
					if(vspeed >= 0) anim = anFall;
					else anim = anJumpU;
					frame = anim[0];
				}
				break;
			case anRun:
				frame += abs(hspeed) / 8;
				if(abs(hspeed) < 3) anim = anWalk;
				if(placeFree(x, y + 2))
				{
					if(vspeed >= 0) anim = anFall;
					else anim = anJumpU;
					frame = anim[0];
				}
				break;
			case anJumpU:
				if(frame < anim[0] + 1) frame += 0.3;
				if(!freeDown)
				{
					anim = anStand;
					frame = 0.0;
				}
				if(vspeed > 0)
				{
					anim = anJumpT;
					frame = anim[0];
				}
				break;
			case anJumpT:
				frame += 0.2;
				if(!freeDown)
				{
					anim = anStand;
					frame = 0.0;
				}
				if(frame > anim[1])
				{
					anim = anFall;
					frame = anim[0];
				}
				break;
			case anFall:
				frame += 0.2;
				if(!freeDown)
				{
					anim = anStand;
					frame = 0.0;
				}
				break;
			case anClimb:
				if(frame < anim[0])
				{
					frame = anim[0];
					climbf = 1;
				}
				if(frame > anim[1])
				{
					frame = anim[1]
					climbf = -1;
				}
				frame += (vspeed / 4) * climbf;
				break;
			case anWall:
				frame += 0.25;
				vspeed = 0;
				if(floor(frame) > anim[1])
				{
					vspeed = -6;
					if(flip == 0) hspeed = 6;
					else hspeed = -6;
					anim = anJumpU;
					frame = anim[0];
				}
		}

		if(anim != anClimb && anim != anWall)
		{
			if(hspeed > 1) flip = 0;
			if(hspeed < -1) flip = 1;
		}

		/*
		if(anim[0] != anim[1])
		{
			if(floor(frame) > anim[1]) frame -= anim[1] - anim[0];
			if(floor(frame) < anim[0]) frame += anim[1] - anim[0];
		}
		*/
		frame = wrap(frame, anim[0], anim[1]);

		//Controls
		if(!placeFree(x, y + 2)) canJump = 4;
		else if(canJump > 0) canJump--;
		if(canMove)
		{
			if(keyDown(config.key.run)) mspeed = 4;
			else mspeed = 2;
			if(keyDown(config.key.right) && hspeed < mspeed) hspeed += 0.4;
			if(keyDown(config.key.left) && hspeed > -mspeed) hspeed -= 0.4;

			if(keyPress(config.key.jump) && canJump > 0)
			{
				vspeed = -7;
				didJump = true;
				canJump = 0;
			}
			if(keyRelease(config.key.jump) && vspeed < 0 && didJump)
			{
				didJump = false;
				vspeed /= 2;
			}

			if(freeDown && keyDown(config.key.jump))
			{
				if(!placeFree(x - 2, y) && keyPress(config.key.right))
				{
					flip = 0;
					anim = anWall;
					frame = anim[0];
				}
				if(!placeFree(x + 2, y) && keyPress(config.key.left))
				{
					flip = 1;
					anim = anWall;
					frame = anim[0];
				}
			}
		}

		//Movement
		if(hspeed > 0) hspeed -= friction;
		if(hspeed < 0) hspeed += friction;
		if(abs(hspeed) < friction) hspeed = 0.0;
		if(freeDown && vspeed < 8) vspeed += gravity;
		if(!freeUp && vspeed < 0) vspeed = 0.0; //If Tux bumped his head
		if(!freeDown && vspeed > 0) vspeed = 0.0;

		//Gravity cases
		gravity = 0.4;
		if(anim == anClimb || anim == anWall) gravity = 0;

		for(local i = 0; i < 4; i++) {
			if(placeFree(x, y + vspeed / 4)) y += vspeed / 4;
			else vspeed -= vspeed / abs(vspeed);
		}

		if(hspeed != 0)
		for(local i = 0; i < 4; i++) {
			if(placeFree(x + hspeed / 4, y))
			{
				for(local i = 0; i < 2; i++) if(!freeDown && placeFree(x + hspeed / 4, y + 0.25))
				{
					y += 0.25;
				}
				x += hspeed / 4;
			}
			else if(placeFree(x + hspeed / 4, y - 0.5))
			{
				x += hspeed / 4;
				y -= 0.5;
			} else hspeed -= (hspeed / abs(hspeed)) / 4;
		}

		shape.setPos(x, y, 0);



		//Draw
		drawSpriteEx(sprTux, floor(frame), floor(x - camx), floor(y - camy), 0, flip, 1, 1, 1);
		//setDrawColor(0xff0000ff);
		//shape.drawPos(-camx, -camy)
	}

	function _typeof(){ return "Tux"; }
}