/*======*\
| ASSETS |
\*======*/

//Variables beging with "def" are default backups of sprites so they can be reset

//Main sprites
::sprFont <- newSprite("res/gfx/font.png", 6, 8, 0, 0, 0, 0)
::font <- newFont(sprFont, 0, 0, true, 0)
::sprFontC <- newSprite("res/gfx/font-cyan.png", 6, 8, 0, 0, 0, 0)
::fontC <- newFont(sprFontC, 0, 0, true, 0)
::sprFont2 <- newSprite("res/gfx/font2.png", 12, 14, 0, 0, 0, 0)
::font2 <- newFont(sprFont2, 33, 0, true, -4)
::sprFont2G <- newSprite("res/gfx/font2-gray.png", 12, 14, 0, 0, 0, 0)
::font2G <- newFont(sprFont2G, 33, 0, true, -4)
::sprFont2I <- newSprite("res/gfx/font2-ice.png", 12, 14, 0, 0, 0, 0)
::font2I <- newFont(sprFont2I, 33, 0, true, -4)
::sprFont2A <- newSprite("res/gfx/font-achieve.png", 12, 14, 0, 0, 0, 0)
::font2A <- newFont(sprFont2A, 33, 0, true, -4)
::sprDebug <- newSprite("res/gfx/debugkeys.png", 8, 8, 0, 0, 0, 0)
::sprTitle <- newSprite("res/gfx/title.png", 220, 55, 0, 0, 110, 0)



::sprTux <- newSprite("res/gfx/tux.png", 32, 32, 0, 0, 16, 19)
::defTux <- sprTux
::sprTuxFire <- newSprite("res/gfx/tuxfire.png", 32, 32, 0, 0, 16, 19)
::defTuxFire <- sprTuxFire
::sprTuxIce <- newSprite("res/gfx/tuxice.png", 32, 32, 0, 0, 16, 19)
::defTuxIce <- sprTuxIce
::sprTuxAir <- newSprite("res/gfx/tuxair.png", 32, 32, 0, 0, 16, 19)
::defTuxAir <- sprTuxAir
::sprTuxEarth <- newSprite("res/gfx/tuxearth.png", 32, 32, 0, 0, 16, 19)
::defTuxEarth <- sprTuxEarth
::sprTuxOverworld <- newSprite("res/gfx/tuxO.png", 14, 17, 0, 0, 7, 14)
::defTuxOverworld <- sprTuxOverworld
::sprTuxDoll <- newSprite("res/gfx/tuxdoll.png", 16, 16, 0, 0, 8, 8)
::defTuxDoll <- sprTuxDoll
::sprTuxNPC <- newSprite("res/gfx/tux-npc.png", 32, 32, 0, 0, 16, 32)



::sprPenny <- newSprite("res/gfx/penny.png", 32, 32, 0, 0, 16, 19)
::defPenny <- sprPenny
::sprPennyFire <- newSprite("res/gfx/pennyfire.png", 32, 32, 0, 0, 16, 19)
::defPennyFire <- sprPennyFire
::sprPennyIce <- newSprite("res/gfx/pennyice.png", 32, 32, 0, 0, 16, 19)
::defPennyIce <- sprPennyIce
::sprPennyAir <- newSprite("res/gfx/pennyair.png", 32, 32, 0, 0, 16, 19)
::defPennyAir <- sprPennyAir
::sprPennyOverworld <- newSprite("res/gfx/pennyO.png", 14, 17, 0, 0, 7, 14)
::defPennyOverworld <- sprPennyOverworld
::sprPennyDoll <- newSprite("res/gfx/pennydoll.png", 16, 16, 0, 0, 8, 8)
::defPennyDoll <- sprPennyDoll



::sprKonqi <- newSprite("res/gfx/konqi.png", 32, 32, 0, 0, 16, 19)
::defKonqi <- sprKonqi
::sprKonqiFire <- newSprite("res/gfx/konqifire.png", 32, 32, 0, 0, 16, 19)
::defKonqiFire <- sprKonqiFire
::sprKonqiIce <- newSprite("res/gfx/konqiice.png", 32, 32, 0, 0, 16, 19)
::defKonqiIce <- sprKonqiIce
::sprKonqiAir <- newSprite("res/gfx/konqiair.png", 32, 32, 0, 0, 16, 19)
::defKonqiAir <- sprKonqiAir
::sprKonqiEarth <- newSprite("res/gfx/konqiearth.png", 32, 32, 0, 0, 16, 19)
::defKonqiEarth <- sprKonqiEarth
::sprKonqiOverworld <- newSprite("res/gfx/konqiO.png", 14, 20, 0, 0, 7, 17)
::defKonqiOverworld <- sprKonqiOverworld
::sprKonqiDoll <- newSprite("res/gfx/konqidoll.png", 16, 16, 0, 0, 8, 8)
::defKonqiDoll <- sprKonqiDoll
::sprKonqiNPC <- newSprite("res/gfx/konqi-npc.png", 32, 32, 0, 0, 16, 32)


