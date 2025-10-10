/*======*\
| ASSETS |
\*======*/

// Variables beging with "def" are default backups of sprites so they can be reset

// Main sprites
sprFont <- newSprite("res/gfx/font.png", 6, 8);
font <- newFont(sprFont, 0, 0, true, 0);
sprFont2 <- newSprite("res/gfx/font2.png", 12, 14);
font2 <- newFont(sprFont2, 0, 0, true, -4);
sprFont2A <- newSprite("res/gfx/font-achieve.png", 12, 14);
font2A <- newFont(sprFont2A, 32, 0, true, -4);
sprDebug <- newSprite("res/gfx/debugkeys.png", 8, 8);
sprTitle <- newSprite("res/gfx/title.png", 220, 55, 110, 0);
sprActors <- newSprite("res/gfx/actors.png", 16, 16);
sprTuxTitle <- newSprite("res/gfx/tux-title.png", 155, 213, 155, 213);
sprCRT <- newSprite("res/gfx/crt.png", 240, 240);

sprTux <- newSprite("res/gfx/tux.png", 32, 32, 16, 19);
defTux <- sprTux;
sprTuxFire <- newSprite("res/gfx/tuxfire.png", 32, 32, 16, 19);
defTuxFire <- sprTuxFire;
sprTuxIce <- newSprite("res/gfx/tuxice.png", 32, 32, 16, 19);
defTuxIce <- sprTuxIce;
sprTuxAir <- newSprite("res/gfx/tuxair.png", 32, 32, 16, 19);
defTuxAir <- sprTuxAir;
sprTuxEarth <- newSprite("res/gfx/tuxearth.png", 32, 32, 16, 19);
defTuxEarth <- sprTuxEarth;
sprTuxShock <- newSprite("res/gfx/tuxshock.png", 32, 32, 16, 19);
defTuxShock <- sprTuxShock;
sprTuxWater <- newSprite("res/gfx/tuxwater.png", 32, 32, 16, 19);
defTuxWater <- sprTuxWater;
sprTuxOverworld <- newSprite("res/gfx/tuxO.png", 14, 17, 7, 14);
defTuxOverworld <- sprTuxOverworld;
sprTuxDoll <- newSprite("res/gfx/tuxdoll.png", 16, 16, 8, 8);
defTuxDoll <- sprTuxDoll;
sprTuxNPC <- newSprite("res/gfx/tux-npc.png", 32, 32, 16, 32);
defTuxNPC <- sprTuxNPC;

sprLutris <- newSprite("res/gfx/lutris.png", 32, 32, 16, 19);
defLutris <- sprLutris;
sprLutrisOverworld <- newSprite("res/gfx/lutrisO.png", 14, 17, 7, 14);
defLutrisOverworld <- sprLutrisOverworld;
sprLutrisDoll <- newSprite("res/gfx/lutrisdoll.png", 16, 20, 8, 8);
defLutrisDoll <- sprLutrisDoll;
sprLutrisAura <- newSprite("res/gfx/lutris-aura.png", 32, 32, 16, 19);
defLutrisAura <- sprLutrisAura;

sprPenny <- newSprite("res/gfx/penny.png", 32, 32, 16, 19);
defPenny <- sprPenny;
sprPennyFire <- newSprite("res/gfx/pennyfire.png", 32, 32, 16, 19);
defPennyFire <- sprPennyFire;
sprPennyIce <- newSprite("res/gfx/pennyice.png", 32, 32, 16, 19);
defPennyIce <- sprPennyIce;
sprPennyAir <- newSprite("res/gfx/pennyair.png", 32, 32, 16, 19);
defPennyAir <- sprPennyAir;
sprPennyEarth <- newSprite("res/gfx/pennyearth.png", 32, 32, 16, 19);
defPennyEarth <- sprPennyEarth;
sprPennyOverworld <- newSprite("res/gfx/pennyO.png", 14, 17, 7, 14);
defPennyOverworld <- sprPennyOverworld;
sprPennyDoll <- newSprite("res/gfx/pennydoll.png", 16, 16, 8, 8);
defPennyDoll <- sprPennyDoll;

sprKonqi <- newSprite("res/gfx/konqi.png", 32, 32, 16, 19);
defKonqi <- sprKonqi;
sprKonqiFire <- newSprite("res/gfx/konqifire.png", 32, 32, 16, 19);
defKonqiFire <- sprKonqiFire;
sprKonqiIce <- newSprite("res/gfx/konqiice.png", 32, 32, 16, 19);
defKonqiIce <- sprKonqiIce;
sprKonqiAir <- newSprite("res/gfx/konqiair.png", 32, 32, 16, 19);
defKonqiAir <- sprKonqiAir;
sprKonqiEarth <- newSprite("res/gfx/konqiearth.png", 32, 32, 16, 19);
defKonqiEarth <- sprKonqiEarth;
sprKonqiWater <- newSprite("res/gfx/konqiwater.png", 32, 32, 16, 19);
defKonqiWater <- sprKonqiWater;
sprKonqiOverworld <- newSprite("res/gfx/konqiO.png", 14, 20, 7, 17);
defKonqiOverworld <- sprKonqiOverworld;
sprKonqiDoll <- newSprite("res/gfx/konqidoll.png", 16, 16, 8, 8);
defKonqiDoll <- sprKonqiDoll;
sprKonqiNPC <- newSprite("res/gfx/konqi-npc.png", 32, 32, 16, 32);

sprKatie <- newSprite("res/gfx/katie.png", 32, 32, 16, 19);
defKatie <- sprKatie;
sprKatieFire <- newSprite("res/gfx/katiefire.png", 32, 32, 16, 19);
defKatieFire <- sprKatieFire;
sprKatieIce <- newSprite("res/gfx/katieice.png", 32, 32, 16, 19);
defKatieIce <- sprKatieIce;
sprKatieAir <- newSprite("res/gfx/katieair.png", 32, 32, 16, 19);
defKatieAir <- sprKatieAir;
sprKatieEarth <- newSprite("res/gfx/katieearth.png", 32, 32, 16, 19);
defKatieEarth <- sprKatieEarth;
sprKatieOverworld <- newSprite("res/gfx/katieO.png", 14, 20, 7, 17);
defKatieOverworld <- sprKatieOverworld;
sprKatieDoll <- newSprite("res/gfx/katiedoll.png", 16, 16, 8, 8);
defKatieDoll <- sprKatieDoll;
sprKatieNPC <- newSprite("res/gfx/katie-npc.png", 32, 32, 16, 32);

sprMidi <- newSprite("res/gfx/midi.png", 32, 32, 16, 19);
defMidi <- sprMidi;
sprMidiOverworld <- newSprite("res/gfx/midiO.png", 14, 21, 7, 17);
defMidiOverworld <- sprMidiOverworld;
sprMidiDoll <- newSprite("res/gfx/mididoll.png", 16, 16, 8, 8);
defMidiDoll <- sprMidiDoll;
sprMidiNPC <- newSprite("res/gfx/midi-npc.png", 32, 32, 16, 32);
sprMidiAura <- newSprite("res/gfx/midi-aura.png", 32, 32, 16, 19);
defMidiAura <- sprMidiAura;

sprSurge <- newSprite("res/gfx/surge.png", 32, 32, 16, 19);
defSurge <- sprSurge;
sprSurgeOverworld <- newSprite("res/gfx/surgeO.png", 14, 25, 7, 21);
defSurgeOverworld <- sprSurgeOverworld;
sprSurgeDoll <- newSprite("res/gfx/surge-doll.png", 16, 16, 8, 8);
defSurgeDoll <- sprSurgeDoll;

sprDashie <- newSprite("res/gfx/dashie.png", 32, 32, 16, 19);
defDashie <- sprDashie;
sprDashieOverworld <- newSprite("res/gfx/dashieO.png", 14, 25, 7, 21);
defDashieOverworld <- sprDashieOverworld;
sprDashieDoll <- newSprite("res/gfx/dashie-doll.png", 16, 16, 8, 8);
defDashieDoll <- sprDashieDoll;

sprKiki <- newSprite("res/gfx/kiki.png", 32, 32, 16, 19);
defKiki <- sprKiki;
sprKikiOverworld <- newSprite("res/gfx/kikiO.png", 16, 21, 8, 17);
defKikiOverworld <- sprKikiOverworld;
sprKikiDoll <- newSprite("res/gfx/kiki-doll.png", 16, 16, 8, 8);
defKikiDoll <- sprKikiDoll;
sprKikiNPC <- newSprite("res/gfx/kiki-npc.png", 32, 32, 16, 32);
sprKikiAura <- newSprite("res/gfx/kiki-aura.png", 32, 32, 16, 19);
defKikiAura <- sprKikiAura;

sprNeverball <- newSprite("res/gfx/neverball.png", 16, 16, 8, 8);
defNeverball <- sprNeverball;
sprNeverballArrow <- newSprite("res/gfx/neverball-arrow.png", 12, 9, 0, 5);
defNeverballArrow <- sprNeverballArrow;

