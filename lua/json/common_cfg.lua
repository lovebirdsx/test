CAMP_LIST = {'enemy', 'neutral', 'ally', 'enemy2', 'god', 'evil'}
TYPE_LIST = {
	'SkullSoldier',
	'SkullSoldierUnderGround',
	'SkullSoldierAmbush',
	'SkullSoldierAmbush',
	'SkullEliteSoldier',
	'SkullEliteSoldierUnderGround',
	'SkullEliteSoldierAmbush',
	'SkullArcher',
	'SkullArcherUnderGround',
	'SkullArcherAmbush',
	'SkullEliteArcher',
	'SkullEliteArcherUnderGround',
	'SkullEliteArcherAmbush',
	'Goblin',
	'Zombie',
	'PlagueZombie',
	'Gargoyle',
	'DeathGuard',
	'Willem',
	'Tomb',
	'Lich',
	'Pig',
	'Crow',
	'Frog',
	'Bomb',
	'Turret',
	'TurretUndead',
	'TowerUndead',
	'Tower',
	'Fence',
	'Fence2',
	'Barrack',
	'Yvette',
	'YvetteMember',
	'Ellick',
	'EllickMember',
	'Henry',
	'HenryMember',
	'Delia',
	'Delia2',
	'DeliaMember',
	'DeliaMember2',
	'Mader',
	'MaderMember',
	'BerserkerSoldier',
	'VillagerMale1',
	'VillagerMale2',
	'VillagerFemale1',
	'Carriag',
	'Colossu',
	'SkyEy',
}
SQUAD_LIST = {
	'hold1', 'hold2', 'hold3', 'hold4',
	'tower1', 'tower2', 'tower3', 'tower4',
	'turret1', 'turret2', 'turret3', 'turret4',
	'barrack1', 'barrack2', 'barrack3', 'barrack4',
	'ambush1', 'ambush2', 'ambush3', 'ambush4',
	'ally1', 'ally2', 'ally3', 'ally4',
	'patrol1', 'patrol2', 'patrol3', 'patrol4',
	'bomb1', 'bomb2', 'bomb3', 'bomb4', 'bomb5',
	'fence'
}
DIR_LIST = {'n', 'ne', 'e', 'se', 's', 'sw', 'w', 'nw'}
SCENE_AI_LIST = {	
	'easy_patrol',
	'rougeinearth',
	'ambush',
	'move',
	'attack_move',
	'berserker',
	'ranger',
	'alchemist',
	'knight',
	'pig',
	'goblin',
	'in_circle',
	'in_circle_attack',
	'sale_mader',
	'tomb',
}
POINTS_LIST = {'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 'p8'}
PATH_LIST = {'path1', 'path2', 'path3', 'path4', 'path5', 'path6', 'path7', 'path8', 'patrol1', 'patrol2', 'patrol3', 'patrol4'}
REGION_LIST = {'region1', 'region2', 'region3', 'region4', 'region5', 'region6', 'region7', 'region8'}

local function gen_kv_list(type_list)	
	local t = {}
	for i = 1, #type_list do
		local type = type_list[i]		
		t[i] = {title = type, value = type}
	end
	return t
end

function choice(title, key, need, type_list)
	local type_list2
	if not need then
		type_list2 = {'none'}
		for i = 1, #type_list do
			type_list2[i + 1] = type_list[i]
		end
	else
		type_list2 = type_list
	end

	local t = {
		type = 'choice',
		title = title,
		key = key,		
		choices = gen_kv_list(type_list2),
	}

	if not need then t.default = 0 end
	return t
end

function combo(title, key, need, type_list)
	local type_list2
	if not need then
		type_list2 = {'none'}
		for i = 1, #type_list do
			type_list2[i + 1] = type_list[i]
		end
	else
		type_list2 = type_list
	end

	local t = {
		type = 'combo box',
		title = title,
		key = key,		
		choices = gen_kv_list(type_list2)
	}

	if not need then t.default = 0 end
	return t
end

function check(title, key, default)
	return {
		default = default,
		key = key,
		title = title,
		type = 'check box'
	}
end

function text(title, key, default)
	return {
		default = default,
		key = key,
		title = title,
		type = 'text'
	}
end

function dialog(col, type, control_list)
	return {
		layout = {
			col = col
		},
		type = type,
		widget = control_list,
	}
end