::sprKatie <- newSprite("res/gfx/katie.png", 32, 32, 0, 0, 16, 19)
::defKatie <- sprKatie
::sprKatieFire <- newSprite("res/gfx/katiefire.png", 32, 32, 0, 0, 16, 19)
::defKatieFire <- sprKatieFire
::sprKatieOverworld <- newSprite("res/gfx/katieO.png", 14, 20, 0, 0, 7, 17)
::defKatieOverworld <- sprKatieOverworld
::sprKatieDoll <- newSprite("res/gfx/katiedoll.png", 16, 16, 0, 0, 8, 8)
::defKatieDoll <- sprKatieDoll
::sprKatieNPC <- newSprite("res/gfx/katie-npc.png", 32, 32, 0, 0, 16, 32)


::sprMidi <- newSprite("res/gfx/midi.png", 32, 32, 0, 0, 16, 19)
::defMidi <- sprMidi
::sprMidiOverworld <- newSprite("res/gfx/midiO.png", 14, 20, 0, 0, 7, 17)
::defMidiOverworld <- sprMidiOverworld
::sprMidiDoll <- newSprite("res/gfx/mididoll.png", 16, 16, 0, 0, 8, 8)
::defMidiDoll <- sprMidiDoll
::sprMidiNPC <- newSprite("res/gfx/midi-npc.png", 32, 32, 0, 0, 16, 32)


//GUI
::sprCursor <- newSprite("res/gfx/cursor.png", 10, 13, 0, 0, 0, 0)
::sprHealth <- newSprite("res/gfx/health.png",16, 16, 0, 0, 0, 0)
::defHealth <- sprHealth
::sprEnergy <- newSprite("res/gfx/energy.png", 16, 16, 0, 0, 0, 0)
::defEnergy <- sprEnergy
::sprLevels <- newSprite("res/gfx/levelicons.png", 16, 16, 0, 0, 8, 8)
::defLevels <- sprLevels
::sprSubItem <- newSprite("res/gfx/itemcard.png", 20, 20, 0, 0, 10, 10)
::defSubItem <- sprSubItem
::sprWarning <- newSprite("res/gfx/warning.png", 280, 72, 0, 0, 140, 36)
::defWarning <- sprWarning
::sprTalk <- newSprite("res/gfx/talk.png", 16, 16, 0, 0, 8, 16)
::defTalk <- sprTalk
::sprBossHealth <- newSprite("res/gfx/boss-health.png", 10, 16, 0, 0, 0, 0)
::defBossHealth <- sprBossHealth
::sprSkull <- newSprite("res/gfx/skull.png", 16, 16, 0, 0, 0, 0)
::sprIris <- newSprite("res/gfx/iris.png", 240, 240, 0, 0, 120, 120)
::sprAchiFrame <- newSprite("res/gfx/achievement-frame.png", 12, 24, 0, 0, 0, 0)
::sprCharCursor <- newSprite("res/gfx/char-cursor.png", 24, 24, 0, 0, 12, 12)


//Blocks
::sprVoid <- newSprite("res/gfx/void.png", 16, 32, 0, 0, 0, 0)
::defVoid <- sprVoid
::sprBoxIce <- newSprite("res/gfx/icebox.png", 16, 16, 0, 0, 0, 0)
::defBoxIce <- sprBoxIce
::sprBoxItem <- newSprite("res/gfx/itembox.png", 16, 16, 0, 0, 0, 0)
::defBoxItem <- sprBoxItem
::sprBoxRed <- newSprite("res/gfx/redbox.png", 16, 16, 0, 0, 0, 0)
::defBoxRed <- sprBoxRed
::sprBoxEmpty <- newSprite("res/gfx/emptybox.png", 16, 16, 0, 0, 0, 0)
::defBoxEmpty <- sprBoxEmpty
::sprSpring <- newSprite("res/gfx/spring.png", 16, 16, 0, 0, 8, 8)
::defSpring <- sprSpring
::sprSpringD <- newSprite("res/gfx/springd.png", 16, 16, 0, 0, 8, 8)
::defSpringD <- sprSpringD
::sprWoodBox <- newSprite("res/gfx/woodbox.png", 16, 16, 0, 0, 0, 0)
::defWoodBox <- sprWoodBox
::sprBoxShop <- newSprite("res/gfx/shopblock.png", 16, 16, 0, 0, 0, 0)
::defBoxShop <- sprBoxShop
::sprIceBlock <- newSprite("res/gfx/iceblock.png", 16, 16, 0, 0, 0, 0)
::defIceBlock <- sprIceBlock
::sprFishBlock <- newSprite("res/gfx/herringblock.png", 16, 16, 0, 0, 0, 0)
::defFishBlock <- sprFishBlock
::sprWoodChunks <- newSprite("res/gfx/woodchunks.png", 8, 8, 0, 0, 4, 4)
::defWoodChunks <- sprWoodChunks
::sprBoxInfo <- newSprite("res/gfx/infobox.png", 16, 16, 0, 0, 0, 0)
::defBoxInfo <- sprBoxInfo
::sprKelvinScarf <- newSprite("res/gfx/kelvinscarf.png", 16, 16, 0, 0, 0, 0)
::defKelvinScarf <- sprKelvinScarf
::sprBoxBounce <- newSprite("res/gfx/bouncebox.png", 16, 16, 0, 0, 0, 0)
::defBoxBounce <- sprBoxBounce
::sprCheckBell <- newSprite("res/gfx/bell.png", 16, 16, 0, 0, 8, 0)
::defCheckBell <- sprCheckBell
::sprTNT <- newSprite("res/gfx/tnt.png", 16, 16, 0, 0, 0, 0)
::defTNT <- sprTNT
::sprC4 <- newSprite("res/gfx/c4.png", 16, 16, 0, 0, 0, 0)
::defC4 <- sprC4
::sprColorBlock <- newSprite("res/gfx/switchblocks.png", 16, 16, 0, 0, 0, 0)
::defColorBlock <- sprColorBlock
::sprColorSwitch <- newSprite("res/gfx/colorswitches.png", 32, 32, 0, 0, 16, 16)
::defColorSwitch <- sprColorSwitch
::sprLockBlock <- newSprite("res/gfx/lock.png", 16, 16, 0, 0, 8, 8)
::defLockBlock <- sprLockBlock
::sprBossDoor <- newSprite("res/gfx/boss-door.png", 16, 32, 0, 0, 0, 0)
::defBossDoor <- sprBossDoor
::sprFireBlock <- newSprite("res/gfx/fireblock.png", 16, 16, 0, 0, 0, 0)
::defFireBlock <- sprFireBlock
::sprCrumbleRock <- newSprite("res/gfx/crumble-rock.png", 16, 16, 0, 0, 8, 8)
::defCrumbleRock <- sprCrumbleRock
::sprCrumbleIce <- newSprite("res/gfx/crumble-ice.png", 16, 16, 0, 0, 8, 8)
::defCrumbleIce <- sprCrumbleIce