sprCyra <- newSprite("res/gfx/cyra_gfx/cyra.png", 100, 54, 32, 33);
defCyra <- sprCyra;
sprCyraFire <- newSprite("res/gfx/cyra_gfx/cyrafire.png", 74, 54, 32, 33);
defCyraFire <- sprCyraFire;
sprCyraIce <- newSprite("res/gfx/cyra_gfx/cyraice.png", 74, 54, 32, 33);
defCyraIce <- sprCyraIce;
sprCyraAir <- newSprite("res/gfx/cyra_gfx/cyraair.png", 74, 54, 32, 33);
defCyraAir <- sprCyraAir;
sprCyraEarth <- newSprite("res/gfx/cyra_gfx/cyraearth.png", 74, 54, 32, 33);
defCyraEarth <- sprCyraEarth;
sprCyraShock <- newSprite("res/gfx/cyra_gfx/cyrashock.png", 74, 54, 32, 33);
defCyraShock <- sprCyraShock;
sprCyraWater <- newSprite("res/gfx/cyra_gfx/cyrawater.png", 74, 54, 32, 33);
defCyraWater <- sprCyraWater;
sprCyraLight <- newSprite("res/gfx/cyra_gfx/cyralight.png", 74, 54, 32, 33);
defCyraLight <- sprCyraLight;
sprCyraDark <- newSprite("res/gfx/cyra_gfx/cyradark.png", 74, 54, 32, 33);
defCyraDark <- sprCyraDark;
sprCyraOverworld <- newSprite("res/gfx/cyra_gfx/cyraO.png", 14, 20, 7, 17);
defCyraOverworld <- sprCyraOverworld;
sprCyraDoll <- newSprite("res/gfx/cyra_gfx/cyradoll.png", 16, 16, 8, 8);
defCyraDoll <- sprCyraDoll;

sprPepper <- newSprite("res/gfx/pepper.png", 100, 54, 32, 33);
defPepper <- sprPepper;
sprPepperOverworld <- newSprite("res/gfx/pepperO.png", 20, 24, 10, 20);
defPepperOverworld <- sprPepperOverworld;
sprPepperDoll <- newSprite("res/gfx/pepperdoll.png", 16, 16, 8, 8);
defPepperDoll <- sprPepperDoll;

// GUI
sprCursor <- newSprite("res/gfx/cursor.png", 10, 13);
sprHealth <- newSprite("res/gfx/health-icon.png", 16, 16);
defHealth <- sprHealth;
sprEnergy <- newSprite("res/gfx/energy-icon.png", 16, 16);
defEnergy <- sprEnergy;
sprStamina <- newSprite("res/gfx/stamina-icon.png", 16, 16);
defStamina <- sprStamina;
sprElement <- newSprite("res/gfx/element-icon.png", 16, 16);
defElement <- sprElement;
sprLevels <- newSprite("res/gfx/levelicons.png", 16, 16, 8, 8);
defLevels <- sprLevels;
sprSubItem <- newSprite("res/gfx/itemcard.png", 20, 20, 10, 10);
defSubItem <- sprSubItem;
sprWarning <- newSprite("res/gfx/warning.png", 280, 72, 140, 36);
defWarning <- sprWarning;
sprTalk <- newSprite("res/gfx/talk.png", 16, 16, 8, 16);
defTalk <- sprTalk;
sprBossHealth <- newSprite("res/gfx/boss-health.png", 10, 8);
defBossHealth <- sprBossHealth;
sprSkull <- newSprite("res/gfx/skull.png", 16, 16);
sprIris <- newSprite("res/gfx/iris.png", 240, 240, 120, 120);
sprAchiFrame <- newSprite("res/gfx/achievement-frame.png", 12, 24);
sprCharCursor <- newSprite("res/gfx/char-cursor.png", 24, 24, 12, 12);
sprNoOne <- newSprite("res/gfx/noone.png", 16, 16, 8, 8);
sprDivBar <- newSprite("res/gfx/divbar.png", 4, 240, 2, 0);
defDivBar <- sprDivBar;
sprExit <- newSprite("res/gfx/exit.png", 16, 16, 8, 8);
defExit <- sprExit;
sprIcoSecret <- newSprite("res/gfx/ico-secret.png", 16, 16, 8, 8);
defIcoSecret <- sprIcoSecret;
sprHerrow <- newSprite("res/gfx/herrow.png", 8, 7, -16, 3);
defHerrow <- sprHerrow;

sprNearRedBack <- newSprite("res/gfx/near-health-back.png", 8, 32);
sprNearGreenBack <- newSprite("res/gfx/near-stamina-back.png", 32, 8);
sprNearBlueBack <- newSprite("res/gfx/near-mana-back.png", 8, 32);

imgNearRedFill <- loadImage("res/gfx/near-health-fill.png");
imgNearGreenFill <- loadImage("res/gfx/near-stamina-fill.png");
imgNearBlueFill <- loadImage("res/gfx/near-mana-fill.png");

sprMeterBack <- newSprite("res/gfx/meter-back.png", 2, 8);

// Blocks
sprVoid <- newSprite("res/gfx/void.png", 16, 32);
defVoid <- sprVoid;
sprBoxIce <- newSprite("res/gfx/icebox.png", 16, 16);
defBoxIce <- sprBoxIce;
sprBoxItem <- newSprite("res/gfx/itembox.png", 16, 16);
defBoxItem <- sprBoxItem;
sprBoxRed <- newSprite("res/gfx/redbox.png", 16, 16);
defBoxRed <- sprBoxRed;
sprBoxEmpty <- newSprite("res/gfx/emptybox.png", 16, 16);
defBoxEmpty <- sprBoxEmpty;
sprSpring <- newSprite("res/gfx/spring.png", 16, 16, 8, 8);
defSpring <- sprSpring;
sprSpringD <- newSprite("res/gfx/springd.png", 16, 16, 8, 8);
defSpringD <- sprSpringD;
sprWoodBox <- newSprite("res/gfx/woodbox.png", 16, 16);
defWoodBox <- sprWoodBox;
sprWoodBoxSnow <- newSprite("res/gfx/woodbox-snow.png", 16, 16);
defWoodBoxSnow <- sprWoodBoxSnow;
sprWoodBoxSand <- newSprite("res/gfx/woodbox-sand.png", 16, 16);
defWoodBoxSand <- sprWoodBoxSand;
sprBoxShop <- newSprite("res/gfx/shopblock.png", 16, 16);
defBoxShop <- sprBoxShop;
sprBoxChar <- newSprite("res/gfx/charbox.png", 16, 16);
defBoxChar <- sprBoxChar;
sprIceBlock <- newSprite("res/gfx/iceblock.png", 16, 16);
defIceBlock <- sprIceBlock;
sprFishBlock <- newSprite("res/gfx/herringblock.png", 16, 16);
defFishBlock <- sprFishBlock;
sprHoneyLock <- newSprite("res/gfx/honey-lock.png", 16, 16);
defHoneyLock <- sprHoneyLock;
sprWoodChunks <- newSprite("res/gfx/woodchunks.png", 8, 8, 4, 4);
defWoodChunks <- sprWoodChunks;
sprWoodChunksSand <- newSprite("res/gfx/woodchunks-sand.png", 8, 8, 4, 4);
defWoodChunksSand <- sprWoodChunksSand;
sprBoxInfo <- newSprite("res/gfx/infobox.png", 16, 16);
defBoxInfo <- sprBoxInfo;
sprKelvinScarf <- newSprite("res/gfx/kelvinscarf.png", 16, 16);
defKelvinScarf <- sprKelvinScarf;
sprBoxBounce <- newSprite("res/gfx/bouncebox.png", 16, 16);
defBoxBounce <- sprBoxBounce;
sprCheckBell <- newSprite("res/gfx/bell.png", 16, 16, 8, 0);
defCheckBell <- sprCheckBell;
sprTNT <- newSprite("res/gfx/tnt.png", 16, 16);
defTNT <- sprTNT;
sprC4 <- newSprite("res/gfx/c4.png", 16, 16);
defC4 <- sprC4;
sprColorBlock <- newSprite("res/gfx/switchblocks.png", 16, 16);
defColorBlock <- sprColorBlock;
sprColorSwitch <- newSprite("res/gfx/colorswitches.png", 32, 32, 16, 16);
defColorSwitch <- sprColorSwitch;
sprLockBlock <- newSprite("res/gfx/lock.png", 16, 16, 8, 8);
defLockBlock <- sprLockBlock;
sprBossDoor <- newSprite("res/gfx/boss-door.png", 16, 32);
defBossDoor <- sprBossDoor;
sprFireBlock <- newSprite("res/gfx/fireblock.png", 16, 16);
defFireBlock <- sprFireBlock;
sprCrumbleRock <- newSprite("res/gfx/crumble-rock.png", 16, 16, 8, 8);
defCrumbleRock <- sprCrumbleRock;
sprCrumbleIce <- newSprite("res/gfx/crumble-ice.png", 16, 16, 8, 8);
defCrumbleIce <- sprCrumbleIce;
sprCube <- newSprite("res/gfx/cube.png", 16, 16, 8, 8);
defCube <- sprCube;
sprBrickBlock <- newSprite("res/gfx/brickblock.png", 16, 16);
defBrickBlock <- sprBrickBlock;
sprBrickBlockSnow <- newSprite("res/gfx/brickblock-snow.png", 16, 16);
defBrickBlockSnow <- sprBrickBlockSnow;
sprBrickChunks <- newSprite("res/gfx/brickblock-chunks.png", 8, 8, 4, 4);
defBrickChunks <- sprBrickChunks;
sprBirdCage <- newSprite("res/gfx/birdcage.png", 32, 48, 16, 32);
defBirdCage <- sprBirdCage;
sprAttackPidgin <- newSprite("res/gfx/attack-pidgin.png", 21, 28, 10, 14);
defAttackPidgin <- sprAttackPidgin;
sprFlipBlock <- newSprite("res/gfx/flip-block.png", 16, 16);
defFlipBlock <- sprFlipBlock;
sprBeeHostage <- newSprite("res/gfx/bee-hostage.png", 20, 27, 10, 14);
defBeeHostage <- sprBeeHostage;
sprItemGlobe <- newSprite("res/gfx/item-globe.png", 24, 24, 12, 12);
defItemGlobe <- sprItemGlobe;

