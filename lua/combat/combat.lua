package.path = '../?.lua;' .. package.path
local class = require 'class'

Character = class(function (self)
	self.raw_attr = {}
	self.effects = {}
end)

function Character:get_current_attr(attr_id, criteria)
	local attr = self.raw_attr[attr_id]
	for _, eff in ipairs(self.effects) do
		attr = eff:apply_attr_modifier(attr_id, attr, criteria)
	end
	attr = apply_capping_to_final_value(attr)
	return attr
end

function Character:on_recv_dmg(dmg_info)
	for _, eff in ipairs(self.effects) do
		eff:on_recv_dmg(self, dmg_info)
	end
end

Effect = class(function (self)
	self.modifier_list = {}
	self.modifier_map = {}
end)

function Effect:apply_attr_modifier(attr_id, attr, criteria)
	local modifer = self.modifier_map[attr_id]
	if modifer then
		if modifer.criteria == criteria then
			return attr * modifer.amount
		else
			return attr
		end
	end
end

function Effect:on_recv_dmg(char, dmg_info)
	
end

Modifier = class(function (self)
	self.amount = 1
	criteria = nil
end)

