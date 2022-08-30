::meAchievements <- []

::gvAchievements <- {
	saveKonqi = function() {
		if(game.path != "res/map/") return false
		return game.characters.rawin("Konqi")
	}
	saveMidi = function() {
		if(game.path != "res/map/") return false
		return game.characters.rawin("Midi")
	}
	over9000 = function() {
		if(game.path != "res/map/") return false
		return game.coins > 9000
	}
	coldGreed = function() {
		if(game.path != "res/map/") return false
		return (game.allCoins.rawin("aurora-learn")
		&& game.allCoins.rawin("aurora-crystal")
		&& game.allCoins.rawin("aurora-slip")
		&& game.allCoins.rawin("aurora-subsea")
		&& game.allCoins.rawin("aurora-tnt")
		&& game.allCoins.rawin("aurora-sense")
		&& game.allCoins.rawin("aurora-frozen")
		&& game.allCoins.rawin("aurora-branches")
		&& game.allCoins.rawin("aurora-bridge")
		&& game.allCoins.rawin("aurora-wind")
		&& game.allCoins.rawin("aurora-steps")
		&& game.allCoins.rawin("aurora-fort")
		&& game.allCoins.rawin("aurora-iceguy")
		&& game.allCoins.rawin("aurora-fishy")
		&& game.allCoins.rawin("aurora-forest"))
	}
}

::gvUnlockedAchievements <- {}

::checkAchievements <- function() {
	foreach(key, i in gvAchievements) {
		if(gvUnlockedAchievements.rawin(key)) continue
		if(i()) {
			gvUnlockedAchievements[key] <- true
			newActor(AchiNotice, 16, -16, key)
			popSound(sndAchievement, 0)
			fileWrite("save/_achievements.json", jsonWrite(gvUnlockedAchievements))
		}
	}
}

::selectAchievements <- function() {
	foreach(key, i in gvAchievements) {
	}

	meAchievements.sort(function(a, b) {
		if(a.name() > b.name()) return 1
		if(a.name() < b.name()) return -1
		return 0
	})
}

::AchiNotice <- class extends Actor {
	hspeed = 0.0
	timer = 60
	name = ""

	constructor(_x, _y, _arr = null){
		base.constructor(_x, _y)
		name = _arr
		print("Got achievement: " + gvLangObj["achi-name"][name])
	}

	function run(draw = false) {
		if(draw) {
			local text = gvLangObj["achi-name"][name]
			drawSprite(sprAchiFrame, 0, x - 12, y - 5)
			for(local i = 0; i < text.len(); i++) drawSprite(sprAchiFrame, 1, x + (i * 8), y - 5)
			drawSprite(sprAchiFrame, 2, x + (text.len() * 8), y - 5)
			drawText(font2A, x, y, text)
			if(y < 48) y += (50.0 - y) / 24.0
			else if(timer > 0) timer--

			if(timer == 0) hspeed += 0.1
			x += hspeed
			if(x > screenW()) deleteActor(id)
		}
	}

	function _typeof() { return "AchiNotice" }
}

::drawAchievements <- function() {
	if(actor.rawin("AchiNotice")) foreach(i in actor["AchiNotice"]) i.run(true)
}