ITEM_APPLE = 0
ITEM_PEAR = 1
ITEM_CHERRY = 2
ITEM_HEALTH = 3
ITEM_CANDY = 4
ITEM_BATTERY = 5
ITEM_BOMB = 6
ITEM_EXPLOSION = 7

function lerp(a, b, t)
	return (1.0 - t) * a + b * t
end

function table.contains(t, val)
	for k, v in pairs(t) do
		if v == val then return true end
	end
	return false
end