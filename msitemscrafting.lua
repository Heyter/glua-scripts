CraftingMenu = vgui.Create("DFrame")
CraftingMenu:SetSize(1000,500)
CraftingMenu:SetTitle("Crafting Bench")
CraftingMenu:Center()
CraftingMenu:MakePopup()

local craft = vgui.Create("DPanel")
local plyinv = vgui.Create("DPanel")

local divider = vgui.Create("DHorizontalDivider",CraftingMenu)
divider:Dock(FILL)
divider:SetLeft(craft)
divider:SetRight(plyinv)
divider:SetLeftMin(500)
divider:SetRightMin(500)
divider:SetDividerWidth(4)
divider:SetLeftWidth(500)

function craft:Paint(w,h)
	derma.SkinHook("Paint","Frame",self,w,h)
	draw.SimpleText("Crafting","DermaDefault",5,5,derma.GetDefaultSkin().Colours.Window.TitleActive)
end

function plyinv:Paint(w,h)
	derma.SkinHook("Paint","Frame",self,w,h)
	draw.SimpleText("Inventory","DermaDefault",5,5,derma.GetDefaultSkin().Colours.Window.TitleActive)
end

local chead = vgui.Create("DPanel",craft)
chead:Dock(TOP)
chead:SetTall(24)
function chead:Paint() end

local ihead = vgui.Create("DPanel",plyinv)
ihead:Dock(TOP)
ihead:SetTall(24)
function ihead:Paint() end

local pilist = vgui.Create("DPanelList", plyinv)
pilist:Dock(TOP)
pilist:SetTall(440)
pilist:EnableHorizontal(false)
pilist:EnableVerticalScrollbar(true)
pilist:SetSpacing(0)

function pilist:PaintOver()
	surface.SetDrawColor( 150, 150, 150, 255 )
	surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
end

local inventory = LocalPlayer():GetInventory()
local plyinv_items = {}

local function CheckCount(item, class, table)
	local inventory = LocalPlayer():GetInventory()
/
	item:SetCount(item:GetCount() - 1)

	if item:GetCount() < 1 then
		item:Remove()
		inventory[class] = nil
		plyinv_items[class] = nil
	elseif IsValid(table.data.model) then
		table.data.model:Remove()
	end

end

for class, table in pairs(inventory) do

	if not table.data then table.data = msitems.GetItemDataFromClass(class) end

	if table.data then

		local item = plyinv_items[class] or vgui.Create("msitems.ItemPanel", plyinv)
		local text = msitems.GetInventoryInfo(class)

		item:SetCount(table.count)
		item:SetItemInfo(msitems.Get(class).WorldModel or blank, text.name, text.info)
		item:SetMenu(function()
			local menu = DermaMenu()
			menu:SetPos(gui.MousePos())
			menu:AddOption("Equip", function()
				if IsValid(LocalPlayer():GetActiveItem()) then return end
				RunConsoleCommand("msitems", "equip", class)
				CheckCount(item, class, table)
			end)
			menu:AddOption("Drop", function()
				RunConsoleCommand("msitems", "drop", class)
				CheckCount(item, class, table)
			end)
		end)

		if not plyinv_items[class] then
			pilist:AddItem(item)
		end

		plyinv_items[class] = item

	end
end