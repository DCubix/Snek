test.img = nil
test.tiles = nil
test.sheet = nil
test.anim = nil
test.an = 0.0
test.pos = { 0, 0 }

function test:on_start()
	self.img = Bitmap("res://test/sprite.png")
	self.tiles = Bitmap("res://test/tiles.png")
	self.sheet = Bitmap("res://test/sheet.png")
	self.anim = Animation(4, 6, 0.15, { 0, 4, 8, 12 })
end

function test:on_update(input, dt)
	self.an = self.an + dt
--	self.pos[1] = math.cos(self.an) * 16 + 32
--	self.pos[2] = math.sin(self.an) * 16 + 32
	local mp = input:getMousePosition()
	self.pos[1] = mp.x
	self.pos[2] = mp.y
	if input:keyPressed(Keys.KeyEnter) then
		print("Enter Pressed!")
	end
end

function test:on_render(renderer)
	renderer:clearFac(RGB(0, 0, 90), 0.05)	
	
--	renderer:drawTile(self.tiles, 2, 1, 2, 4, 2)
--	renderer:drawTile(self.tiles, 0, 2, 2, 4, 2)
--	renderer:drawTile(self.tiles, 0, 3, 2, 4, 2)
--	renderer:drawTile(self.tiles, 0, 4, 2, 4, 2)
--	renderer:drawTile(self.tiles, 1, 5, 2, 4, 2)
--	
--	renderer:drawTile(self.tiles, 0, 1, 3, 4, 2)
--	renderer:drawTile(self.tiles, 0, 2, 3, 4, 2)
--	renderer:drawTile(self.tiles, 0, 3, 3, 4, 2)
--	renderer:drawTile(self.tiles, 0, 4, 3, 4, 2)
--	renderer:drawTile(self.tiles, 0, 5, 3, 4, 2)
--	
--	renderer:drawTile(self.tiles, 3, 1, 4, 4, 2)
--	renderer:drawTile(self.tiles, 0, 2, 4, 4, 2)
--	renderer:drawTile(self.tiles, 0, 3, 4, 4, 2)
--	renderer:drawTile(self.tiles, 0, 4, 4, 4, 2)
--	renderer:drawTile(self.tiles, 4, 5, 4, 4, 2)

	local w = self.img:getWidth()
	local h = self.img:getHeight()
		
	renderer:drawSpriteRect(self.img, self.pos[1] - w/2, self.pos[2] - h/2, w, h)
	renderer:drawAnimation(self.sheet, self.anim, 16, 24)
end

function test:on_end()
	self.img = nil
	self.tiles = nil
	self.sheet = nil
end