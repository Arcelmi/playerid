playerid = {}
playerid_read = {}
player_has_id = {}
lastid = 0

dofile(minetest.get_modpath(minetest.get_current_modname()).."/watch.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/teleport.lua")

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

minetest.register_chatcommand("list_ids", {
	privs = {kick=true},
	func = function(name)
		local form = string.format("size[10,10]"..
			"textlist[0,0;10,10;list;%s]", table.concat(playerid_read, ","))
		minetest.show_formspec(name, "playerid:list_ids", 
			form)
	end
})

minetest.register_chatcommand("xban_id", {
	description = "XBan a playerid",
	params = "<player> <reason>",
	privs = { ban=true },
	func = function(name, params)
		local id, reason = params:match("(%S+)%s+(.+)")
		if not (id and reason) then
			return false, "Usage: /xban <id> <reason>"
		end
		local plname = playerid[tonumber(id)]
		xban.ban_player(plname, name, nil, reason)
		return true, ("Banned %s."):format(plname)
	end,
})

minetest.register_chatcommand("kick_id", {
	params = "<id> [reason]",
	description = "kick a player",
	privs = {kick=true},
	func = function(name, param)
		local tokick, reason = param:match("([^ ]+) (.+)")
		tokick = tokick or param
		tokick = playerid[tonumber(tokick)]
		if not minetest.kick_player(tokick, reason) then
			return false, "Failed to kick player " .. tokick
		end
		local log_reason = ""
		if reason then
			log_reason = " with reason \"" .. reason .. "\""
		end
		minetest.log("action", name .. " kicks " .. tokick .. log_reason)
		return true, "Kicked " .. tokick
	end,
})
