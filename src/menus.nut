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
		if(cursor == i) drawText(font2, 160 -(menu[i].name().len() * 4), 120 - (menu.len() * 14) + (i * 14), menu[i].name());
		else drawText(font, 160 -(menu[i].name().len() * 4), 120 - (menu.len() * 14) + (i * 14), menu[i].name());
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
		name = function(){ return "New Game"; },
		func = function(){ gvPlayers = 1; gvDual = 0; startPlay(0); },
		desc = function(){ return "Begin new game from the beginning."; }
	},
	{
		name = function(){ return "Load Game"; },
		func = function(){ gvPlayers = 2; gvDual = 0; startPlay(1); },
		desc = function(){ return "Continue a previous save"; }
	},
	{
		name = function(){ return "Options"; },
		func = function(){ cursor = 0; menu = meOptions; },
		desc = function(){ return "Change game settings."; }
	},
	{
		name = function(){ return "Quit"; },
		func = function(){ gvQuit = 1; },
		desc = function(){ return "Don't leave!"; }
	}
];

::meOptions <- [
	{
		name = function(){ return "Difficulty: " + strDifficulty[config.difficulty]; },
		func = function(){ cursor = 0; menu = meDifficulty; },
		desc = function(){ return "Change game difficulty"; }

	},
	{
		name = function(){ return "Controls"; },
		func = function(){},
		desc = function(){ return "Rebind keys."; }
	},
	{
		name = function(){ return "Back"; },
		func = function(){ cursor = 0; menu = meMain; },
		desc = function(){ return "Return to main menu."; }
	}
];

::meDifficulty <- [
	{
		name = function(){ return "Easy"; },
		func = function(){ config.difficulty = 0; cursor = 0; menu = meOptions; },
		desc = function(){ return "No time limit, no death penalty, extra health."; }
	},
	{
		name = function(){ return "Normal"; },
		func = function(){ config.difficulty = 1; cursor = 0; menu = meOptions; },
		desc = function(){ return "Lose coins on death, normal health, no time limit."; }
	},
	{
		name = function(){ return "Hard"; },
		func = function(){ config.difficulty = 2; cursor = 0; menu = meOptions; },
		desc = function(){ return "Low health, lose more coins on death, time limit."; }
	}
];


