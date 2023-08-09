/*--------------------*\
| MODDED EVENTS SOURCE |
\*--------------------*/

//These tables can have functions added to them that will be iterated through at certain points
//Names can be arbitrary, and would be best made long and distinct

//Example: ebNewGame.modByMe <- function() { stuff }
//The 'eb' prefix stands for "Event Buffer"

::ebNewGame <- {}
::ebOverworldStart <- {}
::ebOverworldRun <- {}
::ebPlayStart <- {}
::ebPlayRun <- {}

::runModEventBuffer <- function(event) {
	if(event.len() == 0)
		return

	foreach(i in event) {
		if(typeof i == "function")
			i()
	}
}