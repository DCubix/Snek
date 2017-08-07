test2.time = 0.0

local pos_cb = function(x, y)
	return Point(0, math.random(-1, 1))
end

function test2.on_start(self)
	Engine.wait(
		3.0, function()
			-- Go to state 1
			Engine.setState("res://test/test.lua")
		end
	)
end

function test2.on_update(self, dt)
	self.time = self.time + dt
end

function test2.on_render(self, renderer)
	renderer:clearFac(RGB(0, 0, 0), 0.045)
	
	local t = self.time * 2.0
	local x0 = math.cos(t) * 32 + 32
	local y0 = math.sin(t) * 32 + 32
	local x1 = math.cos(t + math.pi) * 32 + 32
	local y1 = math.sin(t + math.pi) * 32 + 32
	
	renderer:drawLine(x0, y0, x1, y1, RGB(255, 0, 0))
	
	local font = Globals.getProperty("font")
	local cm = Globals.getProperty("charMap")

	renderer:drawText(font, "test2", cm, 2, 55)
end