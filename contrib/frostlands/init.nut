print("Found Frostlands")
addTimeAttackWorld("The Frostlands", "frostlands", "fw-1")

gvAchievements.welcomeFrostlands <- function() {
	return (game.path == "contrib/frostlands/")
}