//NPCs
::sprRadGuin <- newSprite("res/gfx/radguin.png", 22, 32, 0, 0, 16, 32)
::sprPennyNPC <- newSprite("res/gfx/penny-npc.png", 14, 24, 0, 0, 7, 24)
::sprXue <- newSprite("res/gfx/xue.png", 20, 23, 0, 0, 12, 23)
::sprPlasmaBreeze <- newSprite("res/gfx/plasmabreeze.png", 30, 32, 0, 0, 15, 32)
::sprRockyRaccoon <- newSprite("res/gfx/rockyraccoon.png", 23, 27, 0, 0, 15, 26)
::sprTinyFireGuin <- newSprite("res/gfx/tinyfireguin.png", 13, 23, 0, 0, 6, 23)
::sprPygame <- newSprite("res/gfx/pygame.png", 32, 38, 0, 0, 16, 38)
::sprGnu <- newSprite("res/gfx/gnu.png", 29, 45, 0, 0, 15, 45)
::sprSam <- newSprite("res/gfx/sam.png", 12, 32, 0, 0, 6, 32)
::sprTuckles <- newSprite("res/gfx/tuckles.png", 18, 34, 0, 0, 8, 34)
::sprGaruda <- newSprite("res/gfx/garuda.png", 35, 36, 0, 0, 17, 36)
::sprKelvinNPC <- newSprite("res/gfx/npc-kelvin.png", 32, 32, 0, 0, 16, 32)
::sprDuke <- newSprite("res/gfx/duke.png", 32, 32, 0, 0, 16, 32)
::sprPenguinNPC <- newSprite("res/gfx/penguin-npc.png", 14, 23, 0, 0, 7, 23)
::sprBearistaNPC <- newSprite("res/gfx/bearista.png", 21, 37, 0, 0, 10, 37)
::sprTixNPC <- newSprite("res/gfx/tix.png", 10, 16, 0, 0, 5, 16)
::sprPenguinBuilderNPC <- newSprite("res/gfx/penguin-builder-npc.png", 14, 27, 0, 0, 7, 27)


