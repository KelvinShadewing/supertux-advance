///////////////////////
// BASE PLAYER CLASS //
///////////////////////

//TODO:
//Base class for all players
//Child classes will use flags to determine what abilities can be used

::Player <- class extends PhysAct {
	//Animations
	anStand = null
	anWalk = null
	anJog = null
	anRun = null
	anJumpU = null
	anJumpT = null
	anFall = null
	anDive = null
	anSlide = null
	anCrawl = null
	anHurt = null

	//Ability flags
	canstomp = true
	canslide = false
	canpound = false
}