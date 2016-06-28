local ids = {
	"STEAM_0:0:58178275",--me
}

hook.Add("Think","Flex_CustomPhysguns",function()
	local rainbow  = HSVToColor((RealTime()*100)%360,1,1)
	local phys  = Vector(math.sin(RealTime())*-255,math.sin(RealTime())*255,255)/255
	for _,ply in pairs(player.GetAll()) do
		if ply:SteamID() == ids[1] then
			ply:SetWeaponColor(phys)
		end
	end
end)