//Enemies
::sprSnake <- newSprite("res/gfx/snake.png", 16, 32, 0, 0, 8, 0)
::defSnake <- sprSnake
::sprSealion <- newSprite("res/gfx/sealion.png", 16, 48, 0, 0, 8, 0)
::defSealion <- sprSealion
::sprDeathcap <- newSprite("res/gfx/deathcap.png", 16, 16, 0, 0, 8, 9)
::defDeathcap <- sprDeathcap
::sprGradcap <- newSprite("res/gfx/smartcap.png", 16, 18, 0, 0, 8, 11)
::defGradcap <- sprGradcap
::sprOrangeBounce <- newSprite("res/gfx/orange.png", 16, 16, 0, 0, 8, 8)
::defOrangeBounce <- sprOrangeBounce
::sprCannon <- newSprite("res/gfx/cannon.png", 16, 16, 0, 0, 8, 8)
::defCannon <- sprCannon
::sprCannonBob <- newSprite("res/gfx/cannonbob.png", 16, 16, 0, 0, 8, 8)
::defCannonBob <- sprCannonBob
::sprOuchin <- newSprite("res/gfx/ouchin.png", 16, 16, 0, 0, 8, 8)
::defOuchin <- sprOuchin
::sprCarlBoom <- newSprite("res/gfx/carlboom.png", 16, 16, 0, 0, 8, 8)
::defCarlBoom <- sprCarlBoom
::sprBlueFish <- newSprite("res/gfx/fishblue.png", 28, 20, 0, 0, 16, 12)
::defBlueFish <- sprBlueFish
::sprRedFish <- newSprite("res/gfx/fishred.png", 28, 20, 0, 0, 16, 12)
::defRedFish <- sprRedFish
::sprGreenFish <- newSprite("res/gfx/fishgreen.png", 28, 20, 0, 0, 16, 12)
::defGreenFish <- sprGreenFish
::sprDeadFish <- newSprite("res/gfx/deadfish.png", 23, 14, 0, 0, 14, 7)
::defDeadFish <- sprDeadFish
::sprJellyFish <- newSprite("res/gfx/jellyfish.png", 16, 16, 0, 0, 8, 8)
::defJellyFish <- sprJellyFish
::sprClamor <- newSprite("res/gfx/clamor.png", 16, 16, 0, 0, 8, 8)
::defClamor <- sprClamor
::sprIcicle <- newSprite("res/gfx/icicle.png", 10, 16, 0, 0, 5, 4)
::defIcicle <- sprIcicle
::sprFlyAmanita <- newSprite("res/gfx/flyamanita.png", 20, 20, 0, 0, 10, 10)
::defFlyAmanita <- sprFlyAmanita
::sprJumpy <- newSprite("res/gfx/bouncecap.png", 16, 20, 0, 0, 8, 8)
::defJumpy <- sprJumpy
::sprDarkStar <- newSprite("res/gfx/darknyan.png", 16, 16, 0, 0, 8, 8)
::defDarkStar <- sprDarkStar
::spr1down <- newSprite("res/gfx/1down.png", 16, 16, 0, 0, 8, 8)
::def1down <- spr1down
::sprHaywire <- newSprite("res/gfx/haywire.png", 16, 16, 0, 0, 8, 8)
::defHaywire <- sprHaywire
::sprSawblade <- newSprite("res/gfx/sawblade.png", 16, 16, 0, 0, 8, 8)
::defSawblade <- sprSawblade
::sprLivewire <- newSprite("res/gfx/Livewire.png", 16, 16, 0, 0, 8, 8)
::defLivewire <- sprLivewire
::sprBlazeborn <- newSprite("res/gfx/Blazeborn.png", 16, 16, 0, 0, 8, 9)
::defBlazeborn <- sprBlazeborn
::sprWildcap <- newSprite("res/gfx/wildcap.png", 16, 16, 0, 0, 8, 9)
::defWildcap <- sprWildcap
::sprOwlBrown <- newSprite("res/gfx/owl-brown.png", 32, 32, 0, 0, 16, 16)
::defOwlBrown <- sprOwlBrown
::sprMrIceguy <- newSprite("res/gfx/mr-iceblock.png", 20, 19, 0, 0, 10, 11)
::defMrIceguy <- sprMrIceguy
::sprSnailRed <- newSprite("res/gfx/snail-red.png", 16, 16, 0, 0, 8, 8)
::defSnailRed <- sprSnailRed
::sprSnailBlue <- newSprite("res/gfx/snail-blue.png", 16, 16, 0, 0, 8, 8)
::defSnailBlue <- sprSnailBlue
::sprMrSnowball <- newSprite("res/gfx/mr-snowball.png", 16, 16, 0, 0, 8, 9)
::defMrSnowball <- sprMrSnowball
::sprMsSnowball <- newSprite("res/gfx/ms-snowball.png", 16, 16, 0, 0, 8, 9)
::defMsSnowball <- sprMsSnowball
::sprSnowBounce <- newSprite("res/gfx/bouncysnow.png", 16, 16, 0, 0, 8, 8)
::defSnowBounce <- sprSnowBounce
::sprSnowJumpy <- newSprite("res/gfx/og-jumpy.png", 16, 25, 0, 0, 8, 11)
::defSnowJumpy <- sprSnowJumpy
::sprSpikeCap <- newSprite("res/gfx/spikecap.png", 16, 17, 0, 0, 8, 11)
::defSpikeCap <- sprSpikeCap
::sprSnowSpike <- newSprite("res/gfx/snowspike.png", 20, 20, 0, 0, 10, 13)
::defSnowSpike <- sprSnowSpike
::sprSnowFly <- newSprite("res/gfx/snowfly.png", 15, 19, 0, 0, 7, 8)
::defSnowFly <- sprSnowFly
::sprTallCap <- newSprite("res/gfx/tallcap.png", 16, 32, 0, 0, 8, 24)
::defTallCap <- sprTallCap
::sprSmartTallCap <- newSprite("res/gfx/smarttallcap.png", 16, 34, 0, 0, 8, 26)
::defSmartTallCap <- sprSmartTallCap
::sprSnowman <- newSprite("res/gfx/snowman.png", 20, 31, 0, 0, 10, 22)
::defSnowman <- sprSnowman
::sprSnowoman <- newSprite("res/gfx/snowoman.png", 20, 31, 0, 0, 10, 22)
::defSnowoman <- sprSnowoman
::sprSnowCaptain <- newSprite("res/gfx/captain-snow.png", 16, 16, 0, 0, 8, 9)
::defSnowCaptain <- sprSnowCaptain
::sprCaptainMorel <- newSprite("res/gfx/captain-morel.png", 16, 19, 0, 0, 8, 12)
::defCaptainMorel <- sprCaptainMorel
::sprBearyl <- newSprite("res/gfx/bearyl.png", 32, 32, 0, 0, 16, 16)
::defBearyl <- sprBearyl
::sprSirCrusher <- newSprite("res/gfx/icecrusher.png", 32, 32, 0, 0, 16, 16)
::defSirCrusher <- sprSirCrusher
::sprDukeCrusher <- newSprite("res/gfx/duke-crusher.png", 32, 32, 0, 0, 16, 16)
::defDukeCrusher <- sprDukeCrusher
::sprWheelerHamster <- newSprite("res/gfx/hamsterwheel.png", 24, 24, 0, 0, 12, 14)
::defWheelerHamster <- sprWheelerHamster
::sprWheelerBlade <- newSprite("res/gfx/wheelblade.png", 24, 24, 0, 0, 12, 14)
::defWheelerBlade <- sprWheelerBlade
::sprShiveriken <- newSprite("res/gfx/shiveriken.png", 24, 24, 0, 0, 12, 14)
::defShiveriken <- sprShiveriken


