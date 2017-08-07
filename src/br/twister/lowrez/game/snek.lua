local class = import("res://br/twister/lowrez/game/middleclass.lua")

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

function WormHead:collided(item)
	return Collisions.rect(item.x-4, item.y-4, 8, 8, self.position.x-4, self.position.y-4, 8, 8)
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
end

function WormHead:render(r, wormAnim, wormSprite)
	local w = 4
	local h = 4

	-- Draw snek body
	wormAnim:setFrame(8)
	for i = #self.body, 1, -1 do
		local b = self.body[i]	
		r:drawAnimation(wormSprite, wormAnim, b.position.x-w, b.position.y-h, nil)
	end
	
	-- Draw snek head
	wormAnim:setFrame(self.direction)
	r:drawAnimation(wormSprite, wormAnim, self.position.x-w, self.position.y-h, nil)
end

