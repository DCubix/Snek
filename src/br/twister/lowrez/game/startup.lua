function startup:on_preload()
	Globals.setProperty("font", {
		Bitmap("res://br/twister/lowrez/game/font.png"),
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,;:!?[]+-*/\\=_\"'#$&%()"
	})
	Globals.setProperty("numbersFont", {
		Bitmap("res://br/twister/lowrez/game/numbers.png"),
		"0123456789:+-.'ABCDEFGHIJKLMNOPQRSTUVWXYZ][|"
	})
	Globals.setProperty("tileSet", Bitmap("res://br/twister/lowrez/game/tiles.png"))
	Globals.setProperty("wormSprite", Bitmap("res://br/twister/lowrez/game/worm.png"))
	Globals.setProperty("wormSkelSprite", Bitmap("res://br/twister/lowrez/game/wormSkel.png"))
	Globals.setProperty("badWormSprite", Bitmap("res://br/twister/lowrez/game/badWorm.png"))
	Globals.setProperty("poweredWormSprite", Bitmap("res://br/twister/lowrez/game/poweredWorm.png"))
	Globals.setProperty("burntWormSprite", Bitmap("res://br/twister/lowrez/game/burntWorm.png"))
	Globals.setProperty("explosionSprite", Bitmap("res://br/twister/lowrez/game/explosion.png"))
	
	Globals.setProperty("appleSprite", Bitmap("res://br/twister/lowrez/game/apple.png"))
	Globals.setProperty("pearSprite", Bitmap("res://br/twister/lowrez/game/pear.png"))
	Globals.setProperty("cherrySprite", Bitmap("res://br/twister/lowrez/game/cherry.png"))
	Globals.setProperty("healthSprite", Bitmap("res://br/twister/lowrez/game/health.png"))
	Globals.setProperty("presentSprite", Bitmap("res://br/twister/lowrez/game/present.png"))
	Globals.setProperty("batterySprite", Bitmap("res://br/twister/lowrez/game/battery.png"))
	Globals.setProperty("bombSprite", Bitmap("res://br/twister/lowrez/game/bomb.png"))
	
	Globals.setProperty("appleSpriteRot", Bitmap("res://br/twister/lowrez/game/appleRot.png"))
	Globals.setProperty("pearSpriteRot", Bitmap("res://br/twister/lowrez/game/pearRot.png"))
	Globals.setProperty("cherrySpriteRot", Bitmap("res://br/twister/lowrez/game/cherryRot.png"))
	
	Globals.setProperty("titleSprite", Bitmap("res://br/twister/lowrez/game/title.png"))
	
	Globals.setProperty("upDown", Bitmap("res://br/twister/lowrez/game/upDown.png"))
	
	Globals.setProperty("selectSound", Audio.loadSound("res://br/twister/lowrez/game/select.wav"))
	Globals.setProperty("pickupSound", Audio.loadSound("res://br/twister/lowrez/game/pickup.wav"))
	Globals.setProperty("oneUpSound", Audio.loadSound("res://br/twister/lowrez/game/oneUp.wav"))
	Globals.setProperty("hurtSound", Audio.loadSound("res://br/twister/lowrez/game/hurt.wav"))
	Globals.setProperty("gameOverSound", Audio.loadSound("res://br/twister/lowrez/game/gameOver.wav"))
	Globals.setProperty("shockSound", Audio.loadSound("res://br/twister/lowrez/game/shock.wav"))
	Globals.setProperty("explodeSound", Audio.loadSound("res://br/twister/lowrez/game/explode.wav"))
	
	Globals.setProperty("menuShown", false)
	
	Engine.getDisplay():setIcon("res://br/twister/lowrez/game/icon.png")
	
	Engine.setState("res://br/twister/lowrez/game/menu.lua")
end

function startup:on_unload()
	Globals.getProperty("font")[1]:unload()
	Globals.getProperty("numbersFont")[1]:unload()
	Globals.getProperty("tileSet"):unload()
	Globals.getProperty("wormSprite"):unload()
	Globals.getProperty("wormSkelSprite"):unload()
	Globals.getProperty("badWormSprite"):unload()
	Globals.getProperty("poweredWormSprite"):unload()
	Globals.getProperty("burntWormSprite"):unload()
	Globals.getProperty("explosionSprite"):unload()
	Globals.getProperty("batterySprite"):unload()
	Globals.getProperty("bombSprite"):unload()
	Globals.getProperty("appleSprite"):unload()
	Globals.getProperty("pearSprite"):unload()
	Globals.getProperty("cherrySprite"):unload()
	Globals.getProperty("healthSprite"):unload()
	Globals.getProperty("presentSprite"):unload()
	Globals.getProperty("appleSpriteRot"):unload()
	Globals.getProperty("cherrySpriteRot"):unload()
	Globals.getProperty("titleSprite"):unload()
	Globals.getProperty("upDown"):unload()
	Globals.getProperty("selectSound"):unload()
	Globals.getProperty("pickupSound"):unload()
	Globals.getProperty("oneUpSound"):unload()
	Globals.getProperty("hurtSound"):unload()
	Globals.getProperty("gameOverSound"):unload()
	Globals.getProperty("shockSound"):unload()
	Globals.getProperty("explodeSound"):unload()
end