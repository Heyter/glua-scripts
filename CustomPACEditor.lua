local L = pace.LanguageString

local PANEL = {}

PANEL.ClassName = "editor"
PANEL.Base = "DFrame"
PANEL.menu_bar = NULL

local BAR_SIZE = 17
local RENDERSCORE_SIZE = 13

local use_tabs = CreateClientConVar("pac_property_tabs", 1, true)

function PANEL:Init()	
	--self:SetTitle("pac3 " .. L"editor")
	self:SetTitle("")
	self:SetSizable(true)
	self:ShowCloseButton(false)
	--self:DockPadding(2, 23, 2, 2)
	
	local div = vgui.Create("DVerticalDivider", self)
		div:SetDividerHeight(RENDERSCORE_SIZE)
		div:Dock(FILL)
		div:SetTopMin(0)
		div:SetCookieName("pac3_editor")
		div:SetTopHeight(ScrH()/1.4)
		div:LoadCookies()
	self.div = div
	
	self:SetTop(pace.CreatePanel("tree"))
	
	local pnl = pace.CreatePanel("properties", div)
	pace.properties = pnl
	
	self:SetBottom(pnl)
	
	self:SetCookieName("pac3_editor")
	self:SetPos(self:GetCookieNumber("x"), BAR_SIZE)
	
	self:MakeBar()
end

function PANEL:MakeBar()	
	if self.menu_bar:IsValid() then self.menu_bar:Remove() end

	local bar = vgui.Create("DMenuBar", self)
	bar:SetSize(self:GetWide(), BAR_SIZE)

	function bar:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
		surface.SetDrawColor(Color(0,150,130))
		surface.DrawOutlinedRect(0,0,w,h)
	end
	pace.Call("MenuBarPopulate", bar)
	pace.MenuBar = bar

	self.menu_bar = bar
	
	self:DockMargin(2,2,2,2)
	self:DockPadding(2,2,2,2)
end

function PANEL:OnRemove()
	if self.menu_bar:IsValid() then
		self.menu_bar:Remove()
	end
end

function PANEL:Think(...)
	DFrame.Think(self, ...)

	local bar = self.menu_bar
		
	self:SetTall(ScrH())
	local w = math.max(self:GetWide(), 200)
	self:SetWide(w)
	local x = self:GetPos()
	x = math.Clamp(x, 0, ScrW()-w)
	self:SetPos(x, 0)
		
	if x ~= self.last_x then
		self:SetCookie("x", x)
		self.last_x = x
	end
end

local auto_size = CreateClientConVar("pac_auto_size_properties", 1, true)

function PANEL:PerformLayout()
	DFrame.PerformLayout(self)

	self.div:InvalidateLayout()
	self.bottom:PerformLayout()
	pace.properties:PerformLayout()
	
	if auto_size:GetBool() then
		self.div:SetTopHeight(ScrH() - math.min(pace.properties:GetHeight() + RENDERSCORE_SIZE + BAR_SIZE - 6, ScrH() / 1.5))
	end
end

function PANEL:SetTop(pnl)
	self.top = pnl
	self.div:SetTop(pnl)
end

function PANEL:SetBottom(pnl)
	self.bottom = pnl
	self.div:SetBottom(pnl)
end

pace.Focused = true

function pace.IsFocused()
	return pace.Focused
end

function pace.GainFocus(show_editor)
	local self = pace.Editor
	if self:IsValid() then
		if self.allowclick ~= false then
			self:MakePopup()
			pace.Focused = true
			if not show_editor then
				self:AlphaTo(255, 0.1, 0)
			end
		end
	end
end

function pace.KillFocus(show_editor)
	local self = pace.Editor
	if self:IsValid() then
		self:KillFocus()
		self:SetMouseInputEnabled(false)
		self:SetKeyBoardInputEnabled(false)
		gui.EnableScreenClicker(false)
		pace.Focused = false
		
		if not show_editor then
			self:AlphaTo(0, 0.1, 0)
		end
		
		self.allowclick = false

		timer.Simple(0.2, function()
			if self:IsValid() then
				self.allowclick = true
			end
		end)
	end
end

local blur = Material("pp/blurscreen")

function PANEL:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
	surface.SetDrawColor(Color(255, 255, 255))
	surface.SetMaterial(blur)

	for i = 1, 2 do
		blur:SetFloat("$blur", (i / 3) * 6)
		blur:Recompute()

		render.UpdateScreenEffectTexture()

		render.SetScissorRect(0, 0, 0 + w, 0 + h, true)
			surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(),ScrH())
		render.SetScissorRect(0, 0, 0, 0, false)
	end
end

function PANEL:PaintOver(w, h)
	local renderTime = pace.RenderTimes and pace.RenderTimes[LocalPlayer():EntIndex()]
	
	if renderTime then
		local x, y = self.top:LocalToScreen()
		y = y + self.top:GetTall()
		
		local str = string.format("%s: %.3f ms", L("average render time"), renderTime * 1000)
		local _w, _h = surface.GetTextSize(str)

		cam.IgnoreZ(true)
		surface.SetDrawColor(0,0,0,0)
		surface.DrawRect(x, y, w-5, RENDERSCORE_SIZE-1)
		
		surface.SetFont(pace.CurrentFont)
		surface.SetTextColor(200,100,100)
		surface.SetTextPos(x+5, y)
		surface.DrawText(str)
		cam.IgnoreZ(false)
	end
end

pace.RegisterPanel(PANEL)

local function SHOW_SPECIAL(pnl, parent, size)
	size = size or 150
	
	pnl:SetPos(pace.Editor:GetWide(), select(2, parent:LocalToScreen()) - size + 25)
	pnl:SetSize(size, size)
	pnl:MakePopup()		
end

local function FIX_MENU(menu)
	menu:SetMaxHeight(500)
	menu:InvalidateLayout(true, true)
	menu:SetPos(pace.Editor:GetPos() + pace.Editor:GetWide(), gui.MouseY() - (menu:GetTall() * 0.5))
end

local function populate_part_menu(menu, part, func)
	if part:HasChildren() then
		local menu, pnl = menu:AddSubMenu(part:GetName(), function()
			pace.current_part[func](pace.current_part, part)
		end)
		
		pnl:SetImage(pace.GetIconFromClassName(part.ClassName))
		
		for key, part in pairs(part:GetChildren()) do
			populate_part_menu(menu, part, func)
		end
	else
		menu:AddOption(part:GetName(), function()
			pace.current_part[func](pace.current_part, part)
		end):SetImage(pace.GetIconFromClassName(part.ClassName))
	end
end

pace.ActiveSpecialPanel = NULL
pace.extra_populates = {}

function pace.SafeRemoveSpecialPanel()
	if pace.ActiveSpecialPanel:IsValid() then
		pace.ActiveSpecialPanel:Remove()
	end
end

hook.Add("GUIMousePressed", "pace_SafeRemoveSpecialPanel", function()
	local pnl = pace.ActiveSpecialPanel
	if pnl:IsValid() then
		local x,y = gui.MousePos()
		local _x, _y = pnl:GetPos()
		if x < _x or y < _y or x > _x + pnl:GetWide() or y > _y + pnl:GetTall() then
			pnl:Remove()
		end
	end
end)

do -- container
	local PANEL = {}

	PANEL.ClassName = "properties_container"
	PANEL.Base = "DPanel"

	function PANEL:Paint(w, h)
		--self:GetSkin().tex.MenuBG(0, 0, w + (self.right and -1 or 3), h + 1)
		if not self.right then		
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w+5,h)
			surface.SetDrawColor(Color(0,150,130))
			surface.DrawOutlinedRect(0,0,w+5,h+2)
		else
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(0,0,w,h)
			
			if self.vector_type == "color" then
				surface.SetDrawColor(self.vector.x, self.vector.y, self.vector.z)
				surface.DrawRect(w-30,0,15,h)
			end
			
			surface.SetDrawColor(Color(0,150,130))
			surface.DrawOutlinedRect(0,0,w,h+2)
		end
	end

	function PANEL:SetContent(pnl)
		pnl:SetParent(self)
		self.content = pnl
	end

	function PANEL:PerformLayout()
		local pnl = self.content or NULL
		if pnl:IsValid() then
			pnl:SetPos(0, 0)
			pnl:SetSize(self:GetSize())
		end
	end

	pace.RegisterPanel(PANEL)
end

