local class = import("res://br/twister/lowrez/game/middleclass.lua")
import("res://br/twister/lowrez/game/util.lua")

Item = class("Item")
function Item:initialize(x, y, type, sprite, anim, rotten, life)
	self.type = type
	self.position = Point(x, y)
	self.sprite = sprite
	self.anim = anim
	self.rotten = rotten == nil and false or rotten
	self.life = life == nil and -1 or life
end

function Item:update(dt, i, items)
	if self.life ~= -1 then
		if self.life > 0.0 then
			self.life = self.life - dt
		else
			table.remove(items, i)
			return true
		end
	end
	return false
end

function Item:render(r)
	if self.anim ~= nil then
		local lf = self.anim:getLastFrame()
		local iw = lf.w * self.sprite:getWidth()
		local ih = lf.h * self.sprite:getHeight()
		r:drawAnimation(self.sprite, self.anim, self.position.x-iw/2, self.position.y-ih/2)
	else
		local iw = self.sprite:getWidth()
		local ih = self.sprite:getHeight()
		r:drawSpriteSimple(self.sprite, self.position.x-iw/2, self.position.y-ih/2)
	end
end

Explosion = class("Explosion", Item)
function Explosion:initialize(x, y)
	Item.initialize(self, x, y, ITEM_EXPLOSION, Globals.getProperty("explosionSprite"), Animation(12, 1, 0.08), false, 1.0)
end

Bomb = class("Bomb", Item)
function Bomb:initialize(x, y)
	Item.initialize(self, x, y, ITEM_BOMB, Globals.getProperty("bombSprite"), Animation(8, 1, 0.04), false, 5.0)
end

function Bomb:update(dt, i, items)
	if Item.update(self, dt, i, items) then
		for i = -1, 1 do
			for j = -1, 1 do
				local rx = i * 8 + self.position.x
				local ry = j * 8 + self.position.y
				table.insert(items, Explosion:new(rx, ry))
			end
		end
		Globals.getProperty("explodeSound"):play()
		return true
	end
	return false
end
