/*=========*\
| TUX ACTOR |
\*=========*/

::Tux <- class extends PhysAct{
	canJump = 16;
	didJump = false; //Checks if up speed can be slowed by letting go of jump
	friction = 0.1;
	gravity = 0.1;
	frame = 0.0;
	flip = 0;
	canMove = true; //If player has control
	mspeed = 4; //Maximum running speed

	//Animations
	anim = []; //Animation frame delimiters: [start, end, speed]
	anStand = [0.0, 0.0];
	anWalk = [8.0, 15.5];
	anRun = [16.0, 23.5];
	anDive = [24.0, 25.5];
	anSlide = [26.0, 29.5];
	anHurt = [30.0, 31.5];
	anJumpU = [32.0, 33.5];
	anJumpT = [34.0, 35.5];
	anFall = [36.0, 37.5];

	constructor(_x, _y)
	{
		base.constructor(_x, _y);
		anim = anStand;
		shape = Polygon(x, y, [[2, 14], [7, 10], [7, -3], [2, -8], [-2, -8], [-7, -3], [-7, 10], [-2, 14]]);
		game.player = this;
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
				frame += abs(hspeed) / 12;
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
				frame += abs(hspeed) / 12;
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
		}
		if(hspeed > 1) flip = 0;
		if(hspeed < -1) flip = 1;

		if(anim[0] != anim[1])
		{
			if(floor(frame) > anim[1]) frame -= anim[1] - anim[0];
			if(floor(frame) < anim[0]) frame += anim[1] - anim[0];
		}

		//Controls
		if(!freeDown) canJump = true;
		if(canMove)
		{
			if(keyDown(config.key.run)) mspeed = 4;
			else mspeed = 2;
			if(keyDown(config.key.right) && hspeed < mspeed) hspeed += 0.2;
			if(keyDown(config.key.left) && hspeed > -mspeed) hspeed -= 0.2;
			if(keyPress(config.key.jump) && canJump)
			{
				vspeed = -3.5;
				didJump = true;
				canJump = false;
			}
			if(keyRelease(config.key.jump) && vspeed < 0 && didJump)
			{
				didJump = false;
				vspeed /= 2;
			}
		}

		//Movement
		if(hspeed > 0) hspeed -= friction;
		if(hspeed < 0) hspeed += friction;
		if(abs(hspeed) < friction) hspeed = 0.0;
		if(freeDown && vspeed < 8) vspeed += gravity;
		if(!freeUp && vspeed < 0) vspeed = 0.0; //If Tux bumped his head
		if(!freeDown && vspeed > 0) vspeed = 0.0;

		/*
		if(hspeed != 0) for(local i = 0; i < abs(hspeed); i++)
		{
			if(placeFree(x + (hspeed / abs(hspeed)), y)) x += hspeed / abs(hspeed);
		}
		if(vspeed != 0) for(local i = 0; i < abs(vspeed); i++)
		{
			if(placeFree(x, y + (vspeed / abs(vspeed)))) y += vspeed / abs(vspeed);
		}
		*/

		if(placeFree(x, y + vspeed)) y += vspeed;
		else vspeed -= vspeed / abs(vspeed);

		if(hspeed != 0)
		{
			if(placeFree(x + hspeed, y))
			{
				for(local i = 0; i < 2; i++) if(!freeDown && placeFree(x + hspeed, y + 1))
				{
					y += 1;
				}
				x += hspeed;
			}
			else if(placeFree(x + hspeed, y - 2))
			{
				x += hspeed;
				y -= 2;
			} else hspeed -= hspeed / abs(hspeed);
		}

		shape.setPos(x, y, 0);



		//Draw
		drawSpriteEx(sprTux, floor(frame), round(x) - camx, round(y) - camy, 0, flip, 1, 1, 1);
		//setDrawColor(0xff0000ff);
		//shape.drawPos(-camx, -camy)
	}

	function _typeof(){ return "Tux"; }
}