do -- list
	local PANEL = {}

	PANEL.ClassName = "properties"
	PANEL.Base = "Panel"

	AccessorFunc(PANEL, "item_height", "ItemHeight")

	function PANEL:Init()
		self.List = {}
				
		local divider = vgui.Create("DHorizontalDivider", self)
		local left = vgui.Create("DPanelList", divider)
			divider:SetLeft(left)
		self.left = left

		local right = vgui.Create("DPanelList", divider)
			divider:SetRight(right)
		self.right = right

		divider:SetDividerWidth(3)
		divider:SetLeftWidth(110)
		
		surface.SetFont(pace.CurrentFont)
		local w,h = surface.GetTextSize("W")
		local size = h + 2
		
		self:SetItemHeight(size)
				
		self.div = divider
		
		function divider:PerformLayout()
			DHorizontalDivider.PerformLayout(self)
			
			if self.m_pLeft then
				self.m_pLeft:SetWide( self.m_iLeftWidth + self.m_iDividerWidth )
			end
		end
		
		local scroll = vgui.Create("DVScrollBar", self)
		scroll:Dock(RIGHT)
		self.scr = scroll
		
		left.OnMouseWheeled = function(_, delta) scroll:OnMouseWheeled(delta) end
		--right.OnMouseWheeled = function(_, delta) scroll:OnMouseWheeled(delta) end
	end
	
	function PANEL:Paint(w, h)
		h = self:GetHeight()
		surface.SetDrawColor(Color(0,150,130))
		surface.DrawOutlinedRect(0,0,w,h-9)
	end

	function PANEL:GetHeight(hack)
		return (self.item_height * (#self.List+(hack or 1))) - (self.div:GetDividerWidth() + 1)
	end

	function PANEL:FixHeight()
		for key, data in pairs(self.List) do
			data.left:SetTall(self:GetItemHeight())
			data.right:SetTall(self:GetItemHeight())
		end
	end
	
	function PANEL:PerformLayout()
		self.scr:SetSize(10, self:GetHeight())
		self.scr:SetUp(self:GetTall(), self:GetHeight() - 10)
		self.div:SetPos(0,self.scr:GetOffset())
		local w, h = self:GetSize()
		self.div:SetSize(w - (self.scr.Enabled and self.scr:GetWide() or 0), self:GetHeight())
	end
	
	pace.CollapsedProperties = pac.luadata.ReadFile("pac3_editor/collapsed.txt") or {}

	local blur = Material("pp/blurscreen")
	
	function PANEL:AddCollapser(name)
		local left = vgui.Create("DButton", self)
		left:SetText("")
		self.left:AddItem(left)
		
		left.DoClick = function()
			pace.CollapsedProperties[name] = not pace.CollapsedProperties[name]
			pace.PopulateProperties(pace.current_part)
					
			pace.Editor:InvalidateLayout()	
			pac.luadata.WriteFile("pac3_editor/collapsed.txt", pace.CollapsedProperties)
		end
		
		local right = vgui.Create("DButton", self)
		right:SetText("")
		self.right:AddItem(right)
		
		right.DoClick = left.DoClick
		
		left.Paint = function(_, w, h)
			--draw.RoundedBox(0,0,0,w,h,Color(0,0,0,200))
			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(blur)

			for i = 1, 1 do
				blur:SetFloat("$blur", (i / 3) * 6)
				blur:Recompute()

				render.UpdateScreenEffectTexture()

				render.SetScissorRect(0, 0, 0 + w, 0 + h, true)
					surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(),ScrH())
				render.SetScissorRect(0, 0, 0, 0, false)
			end
			
			local txt = L(name)
			local _, _h = surface.GetTextSize(txt)
			local middle = h/2 - _h/2
			
			surface.SetTextPos(11, middle)
			surface.SetTextColor(Color(0,150,130))
			surface.SetFont(pace.CurrentFont)
			surface.DrawText(txt)
			
			local txt = (pace.CollapsedProperties[name] and "+" or "-")
			local w = surface.GetTextSize(txt)
			surface.SetTextPos(6-w*0.5,middle)
			surface.DrawText(txt)
		end
		
		right.Paint = function(_,w,h)
			surface.SetDrawColor(Color(255, 255, 255))
			surface.SetMaterial(blur)

			for i = 1, 1 do
				blur:SetFloat("$blur", (i / 3) * 6)
				blur:Recompute()

				render.UpdateScreenEffectTexture()

				render.SetScissorRect(0, 0, 0 + w, 0 + h, true)
					surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(),ScrH())
				render.SetScissorRect(0, 0, 0, 0, false)
			end
		end
		
		table.insert(self.List, {left = left, right = right, panel = var, key = key})
	end

	function PANEL:AddKeyValue(key, var, pos, obj)
		local btn = pace.CreatePanel("properties_label")
			btn:SetValue(" " .. L(key:gsub("%u", " %1"):lower()))
			btn.pac3_sort_pos = pos
			
			if obj then
				btn.key_name = key
				btn.part_namepart_name = obj.ClassName
			end
			
		self.left:AddItem(btn)

		local pnl = pace.CreatePanel("properties_container")
		pnl.right = true
		
		if type(var) == "Panel" then
			pnl:SetContent(var)
		end
		
		pnl.pac3_sort_pos = pos
		self.right:AddItem(pnl)

		table.insert(self.List, {left = btn, right = pnl, panel = var, key = key})
	end

	function PANEL:Clear()
		for key, data in pairs(self.List) do
			data.left:Remove()
			data.right:Remove()
		end
		
		self.left:Clear()
		self.right:Clear()

		self.List = {}
	end

	function PANEL:Populate(obj, dont_clear, group_override)	
		if dont_clear == nil then self:Clear() end

		local tbl = {}
		local data = {}		
		
		for key, val in pairs(obj.ClassName and obj:GetVars() or obj) do
			local callback
			if not obj.ClassName then
				callback = val.callback
				val = val.val
			end		
							
			if not obj.ClassName or (not pace.HiddenPropertyKeys[key] or pace.HiddenPropertyKeys[key] == obj.ClassName) and not pace.ShouldHideProperty(key) then
				local group = pace.ReversedPropertySheets[key:lower()]
				if group == nil then group = L"generic" end
				
				if pace.PropertySheets[obj.ClassName] then
					local reversed = {}
					for group, properties in pairs(pace.PropertySheets[obj.ClassName]) do
						for k,v in pairs(properties) do
							reversed[k] = group
						end
					end
					
					group = reversed[key:lower()]
					if group == nil then group = L"generic" end
				end
				
				if pace.PropertySheetPatterns[obj.ClassName] then
					for _group, pattern in pairs(pace.PropertySheetPatterns[obj.ClassName]) do
						local found
						
						if type(pattern) == "table" then
							for k,v in pairs(pattern) do 
								if key:lower():find(v) then
									found = true
									break
								end
							end
						else
							found = key:lower():find(pattern)
						end
						
						if found then
							group = _group
						end
					end
				end
										
				table.insert(data, {key = key, val = val, group = group_override or group, callback = callback})
			end
		end
		
		table.sort(data, function(a,b) return a.key > b.key end)
		
		local ordered_list = {}
		
		for k,v in pairs(pace.PropertyOrder) do table.insert(ordered_list, v) end
		for k,v in pairs(pac.VariableOrder) do table.insert(ordered_list, v) end
		
		local sorted_sheets = {}
		table.insert(sorted_sheets, "generic")
		
		if pace.PropertySheetPatterns[obj.ClassName] then
			for k,v in pairs(pace.PropertySheetPatterns[obj.ClassName]) do
				table.insert(sorted_sheets, k)
			end
		end
		
		if pace.PropertySheets[obj.ClassName] then
			for k,v in pairs(pace.PropertySheets[obj.ClassName]) do
				table.insert(sorted_sheets, k)
			end
		end
		
		for k,v in pairs(pace.PropertySheets) do
			table.insert(sorted_sheets, k)
		end
		
		for _, group in pairs(sorted_sheets) do
			for pos, str in pairs(ordered_list) do
				for i, val in pairs(data) do
					if val.key == str and val.group == group then
						table.insert(tbl, {pos = pos, key = val.key, val = val.val, group = val.group, callback = val.callback})
						table.remove(data, i)
					end
				end
			end
		end

		for pos, val in pairs(data) do
			table.insert(tbl, {pos = pos, key = val.key, val = val.val, group = val.group, callback = val.callback})
		end
				
		local current_group = nil

		for pos, data in pairs(tbl) do		
			local key, val = data.key, data.val

			if obj.ClassName then
				if pace.IsInBasicMode() and not pace.BasicProperties[key] then continue end
				
				if not pace.IsShowingDeprecatedFeatures() then
					local part = pace.DeprecatedProperties[key]
					if part == true or part == obj.ClassName then
						continue
					end
				end
			end

			local pnl
			local T = (pace.TranslatePropertiesKey(key, obj) or type(val)):lower()

			if pace.PanelExists("properties_" .. T) then
			
				if data.group and data.group ~= current_group then
					self:AddCollapser(data.group)
					current_group = data.group
				end
			
				if pace.CollapsedProperties[data.group] ~= nil and pace.CollapsedProperties[data.group] then continue end
			
				pnl = pace.CreatePanel("properties_" .. T)
			end
			
			if pnl then
				if obj.ClassName then
					
					if pnl.ExtraPopulate then
						table.insert(pace.extra_populates, pnl.ExtraPopulate)
						pnl:Remove()
						continue
					end
				
					pnl.CurrentKey = key
					obj.editor_pnl = pnl
					
					local val = obj["Get" .. key](obj)
					pnl:SetValue(val)
					pnl.LimitValue = pace.PropertyLimits[key]
					
					pnl.OnValueChanged = function(val)
						if T == "number" then
							val = tonumber(val) or 0
						elseif T == "string" then
							val = tostring(val)
						end
						pace.Call("VariableChanged", obj, key, val)
					end
					
					self:AddKeyValue(key, pnl, pos, obj)
				else
					pnl.CurrentKey = key
					pnl:SetValue(val)
					pnl.LimitValue = pace.PropertyLimits[key]
					pnl.OnValueChanged = data.callback
					self:AddKeyValue(key, pnl, pos)
				end
			end
		end
		
		self:FixHeight()
	end
	
	
	function PANEL:PopulateCustom(obj)
		self:Clear()

		local tbl = {}
		local data = {}
		
		for key, val in pairs(obj) do
			table.insert(data, {key = key, val = val.val, callback = val.callback})
		end
		
		table.sort(data, function(a,b) return a.key > b.key end)
		
		for pos, str in pairs(pace.PropertyOrder) do
			for i, val in pairs(data) do
				if val.key == str then
					table.insert(tbl, {pos = pos, key = val.key, val = val.val, callback = val.callback})
					table.remove(data, i)
				end
			end
		end

		for pos, val in pairs(data) do
			table.insert(tbl, {pos = pos, key = val.key, val = val.val, callback = val.callback})
		end
				
		for pos, data in pairs(tbl) do
			local key, val = data.key, data.val

			local pnl
			local T = (pace.TranslatePropertiesKey(key, obj) or type(val)):lower()
			
			if pace.PanelExists("properties_" .. T) then
				pnl = pace.CreatePanel("properties_" .. T)
			end

			if pnl then	
				pnl.CurrentKey = key
				pnl:SetValue(val)
				pnl.LimitValue = pace.PropertyLimits[key]
				pnl.OnValueChanged = data.callback
				self:AddItem(key, pnl, pos)
			end
		end
		
		self:FixHeight()
	end

	pace.RegisterPanel(PANEL)
