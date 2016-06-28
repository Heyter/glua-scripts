if SERVER then return end

if CLIENT then

--Misc Functions
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

	--Fonts
	surface.CreateFont("MetaDM_Name",{
		font = "Tahoma",
		size = 36,
		weight = 500,
		--outline = true
	})

	surface.CreateFont("MetaDM_Header",{
		font = "Tahoma",
		size = 24,
		weight = 500,
		--outline = true
	})


hook.Add("PopulateMetaDM","AddMetaDMContent",function( pnlContent, tree, node )

	local main_node = tree:AddNode( "Main", "icon16/vcard.png" )
	main_node.DoPopulate = function(self)
		if self.panel then return end

		self.panel = vgui.Create( "DScrollPanel", pnlContent )

		self.text = {}

		self.text.Welcome = vgui.Create("DLabel",self.panel)
		self.text.Welcome:SetText("Welcome")
		self.text.Welcome:SetColor(color_black)
		self.text.Welcome:SetFont("MetaDM_Header")
		self.text.Welcome:SizeToContents()
		self.text.Welcome:Dock(TOP)

		self.text.name = vgui.Create("DLabel",self.panel)
		self.text.name:SetText(Name(LocalPlayer(),data))
		self.text.name:SetColor(name_c)
		self.text.name:SetFont("MetaDM_Name")
		self.text.name:SizeToContents()
		self.text.name:Dock(TOP)

		local PlayerDisplay = vgui.Create("DModelPanel",self.panel)
		PlayerDisplay.Entity = LocalPlayer()
		PlayerDisplay.OnRemove = nil
		PlayerDisplay:Dock(LEFT)
		PlayerDisplay:SetSize(300,500)

		local ShouldDrawLocalPlayer

		function PlayerDisplay:Paint(w,h)
			draw.RoundedBox(4,0,0,w,h,Color(53,53,53,200))
			if !IsValid(self.Entity) then return end

			local x, y = self:LocalToScreen(0,0)

			local ang = self.aLookAngle
			if ( !ang ) then
				ang = self.Entity:GetAngles()+Angle(0,RealTime()*25,0)
			end

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

			draw.SimpleText("NOTE: Your PAC will only draw here when in thirdperson.","DermaDefault",5,h-16,color_white)
		end

		local statslist = vgui.Create("DListView",self.panel)
		statslist:SetMultiSelect(false)
		statslist:Dock(LEFT)
		statslist:SetSize(200)
		statslist:DockMargin(10,0,0,0)

		statslist:AddColumn("Stat")
		statslist:AddColumn("Value")

		statslist:AddLine("Kills","0")
		statslist:AddLine("Deaths","0")

		hook.Add("ShouldDrawLocalPlayer","MetaDM_Preview",function()
			if ShouldDrawLocalPlayer then return true end
		end)
	end

	main_node.DoClick = function(self)
		self:DoPopulate()
		pnlContent:SwitchPanel( self.panel )
		self.text.name:SetText(Name(LocalPlayer(),data))
		self.text.name:SetColor(name_c)
	end

	local match_node = tree:AddNode( "Matchmaking", "icon16/group_go.png" )
	match_node.DoPopulate = function(self)
		if self.match_panel then return end

		self.match_panel = vgui.Create( "DScrollPanel", pnlContent )

		self.text = {}

		self.text.matchmaking = vgui.Create("DLabel",self.match_panel)
		self.text.matchmaking:SetText("Matchmaking Menu")
		self.text.matchmaking:SetColor(color_black)
		self.text.matchmaking:SetFont("MetaDM_Header")
		self.text.matchmaking:SizeToContents()
		self.text.matchmaking:Dock(TOP)

	end

	match_node.DoClick = function(self)
		self:DoPopulate()
		pnlContent:SwitchPanel( self.match_panel )
	end

	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end
end)

spawnmenu.AddCreationTab( "MetaDM", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "PopulateMetaDM" )
	return ctrl

end, "icon16/gun.png", 1 )

RunConsoleCommand("spawnmenu_reload")

end