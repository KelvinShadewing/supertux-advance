::pickCharSettings <- {}

::pickCharInitialize <- function(playerNum = 1, unlockAll = false) {
	//Make ordered list of characters
	pickCharSettings.charlist <- []
	foreach(key, i in gvCharacters) {
		if(key in game.characters || unlockAll) {
			local newitem = [key, i["normal"], i["pick"], i["doll"], i["name"]]
			if(playerNum == 1 && game.playerChar2 != key
			|| playerNum == 2 && game.playerChar != key) pickCharSettings.charlist.push(newitem)
		}
	}

	if(playerNum == 2) pickCharSettings.charlist.push(["", 0, [0,0], 0])

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
	pickCharSettings.player <- playerNum
	pickCharSettings.mode <- gvGameMode

	//Set cursor to current character
	for(local i = 0; i < pickCharSettings.charlist.len(); i++) {
		if(pickCharSettings.charlist[i][0] == game.playerChar) {
			pickCharSettings.charslot = i
			break
		}
		if(pickCharSettings.charlist[i][0] == game.playerChar2) {
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

	local listx = 0
	if(pickCharSettings.charlist.len() > 16) listx = (gvScreenW / 2) - (8 * 16)
	else listx = (gvScreenW / 2) - (8 * pickCharSettings.charlist.len())
	listx += 4

	if (getcon("pause", "press") || picktimer <= 0) {
		gvGameMode = pickCharSettings.mode
		return
	}

	setDrawTarget(gvScreen)
	drawSprite(bgCharSel, 0, screenW() / 2, 0)

	if(!didpick) {
		//Move selection
		if(getcon("right", "press")) {
			charslot++
			popSound(sndMenuMove, 0)
		}
		if(getcon("left", "press")) {
			charslot--
			popSound(sndMenuMove, 0)
		}
		if(charslot < 0) charslot = charlist.len() - 1
		if(charslot >= charlist.len()) charslot = 0
		if(charslot >= 16 && getcon("up", "press")) {
			charslot -= 16
			popSound(sndMenuMove, 0)
		}
		if(charslot < charlist.len() - 16 && getcon("down", "press")) {
			charslot += 16
			popSound(sndMenuMove, 0)
		}

		if(getcon("accept", "press") || getcon("jump", "press")) {
			if(pickCharSettings.player == 1) game.playerChar = charlist[charslot][0]
			if(pickCharSettings.player == 2) game.playerChar2 = charlist[charslot][0]
			didpick = true
			popSound(sndMenuSelect, 0)
		}
	}
	else {
		picktimer--
	}

	//Draw
	drawText(font2, (screenW() / 2) - (gvLangObj["options-menu"]["charsel"].len() * 4), 16, gvLangObj["options-menu"]["charsel"])
	if(charlist[charslot][0] != "") drawText(font2, (screenW() / 2) - (charlist[charslot][4].len() * 4), 200, charlist[charslot][4])
	else drawText(font2, (screenW() / 2) - (gvLangObj["menu-commons"]["noone"].len() * 4), 200, gvLangObj["menu-commons"]["noone"])
	if(charlist[charslot][0] != "") {
		if(didpick) drawSprite(getroottable()[charlist[charslot][1]], charlist[charslot][2][1], screenW() / 2, screenH() - 64)
		else drawSprite(getroottable()[charlist[charslot][1]], charlist[charslot][2][0], screenW() / 2, screenH() - 64)
	}

	//Show icon list
	for(local i = 0; i < charlist.len(); i++) {
		if(charlist[i][0] != "") drawSprite(getroottable()[charlist[i][3]], 0, listx + wrap(i, 0, 16) * 16, 48 + (floor(i / 16) * 16))
		else drawSprite(sprNoOne, 0, listx + wrap(i, 0, 16) * 16, 48 + (floor(i / 16) * 16))
	}
	drawSprite(sprCharCursor, getFrames() / 16, listx + wrap(charslot, 0, 16) * 16, 48 + (floor(charslot / 16) * 16))

	resetDrawTarget()
	drawImage(gvScreen, 0, 0)

	pickCharSettings.didpick = didpick
	pickCharSettings.charslot = charslot
	pickCharSettings.charlist = charlist
	pickCharSettings.picktimer = picktimer
}