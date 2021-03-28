/*=========*\
| TUX ACTOR |
\*=========*/

::Tux <- class extends PhysAct{
	canJump = 16;
	friction = 0.2;
	gravuty = 0.25;
	constructor(_x, _y)
	{
		base.constructor(_x, _y);
	}

	function run()
	{
		//Movement
		if(hspeed > 0) hspeed -= friction;
		if(hspeed < 0) hspeed += friction;
	}

	function _typeof(){ return "Tux"; }
}