sprCyraSwordWave <- newSprite("res/gfx/cyra_gfx/swordwave.png", 28, 24, 14, 12);
defCyraSwordWave <- sprCyraSwordWave;
sprCyraFireWave <- newSprite("res/gfx/cyra_gfx/firewave.png", 28, 24, 14, 12);
defCyraFireWave <- sprCyraFireWave;
sprCyraFreezeWave <- newSprite(
	"res/gfx/cyra_gfx/freezewave.png",
	28,
	24,
	14,
	12
);
defCyraFreezeWave <- sprCyraFreezeWave;
sprCyraElectricWave <- newSprite(
	"res/gfx/cyra_gfx/electricwave.png",
	28,
	24,
	14,
	12
);
defCyraElectricWave <- sprCyraElectricWave;
sprWaterCrescent <- newSprite("res/gfx/water-crescent.png", 32, 16, 16, 8);
defWaterCrescent <- sprWaterCrescent;

// NPCs
sprRadGuin <- newSprite("res/gfx/radguin.png", 22, 32, 16, 32);
sprPennyNPC <- newSprite("res/gfx/penny-npc.png", 14, 24, 7, 24);
sprXue <- newSprite("res/gfx/xue.png", 20, 23, 12, 23);
sprPlasmaBreeze <- newSprite("res/gfx/plasmabreeze.png", 30, 32, 15, 32);
sprRockyRaccoon <- newSprite("res/gfx/rockyraccoon.png", 23, 27, 15, 26);
sprTinyFireGuin <- newSprite("res/gfx/tinyfireguin.png", 13, 23, 6, 23);
sprPygame <- newSprite("res/gfx/pygame.png", 32, 38, 16, 38);
sprPygameNPC <- newSprite("res/gfx/npc-pygame.png", 40, 40, 20, 20);
sprGnu <- newSprite("res/gfx/gnu.png", 29, 45, 15, 45);
sprSam <- newSprite("res/gfx/sam.png", 12, 32, 6, 32);
sprTuckles <- newSprite("res/gfx/tuckles.png", 18, 34, 8, 34);
sprGaruda <- newSprite("res/gfx/garuda.png", 35, 36, 17, 36);
sprKelvinNPC <- newSprite("res/gfx/npc-kelvin.png", 32, 32, 16, 32);
sprTwangNPC <- newSprite("res/gfx/twang-npc.png", 19, 20, 10, 20);
sprRustyboxNPC <- newSprite("res/gfx/rustybox-npc.png", 16, 20, 8, 20);
sprDuke <- newSprite("res/gfx/duke.png", 32, 32, 16, 32);
sprPenguinNPC <- newSprite("res/gfx/penguin-npc.png", 14, 23, 7, 23);
sprTixNPC <- newSprite("res/gfx/tix.png", 10, 16, 5, 16);
sprPenguinBuilderNPC <- newSprite(
	"res/gfx/penguin-builder-npc.png",
	14,
	27,
	7,
	27
);
sprBeam <- newSprite("res/gfx/beam.png", 20, 22, 10, 16);
sprOwlNPC <- newSprite("res/gfx/owl-npc.png", 32, 32, 16, 32);
sprMamaBearNPC <- newSprite("res/gfx/mamabear.png", 24, 37, 12, 37);
sprTealDeerNPC <- newSprite("res/gfx/tealdeer.png", 30, 46, 15, 46);
sprTigerNPC <- newSprite("res/gfx/npc-tiger.png", 21, 44, 12, 44);
sprLarryNPC <- newSprite("res/gfx/npc-larry.png", 32, 32, 16, 32);
sprBeeNPC <- newSprite("res/gfx/npc-bee.png", 20, 27, 12, 27);
sprFrostC <- newSprite("res/gfx/npc-frostc.png", 33, 37, 24, 37);

