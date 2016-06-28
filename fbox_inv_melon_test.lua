local slot = 1
me:SetInvItem(slot,"Melon","It's food","models/props_junk/watermelon01.mdl",1,function()
	if SERVER then return end
	local oldslot = slot
	local menu = DermaMenu()
	menu:SetPos(gui.MousePos())
	menu:MakePopup()
	menu:AddOption("Eat",function() print("ate melon") me:EmptyInvItem(oldslot) net.Start("fbox_inv_emptyslot") net.WriteEntity(LocalPlayer()) net.WriteInt(oldslot,32) net.SendToServer() end):SetIcon("icon16/tick.png")
	menu:AddSpacer()
	menu:AddOption("Drop",function() print("will drop then") end):SetIcon("icon16/delete.png")
end)