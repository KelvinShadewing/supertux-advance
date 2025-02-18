Water <- class extends Actor {
	shape = 0
	substance = "water"
	currentColor = 0x000000ff
	newColor = 0x000000ff

	constructor(_x, _y, _arr = null) {
		base.constructor(_x, _y)
		if(_arr != null && _arr != "")
			substance = _arr

		//Set substance color
		switch(substance) {
			case "acid":
				newColor = 0x28684860
				break
			case "lava":
				newColor = 0x28684860
				break
			case "swamp":
				newColor = 0x68301860
				break
			case "honey":
				newColor = 0xf8f80060
				break
			default:
				newColor = 0x2020a060
				break
		}
		currentColor = newColor
	}

	function run() {
		if(gvPlayer && hitTest(shape, gvPlayer.shape))
			handleHits(gvPlayer)

		if(gvPlayer2 && hitTest(shape, gvPlayer2.shape))
			handleHits(gvPlayer2)

		switch(substance) {
			case "acid":
				newColor = 0x28684860
				break
			case "lava":
				newColor = 0x28684860
				break
			case "swamp":
				newColor = 0x68301860
				break
			case "honey":
				newColor = 0xf8f80060
				break
			default:
				newColor = 0x2020a060
				break
		}

		//Update background color
		if(currentColor != newColor) {
				//Prevent floats
				currentColor = currentColor.tointeger()
				newColor = newColor.tointeger()

				local lr = (currentColor >> 24) & 0xFF
				local lg = (currentColor >> 16) & 0xFF
				local lb = (currentColor >> 8) & 0xFF
				local la = currentColor & 0xFF

				local tr = (newColor >> 24) & 0xFF
				local tg = (newColor >> 16) & 0xFF
				local tb = (newColor >> 8) & 0xFF
				local ta = newColor & 0xFF

				//Fade to color
				if(lr != tr) lr += (tr <=> lr) * 2
				if(abs(lr - tr) < 2) lr = tr
				if(lg != tg) lg += (tg <=> lg) * 2
				if(abs(lg - tg) < 2) lg = tg
				if(lb != tb) lb += (tb <=> lb) * 2
				if(abs(lb - tb) < 2) lb = tb
				if(la != ta) la += (ta <=> la) * 2
				if(abs(la - ta) < 2) la = ta

				currentColor = (ceil(lr) << 24) | (ceil(lg) << 16) | (ceil(lb) << 8) | la
			}
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
		setDrawColor(currentColor)
		drawRect(x - shape.w - floor(camx), y - shape.h - camy, (shape.w * 2) - 1, (shape.h * 2) + 2, true)

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
					for(local j = 0; j <= shape.h / 8; j++) {
						drawSprite((j == 0 ? sprLavaSurface : sprLava), (j == 0 ? (getFrames() / 16) + (i * i) : getFrames() / 16), x - shape.w - floor(camx) + (i * 16), y - shape.h - camy + ((j - 1) * 16), 0, 0, 1, 1, 0.5)
					}
				}
				for(local i = 0; i < shape.w / 8; i++) {
					drawLight(sprLightFire, i + getFrames() / 8, x - shape.w - floor(camx) + (i * 16) + 8, y - shape.h - camy, (getFrames() / 4) + (i * 15), 0, 0.75 + (sin((getFrames() / 30.0) + (i * 15)) * 0.25), 0.75 + (sin((getFrames() / 30.0) + (i * 15)) * 0.25))
				}
				break
			case "honey":
				for(local i = 0; i < shape.w / 8; i++) {
					drawSprite(sprHoneySurface, (getFrames() / 32) + i, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy, 0, 0, 1, 1, 0.5)
				}
				break
			case "swamp":
				for(local i = 0; i < shape.w / 8; i++) {
					drawSprite(sprSwampSurface, (getFrames() / 32) + i, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy, 0, 0, 1, 1, 0.5)
				}
				break
			default:
				for(local i = 0; i < shape.w / 8; i++) {
					drawSprite(sprWaterSurface, (getFrames() / 16) + i, x - shape.w - floor(camx) + (i * 16), y - shape.h - camy, 0, 0, 1, 1, 0.5)
				}
				break
		}
	}

	function _typeof() { return "Water" }
}