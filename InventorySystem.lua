if SERVER then return end

hook.Add("PopulateFBoxInv","InventorySystem",function( pnlContent, tree, node )
	local main_node = tree:AddNode( "Inventory", "icon16/package.png" )
	main_node.DoPopulate = function(self)
		if self.panel then return end

		self.panel = vgui.Create( "DScrollPanel", pnlContent )

		local PlayerDisplay = vgui.Create("DModelPanel",self.panel)
		PlayerDisplay.Entity = LocalPlayer()
		PlayerDisplay.OnRemove = nil
		PlayerDisplay:Dock(LEFT)
		PlayerDisplay:SetSize(256,384)
		PlayerDisplay:SetFOV(40)

		local ShouldDrawLocalPlayer

		function PlayerDisplay:Paint(w,h)
			--draw.RoundedBox(4,0,0,w,h,Color(53,53,53,200))
			if !IsValid(self.Entity) then return end

			local x, y = self:LocalToScreen(0,0)

			local ang = self.aLookAngle
			if ( !ang ) then
				ang = self.Entity:GetAngles()+Angle(0,180,0)
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
		end

		hook.Add("ShouldDrawLocalPlayer","FBoxInv",function()
			if ShouldDrawLocalPlayer then return true end
		end)

		local InvPanel = vgui.Create("DGrid",self.panel)
		InvPanel:Dock(LEFT)
		InvPanel:SetSize(640,384)
		InvPanel:SetCols(11)
		InvPanel:SetColWide(64)
		InvPanel:SetRowHeight(64)

		function InvPanel:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(64,64,64))
		end

		for i = 1,55 do
			local ItemPanel = vgui.Create("DButton")
			ItemPanel:SetSize(64,64)
			ItemPanel:DockMargin(0,0,2,0)
			ItemPanel:SetText("")
			ItemPanel.ItemData = {
				name = "Test",
				actions = {
					{
						name = "Eat",
						func = function()
							LocalPlayer():PrintMessage(3,"You ate something!")
						end,
						icon = "icon16/user_add.png"
					}
				}
			}
			InvPanel:AddItem(ItemPanel)

			function ItemPanel:DoClick()
				if ItemPanel.ItemData then
					local Menu = DermaMenu()
					Menu:AddOption(self.ItemData.actions[i].name,self.ItemData.actions[i].func):SetIcon(self.ItemData.actions[i].icon)
					Menu:SetPos(gui.MousePos())
					Menu:Open()
				else

				end
			end

			function ItemPanel:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(128,128,128))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(64,64,64))
			end
		end

	end

	main_node.DoClick = function(self)
		self:DoPopulate()
		pnlContent:SwitchPanel( self.panel )
	end

	local shop_node = tree:AddNode( "Shop", "icon16/cart_add.png" )
	shop_node.DoPopulate = function(self)
		if self.shoppanel then return end

		self.shoppanel = vgui.Create( "DScrollPanel", pnlContent )
	end

	shop_node.DoClick = function(self)
		self:DoPopulate()
		pnlContent:SwitchPanel( self.shoppanel )
	end

	local shop_node = tree:AddNode( "Trade", "icon16/arrow_refresh.png" )
	shop_node.DoPopulate = function(self)
		if self.shoppanel then return end

		self.shoppanel = vgui.Create( "DScrollPanel", pnlContent )
	end

	shop_node.DoClick = function(self)
		self:DoPopulate()
		pnlContent:SwitchPanel( self.shoppanel )
	end

	local FirstNode = tree:Root():GetChildNode( 0 )
	if ( IsValid( FirstNode ) ) then
		FirstNode:InternalDoClick()
	end
end)

spawnmenu.AddCreationTab( "Inventory", function()

	local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	ctrl:CallPopulateHook( "PopulateFBoxInv" )
	return ctrl

end, "icon16/box.png", 300 )

RunConsoleCommand("spawnmenu_reload")