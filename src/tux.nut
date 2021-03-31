/*=========*\
| TUX ACTOR |
\*=========*/

::Tux <- class extends PhysAct{
	canJump = 16;
	didJump = false; //Checks if up speed can be slowed by letting go of jump
	friction = 0.2;
	gravuty = 0.25;
	frame = 0.0;
	flip = 0;
	canMove = true; //If player has control

	//Animations
	anim = []; //Animation frame delimiters: [start, end, speed]
	anStand = [0, 0, 0];
	anWalk = [8, 15, 0];
	anRun = [16, 23, 0];
	anDive = [24, 25, 0.5];
	anSlide = [26, 29, 0.5];
	anHurt = [30, 31, 0.25];
	anJumpU = [32, 33, 0.5];
	anJumpT = [34, 35, 0.5];
	anFall = [36, 37, 0.5];
	constructor(_x, _y)
	{
		base.constructor(_x, _y);
		anim = anStand;
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

		//Movement
		if(hspeed > 0) hspeed -= friction;
		if(hspeed < 0) hspeed += friction;
		if(abs(hspeed) < friction) hspeed = 0;
		if(freeDown && vspeed < 8) vspeed += gravity;
		if(!freeUp && vspeed < 0) vspeed = 0.0; //If Tux bumped his head
		if(!freeDown && vspeed > 0) vspeed = 0.0;

		//Animation states
		switch(anim)
		{
			case anStand:
				if(hspeed != 0) anim = anWalk;
				frame = 0.0;
				break;
			case anWalk:
				if(hspeed == 0) anim = anStand;
				frame += abs(hspeed / 64);
				break;
			case anRun:
				if(abs(hspeed) < 5) anim = anWalk;
				frame += abs(hspeed / 64);
				break;
		}
		if(hspeed > 0) flip = 0;
		if(hspeed < 0) flip = 1;

		frame = wrap(frame, anim[0], anim[1]);

		//Controls
		if(canMove)
		{
			if(keyDown(config.key.right) && hspeed < 4) hspeed += 0.4;
			if(keyDown(config.key.left) && hspeed > -4) hspeed -= 0.4;
		}
		x += hspeed;

		//Draw
		drawSpriteEx(sprTux, frame, x - camx, y - camy, 0, flip, 1, 1, 1);
	}

	function _typeof(){ return "Tux"; }
}