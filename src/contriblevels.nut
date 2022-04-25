::meContribLevels <- [

]
::lastLevelsCounted <- {"contribFolder":null, "completed":null, "total":null, "percentage":null}

::selectContrib <- function(){
	meContribLevels = []
	if(fileExists("contrib")){
		local contrib = lsdir("contrib")
		foreach(item in contrib){
			if(item != "." && item != ".." && isdir("contrib/"+item) && fileExists("contrib/"+item+"/info.json")){
				local data = jsonRead(fileRead("contrib/"+item+"/info.json"))
				meContribLevels.push(
					{
						contribFolder = item
						contribName = data["name"]
						contribWorldmap = data["worldmap"]
						name = function() { return contribName }
						func = function() {
							lastLevelsCounted = {"contribFolder":null, "completed":null, "total":null, "percentage":null}
							game=createNewGameObject()
							game.file = contribFolder
							game.path = "contrib/" + contribFolder + "/"
							game.world = contribWorldmap
							tileSearchDir.push("contrib/" + contribFolder + "/gfx")
							gvDoIGT = false
							if(fileExists("contrib/" + contribFolder + "/" + config.lang + ".json")) {
								gvLangObj = mergeTable(gvLangObj, jsonRead(fileRead("contrib/" + contribFolder + "/" + config.lang + ".json")))
								print("Found text.json")
							}
							else if(fileExists("contrib/" + contribFolder + "/text.json")) {
								gvLangObj = mergeTable(gvLangObj, jsonRead(fileRead("contrib/" + contribFolder + "/text.json")))
								print("Found text.json")
							}
							if(fileExists("contrib/" + contribFolder + "/script.nut")) if(!contribDidRun.rawin(contribFolder)) {
								donut("contrib/" + contribFolder + "/script.nut")
								contribDidRun[contribFolder] <- true
							}
							if(fileExists("save/" + contribFolder + ".json")) loadGame(contribFolder)
							else startOverworld("contrib/" + contribFolder + "/" + contribWorldmap)
						}
						desc = function() {
							if(lastLevelsCounted["contribFolder"] == contribFolder) {
								//Check if the same world as last frame is selected and if so, return saved data.
								return "Progress: " + lastLevelsCounted["completed"] + "/" + lastLevelsCounted["total"] + " (" + lastLevelsCounted["percentage"] + "%)"
							}

							local levels = []
							local completedLevelsCount = 0

							//Get all levels
							local contribWorldmapData = jsonRead(fileRead("contrib/" + contribFolder + "/" + contribWorldmap))

							//Get tileset for actors
							local acttiles = null
							foreach(tile in contribWorldmapData["tilesets"]) {
								if(tile["name"] == "actor") {
									acttiles = tile["firstgid"]
									break
								}
							}
							if(acttiles == null) {
								print("ERROR: Could not find actor tileset in worldmap!")
								return "ERROR: Could not find actor tileset in worldmap!"
							}

							foreach(layer in contribWorldmapData["layers"]) {
								if(!layer.rawin("objects")) continue
								foreach(obj in layer["objects"]) {
									if(!obj.rawin("gid")) continue
									if(obj["gid"] == acttiles + 1 && obj["visible"]) levels.push(obj["name"])
								}
							}

							//Get completed levels count
							if(fileExists("save/" + contribFolder + ".json")) {
								local contribWorldmapSaveData = jsonRead(fileRead("save/" + contribFolder + ".json"))
								foreach(level, levelCompleted in contribWorldmapSaveData["completed"]) {
									if(levelCompleted && levels.find(level) != null) completedLevelsCount++
								}
							}

							local percentage = completedLevelsCount * 100 / levels.len()

							lastLevelsCounted = {"contribFolder":contribFolder, "completed":completedLevelsCount, "total":levels.len(), "percentage":percentage}
							return "Progress: " + completedLevelsCount + "/" + levels.len() + " (" + percentage + "%)"
						}
					}
				)
			}
		}
	}

	if(meContribLevels.len() == 0){
		meContribLevels.push(
				{
					name = function() { return gvLangObj["contrib-menu"]["empty"] }
					disabled = true
				}
			)
	}
	else //Sort contrib levels
	meContribLevels.sort(function(a, b) {
		if(a.name() > b.name()) return 1
		if(a.name() < b.name()) return -1
		return 0
	})

	meContribLevels.push(
		{
			name = function() { return gvLangObj["menu-commons"]["back"] }
			func = function() { menu = meMain; cursor = 2 }
			back = function() { menu = meMain; cursor = 2 }
		}
	)

	menu = meContribLevels
}
