/*==========*\
| MIDI ACTOR |
\*==========*/

::Surge <- class extends Player {
	canJump = 16
	didJump = false //Checks if up speed can be slowed by letting go of jump
	frame = 0.0
	flip = 0
	canMove = true //If player has control
	mspeed = 8 //Maximum running speed
	climbdir = 1.0
	blinking = 0 //Invincibility frames
	startx = 0.0
	starty = 0.0
	hurt = 0
	swimming = false
	inMelee = false
	canStomp = true //If they can use jumping as an attack
	stompDamage = 1
	invincible = 0
	shapeStand = 0
	shapeSlide = 0
	tftime = -1 //Timer for transformation
	hidden = false
	jumpBuffer = 0
	rspeed = 0.0 //Run animation speed
	slideframe = 0.0 //Because using just frame gets screwy for some reason
	wasInWater = false
	antigrav = 0
	groundx = 0.0 //Remember last coordinates over solid ground
	groundy = 0.0
	slippery = false
	accel = 0.2
	boredom = 0

	an = {
		stand = [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 6, 6, 6, 6, 6, 6, 6, 6, 41, 42, 41, 42, 41, 42, 41, 42, 43, 44, 44, 44, 44, 43, 41]
		skid = [4, 5]
		crouch = [7]
		walk = [8, 9, 10, 11, 12, 13, 14, 15]
		run = [16, 17, 18, 19, 20, 21, 22, 23]
		sprint = [24, 25, 26, 27, 28, 29, 30, 31]
		curl = [32, 33]
		roll = [34, 35, 36, 37]
		hurt = [38, 39]
		climb = [44, 45, 46, 47, 46, 45]
		wall = [48, 49]
		dead = [50, 51]
		charge = [52, 53, 54, 55]
		crawl = [56, 57, 58, 59, 58, 57]
		jump = [60, 61]
		fall = [62, 63]
	}
}