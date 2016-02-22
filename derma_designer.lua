
local function derma_controls()
	local PANEL = {}

	function PANEL:Init()

		self:SetTitle( "Derma Initiative Control Test" )
		self.ContentPanel = vgui.Create( "DPropertySheet", self )
		self.ContentPanel:Dock( FILL )

		self:InvalidateLayout( true )
		local w, h = self:GetSize()

		local Controls = table.Copy( derma.GetControlList() )

		for key, ctrl in SortedPairs( derma.GetControlList() ) do

			local Ctrls = _G[ key ]
			if ( Ctrls && Ctrls.GenerateExample ) then

				Ctrls:GenerateExample( key, self.ContentPanel, w, h )

			end

		end

		self:SetSize( 600, 450 )

	end

	function PANEL:SwitchTo( name )
		self.ContentPanel:SwitchToName( name )
	end

	local vguiExampleWindow = vgui.RegisterTable( PANEL, "DFrame" )

	if ( IsValid( DermaExample ) ) then
		DermaExample:Remove()
	return end

	DermaExample = vgui.CreateFromTable( vguiExampleWindow )
	DermaExample:SwitchTo( args )
	DermaExample:MakePopup()
	DermaExample:Center()
end

DermaDesigner_Frame = vgui.Create("DFrame")
DermaDesigner_Frame:SetSize(ScrW()-200,ScrH()-100)
DermaDesigner_Frame:Center()
DermaDesigner_Frame:SetIcon("icon16/application_edit.png")
DermaDesigner_Frame:SetTitle("Derma Designer")
DermaDesigner_Frame:MakePopup()

----

local MenuBar = vgui.Create("DMenuBar",DermaDesigner_Frame)
MenuBar:Dock(TOP)
MenuBar:DockMargin(-3,-6,-3,0)

local File = MenuBar:AddMenu("File")
File:AddOption("New",function() end):SetIcon("icon16/page_white_add.png")
File:AddOption("Open",function() end):SetIcon("icon16/folder.png")
File:AddSpacer()
File:AddOption("Save",function() end):SetIcon("icon16/disk.png")
File:AddOption("Save As...",function() end):SetIcon("icon16/disk.png")
File:AddSpacer()
File:AddOption("Test",function() end):SetIcon("icon16/application_go.png")
File:AddSpacer()
File:AddOption("Exit",function() DermaDesigner_Frame:Close() end):SetIcon("icon16/cross.png")

local Edit = MenuBar:AddMenu("Edit")
Edit:AddOption("Insert Object",function() end):SetIcon("icon16/application_add.png")
Edit:AddOption("Paint Object",function() end):SetIcon("icon16/paintcan.png")
Edit:AddOption("Function",function() end):SetIcon("icon16/page_white_code.png")
Edit:AddSpacer()
Edit:AddOption("Undo",function() end):SetIcon("icon16/arrow_undo.png")
Edit:AddOption("Redo",function() end):SetIcon("icon16/arrow_redo.png")

local Help = MenuBar:AddMenu("Help")
Help:AddOption("Interactive Derma Elements",function() derma_controls() end):SetIcon("icon16/application_view_list.png")
Help:AddOption("VGUI Elements",function() gui.OpenURL("http://wiki.garrysmod.com/page/VGUI/Elements") end):SetIcon("games/16/garrysmod.png")
Help:AddSpacer()
Help:AddOption("About...",function() end):SetIcon("icon16/information.png")

----

local Properties = vgui.Create("DProperties",DermaDesigner_Frame)
Properties:Dock(BOTTOM)
Properties:SetTall(200)
Properties:DockMargin(-4,0,DermaDesigner_Frame:GetWide()-306,0)

local Frame_Name = Properties:CreateRow( "Properties", "Name" )
Frame_Name:Setup("Generic")
Frame_Name:SetValue("Project")
local Frame_Class = Properties:CreateRow( "Properties", "Class" )
Frame_Class:Setup("Generic")
Frame_Class:SetValue("none")
local Frame_SizeX = Properties:CreateRow( "Atributes", "SizeX" )
Frame_SizeX:Setup("Int",{min=0,max=ScrW()})
Frame_SizeX:SetValue(100)
local Frame_SizeY = Properties:CreateRow( "Atributes", "SizeY" )
Frame_SizeY:Setup("Int",{min=0,max=ScrH()})
Frame_SizeY:SetValue(100)
local Frame_PosX = Properties:CreateRow( "Atributes", "PosX" )
Frame_PosX:Setup("Int",{min=0,max=ScrW()})
Frame_PosX:SetValue(0)
local Frame_PosY = Properties:CreateRow( "Atributes", "PosY" )
Frame_PosY:Setup("Int",{min=0,max=ScrH()})
Frame_PosY:SetValue(0)

local TreeView = vgui.Create("DTree",DermaDesigner_Frame)
TreeView:Dock(LEFT)
TreeView:DockMargin(-4,-1,0,0)
TreeView:SetWide(300)

local ProjectNode = TreeView:AddNode("Project"):SetIcon("icon16/application_side_list.png")
