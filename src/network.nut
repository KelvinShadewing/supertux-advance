//This table contains information the guest sends to the host
::net <- {
	scw = 320
	sch = 240
	nearbars = false
}

//This table contains the list of currently playing sounds
::netSndPlay <- {}

/*
List of IDs for guest's sounds. Since mods can affect the IDs of sounds, the game will ask the guest's game for each sound's ID on their end.
*/
::netSndIDs <- {}