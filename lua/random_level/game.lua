require('class')

local FPS = 30

Game = class(function(self)
	self.frame_cnt = 0
	self.wait_records = {}
	self.start_records = {}
	self.wait_id = 0
end)

local _instance
function Game:instance()
	if not _instance then
		_instance = Game()
	end
	return _instance
end

function Game:frame()
	-- 启动需要启动的线程
	if #self.start_records > 0 then
		local start_records = self.start_records
		self.start_records = {}
		for i = 1, #start_records do
			local r = start_records[i]
			local c = coroutine.create(r.fun)
			self:do_resume(c, table.unpack(r.params))
		end
	end

	self.frame_cnt = self.frame_cnt + 1

	-- 调度等待的线程
	local now = self:get_time()
	local wake_up_records = {}
	while #self.wait_records > 0 and self.wait_records[1].end_time <= now do
		wake_up_records[#wake_up_records + 1] = self.wait_records[1]
		table.remove(self.wait_records, 1)
	end

	for i = 1, #wake_up_records do
		local r = wake_up_records[i]
		self:do_resume(r.thread)
	end
end

function Game:run()
	while #self.wait_records > 0 or #self.start_records > 0 do
		self:frame()
	end
end

function Game:wait(time)
	coroutine.yield('wait', time)
end

function Game:get_time()
	return self.frame_cnt / FPS
end

function Game:on_yield_wait(thread, time)
	self.wait_id = self.wait_id + 1
	self.wait_records[#self.wait_records + 1] = {thread = thread, end_time = self:get_time() + time, id = self.wait_id}	
	table.sort(self.wait_records, function (a, b)
		if a.end_time ~= b.end_time then
			return a.end_time < b.end_time
		else
			return a.id < b.id
		end
	end)	
end

function Game:do_resume(c, ...)
	local ret, type, p1, p2, p3, p4 = coroutine.resume(c, ...)
	if ret then
		local st = coroutine.status(c)
		if st == 'suspended' then
			local fun = self['on_yield_' .. type]
			fun(self, c, p1, p2, p3, p4)
		end
	else
		print('error', type)
	end
end

function Game:start_thread(fun, ...)
	table.insert(self.start_records, {fun = fun, params = {...}})
end
