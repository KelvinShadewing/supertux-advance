NPC <- class extends Actor {
	shape = 0;
	text = "";
	useflip = 0;
	flip = 0;
	sprite = 0;
	arr = null;
	talki = 0;
	sayfunc = null;
	argv = null;
	target = null;
	nowTalking = false;

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y);

		shape = Rec(x, y - 16, 24, 24, 0);
		flip = randInt(2);

		if (_arr != null) {
			argv = split(_arr, ", ");

			if (getroottable().rawin(argv[0])) sprite = getroottable()[argv[0]];
			useflip = argv[1].tofloat();

			sayfunc = argv[2];
			arr = [];

			for (local i = 3; i < argv.len(); i++) {
				if (i >= argv.len()) arr.push("");
				else if (canint(argv[i])) arr.push(argv[i].tointeger());
				else if (argv[i] == 0) arr.push("");
				else if (gvLangObj["npc"].rawin(argv[i]))
					arr.push(
						textLineLen(
							formatInfo(gvLangObj["npc"][argv[i]]),
							gvTextW
						)
					);
				else arr.push("");
			}
		}
	}

	function setDia(_arr = null) {
		if (_arr != null) {
			local oldargv = argv;
			argv = split(_arr, ",");
			//
			argv.insert(0, oldargv[0]);
			argv.insert(1, oldargv[1]);
			argv.insert(2, oldargv[2]);
			arr = [];

			for (local i = 0; i < argv.len(); i++) {
				if (i >= argv.len()) arr.push("");
				else if (canint(argv[i])) arr.push(argv[i].tointeger());
				else if (argv[i] == 0) arr.push("");
				else if (gvLangObj["npc"].rawin(argv[i]))
					arr.push(
						textLineLen(
							formatInfo(gvLangObj["npc"][argv[i]]),
							gvTextW
						)
					);
				else arr.push("");
			}
		}
	}

	function run() {
		if (target == null || !nowTalking) {
			if (gvPlayer && gvPlayer2) {
				if (
					distance2(x, y, gvPlayer.x, gvPlayer.y) <
					distance2(x, y, gvPlayer2.x, gvPlayer2.y)
				)
					target = gvPlayer;
				else target = gvPlayer2;
			} else if (gvPlayer) target = gvPlayer;
			else if (gvPlayer2) target = gvPlayer2;
		}

		if (target != null && sayfunc != null) {
			if (
				hitTest(shape, target.shape) &&
				(getcon("up", "press", false, target.playerNum) ||
					(getcon("jump", "press", false, target.playerNum) &&
						nowTalking)) &&
				sayfunc != null
			) {
				if (nowTalking) {
					gvInfoBox = "";
					nowTalking = false;
					target.canMove = true;
				} else if (gvInfoBox == "") {
					this[sayfunc]();
					nowTalking = true;
					target.canMove = false;
					target.hspeed = 0;
					if (target.x > x) target.flip = 1;
					if (target.x < x) target.flip = 0;
				}
			}

			if (gvInfoBox == text)
				if (!inDistance2(x, y, target.x, target.y, 32)) {
					gvInfoBox = "";
				}

			if (nowTalking && (gvInfoBox == "" || gvInfoBox != text)) {
				target.canMove = true;
				nowTalking = false;
			}

			if (inDistance2(x, y, target.x, target.y, 32)) {
				if (x > target.x + 2) flip = 1;
				if (x < target.x - 2) flip = 0;
			}
		}
	}

	function draw() {
		if (
			gvPlayer &&
			gvPlayer2 &&
			hitTest(shape, gvPlayer.shape) &&
			hitTest(shape, gvPlayer2.shape)
		) {
			if (
				sprite == 0 &&
				sayfunc == "sayChar" &&
				(argv[3] in gvLangObj["npc"] ||
					argv[3] + typeof gvPlayer in gvLangObj["npc"] ||
					argv[3] + "-" + typeof gvPlayer in gvLangObj["npc"])
			)
				drawSprite(
					sprTalk,
					1,
					gvPlayer.x - camx,
					gvPlayer.y -
						camy -
						24 +
						round(sin(getFrames().tofloat() / 5))
				);
			else if ((sayfunc == "say" && talki > 0) || sayfunc == "sayRand")
				drawSpriteHUD(
					sprTalk,
					0,
					x - camx,
					y -
						spriteH(sprite) -
						camy -
						4 +
						round(sin(getFrames().tofloat() / 5))
				);
			else if (sprite != 0)
				drawSpriteHUD(
					sprTalk,
					2,
					x - camx,
					y -
						spriteH(sprite) -
						camy -
						4 +
						round(sin(getFrames().tofloat() / 5))
				);

			if (
				sprite == 0 &&
				sayfunc == "sayChar" &&
				(argv[3] in gvLangObj["npc"] ||
					argv[3] + typeof gvPlayer2 in gvLangObj["npc"] ||
					argv[3] + "-" + typeof gvPlayer2 in gvLangObj["npc"])
			)
				drawSprite(
					sprTalk,
					1,
					gvPlayer2.x - camx,
					gvPlayer2.y -
						camy -
						24 +
						round(sin(getFrames().tofloat() / 5))
				);
			else if ((sayfunc == "say" && talki > 0) || sayfunc == "sayRand")
				drawSpriteHUD(
					sprTalk,
					0,
					x - camx,
					y -
						spriteH(sprite) -
						camy -
						4 +
						round(sin(getFrames().tofloat() / 5))
				);
			else if (sprite != 0)
				drawSpriteHUD(
					sprTalk,
					2,
					x - camx,
					y -
						spriteH(sprite) -
						camy -
						4 +
						round(sin(getFrames().tofloat() / 5))
				);
		} else if (target != null && hitTest(shape, target.shape)) {
			if (
				sprite == 0 &&
				sayfunc == "sayChar" &&
				(argv[3] in gvLangObj["npc"] ||
					argv[3] + typeof target in gvLangObj["npc"] ||
					argv[3] + "-" + typeof target in gvLangObj["npc"])
			)
				drawSprite(
					sprTalk,
					1,
					target.x - camx,
					target.y - camy - 24 + round(sin(getFrames().tofloat() / 5))
				);
			else if ((sayfunc == "say" && talki > 0) || sayfunc == "sayRand")
				drawSpriteHUD(
					sprTalk,
					0,
					x - camx,
					y -
						spriteH(sprite) -
						camy -
						4 +
						round(sin(getFrames().tofloat() / 5))
				);
			else if (sprite != 0)
				drawSpriteHUD(
					sprTalk,
					2,
					x - camx,
					y -
						spriteH(sprite) -
						camy -
						4 +
						round(sin(getFrames().tofloat() / 5))
				);
		}

		if (useflip)
			drawSprite(
				sprite,
				getFrames() * useflip,
				x - camx,
				y - camy,
				0,
				flip,
				1,
				1,
				1
			);
		else drawSprite(sprite, flip, x - camx, y - camy, 0, 0, 1, 1, 1);
	}

	function say() {
		if (argv[3] + "-" + talki in gvLangObj["npc"])
			text = textLineLen(
				formatInfo(gvLangObj["npc"][argv[3] + "-" + talki]),
				gvTextW
			);
		else text = arr[0];
		gvInfoBox = text;
		talki++;
		if (!(argv[3] + "-" + talki in gvLangObj["npc"])) talki = 0;
	}

	function sayRand() {
		if (argv[3] + "-" + talki in gvLangObj["npc"])
			text = textLineLen(
				formatInfo(gvLangObj["npc"][argv[3] + "-" + talki]),
				gvTextW
			);
		else text = "";
		gvInfoBox = text;
		talki = randInt(arr[1]);
		if (!(argv[3] + "-" + talki in gvLangObj["npc"])) talki = 0;
	}

	function sayChar() {
		text = "";
		if (argv[3] + typeof target in gvLangObj["npc"])
			text = textLineLen(
				formatInfo(gvLangObj["npc"][argv[3] + typeof target]),
				gvTextW
			);
		else if (argv[3] + "-" + typeof target in gvLangObj["npc"])
			text = textLineLen(
				formatInfo(gvLangObj["npc"][argv[3] + "-" + typeof target]),
				gvTextW
			);
		else if (argv[3] in gvLangObj["npc"])
			text = textLineLen(formatInfo(gvLangObj["npc"][argv[3]]), gvTextW);
		gvInfoBox = text;
	}

	function rescueKonqi() {
		text = textLineLen(formatInfo(gvLangObj["npc"]["konqi-c"]), gvTextW);
		gvInfoBox = text;
		freeKonqi();
		if (actor.rawin("BossDoor"))
			foreach (i in actor["BossDoor"]) i.opening = true;
	}

	function rescueKatie() {
		text = textLineLen(formatInfo(gvLangObj["npc"]["katie-c"]), gvTextW);
		gvInfoBox = text;
		freeKonqi();
		if (actor.rawin("BossDoor"))
			foreach (i in actor["BossDoor"]) i.opening = true;
	}

	function rescueMidi() {
		text = textLineLen(formatInfo(gvLangObj["npc"]["midi-c"]), gvTextW);
		gvInfoBox = text;
		freeMidi();
		if (actor.rawin("BossDoor"))
			foreach (i in actor["BossDoor"]) i.opening = true;
	}

	function rescueFriend() {
		// Find who to free based on sprite
		if (sprite == sprXue) {
			if (!game.friends.rawin("Xue")) game.friends.Xue <- true;
			text = textLineLen(formatInfo(gvLangObj["npc"]["xue-c"]), gvTextW);
			newActor(
				AchiNotice,
				16,
				-16,
				format(gvLangObj["info"]["rescued"], "Xue")
			);
		}
		if (sprite == sprGnu)
			if (!game.friends.rawin("Gnu")) {
				game.friends.Gnu <- true;
				text = textLineLen(
					formatInfo(gvLangObj["npc"]["gnu-c"]),
					gvTextW
				);
				newActor(
					AchiNotice,
					16,
					-16,
					format(gvLangObj["info"]["rescued"], "Gnu")
				);
			}
		if (sprite == sprPlasmaBreeze)
			if (!game.friends.rawin("PlasmaBreeze")) {
				game.friends.PlasmaBreeze <- true;
				text = textLineLen(
					formatInfo(gvLangObj["npc"]["breeze-c"]),
					gvTextW
				);
				newActor(
					AchiNotice,
					16,
					-16,
					format(gvLangObj["info"]["rescued"], "Plasma Breeze")
				);
			}
		if (sprite == sprRockyRaccoon)
			if (!game.friends.rawin("RockyRaccoon")) {
				game.friends.RockyRaccoon <- true;
				text = textLineLen(
					formatInfo(gvLangObj["npc"]["rocky-c"]),
					gvTextW
				);
				newActor(
					AchiNotice,
					16,
					-16,
					format(gvLangObj["info"]["rescued"], "Rocky Raccoon")
				);
			}
		if (sprite == sprPygame)
			if (!game.friends.rawin("Pygame")) {
				game.friends.Pygame <- true;
				text = textLineLen(
					formatInfo(gvLangObj["npc"]["python-c"]),
					gvTextW
				);
				newActor(
					AchiNotice,
					16,
					-16,
					format(gvLangObj["info"]["rescued"], "Pygame")
				);
			}
		if (sprite == sprGaruda)
			if (!game.friends.rawin("Garuda")) {
				game.friends.Garuda <- true;
				text = textLineLen(
					formatInfo(gvLangObj["npc"]["garuda-c"]),
					gvTextW
				);
				newActor(
					AchiNotice,
					16,
					-16,
					format(gvLangObj["info"]["rescued"], "Garuda")
				);
			}
		if (sprite == sprTealDeerNPC)
			if (!game.friends.rawin("TealDeer")) {
				game.friends.TealDeer <- true;
				text = textLineLen(
					formatInfo(gvLangObj["npc"]["tealdeer-c"]),
					gvTextW
				);
				newActor(
					AchiNotice,
					16,
					-16,
					format(gvLangObj["info"]["rescued"], "Teal Deer")
				);
			}

		gvInfoBox = text;
	}

	function wantFish() {
		if (game.redCoins < game.maxRedCoins) text = formatInfo(arr[0]);
		else text = formatInfo(arr[1]);
		gvInfoBox = text;
	}

	function watchActor() {
		if (checkActor(mapActor[arr[0].tointeger()])) text = formatInfo(arr[1]);
		else text = formatInfo(arr[2]);
		gvInfoBox = text;
	}

	function _typeof() {
		return "NPC";
	}
};

