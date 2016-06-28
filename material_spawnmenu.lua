surface.CreateFont("Material_Title",{
	font = "Roboto Regular",
	size = 24,
})

surface.CreateFont("Material_Label",{
	font = "Roboto Medium",
	size = 16,
})

local DarkMode = CreateClientConVar("materia_darkmode",0)

local PANEL = {}

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()

	self.MenuActive = false

	self.titlebar = vgui.Create("EditablePanel",self)
	self.titlebar:Dock(TOP)
	self.titlebar:SetTall(48)
	self.titlebar:DockMargin(0,-28,0,0)
	function self.titlebar:Paint(w,h)
		draw.RoundedBox(0,0,0,w,48,Color(84,110,122))
	end

	self.menubtn = vgui.Create("DButton",self.titlebar)
	self.menubtn:Dock(LEFT)
	self.menubtn:SetWide(48)
	self.menubtn:SetText("")
	self.menubtn:DockMargin(6,0,0,0)
	function self.menubtn:Paint(w,h)
		draw.RoundedBox(0,6,14,w-20,3,Color(255,255,255))
		draw.RoundedBox(0,6,22,w-20,3,Color(255,255,255))
		draw.RoundedBox(0,6,30,w-20,3,Color(255,255,255))
	end

	self:Populate()
	self:SetFadeTime( 0 )

	self.title = vgui.Create("DLabel",self.titlebar)
	self.title:Dock(LEFT)
	self.title:SetFont("Material_Title")
	self.title:SetTextColor(Color(255,255,255))
	self.title:SetText(self:GetActiveTab():GetText())
	self.title:SizeToContents()

	self.menu = vgui.Create("DPanelList",self)
	self.menu:Dock(LEFT)
	self.menu:SetWide(300)
	self.menu:SetVisible(false)
	function self.menu:Paint(w,h)
		draw.RoundedBox(0,0,0,300,h,Color(255,255,255))
	end

	self.menubtn.DoClick = function()
		if self.MenuActive == true then
			self.MenuActive = false
			self.menu:SetVisible(false)
		else
			self.MenuActive = true
			self.menu:SetVisible(true)
		end
	end

end

function PANEL:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,DarkMode:GetInt() == 1 and Color(66, 66, 66) or Color(224, 224, 224))
end

--[[function PANEL:AddSheet( label, panel, material, NoStretchX, NoStretchY, Tooltip )

	if ( !IsValid( panel ) ) then return end

	local Sheet = {}

	Sheet.Name = label;

	Sheet.Tab = vgui.Create( "DButton", self )
	Sheet.Tab:SetTooltip( Tooltip )
	--Sheet.Tab:Setup( label, self, panel, material )
	Sheet.Tab:SetText(label)
	Sheet.Tab:SetIcon(material)
	function Sheet.Tab:DoClick()
		self:GetParent():GetParent():SetActiveTab(panel)
	end
	function Sheet.Tab:PerformLayout()
		if ( IsValid( self.m_Image ) ) then
			self.m_Image:SetSize(48,48)
			self.m_Image:SetPos( 16, ( self:GetTall() - self.m_Image:GetTall() ) * 0.5 )
			self:SetTextInset( self.m_Image:GetWide() + 8, 0 )
		end


	end

	Sheet.Panel = panel
	Sheet.Panel.NoStretchX = NoStretchX
	Sheet.Panel.NoStretchY = NoStretchY
	Sheet.Panel:SetPos( self:GetPadding(), 20 + self:GetPadding() )
	Sheet.Panel:SetVisible( false )

	panel:SetParent( self )

	table.insert( self.Items, Sheet )

	if ( !self:GetActiveTab() ) then
		self:SetActiveTab( Sheet.Tab )
		Sheet.Panel:SetVisible( true )
	end

	self.menu:AddPanel( Sheet.Tab )

	return Sheet;

end--]]

function PANEL:Populate()

	local tabs = spawnmenu.GetCreationTabs()

	for k, v in SortedPairsByMemberValue( tabs, "Order" ) do

		--
		-- Here we create a panel and populate it on the first paint
		-- that way everything is created on the first view instead of
		-- being created on load.
		--
		local pnl = vgui.Create( "Panel" )

		self:AddSheet( k, pnl, v.Icon, nil, nil, v.Tooltip )

		--
		-- On paint, remove the paint function and populate the panel
		--
		pnl.Paint = function()

			pnl.Paint = nil

			local childpnl = v.Function()
			childpnl:SetParent( pnl )
			childpnl:Dock( FILL )

		end
	end
end

vgui.Register( "CreationMenu", PANEL, "DPropertySheet" )

local PANEL = {}

AccessorFunc( PANEL, "m_pSelectedPanel", 		"SelectedPanel" )

--[[---------------------------------------------------------
   Name: Paint
-----------------------------------------------------------]]
function PANEL:Init()
		
	self:SetPaintBackground( false )
	
	self.CategoryTable = {}	
	
	self.ContentNavBar = vgui.Create( "ContentSidebar", self );
	self.ContentNavBar:Dock( LEFT );
	self.ContentNavBar:SetSize( 190, 10 );
	self.ContentNavBar:DockMargin( 0, 0, 4, 0 )
	
	
	self.HorizontalDivider = vgui.Create( "DHorizontalDivider", self );	
	self.HorizontalDivider:Dock( FILL );
	self.HorizontalDivider:SetLeftWidth( 175 )
	self.HorizontalDivider:SetLeftMin( 175 )
	self.HorizontalDivider:SetRightMin( 450 )
	
	self.HorizontalDivider:SetLeft( self.ContentNavBar );
	
end

function PANEL:EnableModify()
	self.ContentNavBar:EnableModify()
end

function PANEL:CallPopulateHook( HookName )

	hook.Call( HookName, GAMEMODE, self, self.ContentNavBar.Tree, self.OldSpawnlists )

end

function PANEL:SwitchPanel( panel )

	if ( IsValid( self.SelectedPanel ) ) then
		self.SelectedPanel:SetVisible( false );
		self.SelectedPanel = nil;
	end
	
	self.SelectedPanel = panel

	self.SelectedPanel:Dock( FILL )
	self.SelectedPanel:SetVisible( true )
	self:InvalidateParent()
	
	self.HorizontalDivider:SetRight( self.SelectedPanel );
	
end


vgui.Register( "SpawnmenuContentPanel", PANEL, "DPanel" )



local function CreateContentPanel()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:DockMargin(0,28,0,0)

	ctrl.OldSpawnlists = ctrl.ContentNavBar.Tree:AddNode( "#spawnmenu.category.browse", "icon16/cog.png" )
	
	ctrl:EnableModify()
	hook.Call( "PopulatePropMenu", GAMEMODE )
	ctrl:CallPopulateHook( "PopulateContent" );

		
	ctrl.OldSpawnlists:MoveToFront()
	ctrl.OldSpawnlists:SetExpanded( true )

	return ctrl

end

spawnmenu.AddCreationTab( "#spawnmenu.content_tab", CreateContentPanel, "icon16/application_view_tile.png", -10 )
