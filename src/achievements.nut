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

	coldGreed = function() { //Collect every coin in Aurora Isles
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

	arcticExplorer = function() { //Find all secrets in Aurora Isles
		if(game.path != "res/map/") return false
		return (game.allSecrets.rawin("aurora-learn")
		&& game.allSecrets.rawin("aurora-slip")
		&& game.allSecrets.rawin("aurora-crystal")
		&& game.allSecrets.rawin("aurora-subsea")
		&& game.allSecrets.rawin("aurora-tnt")
		&& game.allSecrets.rawin("aurora-sense")
		&& game.allSecrets.rawin("aurora-frozen")
		&& game.allSecrets.rawin("aurora-branches")
		&& game.allSecrets.rawin("aurora-bridge")
		&& game.allSecrets.rawin("aurora-wind")
		&& game.allSecrets.rawin("aurora-steps")
		&& game.allSecrets.rawin("aurora-fort")
		&& game.allSecrets.rawin("aurora-iceguy")
		&& game.allSecrets.rawin("aurora-fishy")
		&& game.allSecrets.rawin("aurora-forest"))
	}

	snowMoreBaddies = function() { //Defeat every enemy in Aurora Isles
		if(game.path != "res/map/") return false
		return (game.allEnemies.rawin("aurora-learn")
		&& game.allEnemies.rawin("aurora-slip")
		&& game.allEnemies.rawin("aurora-crystal")
		&& game.allEnemies.rawin("aurora-subsea")
		&& game.allEnemies.rawin("aurora-tnt")
		&& game.allEnemies.rawin("aurora-sense")
		&& game.allEnemies.rawin("aurora-frozen")
		&& game.allEnemies.rawin("aurora-branches")
		&& game.allEnemies.rawin("aurora-bridge")
		&& game.allEnemies.rawin("aurora-wind")
		&& game.allEnemies.rawin("aurora-steps")
		&& game.allEnemies.rawin("aurora-fort")
		&& game.allEnemies.rawin("aurora-iceguy")
		&& game.allEnemies.rawin("aurora-fishy")
		&& game.allEnemies.rawin("aurora-forest"))
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
	meAchievements = []

	foreach(key, i in gvAchievements) {
		local newKey = key
		meAchievements.push({
			name = function() { return gvLangObj["achi-name"][newKey] }
			func = function() {}
			desc = function() { return gvLangObj["achi-desc"][newKey] }
			disabled = !gvUnlockedAchievements.rawin(newKey)
		})
	}

	meAchievements.sort(function(a, b) {
		if(a.name() > b.name()) return 1
		if(a.name() < b.name()) return -1
		return 0
	})

	meAchievements.push({
			name = function() { return gvLangObj["menu-commons"]["back"] }
			func = function() { menu = meExtras }
			back = function() { menu = meExtras }
		})

	menu = meAchievements
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
			if(y < 64) y += (80.0 - y) / 24.0
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