//Bosses
::sprNolok <- newSprite("res/gfx/nolok.png", 64, 64, 0, 0, 32, 40)
::defNolok <- sprNolok
::sprYeti <- newSprite("res/gfx/yeti.png", 64, 64, 0, 0, 36, 40)
::defYeti <- sprYeti


//Items
::sprMuffin <- newSprite("res/gfx/muffin.png", 16, 16, 0, 0, 8, 8)
::defMuffin <- sprMuffin
::sprStar <- newSprite("res/gfx/starnyan.png", 16, 16, 0, 0, 8, 8)
::defStar <- sprStar
::sprCoin <- newSprite("res/gfx/coin.png", 16, 16, 0, 0, 8, 8)
::defCoin <- sprCoin
::sprCoin5 <- newSprite("res/gfx/5coin.png", 16, 16, 0, 0, 8, 8)
::defCoin5 <- sprCoin5
::sprCoin10 <- newSprite("res/gfx/10coin.png", 16, 16, 0, 0, 8, 8)
::defCoin10 <- sprCoin10
::sprHerring <- newSprite("res/gfx/herring.png", 16, 16, 0, 0, 8, 8)
::defHerring <- sprHerring
::sprFlowerFire <- newSprite("res/gfx/fireflower.png", 16, 16, 0, 0, 8, 8)
::defFlowerFire <- sprFlowerFire
::sprFlowerIce <- newSprite("res/gfx/iceflower.png", 16, 16, 0, 0, 8, 8)
::defFlowerIce <- sprFlowerIce
::sprAirFeather <- newSprite("res/gfx/airfeather.png", 16, 16, 0, 0, 8, 8)
::defAirFeather <- sprAirFeather
::sprFlyRefresh <- newSprite("res/gfx/featherspin.png", 16, 16, 0, 0, 8, 8)
::defFlyRefresh <- sprFlyRefresh
::sprEarthShell <- newSprite("res/gfx/earthshell.png", 16, 16, 0, 0, 8, 8)
::defEarthShell <- sprEarthShell
::sprBerry <- newSprite("res/gfx/strawberry.png", 10, 12, 0, 0, 5, 6)
::defBerry <- sprBerry
::sprKeyCopper <- newSprite("res/gfx/key-copper.png", 16, 16, 0, 0, 8, 8)
::defKeyCopper <- sprKeyCopper
::sprKeySilver <- newSprite("res/gfx/key-silver.png", 16, 16, 0, 0, 8, 8)
::defKeySilver <- sprKeySilver
::sprKeyGold <- newSprite("res/gfx/key-gold.png", 16, 16, 0, 0, 8, 8)
::defKeyGold <- sprKeyGold
::sprKeyMythril <- newSprite("res/gfx/key-mythril.png", 16, 16, 0, 0, 8, 8)
::defKeyMythril <- sprKeyMythril
::sprSpecialBall <- newSprite("res/gfx/specialbubble.png", 16, 16, 0, 0, 8, 8)
::defSpecialBall <- sprSpecialBall
::sprCoffee <- newSprite("res/gfx/coffee-cup.png", 14, 20, 0, 0, 7, 12)
::defCoffee <- sprCoffee