end

do -- non editable string
	local DTooltip = _G.DTooltip
	if DTooltip and DTooltip.PositionTooltip then
		pace_Old_PositionTooltip = pace_Old_PositionTooltip or DTooltip.PositionTooltip
		function DTooltip.PositionTooltip(self, ...)
			if self.TargetPanel.pac_tooltip_hack then
				local args = {pace_Old_PositionTooltip(self, ...)}
									
				if ( !IsValid( self.TargetPanel ) ) then
					self:Remove()
					return;
				end

				self:PerformLayout()
				
				local x, y		= input.GetCursorPos()
				local w, h		= self:GetSize()
				
				local lx, ly	= self.TargetPanel:LocalToScreen( 0, 0 )
								
				y = math.min( y, ly - h )
				
				self:SetPos( x, y )
							
				
				return unpack(args)
			end
			
			return pace_Old_PositionTooltip(self, ...)
		end
	end
	

	local PANEL = {}

	PANEL.ClassName = "properties_label"
	PANEL.Base = "pace_properties_container"

	function PANEL:SetValue(str)
		local lbl = vgui.Create("DLabel")
			lbl:SetTextColor(Color(0,150,130))
			lbl:SetFont(pace.CurrentFont)
			lbl:SetText("  " .. str) -- ugh
			lbl:SizeToContents()
			lbl.pac_tooltip_hack = true
		self:SetContent(lbl)
		
		if self.part_name and self.key_name then
			lbl.OnCursorEntered = function() 
				
				if lbl.wiki_info then
					lbl:SetTooltip(lbl.wiki_info)
					return
				end
			
				if not lbl.fetching_wiki then
					lbl:SetCursor("waitarrow")
					pace.GetPropertyDescription(self.part_name, self.key_name, function(str)
						if lbl:IsValid() then
							lbl:SetTooltip(str)
							ChangeTooltip(lbl)
							lbl.wiki_info = str
							lbl:SetCursor("arrow")
						end
					end)
					lbl.fetching_wiki = true
				end	
			end
		end
	end

	pace.RegisterPanel(PANEL)
end

do -- base editable
	local PANEL = {}

	PANEL.ClassName = "properties_base_type"
	PANEL.Base = "DLabel"
	
	PANEL.SingleClick = true
	
	function PANEL:OnCursorMoved()
		self:SetCursor("hand")
	end
	
	function PANEL:Init(...)
		timer.Simple(0,function()
			if self.SpecialCallback then
				local btn = vgui.Create("DButton", self)
				btn:SetSize(16, 16)
				btn:Dock(RIGHT)
				btn:SetText("...")
				btn.DoClick = function() self:SpecialCallback(self.CurrentKey) end
				btn.DoRightClick = self.SpecialCallback2 and function() self:SpecialCallback2(self.CurrentKey) end or btn.DoClick
			end
		end)
		
		if DLabel and DLabel.Init then
			return DLabel.Init(self, ...)
		end
	end

	function PANEL:SetValue(var, skip_encode)
		if self.editing then return end

		local str = tostring(skip_encode and var or self:Encode(var))
		
		self:SetTextColor(Color(0,150,130))
		self:SetFont(pace.CurrentFont)
		self:SetText("  " .. str) -- ugh
		self:SizeToContents()

		if #str > 10 then
			self:SetTooltip(str)
		end

		self.original_str = str
		self.original_var = var
	end
	
	-- kind of a hack
	local last_focus = NULL

	function PANEL:OnMousePressed(mcode)	
		if last_focus:IsValid() then
			last_focus:Reset()
			last_focus = NULL
		end	
				
		if mcode == MOUSE_LEFT then
			--if input.IsKeyDown(KEY_R) then
			--	self:Restart()
			--else
				self.MousePressing = true
				if self:MousePress(true) == false then return end
				if self.SingleClick or (self.last_press or 0) > RealTime() then
					self:EditText()
					self:DoubleClick()
					self.last_press = 0
					
					last_focus = self
				else
					self.last_press = RealTime() + 0.2
				end
			--end
		end
		
		if mcode == MOUSE_RIGHT then
			local menu = DermaMenu()
			menu:SetPos(gui.MousePos())
			menu:MakePopup()
			self:PopulateContextMenu(menu)
		end
	end

	function PANEL:PopulateContextMenu(menu)
		menu:AddOption(L"copy", function()
			pace.clipboard = pac.class.Copy(self:GetValue())
		end):SetImage(pace.MiscIcons.copy)
		menu:AddOption(L"paste", function()
			self:SetValue(pac.class.Copy(pace.clipboard))
			self.OnValueChanged(self:GetValue())
		end):SetImage(pace.MiscIcons.paste)
		menu:AddSpacer()
		menu:AddOption(L"reset", function()
			if pace.current_part and pace.current_part.DefaultVars[self.CurrentKey] then
				self:SetValue(pac.class.Copy(pace.current_part.DefaultVars[self.CurrentKey]))
			end
		end):SetImage(pace.MiscIcons.clear)
	end
	
	function PANEL:OnMouseReleased()
		self:MousePress(false)
		self.MousePressing = false
	end

	function PANEL:IsMouseDown()
		if not input.IsMouseDown(MOUSE_LEFT) then
			self.MousePressing = false
		end
		return self.MousePressing
	end

	function PANEL:DoubleClick()

	end
	
	function PANEL:MousePress()

	end
	
	function PANEL:Restart()
		self:SetValue(self:Decode(""))
		self.OnValueChanged(self:Decode(""))
	end

	function PANEL:EditText()		
		self:SetText("")
		
		local pnl = vgui.Create("DTextEntry", self)
		self.editing = pnl
		pnl:SetFont(pace.CurrentFont)
		pnl:SetDrawBackground(false)
		pnl:SetDrawBorder(false)
		pnl:SetValue(self.original_str or "")
		pnl:SetKeyboardInputEnabled(true)
		pnl:RequestFocus()
		pnl:SelectAllOnFocus(true)
		
		local x,y = pnl:GetPos()
		pnl:SetPos(x+3,y-4)
		pnl:Dock(FILL)
				
		pnl.OnEnter = function()
			pace.BusyWithProperties = NULL
			self.editing = false
			
			pnl:Remove()
			
			self:SetValue(pnl:GetValue() or "", true)
			self.OnValueChanged(self:Decode(pnl:GetValue()))
		end
		
		pace.BusyWithProperties = pnl
	end
	
	pace.BusyWithProperties = NULL
	
	local function click()
		if not input.IsMouseDown(MOUSE_LEFT) then return end
		local pnl = pace.BusyWithProperties
		if pnl and pnl ~= true and pnl:IsValid() then
			local x, y = gui.MousePos()
			local _x, _y = pnl:GetParent():LocalToScreen()
			if x < _x or y < _y or x > _x + pnl:GetParent():GetWide() or y > _y + pnl:GetParent():GetTall() then
				pnl:OnEnter()
			end
		end
	end
	
	hook.Add("GUIMousePressed", "pace_property_text_edit", click)
	hook.Add("VGUIMousePressed", "pace_property_text_edit", click)
	
	function PANEL:Reset()
		if IsValid(self.editing) then
			self.editing:OnEnter()
			self.editing = false
		else
			self:SetValue(self.original_var)
			self.OnValueChanged(self.original_var)
		end
	end

	function PANEL:GetValue()
		return self.original_var
	end

	function PANEL:Encode(var)
		return var
	end

	function PANEL:Decode(var)
		return var
	end

	function PANEL:PerformLayout()
		self:SetSize(self:GetParent():GetSize())
	end

	pace.RegisterPanel(PANEL)
