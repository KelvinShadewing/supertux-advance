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
				if("stats" in target && !target.invincible)
					target.stats.health -= 0.2 * target.damageMult.fire
				break
			case "acid":
				if("stats" in target && !target.invincible)
					target.stats.health -= 0.1 * target.damageMult.toxic
				break
		}
	}

	function draw() {
		switch(substance) {
			case "acid":
				setDrawColor(0xc28684880)
				drawRect(x - shape.w - floor(camx), y - shape.h - camy + 12, (shape.w * 2) - 1, (shape.h * 2) - 8, true)
				for(local i = 0; i < shape.w / 8; i++) {
					drawSpriteEx(sprAcidSurface, (getFrames() / 16) + (i * i), x - shape.w - floor(camx) + (i * 16), y - shape.h - camy - 4, 0, 0, 1, 1, 0.5)
				}
				break
			case "lava":
				setDrawColor(0xc80000b0)
				drawRect(x - shape.w - floor(camx), y - shape.h - camy + 4, (shape.w * 2) - 1, (shape.h * 2), true)
				for(local i = 0; i < shape.w / 8; i++) {
					drawSpriteEx(sprLavaSurface, (getFrames() / 16) + (i * i), x - shape.w - floor(camx) + (i * 16), y - shape.h - camy - 4, 0, 0, 1, 1, 0.7)
					drawLight(sprLightFire, 0, x - shape.w - floor(camx) + (i * 16) + 8, y - shape.h - camy - 4, (getFrames() / 4) + (i * 15), 0, 0.75 + (sin((getFrames() / 30.0) + (i * 15)) * 0.25), 0.75 + (sin((getFrames() / 30.0) + (i * 15)) * 0.25))
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