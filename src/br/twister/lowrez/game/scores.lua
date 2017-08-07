scores.list = {}
scores.listPos = 1

string.lpad = function(str, len, char)
	if char == nil then char = ' ' end
	return str .. string.rep(char, len - #str)
end

function scores:on_start()
	-- XXX Read scores
	local f = io.open("scores.dat", "r")
	if f ~= nil then
		local i = 1
		for line in f:lines() do
			for k, v in string.gmatch(line, "(%w+)=(%w+)") do
				self.list[i] = { k, tonumber(v) }
				i = i + 1
			end
		end
		f:close()
	end
	
	table.sort(self.list, function(a, b) return a[2] > b[2] end)
end

function scores:on_update(input, dt)
	if input:keyPressed(Keys.KeyEnter) then
		Globals.setProperty("menuShown", true)
		Engine.setState("res://br/twister/lowrez/game/menu.lua")
	elseif input:keyPressed(Keys.KeyUp) then
		if self.listPos > 1 then self.listPos = self.listPos - 1 end
	elseif input:keyPressed(Keys.KeyDown) then
		if self.listPos + 7 < #self.list then self.listPos = self.listPos + 1 end
	end
end

function scores:on_render(r)
	r:clear(RGB(0, 0, 0))
	
	local nfont = Globals.getProperty("numbersFont")
	
	local n = Point(9, 2)
	for i = self.listPos, self.listPos + 7 do
		local item = self.list[i]
		if item == nil then goto continue end
		local k = item[1]
		local v = item[2]
		local col = RGB(180, 180, 180)
		if i == 1 then
			col = RGB(255, 215, 0)
		end
		n = r:drawText(nfont[1], string.format("%7s%6d", k:lpad(7, ' '), v), nfont[2], n.x, n.y+1, 1, col)
		::continue::
	end
	
	local tw = r:getTextWidth(nfont[1], "[ENTER] BACK", nfont[2], 1)
	r:drawText(nfont[1], "[ENTER] BACK", nfont[2], 32 - tw/2, 59 - nfont[1]:getHeight(), 1)
	
	r:drawSpriteSimple(Globals.getProperty("upDown"), 2, 3)
end