end

do -- string
	local PANEL = {}

	PANEL.ClassName = "properties_string"
	PANEL.Base = "pace_properties_base_type"
	
	PANEL.SingleClick = true
	
	pace.RegisterPanel(PANEL)
end

do -- vector
	local function VECTOR(ctor, type, arg1, arg2, arg3, encode, special_callback, sens)
		local PANEL = {}

		PANEL.ClassName = "properties_" .. type
		PANEL.Base = "pace_properties_container"

		PANEL.vector_type = type
		
		function PANEL:Init(...)
			self.vector = ctor(0,0,0)

			local left = pace.CreatePanel("properties_number", self)
			local middle = pace.CreatePanel("properties_number", self)
			local right = pace.CreatePanel("properties_number", self)
			
			left.PopulateContextMenu = function(_, menu) self:PopulateContextMenu(menu) end
			middle.PopulateContextMenu = function(_, menu) self:PopulateContextMenu(menu) end
			right.PopulateContextMenu = function(_, menu) self:PopulateContextMenu(menu) end
			
			if encode then
				left.Encode = encode
				middle.Encode = encode
				right.Encode = encode
			end
			
			if sens then
				left.sens = sens
				middle.sens = sens
				right.sens = sens
			end
			
			left:SetMouseInputEnabled(true)
			left.OnValueChanged = function(num)			
				self.vector[arg1] = num
				
				if input.IsKeyDown(KEY_R) then
					self:Restart()
				elseif input.IsKeyDown(KEY_LSHIFT) then
					middle:SetValue(num)
					self.vector[arg2] = num
					
					right:SetValue(num)
					self.vector[arg3] = num
				end
				
				self.OnValueChanged(self.vector)
				self:InvalidateLayout()
			end

			middle:SetMouseInputEnabled(true)
			middle.OnValueChanged = function(num)			
				self.vector[arg2] = num
				
				if input.IsKeyDown(KEY_R) then
					self:Restart()
				elseif input.IsKeyDown(KEY_LSHIFT) then
					left:SetValue(num)
					self.vector[arg1] = num
					
					right:SetValue(num)
					self.vector[arg3] = num
				end
				
				self.OnValueChanged(self.vector)
				self:InvalidateLayout()
			end

			right:SetMouseInputEnabled(true)
			right.OnValueChanged = function(num)				
				self.vector[arg3] = num
				
				if input.IsKeyDown(KEY_R) then
					self:Restart()
				elseif input.IsKeyDown(KEY_LSHIFT) then
					middle:SetValue(num)
					self.vector[arg2] = num
					
					left:SetValue(num)
					self.vector[arg1] = num
				end
				
				self.OnValueChanged(self.vector)
				self:InvalidateLayout()
			end

			left:SetPaintBorderEnabled(true)
			middle:SetPaintBorderEnabled(true)
			right:SetPaintBorderEnabled(true)

			self.left = left
			self.middle = middle
			self.right = right
			
			timer.Simple(0,function()
				if self.SpecialCallback then
					local btn = vgui.Create("DButton", self)
					btn:SetSize(16, 16)
					btn:Dock(RIGHT)
					btn:SetText("...")
					btn.DoClick = function() self:SpecialCallback() end
					btn.DoRightClick = self.SpecialCallback2 and function() self:SpecialCallback2(self.CurrentKey) end or btn.DoClick
				end
			end)
		end
		
		PANEL.SpecialCallback = special_callback		
		
		function PANEL:Restart()
			self.left:SetValue(0)
			self.middle:SetValue(0)
			self.right:SetValue(0)
			
			self.OnValueChanged(self.vector)
		end
		
		function PANEL:PopulateContextMenu(menu)
			menu:AddOption(L"copy", function()
				pace.clipboard = pac.class.Copy(self.vector)
			end):SetImage(pace.MiscIcons.copy)	
			menu:AddOption(L"paste", function()
				local val = pac.class.Copy(pace.clipboard)
				if _G.type(val) == "number" then
					val = ctor(val, val, val)
				elseif _G.type(val) == "Vector" and type == "angle" then
					val = ctor(val.x, val.y, val.z)
				elseif _G.type(val) == "Angle" and type == "vector" then
					val = ctor(val.p, val.y, val.r)
				end
				
				if _G.type(val):lower() == type or type == "color" then
					self:SetValue(val)
					
					self.OnValueChanged(self.vector)
				end
			end):SetImage(pace.MiscIcons.paste)
			menu:AddSpacer()
			menu:AddOption(L"reset", function()
				if pace.current_part and pace.current_part.DefaultVars[self.CurrentKey] then
					self:SetValue(pac.class.Copy(pace.current_part.DefaultVars[self.CurrentKey]))
				end
			end):SetImage(pace.MiscIcons.clear)
		end

		function PANEL:SetValue(vec)
			self.vector = vec

			self.left:SetValue(math.Round(vec[arg1], 4))
			self.middle:SetValue(math.Round(vec[arg2], 4))
			self.right:SetValue(math.Round(vec[arg3], 4))
		end

		function PANEL:PerformLayout()
			self.left:SizeToContents()
			self.left:SetWide(math.max(self.left:GetWide(), 22))
			
			self.middle:SizeToContents()
			self.middle:SetWide(math.max(self.middle:GetWide(), 22))
			
			self.right:SizeToContents()
			self.right:SetWide(math.max(self.right:GetWide(), 22))

			self.middle:MoveRightOf(self.left, 10)
			self.right:MoveRightOf(self.middle, 10)
		end
		
		function PANEL:OnValueChanged(vec)
		end

		pace.RegisterPanel(PANEL)
	end

	VECTOR(Vector, "vector", "x", "y", "z")
	VECTOR(Angle, "angle", "p", "y", "r")
	VECTOR(Vector, "color", "x", "y", "z", 
		function(_, num)		
			num = tonumber(num) or 0
	
			num = math.Round(num) 
			num = math.Clamp(num, 0, 255) 

			return tostring(num)
		end, 
		
		function(self)
			pace.SafeRemoveSpecialPanel()
			
			local frm = vgui.Create("DFrame")
			frm:SetTitle("color")
			
			SHOW_SPECIAL(frm, self, 300)
			
			local clr = vgui.Create("DColorMixer", frm)
			clr:Dock(FILL)
			clr:SetColor(Color(self.vector.x, self.vector.y, self.vector.z))
			
			local function tohex(vec)
				return ("#%X%X%X"):format(vec.x, vec.y, vec.z)
			end
			
			local function fromhex(str)
				local x,y,z = str:match("#?(..)(..)(..)")
				return Vector(tonumber("0x" .. x), tonumber("0x" .. y), tonumber("0x" .. z))
			end
			
			local html_color = vgui.Create("DTextEntry", frm)
			html_color:Dock(BOTTOM)
			html_color:SetText(tohex(self.vector))
			html_color.OnEnter = function() 
				local vec = fromhex(html_color:GetValue())
				clr:SetColor(Color(vec.x, vec.y, vec.z))
				self.OnValueChanged(vec)
				self:SetValue(vec)
			end
			
			function clr.Think()
				local clr = clr:GetColor() or Color(255, 255, 255, 255)
				local vec = Vector(clr.r, clr.g, clr.b)
				self.OnValueChanged(vec)
				self:SetValue(vec)
				html_color:SetText(tohex(vec))
			end
			
			pace.ActiveSpecialPanel = frm
		end,
		10
	)
end

