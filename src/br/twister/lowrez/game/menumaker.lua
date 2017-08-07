local class = import("res://br/twister/lowrez/game/middleclass.lua")

local wormSprite = nil

string.lpad = function(str, len, char)
	if char == nil then char = ' ' end
	return str .. string.rep(char, len - #str)
end

Menu = class("Menu")
function Menu:initialize(options)
	if wormSprite == nil then
		wormSprite = Globals.getProperty("wormSprite")
	end
	self.options = options
	self.selected = 0
end

function Menu:render(r, x, y)
	local font = Globals.getProperty("numbersFont")
	local pos = Point(x, y)
	local positions = {}
	for i = 1, #self.options do
		r:drawText(font[1], self.options[i], font[2], pos.x, pos.y+1, 1, RGB(0, 0, 0))
		r:drawText(font[1], self.options[i], font[2], pos.x, pos.y, 1)
		table.insert(positions, { x=pos.x, y=pos.y })
		pos.y = pos.y + font[1]:getHeight() + 2
	end
	
	local cpos = positions[self.selected+1]
	local cp = Point(r:getDrawOffset().x, r:getDrawOffset().y)
	r:setDrawOffset(Point(0, 0))
	r:drawSprite(wormSprite, 0, 0, 8, 8, cpos.x-10, cpos.y-2, 8, 8)
	r:setDrawOffset(cp)
end

function Menu:nextOption()
	self.selected = self.selected + 1
	Globals.getProperty("selectSound"):play()
	if self.selected >= #self.options then
		self.selected = #self.options-1
	end
end

function Menu:prevOption()
	self.selected = self.selected - 1
	Globals.getProperty("selectSound"):play()
	if self.selected < 0 then
		self.selected = 0
	end
end