require 'common_cfg'

-- 镜头移动起始点
-- type=camera_pos;category=show_start

-- 镜头移动结束点
-- type=camera_pos;category=show_end

-- 精英小队
-- type=squad;category=elite

-- 普通小队
-- type=squad;category=normal

local CAMERA_CATEGORY = {'show_start', 'show_end'}
local SQUAD_CATEGORY = {'normal', 'elite'}

local DialogCameraPos = dialog(1, 'camera_pos', {
	choice	('Category', 'category', true, CAMERA_CATEGORY)
})

local DialogSquad = dialog(3, 'squad', {
	choice	('Category', 'category', true, SQUAD_CATEGORY),
	choice	('Camp', 'camp', false, CAMP_LIST),
	choice	('Dir', 'dir', false, DIR_LIST),
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

return {
	dialog = {
		DialogCameraPos,
		DialogSquad,
	}
}
