import("res://br/twister/lowrez/game/snek.lua")
import("res://br/twister/lowrez/game/menumaker.lua")

menu.titleSprite = nil
menu.titleY = -50.0
menu.mainMenu = nil
menu.worm = nil
menu.wormAnim = nil
menu.wormSprite = nil
menu.tgt = Point(0, 0)

function menu:on_start()
	self.wormSprite = Globals.getProperty("wormSprite")
	self.wormAnim = Animation(10, 1, 0.0, nil)
	self.wormAnim:setAutomatic(false)
	
	self.titleSprite = Globals.getProperty("titleSprite")
	self.mainMenu = Menu:new({ "PLAY", "HI-SCORES", "EXIT" })
	
	self.worm = WormHead:new()
	self.worm.position.x = 32
	self.worm.position.y = 18
	self.worm.prevPos.x = 32
	self.worm.prevPos.y = 18
	self.worm:init(12)
	
	self.tgt.x = math.random(-32, 96)
	self.tgt.y = math.random(-32, 96)
end

function menu:on_update(input, dt)
	local h = self.titleSprite:getHeight()
	if not Globals.getProperty("menuShown") then
		self.titleY = self.titleY + 30.0 * dt
		if self.titleY >= 16 - h/2 then
			Globals.setProperty("menuShown", true)
		end
	else
		self.titleY = 16 - h/2
		
		if input:keyPressed(Keys.KeyUp) then
			self.mainMenu:prevOption()
		elseif input:keyPressed(Keys.KeyDown) then
			self.mainMenu:nextOption()
		elseif input:keyPressed(Keys.KeyEnter) then
			if self.mainMenu.selected == 0 then
				Engine.setState("res://br/twister/lowrez/game/game.lua")
			elseif self.mainMenu.selected == 1 then
				Engine.setState("res://br/twister/lowrez/game/scores.lua")
			else
				Engine.getDisplay():close()
			end
		end
		
		local dir = self.tgt:sub(self.worm.position)
		local angle = self.worm.dir:cross(dir)

		if angle < 0 then
			self.worm:turnLeft(dt)
		else
			self.worm:turnRight(dt)
		end
		
		if Collisions.rect(self.worm.position.x-2, self.worm.position.y-2, 4, 4, self.tgt.x-2, self.tgt.y-2, 4, 4) then
			self.tgt.x = math.random(-32, 96)
			self.tgt.y = math.random(-32, 96)
		end
		
		self.worm:update(dt, nil)
	end
end

function menu:on_render(r)
	r:setDrawOffset(Point(0, 0))
	r:clear(RGB(0, 0, 0))
	
	local w = self.titleSprite:getWidth()
	local h = self.titleSprite:getHeight()
	
	if Globals.getProperty("menuShown") then
		self.worm:render(r, self.wormAnim, self.wormSprite)
		
		self.mainMenu:render(r, 18, 33)
		
		local sfont = Globals.getProperty("numbersFont")
		local tw = r:getTextWidth(sfont[1], "BY: TWISTER", sfont[2], 0)
		r:drawText(sfont[1], "BY: TWISTER", sfont[2], 27 - tw/2, 54, 1, RGB(180, 180, 180))
	end
	r:drawSpriteSimple(self.titleSprite, 32 - w/2, self.titleY)
end