freeCharacter <- function (name) {
	if (game.characters.len() >= gvCharacters.len() || !(name in gvCharacters))
		return;

	if (!game.rawin("state")) game.state <- {};

	if (!("freed" in game.state)) game.state.freed <- {};

	if (name in game.state.freed) return;
	game.state.freed[name] <- true;

	if (gvTARandomPlayer && name in gvCharacters) {
		local nl = [];
		foreach (k, i in gvCharacters) nl.push(k);

		do {
			name = nl[randInt(nl.len())];
		} while (name in game.characters);
	}

	game.friends[name] <- true;
	if (name in gvCharacters) game.characters[name] <- true;
};

freeKonqi <- function () {
	freeCharacter("Konqi");
	freeCharacter("Katie");
};

freeMidi <- function () {
	freeCharacter("Midi");
	freeCharacter("Kiki");
};

freeSurge <- function () {
	freeCharacter("Surge");
	freeCharacter("Dashie");
};

freeNeverball <- function () {
	freeCharacter("Neverball");
};

////////////
// NPC v2 //
////////////

gvStockRoutines <- {
	wander = function () {
		friction = 0;
		gravity = 0.2;

		if (hspeed != 0) anim = "walk";
		else anim = "stand";

		if (placeFree(x, y + 1) && !onPlatform()) anim = "fall";

		timer--;
		switch (action) {
			case 0:
				if (timer == 0) {
					timer = randInt(900);
					hspeed = choose(1, -1);
					action = 1;
				}
				break;

			case 1:
				if (timer == 0) {
					timer = randInt(900);
					hspeed = 0;
					action = 0;
				}

				if (
					abs(x - xstart) > 256 ||
					(!placeFree(x + hspeed, y) &&
						!placeFree(x + hspeed, y - 2)) ||
					placeFree(x + hspeed, y + 4) || !onPlatform(hspeed)
				)
					hspeed = -hspeed;
		}
	}
};

