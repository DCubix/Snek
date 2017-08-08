import("res://br/twister/lowrez/game/snek.lua")
import("res://br/twister/lowrez/game/util.lua")

Enemy = class("Enemy", WormHead)
function Enemy:initialize()
	WormHead.initialize(self)
	self.target = nil
	self.deadTime = 0.0
	self.burnt = false
	self.dispose = false
	self.anim = Animation(10, 1, 0.0)
	self.anim:setAutomatic(false)
	self.hitOnce = false
end

function Enemy:update(game, dt, cols, player, items)
	-- XXX Enemy AI
	if self.dead then
		if self.deadTime > 0.0 then
			self.deadTime = self.deadTime - dt
		else
			self.dispose = true
		end
	else
		if self:hitWorm(player) and player.powered then
			self.dead = true
			self.burnt = true
			Globals.getProperty("shockSound"):play(0.5)
			game.score = game.score + #self.body * 10
		elseif player:hitWorm(self) then
			if player.powered then
				self.dead = true
				self.burnt = true
				Globals.getProperty("shockSound"):play(0.5)
				game.score = game.score + #self.body * 10
			elseif player.active then
				player:damage()
			end
		end
	
		-- XXX Avoid player
		for idx, p in pairs(player.body) do
			local dist = p.position:distanceTo(self.position)
			if dist <= 10 then
				self:turnRight(dt)
			end
		end
		
		if self.target == nil then -- XXX Pick a random target
			if #items > 1 then
				self.target = math.random(1, #items)
			elseif #items == 1 then
				self.target = 1
			else
				self.target = nil
			end
		else -- XXX Follow target until it hits it
			if items[self.target] ~= nil then
				if not table.contains({ ITEM_APPLE, ITEM_PEAR, ITEM_CHERRY }, items[self.target].type) then
					self.target = nil
				end
			end
			
			if self.target == nil then return end
			
			local item = items[self.target]
			if item == nil then
				self.target = nil
			else
				local dir = item.position:sub(self.position)
				local angle = self.dir:cross(dir)
		
				if angle < 0 then
					self:turnLeft(dt)
				else
					self:turnRight(dt)
				end
				
				-- XXX Hits item
				for i, itm in pairs(items) do
					if self:collided(itm) then
						if itm.type ~= ITEM_EXPLOSION and itm.type ~= ITEM_BOMB then
							self:grow()
							table.remove(items, self.target)
							self.target = nil
							break
						end
					end
					if itm.type == ITEM_EXPLOSION then
						if self:collidedAll(itm) then
							self.dead = true
							self.burnt = true
							break
						end
					end
				end
			end
		end
		WormHead.update(self, dt, cols)
	end
end

function Enemy:render(r)
	local sprite = Globals.getProperty("badWormSprite")
	if self.dead and not self.burnt then
		sprite = Globals.getProperty("wormSkelSprite")
	elseif self.dead and self.burnt then
		sprite = Globals.getProperty("burntWormSprite")
	end
	WormHead.render(self, r, self.anim, sprite)
end