//Effects
::sprSpark <- newSprite("res/gfx/spark.png", 12, 16, 0, 0, 6, 8)
::defSpark <- sprSpark
::sprGlimmer <- newSprite("res/gfx/glimmer.png", 10, 10, 0, 0, 5, 5)
::defGlimmer <- sprGlimmer
::sprFireball <- newSprite("res/gfx/fireball.png", 8, 8, 0, 0, 4, 4)
::defFireball <- sprFireball
::sprIceball <- newSprite("res/gfx/iceball.png", 6, 6, 0, 0, 3, 3)
::defIceball <- sprIceball
::sprPoof <- newSprite("res/gfx/poof.png", 16, 16, 0, 0, 8, 8)
::defPoof <- sprPoof
::sprFlame <- newSprite("res/gfx/flame.png", 14, 20, 0, 0, 7, 12)
::defFlame <- sprFlame
::sprFlameTiny <- newSprite("res/gfx/tinyflame.png", 8, 8, 0, 0, 4, 4)
::defFlameTiny <- sprFlameTiny
::sprIceTrapSmall <- newSprite("res/gfx/icetrapsmall.png", 16, 16, 0, 0, 8, 8)
::defIceTrapSmall <- sprIceTrapSmall
::sprIceTrapLarge <- newSprite("res/gfx/icetraplarge.png", 32, 32, 0, 0, 16, 16)
::defIceTrapLarge <- sprIceTrapLarge
::sprIceTrapTall <- newSprite("res/gfx/icetraptall.png", 16, 32, 0, 0, 8, 16)
::defIceTrapTall <- sprIceTrapTall
::sprIceChunks <- newSprite("res/gfx/icechunk.png", 8, 8, 0, 0, 4, 4)
::defIceChunks <- sprIceChunks
::sprTinyWind <- newSprite("res/gfx/tinywind.png", 16, 16, 0, 0, 8, 8)
::defTinyWind <- sprTinyWind
::sprTFflash <- newSprite("res/gfx/tfFlash.png", 32, 40, 0, 0, 16, 20)
::defTFflash <- sprTFflash
::sprExplodeF <- newSprite("res/gfx/explodeF.png", 24, 24, 0, 0, 12, 12)
::defExplodeF <- sprExplodeF
::sprExplodeI <- newSprite("res/gfx/explodeI.png", 30, 30, 0, 0, 15, 15)
::defExplodeI <- sprExplodeI
::sprExplodeN <- newSprite("res/gfx/explodeN.png", 30, 30, 0, 0, 15, 15)
::defExplodeN <- sprExplodeN
::sprExplodeT <- newSprite("res/gfx/explodeT.png", 32, 32, 0, 0, 16, 16)
::defExplodeT <- sprExplodeT
::sprWaterSurface <- newSprite("res/gfx/watersurface.png", 16, 4, 0, 0, 0, 0)
::defWaterSurface <- sprWaterSurface
::sprHeal <- newSprite("res/gfx/heal.png", 7, 7, 0, 0, 3, 3)
::defHeal <- sprHeal
::sprSplash <- newSprite("res/gfx/splash.png", 21, 17, 0, 0, 12, 16)
::defSplash <- sprSplash
::sprBigSpark <- newSprite("res/gfx/hit-yellow.png", 55, 68, 0, 0, 32, 40)
::defBigSpark <- sprBigSpark
::sprSteelBall <- newSprite("res/gfx/steelball.png", 8, 8, 0, 0, 4, 4)
::defSteelBall <- sprSteelBall


//Platforms
::sprPlatformWood <- newSprite("res/gfx/moplat-wood.png", 16, 8, 0, 0, 8, 4)


//Portals
::sprPortalGray <- newSprite("res/gfx/portal-gray.png", 32, 48, 0, 0, 16, 24)
::sprPortalBlue <- newSprite("res/gfx/portal-blue.png", 32, 48, 0, 0, 16, 24)
::sprPortalRed <- newSprite("res/gfx/portal-red.png", 32, 48, 0, 0, 16, 24)
::sprPortalGreen <- newSprite("res/gfx/portal-green.png", 32, 48, 0, 0, 16, 24)
::sprPortalYellow <- newSprite("res/gfx/portal-yellow.png", 32, 48, 0, 0, 16, 24)
::sprPortalPunkle <- newSprite("res/gfx/portal-punkle.png", 32, 48, 0, 0, 16, 24)


//Backgrounds
::bgPause <- 0
::bgCaveHoles <- newSprite("res/gfx/rockgapsBG.png", 400, 392, 0, 0, 0, 0)
::bgIridia <- newSprite("res/gfx/iridia.png", 100, 56, 0, 0, 0, 0)
::bgAurora <- newSprite("res/gfx/aurora.png", 720, 240, 0, 0, 0, 0)
::bgAuroraNight <- newSprite("res/gfx/aurora-night.png", 720, 240, 0, 0, 0, 0)
::bgRiverCity <- newSprite("res/gfx/rivercity.png", 380, 240, 0, 0, 0, 0)
::bgOcean <- newSprite("res/gfx/ocean.png", 480, 8, 0, 0, 0, 0)
::bgOceanNight <- newSprite("res/gfx/ocean-night.png", 480, 8, 0, 0, 0, 0)
::bgForest0 <- newSprite("res/gfx/forest0.png", 128, 180, 0, 0, 0, 0)
::bgForest1 <- newSprite("res/gfx/forest1.png", 128, 240, 0, 0, 0, 0)
::bgWoodedMountain <- newSprite("res/gfx/woodedmountain.png", 720, 240, 0, 0, 0, 0)
::bgStarSky <- newSprite("res/gfx/starysky.png", 240, 240, 0, 0, 0, 0)
::bgUnderwater <- newSprite("res/gfx/underwaterbg.png", 424, 240, 0, 0, 0, 0)
::bgCastle <- newSprite("res/gfx/castlebg.png", 320, 240, 0, 0, 0, 0)
::bgSnowPlain <- newSprite("res/gfx/bgSnowPlain.png", 720, 240, 0, 0, 0, 0)
::bgSnowNight <- newSprite("res/gfx/bgSnowNight.png", 800, 240, 0, 0, 0, 0)
::bgIceForest <- newSprite("res/gfx/iceforest.png", 640, 240, 0, 0, 0, 0)
::bgIceForest0 <- newSprite("res/gfx/iceforest0.png", 800, 320, 0, 0, 0, 0)
::bgIceForest1 <- newSprite("res/gfx/iceforest1.png", 640, 256, 0, 0, 0, 0)
::bgIceForest2 <- newSprite("res/gfx/iceforest2.png", 480, 192, 0, 0, 0, 0)
::bgFortMagma <- newSprite("res/gfx/fortmagmasky.png", 960, 240, 0, 0, 0, 0)
::bgCharSel <- newSprite("res/gfx/charsel.png", 424, 240, 0, 0, 212, 0)
::bgPennyton0 <- newSprite("res/gfx/pennyton-bg-0.png", 480, 112, 0, 0, 0, 0)
::bgPennyton1 <- newSprite("res/gfx/pennyton-bg-1.png", 480, 74, 0, 0, 0, 0)


