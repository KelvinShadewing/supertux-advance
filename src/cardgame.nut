const card_mode_select = 0;
const card_mode_flip = 1;
const card_mode_check = 2;
const card_mode_undo = 3;

gvCardsTable <- {
	"muffin": [sprMuffin, 0],
	"nut": [sprNutBomb3],
	"fire": [sprFlowerFire, 0],
	"ice": [sprFlowerIce, 0],
	"air": [sprAirFeather, 0],
	"earth": [sprEarthShell, 0],
	"shock": [sprShockBulb, 0],
	"water": [sprWaterLily, 0],
	"light": [sprLightCap, 0],
	"dark": [sprDarkCap, 0],
	"fish": [sprHerring, 0],
	"pumpkin": [sprPumpkin, 0],
	"coffee": [sprCoffee, 0],
	"coin": [sprCoin, 0]
};

newPlayingCardBoard <- function () {
	return clone {
		board = [
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			],
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			],
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			],
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			],
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			],
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			],
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			],
			[
				["", -1],
				["", -1],
				["", -1],
				["", -1]
			]
		],

		cursor = [0, 0],

		pickA = [0, 0],
		pickB = [0, 0],

		mode = card_mode_select
	};
};

gvPlayingCardBoard <- newPlayingCardBoard();

startCardGame <- function () {
	gvGameMode = gmCardGame;
};

gmCardGame <- function () {
	// Cursor control
	if (getcon("left", "press", false, 0)) {
		gvPlayingCardBoard.cursor[0]--;
	}
	if (getcon("right", "press", false, 0)) {
		gvPlayingCardBoard.cursor[0]++;
	}
	if (getcon("up", "press", false, 0)) {
		gvPlayingCardBoard.cursor[1]--;
	}
	if (getcon("down", "press", false, 0)) {
		gvPlayingCardBoard.cursor[1]++;
	}
	gvPlayingCardBoard.cursor[0] %= 8;
	gvPlayingCardBoard.cursor[1] %= 4;
};
