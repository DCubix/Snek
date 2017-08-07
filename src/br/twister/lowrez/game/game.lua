import("res://br/twister/lowrez/game/snek.lua")
import("res://br/twister/lowrez/game/menumaker.lua")

game.wormSprite = nil
game.badWormSprite = nil
game.wormAnim = nil
game.itemSprites = {}
game.pauseMenu = nil

game.blink = false
game.blinkTime = 0.0

game.score = 0
game.fruitsEaten = 0
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
game.items = {} -- { x, y, type, spr } where type = 0 -> apple, 1 -> pear, 2 -> cherry, 3 -> health -> 4 -> ?
game.badWorms = {} -- { worm, anim, target }

game.worm = nil

game.state = 0 -- 0 = Standby; 1 = Game; 2 = Game Over; 3 = Pause

function game:addBadWorm(width, height)
	local anim = Animation(10, 1, 0.0)
	anim:setAutomatic(false)
	
	local rx = math.random(2, width-2) * 8
	local ry = math.random(2, height-2) * 8
	
	local worm = WormHead:new()
	worm.position.x = rx
	worm.position.y = ry
	worm.prevPos.x = rx
	worm.prevPos.y = ry
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
	table.insert(self.badWorms, { worm=worm, anim=anim, target=nil })
end

function game:addFruits(minFruits, maxFruits, width, height)
	minFruits = minFruits ~= nil and minFruits or 2
	maxFruits = maxFruits ~= nil and maxFruits or 10

	local fruitCount = math.random(minFruits, maxFruits)
	for i = 0, fruitCount do
		local rx = (math.random(2, width-2) * 8)-4
		local ry = (math.random(2, height-2) * 8)-4
		local rt = math.random(0, 4)
		if rt == 3 or rt == 4 then
			for i = 0, 10 do rt = math.random(0, 4) end
		end
		
		local ani = nil
		if rt < 3 then
			ani = Animation(8, 1, 0.07)
		end
		
		local rotten = false
		if rt >= 0 and rt < 3 then
			rotten = math.random(0, 8) == 8 and true or false
		end
		local sprName = self.itemSprites[rt+1]
		if rotten then
			sprName = sprName.."Rot"
		end
		table.insert(self.items, { x=rx, y=ry, spr=Globals.getProperty(sprName), anim=ani, type=rt, rot=rotten })
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

function lerp(a, b, t)
	return (1.0 - t) * a + b * t
end

function game:incrementScore(itemType)
	local scoreInc = 0
	if itemType == 0 then -- Apple
		scoreInc = 1
	elseif itemType == 1 then -- Pear
		scoreInc = 5
	elseif itemType == 2 then -- Cherry
		scoreInc = 10
	elseif itemType== 3 then -- Health
		scoreInc = 0
	elseif itemType == 4 then -- ?
		scoreInc = self:incrementScore(math.random(0, 3))
	end
	return scoreInc
end

function game:on_start()
	self.wormSprite = Globals.getProperty("wormSprite")
	self.badWormSprite = Globals.getProperty("badWormSprite")
	self.wormAnim = Animation(10, 1, 0.0, nil)
	self.wormAnim:setAutomatic(false)
	
	self.pauseMenu = Menu:new({ "RESUME", "QUIT" })
	
	table.insert(self.itemSprites, "appleSprite")
	table.insert(self.itemSprites, "pearSprite")
	table.insert(self.itemSprites, "cherrySprite")
	table.insert(self.itemSprites, "healthSprite")
	table.insert(self.itemSprites, "presentSprite")

	self.map = import("res://br/twister/lowrez/game/level0.lua")
	local ly = self.map.layers[1]

	self.worm = WormHead:new()
	self.worm.position.x = ly.width * 4
	self.worm.position.y = ly.height * 4
	self.worm.prevPos.x = ly.width * 4
	self.worm.prevPos.y = ly.height * 4
	self.worm:init()
	
	self.cameraTarget = self.worm.position
	
	self:addBadWorm(ly.width, ly.height)
	self:addBadWorm(ly.width, ly.height)
	self:addBadWorm(ly.width, ly.height)
	self:addBadWorm(ly.width, ly.height)
	
	self:addFruits(30, 30, ly.width, ly.height)
	
	self.state = 1
end

