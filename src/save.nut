::newGame <- function(f) {
	local newdif = game.difficulty
	game = clone(gameDefault)
	game.completed.clear()
	game.allcoins.clear()
	game.allenemies.clear()
	game.allsecrets.clear()
	game.besttime.clear()
	game.file = f
	gvDoIGT = false
	game.difficulty = newdif
	if(game.difficulty > 1) game.maxHealth = 5 - game.difficulty
	startPlay("res/map/0-t0.json")
}

::saveGame <- function() {
	fileWrite("save/" + game.file.tostring() + ".json", jsonWrite(game))
}

::loadGame <- function(f) {
	if(fileExists("save/" + f.tostring() + ".json")) {
		game = jsonRead(fileRead("save/" + f.tostring() + ".json"))
		startOverworld(game.world)
	}
}

::selectLoadGame <- function() {
	meLoadGame = []
	local dir = lsdir("save")
	dir.sort()

	for(local i = 0; i < dir.len(); i++) {
		local f = ""
		if(dir[i] != "." && i != ".." && dir[i] != "delete.me" && dir[i].find(".json") == dir[i].len() - 5) f = dir[i].slice(0, -5)
		else continue
		local o = {}
		o.name <- function() { return "File " + f }
		o.func <- function() { loadGame(f) }
		meLoadGame.push(o)
	}

	meLoadGame.push({
		name = function() { return "Cancel" }
		func = function() { cursor = 0; menu = meMain }
	})

	menu = meLoadGame
}