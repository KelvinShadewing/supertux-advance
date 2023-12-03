::levelEndRunner <- 0 //Stores a reference to the currently-active LevelEnder

::LevelEnder <- class extends Actor {
	timer = 180

	constructor(_x, _y, _arr = null) {
		base.constructor(0, 0)
	}

	function run() {
		if((gvPlayer && gvPlayer.endMode || !gvPlayer)
		&& (gvPlayer2 && gvPlayer2.endMode || !gvPlayer2)) {
			{
				timer--
				if(timer == 0 || getcon("pause", "press")) {
					stopChannel(-1)
					levelEndRunner = 0
					if(gvNextLevel != "" && gvTimeAttack) {
						game.check = false
						if(gvNextLevel == "timeattack-win") startPlay("res/map/" + gvNextLevel + ".json", true, true)
						else startPlay(game.path + gvNextLevel + ".json", true, true)
						if(game.difficulty == 0 || gvTAStep % game.difficulty == 0) {
							game.maxHealth++
							game.ps.health++
							game.ps2.health++
						}

						if(game.energyBonus <= game.staminaBonus)
							game.energyBonus += 1.0 / (game.difficulty + 1)
						else
							game.staminaBonus += 1.0 / (game.difficulty + 1)
						
						gvIGT = 0
					}
					else startOverworld(game.world)
				}
			}
		}
	}

	function _typeof() { return "LevelEnder" }
}

::endGoal <- function(speed = 0, unblock = "") {
	local clearedLevel
	clearedLevel = gvMap.name
	
	if(levelEndRunner == 0){
		if(gvTimeAttack) {
			gvTAStep++
			if(gvTAStep < gvTACourse.len())
				gvNextLevel = gvTACourse[gvTAStep]
			else {
				game.path = "res/map"
				gvNextLevel = "timeattack-win"
			}
		}

		if(gvPlayer) {
			gvPlayer.canMove = false
			gvPlayer.endMode = true
			gvPlayer.invincible = 999
		}

		if(gvPlayer2) {
			gvPlayer2.canMove = false
			gvPlayer2.endMode = true
			gvPlayer2.invincible = 999
		}

		if("endSpeed" in myTarget) myTarget.endSpeed = speed

		if(unblock != "" && !game.unblocked.rawin(unblock)) game.unblocked[unblock] <- true
		if(!game.completed.rawin(clearedLevel)) game.completed[clearedLevel] <- true
		if(game.levelCoins >= game.maxCoins && !game.allCoins.rawin(clearedLevel)) game.allCoins[clearedLevel] <- true
		if(game.secrets >= game.maxSecrets && !game.allSecrets.rawin(clearedLevel)) game.allSecrets[clearedLevel] <- true
		if(game.enemies >= game.maxEnemies && !game.allEnemies.rawin(clearedLevel)) game.allEnemies[clearedLevel] <- true
		if(!game.bestTime.rawin(clearedLevel)) game.bestTime[clearedLevel] <- gvIGT
		else if(game.bestTime[clearedLevel] > gvIGT) game.bestTime[clearedLevel] = gvIGT

		//Best stats
		if(!game.bestTime.rawin(clearedLevel + "-" + game.playerChar))
			game.bestTime[clearedLevel + "-" + game.playerChar] <- gvIGT
		else if(game.bestTime[clearedLevel + "-" + game.playerChar] > gvIGT)
			game.bestTime[clearedLevel + "-" + game.playerChar] <- gvIGT

		if(!game.bestCoins.rawin(clearedLevel))
			game.bestCoins[clearedLevel] <- game.levelCoins
		else if(game.bestCoins[clearedLevel] < game.levelCoins)
			game.bestCoins[clearedLevel] <- game.levelCoins

		if(!game.bestSecrets.rawin(clearedLevel))
			game.bestSecrets[clearedLevel] <- game.secrets
		else if(game.bestSecrets[clearedLevel] < game.secrets)
			game.bestSecrets[clearedLevel] <- game.secrets

		if(!game.bestEnemies.rawin(clearedLevel))
			game.bestEnemies[clearedLevel] <- game.enemies
		else if(game.bestEnemies[clearedLevel] < game.enemies)
			game.bestEnemies[clearedLevel] <- game.enemies

		if(gvNumPlayers == 1 && "strokes" in gvPlayer) {
			if(!game.bestStrokes.rawin(clearedLevel))
				game.bestStrokes[clearedLevel] <- gvPlayer.strokes
			else if(game.bestStrokes[clearedLevel] > gvPlayer.strokes)
				game.bestStrokes[clearedLevel] <- gvPlayer.strokes
		}

		game.coins += game.levelCoins

		playSound(sndWin, 0)
		stopMusic()

		levelEndRunner = newActor(LevelEnder, 0, 0)

		if(ghostRecordNew.len() < ghostRecordOld.len() || ghostRecordOld.len() <= 1) {
			if(gvNumPlayers == 1) { //Second method for storing two-player runs is in the works
				local timeString = ""
				for(local i = 0; i < ghostRecordNew.len(); i++)
					timeString += ghostRecordNew[i][0] + "," + ghostRecordNew[i][1] + "\n"
				
				if(game.path == "res/map/")
					fileWrite("ghosts/" + ghostRecordName, timeString)
				else
					fileWrite("ghosts/" + game.path + ghostRecordName, timeString)
			}
		}

		saveGame()
	}
}