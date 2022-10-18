::NPC <- class extends Actor {
	shape = 0
	text = ""
	useflip = 0
	flip = 0
	sprite = 0
	arr = null
	talki = 0
	sayfunc = null
	argv = null

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)

		shape = Rec(x, y - 16, 24, 24, 0)
		flip = randInt(2)

		if(_arr != null) {
			argv = split(_arr, ", ")

			if(getroottable().rawin(argv[0])) sprite = getroottable()[argv[0]]
			useflip = argv[1].tofloat()

			sayfunc = argv[2]
			arr = []

			for(local i = 3; i < argv.len(); i++) {
				if(i >= argv.len()) arr.push("")
				else if(canint(argv[i])) arr.push(argv[i].tointeger())
				else if(argv[i] == 0) arr.push("")
				else if(gvLangObj["npc"].rawin(argv[i])) arr.push(textLineLen(gvLangObj["npc"][argv[i]], gvTextW))
				else arr.push("")
			}
		}
	}

	function setDia(_arr = null) {
		if(_arr != null) {
			local oldargv = argv
			argv = split(_arr, ",")
			//
			argv.insert(0, oldargv[0])
			argv.insert(1, oldargv[1])
			argv.insert(2, oldargv[2])
			arr = []

			for(local i = 0; i < argv.len(); i++) {
				if(i >= argv.len()) arr.push("")
				else if(canint(argv[i])) arr.push(argv[i].tointeger())
				else if(argv[i] == 0) arr.push("")
				else if(gvLangObj["npc"].rawin(argv[i])) arr.push(textLineLen(gvLangObj["npc"][argv[i]], gvTextW))
				else arr.push("")
			}
		}
	}

	function run() {
		if(gvPlayer && sayfunc != null) {
			if(hitTest(shape, gvPlayer.shape)) {
				if(getcon("up", "press") && sayfunc != null) this[sayfunc]()
				if(sprite == 0 && sayfunc == "sayChar" && (argv[3] in gvLangObj["npc"] || (argv[3] + typeof gvPlayer) in gvLangObj["npc"] || (argv[3] + "-" + typeof gvPlayer) in gvLangObj["npc"])) drawSprite(sprTalk, 1, gvPlayer.x - camx, gvPlayer.y - camy - 24 + round(sin(getFrames().tofloat() / 5)))
				else if(sayfunc == "say" && talki > 0 || sayfunc == "sayRand") drawSprite(sprTalk, 0, x - camx, y - spriteH(sprite) - camy - 4 + round(sin(getFrames().tofloat() / 5)))
				else if(sprite != 0) drawSprite(sprTalk, 2, x - camx, y - spriteH(sprite) - camy - 4 + round(sin(getFrames().tofloat() / 5)))
			}

			if(gvInfoBox == text) if(!inDistance2(x, y, gvPlayer.x, gvPlayer.y, 32)) gvInfoBox = ""

			if(inDistance2(x, y, gvPlayer.x, gvPlayer.y, 32)) {
				if(x > gvPlayer.x + 2) flip = 1
				if(x < gvPlayer.x - 2) flip = 0
			}
		}

		if(useflip) drawSpriteEx(sprite, getFrames() * useflip, x - camx, y - camy, 0, flip, 1, 1, 1)
		else drawSpriteEx(sprite, flip, x - camx, y - camy, 0, 0, 1, 1, 1)
	}

	function say() {
		if(argv[3] + "-" + talki in gvLangObj["npc"]) text = textLineLen(gvLangObj["npc"][argv[3] + "-" + talki], gvTextW)
		else text = arr[0]
		gvInfoBox = text
		talki++
		if(!(argv[3] + "-" + talki in gvLangObj["npc"])) talki = 0
	}

	function sayRand() {
		if(argv[3] + "-" + talki in gvLangObj["npc"]) text = textLineLen(gvLangObj["npc"][argv[3] + "-" + talki], gvTextW)
		else text = ""
		gvInfoBox = text
		talki = randInt(arr[1])
		if(!(argv[3] + "-" + talki in gvLangObj["npc"])) talki = 0
	}

	function sayChar() {
		text = ""
		if((argv[3] + typeof gvPlayer) in gvLangObj["npc"]) text = textLineLen(gvLangObj["npc"][argv[3] + typeof gvPlayer], gvTextW)
		else if((argv[3] + "-" + typeof gvPlayer) in gvLangObj["npc"]) text = textLineLen(gvLangObj["npc"][argv[3] + "-" + typeof gvPlayer], gvTextW)
		else if((argv[3]) in gvLangObj["npc"]) text = textLineLen(gvLangObj["npc"][argv[3]], gvTextW)
		gvInfoBox = text
	}

	function rescueKonqi() {
		text = textLineLen(gvLangObj["npc"]["konqi-c"], gvTextW)
		gvInfoBox = text
		freeKonqi()
		if(actor.rawin("BossDoor")) foreach(i in actor["BossDoor"]) i.opening = true
	}

	function rescueKatie() {
		text = textLineLen(gvLangObj["npc"]["katie-c"], gvTextW)
		gvInfoBox = text
		freeKonqi()
		if(actor.rawin("BossDoor")) foreach(i in actor["BossDoor"]) i.opening = true
	}

	function rescueMidi() {
		text = textLineLen(gvLangObj["npc"]["midi-c"], gvTextW)
		gvInfoBox = text
		freeMidi()
		if(actor.rawin("BossDoor")) foreach(i in actor["BossDoor"]) i.opening = true
	}

	function rescueFriend() {
		//Find who to free based on sprite
		if(sprite == sprXue) {
			if(!game.friends.rawin("Xue")) game.friends.Xue <- true
			text = textLineLen(gvLangObj["npc"]["xue-c"], gvTextW)
		}
		if(sprite == sprGnu) if(!game.friends.rawin("Gnu")) {
			game.friends.Gnu <- true
			text = textLineLen(gvLangObj["npc"]["gnu-c"], gvTextW)
		}
		if(sprite == sprPlasmaBreeze) if(!game.friends.rawin("PlasmaBreeze")) {
			game.friends.PlasmaBreeze <- true
			text = textLineLen(gvLangObj["npc"]["breeze-c"], gvTextW)
		}
		if(sprite == sprRockyRaccoon) if(!game.friends.rawin("RockyRaccoon")) {
			game.friends.RockyRaccoon <- true
			text = textLineLen(gvLangObj["npc"]["rocky-c"], gvTextW)
		}
		if(sprite == sprPygame) if(!game.friends.rawin("Pygame")) {
			game.friends.Pygame <- true
			text = textLineLen(gvLangObj["npc"]["python-c"], gvTextW)
		}
		if(sprite == sprGaruda) if(!game.friends.rawin("Garuda")) {
			game.friends.Garuda <- true
			text = textLineLen(gvLangObj["npc"]["garuda-c"], gvTextW)
		}

		gvInfoBox = text
		if(actor.rawin("BossDoor")) foreach(i in actor["BossDoor"]) i.opening = true
	}

	function wantFish() {
		if(game.redCoins < game.maxRedCoins) text = arr[0]
		else text = arr[1]
		gvInfoBox = text
	}

	function watchActor() {
		if(checkActor(mapActor[arr[0].tointeger()])) text = arr[1]
		else text = arr[2]
		gvInfoBox = text
	}

	function _typeof() { return "NPC" }
}

