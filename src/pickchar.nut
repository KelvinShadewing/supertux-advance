
::pickCharSettings <- {}

::pickCharInitialize <- function() {
	//Make ordered list of characters
	pickCharSettings.charlist <- []
	foreach(key, i in game.characters) {
		local newitem = [key, i[2], i[3]]
		pickCharSettings.charlist.push(newitem)
	}

	//Sort characters
	//Squirrel tables are sorted by hash, so the list will appear
	//randomized if this is not done
	pickCharSettings.charlist.sort(function(a, b) {
		if(a[0] > b[0]) return 1
		if(a[0] < b[0]) return -1
		return 0
	})
	
	pickCharSettings.didpick <- false
	pickCharSettings.picktimer <- 30
	pickCharSettings.charslot <- 0
	
	//Set cursor to current character
	for(local i = 0; i < pickCharSettings.charlist.len(); i++) {
		if(pickCharSettings.charlist[i][0] == game.playerChar) {
			pickCharSettings.charslot = i
			break
		}
	}
}

::pickChar <- function() {

	local didpick = pickCharSettings.didpick
	local charslot = pickCharSettings.charslot
	local charlist = pickCharSettings.charlist
	local picktimer = pickCharSettings.picktimer
	
	if (getcon("pause", "press") || picktimer <= 0) {
		gvGameMode = gmOverworld
		return
	}

	setDrawTarget(gvScreen)
	drawSprite(bgCharSel, 0, screenW() / 2, 0)
	
	if(!didpick) {
		//Move selection
		if(getcon("right", "press")) charslot++
		if(getcon("left", "press")) charslot--
		if(charslot < 0) charslot = charlist.len() - 1
		if(charslot >= charlist.len()) charslot = 0

		if(getcon("accept", "press") || getcon("jump", "press")) {
			game.playerChar = charlist[charslot][0]
			didpick = true
		}
	}
	else {
		picktimer--
	}

	//Draw
	drawText(font2, (screenW() / 2) - (gvLangObj["options-menu"]["charsel"].len() * 4), 64, gvLangObj["options-menu"]["charsel"])
	drawText(font2, (screenW() / 2) - (charlist[charslot][0].len() * 4), 80, charlist[charslot][0])
	if(didpick) drawSprite(getroottable()[charlist[charslot][1]], charlist[charslot][2][1], screenW() / 2, screenH() - 64)
	else drawSprite(getroottable()[charlist[charslot][1]], charlist[charslot][2][0], screenW() / 2, screenH() - 64)

	resetDrawTarget()
	drawImage(gvScreen, 0, 0)
	
	pickCharSettings.didpick = didpick
	pickCharSettings.charslot = charslot
	pickCharSettings.charlist = charlist
	pickCharSettings.picktimer = picktimer
}

::addChar <- function(char, overworld, doll, playable, frames) {
	if(!getroottable().rawin(char)) {
		print("No class for " + char + " has been defined!")
		return
	}

	local newchar = [overworld, doll, playable, frames]
	if(!game.characters.rawin(char)) game.characters[char] <- newchar
}