//Weather
::weRain <- newSprite("res/gfx/rainfall.png", 64, 64, 0, 0, 0, 0)
::weSnow <- newSprite("res/gfx/snowfall.png", 64, 64, 0, 0, 0, 0)

//Lights
::sprLightBasic <- newSprite("res/gfx/light-player-basic.png", 48, 48, 0, 0, 24, 24)
spriteSetBlendMode(sprLightBasic, bm_add)
::sprLightFire <- newSprite("res/gfx/light-fire.png", 128, 128, 0, 0, 64, 64)
spriteSetBlendMode(sprLightFire, bm_add)
::sprLightIce <- newSprite("res/gfx/light-ice.png", 128, 128, 0, 0, 64, 64)
spriteSetBlendMode(sprLightIce, bm_add)
::sprLightGradient <- newSprite("res/gfx/light-gradient.png", 128, 128, 0, 0, 64, 64)
spriteSetBlendMode(sprLightGradient, bm_add)


//Sounds
::sndFireball <- loadSound("res/snd/fireball.ogg")
::sndJump <- loadSound("res/snd/jump.ogg")
::sndHurt <- loadSound("res/snd/hurt.ogg")
::sndKick <- loadSound("res/snd/kick.ogg")
::sndSquish <- loadSound("res/snd/squish.ogg")
::sndCoin <- loadSound("res/snd/coin.ogg")
::sndSlide <- loadSound("res/snd/slide.ogg")
::sndFlame <- loadSound("res/snd/flame.ogg")
::sndSpring <- loadSound("res/snd/trampoline.ogg")
::sndDie <- loadSound("res/snd/die.ogg")
::sndWin <- loadSound("res/snd/win.ogg")
::sndBump <- loadSound("res/snd/bump.ogg")
::sndHeal <- loadSound("res/snd/heal.ogg")
::sndFlap <- loadSound("res/snd/flap.ogg")
::sndExplodeF <- loadSound("res/snd/explodeF.ogg")
::sndFizz <- loadSound("res/snd/fizz.ogg")
::sndBell <- loadSound("res/snd/bell.ogg")
::sndIcicle <- loadSound("res/snd/icicle.ogg")
::sndIceBreak <- loadSound("res/snd/icebreak.ogg")
::snd1up <- loadSound("res/snd/1up.ogg")
::sndWallkick <- loadSound("res/snd/wallkick.ogg")
::sndWarning <- loadSound("res/snd/warning.ogg")
::sndGulp <- loadSound("res/snd/gulp.ogg")
::sndFish <- loadSound("res/snd/fish.ogg")
::sndGrowl <- loadSound("res/snd/growl.ogg")
::sndMenuMove <- loadSound("res/snd/menu-move.ogg")
::sndMenuSelect <- loadSound("res/snd/menu-select.ogg")
::sndBossHit <- loadSound("res/snd/boss-hit.ogg")
::sndCrush <- loadSound("res/snd/crush.ogg")
::sndIceblock <- loadSound("res/snd/iceblock_bump.ogg")
::sndAchievement <- loadSound("res/snd/achievement.ogg")


//Music
::gvMusic <- 0 //Stores the current music so that not too many large songs are loaded at once
::gvMusicName <- ""
::gvLastSong <- ""

::musTheme <- "res/mus/supertuxtheme.ogg"
::musDisko <- "res/mus/chipdisko.ogg"
::musCave <- "res/mus/cave.ogg"
::musOverworld <- "res/mus/overworld.ogg"
::musCity <- "res/mus/village-mixed.ogg"
::musCastle <- "res/mus/castle.ogg"
::musRace <- "res/mus/blackdiamond.ogg"
::musDeluge <- "res/mus/deluge.ogg"
::musSnowTown <- "res/mus/winter_wonderland.ogg"
::musAirship <- "res/mus/airship.ogg"
::musPuzzle <- "res/mus/puzzle.ogg"
::musIceland <- "res/mus/iceland.ogg"
::musretro2<- "res/mus/retro-2.ogg"
::musBoss <- "res/mus/boss.ogg"
::musBossIntro <- "res/mus/boss-intro.ogg"
::musGrassOverworld <- "res/mus/peaceful-village.ogg"
::musBerrylife <- "res/mus/berrylife.ogg"

//Saved separately so that it can be reused frequently
::musInvincible <- loadMusic("res/mus/invincible.ogg")

::songPlay <- function(song) {
	if(song == 0) {
		songStop()
		return
	}
	gvMusicName = song
	if(gvMusicName == gvLastSong) return

	deleteMusic(gvMusic)
	gvMusic = loadMusic(song)
	playMusic(gvMusic, -1)

	gvLastSong = song
}

