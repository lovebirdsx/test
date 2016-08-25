require 'common_cfg'

return dialog(3, 'unit', {
		choice	('Camp', 'camp', true, CAMP_LIST),
		choice	('Type', 'type', true, TYPE_LIST),
		combo	('Squad', 'squad', true, SQUAD_LIST),
		check	('IsLeader', 'leader', false),
		choice	('Dir', 'dir', true, DIR_LIST),
		check	('GodSight', 'god_sight', false),
		check	('EnableSceneAI', 'scene_ai', false),
		choice	('SceneAI', 'move_ai', false, SCENE_AI_LIST),
		text	('Radius', 'radius', 'none'),
		text	('Radius2', 'radius2', 'none'),
		text	('Time', 'time', 'none'),
		text	('WaitTime', 'wait_time', 'none'),
		check	('PatrolLoop', 'patrol_loop', false),
		combo	('Point', 'pos', false, POINTS_LIST),
		combo	('Path', 'path', false, PATH_LIST),
		combo	('Region', 'region', false, REGION_LIST),
		text	('GenUnits', 'units', 'none'),
		combo	('GenCamp', 'gen_camp', false, CAMP_LIST),
		text	('First', 'first', 'none'),
		text	('Interval', 'interval', 'none'),
})
