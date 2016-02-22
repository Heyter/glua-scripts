if SERVER then return end

//Misc Functions
local function Name(ply,data)
	local name = ply:Name()
	local last = data.__lastcleanname

	if name ~= last then
		last = name:gsub("%^%d", "")
		last = last:gsub("<(.-)=(.-)>", "")
		data.__lastcleanname = last
	end
	return last

end
	local PlayerColors = {
		--["0"]  = Color(0,0,0),
		["1"]  = Color(128,128,128),
		["2"]  = Color(192,192,192),
		["3"]  = Color(255,255,255),
		["4"]  = Color(0,0,128),
		["5"]  = Color(0,0,255),
		["6"]  = Color(0,128,128),
		["7"]  = Color(0,255,255),
		["8"]  = Color(0,128,0),
		["9"]  = Color(0,255,0),
		["10"] = Color(128,128,0),
		["11"] = Color(255,255,0),
		["12"] = Color(128,0,0),
		["13"] = Color(255,0,0),
		["14"] = Color(128,0,128),
		["15"] = Color(255,0,255),
	}

	local name_c
	for col in string.gmatch(LocalPlayer():Name(),"%^(%d)") do
		name_c = PlayerColors[col]
	end
	for col1,col2,col3 in string.gmatch(LocalPlayer():Name(),"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
		name_c = HSVToColor(col1,col2,col3)
	end
	for col1,col2,col3 in string.gmatch(LocalPlayer():Name(),"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
		name_c = Color(col1,col2,col3,255)
	end
	local c = name_c and name_c or team.GetColor(LocalPlayer():Team())

//Fonts
surface.CreateFont("PlayerStatsName",{
	font = "Tahoma",
	size = 36,
	weight = 500,
	--outline = true
})

function PlayerStats()
	local Frame = vgui.Create("DFrame")
	Frame:SetSize(750,700)
	Frame:Center()
	Frame:SetTitle("Player Stats (BETA)")
	Frame:SetDraggable(true)
	Frame:ShowCloseButton(true)
	Frame:MakePopup()

	function Frame:Paint(w,h)
		draw.RoundedBoxEx(4,0,0,w,24,name_c or team.GetColor(LocalPlayer():Team()),true,true,false,false)
		draw.RoundedBoxEx(4,0,24,w,h-24,Color(0,0,0,220),false,false,true,true)
	end

	local StatsSheet = vgui.Create("DPropertySheet")
	StatsSheet:Dock(RIGHT)

	function StatsSheet:Paint() end

	----

	local PlayerDisplay = vgui.Create("DModelPanel")
	PlayerDisplay:Dock(LEFT)
	PlayerDisplay.Entity = LocalPlayer()
	PlayerDisplay:SetFOV(26)

	function PlayerDisplay:Paint()
		draw.RoundedBox(4,0,0,self:GetWide(),self:GetTall(),Color(53,53,53,200))
		if !IsValid(self.Entity) then return end

		local x, y = self:LocalToScreen(0,0)

		local ang = self.aLookAngle
		if ( !ang ) then
			ang = self.Entity:GetAngles()+Angle(0,180,0)
		end

		local w, h = self:GetSize()
		cam.Start3D(self.Entity:LocalToWorld(self.Entity:OBBCenter())-ang:Forward()*100,ang,self.fFOV,x,y,w,h,5,4096)
		cam.IgnoreZ(true)
		ShouldDrawLocalPlayer = true
		local pac=pac
		if pac then
			pac.ForceRendering(true)
			pac.RenderOverride(self.Entity,"opaque")
			pac.RenderOverride(self.Entity,"translucent",true)
		end
		self.Entity:DrawModel()

		if pac then
			pac.ForceRendering(false)
		end
		ShouldDrawLocalPlayer = false
		cam.IgnoreZ(false)
		cam.End3D()

		self.LastPaint = RealTime()
	end

	----

	local StatsPanel = vgui.Create("DPanel")
	function StatsPanel:Paint() end

	local PlayerName = vgui.Create("DLabel",StatsPanel)
	PlayerName:SetPos(5,5)
	PlayerName:SetText(Name(LocalPlayer(),LocalPlayer():GetTable()))
	PlayerName:SetColor(name_col)
	PlayerName:SetFont("PlayerStatsName")
	PlayerName:SizeToContents()
	PlayerName:SetMouseInputEnabled(true)

	local PlayerAway = vgui.Create("DLabel",StatsPanel)
	PlayerAway:SetPos(10+PlayerName:GetWide(),24)
	PlayerAway:SetText("")
	PlayerAway:SetColor(color_white)
	PlayerAway:SetFont("DermaDefault")
	PlayerAway:SizeToContents()

	local stats_title_text
	if LocalPlayer():GetCustomTitle() == "" or LocalPlayer():GetCustomTitle() == nil or LocalPlayer():GetCustomTitle() == " " then stats_title_text = "No Title" else stats_title_text = LocalPlayer():GetCustomTitle() end

	local PlayerTitle = vgui.Create("DLabel",StatsPanel)
	PlayerTitle:SetPos(5,41)
	PlayerTitle:SetText(stats_title_text)
	PlayerTitle:SetColor(color_white)
	PlayerTitle:SetFont("DermaDefault")
	PlayerTitle:SizeToContents()
	PlayerTitle:SetMouseInputEnabled(true)

	local PlayerCoins = vgui.Create("DLabel",StatsPanel)
	PlayerCoins:SetPos(26,59)
	PlayerCoins:SetText(LocalPlayer():GetCoins())
	PlayerCoins:SetColor(color_white)
	PlayerCoins:SetFont("DermaDefault")
	PlayerCoins:SizeToContents()
	PlayerCoins:SetMouseInputEnabled(true)

	local IconCoins = vgui.Create("DImage",StatsPanel)
	IconCoins:SetPos(5,57)
	IconCoins:SetSize(16,16)
	IconCoins:SetImage("icon16/coins.png")

	local PlayerTime = vgui.Create("DLabel",StatsPanel)
	PlayerTime:SetPos(26,80)
	PlayerTime:SetText("Playtime")
	PlayerTime:SetColor(color_white)
	PlayerTime:SetFont("DermaDefault")
	PlayerTime:SizeToContents()
	PlayerTime:SetMouseInputEnabled(true)

	local IconTime = vgui.Create("DImage",StatsPanel)
	IconTime:SetPos(5,78)
	IconTime:SetSize(16,16)
	IconTime:SetImage("icon16/time.png")

	local HelpText = vgui.Create("DLabel",StatsPanel)
	HelpText:SetText("Click for help")
	HelpText:SetColor(color_white)
	HelpText:SetFont("DermaDefault")
	HelpText:SizeToContents()
	HelpText:SetMouseInputEnabled(true)
	HelpText:SetPos((Frame:GetWide()-250)-HelpText:GetWide()-35,5)

	function PlayerName:DoClick()
		Derma_StringRequest("Name", "Type the new nickname for yourself", LocalPlayer():Name(), function(name)
			RunConsoleCommand("aowl","name",name)
		end)
	end

	function PlayerTitle:DoClick()
		Derma_StringRequest("Title", "Type the new title for yourself (leave blank to reset)", "", function(title)
			RunConsoleCommand("aowl","title",title)
		end)
	end

	function PlayerCoins:DoClick()
		Derma_StringRequest("Drop", "Type the amount of coins you would like to drop", "0", function(amount)
			RunConsoleCommand("coins_drop",amount)
		end)
	end

	function HelpText:DoClick()
		Derma_Message([[Welcome to Player Stats Beta.
						This is an inventory, badges and achievements replacer made by Flex with the help of code from each area.
						If you click your name or title, you can change them.
						If you click your coins, you can drop a certain ammount of coins.
						Achievements list is broke at the moment, please wait for it to be fixed. (out of my reach of how to fix it)
						]],"Player Stats Help","Okay")
	end

	----

	local AchBadgeSheet = vgui.Create("DPropertySheet",StatsPanel)
	AchBadgeSheet:SetPos(0,100)
	AchBadgeSheet:SetSize(460,520)

	function AchBadgeSheet:Paint() end

	local BadgePanel = vgui.Create("DPanel")
	function BadgePanel:Paint(w,h)
		draw.RoundedBox(0,0,400,w,h-400,Color(100,100,100))
	end

	local AchPanel = vgui.Create("DPanel")
	function AchPanel:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(100,100,100))
	end

	local list_badges
	local list_badges_ids
	local list_ach
	local list_ach_ids

	local function refresh_list_badges(target)
		list_badges = nil
		net.Start("MetaBadges_net_getlist")
		if target then net.WriteEntity(target) end
		net.SendToServer()
	end

	local function refresh_list_ach(target)
		list_ach = nil
		net.Start("MetAchievements_net_getlist")
		if target then net.WriteEntity(target) end
		net.SendToServer()
	end

	local function isplayer(ply)
		if type(ply) == "Player" then
			return IsValid(ply)
		end
		return false
	end

	local function show_information (text)
		-- For the love of god, ONLY CALL THIS ONCE!
		-- This bricks the window, so make sure you don't plan to do anything with it after calling this.
		-- > Implying you could do anything sane with this code anyways.

		AList:Remove()
		BList:Remove()
		local TextEntry = vgui.Create( "DTextEntry" )
		TextEntry:SetParent( Frame )
		TextEntry:SetPos( 10, 35 )
		TextEntry:SetSize( Frame_Width-20, Frame_Height-45 )
		TextEntry:SetMultiline(true)
		TextEntry:SetEditable(false)
		TextEntry:SetText(text)
	end

	----

	BScroll = vgui.Create( "DScrollPanel",BadgePanel )
	BScroll:SetSize(444,400)

	BList = vgui.Create( "DIconLayout",BScroll )
	BList:SetSize(BScroll:GetSize())
	BList:SetPos(0,0)
	BList:SetSpaceY(5)
	BList:SetSpaceX(4)

	----

	--[[
	AList = vgui.Create("DListView", AchPanel)
	AList:SetPos(0,0)
	AList:SetSize(180, 484)
	AList:SetMultiSelect(false)

	AList:AddColumn("Achievements")
	AList:AddColumn(""):SetMaxWidth(30)

	AIcon = vgui.Create("DImage", AchPanel)
	--AIcon:SetImage("phxtended/metal")
	AIcon:SetPos(280,125)
	AIcon:SetSize(200,200)

	local ATitle = vgui.Create("DLabel", AchPanel)
	ATitle:SetPos(190,55)
	ATitle:SetSize(400,30)
	ATitle:SetFont("MetAchievements_list_title")
	ATitle:SetTextColor(Color(255,215,0))
	ATitle:SetText("")

	local ADesc = vgui.Create("DTextEntry", AchPanel)
	ADesc:SetPos(190,85)
	ADesc:SetSize(300,484-150)
	ADesc:SetText("")
	ADesc:SetFont("MetAchievements_list_desc")
	ADesc:SetTextColor(Color(240,240,240,255))
	ADesc:SetDrawBackground(false)
	ADesc:SetEditable(false)
	ADesc:SetMultiline(true)

	local AStats = vgui.Create("DTextEntry", AchPanel)
	AStats:SetPos(190,484-150)
	AStats:SetSize(300,150)
	AStats:SetText("")
	AStats:SetFont("MetAchievements_list_stats")
	AStats:SetTextColor(Color(250,250,250,255))
	AStats:SetDrawBackground(false)
	AStats:SetEditable(false)
	AStats:SetMultiline(true)

	AProgress = vgui.Create("DProgress", AchPanel)
	AProgress:SetPos(185, 484-45)
	AProgress:SetSize(395-185, 35)
	AProgress:SetVisible(false)

		-- Progress Bar Hacks
			AProgress.SProgress = 0
			AProgress.Progress = 0
			local oldthink = AProgress.Think
			AProgress.Think = function(self, ...)
				if isfunction(oldthink) then oldthink(self, ...) end
				self.SProgress = math.Approach(self.SProgress, self.Progress, 0.05)
				self:SetFraction(self.SProgress)
			end
			function AProgress:SetProgress(frac)
				if isnumber(frac) then
					self.Progress = math.Clamp(frac, 0, 1)
				end
			end
			AProgress.Paint = function(self, w, h)
				local frac = self:GetFraction() or 0

				surface.SetDrawColor(100, 100, 100, 255)
				surface.DrawRect(0 , 0, w, h )

				if frac == 1 then
					surface.SetDrawColor(0, 255, 0, 255)
				else
					surface.SetDrawColor(255, 120, 0, 255)
				end
				surface.DrawRect(0 , 0, frac*w, h )
				surface.SetDrawColor(230, 230, 230, 255)
				surface.DrawRect(1 , 1, frac*w-2, h-2 )
			end
		-- / Progress Bar Hacks

		AUnlocked = vgui.Create("DLabel", AchPanel)
		AUnlocked:SetPos(200,484-39)
		AUnlocked:SetSize(400,28)
		AUnlocked:SetFont("MetAchievements_list_title")
		AUnlocked:SetTextColor(Color(0,0,0))
		AUnlocked:SetText("")

		function AList:OnRowSelected(num)
			local aid = list_ach_ids[num]
			local info = list_ach.info[aid]
			local data = list_ach.data[aid]
			ATitle:SetText(list_ach.title)
			AStats:SetText(isstring(data.stats) and data.stats or "")
			ADesc:SetText(info.description)
			local text_progress = ""

			if data.unlocked then
				AProgress:SetVisible(true)
				AProgress:SetProgress(1)
			elseif isnumber(data.progress) then
				AProgress:SetVisible(true)
				AProgress:SetProgress(data.progress)
				text_progress = Format("Progress: %d %%", math.floor(data.progress*100))
			else
				AProgress:SetVisible(false)
			end

			AUnlocked:SetContentAlignment( 5 )
			AUnlocked:SetText(data.unlocked and "UNLOCKED" or text_progress)
			--AIcon:SetImage(info.icon)
		end
	]]--
	----

	--start net--
	net.Receive("MetaBadges_net_getlist", function()
		if not IsValid(BadgePanel) then return end
		list_badges = net.ReadTable() or {}
		local info = list_badges.info or {}

		local owner = net.ReadEntity()
		owner = IsValid(owner) and owner or LocalPlayer()

		if list_badges.blacklisted and owner ~= LocalPlayer() then
			if Frame then Frame:Close() end
			LocalPlayer():ChatPrint(string.format("Player '%s' is banned from the badge system!", owner:Nick()))
			return
		end

		if list_badges.maintenance then
			show_information (string.format([[= Maintenance Mode =

				The Badge system was temporarily disabled.
				We are sorry for the inconvenience - here is the reason provided to the system:

				%s]], (list_badges.maintenance_info or "[no reason provided]")))
		elseif list_badges.blacklisted then
			show_information ([[You have been banned from the Badge System!
				This may have one of the following reasons:

				- You were banned from the server.
				( If you get banned from the server, you automatically get permanently blacklisted from the Badge System )

				- You willingly exploited the Badge System.
				- You've been heavily annoying other players about badges.

				]]..

				( isstring(list_badges.blacklist_reason) and
					string.gsub([[The reason provided was:
					"#REASON".

					]], "#REASON", list_badges.blacklist_reason)
				  or "" )

				..[[If you believe this is a mistake, please contact 'PotcFdk'.]])
		elseif list_badges.data then

			-- make list_badges.data a number-indexed table...

			local l_data = {}

			for bid, data in next, list_badges.data do
				data.__bid = bid
				table.insert (l_data, data)
			end

			-- now sort by upgrade time, newest first

			table.sort (l_data, function (a, b)
				return (a.time_upgraded or 0) > (b.time_upgraded or 0)
			end)

			local panels = {}
			for _, data in next, l_data do
				local time_upgraded = data.time_upgraded and os.date("%Y/%m/%d  %H:%M:%S", data.time_upgraded) or nil
				local level = data.level or 0

				local bid = data.__bid
				local binfo = info[bid]
				if not binfo then continue end
				local icon_set = binfo.icon_set or 1
				local b_basetitle = binfo.basetitle
				local b_blevelinfo = binfo.levels and binfo.levels[level] or binfo.default


				if level >= 1 then
					local panel = BList:Add("DPanel")
					panel:SetSize(128, 128)
					panel.PerformTab = {}
					panel._HasFocus = true -- default

					panels[bid] = panel

					-- DPanel Hacks
						panel.Paint = function(self, w, h)
							surface.SetDrawColor(120, 120, 120, 100)
							surface.DrawRect(0, 0, w, h)

							if self.Hovered then
								if not panel._HasFocus then -- if changed
									panel._HasFocus = true
									for k, v in next, self.PerformTab do
										v(true)
									end
								end
								surface.SetDrawColor(140, 140, 160, 120)
								surface.DrawRect(0, 0, w, h)
							else
								if panel._HasFocus then -- if changed
									panel._HasFocus = false
									for k, v in next, self.PerformTab do
										v(false)
									end
								end
							end
						end
					-- / DPanel Hacks

					local badge = vgui.Create("DImage", panel)
					badge:SetSize(panel:GetSize())

					if file.Exists("materials/metabadges/"..bid.."/s"..icon_set.."/"..level..".vmt", "GAME") then
						badge:SetImage("metabadges/"..bid.."/s"..icon_set.."/"..level)
					elseif file.Exists("materials/metabadges/"..bid.."/s"..icon_set.."/default.vmt", "GAME") then
						badge:SetImage("metabadges/"..bid.."/s"..icon_set.."/default")
					else
						badge:SetImage("metabadges/default-01a")
					end
				end
			end

			local title = vgui.Create("DLabel", BadgePanel)
			title:SetPos(10,400)
			title:SetSize(790,30)
			title:SetFont("MetaBadges_list_title")
			title:SetTextColor(Color(255,215,0))
			title:SetText("")
			--title:SetContentAlignment(5)

			local desc = vgui.Create("DLabel", BadgePanel)
			desc:SetPos(10,420)
			desc:SetSize(790,40)
			desc:SetFont("MetaBadges_list_desc")
			desc:SetTextColor(Color(230,230,230))
			desc:SetText("")
			--desc:SetContentAlignment(5)

			local selection_desc = vgui.Create("DLabel", BadgePanel)
			selection_desc:SetPos(10, 450)
			selection_desc:SetSize(580,30)
			selection_desc:SetFont("MetaBadges_selection_desc")
			selection_desc:SetTextColor(Color(200,200,200))
			selection_desc:SetText("")

			for k, v in next, panels do
				table.insert(v.PerformTab, function(enable)
					if enable then
						local level = list_badges.data[k].level
						if not level then return end

						local titlet = list_badges and list_badges.info and list_badges.info[k] and list_badges.info[k].levels
							and list_badges.info[k].levels[level] and list_badges.info[k].levels[level].title
						titlet = titlet or list_badges and list_badges.info and list_badges.info[k] and list_badges.info[k].levels
							and list_badges.info[k].levels.default and list_badges.info[k].levels.default.title
						title:SetText(titlet or "")

						local basetitle = list_badges.info[k].basetitle or "#BASETITLE"
						basetitle = basetitle and basetitle.." " or ""
						desc:SetText(basetitle.."Level "..level)

						local desc = list_badges and list_badges.info and list_badges.info[k] and list_badges.info[k].levels
							and list_badges.info[k].levels[level] and list_badges.info[k].levels[level].description
						desc = desc or list_badges and list_badges.info and list_badges.info[k] and list_badges.info[k].levels
							and list_badges.info[k].levels.default and list_badges.info[k].levels.default.description
						selection_desc:SetText(desc or "")
					end
				end)
			end
		else
			show_information (string.format([[CRITICAL ERROR

				The server responded with invalid data.
				This shouldn't happen. Like, at all.
				We are sorry, please try to forward this problem to 'PotcFdk', if that's possible.]]))
		end
		Msg("[MetaBadges]") print(" Received server reply!")
	end)
	----

	refresh_list_badges(LocalPlayer())
	--refresh_list_ach(LocalPlayer())

	AchBadgeSheet:AddSheet("Badges",BadgePanel,"icon16/award_star_gold_1.png",false,false,"Stats for your player and your server time")
	--AchBadgeSheet:AddSheet("Achievements",AchPanel,"icon16/award_star_gold_2.png",false,false,"Achievemtns")

	----

	--[[local InventoryPanel = vgui.Create("DPanel")
	InventoryPanel.msitems = {}

	InventoryPanel.equiped = vgui.Create("DModelPanel", InventoryPanel)
	InventoryPanel.equiped:SetSize(64,64)
	InventoryPanel.equiped:SetModel("")

	InventoryPanel.title = vgui.Create("DLabel", InventoryPanel)
	InventoryPanel.title:SetFont("BudgetLabel")
	InventoryPanel.title:SetText("")
	InventoryPanel.title:NoClipping(true)
	InventoryPanel.title:SizeToContents()
	InventoryPanel.title:SetZPos(1)

	InventoryPanel.name = vgui.Create("DLabel", InventoryPanel)
	InventoryPanel.name:SetFont("ChatFont")
	InventoryPanel.name:SetText("")

	InventoryPanel.info = vgui.Create("DLabel", InventoryPanel)
	InventoryPanel.info:SetText("")

	InventoryPanel.list = vgui.Create("DPanelList", InventoryPanel)
	InventoryPanel.list:EnableHorizontal(false)
	InventoryPanel.list:EnableVerticalScrollbar(true)
	InventoryPanel.list:SetSpacing(0)

	function InventoryPanel.list:PaintOver()
		surface.SetDrawColor( 150, 150, 150, 255 )
		surface.DrawOutlinedRect( 0, 0, InventoryPanel:GetWide(), InventoryPanel:GetTall() )
	end

	local oldpaint = InventoryPanel.equiped.Paint

	function InventoryPanel.equiped:Paint(w,h)
		derma.SkinHook( "Paint", "Button", self, w, h )
		derma.SkinHook( "PaintOver", "Button", self,w,h )
		oldpaint(self,w,h)
	end

	function InventoryPanel:Paint()
		draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color(100, 100, 100) )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
	end

	function InventoryPanel:PerformLayout(w,h)
		DPanel.PerformLayout(self,w,h)

		self.equiped:AlignRight(5) -- This will make the icon align with the scrollbar
		self.equiped:AlignTop(25+10)

		self.name:AlignTop(20+10)
		self.name:AlignLeft(24)

		self.info:AlignLeft(26)
		self.info:MoveBelow(self.name, 10)

		self.list:StretchToParent(5,25+80,5,5)
		self.list:PerformLayout()

		self.title:MoveAbove(self.list, -10)
		self.title:AlignLeft(10)

	end

	function InventoryPanel:SetEquiped(model, name, info, menu)
		self.equiped:SetModel(model or "")
		self.equiped:SetToolTip(name)

		function self.equiped:OnMousePressed(code)
			if menu and code == MOUSE_RIGHT then
				menu()
			end
		end

		if IsValid(self.equiped:GetEntity()) then self.equiped:SetLookAt(self.equiped:GetEntity():OBBCenter()) end
		self.equiped:SetCamPos(Vector()*100)
		self.equiped:SetFOV(5)

		self.name:SetText(name or "")
		self.name:SizeToContents()

		self.info:SetText(info or "")
		self.info:SizeToContents()
	end

	function InventoryPanel:UpdateEquiped()
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

	function InventoryPanel:CheckCount(item, class, table)
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

	function InventoryPanel:UpdateInventory()
		local inventory = LocalPlayer():GetInventory()
		for class, table in pairs(inventory) do

			if not table.data then table.data = msitems.GetItemDataFromClass(class) end

			if table.data then

				local item = self.msitems[class] or vgui.Create("msitems.ItemPanel", self)
				local text = msitems.GetInventoryInfo(class)

				item:SetCount(table.count)
				item:SetItemInfo(msitems.Get(class).WorldModel or blank, text.name, text.info)
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
					self.list:AddItem(item)
				end

				self.msitems[class] = item

			end
		end
		self.list:Rebuild()
	end

	function msitems.UpdateInventory(class, count)
		if IsValid(InventoryPanel) then
			if class and count and InventoryPanel.msitems[class] and count < 1 then
				InventoryPanel.msitems[class]:Remove()
			end
			InventoryPanel:UpdateInventory()
		end
	end

	timer.Create("msitems.stats.UpdateCurrentIcon", 0.2, 0, function()
		if IsValid(InventoryPanel) then InventoryPanel:UpdateEquiped() end
	end)

	InventoryPanel:UpdateInventory()
	--]]

	----

	StatsSheet:AddSheet("Player Stats",StatsPanel,"icon16/user.png",false,false,"Stats for your player and your server time")
	StatsSheet:AddSheet("Inventory",InventoryPanel,"icon16/box.png",false,false,"Inventory")

	local div = vgui.Create("DHorizontalDivider",Frame)
	div:Dock(FILL)
	div:SetLeft(PlayerDisplay)
	div:SetLeftMin(250)
	div:SetLeftWidth(250)
	div:SetRight(StatsSheet)
	div:SetRightMin(Frame:GetWide()-250)
	div:SetDividerWidth(4)
	function div:StartGrab() return false end

	function Frame:Think()
		if LocalPlayer():GetCustomTitle() == "" or LocalPlayer():GetCustomTitle() == nil or LocalPlayer():GetCustomTitle() == " " then stats_title_text = "No Title" else stats_title_text = LocalPlayer():GetCustomTitle() end

		PlayerAway:SetText(LocalPlayer():IsAFK() and "Away" or "")

		local time = LocalPlayer():GetUTime() + CurTime() - LocalPlayer():GetUTimeStart()

		local calc_time = string.FormattedTime(time)

		PlayerName:SetText(Name(LocalPlayer(),data))
		PlayerTitle:SetText(stats_title_text)
		PlayerCoins:SetText(LocalPlayer():GetCoins())
		PlayerTime:SetText((math.Round(calc_time.h/24)).." days | "..calc_time.h.." h, "..calc_time.m.." m, "..calc_time.s.." s")

		PlayerName:SizeToContents()
		PlayerTitle:SizeToContents()
		PlayerCoins:SizeToContents()
		PlayerTime:SizeToContents()

		PlayerName:SetColor(name_c or team.GetColor(LocalPlayer():Team()))
	end
end
