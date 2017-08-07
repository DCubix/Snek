class = import("res://br/twister/lowrez/game/middleclass.lua")

WormSegment = class("WormSegment")
function WormSegment:initialize()
	self.position = Point(0, 0)
	self.parent = nil
end

function WormSegment:update(dt, minDist, speed)
	local dist = self.parent.position:distanceTo(self.position)
	if dist > minDist then
		local dir = self.parent.position:directionTo(self.position)
		self.position.x = self.position.x + dir.x * speed * dt
		self.position.y = self.position.y + dir.y * speed * dt
	end
end

WormHead = class("WormHead", WormSegment)
function WormHead:initialize()
	WormSegment.initialize(self)
	self.body = {}
	self.angle = 0.0
	self.direction = 0
	self.dir = Point(0, 0)
	self.speed = 30.0
	self.prevPos = Point(0, 0)
	self.dead = false
	self.active = true
	self.blink = true
	self.activeTime = 0.0
	self.lives = 3
end

function WormHead:init(length)
	length = length ~= nil and length or 2
	self.body = {}
	local parentSeg = self
	for i = 1, length do
		self:grow()
	end
end

function WormHead:turnLeft(dt)
	self.angle = self.angle - 3 * dt
	if self.angle < 0 then
		self.angle = self.angle + math.pi*2
	end
end

function WormHead:turnRight(dt)
	self.angle = self.angle + 3 * dt
	if self.angle > math.pi*2 then
		self.angle = self.angle - math.pi*2
	end
end

function WormHead:grow()
	local parentSeg = self.body[#self.body]
	if parentSeg == nil then parentSeg = self end
	local part = WormSegment:new()
	part.position.x = parentSeg.position.x
	part.position.y = parentSeg.position.y
	part.parent = parentSeg
	table.insert(self.body, part)
end

function WormHead:flash(time)
	self.activeTime = time
	self.active = false
end

function WormHead:damage()
	self:flash(5.0)
	self.lives = self.lives - 1
	Globals.getProperty("hurtSound"):play()
	if self.lives <= 0 then
		self.lives = 0
		self.dead = true
		return true
	end
	return false
end

function WormHead:collided(item)
	return Collisions.rect(item.position.x-4, item.position.y-4, 8, 8, self.position.x-4, self.position.y-4, 8, 8)
end

function WormHead:collidedAll(item)
	if self:collided(item) then return true
	else
		for i, v in pairs(self.body) do
			if Collisions.rect(item.position.x-4, item.position.y-4, 8, 8, v.position.x-4, v.position.y-4, 8, 8) then
				return true
			end
		end
	end
	return false
end

function WormHead:hitWorm(worm)
	for i = 1, #worm.body do
		local b = worm.body[i]
		if Collisions.rect(b.position.x-2, b.position.y-2, 4, 4, self.position.x-2, self.position.y-2, 4, 4) then
			return true
		end
	end
	return false
end

function WormHead:update(dt, cols)
	local deg = (self.angle + math.pi/2) * 180 / math.pi
	if deg > 360 then
		deg = deg - 360
	end
	
	self.dir.x = math.floor(math.cos(self.angle) * 10) / 10
	self.dir.y = math.floor(math.sin(self.angle) * 10) / 10
	self.dir = self.dir:normalized()
	
	self.position.x = self.position.x + self.dir.x * self.speed * dt
	self.position.y = self.position.y + self.dir.y * self.speed * dt
	
	-- Check collision against "walls"
	if cols ~= nil then
		local col = false
		for i = 1, #cols do
			local rect = cols[i]
			col = Collisions.rect(self.position.x-2, self.position.y-2, 4, 4, rect.x, rect.y, rect.width, rect.height)
			if col then
				break
			end
		end
			
		if col then
			self.position.x = self.prevPos.x
			self.position.y = self.prevPos.y
		end
		self.prevPos.x = self.position.x
		self.prevPos.y = self.position.y
	end
	--
	
	self.direction = math.floor(deg / 45)

	for i = 1, #self.body do
		local b = self.body[i]
		b:update(dt, 4, self.speed)
	end
	
	if self.activeTime > 0.0 then
		self.activeTime = self.activeTime - dt
		self.blink = not self.blink
	else
		self.active = true
		self.blink = true
	end
end

function WormHead:render(r, wormAnim, sprite, sprite2)
	local w = 4
	local h = 4

	if self.blink then
		-- Draw snek body
		wormAnim:setFrame(8)
		for i = #self.body, 1, -1 do
			local b = self.body[i]	
			r:drawAnimation(sprite, wormAnim, b.position.x-w, b.position.y-h, nil)
		end
		
		-- Draw snek head
		wormAnim:setFrame(self.direction)
		r:drawAnimation(sprite, wormAnim, self.position.x-w, self.position.y-h, nil)
	else
		if sprite2 ~= nil then
			-- Draw snek body
			wormAnim:setFrame(8)
			for i = #self.body, 1, -1 do
				local b = self.body[i]	
				r:drawAnimation(sprite2, wormAnim, b.position.x-w, b.position.y-h, nil)
			end
			
			-- Draw snek head
			wormAnim:setFrame(self.direction)
			r:drawAnimation(sprite2, wormAnim, self.position.x-w, self.position.y-h, nil)
		end
	end
end

