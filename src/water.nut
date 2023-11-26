::Water <- class extends Actor {
	shape = 0
	substance = "water"

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr != null && _arr != "")
			substance = _arr
	}

	function run() {
		if(gvPlayer && hitTest(shape, gvPlayer.shape))
			handleHits(gvPlayer)

		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape))
			handleHits(gvPlayer2)
	}

	function handleHits(target) {
		switch(substance) {
			case "lava":
				target.x = (target.x + target.xprev) / 2.0
				target.y = (target.y + target.yprev) / 2.0
				if("stats" in target && !target.invincible && !target.blinking)
					target.stats.health -= 0.2 * target.damageMult.fire
				if(getFrames() % 8 == 0) {
					newActor(FlameTiny, target.x + target.shape.w - randInt(target.shape.w * 2), target.y + target.shape.h - randInt(target.shape.h * 2))
					popSound(sndFlame)
				}
				break
			case "acid":
				if("stats" in target && !target.invincible && !target.blinking)
					target.stats.health -= 0.1 * target.damageMult.toxic
				if(getFrames() % 8 == 0) {
					local c = actor[newActor(AcidBubble, target.x + target.shape.w - randInt(target.shape.w * 2), target.y + target.shape.h - randInt(target.shape.h * 2))]
					c.vspeed = -0.2
					popSound(sndBlurp)
				}
				break
			case "swamp":
			case "honey":
				if("stats" in target && target.stats.weapon == "water")
					break
				target.x = (target.x + target.xprev) / 2.0
				target.y = (target.y + target.yprev) / 2.0
				break
		}
	}

	function draw() {
		switch(substance) {
			case "acid":
				for(local i = 0; i < shape.w / 8; i++) {
					for(local j = 0; j < shape.h / 8; j++) {
						drawSprite((j == 0 ? sprAcidSurface : sprAcid), getFrames() / 16, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy + (j * 16), 0, 0, 1, 1, 0.5)
					}
				}
				break
			case "lava":
				for(local i = 0; i < shape.w / 8; i++) {
					for(local j = 0; j < shape.h / 8; j++) {
						drawSprite((j == 0 ? sprLavaSurface : sprLava), (j == 0 ? (getFrames() / 16) + (i * i) : getFrames() / 16), x - shape.w - floor(camx) + (i * 16), y - shape.h - camy + (j * 16), 0, 0, 1, 1, 0.5)
					}
				}
				for(local i = 0; i < shape.w / 8; i++) {
					drawLight(sprLightFire, i + getFrames() / 8, x - shape.w - floor(camx) + (i * 16) + 8, y - shape.h - camy - 4, (getFrames() / 4) + (i * 15), 0, 0.75 + (sin((getFrames() / 30.0) + (i * 15)) * 0.25), 0.75 + (sin((getFrames() / 30.0) + (i * 15)) * 0.25))
				}
				break
			case "honey":
				setDrawColor(0xf8f80060)
				drawRect(x - shape.w - floor(camx), y - shape.h - camy, (shape.w * 2) - 1, (shape.h * 2) + 2, true)
				for(local i = 0; i < shape.w / 8; i++) {
					drawSpriteEx(sprHoneySurface, (getFrames() / 32) + i, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy - 4, 0, 0, 1, 1, 0.5)
				}
				break
			case "swamp":
				setDrawColor(0x68301860)
				drawRect(x - shape.w - floor(camx), y - shape.h - camy, (shape.w * 2) - 1, (shape.h * 2) + 2, true)
				for(local i = 0; i < shape.w / 8; i++) {
					drawSpriteEx(sprSwampSurface, (getFrames() / 32) + i, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy - 4, 0, 0, 1, 1, 0.5)
				}
				break
			default:
				setDrawColor(0x2020a060)
				drawRect(x - shape.w - floor(camx), y - shape.h - camy, (shape.w * 2) - 1, (shape.h * 2) + 2, true)
				for(local i = 0; i < shape.w / 8; i++) {
					drawSpriteEx(sprWaterSurface, (getFrames() / 16) + i, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy - 4, 0, 0, 1, 1, 0.5)
				}
				break
		}
	}

	function _typeof() { return "Water" }
}