// Enemies
sprSnake <- newSprite("res/gfx/snake.png", 16, 32, 8, 0);
defSnake <- sprSnake;
sprSealion <- newSprite("res/gfx/sealion.png", 16, 48, 8, 0);
defSealion <- sprSealion;
sprDeathcap <- newSprite("res/gfx/deathcap.png", 16, 16, 8, 9);
defDeathcap <- sprDeathcap;
sprGradcap <- newSprite("res/gfx/smartcap.png", 16, 18, 8, 11);
defGradcap <- sprGradcap;
sprOrangeBounce <- newSprite("res/gfx/orange.png", 16, 16, 8, 8);
defOrangeBounce <- sprOrangeBounce;
sprCoconutBounce <- newSprite("res/gfx/coconut-bounce.png", 16, 16, 8, 8);
defCoconutBounce <- sprCoconutBounce;
sprCannon <- newSprite("res/gfx/cannon.png", 16, 16, 8, 8);
defCannon <- sprCannon;
sprCannonBob <- newSprite("res/gfx/cannonbob.png", 16, 16, 8, 8);
defCannonBob <- sprCannonBob;
sprOuchin <- newSprite("res/gfx/ouchin.png", 16, 16, 8, 8);
defOuchin <- sprOuchin;
sprCarlBoom <- newSprite("res/gfx/carlboom.png", 16, 16, 8, 8);
defCarlBoom <- sprCarlBoom;
sprBlueFish <- newSprite("res/gfx/fishblue.png", 28, 20, 16, 12);
defBlueFish <- sprBlueFish;
sprBlueFishSnow <- newSprite("res/gfx/fishblue-snow.png", 31, 18, 16, 9);
defBlueFishSnow <- sprBlueFishSnow;
sprRedFish <- newSprite("res/gfx/fishred.png", 28, 20, 16, 12);
defRedFish <- sprRedFish;
sprRedFishSnow <- newSprite("res/gfx/fishred-snow.png", 31, 18, 16, 9);
defRedFishSnow <- sprRedFishSnow;
sprGreenFish <- newSprite("res/gfx/fishgreen.png", 28, 20, 16, 12);
defGreenFish <- sprGreenFish;
sprGreenFishSnow <- newSprite("res/gfx/fishgreen-snow.png", 31, 18, 16, 9);
defGreenFishSnow <- sprGreenFishSnow;
sprDeadFish <- newSprite("res/gfx/deadfish.png", 23, 14, 14, 7);
defDeadFish <- sprDeadFish;
sprJellyFish <- newSprite("res/gfx/jellyfish.png", 16, 16, 8, 8);
defJellyFish <- sprJellyFish;
sprClamor <- newSprite("res/gfx/clamor.png", 16, 16, 8, 8);
defClamor <- sprClamor;
sprIcicle <- newSprite("res/gfx/icicle.png", 10, 16, 5, 4);
defIcicle <- sprIcicle;
sprPinecone <- newSprite("res/gfx/pinecone.png", 10, 16, 5, 4);
defPinecone <- sprPinecone;
sprCoconut <- newSprite("res/gfx/coconut.png", 16, 16, 8, 4);
defCoconut <- sprCoconut;
sprFlyAmanita <- newSprite("res/gfx/flyamanita.png", 20, 20, 10, 10);
defFlyAmanita <- sprFlyAmanita;
sprJumpy <- newSprite("res/gfx/bouncecap.png", 16, 20, 8, 8);
defJumpy <- sprJumpy;
sprDarkStar <- newSprite("res/gfx/darknyan.png", 16, 16, 8, 8);
defDarkStar <- sprDarkStar;
spr1down <- newSprite("res/gfx/1down.png", 16, 16, 8, 8);
def1down <- spr1down;
sprHaywire <- newSprite("res/gfx/haywire.png", 16, 16, 8, 8);
defHaywire <- sprHaywire;
sprGoldbomb <- newSprite("res/gfx/goldbomb.png", 16, 16, 8, 8);
defGoldbomb <- sprGoldbomb;
sprSawblade <- newSprite("res/gfx/sawblade.png", 16, 16, 8, 8);
defSawblade <- sprSawblade;
sprLivewire <- newSprite("res/gfx/Livewire.png", 16, 16, 8, 8);
defLivewire <- sprLivewire;
sprBlazeborn <- newSprite("res/gfx/blazeborn.png", 16, 16, 8, 9);
defBlazeborn <- sprBlazeborn;
sprWildcap <- newSprite("res/gfx/wildcap.png", 16, 16, 8, 9);
defWildcap <- sprWildcap;
sprOwlBrown <- newSprite("res/gfx/owl-brown.png", 32, 32, 16, 16);
defOwlBrown <- sprOwlBrown;
sprMrIceguy <- newSprite("res/gfx/mr-iceblock.png", 20, 19, 10, 11);
defMrIceguy <- sprMrIceguy;
sprMrTurtle <- newSprite("res/gfx/mr-turtle.png", 24, 16, 8, 9);
defMrTurtle <- sprMrTurtle;
sprSnailRed <- newSprite("res/gfx/snail-red.png", 16, 16, 8, 10);
defSnailRed <- sprSnailRed;
sprSnailBlue <- newSprite("res/gfx/snail-blue.png", 16, 16, 8, 10);
defSnailBlue <- sprSnailBlue;
sprSnailGreen <- newSprite("res/gfx/snail-green.png", 16, 16, 8, 10);
defSnailGreen <- sprSnailGreen;
sprMrSnowball <- newSprite("res/gfx/mr-snowball.png", 16, 16, 8, 9);
defMrSnowball <- sprMrSnowball;
sprMsSnowball <- newSprite("res/gfx/ms-snowball.png", 16, 16, 8, 9);
defMsSnowball <- sprMsSnowball;
sprSnowBounce <- newSprite("res/gfx/bouncysnow.png", 16, 16, 8, 8);
defSnowBounce <- sprSnowBounce;
sprSnowJumpy <- newSprite("res/gfx/og-jumpy.png", 16, 25, 8, 11);
defSnowJumpy <- sprSnowJumpy;
sprSpikeCap <- newSprite("res/gfx/spikecap.png", 16, 17, 8, 11);
defSpikeCap <- sprSpikeCap;
sprSnowSpike <- newSprite("res/gfx/snowspike.png", 20, 20, 10, 13);
defSnowSpike <- sprSnowSpike;
sprSnowFly <- newSprite("res/gfx/snowfly.png", 15, 19, 7, 8);
defSnowFly <- sprSnowFly;
sprTallCap <- newSprite("res/gfx/tallcap.png", 16, 32, 8, 24);
defTallCap <- sprTallCap;
sprSmartTallCap <- newSprite("res/gfx/smarttallcap.png", 16, 34, 8, 26);
defSmartTallCap <- sprSmartTallCap;
sprSnowman <- newSprite("res/gfx/snowman.png", 20, 31, 10, 22);
defSnowman <- sprSnowman;
sprSnowoman <- newSprite("res/gfx/snowoman.png", 20, 31, 10, 22);
defSnowoman <- sprSnowoman;
sprSnowCaptain <- newSprite("res/gfx/captain-snow.png", 16, 16, 8, 9);
defSnowCaptain <- sprSnowCaptain;
sprCaptainMorel <- newSprite("res/gfx/captain-morel.png", 16, 19, 8, 12);
defCaptainMorel <- sprCaptainMorel;
sprBearyl <- newSprite("res/gfx/bearyl.png", 32, 32, 16, 16);
defBearyl <- sprBearyl;
sprSirCrusher <- newSprite("res/gfx/icecrusher.png", 32, 32, 16, 16);
defSirCrusher <- sprSirCrusher;
sprDukeCrusher <- newSprite("res/gfx/duke-crusher.png", 32, 32, 16, 16);
defDukeCrusher <- sprDukeCrusher;
sprWheelerHamster <- newSprite("res/gfx/hamsterwheel.png", 24, 24, 12, 14);
defWheelerHamster <- sprWheelerHamster;
sprWheelerBlade <- newSprite("res/gfx/wheelblade.png", 24, 24, 12, 14);
defWheelerBlade <- sprWheelerBlade;
sprShiveriken <- newSprite("res/gfx/shiveriken.png", 24, 24, 12, 14);
defShiveriken <- sprShiveriken;
sprIvyGreen <- newSprite("res/gfx/ivy.png", 28, 20, 14, 14);
defIvyGreen <- sprIvyGreen;
sprMrSnowflake <- newSprite("res/gfx/mr-snowflake.png", 18, 19, 9, 13);
defMrSnowflake <- sprMrSnowflake;
sprIvyRed <- newSprite("res/gfx/walkingleaf.png", 28, 20, 14, 14);
defIvyRed <- sprIvyRed;
sprMrsSnowflake <- newSprite("res/gfx/mrs-snowflake.png", 18, 19, 9, 13);
defMrsSnowflake <- sprMrsSnowflake;
sprSkyDive <- newSprite("res/gfx/skydive.png", 24, 24, 12, 13);
defSkyDive <- sprSkyDive;
sprPuffranah <- newSprite("res/gfx/puffranah.png", 54, 51, 30, 30);
defPuffranah <- sprPuffranah;
sprStruffle <- newSprite("res/gfx/struffle.png", 32, 32, 16, 16);
defStruffle <- sprStruffle;
sprCrystallo <- newSprite("res/gfx/crystallo.png", 22, 21, 12, 15);
defCrystallo <- sprCrystallo;
sprWaspyBoi <- newSprite("res/gfx/waspy-boi.png", 30, 24, 15, 12);
defWaspyBoi <- sprWaspyBoi;
sprDevine <- newSprite("res/gfx/devine.png", 16, 16, 8, 8);
defDevine <- sprDevine;
sprSnoway <- newSprite("res/gfx/snoway.png", 16, 16, 8, 8);
defSnoway <- sprSnoway;
sprShortfuse <- newSprite("res/gfx/shortfuse.png", 12, 12, 6, 8);
defShortfuse <- sprShortfuse;
sprPeterFlower <- newSprite("res/gfx/peter.png", 48, 44, 24, 36);
defPeterFlower <- sprPeterFlower;
sprGranito <- newSprite("res/gfx/granito.png", 24, 24, 12, 14);
defGranito <- sprGranito;

sprGooBlack <- newSprite("res/gfx/goo-black.png", 16, 16, 8, 8);
defGooBlack <- sprGooBlack;
sprGooBlue <- newSprite("res/gfx/goo-blue.png", 16, 16, 8, 8);
defGooBlue <- sprGooBlue;
sprGooBrown <- newSprite("res/gfx/goo-brown.png", 16, 16, 8, 8);
defGooBrown <- sprGooBrown;
sprGooCrimson <- newSprite("res/gfx/goo-crimson.png", 16, 16, 8, 8);
defGooCrimson <- sprGooCrimson;
sprGooCyan <- newSprite("res/gfx/goo-cyan.png", 16, 16, 8, 8);
defGooCyan <- sprGooCyan;
sprGooGray <- newSprite("res/gfx/goo-gray.png", 16, 16, 8, 8);
defGooGray <- sprGooGray;
sprGooGreen <- newSprite("res/gfx/goo-green.png", 16, 16, 8, 8);
defGooGreen <- sprGooGreen;
sprGooIce <- newSprite("res/gfx/goo-ice.png", 16, 16, 8, 8);
defGooIce <- sprGooIce;
sprGooOrange <- newSprite("res/gfx/goo-orange.png", 16, 16, 8, 8);
defGooOrange <- sprGooOrange;
sprGooPink <- newSprite("res/gfx/goo-pink.png", 16, 16, 8, 8);
defGooPink <- sprGooPink;
sprGooPurple <- newSprite("res/gfx/goo-purple.png", 16, 16, 8, 8);
defGooPurple <- sprGooPurple;
sprGooRed <- newSprite("res/gfx/goo-red.png", 16, 16, 8, 8);
defGooRed <- sprGooRed;
sprGooTan <- newSprite("res/gfx/goo-tan.png", 16, 16, 8, 8);
defGooTan <- sprGooTan;
sprGooTeal <- newSprite("res/gfx/goo-teal.png", 16, 16, 8, 8);
defGooTeal <- sprGooTeal;
sprGooWhite <- newSprite("res/gfx/goo-white.png", 16, 16, 8, 8);
defGooWhite <- sprGooWhite;
sprGooYellow <- newSprite("res/gfx/goo-yellow.png", 16, 16, 8, 8);
defGooYellow <- sprGooYellow;
sprGooFox <- newSprite("res/gfx/goo-fox.png", 16, 16, 8, 8);
defGooFox <- sprGooFox;