do -- number
	local PANEL = {}

	PANEL.ClassName = "properties_number"
	PANEL.Base = "pace_properties_base_type"
	
	PANEL.sens = 1
	
	PANEL.SingleClick = false
	
	function PANEL:MousePress(bool)
		if bool then
			self.mousey = gui.MouseY()
			self.mousex = gui.MouseX()
			self.oldval = tonumber(self:GetValue()) or 0
		else
			self.mousey = nil
		end
	end
	
	function PANEL:OnCursorMoved()
		self:SetCursor("sizens")
	end
	
	function PANEL:SetNumberValue(val)		
		if self.LimitValue then
			val = self:LimitValue(val) or val
		end
		
		val = self:Encode(val)
		self:SetValue(val)
		self.OnValueChanged(tonumber(val))
	end
	
	function PANEL:OnMouseWheeled(delta)
		if not input.IsKeyDown(KEY_LCONTROL) then delta = delta / 10 end
		if input.IsKeyDown(KEY_LALT) then delta = delta / 10 end 
		local val = self:GetValue() + (delta * self.sens)
		
		self:SetNumberValue(val)
	end

	function PANEL:Think()
		self:SetFGColor(0,150,130,255) -- gmod update fix: no idea
		
		if self:IsMouseDown() then			
			local sens = self.sens
			
			if input.IsKeyDown(KEY_LALT) then
				sens = sens / 10
			end
			
			local delta = (self.mousey - gui.MouseY()) / 10
			local val = (self.oldval or 0) + (delta * sens)
			
			self:SetNumberValue(val)
			
			if gui.MouseY()+1 >= ScrH() then
				self.mousey = 0
				self.oldval = val
				gui.SetMousePos(gui.MouseX(), 0)
			elseif gui.MouseY() <= 0 then
				self.mousey = ScrH()
				self.oldval = val
				gui.SetMousePos(gui.MouseX(), ScrH())
			end
		end
	end

	function PANEL:Encode(num)
		num = tonumber(num) or 0
		
		num = math.Round(num, 3)
		
		if input.IsKeyDown(KEY_LCONTROL) then
			num = math.Round(num)
		end
		
		return num
	end

	function PANEL:Decode(str)
		return tonumber(str) or 0
	end

	pace.RegisterPanel(PANEL)
end

do -- boolean
	local PANEL = {}

	PANEL.ClassName = "properties_boolean"
	PANEL.Base = "pace_properties_container"

	function PANEL:Init()
		local chck = vgui.Create("DCheckBox", self)
		chck.OnChange = function() 
			local b = chck:GetChecked()
			self.OnValueChanged(b) 
			self.lbl:SetText(L(tostring(b)))
		end
		self.chck = chck
		
		local lbl = vgui.Create("DLabel", self)
		lbl:SetFont(pace.CurrentFont)
		lbl:SetTextColor(Color(0,150,130))
		self.lbl = lbl
	end

	function PANEL:Paint() end
	
	function PANEL:SetValue(b)
		self.chck:SetChecked(b)
		self.chck:Toggle()
		self.chck:Toggle()
		self.lbl:SetText(L(tostring(b)))
	end

	function PANEL:OnValueChanged()

	end

	function PANEL:PerformLayout()
		self.BaseClass.PerformLayout(self)
		
		local s = 4
		
		self.chck:SetPos(s*0.5, s*0.5+1)
		self.chck:SetSize(self:GetTall()-s, self:GetTall()-s)

		self.lbl:MoveRightOf(self.chck, 5)
		self.lbl:CenterVertical()
		local w,h = self:GetParent():GetSize()
		self:SetSize(w-2,h)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- bone
	local PANEL = {}

	PANEL.ClassName = "properties_bone"
	PANEL.Base = "pace_properties_base_type"
	
	function PANEL:SpecialCallback()
		pace.SelectBone(pace.current_part:GetOwner(), function(data)
			self:SetValue(L(data.friendly))
			self.OnValueChanged(data.friendly)
		end)
	end
	
	function PANEL:SpecialCallback2()
		local bones = pac.GetModelBones(pace.current_part:GetOwner())
		
		local menu = DermaMenu()
		
		menu:MakePopup()
		
		bones = table.ClearKeys(bones)
		table.sort(bones, function(a,b) return a.friendly > b.friendly end)
		for _, data in pairs(bones) do
			menu:AddOption(L(data.friendly), function()
				self:SetValue(L(data.friendly))
				self.OnValueChanged(data.friendly)
			end)
		end
		
		FIX_MENU(menu)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- part
	local PANEL = {}

	PANEL.ClassName = "properties_part"
	PANEL.Base = "pace_properties_base_type"
	
	function PANEL:SpecialCallback()
		pace.SelectPart(pac.GetParts(true), function(part)
			self:SetValue(part:GetName())
			self.OnValueChanged(part)
		end)
	end
		
	function PANEL:SpecialCallback2(key)
		local menu = DermaMenu()
		
		menu:MakePopup()		
		
		for _, part in pairs(pac.GetParts(true)) do
			if not part:HasParent() then
				populate_part_menu(menu, part, "Set" .. key)
			end
		end
		
		FIX_MENU(menu)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- owner
	local PANEL = {}

	PANEL.ClassName = "properties_ownername"
	PANEL.Base = "pace_properties_base_type"
	
	function PANEL:SpecialCallback()
		pace.SelectEntity(function(ent)
			pace.current_part:SetOwnerName(ent:EntIndex())
			local name = pace.current_part:GetOwnerName()
			self.OnValueChanged(name)
			self:SetValue(L(name))
		end)
	end
		
	function PANEL:SpecialCallback2()
		local menu = DermaMenu()
		menu:MakePopup()
				
		local function get_friendly_name(ent)
			local name = ent.GetName and ent:GetName()
			if not name or name == "" then
				name = ent:GetClass()
			end

			return ent:EntIndex() .. " - " .. name
		end
		
		for key, name in pairs(pac.OwnerNames) do
			menu:AddOption(name, function() pace.current_part:SetOwnerName(name) end)
		end
		
		local entities = menu:AddSubMenu(L"entities", function() end)
		entities.GetDeleteSelf = function() return false end
		for _, ent in pairs(ents.GetAll()) do
			if ent:EntIndex() > 0 then
				entities:AddOption(get_friendly_name(ent), function()
					pace.current_part:SetOwnerName(ent:EntIndex())
					self.OnValueChanged(ent:EntIndex())
				end)
			end
		end
		
		FIX_MENU(menu)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- aimpart
	local PANEL = {}

	PANEL.ClassName = "properties_aimpartname"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()
		pace.SelectPart(pac.GetParts(true), function(part)
			self:SetValue(part:GetName())
			self.OnValueChanged(part)
		end)
	end
		
	function PANEL:SpecialCallback2(key)
		local menu = DermaMenu()
		menu:MakePopup()
				
		for key, name in pairs(pac.AimPartNames) do
			menu:AddOption(L(key), function() pace.current_part:SetAimPartName(name) end):SetImage("icon16/eye.png")
		end
		
		for _, part in pairs(pac.GetParts(true)) do
			if not part:HasParent() then
				populate_part_menu(menu, part, "SetAimPartName")
			end
		end
		
		FIX_MENU(menu)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- model
	local PANEL = {}

	PANEL.ClassName = "properties_model"
	PANEL.Base = "pace_properties_base_type"
	
	function PANEL:SpecialCallback2()
		pace.SafeRemoveSpecialPanel()
		g_SpawnMenu:Open()
	end
	
	function PANEL:SpecialCallback()
		pace.close_spawn_menu = true
		pace.SafeRemoveSpecialPanel()
		g_SpawnMenu:Open()
	end
	
	-- this is so lame
	
	--[[function PANEL:SpecialCallback()
		pace.SafeRemoveSpecialPanel()
		
		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"models")
		frame:SetPos(pace.Editor:GetWide(), 0)
		frame:SetSize(pace.Editor:GetWide(), ScrH())
		
		local divider = vgui.Create("DVerticalDivider", frame)
		divider:Dock(FILL)
				
		local top = vgui.Create("DPanelList")
			top:EnableVerticalScrollbar(true)		
		divider:SetTop(top)
		
		local bottom = vgui.Create("DPanelList")
			bottom:Dock(FILL)
			bottom:EnableHorizontal(true)
			bottom:EnableVerticalScrollbar(true)
			bottom:SetSpacing(4, 4)
		divider:SetBottom(bottom)
		
		local function GetParentFolder(str)
			return str:match("(.*/)" .. (".*/"):rep(1)) or ""
		end
	
		local function populate(dir)
			frame:SetTitle(dir)
			
			local a,b = file.Find(dir .. "*", "GAME")
			local files = table.Merge(a or {}, b or {})
			
			if GetParentFolder(dir):find("/", nil, true) then
				local btn = vgui.Create("DButton")
					btn:SetText("..")
					top:AddItem(btn)
				
				function btn:DoClick()
					for k,v in pairs(top:GetItems()) do v:Remove() end
					for k,v in pairs(bottom:GetItems()) do v:Remove() end
					populate(GetParentFolder(dir))
				end
			end
					
			for _, name in pairs(files) do
				if not name:find("%.", nil, true) then
					local btn = vgui.Create("DButton")
					btn:SetText(name)
					top:AddItem(btn)
					
					function btn:DoClick()
						for k,v in pairs(top:GetItems()) do v:Remove() end
						for k,v in pairs(bottom:GetItems()) do v:Remove() end
						populate(dir .. name .. "/")
					end
				end
			end
			
			for _, name in pairs(files) do
				local dir = dir:match("../.-/(.+)")

				if name:find(".mdl", nil, true) then
					local btn = vgui.Create("SpawnIcon")
					btn:SetIconSize(64)
					btn:SetSize(64, 64)
											
					btn:SetModel(dir .. name)
					bottom:AddItem(btn)
					
					function btn.DoClick()
						pace.current_part:SetModel(dir .. name)
					end
				end
				
				-- umm
				
				if name:find(".vmt", nil, true) then
					local image = vgui.Create("DImageButton")
					image:SetSize(64, 64)
					local path = (dir .. name):match("materials/(.-)%.vmt")
					image:SetMaterial(path)
					image:SetTooltip(path)
					bottom:AddItem(image)
					
					function image.DoClick()
						pace.current_part:SetMaterial(path)
					end
				end
									

			end
			
			top:InvalidateLayout(true)
			bottom:InvalidateLayout(true)
		end

		populate("")
		
		pace.ActiveSpecialPanel = frame
	end]]
	
	pace.RegisterPanel(PANEL)
