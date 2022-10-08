::newGame <- function(f) {
	local newdif = game.difficulty
	game = createNewGameObject()
	game.file = f
	gvDoIGT = false
	game.difficulty = newdif
	if(game.difficulty > 1) game.maxHealth = (4 - game.difficulty) * 4
	startPlay("res/map/aurora-pennyton.json", true, true)
}

::newTimeAttack <- function() {
	local path = game.path
	local newdif = game.difficulty
	game = createNewGameObject()
	game.file = -1
	gvDoIGT = true
	game.difficulty = newdif
	game.path = path
	if(game.difficulty > 1) game.maxHealth = (4 - game.difficulty) * 4
	startPlay(game.path + gvTAStart + ".json", true, true)
	gvLight = 0xffffffff
	gvLightTarget = 0xffffffff
	drawWeather = 0
}

::saveGame <- function() {
	if(game.file != -1) fileWrite("save/" + game.file.tostring() + ".json", jsonWrite(game))
}

::loadGame <- function(f) {
	if(fileExists("save/" + f.tostring() + ".json")) {
		game = mergeTable(createNewGameObject(), jsonRead(fileRead("save/" + f.tostring() + ".json")))
		startOverworld(game.world)
	}
}

::selectLoadGame <- function() {
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