// Bosses
sprNolok <- newSprite("res/gfx/nolok.png", 64, 64, 32, 40);
defNolok <- sprNolok;
sprYeti <- newSprite("res/gfx/yeti.png", 64, 64, 36, 40);
defYeti <- sprYeti;

// Items
sprMuffin <- newSprite("res/gfx/muffin.png", 16, 16, 8, 8);
defMuffin <- sprMuffin;
sprStar <- newSprite("res/gfx/starnyan.png", 16, 16, 8, 8);
defStar <- sprStar;
sprCoin <- newSprite("res/gfx/coin.png", 16, 16, 8, 8);
defCoin <- sprCoin;
sprGoldRing <- newSprite("res/gfx/gold-ring.png", 16, 16, 8, 8);
defGoldRing <- sprGoldRing;
sprCoin5 <- newSprite("res/gfx/5coin.png", 16, 16, 8, 8);
defCoin5 <- sprCoin5;
sprCoin10 <- newSprite("res/gfx/10coin.png", 16, 16, 8, 8);
defCoin10 <- sprCoin10;
sprHerring <- newSprite("res/gfx/herring.png", 16, 16, 8, 8);
defHerring <- sprHerring;
sprRedHerring <- newSprite("res/gfx/redherring.png", 16, 16, 8, 8);
defRedHerring <- sprRedHerring;
sprHoneyCrystal <- newSprite("res/gfx/honey-crystal.png", 16, 16, 8, 8);
defHoneyCrystal <- sprHoneyCrystal;
sprFlowerFire <- newSprite("res/gfx/fireflower.png", 16, 16, 8, 8);
defFlowerFire <- sprFlowerFire;
sprFlowerIce <- newSprite("res/gfx/iceflower.png", 16, 16, 8, 8);
defFlowerIce <- sprFlowerIce;
sprAirFeather <- newSprite("res/gfx/airfeather.png", 16, 16, 8, 8);
defAirFeather <- sprAirFeather;
sprFlyRefresh <- newSprite("res/gfx/featherspin.png", 16, 16, 8, 8);
defFlyRefresh <- sprFlyRefresh;
sprEarthShell <- newSprite("res/gfx/earthshell.png", 16, 16, 8, 8);
defEarthShell <- sprEarthShell;
sprBerry <- newSprite("res/gfx/strawberry.png", 10, 12, 5, 6);
defBerry <- sprBerry;
sprBerryLarge <- newSprite("res/gfx/strawberry-large.png", 15, 18, 8, 9);
defBerryLarge <- sprBerryLarge;
sprKeyCopper <- newSprite("res/gfx/key-copper.png", 16, 16, 8, 8);
defKeyCopper <- sprKeyCopper;
sprKeySilver <- newSprite("res/gfx/key-silver.png", 16, 16, 8, 8);
defKeySilver <- sprKeySilver;
sprKeyGold <- newSprite("res/gfx/key-gold.png", 16, 16, 8, 8);
defKeyGold <- sprKeyGold;
sprKeyMythril <- newSprite("res/gfx/key-mythril.png", 16, 16, 8, 8);
defKeyMythril <- sprKeyMythril;
sprSpecialBall <- newSprite("res/gfx/specialbubble.png", 16, 16, 8, 8);
defSpecialBall <- sprSpecialBall;
sprCoffee <- newSprite("res/gfx/coffee-cup.png", 14, 20, 7, 12);
defCoffee <- sprCoffee;
sprMysticDoll <- newSprite("res/gfx/mystic-doll.png", 16, 16, 8, 8);
defMysticDoll <- sprMysticDoll;
sprCoinSmall <- newSprite("res/gfx/coin-small.png", 8, 8, 4, 4);
defCoinSmall <- sprCoinSmall;
sprShockBulb <- newSprite("res/gfx/shockbulb.png", 14, 15, 7, 8);
defShockBulb <- sprShockBulb;
sprWaterLily <- newSprite("res/gfx/water-lily.png", 16, 16, 8, 8);
defWaterLily <- sprWaterLily;
sprPumpkin <- newSprite("res/gfx/pumpkin.png", 16, 16, 8, 8);
defPumpkin <- sprPumpkin;
sprSoccerBall <- newSprite("res/gfx/soccerball.png", 16, 16, 8, 8);
defSoccerBall <- sprSoccerBall;
sprLightCap <- newSprite("res/gfx/lightcap.png", 16, 16, 8, 8);
defLightCap <- sprLightCap;
sprDarkCap <- newSprite("res/gfx/darkcap.png", 16, 16, 8, 8);
defDarkCap <- sprDarkCap;

