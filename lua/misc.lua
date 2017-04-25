require 'table'

local Config = {}
local vmath = {}

function vmath.vector4(a, b, c, d)
	return {v1 = a, v2 = b, v3 = c, v4 = d}
end


Config.HexColors = {
	vmath.vector4(255 / 255, 165 / 255, 138 / 255, 1),
	vmath.vector4(255 / 255, 220 / 255, 138 / 255, 1),
	vmath.vector4(138 / 255, 255 / 255, 153 / 255, 1),
	vmath.vector4(138 / 255, 255 / 255, 249 / 255, 1),
	vmath.vector4(138 / 255, 142 / 255, 255 / 255, 1),
	vmath.vector4(178 / 255, 138 / 255, 255 / 255, 1),
	vmath.vector4(255 / 255, 138 / 255, 181 / 255, 1),
}


function main()
	for i, c in ipairs(Config.HexColors) do
		print(string.format('%2f %2f %2f %2f', c.v1, c.v2, c.v3, c.v4))
	end
end

main()