///////////
// MENUS //
///////////

::menu <- [];
::cursor <- 0;
::textMenu <- function(){
	//If no menu is loaded
	if(menu == []) return;

	//Draw options
	for(local i = 0; i < menu.len(); i++){
		if(cursor == i) drawText(font2, 200 -(menu[i].name().len() * 4), 238 - (menu.len() * 14) + (i * 14), menu[i].name());
		else drawText(font, 200 -(menu[i].name().len() * 4), 238 - (menu.len() * 14) + (i * 14), menu[i].name());
	};

	//Keyboard input
	if(keyPress(k_down)){
		cursor++;
		if(cursor >= menu.len()) cursor = 0;
	};

	if(keyPress(k_up)){
		cursor--;
		if(cursor < 0) cursor = menu.len() - 1;
	};

	if(keyPress(k_space) || keyPress(k_return)){
		menu[cursor].func();
	};
};

//Names are stored as functions because some need to change each time
//they're brought up again.
::meMain <- [
	{
		name = function(){ return "Singleplayer"; },
		func = function(){ gvPlayers = 1; gvDual = 0; startPlay(0); }
	},
	{
		name = function(){ return "Multiplayer"; },
		func = function(){ gvPlayers = 2; gvDual = 0; startPlay(1); }
	},
	{
		name = function(){ return "Options"; },
		func = function(){ cursor = 0; menu = meOptions; }
	},
	{
		name = function(){ return "Quit"; },
		func = function(){ gvQuit = 1; }
	}
];

::meOptions <- [
	{
		name = function(){ return "Difficulty: " + strDifficulty[config.difficulty]; },
		func = function(){ cursor = 0; menu = meDifficulty; }
	},
	{
		name = function(){ return "Prey 1: " + config.prey0; },
		func = function(){}
	},
	{
		name = function(){ return "Prey 2: " + config.prey1; },
		func = function(){}
	},
	{
		name = function(){ return "Predator: " + config.pred; },
		func = function(){}
	},
	{
		name = function(){ return "Back"; },
		func = function(){ cursor = 0; menu = meMain; }
	}
];

::meDifficulty <- [
	{
		name = function(){ return "Easy"; },
		func = function(){ config.difficulty = 0; cursor = 0; menu = meOptions; }
	},
	{
		name = function(){ return "Normal"; },
		func = function(){ config.difficulty = 1; cursor = 0; menu = meOptions; }
	},
	{
		name = function(){ return "Hard"; },
		func = function(){ config.difficulty = 2; cursor = 0; menu = meOptions; }
	}
];
