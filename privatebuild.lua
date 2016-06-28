if SERVER then
	local whitelist = {
		["STEAM_0:0:69785433"] = true,
		["STEAM_0:0:44826242"] = true,
		["STEAM_0:0:58178275"] = true,
		["STEAM_0:0:28332384"] = true,
		["STEAM_0:1:42637878"] = true,
		["STEAM_0:1:66459838"] = true,
		["STEAM_0:1:106477742"] = true,
		["STEAM_0:0:29136039"] = true,
		["STEAM_0:1:64560387"] = true,
		["STEAM_0:1:19236861"] = true,
		["STEAM_0:1:13374044"] = true,
		["STEAM_0:0:13073749"] = true,
		["STEAM_0:1:19269760"] = true,
	}


	local delay = CurTime()
	hook.Add("Think","FlexPrivateBuild",function()
		if delay and delay > CurTime() then return end
		local box1 = ents.FindInBox(Vector(-11452, -13543, -7127),Vector(-6897, -8989, -5576))
		for _,ply in pairs(player.GetAll()) do
			if whitelist[ply:SteamID()] and not ply:IsAdmin() then
				ply:SetTeam(1337)
				me:SetTeam(1337)
			end
			if table.HasValue(box1,ply) then
				if whitelist[ply:SteamID()] ~= true then
					ply:SetPos(Vector(-9299.001953125, -11153.404296875, -7403.8979492188))
					ply:ChatPrint("You are not whitelisted to come here")
					MsgC(Color(100,200,100),"[Flex's Private Build] ",color_white,"Kicking out "..tostring(ply).."\n")
				end
			end
		end
		delay = delay+1
	end)
end

team.SetUp(1337,"Flex's Private Build",Color(0,150,130))