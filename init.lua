playerid = {}
local playerid_read = {}
local player_has_id = {}
local lastid = 0

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	if not player_has_id[name] then
		player_has_id[name] = true
		local id = lastid+1
		lastid = id
		playerid[id] = name
		playerid_read[id] = name.." ("..id..")"
	end
end)

minetest.register_chatcommand("idlist", {
	privs = {interact=true},
	func = function(name)
		minetest.chat_send_player(name, table.concat(playerid_read, ","))
	end
})

minetest.register_on_chat_message(function(name, message)
	if message:sub(1,3) == "/id" then
		msg = string.split(message, "%s", false, -1, true)
		msg[1] = msg[1]:gsub("/id", "")
		local params = ""
		local new_param
		local i = 2
		while msg[i] do
			msg[i] = msg[i]:gsub("id:", "")
			if not playerid[tonumber(msg[i])] then
				msg[i]=msg[i]
			else
				msg[i] = playerid[tonumber(msg[i])]
			end
			params = params.." "..msg[i]
			i = i+1
		end
		params = params:sub(2, params:len())
		command = minetest.chatcommands[msg[1]]
		if command then
			local has, missing = minetest.check_player_privs(name, command.privs)
			if has then
				return command.func(name, params)
			else
				minetest.chat_send_player(name, "Fehlende Privilegien: "..dump(missing))
				return true
			end
		else
			minetest.chat_send_player(name,"Befehl nicht gefunden")
			return true
		end
	end
end)
