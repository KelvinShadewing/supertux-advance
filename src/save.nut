newGame <- function(f) {
	local newdif = game.difficulty
	game = createNewGameObject()
	game.file = f
	gvDoIGT = false
	game.difficulty = newdif
	game.state = {
		pennyton = 0
		fishmines = 0
	}

	if(typeof f == "integer") {
		game.randPlayer = gvTARandomPlayer
		game.randItem = gvTARandomItem
		game.randLevel = gvTARandomLevel

		//Break RNG
		if(gvTARandomItem || gvTARandomLevel || gvTARandomPlayer)
			randInt(getFrames())

		//Generate random levels list
		local nl = []
		while(nl.len() < gvStoryLevelList.len()) {
			for(local i = 0; i < gvStoryLevelList.len(); i++) {
				if(randInt(10) == 0 && !(nl.find(gvStoryLevelList[i])))
					nl.push(gvStoryLevelList[i])
			}
		}

		//Add list to game file
		for(local i = 0; i < nl.len(); i++) {
			game.ranLevList[gvStoryLevelList[i]] <- nl[i]
		}

		//Set random player characters
		if(gvTARandomPlayer) {
			game.characters.clear()

			for(local i = 0; i < 3; i++) {
				local np = ""
				
				//Pick a new character
				while(np == "") foreach(k, j in gvCharacters) {
					if(randInt(100) == 0 && !(k in game.characters)) {
						np = k
						break
					}
				}

				game.characters[np] <- true
			}
		}
	}

	startPlay("res/map/aurora-pennyton.json", true, true)
}

newTimeAttack <- function() {
	local path = game.path
	local newdif = game.difficulty
	local tempPlayer1 = game.playerChar
	local tempPlayer2 = game.playerChar2
	game = createNewGameObject()
	game.playerChar = tempPlayer1
	game.playerChar2 = tempPlayer2
	game.file = -1
	gvDoIGT = true
	game.difficulty = newdif
	game.path = path
	if(fileExists(path + "/text.json")) {
		gvLangObj = mergeTable(gvLangObj, jsonRead(fileRead(path + "/text.json")))
		print("Found text.json")
	}
	if(gvTARandomLevel) {
		local tempCourse = gvTACourse
		gvTACourse = []
		while(tempCourse.len() > 0) {
			local i = randInt(tempCourse.len())
			gvTACourse.push(tempCourse[i])
			tempCourse.remove(i)
		}
	}
	gvLight = 0xffffffff
	gvLightTarget = 0xffffffff
	drawWeather = 0
	gvIGT = 0
	gvTAStep = 0
	startPlay(game.path + gvTACourse[0] + ".json", true, true)
}

saveGame <- function() {
	if(game.file != -1) fileWrite("save/" + game.file.tostring() + ".json", jsonWrite(game))
}

loadGame <- function(f) {
	if(fileExists("save/" + f.tostring() + ".json")) {
		game = mergeTable(createNewGameObject(), jsonRead(fileRead("save/" + f.tostring() + ".json")))
		//Sanitize removed characters
		local foundMissing = true
		while(foundMissing) {
			foundMissing = false
			foreach(key, i in game.characters) {
				if(!(key in gvCharacters)) {
					delete game.characters[key]
					foundMissing = true
				}
			}
		}
		gvTARandomLevel = game.rawin("randLevel") ? game.randLevel : false
		gvTARandomPlayer = game.rawin("randPlayer") ? game.randPlayer : false
		gvTARandomItem = game.rawin("randItem") ? game.randItem : false
		startOverworld(game.world)
	}
}

selectLoadGame <- function() {
	local hasSaveFiles = false
	meLoadGame = []
	local dir = lsdir("save")
	dir.sort()

	for(local i = 0; i < dir.len(); i++) {
		local f = ""
		if(dir[i] != "." && i != ".." && dir[i] != "delete.me" && dir[i].find(".json") == dir[i].len() - 5 && canint(dir[i])) f = dir[i].slice(0, -5)
		else continue
		hasSaveFiles = true
		local o = {}
		o.name <- function() { return "File " + f }
		o.func <- function() { loadGame(f) }
		meLoadGame.push(o)
	}

	if(!hasSaveFiles) {
		meLoadGame.push(
			{
				name = function() { return gvLangObj["load-game-menu"]["empty"] }
				disabled = true
			}
		)
	}

	meLoadGame.push({
		name = function() { return gvLangObj["menu-commons"]["cancel"] }
		func = function() { cursor = 1; menu = meMain }
		back = function() { cursor = 1; menu = meMain }
	})

	menu = meLoadGame
}