// Effects
sprSpark <- newSprite("res/gfx/spark.png", 12, 16, 6, 8);
defSpark <- sprSpark;
sprGlimmer <- newSprite("res/gfx/glimmer.png", 10, 10, 5, 5);
defGlimmer <- sprGlimmer;
sprFireball <- newSprite("res/gfx/fireball.png", 8, 8, 4, 4);
defFireball <- sprFireball;
sprIceball <- newSprite("res/gfx/iceball.png", 6, 6, 3, 3);
defIceball <- sprIceball;
sprPoof <- newSprite("res/gfx/poof.png", 16, 16, 8, 8);
defPoof <- sprPoof;
sprFlame <- newSprite("res/gfx/flame.png", 14, 20, 7, 12);
defFlame <- sprFlame;
sprFlameTiny <- newSprite("res/gfx/tinyflame.png", 8, 8, 4, 4);
defFlameTiny <- sprFlameTiny;
sprIceTrapSmall <- newSprite("res/gfx/icetrapsmall.png", 24, 24, 12, 12);
defIceTrapSmall <- sprIceTrapSmall;
sprIceTrapLarge <- newSprite("res/gfx/icetraplarge.png", 48, 48, 24, 24);
defIceTrapLarge <- sprIceTrapLarge;
sprIceTrapTall <- newSprite("res/gfx/icetraptall.png", 24, 48, 12, 24);
defIceTrapTall <- sprIceTrapTall;
sprIceTrapScaled <- newSprite("res/gfx/icetrap-scaled.png", 96, 96, 48, 48);
defIceTrapScaled <- sprIceTrapScaled;
sprIceChunks <- newSprite("res/gfx/icechunk.png", 12, 12, 6, 6);
defIceChunks <- sprIceChunks;
sprTinyWind <- newSprite("res/gfx/tinywind.png", 16, 16, 8, 8);
defTinyWind <- sprTinyWind;
sprTFflash <- newSprite("res/gfx/tfFlash.png", 32, 40, 16, 20);
defTFflash <- sprTFflash;
sprExplodeF <- newSprite("res/gfx/explodeF.png", 24, 24, 12, 12);
defExplodeF <- sprExplodeF;
sprExplodeF2 <- newSprite("res/gfx/explodeF2.png", 48, 48, 24, 24);
defExplodeF2 <- sprExplodeF2;
sprExplodeF3 <- newSprite("res/gfx/explodeF3.png", 72, 72, 36, 36);
defExplodeF3 <- sprExplodeF3;
sprExplodeI <- newSprite("res/gfx/explodeI.png", 30, 30, 15, 15);
defExplodeI <- sprExplodeI;
sprExplodeN <- newSprite("res/gfx/explodeN.png", 30, 30, 15, 15);
defExplodeN <- sprExplodeN;
sprExplodeN2 <- newSprite("res/gfx/explodeN2.png", 55, 55, 27, 27);
defExplodeN2 <- sprExplodeN2;
sprExplodeN3 <- newSprite("res/gfx/explodeN3.png", 87, 87, 43, 43);
defExplodeN3 <- sprExplodeN3;
sprExplodeS <- newSprite("res/gfx/explodeS.png", 32, 32, 16, 16);
defExplodeS <- sprExplodeS;
sprExplodeS2 <- newSprite("res/gfx/explodeS2.png", 64, 64, 32, 32);
defExplodeS2 <- sprExplodeS2;
sprExplodeA <- newSprite("res/gfx/explodeA.png", 32, 32, 16, 30);
defExplodeA <- sprExplodeA;
sprExplodeE <- newSprite("res/gfx/explodeE.png", 32, 32, 16, 20);
defExplodeE <- sprExplodeE;
sprExplodeW <- newSprite("res/gfx/explodeW.png", 32, 32, 16, 16);
defExplodeW <- sprExplodeW;
sprExplodeW2 <- newSprite("res/gfx/explodeW2.png", 64, 64, 32, 32);
defExplodeW2 <- sprExplodeW2;
sprWaterSurface <- newSprite("res/gfx/watersurface.png", 16, 4);
defWaterSurface <- sprWaterSurface;
sprLavaSurface <- newSprite("res/gfx/lavasurface.png", 16, 8, 0, -8);
defLavaSurface <- sprLavaSurface;
sprLava <- newSprite("res/gfx/lava.png", 16, 16, 0, 0);
defLava <- sprLava;
sprHoneySurface <- newSprite("res/gfx/honey-surface.png", 16, 4);
defHoneySurface <- sprHoneySurface;
sprSwampSurface <- newSprite("res/gfx/swamp-surface.png", 16, 4);
defSwampSurface <- sprSwampSurface;
sprAcidSurface <- newSprite("res/gfx/acidsurface.png", 16, 16);
defAcidSurface <- sprAcidSurface;
sprAcid <- newSprite("res/gfx/acid.png", 16, 16);
defAcid <- sprAcid;
sprHeal <- newSprite("res/gfx/heal.png", 7, 7, 3, 3);
defHeal <- sprHeal;
sprHealMana <- newSprite("res/gfx/heal-mana.png", 7, 7, 3, 3);
defHealMana <- sprHealMana;
sprHealStamina <- newSprite("res/gfx/heal-stamina.png", 7, 7, 3, 3);
defHealStamina <- sprHealStamina;
sprSplash <- newSprite("res/gfx/splash.png", 21, 17, 12, 16);
defSplash <- sprSplash;
sprHoneySplash <- newSprite("res/gfx/honeysplash.png", 21, 17, 12, 16);
defHoneySplash <- sprHoneySplash;
sprSwampSplash <- newSprite("res/gfx/swampsplash.png", 21, 17, 12, 16);
defSwampSplash <- sprSwampSplash;
sprAcidSplash <- newSprite("res/gfx/acidsplash.png", 21, 17, 12, 16);
defAcidSplash <- sprAcidSplash;
sprLavaSplash <- newSprite("res/gfx/lavasplash.png", 21, 17, 12, 16);
defLavaSplash <- sprLavaSplash;
sprBigSpark <- newSprite("res/gfx/hit-yellow.png", 55, 68, 32, 40);
defBigSpark <- sprBigSpark;
sprSteelBall <- newSprite("res/gfx/steelball.png", 8, 8, 4, 4);
defSteelBall <- sprSteelBall;
sprRock <- newSprite("res/gfx/rock.png", 16, 16, 8, 8);
defRock <- sprRock;
sprBallSpin <- newSprite("res/gfx/ball-spin.png", 20, 20, 10, 10);
defBallSpin <- sprBallSpin;
sprNutBomb <- newSprite("res/gfx/nutbomb.png", 8, 8, 4, 4);
defNutBomb <- sprNutBomb;
sprNutBomb2 <- newSprite("res/gfx/nutbomb2.png", 16, 16, 8, 8);
defNutBomb2 <- sprNutBomb2;
sprNutBomb3 <- newSprite("res/gfx/nutbomb3.png", 16, 16, 8, 8);
defNutBomb3 <- sprNutBomb3;
sprTopNut <- newSprite("res/gfx/topnut.png", 16, 16, 8, 9);
defTopNut <- sprTopNut;
sprWingNut <- newSprite("res/gfx/wingnutbomb.png", 16, 16, 8, 8);
defWingnut <- sprWingNut;
sprNutMine <- newSprite("res/gfx/nutmine.png", 16, 16, 8, 12);
defNutMine <- sprNutMine;
sprCakeBomb <- newSprite("res/gfx/cupcake-small.png", 16, 16, 8, 8);
defCakeBomb <- sprCakeBomb;
sprCakeBomb2 <- newSprite("res/gfx/cupcake-med.png", 16, 16, 8, 8);
defCakeBomb2 <- sprCakeBomb2;
sprCakeBomb3 <- newSprite("res/gfx/cupcake-large.png", 16, 16, 8, 8);
defCakeBomb3 <- sprCakeBomb3;
sprTopCake <- newSprite("res/gfx/topcake.png", 16, 16, 8, 12);
defTopCake <- sprTopCake;
sprWingCake <- newSprite("res/gfx/wingcupcake.png", 16, 16, 8, 8);
defWingCake <- sprWingCake;
sprCakeMine <- newSprite("res/gfx/cakemine.png", 16, 16, 8, 12);
defCakeMine <- sprCakeMine;
sprCharge <- newSprite("res/gfx/charge.png", 32, 32, 16, 16);
defCharge <- sprCharge;
sprChargeFire <- newSprite("res/gfx/charge-fire.png", 32, 32, 16, 16);
defChargeFire <- sprChargeFire;
sprChargeIce <- newSprite("res/gfx/charge-ice.png", 32, 32, 16, 16);
defChargeIce <- sprChargeIce;
sprChargeShock <- newSprite("res/gfx/charge-shock.png", 32, 32, 16, 16);
defChargeShock <- sprChargeShock;
sprChargeAir <- newSprite("res/gfx/charge-air.png", 32, 32, 16, 16);
defChargeAir <- sprChargeAir;
sprChargeEarth <- newSprite("res/gfx/charge-earth.png", 32, 32, 16, 16);
defChargeEarth <- sprChargeEarth;
sprChargeWater <- newSprite("res/gfx/charge-water.png", 32, 32, 16, 16);
defChargeWater <- sprChargeWater;
sprGoldCharge <- newSprite("res/gfx/goldcharge.png", 8, 8, 4, 4);
defGoldCharge <- sprGoldCharge;
sprBubble <- newSprite("res/gfx/bubble.png", 8, 8, 4, 4);
defBubble <- sprBubble;
sprCrystalBullet <- newSprite("res/gfx/crystal-bullet.png", 16, 7, 8, 5);
defCrystalBullet <- sprCrystalBullet;
sprShieldInsta <- newSprite("res/gfx/shield-insta.png", 32, 32, 16, 16);
defShieldInsta <- sprShieldInsta;
sprShieldDash <- newSprite("res/gfx/shield-dash.png", 32, 32, 12, 16);
defShieldDash <- sprShieldDash;
sprShieldFire <- newSprite("res/gfx/shield-fire.png", 32, 32, 16, 16);
defShieldFire <- sprShieldFire;
sprShieldIce <- newSprite("res/gfx/shield-ice.png", 32, 32, 16, 16);
defShieldIce <- sprShieldIce;
sprShieldAir <- newSprite("res/gfx/shield-air.png", 32, 32, 16, 16);
defShieldAir <- sprShieldAir;
sprShieldWater <- newSprite("res/gfx/shield-water.png", 32, 32, 16, 16);
defShieldWater <- sprShieldWater;
sprShieldShock <- newSprite("res/gfx/shield-shock.png", 32, 32, 16, 16);
defShieldShock <- sprShieldShock;
sprWaterball <- newSprite("res/gfx/water-ball-small.png", 8, 8, 4, 4);
defWaterball <- sprWaterball;
sprWaterBomb <- newSprite("res/gfx/water-ball.png", 18, 18, 9, 9);
defWaterBomb <- sprWaterBomb;
sprShockball <- newSprite("res/gfx/shockball.png", 8, 8, 4, 4);
defShockball <- sprShockball;
sprShockBolt <- newSprite("res/gfx/shock-bolt.png", 24, 8, 12, 4);
defShockBolt <- sprShockBolt;
sprStoneBall <- newSprite("res/gfx/stone-ball.png", 16, 16, 8, 8);
defStoneBall <- sprStoneBall;
sprExplodeTiny <- newSprite("res/gfx/explode-tiny.png", 16, 16, 8, 8);
defExplodeTiny <- sprExplodeTiny;
sprFireDash <- newSprite("res/gfx/firedash.png", 16, 32, 8, 16);
defFireDash <- sprFireDash;
sprMagicJump <- newSprite("res/gfx/jump-flash.png", 20, 16, 10, 8);
defMagicJump <- sprMagicJump;
sprChainLink <- newSprite("res/gfx/chain-link.png", 8, 8, 4, 4);
defChainLink <- sprChainLink;
sprMagnet <- newSprite("res/gfx/magnet.png", 16, 16, 4, 8);
defMagnet <- sprMagnet;
sprVineLink <- newSprite("res/gfx/vine-link.png", 8, 8, 4, 4);
defVineLink <- sprVineLink;
sprVineClaw <- newSprite("res/gfx/vine-claw.png", 16, 16, 4, 8);
defVineClaw <- sprVineClaw;

// Platforms
sprPlatformWood <- newSprite("res/gfx/moplat-wood.png", 16, 8, 8, 4);
defPlatformWood <- sprPlatformWood;
sprPlatformStone <- newSprite("res/gfx/moplat-stone.png", 16, 8, 8, 4);
defPlatformStone <- sprPlatformStone;
sprPlatformBlue <- newSprite("res/gfx/moplat-blue.png", 16, 8, 8, 4);
defPlatformBlue <- sprPlatformBlue;
sprBoostRing <- newSprite("res/gfx/boost-ring.png", 12, 32, 6, 16);
defBoostRing <- sprBoostRing;
sprUbumper <- newSprite("res/gfx/ubumper.png", 20, 20, 10, 10);
defUbumper <- sprUbumper;
sprRamp <- newSprite("res/gfx/ramp.png", 32, 24, 16, 16);
defRamp <- sprRamp;

