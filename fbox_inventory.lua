local colors = {
	red = Color(200,100,100),
	green = Color(100,200,100),
	teal = Color(100,200,200),
	blue = Color(100,100,200),
	gray = Color(100,100,100),
	slate = Color(33,33,33),
	sublime = Color(78,78,76),
	close1 = Color(169,36,36),
	close2 = Color(145,36,36),
}

function InvPrintPly(text,ply)
	if CLIENT then return end
	MsgC(colors.green,"[Inventory] ",color_white,text,colors.red,ply:RealNick(),colors.gray," ("..ply:SteamID()..")\n")
end

local META = FindMetaTable("Player")

function META:LoadInventory()
	if self:GetPData("fbox_inv") == nil then
		self:ResetInventory()
	else
		self.Inventory = util.JSONToTable(self:GetPData("fbox_inv"))
		InvPrintPly("Inventory loaded for ",self)
	end
end

function META:SaveInventory()
	self:SetPData("fbox_inv",util.TableToJSON(self.Inventory))
	InvPrintPly("Inventory saved for ",self)
end

function META:ResetInventory()
	self.Inventory = {}
	for i = 1,55 do
		self.Inventory[i] = {}
	end

	self:SetPData("fbox_inv",util.TableToJSON(self.Inventory))
	InvPrintPly("New/Cleared inventory created for ",self)
end

function META:GetInventory()
	return self.Inventory
end

function META:GetInvItem(num)
	return self.Inventory[num]
end

function META:SetInvItem(num,name,desc,model,stack,func)
	if self.Inventory[num].name == nil then
		self.Inventory[num].name = name
		self.Inventory[num].desc = desc
		self.Inventory[num].model = model
		self.Inventory[num].stack = stack
		self.Inventory[num].func = func

		MsgC(colors.green,"[Inventory] ",color_white,"Slot ",colors.teal,num,color_white," set for ",colors.red,self:RealName(),colors.gray," ("..self:SteamID()..")",color_white," with data: ",colors.teal,"{"..name..","..desc..","..model..","..tostring(func).."}\n")
	elseif self.Inventory[num+1].name == nil and self.Inventory[num+1].name != self.Inventory[num].name then
		self.Inventory[num+1].name = name
		self.Inventory[num+1].desc = desc
		self.Inventory[num+1].model = model
		self.Inventory[num+1].stack = stack
		self.Inventory[num+1].func = func

		if SERVER then
			MsgC(colors.green,"[Inventory] ",colors.red,"ERROR: ",color_white,"Inventory slot was not empty, moving to slot: ",colors.teal,num+1,"\n")
			MsgC(colors.green,"[Inventory] ",color_white,"Slot ",colors.teal,num+1,color_white," set for ",colors.red,self:RealName(),colors.gray," ("..self:SteamID()..")",color_white," with data: ",colors.teal,"{"..name..","..desc..","..model..","..tostring(action).."}\n")
		end
	elseif self.Inventory[num+1].name == self.Inventory[num].name then
		if not self.Inventory[num].stack then return end
		self.Inventory[num].stack = self.Inventory[num].stack + 1
	else
		if CLIENT then return end
		MsgC(colors.green,"[Inventory] ",colors.red,"ERROR: ",color_white,"Inventory slot was not empty, slot above also not empty, proventing override.\n")
	end
end

function META:EmptyInvItem(slot)
	if self.Inventory[slot] then
		self.Inventory[slot] = {}
		if SERVER then
			MsgC(colors.green,"[Inventory] ",color_white,"Slot ",colors.teal,slot,color_white," emptied for ",colors.red,self:RealName(),colors.gray," ("..self:SteamID()..")\n")
		end
	end
end

function META:OpenInventory()
	if CLIENT then
		finv.OpenInventory()
	end
	if SERVER then
		self:SendLua[[finv.OpenInventory()]]
	end
end

if SERVER then
	--Hooks
	hook.Add("PlayerInitialSpawn","fbox_LoadInv",function(ply)
		ply:LoadInventory()
	end)

	hook.Add("PlayerDisconnected","fbox_DCSaveInv",function(ply)
		ply:SaveInventory()
	end)

	--aowl command
	aowl.AddCommand("inventory",function(ply)
		ply:OpenInventory()
	end)

	--Networking
	util.AddNetworkString("fbox_inv_emptyslot")

	net.Receive("fbox_inv_emptyslot",function(ply,slot)
		local ply = net.ReadEntity()
		local slot = net.ReadInt(32)
		ply:EmptyInvItem(slot)
	end)
end

if CLIENT then
	finv = {}
	function finv.OpenInventory()

		local icons = {
			package = Material("icon16/package.png")
		}

		local textures = {
			grad_u = Material("vgui/gradient-u"),
			grad_d = Material("vgui/gradient-d"),
			grad_l = Material("vgui/gradient-l"),
			grad_r = Material("vgui/gradient-r"),
		}

		local ply = LocalPlayer()

		local frame = vgui.Create("DFrame")
		frame:SetTitle("")
		frame:SetSize(720,400)
		frame:Center()
		frame:MakePopup()

		frame.btnMaxim:SetVisible(false)
		frame.btnMinim:SetVisible(false)

		function frame:Paint(w,h)
			draw.RoundedBox(0,0,0,w,26,colors.slate)
			draw.RoundedBox(0,0,26,w,h-26,colors.sublime)
			surface.SetMaterial(icons.package)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(5,5,16,16)
			draw.SimpleText("Inventory","DermaDefault",26,6)
		end

		function frame.btnClose:Paint(w,h)
			draw.RoundedBox(0,0,5,32,16,colors.close1)
			surface.SetMaterial(textures.grad_d)
			surface.SetDrawColor(colors.close2)
			surface.DrawTexturedRect(0,5,32,16)
			draw.SimpleTextOutlined("r","Marlett",8,6,color_white,nil,nil,1,color_black)
		end

		local InvPanel = vgui.Create("DGrid",frame)
		InvPanel:Dock(FILL)
		InvPanel:SetCols(11)
		InvPanel:SetColWide(64)
		InvPanel:SetRowHeight(64)

		function InvPanel:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(64,64,64))
		end

		for i = 1,#ply:GetInventory() do
			local item = ply:GetInventory()[i]
			local ItemPanel = vgui.Create("DPanel")
			ItemPanel:SetSize(64,64)
			ItemPanel:DockMargin(0,0,2,0)
			if item.name and item.desc and item.model and item.stack then
				local ItemModel = vgui.Create("DModelPanel",ItemPanel)
				ItemModel:Dock(FILL)
				ItemModel:SetModel(item.model)
				ItemModel:SetToolTip("Name: "..item.name.."\nDescription: "..item.desc.."\nStack: "..item.stack)
				if item.func then
					ItemModel.DoClick = item.func
				end
			end
			InvPanel:AddItem(ItemPanel)

			function ItemPanel:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(128,128,128))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(64,64,64))
			end
		end
	end
end