local revive = CreateClientConVar("fa_autorevive",1,true,true)

hook.Add("Think","autorevive",function()
	if !LocalPlayer():Alive() and GetConVar("fa_autorevive"):GetInt() == 1 then
		if aowl then
			LocalPlayer():ConCommand("aowl revive")
		end
	end
end)