gvNPCs <- {
	// NPC definitions go here
	Test = {
		name = "Mr. Test",
		an = {
			stand = [0]
		},
		routine = gvStockRoutines.wander,
		shape = Rec(0, 0, 8, 8, 0),
		sprite = 0
	},
	Pygame = {
		name = "Pygame",
		an = {
			stand = [0],
			fall = [1, 2, 3, 4],
			walk = [8, 9, 10, 11, 12, 13, 14, 15]
		},
		routine = gvStockRoutines.wander,
		shape = Rec(0, 0, 16, 16, 0, 0, 4),
		sprite = sprPygameNPC
	}
};

NPC2 <- class extends PhysAct {
	source = null;
	anim = "stand";
	timer = 0;
	action = 0;
	flip = 0;
	sprite = null;
	args = null;

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr);
		if (_arr) args = split(_arr, ",");
		if (args[0] in gvNPCs) source = deepClone(gvNPCs[_arr]);

		if (source) {
			shape = source.shape;
			routine = source.routine;
			sprite = source.sprite;
		}

		xstart = x;
		ystart = y;
	}

	function _typeof() {
		return "NPC2";
	}
};

//////////////////
// SPECIAL NPCS //
//////////////////

RallyPoint <- class extends PhysAct {
	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, (_arr = null));
		shape = Cir(x, y, 8);
		if (canint(_arr)) shape.r = float(_arr);
	}

	function _typeof() {
		return "RallyPoint";
	}
};