// Doors
sprDoorLocks <- newSprite("res/gfx/lock-door.png", 16, 16, 8, 8);
sprDoorWoodFace <- newSprite("res/gfx/door-wood-face.png", 32, 48);
defDoorWoodFace <- sprDoorWoodFace;
sprDoorWoodEdge <- newSprite("res/gfx/door-wood-edge.png", 6, 48, 3, 0);
defDoorWoodEdge <- sprDoorWoodEdge;
sprDoorDungeonFace <- newSprite("res/gfx/door-dungeon-face.png", 32, 48);
defDoorDungeonFace <- sprDoorDungeonFace;
sprDoorDungeonEdge <- newSprite("res/gfx/door-dungeon-edge.png", 6, 48, 3, 0);

// Portals
sprPortalGray <- newSprite("res/gfx/portal-gray.png", 32, 48, 16, 24);
sprPortalBlue <- newSprite("res/gfx/portal-blue.png", 32, 48, 16, 24);
sprPortalRed <- newSprite("res/gfx/portal-red.png", 32, 48, 16, 24);
sprPortalGreen <- newSprite("res/gfx/portal-green.png", 32, 48, 16, 24);
sprPortalYellow <- newSprite("res/gfx/portal-yellow.png", 32, 48, 16, 24);
sprPortalPunkle <- newSprite("res/gfx/portal-punkle.png", 32, 48, 16, 24);
sprPortalOrange <- newSprite("res/gfx/portal-orange.png", 32, 48, 16, 24);

// Misc Objects
sprNectarBottle <- newSprite("res/gfx/nectar-bottle.png", 16, 16, 8, 8);

// Backgrounds
bgPause <- 0;
bgCaveHoles <- newSprite("res/gfx/rockgapsBG.png", 400, 392);
bgIridia <- newSprite("res/gfx/iridia.png", 100, 56);
bgAurora <- newSprite("res/gfx/aurora.png", 720, 240);
bgAuroraNight <- newSprite("res/gfx/aurora-night.png", 720, 240);
bgRiverCity <- newSprite("res/gfx/rivercity.png", 380, 240);
bgOcean <- newSprite("res/gfx/ocean.png", 480, 8);
bgOceanNight <- newSprite("res/gfx/ocean-night.png", 480, 8);
bgForest0 <- newSprite("res/gfx/forest0.png", 128, 180);
bgForest1 <- newSprite("res/gfx/forest1.png", 128, 240, 0, -4);
bgForest2 <- newSprite("res/gfx/forest-cliff-bg.png", 755, 240);
bgWoodedMountain <- newSprite("res/gfx/woodedmountain.png", 640, 240);
bgForestNight0 <- newSprite("res/gfx/forest0-night.png", 128, 180);
bgForestNight1 <- newSprite("res/gfx/forest1-night.png", 128, 240, 0, -4);
bgWoodedMountainNight <- newSprite(
	"res/gfx/forest-mountain-night.png",
	850,
	240
);
bgStarSky <- loadImage("res/gfx/starrysky.png");
bgUnderwater <- newSprite("res/gfx/underwaterbg.png", 426, 240);
bgUnderwaterLight <- newSprite("res/gfx/underwaterbg-light.png", 426, 240);
bgCastle <- newSprite("res/gfx/castlebg.png", 640, 240);
bgSnowPlain <- newSprite("res/gfx/bgSnowPlain.png", 720, 240);
bgSnowNight <- newSprite("res/gfx/bgSnowNight.png", 800, 240);
bgIceForest <- newSprite("res/gfx/iceforest.png", 640, 240);
bgIceForest0 <- newSprite("res/gfx/iceforest0.png", 800, 320);
bgIceForest1 <- newSprite("res/gfx/iceforest1.png", 640, 256);
bgIceForest2 <- newSprite("res/gfx/iceforest2.png", 480, 192);
bgFortMagma <- newSprite("res/gfx/fortmagmasky.png", 960, 240);
bgCharSel <- newSprite("res/gfx/charsel.png", 426, 240, 213, 0);
bgPennyton0 <- newSprite("res/gfx/pennyton-bg-0.png", 480, 112);
bgPennyton1 <- newSprite("res/gfx/pennyton-bg-1.png", 480, 74);
bgMoon <- newSprite("res/gfx/bg-moon.png", 32, 32, 16, 16);
bgSwitch0 <- newSprite("res/gfx/bg-switch-palace-0.png", 168, 480);
bgSwitch1 <- newSprite("res/gfx/bg-switch-palace-1.png", 84, 240);
bgCaveEarth0 <- newSprite("res/gfx/dirt-cave-bg-0.png", 100, 56);
bgCaveEarth1 <- newSprite("res/gfx/dirt-cave-bg-1.png", 512, 288);
bgCaveBlue0 <- newSprite("res/gfx/blue-cave-bg-0.png", 100, 56);
bgCaveBlue1 <- newSprite("res/gfx/blue-cave-bg-1.png", 512, 288);
bgDeepForest0 <- loadImage("res/gfx/deep-forest-0.png");
bgDeepForest1 <- loadImage("res/gfx/deep-forest-1.png");
bgDeepForest2 <- loadImage("res/gfx/deep-forest-2.png");
bgSunsetMountain <- loadImage("res/gfx/sunset-mountain.png");
bgDesert <- newSprite("res/gfx/desertbg.png", 350, 1);
bgStadium <- newSprite("res/gfx/bg_stadium.png", 320, 280, 0, 280);
bgHive <- newSprite("res/gfx/bg-beehive.png", 258, 172);

// Weather
weRain <- newSprite("res/gfx/rainfall.png", 256, 256);
weSnow <- newSprite("res/gfx/snowfall.png", 64, 64);

// Lights
sprLightBasic <- newSprite("res/gfx/light-player-basic.png", 48, 48, 24, 24);
spriteSetBlendMode(sprLightBasic, bm_add);
sprLightFire <- newSprite("res/gfx/light-fire.png", 128, 128, 64, 64);
spriteSetBlendMode(sprLightFire, bm_add);
sprLightIce <- newSprite("res/gfx/light-ice.png", 128, 128, 64, 64);
spriteSetBlendMode(sprLightIce, bm_add);
sprLightGradient <- newSprite("res/gfx/light-gradient.png", 64, 64, 32, 32);
spriteSetBlendMode(sprLightGradient, bm_add);
sprLightLarge <- newSprite("res/gfx/light-large.png", 256, 256, 128, 128);
spriteSetBlendMode(sprLightLarge, bm_add);
sprLightCeiling <- newSprite("res/gfx/light-ceiling.png", 256, 128, 128, 8);
spriteSetBlendMode(sprLightCeiling, bm_add);

// Battle stages
sprBattleTest <- newSprite("res/gfx/previews/battle-test.png", 128, 56, 64, 28);
sprBattleCastle <- newSprite(
	"res/gfx/previews/battle-castle.png",
	128,
	58,
	64,
	29
);
sprBattleHenge <- newSprite(
	"res/gfx/previews/battle-henge.png",
	128,
	52,
	64,
	26
);
sprBattleDesert <- newSprite(
	"res/gfx/previews/battle-desert.png",
	128,
	102,
	64,
	51
);
sprBattleHole <- newSprite(
	"res/gfx/previews/battle-hole.png",
	128,
	118,
	64,
	59
);
sprBattleSoccer <- newSprite(
	"res/gfx/previews/battle-soccer.png",
	128,
	20,
	64,
	10
);

