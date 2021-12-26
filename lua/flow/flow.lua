local MSG_RESUME = hash("FLOW_RESUME")

local READY = "READY"
local RUNNING = "RUNNING"
local RESUMING = "RESUMING"
local WAITING = "WAITING"

local function pack(...)
    return { n = select("#", ...), ... }
end

local Flow = {}
local instances = {}
local time = 0
local id = 1

local function create_or_get(co)
    if not instances[co] then
        instances[co] = {
            url = msg.url(),
            state = READY,
            co = co,
            id = id
        }
        id = id + 1
    end
    return instances[co]
end

function Flow.start(fn)
    local instance = create_or_get(coroutine.create(fn))
    local ok, msg = coroutine.resume(instance.co)
    if not ok then
        print(debug.traceback(instance.co, msg))
    end
end

function Flow.wait(seconds)
    local instance = create_or_get(coroutine.running())
    local now = time
    instance.state = WAITING
    instance.condition = function()
        return time > (now + seconds)
    end
    return coroutine.yield()
end

function Flow.wait_condition(fn)
    local instance = create_or_get(coroutine.running())
    instance.state = WAITING
    instance.condition = fn
    return coroutine.yield()
end

-- 返回message, message_id, sender
function Flow.wait_any_message()
    local instance = create_or_get(coroutine.running())
    instance.state = WAITING
    instance.on_message = function(message_id, message, sender)
        assert(instance.state == WAITING)
        instance.state = RUNNING
        local ok, msg = coroutine.resume(instance.co, message, message_id, sender)
        if not ok then
            print(debug.traceback(instance.co, msg))
        end
    end
    return coroutine.yield()
end

function Flow.wait_condition_or_message(condition, ...)
    local message_ids_to_wait_for = { ... }
    for i, msg_id in ipairs(message_ids_to_wait_for) do
        if type(msg_id) == 'string' then
            message_ids_to_wait_for[i] = hash(msg_id)
        end
    end

    local instance = create_or_get(coroutine.running())
    instance.state = WAITING
    instance.condition = condition
    instance.on_message = function(message_id, message, sender)
        for _, message_id_to_wait_for in pairs(message_ids_to_wait_for) do
            if message_id == message_id_to_wait_for then
                assert(instance.state == WAITING)
                instance.state = RUNNING
                local ok, msg = coroutine.resume(instance.co, message, message_id, sender)
                if not ok then
                    print(debug.traceback(instance.co, msg))
                end
                break
            end
        end
    end
    return coroutine.yield()
end

-- 返回message, message_id, sender
function Flow.wait_message(...)
    return Flow.wait_condition_or_message(nil, ...)
end

-- 返回message, message_id, sender, 如果超时,返回nil
function Flow.wait_message_timeout(seconds, ...)
    local timeout = time + seconds
    return Flow.wait_condition_or_message(function () return time >= timeout end, ...)
end

function Flow.load(collection_url)
    local instance = create_or_get(coroutine.running())
    instance.state = WAITING
    instance.on_message = function(message_id, message, sender)
        if message_id == hash("proxy_loaded") and sender == collection_url then
            msg.post(sender, "enable")
            instance.state = READY
        end
    end
    msg.post(collection_url, "load")
    return coroutine.yield()
end

function Flow.unload(collection_url)
    local instance = create_or_get(coroutine.running())
    instance.state = WAITING
    instance.on_message = function(message_id, message, sender)
        if message_id == hash("proxy_unloaded") and sender == collection_url then
            instance.state = READY
        end
    end
    msg.post(collection_url, "unload")
    return coroutine.yield()
end

function Flow.update(dt)
    time = time + dt

    for co, instance in pairs(instances) do
        local status = coroutine.status(co)
        if status == "dead" then
            instances[co] = nil
        else
            if instance.state == WAITING and instance.condition then
                if instance.condition() then
                    instance.condition = nil
                    instance.on_message = nil
                    instance.state = READY
                end
            end

            if instance.state == READY then
                instance.state = RESUMING
                msg.post(instance.url, MSG_RESUME, { id = instance.id })
            end
        end
    end
end

function Flow.on_message(message_id, message, sender)
    if message_id == MSG_RESUME then
        for co, instance in pairs(instances) do
            if instance.id == message.id then
                instance.state = RUNNING
                local result = instance.result or {}
                instance.result = nil
                local ok, msg = coroutine.resume(co, unpack(result, 1, result.n or #result))
                if not ok then
                    print(debug.traceback(instance.co, msg))
                end
                return
            end
        end
    else
        local recver = msg.url()
        for _, instance in pairs(instances) do
            if recver == instance.url and instance.on_message then
                instance.on_message(message_id, message, sender)
            end
        end
    end
end

return Flow
