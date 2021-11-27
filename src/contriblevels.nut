::meContribLevels <- [

]
::selectContrib <- function(){
	meContribLevels = []
	if(fileExists("contrib")){
		local contrib=lsdir("contrib")
		foreach(item in contrib){
			if(item!="." && item!=".." && isdir("contrib/"+item) && fileExists("contrib/"+item+"/info.json")){
				local data=jsonRead(fileRead("contrib/"+item+"/info.json"))
				meContribLevels.push(
					{
						contribFolder=item,
						contribName=data["name"],
						contribWorldmap=data["worldmap"],
						name = function() { return contribName },
						func = function(){
							game=clone(gameDefault)
							game.completed.clear();
							game.allcoins.clear();
							game.allenemies.clear();
							game.allsecrets.clear();
							game.besttime.clear();
							gvDoIGT = false;
							startOverworld("contrib/"+contribFolder+"/"+contribWorldmap)
						}
					}
				)
			}
		}
	}
	if(meContribLevels.len()==0){
		meContribLevels.push(
			{
				name = function() { return gvLangObj["contrib-menu"]["empty"] }
				func = function() { }
			}
	        )
	}
	meContribLevels.push(
		{
			name = function() { return "Back" }
			func = function(){
				menu = meMain
			}
		}
	)
	menu = meContribLevels
}