function game:on_update(input, dt)
	if self.state == 1 then -- Play state
		local layer0 = self.map.layers[1]
		local layer3 = self.map.layers[4] -- Colliders
		
		if self.blinkTime > 0.0 then
			self.blink = not self.blink
			self.blinkTime = self.blinkTime - dt
		end
		
		if #self.items < 30 then
			self:addFruits(1, 1, layer0.width, layer0.height)
		end
		
		-- XXX Player
		if input:keyDown(Keys.KeyLeft) then
			self.worm:turnLeft(dt)
		elseif input:keyDown(Keys.KeyRight) then
			self.worm:turnRight(dt)
		end
		
		-- XXX Check collisions against "fruits"
		for i, item in pairs(self.items) do
			if self.worm:collided(item) then
				local coll = false
				if self.blinkTime <= 0.0 then
					if item.rot then
						Globals.getProperty("hurtSound"):play()
						self.worm.lives = self.worm.lives - 1
						self.blinkTime = 5
						table.remove(self.items, i)
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
					if item.type == 3 then
						Globals.getProperty("oneUpSound"):play()
						self.worm.lives = self.worm.lives + 1
						if self.worm.lives >= 3 then self.worm.lives = 3 end
					else
						Globals.getProperty("pickupSound"):play()
						self.worm:grow()
					end
					table.remove(self.items, i)
				end
				break
			end
		end
		
		-- XXX Enemy <-> player collision
		for k, v in pairs(self.badWorms) do
			if not v.worm.dead and self.worm:hitWorm(v.worm) and self.blinkTime <= 0.0 then
				Globals.getProperty("hurtSound"):play()
				self.worm.lives = self.worm.lives - 1
				self.blinkTime = 5
				break
			end
		end

		if self.worm.lives <= 0 then
			self.worm.dead = true
			self.state = 2
			self.worm.lives = 0
			Globals.getProperty("gameOverSound"):play()
		end
		
		self.worm:update(dt, layer3.objects)
		
		-- XXX Enemy AI
		for k, v in pairs(self.badWorms) do
			if v.worm.dead then goto continue end
			
			-- XXX Avoid player
			for idx, p in pairs(self.worm.body) do
				local dist = p.position:distanceTo(v.worm.position)
				if dist <= 10 then
					v.worm:turnRight(dt)
				end
			end
			
			if v.target == nil then -- XXX Pick a random target
				if #self.items > 1 then
					v.target = math.random(1, #self.items)
				elseif #self.items == 1 then
					v.target = 1
				else
					v.target = nil
				end
			else -- XXX Follow target until it hits it
				local item = self.items[v.target]
				if item == nil then
					v.target = nil
				else
					local dir = Point(item.x, item.y):sub(v.worm.position)
					local angle = v.worm.dir:cross(dir)
			
					if angle < 0 then
						v.worm:turnLeft(dt)
					else
						v.worm:turnRight(dt)
					end
					
					-- XXX Hits target
					for i, item in pairs(self.items) do
						if not v.worm:collided(item) then goto continue2 end
						v.worm:grow()
						table.remove(self.items, i)
						v.target = nil
						break
						::continue2::
					end
				end
			end
			v.worm:update(dt, layer3.objects)
			::continue::
		end
		
		-- XXX Camera
		self.cameraPos.x = lerp(self.cameraPos.x, self.cameraTarget.x, 0.15)
		self.cameraPos.y = lerp(self.cameraPos.y, self.cameraTarget.y, 0.15)
		
		-- Pausing
		if input:keyPressed(Keys.KeyP) then
			Globals.getProperty("selectSound"):play()
			self.state = 3
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
	
		-- XXX Draw Fruits and items
		for i = 1, #self.items do
			local fruit = self.items[i]
			if fruit == nil then goto continue end
			if fruit.anim ~= nil then
				local lf = fruit.anim:getLastFrame()
				local iw = lf.w * fruit.spr:getWidth()
				local ih = lf.h * fruit.spr:getHeight()
				r:drawAnimation(fruit.spr, fruit.anim, fruit.x-iw/2, fruit.y-ih/2)
			else
				local iw = fruit.spr:getWidth()
				local ih = fruit.spr:getHeight()
				r:drawSpriteSimple(fruit.spr, fruit.x-iw/2, fruit.y-ih/2)
			end
			::continue::
		end
		
		-- XXX Draw worms (sneks)
		local deadWormSprite = Globals.getProperty("wormSkelSprite")
		for k, v in pairs(self.badWorms) do
			local spr = not v.worm.dead and self.badWormSprite or deadWormSprite
			v.worm:render(r, v.anim, spr)
		end
		
		if not self.worm.dead then
			if self.blinkTime > 0.0 then
				if self.blink then
					self.worm:render(r, self.wormAnim, self.wormSprite)
				end
			else
				self.worm:render(r, self.wormAnim, self.wormSprite)
			end
		else
			self.worm:render(r, self.wormAnim, deadWormSprite)
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