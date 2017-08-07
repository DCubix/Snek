function startup:on_preload()
	local res = "res://br/twister/lowrez/game/res/"

	Globals.setProperty("font", {
		Bitmap(res.."font.png"),
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,;:!?[]+-*/\\=_\"'#$&%()"
	})
	Globals.setProperty("numbersFont", {
		Bitmap(res.."numbers.png"),
		"0123456789:+-.'ABCDEFGHIJKLMNOPQRSTUVWXYZ][|"
	})
	Globals.setProperty("tileSet", Bitmap(res.."tiles.png"))
	Globals.setProperty("wormSprite", Bitmap(res.."worm.png"))
	Globals.setProperty("wormSkelSprite", Bitmap(res.."wormSkel.png"))
	Globals.setProperty("badWormSprite", Bitmap(res.."badWorm.png"))
	Globals.setProperty("poweredWormSprite", Bitmap(res.."poweredWorm.png"))
	Globals.setProperty("burntWormSprite", Bitmap(res.."burntWorm.png"))
	Globals.setProperty("explosionSprite", Bitmap(res.."explosion.png"))
	
	Globals.setProperty("appleSprite", Bitmap(res.."apple.png"))
	Globals.setProperty("pearSprite", Bitmap(res.."pear.png"))
	Globals.setProperty("cherrySprite", Bitmap(res.."cherry.png"))
	Globals.setProperty("healthSprite", Bitmap(res.."health.png"))
	Globals.setProperty("presentSprite", Bitmap(res.."present.png"))
	Globals.setProperty("batterySprite", Bitmap(res.."battery.png"))
	Globals.setProperty("bombSprite", Bitmap(res.."bomb.png"))
	
	Globals.setProperty("appleSpriteRot", Bitmap(res.."appleRot.png"))
	Globals.setProperty("pearSpriteRot", Bitmap(res.."pearRot.png"))
	Globals.setProperty("cherrySpriteRot", Bitmap(res.."cherryRot.png"))
	
	Globals.setProperty("titleSprite", Bitmap(res.."title.png"))
	
	Globals.setProperty("upDown", Bitmap(res.."upDown.png"))
	
	Globals.setProperty("selectSound", Audio.loadSound(res.."select.wav"))
	Globals.setProperty("pickupSound", Audio.loadSound(res.."pickup.wav"))
	Globals.setProperty("oneUpSound", Audio.loadSound(res.."oneUp.wav"))
	Globals.setProperty("hurtSound", Audio.loadSound(res.."hurt.wav"))
	Globals.setProperty("gameOverSound", Audio.loadSound(res.."gameOver.wav"))
	Globals.setProperty("shockSound", Audio.loadSound(res.."shock.wav"))
	Globals.setProperty("explodeSound", Audio.loadSound(res.."explode.wav"))
	
	Globals.setProperty("menuShown", false)
	
	Engine.getDisplay():setIcon(res.."icon.png")
	
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