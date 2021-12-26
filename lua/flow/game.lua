local game = {}
local objs = {}
local objs_by_url = {}
local running = true
local add_record = {}
local msgs = {}
local curr_obj = nil
local time = 0

local function printf(fmt, ...)
	local prefix = string.format('%5d ', math.floor(time * 1000))
	print(string.format(prefix .. fmt, ...))
end

local function pack(...)
	return {n = select('#', ...), ...}
end

local function obj_call(obj, fun_name, ...)
	curr_obj = obj
	local fun = obj[fun_name]
	if fun then fun(...) end
end

function game.update(dt)
	while #add_record > 0 do
		local obj = table.remove(add_record, 1)
		table.insert(objs, obj)

		objs_by_url[obj.url()] = obj

		obj_call(obj, 'init')
	end

	for _, obj in ipairs(objs) do
		obj_call(obj, 'update', dt)
	end

	while #msgs > 0 do
		local msg = table.remove(msgs, 1)
		local recver, message_id, message, sender = unpack(msg)
		local obj = objs_by_url[recver]
		if obj then
			assert(obj.on_message, ('no on_message to obj %s msg:[%s] from:[%s]'):format(recver, message_id, sender))
			-- printf('MSG [%16s] -> [%16s] %s', sender, recver, message_id)

			obj_call(obj, 'on_message', message_id, message, sender)
		else
			printf('ignore msg: %s to %s', message_id, recver)
		end
	end
end

function game.add_obj(obj)
	table.insert(add_record, obj)
	assert(not objs_by_url[obj.url()])
end

function game.run(update_times)
	local count = 1
	local dt = 1 / 30

	while running and (not update_times or count < update_times) do
		count = count + 1
		game.update(dt)
		time = time + dt
	end
end

function game.exit()
	running = false
end

function game.post_msg(url, message_id, message)
	table.insert(msgs, pack(url, message_id, message, curr_obj.url()))
end

function game.get_url()
	return curr_obj.url()
end

function game.time()
	return time
end

return game
