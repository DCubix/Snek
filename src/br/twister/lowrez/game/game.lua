import("res://br/twister/lowrez/game/snek.lua")
import("res://br/twister/lowrez/game/enemy.lua")
import("res://br/twister/lowrez/game/item.lua")
import("res://br/twister/lowrez/game/util.lua")
import("res://br/twister/lowrez/game/menumaker.lua")

local class = import("res://br/twister/lowrez/game/middleclass.lua")

game.wormSprite = nil
game.badWormSprite = nil
game.wormAnim = nil
game.bombAnim = Animation(8, 1, 0.02)
game.itemSprites = {}
game.pauseMenu = nil

game.score = 0
game.cameraPos = Point(0, 0)
game.cameraTarget = Point()

game.playerName = "SNEK"
game.maxPlayerNameLen = 7
game.textBox = {
	cursorTime = 0.0,
	cursorBlink = true,
	cursorPos = 5
}

game.map = {}
game.items = {} -- { x, y, type, spr }
game.badWorms = {} -- { worm, anim, target }

game.worm = nil

game.state = 0 -- 0 = Standby; 1 = Game; 2 = Game Over; 3 = Pause

function game:addBadWorm(width, height)
	local rx = math.random(2, width-2) * 8
	local ry = math.random(2, height-2) * 8
	
	local worm = Enemy:new()
	worm.position.x = rx
	worm.position.y = ry
	worm.prevPos.x = rx
	worm.prevPos.y = ry
	worm.burnt = false
	worm.deadTime = 5.0
	worm:init()
	
	for i = 1, #self.badWorms do
		if worm:hitWorm(self.worm) then
			rx = math.random(2, width-2) * 8
			ry = math.random(2, height-2) * 8
			worm.position.x = rx
			worm.position.y = ry
			worm.prevPos.x = rx
			worm.prevPos.y = ry
			worm:init()
		end
	end
	table.insert(self.badWorms, worm)
end

function game:addFruits(minFruits, maxFruits, width, height)
	minFruits = minFruits ~= nil and minFruits or 2
	maxFruits = maxFruits ~= nil and maxFruits or 10

	local fruitCount = math.random(minFruits, maxFruits)
	for i = 0, fruitCount do
		local rx = (math.random(2, width-2) * 8)-4
		local ry = (math.random(2, height-2) * 8)-4
		local rt = math.random(0, 5)
		if rt == ITEM_HEALTH or rt == ITEM_CANDY or rt == ITEM_BATTERY then
			for i = 0, 99 do rt = math.random(0, 5) end
		end
		
		local ani = nil
		if not (rt == ITEM_HEALTH or rt == ITEM_CANDY) then
			if rt == ITEM_BATTERY then
				ani = Animation(10, 1, 0.02)
			else
				ani = Animation(8, 1, 0.05)
			end
		end
		
		local rotten = false
		if table.contains({ ITEM_APPLE, ITEM_PEAR, ITEM_CHERRY }, rt) then
			rotten = math.random(0, 8) == 8 and true or false
		end
		
		local sprName = ""
		if rt == ITEM_APPLE then sprName = "appleSprite"
		elseif rt == ITEM_PEAR then sprName = "pearSprite"
		elseif rt == ITEM_CHERRY then sprName = "cherrySprite"
		elseif rt == ITEM_BATTERY then sprName = "batterySprite"
		elseif rt == ITEM_CANDY then sprName = "presentSprite"
		elseif rt == ITEM_HEALTH then sprName = "healthSprite"
		end
		
		if rotten then
			sprName = sprName.."Rot"
		end
		table.insert(self.items, Item:new(rx, ry, rt, Globals.getProperty(sprName), ani, rotten, -1))
	end
end

function drawTileLayer(r, layer)
	for j = 0, layer.height do
		for i = 0, layer.width do
			local tileIndex = i + j * layer.width
			local tile = layer.data[tileIndex+1]
			if tile ~= nil then
				if tile-1 >= 0 then
					r:drawTile(Globals.getProperty("tileSet"), tile-1, i, j, 4, 6)
				end
			end
		end
	end