end

do -- material
	local PANEL = {}

	PANEL.ClassName = "properties_material"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()
		pace.SafeRemoveSpecialPanel()
		
		local pnl = pace.CreatePanel("mat_browser")
		
		SHOW_SPECIAL(pnl, self, 300)
		
		function pnl.MaterialSelected(_, path)
			self:SetValue(path)
			self.OnValueChanged(path)
		end
		
		pace.ActiveSpecialPanel = pnl
	end
	
	pace.RegisterPanel(PANEL)
end

local function create_search_list(property, key, name, add_columns, get_list, get_current, add_line, select_value)
	select_value = select_value or function(val, key) return val end
	pace.SafeRemoveSpecialPanel()
		
	local frame = vgui.Create("DFrame")
	frame:SetTitle(L(name))
	frame:SetSize(300, 300)
	frame:Center()
	frame:SetSizable(true)

	local list = vgui.Create("DListView", frame)
	list:Dock(FILL)
	list:SetMultiSelect(false)
	
	add_columns(list)
	
	list.OnRowSelected = function(_, id, line) 
		local val = select_value(line.list_val, line.list_key)
		
		if property then
			property:SetValue(val)
			property.OnValueChanged(val)
		else
			if pace.current_part:IsValid() and pace.current_part["Set" .. key] then
				pace.Call("VariableChanged", pace.current_part, key, val)
			end
		end
	end
	
	local first = NULL
		
	local function build(find)	
		list:Clear()			
		
		local cur = get_current()
		
		for key, val in pairs(get_list()) do
			if (not find or find == "") or tostring(select_value(val, key)):lower():find(find) then
			
				local pnl = add_line(list, key, val)
				pnl.list_key = key
				pnl.list_val = val
				
				if not first:IsValid() then
					first = pnl
				end
				
				if cur == name then
					list:SelectItem(pnl)
				end
			end
		end
	end
	
	local search = vgui.Create("DTextEntry", frame)
	search:Dock(BOTTOM)
	search.OnTextChanged = function() build(search:GetValue()) end
	search.OnEnter = function() if first:IsValid() then list:SelectItem(first) end frame:Remove() end
	search:RequestFocus()
	frame:MakePopup()
	
	build()
	
	pace.ActiveSpecialPanel = frame
	
	return frame
end

do -- sequence list
	local PANEL = {}

	PANEL.ClassName = "properties_sequence"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()
		create_search_list(
			self,
			self.CurrentKey,
			"animations", 
			function(list) 	
				list:AddColumn("id"):SetFixedWidth(25)
				list:AddColumn("name") 
			end,
			function() 
				return pace.current_part:GetSequenceList()
			end,
			function()
				return pace.current_part.ClassName == "animation" and pace.current_part:GetSequenceName()
			end,
			function(list, key, val)
				return list:AddLine(key, val)
			end
		)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- pose parameter list
	local PANEL = {}

	PANEL.ClassName = "properties_poseparameter"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()		
		create_search_list(
			self,
			self.CurrentKey,
			"pose parameters", 
			function(list) 	
				list:AddColumn("id"):SetFixedWidth(25)
				list:AddColumn("name") 
			end,
			function() 
				return pace.current_part:GetPoseParameterList()
			end,
			function()
				return pace.current_part:GetPoseParameter()
			end,
			function(list, key, val)
				return list:AddLine(key, val.name)
			end,
			function(val) 
				return val.name
			end
		)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- event list
	local PANEL = {}

	PANEL.ClassName = "properties_event"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()	
		local frame = create_search_list(
			self,
			self.CurrentKey,
			"events", 
			function(list) 	
				list:AddColumn("name") 
			end,
			function() 
				return pace.current_part.Events
			end,
			function()
				return pace.current_part.Event
			end,
			function(list, key, val)
				return list:AddLine(L(key:gsub("_", " ")))
			end,
			function(val, key)
				return key
			end
		)
		
		SHOW_SPECIAL(frame, self, 250)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- operator list
	local PANEL = {}

	PANEL.ClassName = "properties_operator"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()			
		local frame = create_search_list(
			self,
			self.CurrentKey,
			"operators", 
			function(list) 	
				list:AddColumn("name") 
			end,
			function() 
				return pace.current_part.Operators
			end,
			function()
				return pace.current_part.Operator
			end,
			function(list, key, val)
				return list:AddLine(L(val:gsub("_", " ")))
			end,
			function(val, key)
				return val
			end
		)
		
		SHOW_SPECIAL(frame, self, 250)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- arguments
	local PANEL = {}

	PANEL.ClassName = "properties_arguments"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:ExtraPopulate()	 
		local data = pace.current_part.Events[pace.current_part.Event]
		data = data and data.arguments
		
		if not data then return end

		local tbl = {}
		local args = {pace.current_part:GetParsedArguments(data)}
		if args then
			for pos, arg in pairs(data) do
				local nam, typ = next(arg)
				if args[pos] then
					arg = args[pos]
				else
					if typ == "string" then
						arg = ""
					elseif typ == "number" then
						arg = 0
					elseif typ == "boolean" then
						arg = false
					end
				end
				tbl[nam] = {val = arg, callback = function(val)
					local args = {pace.current_part:GetParsedArguments(data)}
					args[pos] = val
					pace.current_part:ParseArguments(unpack(args))
					--self:SetValue(pace.current_part.Arguments)
				end}
			end
			pace.properties:Populate(tbl, true, L"arguments")
		end
				
	end
	
	pace.RegisterPanel(PANEL)
end

do -- Proxy Functions
	local PANEL = {}

	PANEL.ClassName = "properties_proxyfunctions"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()	
		pace.SafeRemoveSpecialPanel()
		 
		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"functions")
		SHOW_SPECIAL(frame, self, 250)
		frame:SetSizable(true)

		local list = vgui.Create("DListView", frame)
		list:Dock(FILL)
		list:SetMultiSelect(false)
		list:AddColumn(L"function")

		list.OnRowSelected = function(_, id, line) 
			self:SetValue(line.event_name)
			self.OnValueChanged(line.event_name)
		end

		for name, _ in pairs(pace.current_part.Functions) do
			local pnl = list:AddLine(L(name))
			pnl.event_name = name
			
			if cur == name then
				list:SelectItem(pnl)
			end
		end
		
		pace.ActiveSpecialPanel = frame
	end
	
	pace.RegisterPanel(PANEL)
end

do -- Proxy Functions
	local PANEL = {}

	PANEL.ClassName = "properties_proxyinputs"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()			
		local frame = create_search_list(
			self,
			self.CurrentKey,
			"operators", 
			function(list) 	
				list:AddColumn("name") 
			end,
			function() 
				return pace.current_part.Inputs
			end,
			function()
				return pace.current_part.Input
			end,
			function(list, key, val)
				return list:AddLine(L(key))
			end,
			function(val, key)
				return key
			end
		)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- Proxy Variables
	local PANEL = {}

	PANEL.ClassName = "properties_proxyvars"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()	
		local parent = pace.current_part.Parent
		
		if not parent:IsValid() then return end
		
		pace.SafeRemoveSpecialPanel()
		 
		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"functions")
		SHOW_SPECIAL(frame, self, 250)
		frame:SetSizable(true)

		local list = vgui.Create("DListView", frame)
		list:Dock(FILL)
		list:SetMultiSelect(false)
		list:AddColumn(L"parent variables")

		list.OnRowSelected = function(_, id, line) 
			self:SetValue(line.event_name)
			self.OnValueChanged(line.event_name)
		end

		for key, _ in pairs(parent.StorableVars) do
			if key == "UniqueID" then continue end
			
			local T = type(parent[key])
			if T == "number" or T == "Vector" or T == "Angle" or T == "boolean" then
				local pnl = list:AddLine(L(key:gsub("%u", " %1"):lower()))
				pnl.event_name = key
				
				if cur == key then
					list:SelectItem(pnl)
				end
			end
		end
		
		pace.ActiveSpecialPanel = frame
	end
	
	pace.RegisterPanel(PANEL)
