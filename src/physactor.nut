/*=============*\
| PHYSICS ACTOR |
\*=============*/

::PhysAct <- class extends Actor{
	hspeed = 0.0;
	vspeed = 0.0;
	shape = 0;

	constructor(_x, _y)
	{
		base.constructor(_x, _y);
		
	}
}