::freeKonqi <- function() {
	if(!game.characters.rawin("Konqi")) game.characters["Konqi"] <- {
		over = "sprKonqiOverworld"
		doll =  "sprKonqiDoll"
		normal = "sprKonqi"
		fire = "sprKonqiFire"
		ice = "sprKonqiIce"
		air = "sprKonqiAir"
		earth = "sprKonqiEarth"
		wave = [8, 9]
	}
	if(!game.characters.rawin("Katie")) game.characters["Katie"] <- {
		over = "sprKatieOverworld"
		doll =  "sprKatieDoll"
		normal = "sprKatie"
		fire = "sprKatieFire"
		ice = "sprKatieIce"
		air = "sprKatieAir"
		earth = "sprKatieEarth"
		wave = [8, 9]
	}
	if(!game.friends.rawin("Konqi")) game.friends["Konqi"] <- true
}

::freeMidi <- function() {
	if(!game.characters.rawin("Midi")) game.characters["Midi"] <- {
		over = "sprMidiOverworld"
		doll = "sprMidiDoll"
		normal = "sprMidi"
		fire = "sprMidi"
		ice = "sprMidi"
		air = "sprMidi"
		earth = "sprMidi"
		wave = [177, 236]
	}
	if(!game.friends.rawin("Midi")) game.friends["Midi"] <- true
}