::songStop <- function() {
	stopMusic()
	gvMusicName = 0
	gvLastSong = 0
}

::gfxReset <- function() {
	sprTux = defTux
	sprTuxFire = defTuxFire
	sprTuxIce = defTuxIce
	sprTuxAir = defTuxAir
	sprTuxEarth = defTuxEarth
	sprTuxOverworld = defTuxOverworld
	sprTuxDoll = defTuxDoll

	sprKonqi = defKonqi
	sprKonqiFire = defKonqiFire
	sprKonqiIce = defKonqiIce
	sprKonqiAir = defKonqiAir
	sprKonqiEarth = defKonqiEarth
	sprKonqiOverworld = defKonqiOverworld
	sprKonqiDoll = defKonqiDoll

	sprMidi = defMidi
	sprMidiOverworld = defMidiOverworld
	sprMidiDoll = defMidiDoll

	sprHealth = defHealth
	sprEnergy = defEnergy
	sprLevels = defLevels
	sprSubItem = defSubItem
	sprWarning = defWarning

	sprVoid = defVoid
	sprBoxIce = defBoxIce
	sprBoxItem = defBoxItem
	sprBoxRed = defBoxRed
	sprBoxEmpty = defBoxEmpty
	sprSpring = defSpring
	sprSpringD = defSpringD
	sprWoodBox = defWoodBox
	sprIceBlock = defIceBlock
	sprFishBlock = defFishBlock
	sprWoodChunks = defWoodChunks
	sprBoxInfo = defBoxInfo
	sprKelvinScarf = defKelvinScarf
	sprBoxBounce = defBoxBounce
	sprCheckBell = defCheckBell
	sprTNT = defTNT
	sprC4 = defC4
	sprColorBlock = defColorBlock
	sprColorSwitch = defColorSwitch
	sprLockBlock = defLockBlock
	sprBossDoor = defBossDoor
	sprCrumbleRock = defCrumbleRock

	sprSnake = defSnake
	sprDeathcap = defDeathcap
	sprGradcap = defGradcap
	sprOrangeBounce = defOrangeBounce
	sprCannon = defCannon
	sprOuchin = defOuchin
	sprCarlBoom = defCarlBoom
	sprBlueFish = defBlueFish
	sprRedFish = defRedFish
	sprGreenFish = defGreenFish
	sprDeadFish = defDeadFish
	sprJellyFish = defJellyFish
	sprClamor = defClamor
	sprIcicle = defIcicle
	sprFlyAmanita = defFlyAmanita
	sprJumpy = defJumpy
	sprDarkStar = defDarkStar
	sprHaywire = defHaywire
	sprSawblade = defSawblade
	sprLivewire = defLivewire
	sprBlazeborn = defBlazeborn
	sprSpikeCap = defSpikeCap
	sprTallCap = defTallCap
	sprSmartTallCap = defSmartTallCap
	sprCaptainMorel = defCaptainMorel
	sprSnowCaptain = defSnowCaptain
	sprBearyl = defBearyl
	sprWheelerHamster = defWheelerHamster

	sprNolok = defNolok
	sprYeti = defYeti

	sprMuffin = defMuffin
	sprStar = defStar
	sprCoin = defCoin
	sprCoin5 = defCoin5
	sprCoin10 = defCoin10
	sprHerring = defHerring
	sprFlowerFire = defFlowerFire
	sprFlowerIce = defFlowerIce
	sprAirFeather = defAirFeather
	sprEarthShell = defEarthShell
	sprFlyRefresh = defFlyRefresh
	sprBerry = defBerry
	sprKeyCopper = defKeyCopper
	sprKeySilver = defKeySilver
	sprKeyGold = defKeyGold
	sprKeyMythril = defKeyMythril
	sprSpecialBall = defSpecialBall

	sprSpark = defSpark
	sprGlimmer = defGlimmer
	sprFireball = defFireball
	sprIceball = defIceball
	sprPoof = defPoof
	sprFlame = defFlame
	sprFlameTiny = defFlameTiny
	sprIceTrapLarge = defIceTrapLarge
	sprIceTrapSmall = defIceTrapSmall
	sprIceTrapTall = defIceTrapTall
	sprIceChunks = defIceChunks
	sprTinyWind = defTinyWind
	sprTFflash = defTFflash
	sprExplodeF = defExplodeF
	sprExplodeI = defExplodeI
	sprExplodeN = defExplodeN
	sprExplodeT = defExplodeT
	sprWaterSurface = defWaterSurface
	sprHeal = defHeal
	sprSplash = defSplash
}

::gfxEnemySnow <- function() {
	sprDeathcap = sprMrSnowball
	sprGradcap = sprMsSnowball
	sprOrangeBounce = sprSnowBounce
	sprJumpy = sprSnowJumpy
	sprSpikeCap = sprSnowSpike
	sprFlyAmanita = sprSnowFly
	sprTallCap = sprSnowman
	sprSmartTallCap = sprSnowoman
	sprCrumbleRock = sprCrumbleIce
	sprCaptainMorel = sprSnowCaptain
	sprBearyl = sprSirCrusher
	sprWheelerHamster = sprShiveriken
	sprSnake = sprSealion
}

::tsSolid <- newSprite("res/gfx/solid.png", 16, 16, 0, 0, 0, 0)