end


do -- bodygroup names
	local PANEL = {}

	PANEL.ClassName = "properties_bodygroupname"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()	
		pace.SafeRemoveSpecialPanel()
		 
		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"bodygroup names")
		SHOW_SPECIAL(frame, self, 250)
		frame:SetSizable(true)

		local list = vgui.Create("DListView", frame)
		list:Dock(FILL)
		list:SetMultiSelect(false)
		list:AddColumn(L"name")

		list.OnRowSelected = function(_, id, line) 
			self:SetValue(line.name)
			self.OnValueChanged(line.name)
		end

		local cur = pace.current_part:GetBodyGroupName()
		
		for _, name in pairs(pace.current_part:GetBodyGroupNameList()) do
			local pnl = list:AddLine(L(name))
			pnl.name = name
			
			if cur == name then
				list:SelectItem(pnl)
			end
		end
		
		pace.ActiveSpecialPanel = frame
	end
	
	pace.RegisterPanel(PANEL)

end

do -- flex
	local PANEL = {}

	PANEL.ClassName = "properties_flex"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()	
		pace.SafeRemoveSpecialPanel()
		 
		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"flex names")
		SHOW_SPECIAL(frame, self, 250)
		frame:SetSizable(true)

		local list = vgui.Create("DListView", frame)
		list:Dock(FILL)
		list:SetMultiSelect(false)
		list:AddColumn(L"id")
		list:AddColumn(L"name")

		list.OnRowSelected = function(_, id, line) 
			self:SetValue(line.name)
			self.OnValueChanged(line.name)
		end
		
		local cur = pace.current_part:GetFlex()

		for _, v in pairs(pace.current_part:GetFlexList()) do
			local pnl = list:AddLine(v.i, L(v.name))
			pnl.name = v.name
			
			if cur == v.name then
				list:SelectItem(pnl)
			end
		end
		
		pace.ActiveSpecialPanel = frame
	end
	
	pace.RegisterPanel(PANEL)

end

do -- holdtype
	local PANEL = {}

	PANEL.ClassName = "properties_weaponholdtype"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()	
		local frame = create_search_list(
			self,
			self.CurrentKey,
			L"holdtypes", 
			function(list) 	
				list:AddColumn("name") 
			end,
			function() 
				return pace.current_part.ValidHoldTypes
			end,
			function()
				return pace.current_part.HoldType
			end,
			function(list, key, val)
				return list:AddLine(key)
			end,
			function(val, key)
				return key
			end
		)
		
		pace.ActiveSpecialPanel = frame
	end
	
	pace.RegisterPanel(PANEL)
end

do -- effect
	local PANEL = {}

	PANEL.ClassName = "properties_effect"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()		
		if not pace.particle_list then
			local found = {}

			for file_name in pairs(LOADED_PARTICLES) do
				local data = file.Read("particles/"..file_name, "GAME", "b")
				for str in data:gmatch("\3%c([%a_]+)%c") do
					found[str] = true
				end
			end

			pace.particle_list = found
		end
		
		local frame = create_search_list(
			self,
			self.CurrentKey,
			L"particle list", 
			function(list) 	
				list:AddColumn("name") 
			end,
			function() 
				return pace.particle_list
			end,
			function()
				return pace.current_part.Effect
			end,
			function(list, key, val)
				return list:AddLine(key)
			end,
			function(val, key)
				return key
			end
		)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- damage type
	local PANEL = {}

	PANEL.ClassName = "properties_damagetype"
	PANEL.Base = "pace_properties_base_type"
	
	local damage_types = {
		generic = 0, --generic damage
		crush = 1, --caused by physics interaction
		bullet = 2, --bullet damage
		slash = 4, --sharp objects, such as manhacks or other npcs attacks
		burn = 8, --damage from fire
		vehicle = 16, --hit by a vehicle
		fall = 32, --fall damage
		blast = 64, --explosion damage
		club = 128, --crowbar damage
		shock = 256, --electrical damage, shows smoke at the damage position
		sonic = 1302, --sonic damage,used by the gargantua and houndeye npcs
		energybeam = 1024, --laser
		nevergib = 4096, --don't create gibs
		alwaysgib = 8192, --always create gibs
		drown = 16384, --drown damage
		paralyze = 32768, --same as dmg_poison
		nervegas = 65536, --neurotoxin damage
		poison = 131072, --poison damage
		acid = 1048576, --
		airboat = 0554432, --airboat gun damage
		blast_surface = 134217728, --this won't hurt the player underwater
		buckshot = 5368701502, --the pellets fired from a shotgun
		direct = 268435456, --
		dissolve = 67108864, --forces the entity to dissolve on death
		drownrecover = 524288, --damage applied to the player to restore health after drowning
		physgun = 8388608, --damage done by the gravity gun
		plasma = 16777216, --
		prevent_physics_force = 2048, --
		radiation = 262144, --radiation
		removenoragdoll = 4194304, --don't create a ragdoll on death
		slowburn = 2097152, --
	}
		
	function PANEL:SpecialCallback()				
		local frame = create_search_list(
			self,
			self.CurrentKey,
			L"damage type list", 
			function(list) 	
				list:AddColumn("name") 
			end,
			function() 
				return damage_types
			end,
			function()
				return pace.current_part.DamageType
			end,
			function(list, key, val)
				return list:AddLine(key)
			end,
			function(val, key)
				return key
			end
		)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- damage type
	local PANEL = {}

	PANEL.ClassName = "properties_buttons"
	PANEL.Base = "pace_properties_base_type"
	
	local enums = {}

	for key, val in pairs(_G) do
		if type(key) == "string" and type(val) == "number" and key:sub(0,4) == "KEY_" then
			enums[key:sub(5):lower()] = val
		end
	end
	
		
	function PANEL:SpecialCallback()				
		local frame = create_search_list(
			self,
			self.CurrentKey,
			L"keyboard buttons", 
			function(list) 	
				list:AddColumn("name") 
			end,
			function() 
				return enums
			end,
			function()
				return pace.current_part.Arguments
			end,
			function(list, key, val)
				return list:AddLine(key)
			end,
			function(val, key)
				return key
			end
		)
	end
	
	pace.RegisterPanel(PANEL)
end

do -- script
	local PANEL = {}

	PANEL.ClassName = "properties_code"
	PANEL.Base = "pace_properties_base_type"
		
	function PANEL:SpecialCallback()	
		pace.SafeRemoveSpecialPanel()
		 
		local frame = vgui.Create("DFrame")
		frame:SetTitle(L"script")
		SHOW_SPECIAL(frame, self, 1302)
		frame:SetSizable(true)

		local editor = vgui.Create("pace_luapad", frame)
		editor:Dock(FILL)

		editor:SetText(pace.current_part:GetCode())		
		editor.OnTextChanged = function(self)
			pace.current_part:SetCode(self:GetValue())
		end
		
		editor.last_error = ""
		
		function editor:CheckGlobal(str) 
			local part = pace.current_part
			
			if not part:IsValid() then frame:Remove() return end
						
			return part:ShouldHighlight(str)
		end
		
		function editor:Think()
			local part = pace.current_part
			
			if not part:IsValid() then frame:Remove() return end
						
			local title = L"script editor"
					  
			if part.Error then
				title = part.Error
			
				local line = tonumber(title:match("SCRIPT_ENV:(%d-):"))
				
				if line then
					title = title:match("SCRIPT_ENV:(.+)")
					if self.last_error ~= title then			
						editor:SetScrollPosition(line)							
						editor:SetErrorLine(line)
						self.last_error = title
					end
				end
			else	
				editor:SetErrorLine(nil)
				
				if part.script_printing then
					title = part.script_printing
					part.script_printing = nil
				end
			end
			
			frame:SetTitle(title)
		end
		
		pace.ActiveSpecialPanel = frame
	end
	
	pace.RegisterPanel(PANEL)
end

local PANEL = {}

PANEL.ClassName = "tree"
PANEL.Base = "pac_dtree"

function PANEL:Init()
	pace.pac_dtree.Init(self)

	self:SetLineHeight(18)
	self:SetIndentSize(10)

	self.parts = {}
	
	self:Populate()
	
	pace.tree = self
end

