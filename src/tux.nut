/*=========*\
| TUX ACTOR |
\*=========*/

::Tux <- class extends PhysAct{
	canJump = 16;
	didJump = false; //Checks if up speed can be slowed by letting go of jump
	friction = 0.2;
	gravuty = 0.25;
	frame = 0.0;
	constructor(_x, _y)
	{
		base.constructor(_x, _y);
	}

	function run()
	{
		//Movement
		if(hspeed > 0) hspeed -= friction;
		if(hspeed < 0) hspeed += friction;

		//Draw
		drawSprite(sprTux, frame, x - camx, y - camy);
	}

	function _typeof(){ return "Tux"; }
}