BeeHostage <- class extends PathCrawler {
	rx = 0;
	ry = 0;
	freed = false;
	anim = "stand";
	an = {
		stand = [0],
		fly = [1, 2]
	};
	flip = 0;
	shape = null;
	moving = false;

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y, _arr);
		shape = Rec(x, y, 16, 16, 0);
	}

	function run() {
		base.run();
		if (hspeed > 0) flip = 0;
		if (hspeed < 0) flip = 1;

		if (rx == 0 && ry == 0 && checkActor("RallyPoint")) {
			foreach (i in actor["RallyPoint"]) {
				rx = i.x;
				ry = i.y;
				break;
			}
		}

		if (!freed && checkActor("WeaponEffect")) {
			foreach (i in actor["WeaponEffect"]) {
				if (hitTest(shape, i.shape)) {
					freed = true;
					anim = "fly";
					moving = true;
					if (i.piercing == 0) deleteActor(i.id);
					else i.piercing--;
					speed = 2.0;
					break;
				}
			}
		}

		if (freed && !moving) {
			hspeed += lendirX(
				0.1,
				pointAngle(x, y, rx - 32 + randInt(64), ry - 32 + randInt(64))
			);
			vspeed += lendirY(
				0.1,
				pointAngle(x, y, rx - 32 + randInt(64), ry - 32 + randInt(64))
			);
			x += hspeed;
			y += vspeed;
		}
	}

	function pathEnd() {
		moving = false;
		newActor(Herring, x, y);
	}

	function draw() {
		drawSpriteZ(
			4,
			sprBeeHostage,
			an[anim][wrap(getFrames() / 4, 0, an[anim].len() - 1)],
			x - camx,
			y - camy,
			0,
			flip
		);
		if (!freed) drawSpriteZ(4, sprBirdCage, 0, x - camx, y - camy);
	}
};
