CreateClientConVar("ms_inv_dark",1,true,false)

local icon = {}
icon.close = Material("icon16/cross.png")
icon.theme = Material("icon16/wrench_orange.png")
icon.frame = Material("icon16/box.png")

local col = {}
col.title_dark = Color(30,30,30)
col.base_dark = Color(60,60,60)
col.title_light = Color(180,180,180)
col.base_light = Color(160,160,160)

--ITEM PANEL--

local blank = ""

local PANEL = vgui.Register("msitems.itempnl", {}, "DButton")

function PANEL:Init()

	self.icon = vgui.Create("SpawnIcon", self)
	self.icon:SetSize(64,64)
	self.icon:SetModel(blank)

	function self.icon.Paint(icon,w,h)
		local darkmode = GetConVar("ms_inv_dark"):GetInt()
		if darkmode == 1 then
			titlecol = col.title_dark
		elseif darkmode == 0 then
			titlecol = col.title_light
		end

		draw.RoundedBox(0,0,0,w,h,titlecol)
	end

	function self.icon.PaintOver(w,h)

		self:DrawSelections()

		if self.itemcount > 0 then
			draw.SimpleText( self.itemcount, "BudgetLabel", 3, 3, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
		end

		if self.price then
			draw.SimpleText( self.price, "TargetIDSmall", 3, icon:GetTall() - 12, Color(255,255,255), TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
		end
	end

	self.icon.OnMousePressed = self.OnMousePressed

	self.itemcount = 0

	self:SetTall(64)
	self:SetText("")

	--self:SetPaintBackground(false)
end


--[[ function PANEL:OnCursorEntered()
	self:SetBackgroundColor(Color(150,150,150))
end

function PANEL:OnCursorExited()
	self:SetBackgroundColor(Color(100,100,100))
end ]]

AccessorFunc(PANEL, "itemcount", "Count")
AccessorFunc(PANEL, "price", "Price")

function PANEL:SetItemInfo(model, name, info)
	self._model = model
	self._name = name
	self._info = info

	self.icon:SetModel(model or "")
	self.icon:SetTooltip(name.."\n"..info)
end

function PANEL:GetItemInfo()
	return self._model, self._name, self._info
end

function PANEL:SetMenu(func)
	function self.icon:OnMousePressed(code)
		if func and code == MOUSE_RIGHT then
			func()
		end
	end
	self.icon.OpenMenu = func
end

function PANEL:SetClick(func)
	self.Click = func
end

function PANEL:OnMousePressed(code)
	if code == MOUSE_RIGHT and self.icon and self.icon.OpenMenu then
		self.icon.OpenMenu()
	elseif code == MOUSE_LEFT and self.Click then
		self.Click()
	end
end

--INVENTORY PANEL--

local g_ItemInventoryNew

local InventoryFrame = vgui.Register("msitems.newinv",{},"DFrame")

function InventoryFrame:Init()
	self:SetSize(750,300)
	self:SetPos(ScrW()/2-375,ScrH())
	self:SetTitle("Inventory")
	self:SetDraggable(false)

	self.msitems = {}

	self.Open = false
	self:MakeMove()

	self.btnMaxim:SetVisible(false)
	self.btnMinim:SetVisible(false)
	self.btnClose:SetSize(16,16)

	self.btnTheme = vgui.Create("DButton",self)
	self.btnTheme:SetSize(16,16)
	self.btnTheme:SetText("")

	self.btnTheme.DoClick = function()
		local menu = DermaMenu()
		menu:AddCVar("Dark Mode","ms_inv_dark",1)
		menu:AddCVar("Light Mode","ms_inv_dark",0)
		menu:Open()
	end

	self.btnTheme.Paint = function()
		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(icon.theme)
		surface.DrawTexturedRect(0,0,16,16)
	end

	self.btnClose.Paint = function(w,h)
		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(icon.close)
		surface.DrawTexturedRect(0,0,16,16)
	end

	self.equiped = vgui.Create("DPanel",self)
	self.equiped:Dock(TOP)
	self.equiped:SetTall(64)
	function self.equiped:Paint(w,h)
		local darkmode = GetConVar("ms_inv_dark"):GetInt()
		if darkmode == 1 then
			basecol = col.base_light
			textcol = color_white
		elseif darkmode == 0 then
			basecol = col.base_dark
			textcol = color_black
		end
		draw.RoundedBox(0,0,0,w,h,basecol)
	end

	self.equip_item = vgui.Create("SpawnIcon",self.equiped)
	self.equip_item:SetSize(64,64)
	self.equip_item:SetModel("")
	self.equip_item:Dock(LEFT)

	function self.equip_item:Paint(w,h)
		local darkmode = GetConVar("ms_inv_dark"):GetInt()
		if darkmode == 1 then
			titlecol = col.title_dark
			textcol = Color(255,255,255)
		elseif darkmode == 0 then
			titlecol = col.title_light
			textcol = Color(0,0,0)
		end
		draw.RoundedBox(0,0,0,w,h,titlecol)
	end

	self.ply_coins = vgui.Create("DLabel", self.equiped)
	self.ply_coins:Dock(BOTTOM)
	self.ply_coins:SetText(LocalPlayer():GetCoins() .. " Coins")
	self.ply_coins:SetColor(color_white)
	self.ply_coins:SizeToContents()
	self.ply_coins:SetMouseInputEnabled(true)
	self.ply_coins:DockMargin(4,0,0,0)

	self.ply_coins.OnMousePressed = function()
		Derma_StringRequest("Drop", "Type the amount of coins you would like to drop", "0", function(amount)
			RunConsoleCommand("drop_coins", amount)
		end)
	end

	self.equip_name = vgui.Create("DLabel",self.equiped)
	self.equip_name:Dock(TOP)
	self.equip_name:SetFont("chathud_chatprint")
	self.equip_name:SetText("None")
	self.equip_name:SetColor(color_white)
	self.equip_name:SizeToContents()
	self.equip_name:DockMargin(4,0,0,0)

	self.equip_info = vgui.Create("DLabel",self.equiped)
	self.equip_info:Dock(TOP)
	self.equip_info:SetText("You don't have any item currently selected.")
	self.equip_info:SetColor(color_white)
	self.equip_info:SizeToContents()
	self.equip_info:DockMargin(4,0,0,0)

	self.scroll = vgui.Create("DScrollPanel",self)
	self.scroll:Dock(FILL)
	self.scroll:DockMargin(0,4,0,0)

	self.item_list = vgui.Create("DIconLayout",self.scroll)
	self.item_list:Dock(FILL)
	self.item_list:SetSpaceX(2)
	self.item_list:SetSpaceY(2)
end

function InventoryFrame:MakeMove()
	local y = ScrH()-self:GetTall()

	if !self.Open then
		self:MoveTo((ScrW()/2)-(self:GetWide()/2),y,0.2,0,1)
		gui.EnableScreenClicker(true)
	else
		self:MoveTo((ScrW()/2)-(self:GetWide()/2),y+self:GetTall(),0.2,0,1)
		gui.EnableScreenClicker(false)

		self.Think = function()
			local xp, yp = self:GetPos()
			if yp == ScrH() then
				self:Close(true)
			end
		end
	end
	self.Open = !self.Open
end

function InventoryFrame:Close(internal_close)
	if not internal_close then
		self:MakeMove()
	else
		self:Remove()
	end
end

function InventoryFrame:PerformLayout()

	self.btnClose:SetPos(self:GetWide()-16-4,2)
	self.btnClose:SetSize(16,16)

	self.btnTheme:SetPos(self:GetWide()-16*2-4*2,2)
	self.btnTheme:SetSize(16,16)

	self.lblTitle:SetPos(20,0)
	self.lblTitle:SetSize(self:GetWide()-25,20)

end

function InventoryFrame:Paint(w,h)
	local darkmode = GetConVar("ms_inv_dark"):GetInt()
	if darkmode == 1 then
		titlecol = col.title_dark
		basecol = col.base_dark
		self.lblTitle:SetColor(Color(255,255,255))
	elseif darkmode == 0 then
		titlecol = col.title_light
		basecol = col.base_light
		self.lblTitle:SetColor(Color(0,0,0))
	end
	draw.RoundedBox(0,0,0,w,20,titlecol)
	draw.RoundedBox(0,0,20,w,h-20,basecol)
	surface.SetDrawColor(Color(255,255,255))
	surface.SetMaterial(icon.frame)
	surface.DrawTexturedRect(2,2,16,16)
end

function InventoryFrame:UpdateInventory()
	local inventory = LocalPlayer():GetInventory()
	for class, table in pairs(inventory) do

		if not table.data then table.data = msitems.GetItemDataFromClass(class) end

		if table.data then

			local item = self.msitems[class] or self.item_list:Add("msitems.itempnl")
			local text = msitems.GetInventoryInfo(class)

			item:SetCount(table.count)
			item:SetItemInfo(msitems.Get(class).WorldModel or blank, text.name, text.info)
			item:SetSize(64,64)
			item:SetMenu(function()
				local menu = DermaMenu()
				menu:SetPos(gui.MousePos())
				menu:AddOption("Equip", function()
					if IsValid(LocalPlayer():GetActiveItem()) then return end
					RunConsoleCommand("msitems", "equip", class)
					self:CheckCount(item, class, table)
				end)
				menu:AddOption("Drop", function()
					RunConsoleCommand("msitems", "drop", class)
					self:CheckCount(item, class, table)
				end)
			end)

			if not self.msitems[class] then
				self.item_list:Add(item)
			end

			self.msitems[class] = item

		end
	end
	self.item_list:Layout()
end

function InventoryFrame:SetEquiped(model, name, info, menu)
	self.equip_item:SetModel(model or "")
	self.equip_item:SetTooltip(name)

	function self.equip_item:OnMousePressed(code)
		if menu and code == MOUSE_RIGHT then
			menu()
		end
	end

	self.equip_name:SetText(name or "")
	self.equip_name:SizeToContents()

	self.equip_info:SetText(info or "")
	self.equip_info:SizeToContents()
end

function InventoryFrame:UpdateEquiped()
	local ply = LocalPlayer()
	local item = ply:GetActiveItem()
	if item then
		local data = item:GetInventoryInfo()
		self:SetEquiped(item.WorldModel, data.name, data.info, function()
			item:MakeMenu():SetPos(gui.MousePos())
		end)
	else
		self:SetEquiped(nil, "None", "You don't have any item currently selected.")
	end
end

function InventoryFrame:CheckCount(item, class, table)
	local inventory = LocalPlayer():GetInventory()

	item:SetCount(item:GetCount() - 1)

	if item:GetCount() < 1 then
		item:Remove()
		inventory[class] = nil
		self.msitems[class] = nil
	elseif IsValid(table.data.model) then
		table.data.model:Remove()
	end

end

function InventoryFrame:SetCoins(amount)
	self.ply_coins:SetText(amount.." Coins")
	self.ply_coins:SizeToContents()
end

function InventoryFrame:Think()
	DFrame.Think(self)
	if coins then self:SetCoins(LocalPlayer():GetCoins()) end
end

function msitems.UpdateInventory(class, count)
	if IsValid(g_ItemInventoryNew) then
		if class and count and g_ItemInventoryNew.msitems[class] and count < 1 then
			g_ItemInventoryNew.msitems[class]:Remove()
		end
		g_ItemInventoryNew:UpdateInventory()
	end
end

timer.Create("msitems.NewUpdateCurrentIcon", 0.2, 0, function()
	if IsValid(g_ItemInventoryNew) then g_ItemInventoryNew:UpdateEquiped() end
end)

local toggle = true

hook.Remove('PlayerBindPress',"gm_showspare1_NPCShop")

hook.Add('PlayerBindPress',"gm_showspare1_NPCShop",function(_,bind,pressed)
	if string.find(bind,"gm_showspare1",1,true) and pressed then
		RunConsoleCommand("items_toggle_new_inventory")
	end
end)

concommand.Add("items_toggle_new_inventory", function()
	if !IsValid(g_ItemInventoryNew) then
		g_ItemInventoryNew = vgui.Create("msitems.newinv")
		msitems.UpdateInventory()
		g_ItemInventoryNew:MakeMove()
	end
		g_ItemInventoryNew:MakeMove()
		msitems.UpdateInventory()
end)