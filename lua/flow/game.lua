local M = {}
local objs = {}
local objs_by_url = {}
local running = true
local add_record = {}
local msgs = {}
local curr_obj = nil
local time = 0

local function pack(...)
	return {n = select('#', ...), ...}
end

function M.update(dt)
	if #add_record > 0 then
		for _, obj in ipairs(add_record) do
			table.insert(objs, obj)
		end
		add_record = {}
	end

	for _, obj in ipairs(objs) do
		curr_obj = obj
		if obj.update then
			obj.update(dt)
		end
	end

	while #msgs > 0 do
		local msg = table.remove(msgs, 1)
		local recver, message_id, message, sender = unpack(msg)
		local obj = objs_by_url[recver]
		if obj then
			assert(obj.on_message, ('no on_message to obj %s msg:[%s] from:[%s]'):format(recver, message_id, sender))
			obj.on_message(message_id, message, sender)
		else
			print(('ignore msg: %s to %s'):format(message_id, recver))
		end
	end
end

function M.add_obj(obj)
	table.insert(add_record, obj)
	assert(not objs_by_url[obj.url()])
	objs_by_url[obj.url()] = obj

	curr_obj = obj
	if obj.init then
		obj.init()
	end
end

function M.run(update_times)
	local count = 1
	while running and (not update_times or count < update_times) do
		count = count + 1
		local dt = 1 / 30
		M.update(dt)
		time = time + dt
	end
end

function M.exit()
	running = false
end

function M.post_msg(url, message_id, message)
	table.insert(msgs, pack(url, message_id, message, curr_obj.url()))
end

function M.get_url()
	return curr_obj.url()
end

function M.time()
	return time
end

return M
