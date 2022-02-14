::creditsData <- null
::creditsOffset <- 0
::creditsTimer <- 0
::creditsLength <- 0
::creditsSprites <- []
::startCredits <- function(){
	if(creditsData==null)
		creditsData = jsonRead(fileRead("res/credits.json"))
	gvGameMode = gmCredits
	creditsOffset = 0
	creditsTimer = 0
	creditsLength = 0
	creditsSprites = []
	for(local i = 0; i < creditsData["credits"].len(); i+=1){
		if(creditsData["credits"][i]["type"]=="image"){
			creditsSprites.push(newSprite(creditsData["credits"][i]["image"],creditsData["credits"][i]["w"],creditsData["credits"][i]["h"],0,0,0,0))
			creditsLength += creditsData["credits"][i]["h"]
		}
		else{
			creditsSprites.push(null)
			if(creditsData["credits"][i]["type"] == "spacing") {
				creditsLength += fontH * creditsData["credits"][i]["height"]
			}
			else {
				creditsLength += fontH
			}
			if(creditsData["credits"][i]["type"]=="header") creditsLength += 4
		}
	}
	creditsLength += 30 //Padding
	update()
}
::gmCredits <- function(){
	local y=0
	for(local i = 0; i<creditsData["credits"].len(); i+=1){
		switch(creditsData["credits"][i]["type"]){
			case "normal":
				drawText(font, (screenW() / 2) - creditsData["credits"][i]["text"].len()*3, y + screenH() - creditsOffset, creditsData["credits"][i]["text"])
				y += fontH
				break
			case "header":
				drawText(font2, (screenW() / 2) - creditsData["credits"][i]["text"].len()*4, y + screenH() - creditsOffset, creditsData["credits"][i]["text"])
				y += fontH + 4
				break
			case "image":
				drawSprite(creditsSprites[i], creditsData["credits"][i]["f"] + ((getFrames() * creditsData["credits"][i]["s"]) % creditsData["credits"][i]["l"]), (screenW() - creditsData["credits"][i]["w"]) / 2, y + screenH() - creditsOffset)
				y += creditsData["credits"][i]["h"] + 5
				break
			case "spacing":
				y += fontH * creditsData["credits"][i]["height"]
				break
		}
	}
	creditsOffset += getcon("jump", "hold") || getcon("down", "hold") || getcon("accept", "hold") ? 2 : 0.5
	creditsOffset -= getcon("up", "hold") && creditsOffset >= -10 ? 2 : 0
	if(creditsOffset>=screenH()+creditsLength+10 || getcon("pause","press")){
		for(local i=0; i<creditsSprites.len(); i+=1){
			if(creditsSprites[i]==null)
				continue
			deleteSprite(creditsSprites[i])
		}
		gvGameMode = gmMain
	}
}
