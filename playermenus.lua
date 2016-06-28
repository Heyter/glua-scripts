local function shop(ent,role)
	if not IsValid(g_NPCShop) then
		g_NPCShop = vgui.Create("msitemsNPCShop")
	end
	if not g_NPCShop.shown then
		g_NPCShop:SetupShop(ent, role)
		g_NPCShop.PlyItemList:RebuildList()
	end
	g_NPCShop:SetVisible(true)
	g_NPCShop:MakeMove()
end

hook.Add("KeyPress", "PlayerMenu", function(ply, key)
	local p = ply:GetEyeTrace().Entity
	if not IsValid(p) or not p:IsPlayer() then return end
	local menu

	if key == IN_USE and p:GetPos():Distance(ply:GetShootPos()) < 200 and not IsValid(menu) then
		menu = DermaMenu()
		if msitems.NPCShops[p:UniqueID()] then
			menu:AddOption("Shop",function() shop(p,p:UniqueID()) end):SetIcon("icon16/cart.png")
			menu:AddSpacer()
		end
		menu:AddOption("PM",function() RunConsoleCommand("chat_open_pm",p:SteamID()) end):SetIcon("icon16/group.png")
		menu:AddOption("Copy SteamID",function() SetClipboardText(p:SteamID()) end):SetIcon("icon16/vcard.png")
		menu:Center()
		menu:MakePopup()
	end
end)