do
	local pnl = NULL

	function PANEL:Think(...)	
		pnl = vgui.GetHoveredPanel() or NULL
				
		if pnl:IsValid() then
			local pnl = pnl:GetParent()
			
			if pnl and pnl.part and pnl.part:IsValid() then
				pace.Call("HoverPart", pnl.part)
			end
		end	
		
		for key, part in pairs(pac.GetParts(true)) do
		
			if part.event_triggered ~= nil then
				local node = part.editor_node
				if node and node:IsValid() then
					if part.event_triggered then
						node.Icon:SetImage("icon16/clock_red.png")
					else
						node.Icon:SetImage(pace.PartIcons[part.ClassName])
					end				
				end
			end
			
			if part.ClassName == "proxy" and part.Name == "" then
				local node = part.editor_node
				if node and node:IsValid() and node.m_bExpanded then
					node:SetText(part:GetName())	
				end
			end
		end
		
				
		if pace.pac_dtree.Think then
			return pace.pac_dtree.Think(self, ...)
		end
	end
end

function PANEL:OnMousePressed(mc)
	if mc == MOUSE_RIGHT then
		pace.Call("NewPartMenu")
	end
end

function PANEL:SetModel(path)
	local pnl = vgui.Create("SpawnIcon", self)
		pnl:SetModel(path or "")
		pnl:SetSize(16, 16)
		
		--[[if pnl.Entity and pnl.Entity:IsValid() then
			local mins, maxs = pnl.Entity:GetRenderBounds()
			pnl:SetCamPos(mins:Distance(maxs) * Vector(0.75, 0.75, 0.5) * 15)
			pnl:SetLookAt((maxs + mins) / 2)
			pnl:SetFOV(3)
		end

		pnl.SetImage = function() end
		pnl.GetImage = function() end]]

	self.Icon:Remove()
	self.Icon = pnl
end

local function install_drag(node)
	node:SetDraggableName("pac3")
	
	function node:DroppedOn(child)
						
		if not child.part then
			child = child:GetParent()
		end
		
		self:InsertNode(child)
		self:SetExpanded(true)
		
		if child.part and child.part:IsValid() then
			if self.part and self.part:IsValid() and child.part:GetParent() ~= self.part then
				child.part:SetParent(self.part)
			end
		end
	end
	
	local old = node.OnDrop
	
	function node:OnDrop(child, ...)
		-- we're hovering on the label, not the actual node
		-- so get the parent node instead
		
		if not child.part then
			child = child:GetParent()
		end
				
		if child.part and child.part:IsValid() then
			if self.part and self.part:IsValid() and self.part:GetParent() ~= child.part  then
				self.part:SetParent(child.part)
			end
		end
		
		return old(self, child, ...)
	end
end

local function install_expand(node)
	local old = node.SetExpanded
	node.SetExpanded = function(self, b, ...)
		if self.part and self.part:IsValid() then
			self.part:SetEditorExpand(b)
			return old(self, b, ...)
		end
	end
end

local fix_folder_funcs = function(tbl) 
	tbl.MakeFolder = function() end
	tbl.FilePopulateCallback = function() end
	tbl.FilePopulate = function() end
	tbl.PopulateChildren = function() end
	tbl.ChildExpanded = function() end
	tbl.PopulateChildrenAndSelf = function() end
	return tbl
end

local function node_layout(self, ...)
	pace.pac_dtree_node.PerformLayout(self, ...)
	if self.Label then
		self.Label:SetFont(pace.CurrentFont)
		self.Label:SetTextColor(Color(0,150,130))
	end			
end

-- a hack, because creating a new node button will mess up the layout
function PANEL:AddNode(...)

	local node = fix_folder_funcs(pace.pac_dtree.AddNode(self, ...))
	install_expand(node)
	install_drag(node)
	node.SetModel = self.SetModel
		
	node.AddNode = function(...)
		local node_ = fix_folder_funcs(pace.pac_dtree_node.AddNode(...))
		install_expand(node_)
		install_drag(node_)
		node_.SetModel = self.SetModel

		node_.AddNode = node.AddNode
		
		node_.PerformLayout = node_layout
		
		return node_
	end
	
	node.PerformLayout = node_layout	
		
	return node
end

local enable_model_icons = CreateClientConVar("pac_editor_model_icons", "1")

function PANEL:PopulateParts(node, parts, children)
	fix_folder_funcs(node)

	parts = table.ClearKeys(parts)
	
	local tbl = {}
	
	table.sort(parts, function(a,b) 
		return a and b and a:GetName() < b:GetName() 
	end)
	
	for key, val in pairs(parts) do
		if not val:HasChildren() then
			table.insert(tbl, val)
		end
	end
	
	for key, val in pairs(parts) do
		if val:HasChildren() then
			table.insert(tbl, val)
		end
	end
	
	for key, part in pairs(tbl) do
		key = part.Id
		
		if part:GetRootPart().show_in_editor == false then continue end
				
		if not part:HasParent() or children then
			local part_node
			
			if IsValid(part.editor_node) then
				part_node = part.editor_node
			elseif IsValid(self.parts[key]) then
				part_node = self.parts[key]
			else
				part_node = node:AddNode(part:GetName())
			end
			
			fix_folder_funcs(part_node)
			
			part_node:SetTooltip(part:GetDescription())
			
			part.editor_node = part_node
			part_node.part = part
			
			self.parts[key] = part_node

			part_node.DoClick = function()
				if part:IsValid() then
					pace.Call("PartSelected", part)
					return true
				end
			end
			
			part_node.DoRightClick = function()
				if part:IsValid() then
					pace.Call("PartMenu", part)
					pace.Call("PartSelected", part)
					part_node:InternalDoClick()
					return true
				end
			end
			
			if enable_model_icons:GetBool() and part.ClassName == "model" and part.GetModel then
				part_node:SetModel(part:GetModel())
			else
				part_node.Icon:SetImage(pace.GetIconFromClassName(part.ClassName))
			end
			
			self:PopulateParts(part_node, part:GetChildren(), true)			
		
			if part.newly_created then
				part_node:SetSelected(true)
				
				local function expand(part)
					if part:HasParent() and part.Parent.editor_node then
						part.Parent.editor_node:SetExpanded(true)
						expand(part.Parent)
					end
				end

				expand(part)
				
				part_node:SetSelected(true)
				part.newly_created = nil
			else
				part_node:SetSelected(false)
				part_node:SetExpanded(part:GetEditorExpand())
			end
		end
	end
end

function PANEL:SelectPart(part)
	for key, node in pairs(self.parts) do
		if not node.part or not node.part:IsValid() then
			node:Remove()
			self.parts[key] = nil
		else
			if node.part == part then
				node:SetSelected(true)
			else
				node:SetSelected(false)
			end
		end
	end
end

function PANEL:Populate(reset)

	self:SetLineHeight(18)
	self:SetIndentSize(2)
	
	for key, node in pairs(self.parts) do
		if reset or (not node.part or not node.part:IsValid()) then
			node:Remove()
			self.parts[key] = nil
		end
	end
	
	--[[self.m_pSelectedItem = nil
	
	for key, node in pairs(self:GetItems()) do
		node:Remove()
	end]]
	
	self:PopulateParts(self, pac.GetParts(true))
	
	self:InvalidateLayout()
end

function PANEL:Paint(w,h)
	surface.SetDrawColor(Color(0,150,130))
	for i=0, 1 - 1 do
		surface.DrawOutlinedRect( 0 + i, 0 + i, w - i * 2, h - i * 2 )
	end
end

pace.RegisterPanel(PANEL)

local function remove_node(part)
	if (part.editor_node or NULL):IsValid() and part:GetRootPart().show_in_editor ~= false then
		part.editor_node:SetForceShowExpander()
		part.editor_node:GetRoot().m_pSelectedItem = nil
		part.editor_node:Remove()		
		pace.RefreshTree()
	end
end

hook.Add("pac_OnPartRemove", "pace_remove_tree_nodes", remove_node)

local function refresh(part, localplayer)
	if localplayer and part:GetRootPart().show_in_editor ~= false then
		pace.RefreshTree(true)
	end
end
hook.Add("pac_OnWoreOutfit", "pace_create_tree_nodes", refresh)

local function refresh(part, localplayer)	
	if localplayer and part:GetRootPart().show_in_editor ~= false then
		pace.RefreshTree(true)
	end
end
hook.Add("pac_OnPartCreated", "pace_create_tree_nodes", refresh)

function pace.RefreshTree(reset)
	if pace.tree:IsValid() then
		timer.Create("pace_refresh_tree",  0.01, 1, function()
			if pace.tree:IsValid() then
				pace.tree:Populate(reset)
				pace.tree.RootNode:SetExpanded(true, true) -- why do I have to do this?
				
				pace.TrySelectPart()
			end
		end)
	end
end