// Sounds
sndFireball <- loadSound("res/snd/fireball.ogg");
sndJump <- loadSound("res/snd/jump.ogg");
sndMidiJump <- loadSound("res/snd/midi-jump.ogg");
sndHurt <- loadSound("res/snd/hurt.ogg");
sndHit <- loadSound("res/snd/hit.ogg");
sndKick <- loadSound("res/snd/kick.ogg");
sndSquish <- loadSound("res/snd/squish.ogg");
sndCoin <- loadSound("res/snd/coin.ogg");
sndCoinSmall <- loadSound("res/snd/coin-small.ogg");
sndSlide <- loadSound("res/snd/slide.ogg");
sndFlame <- loadSound("res/snd/flame.ogg");
sndSpring <- loadSound("res/snd/trampoline.ogg");
sndDie <- loadSound("res/snd/die.ogg");
sndWin <- loadSound("res/snd/win.ogg");
sndBump <- loadSound("res/snd/bump.ogg");
sndHeal <- loadSound("res/snd/heal.ogg");
sndFlap <- loadSound("res/snd/flap.ogg");
sndExplodeF <- loadSound("res/snd/explodeF.ogg");
sndExplodeF2 <- loadSound("res/snd/explodeF2.ogg");
sndExplodeN <- loadSound("res/snd/explodeN.ogg");
sndExplodeI <- loadSound("res/snd/explodeI.ogg");
sndExplodeS <- loadSound("res/snd/explodeS.ogg");
sndExplodeA <- loadSound("res/snd/explodeA.ogg");
sndExplodeA2 <- loadSound("res/snd/explodeA2.ogg");
sndExplodeA3 <- loadSound("res/snd/explodeA3.ogg");
sndExplodeTiny <- loadSound("res/snd/explode-tiny.ogg");
sndFizz <- loadSound("res/snd/fizz.ogg");
sndBell <- loadSound("res/snd/bell.ogg");
sndIcicle <- loadSound("res/snd/icicle.ogg");
sndIceBreak <- loadSound("res/snd/icebreak.ogg");
snd1up <- loadSound("res/snd/1up.ogg");
sndWallkick <- loadSound("res/snd/wallkick.ogg");
sndWarning <- loadSound("res/snd/warning.ogg");
sndGulp <- loadSound("res/snd/gulp.ogg");
sndFish <- loadSound("res/snd/fish.ogg");
sndGrowl <- loadSound("res/snd/growl.ogg");
sndMenuMove <- loadSound("res/snd/menu-move.ogg");
sndMenuSelect <- loadSound("res/snd/menu-select.ogg");
sndBossHit <- loadSound("res/snd/boss-hit.ogg");
sndCrush <- loadSound("res/snd/crush.ogg");
sndIceblock <- loadSound("res/snd/iceblock_bump.ogg");
sndAchievement <- loadSound("res/snd/achievement.ogg");
sndThrow <- loadSound("res/snd/throw.ogg");
sndCrumble <- loadSound("res/snd/crumble.ogg");
sndWoosh <- loadSound("res/snd/shortwind.ogg");
sndDrop <- loadSound("res/snd/drop.ogg");
sndBlizzardBomb <- loadSound("res/snd/blizzard-bomb.ogg");
sndPigSnort <- loadSound("res/snd/pig_snort.ogg");
sndPigSqueal <- loadSound("res/snd/pig_squeal.ogg");
sndSurgeJump <- loadSound("res/snd/surge-jump.ogg");
sndSurgeRoll <- loadSound("res/snd/surge-roll.ogg");
sndSurgeCharge <- [
	loadSound("res/snd/surge-charge-0.ogg"),
	loadSound("res/snd/surge-charge-1.ogg"),
	loadSound("res/snd/surge-charge-2.ogg"),
	loadSound("res/snd/surge-charge-3.ogg"),
	loadSound("res/snd/surge-charge-4.ogg"),
	loadSound("res/snd/surge-charge-5.ogg"),
	loadSound("res/snd/surge-charge-6.ogg"),
	loadSound("res/snd/surge-charge-7.ogg"),
	loadSound("res/snd/surge-charge-8.ogg"),
	loadSound("res/snd/surge-charge-9.ogg"),
	loadSound("res/snd/surge-charge-10.ogg")
];
sndSplash <- loadSound("res/snd/splash.ogg");
sndSplashBig <- loadSound("res/snd/splash-big.ogg");
sndFlyAway <- loadSound("res/snd/fly-away.ogg");
sndNootA <- loadSound("res/snd/noota.ogg");
sndNootB <- loadSound("res/snd/nootb.ogg");
sndDook <- loadSound("res/snd/dook.ogg");
sndWaterball <- loadSound("res/snd/waterball.ogg");
sndBlurp <- loadSound("res/snd/blurp.ogg");
sndSecret <- loadSound("res/snd/secret.ogg");
sndPing <- [
	loadSound("res/snd/ping-0.ogg"),
	loadSound("res/snd/ping-1.ogg"),
	loadSound("res/snd/ping-2.ogg"),
	loadSound("res/snd/ping-3.ogg"),
	loadSound("res/snd/ping-4.ogg"),
	loadSound("res/snd/ping-5.ogg"),
	loadSound("res/snd/ping-6.ogg"),
	loadSound("res/snd/ping-7.ogg")
];
sndNBShoot <- loadSound("res/snd/nb-switch.ogg");
sndNBBounce <- loadSound("res/snd/nb-bumplil.ogg");
sndCyraSwordSwing <- loadSound("res/snd/cyra_snd/swordswing.ogg");
sndCyraFireSwing <- loadSound("res/snd/cyra_snd/firewave.ogg");
sndCyraTornado <- loadSound("res/snd/cyra_snd/windswing.ogg");
sndCyraElectricSwing <- loadSound("res/snd/electricwave.ogg");
sndCannon <- loadSound("res/snd/cannon.ogg");
sndTrick <- loadSound("res/snd/trick.ogg");

// Music
gvMusic <- 0; // Stores the current music so that not too many large songs are loaded at once
gvMusicName <- "";
gvLastSong <- "";

musTheme <- "res/mus/supertuxtheme.ogg";
musDisko <- "res/mus/chipdisko.ogg";
musCave <- "res/mus/cave.ogg";
musOverworld <- "res/mus/overworld.ogg";
musCity <- "res/mus/village-mixed.ogg";
musCastle <- "res/mus/castle.ogg";
musRace <- "res/mus/blackdiamond.ogg";
musDeluge <- "res/mus/deluge.ogg";
musSnowTown <- "res/mus/winter_wonderland.ogg";
musAirship <- "res/mus/airship.ogg";
musPuzzle <- "res/mus/puzzle.ogg";
musIceland <- "res/mus/iceland.ogg";
musRetro23 <- "res/mus/retro-23.ogg";
musBoss <- "res/mus/boss.ogg";
musBossIntro <- "res/mus/boss-intro.ogg";
musGrassOverworld <- "res/mus/peaceful-village.ogg";
musBerrylife <- "res/mus/berrylife.ogg";
musIceChip <- "res/mus/ice_music.ogg";
musSnabForest <- "res/mus/snab-forest.ogg";
musSAGrass <- "res/mus/sa-grasslands.ogg";
musSAIsland <- "res/mus/sa-island.ogg";
musSAMines <- "res/mus/sa-mines.ogg";
musSAPrairie <- "res/mus/sa-prairie.ogg";
musSASneak <- "res/mus/sa-sneak.ogg";
musForestTop <- "res/mus/forest-top.ogg";
musSAAdventure <- "res/mus/sa-sdventure.ogg";
musCloseYetFar <- "res/mus/RPG_Close_Yet_So_Far.ogg";
musMadBossa <- "res/mus/mad-bossa.ogg";
musSummerChallenge <- "res/mus/summer-challenge.ogg";
musRetroBeach <- "res/mus/retroracing-beach.ogg";

// Saved separately so that it can be reused frequently
musInvincible <- loadMusic("res/mus/invincible.ogg");

songPlay <- function (song) {
	if (song == 0) {
		songStop();
		return;
	}
	gvMusicName = song;
	if (gvMusicName == gvLastSong) return;

	deleteMusic(gvMusic);
	gvMusic = loadMusic(song);
	playMusic(gvMusic, -1);

	gvLastSong = song;
};

songStop <- function () {
	stopMusic();
	gvMusicName = 0;
	gvLastSong = 0;
};

gfxReset <- function () {
	foreach (key, i in getroottable()) {
		if (key.len() > 4 && key.slice(0, 3) == "spr") {
			local defspr = "def" + key.slice(3);
			if (defspr in getroottable()) {
				getroottable()[key] = getroottable()[defspr];
			}
		}
	}
};

gfxEnemySnow <- function () {
	sprDeathcap = sprMrSnowball;
	sprGradcap = sprMsSnowball;
	sprOrangeBounce = sprSnowBounce;
	sprJumpy = sprSnowJumpy;
	sprSpikeCap = sprSnowSpike;
	sprFlyAmanita = sprSnowFly;
	sprTallCap = sprSnowman;
	sprSmartTallCap = sprSnowoman;
	sprCrumbleRock = sprCrumbleIce;
	sprCaptainMorel = sprSnowCaptain;
	sprBearyl = sprSirCrusher;
	sprWheelerHamster = sprShiveriken;
	sprSnake = sprSealion;
	sprWoodBox = sprWoodBoxSnow;
	sprIvyGreen = sprMrSnowflake;
	sprIvyRed = sprMrsSnowflake;
	sprMrIceguy = defMrIceguy;
	sprBlueFish = sprBlueFishSnow;
	sprRedFish = sprRedFishSnow;
	sprGreenFish = sprGreenFishSnow;
	sprDevine = sprSnoway;
	sprBrickBlock = sprBrickBlockSnow;
};

gfxEnemyForest <- function () {
	sprMrIceguy = sprMrTurtle;
	sprIcicle = sprPinecone;
	sprChainLink = sprVineLink;
	sprMagnet = sprVineClaw;
};

gfxEnemySand <- function () {
	gfxEnemyForest();
	sprIcicle = sprCoconut;
	sprOrangeBounce = sprCoconutBounce;
	sprWoodBox = sprWoodBoxSand;
	sprWoodChunks = sprWoodChunksSand;
};

tsSolid <- newSprite("res/gfx/solid.png", 16, 16);
