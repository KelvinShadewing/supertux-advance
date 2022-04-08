::pickChar <- function() {
	update()
	resetDrawTarget()

	//Make ordered list of characters
	local charlist = []
	foreach(key, i in game.characters) {
		local newitem = [key, i[2], i[3]]
		charlist.push(newitem)
	}

	//Sort characters
	//Squirrel tables are sorted by hash, so the list will appear
	//randomized if this is not done
	charlist.sort(function(a, b) {
		if(a[0] > b[0]) return 1
		if(a[0] < b[0]) return -1
		return 0
	})

	local didpick = false
	local picktimer = 30
	local charslot = 0

	//Set cursor to current character
	for(local i = 0; i < charlist.len(); i++) {
		if(charlist[i][0] == game.playerChar) {
			charslot = i
			break
		}
	}

	//Function loop
	while(!getcon("pause", "press") && picktimer > 0) {
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
		update()
	}
}

::addChar <- function(char, overworld, doll, playable, frames) {
	if(!getroottable().rawin(char)) {
		print("No class for " + char + " has been defined!")
		return
	}

	local newchar = [overworld, doll, playable, frames]
	if(!game.characters.rawin(char)) game.characters[char] <- newchar
}