end

function game:incrementScore(itemType)
	local scoreInc = 0
	if itemType == ITEM_APPLE then
		scoreInc = 1
	elseif itemType == ITEM_PEAR then
		scoreInc = 5
	elseif itemType == ITEM_CHERRY then
		scoreInc = 10
	elseif itemType == ITEM_HEALTH then
		scoreInc = 0
	elseif itemType == ITEM_CANDY then
		local bombRand = math.random(0, 9)
		scoreInc = 20
		if bombRand == 9 then
			scoreInc = 0
			self.worm.hasBomb = true
		end
	end
	return scoreInc
end

function game:on_start()
	self.wormSprite = Globals.getProperty("wormSprite")
	self.badWormSprite = Globals.getProperty("badWormSprite")
	self.wormAnim = Animation(10, 1, 0.0)
	self.wormAnim:setAutomatic(false)
	
	self.pauseMenu = Menu:new({ "RESUME", "QUIT" })

	self.map = import("res://br/twister/lowrez/game/level0.lua")
	local ly = self.map.layers[1]

	self.worm = WormHead:new()
	self.worm.position.x = ly.width * 4
	self.worm.position.y = ly.height * 4
	self.worm.prevPos.x = ly.width * 4
	self.worm.prevPos.y = ly.height * 4
	self.worm.hasBomb = false
	self.worm.powered = false
	self.worm:init()
	
	self.cameraTarget = self.worm.position
	
--	self:addBadWorm(ly.width, ly.height)
--	self:addBadWorm(ly.width, ly.height)
--	self:addBadWorm(ly.width, ly.height)
--	self:addBadWorm(ly.width, ly.height)
	
	self:addFruits(30, 30, ly.width, ly.height)
	
	self.state = 1
end

