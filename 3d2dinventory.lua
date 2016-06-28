surface.CreateFont("flex_inv_big",{
	font = "Roboto Medium",
	size = 64,
})

surface.CreateFont("flex_inv_text",{
	font = "Roboto Medium",
	size = 32,
})

surface.CreateFont("flex_inv_texts",{
	font = "Roboto Medium",
	size = 24,
})

hook.Add("PostDrawOpaqueRenderables","3d2dinventory",function()
	local ang = me:EyeAngles()
	local pos = me:EyePos()+(ang:Up()*50)-(ang:Right()*-20)-(ang:Forward()*-30)
	ang:RotateAroundAxis(ang:Up(),180)
	ang:RotateAroundAxis(ang:Up(),-12)
	ang:RotateAroundAxis(ang:Forward(),90)
	ang:RotateAroundAxis(ang:Right(),-90)
	cam.Start3D2D(pos,ang,0.15)
		draw.RoundedBox(0,0,0,600,70,Color(0,0,0,200))
		draw.DrawText("Inventory","flex_inv_big",600/2,0,Color(255,255,255),TEXT_ALIGN_CENTER)

		draw.RoundedBox(0,0,80,600,70,Color(0,0,0,200))
		draw.RoundedBox(0,0,80,70,70,Color(128,128,128,255))
		draw.DrawText("None","flex_inv_text",74,80,Color(255,255,255),TEXT_ALIGN_LEFT)
		draw.DrawText("Nothing currently equipped","flex_inv_texts",74,110,Color(255,255,255),TEXT_ALIGN_LEFT)
		local inventory = LocalPlayer():GetInventory()
		local i = 0
		for c,d in pairs(inventory) do
			if not d.data then continue end

			if d.data then
				i = i+0.5
				draw.RoundedBox(0,0,160*i+160,600,70,Color(0,0,0,200))
				draw.RoundedBox(0,0,160*i+160,70,70,Color(128,128,128,255))
				draw.DrawText(d.data.inventory.name,"flex_inv_text",74,160*i+160,Color(255,255,255),TEXT_ALIGN_LEFT)
				draw.DrawText(d.data.inventory.info,"flex_inv_texts",74,190*i+190,Color(255,255,255),TEXT_ALIGN_LEFT)
			end
		end
	cam.End3D2D()
end)

hook.Add("CalcView","3d2dinventory",function(ply,pos,ang,fov)
	local view = {}
	--ang:RotateAroundAxis(ang:Up(),180)

	view.origin = pos-( ang:Forward()*70 )+(ang:Right()*40)-(ang:Up()*5)
	view.angles = ang
	view.fov = fov
	view.drawviewer = true

	return view
end)