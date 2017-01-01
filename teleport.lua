minetest.register_chatcommand("teleport_id", {
	params = "<id>",
	description = "teleport to given position",
	privs = {teleport=true},
	func = function(player, param)
		teleport_to = minetest.get_player_by_name(playerid[tonumber(param)])
		if teleport_to then
			player_pos = teleport_to:getpos()
			local player = minetest.get_player_by_name(player)
			player:setpos(player_pos)
			return true, "Teleporting to " .. teleport_to:get_player_name() .. " at "..core.pos_to_string(player_pos)
		else
			return "ID not found!"
		end
	end,
})