function game:on_update(input, dt)
	if self.state == 1 then -- Play state
		local layer0 = self.map.layers[1]
		local layer3 = self.map.layers[4] -- Colliders
		
		if #self.items < 30 then
			self:addFruits(1, 1, layer0.width, layer0.height)
		end
		
		if #self.badWorms < 4 then
			self:addBadWorm(layer0.width, layer0.height)
		end
		
		-- XXX Update items
		for k, v in pairs(self.items) do
			if v:update(dt, k, self.items) then break end
		end
		
		-- XXX Player
		if input:keyDown(Keys.KeyLeft) then
			self.worm:turnLeft(dt)
		elseif input:keyDown(Keys.KeyRight) then
			self.worm:turnRight(dt)
		end

		-- XXX Check collisions against "fruits"
		for i, item in pairs(self.items) do
			if self.worm:collided(item) and not table.contains({ ITEM_BOMB, ITEM_EXPLOSION }, item.type) then
				local coll = false
				if self.worm.active then
					if item.rotten then
						self.worm:damage()
						table.remove(self.items, i)
						Globals.getProperty("hurtSound"):play()
					else				
						coll = true
					end
				else
					if not item.rot then
						coll = true
					end
				end
				if coll then
					self.score = self.score + self:incrementScore(item.type) * 10
					if item.type == ITEM_HEALTH then
						Globals.getProperty("oneUpSound"):play()
						self.worm.lives = self.worm.lives + 1
						if self.worm.lives >= 3 then self.worm.lives = 3 end
					elseif item.type == ITEM_BATTERY then
						Globals.getProperty("oneUpSound"):play()
						self.worm.powered = true
						self.worm:flash(5.0)
					else
						Globals.getProperty("pickupSound"):play()
						self.worm:grow()
					end
					table.remove(self.items, i)
				end
				break
			end
		end
		
		-- XXX Enemy update
		for k, v in pairs(self.badWorms) do
			if v.dispose then
				table.remove(self.badWorms, k)
				break
			else
				v:update(self, dt, layer3.objects, self.worm, self.items)
			end
		end

		self.worm:update(dt, layer3.objects)
		if self.worm.powered then
			if self.worm.activeTime <= 0.0 then
				self.worm.powered = false
			end
		end
		if self.worm.dead then
			Globals.getProperty("gameOverSound"):play()
			self.state = 2
		end
		
		-- XXX Camera
		self.cameraPos.x = lerp(self.cameraPos.x, self.cameraTarget.x, 0.15)
		self.cameraPos.y = lerp(self.cameraPos.y, self.cameraTarget.y, 0.15)
		
		-- Pausing
		if input:keyPressed(Keys.KeyP) then
			Globals.getProperty("selectSound"):play()
			self.state = 3
		elseif input:keyPressed(Keys.KeySpace) then
			if self.worm.hasBomb then
				local pos = self.worm.body[#self.worm.body].position
				table.insert(self.items, Bomb:new(pos.x, pos.y))
				self.worm.hasBomb = false
			end
		end
	elseif self.state == 2 then -- Game Over State
		self.textBox.cursorTime = self.textBox.cursorTime + dt
		if self.textBox.cursorTime >= 0.25 then
			self.textBox.cursorBlink = not self.textBox.cursorBlink
			self.textBox.cursorTime = 0.0
		end
		
		local chr = input:getTypedChar()
		if chr ~= 0 and #self.playerName < self.maxPlayerNameLen then
			local schr = string.upper(string.char(chr))
			if Globals.getProperty("numbersFont")[2]:find(schr) then
				self.playerName = self.playerName .. schr
				self.textBox.cursorPos = self.textBox.cursorPos + 1
			end
		end
		
		if input:keyPressed(Keys.KeyBackSpace) then
			if self.textBox.cursorPos > 1 then
				self.textBox.cursorPos = self.textBox.cursorPos - 1
				self.playerName = self.playerName:sub(1, self.textBox.cursorPos-1)
			end
		elseif input:keyPressed(Keys.KeyEnter) then
			-- XXX Save score
			if #self.playerName == 0 then
				self.playerName = "SNEK"
			end
			
			local f = io.open("scores.dat", "a")
			f:write(string.format("%s=%d\n", self.playerName, self.score))
			f:close()
			
			Engine.setState("res://br/twister/lowrez/game/menu.lua")
		end
	elseif self.state == 3 then -- Pause State
		if input:keyPressed(Keys.KeyUp) then
			self.pauseMenu:prevOption()
		elseif input:keyPressed(Keys.KeyDown) then
			self.pauseMenu:nextOption()
		elseif input:keyPressed(Keys.KeyEnter) then
			if self.pauseMenu.selected == 0 then
				self.state = 1
			else
				Engine.setState("res://br/twister/lowrez/game/menu.lua")
			end
		end
	end
end

function game:on_render(r)
	r:clear(RGB(168, 186, 68))
	
	if self.state == 1 or self.state == 2 or self.state == 3 then
		local layer0 = self.map.layers[1] -- Ground (dirt)
		local layer1 = self.map.layers[2] -- Grass
		local layer2 = self.map.layers[3] -- Fences
		
		-- XXX Camera positioning
		local cw = Engine.getScreenWidth()/2
		local ch = Engine.getScreenHeight()/2
		local cx = self.cameraPos.x - cw
		local cy = self.cameraPos.y - ch
		if cx <= 0 then
			cx = 0
		elseif cx + cw*2 >= (layer0.width * 8) then
			cx = (layer0.width * 8) - cw*2
		end
		if cy <= 0 then
			cy = 0
		elseif cy + ch*2 >= (layer0.height * 8) then
			cy = (layer0.height * 8) - ch*2
		end
		
		r:setDrawOffset(Point(cx, cy))
		
		-- XXX Draw map
		drawTileLayer(r, layer0)
		drawTileLayer(r, layer1)
	
		-- XXX Draw items
		for k, v in pairs(self.items) do
			v:render(r)
		end
		
		-- XXX Draw sneks
		for k, v in pairs(self.badWorms) do
			v:render(r)
		end
		
		if not self.worm.dead then
			if self.worm.powered then
				self.worm:render(r, self.wormAnim, Globals.getProperty("wormSprite"), Globals.getProperty("poweredWormSprite"))
			else
				self.worm:render(r, self.wormAnim, Globals.getProperty("wormSprite"))
			end
		else
			self.worm:render(r, self.wormAnim, Globals.getProperty("wormSkelSprite"))
		end
		
		-- XXX Draw the rest of the map
		drawTileLayer(r, layer2)
		
		if self.state == 1 then
			-- XXX Draw HUD
			r:clearRectFac(RGB(0, 0, 0), 0.8, 0, 0, 64, 9)
			
			local font = Globals.getProperty("numbersFont")
			r:drawText(font[1], string.format("%06d", self.score), font[2], 1, 2, 1)
			
			local hx = 56
			for i = 1, self.worm.lives do
				r:drawSpriteSimple(Globals.getProperty("healthSprite"), hx + cx, 1 + cy)
				hx = hx - 8
			end
			
			if self.worm.hasBomb then
				local spr = Globals.getProperty("bombSprite")
				local tmpdo = r:getDrawOffset():clone()
				r:setDrawOffset(Point(0, 0))
				r:drawSprite(spr, 0, 0, 10, 10, 1, 52, 10, 10)
				r:setDrawOffset(tmpdo)
			end
		elseif self.state == 3 then
			-- XXX Draw PAUSE
			local sfont = Globals.getProperty("font")
			local tw = r:getTextWidth(sfont[1], "PAUSED", sfont[2], 0)
			local fh = sfont[1]:getHeight()/2
			
			r:clearRectFac(RGB(0, 0, 0), 0.5, 0, 0, 64, 64)
			r:drawText(sfont[1], "PAUSED", sfont[2], 32 - tw/2, 33 - fh, 0, RGB(0, 0, 0))
			r:drawText(sfont[1], "PAUSED", sfont[2], 32 - tw/2, 32 - fh, 0)
			
			self.pauseMenu:render(r, 24, 36 + fh)
		elseif self.state == 2 then
			-- XXX Draw GAME OVER
			local sfont = Globals.getProperty("font")
			local tw = r:getTextWidth(sfont[1], "GAME", sfont[2], 0)
			local fh = sfont[1]:getHeight()/2
			
			r:clearRectFac(RGB(0, 0, 0), 0.6, 0, 0, 64, 64)
			local n = r:drawText(sfont[1], "GAME", sfont[2], 33 - tw/2, 26 - fh*2, 0, RGB(0, 0, 0))
					  r:drawText(sfont[1], "GAME", sfont[2], 33 - tw/2, 25 - fh*2, 0)
			
			tw = r:getTextWidth(sfont[1], "OVER", sfont[2], 0)
			r:drawText(sfont[1], "OVER", sfont[2], 32 - tw/2, n.y+2, 0, RGB(0, 0, 0))
			n = r:drawText(sfont[1], "OVER", sfont[2], 32 - tw/2, n.y+1, 0)
			
			local nfont = Globals.getProperty("numbersFont")
			
			-- XXX Input Field
			local name = string.lpad(string.upper(self.playerName), self.maxPlayerNameLen, '.')
			local pname = name
			if self.textBox.cursorBlink then
				if self.textBox.cursorPos > 1 then
					pname = name:sub(1, self.textBox.cursorPos-1) .. '|' .. name:sub(self.textBox.cursorPos+1)
				else
					pname = '|' .. name:sub(self.textBox.cursorPos+1)
				end
			end
			
			tw = r:getTextWidth(nfont[1], pname, nfont[2], 1)
			r:drawText(nfont[1], pname, nfont[2], 32 - tw/2, n.y+7, 1, RGB(0, 0, 0))
			r:drawText(nfont[1], pname, nfont[2], 32 - tw/2, n.y+6, 1, RGB(180, 180, 180))
			
			tw = r:getTextWidth(nfont[1], "[ENTER] BACK", nfont[2], 1)
			r:drawText(nfont[1], "[ENTER] BACK", nfont[2], 32 - tw/2, 59 - nfont[1]:getHeight(), 1, RGB(0, 0, 0))
			r:drawText(nfont[1], "[ENTER] BACK", nfont[2], 32 - tw/2, 58 - nfont[1]:getHeight(), 1)
		end
	end
end