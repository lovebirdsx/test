local game = require 'flow.game'

msg = {}

function msg.post(url, message_id, message)
	game.post_msg(url, message_id, message)
end

function msg.url()
	return game.get_url()
end

function hash(str)
	return str
end

return msg