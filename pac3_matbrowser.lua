mat_browser = vgui.Create("DFrame")
mat_browser:SetSize(768,512)
mat_browser:Center()
mat_browser:SetTitle("Material Browser")
mat_browser:SetIcon("icon16/application_view_tile.png")
mat_browser:MakePopup()

local tree = vgui.Create("DTree",mat_browser)
tree:Dock(LEFT)
tree:SetWide(128)

local pac_mats    = tree:AddNode("Materials"):SetIcon("icon16/image.png")
local pac_trails  = tree:AddNode("Trails"):SetIcon("icon16/image.png")
local pac_sprites = tree:AddNode("Sprites"):SetIcon("icon16/image.png")
local toolgun     = tree:AddNode("Toolgun"):SetIcon("icon16/image.png")
local browse,asdf = tree:AddNode("Browse")
browse:SetIcon("icon16/folder.png")
browse:MakeFolder("materials","GAME")

local path_pnl = vgui.Create("EditablePanel",mat_browser)
path_pnl:Dock(TOP)
path_pnl:DockMargin(4,0,4,4)
path_pnl:SetTall(24)
local path = vgui.Create("DTextEntry",path_pnl)
path:SetText("")
path:Dock(FILL)
path:SetEditable(false)
local use = vgui.Create("DButton",path_pnl)
use:Dock(RIGHT)
use:SetWide(24)
use:SetImage("icon16/tick.png")
use:SetText("")
use:SetToolTip("Use Material")
function use:DoClick()
	SetClipboardText(path:GetText())
end
local copy = vgui.Create("DButton",path_pnl)
copy:Dock(RIGHT)
copy:SetWide(24)
copy:SetImage("icon16/page_copy.png")
copy:SetText("")
copy:SetToolTip("Copy Path")
function copy:DoClick()
	SetClipboardText(path:GetText())
end
local browser = vgui.Create("DIconBrowser",mat_browser)
browser:Dock(FILL)
browser:DockMargin(4,0,4,4)
function browser:OnChange()
	path:SetText(self:GetSelectedIcon())
end

local local_IconList = {}
function browser:Fill(tbl)
	self.Filled = true
	if ( self.m_bManual ) then return end

	local_IconList = tbl and tbl or {}

	for k, v in SortedPairs( local_IconList ) do

		timer.Simple( k * 0.001, function()

				if ( !IsValid( self ) ) then return end
				if ( !IsValid( self.IconLayout ) ) then return end

				local btn = self.IconLayout:Add( "DImageButton" )
				if string.sub(v,0,10) == "materials/" then
					string.gsub(v,"^materials%/","")
				end
				btn.FilterText = string.lower( v )
				btn:SetOnViewMaterial( v )
				btn:SetSize( 64, 64 )
				btn:SetPos( -64, -64 )
				btn:SetStretchToFit( true )
				btn:SetTooltip(v)

				btn.DoClick = function()

					self.m_pSelectedIcon = btn
					self.m_strSelectedIcon = btn:GetImage()
					self:OnChangeInternal()

				end

				btn.Paint = function( btn, w, h )

					if ( self.m_pSelectedIcon != btn ) then return end

					derma.SkinHook( "Paint", "Selection", btn, w, h )

				end

				if ( !self.m_pSelectedIcon || self.m_strSelectedIcon == btn:GetImage() ) then
					self.m_pSelectedIcon = btn
					--self:ScrollToChild( btn )
				end

				self.IconLayout:Layout()

			end )

	end
end
browser:Fill(pace.Materials.materials)

function tree:OnNodeSelected(node)
	browser:Clear()
	if node:GetText() == "Toolgun" then
		browser:Fill(list.Get("OverrideMaterials"))
	elseif node:GetText() == "Materials" then
		browser:Fill(pace.Materials.materials)
	elseif node:GetText() == "Trails" then
		browser:Fill(pace.Materials.trails)
	elseif node:GetText() == "Sprites" then
		browser:Fill(pace.Materials.sprites)
	else
		local Path = node:GetFolder()

		local files = file.Find( Path .. "/*.vmt", node:GetPathID() )
		files = table.Add( files, file.Find( Path .. "/*.png", node:GetPathID() ) )
		local files2 = {}

		local p = Path:gsub("^materials%/","")

		for _,f in next,files do
			f = f:gsub("%.vmt","")
			table.insert(files2,p.."/"..f)
		end
		browser:Fill(files2)
	end
end