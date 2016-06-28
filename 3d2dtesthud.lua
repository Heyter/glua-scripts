local MAT_DOFBLUR = CreateMaterial("dofblur","Refract",{
["$model"]         = "1",
["$dudvmap"]       = "models/wireframe",
["$normalmap"]     = "models/wireframe",
["$refractamount"] = "0",
["$vertexalpha"]   = "1",
["$vertexcolor"]   = "1",
["$translucent"]   = "1",
["$forcerefract"]  = "1",
["$bluramount"]    = "1",
["$nofog"]         = "1",
["Refract_DX60"]   = {["$fallbackmaterial"] = "null"}
})

for i=1, 10 do
	MAT_DOFBLUR:SetFloat( "$blur", Fraction )
	MAT_DOFBLUR:Recompute()
	render.UpdateFullScreenDepthTexture( )
	render.UpdatePowerOfTwoTexture( )
	render.UpdateRefractTexture( )
	if ( render ) then render.UpdateScreenEffectTexture() end
end


local function drawblur(x,y,w,h)
	surface.SetMaterial( MAT_DOFBLUR )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect(x,y,w,h)
end


local health = 0

hook.Add("PostDrawHUD","testhud",function()
	local ply = LocalPlayer()
	local pos = ply:EyePos()+ply:EyeAngles():Forward()*10+ply:EyeAngles():Right()*-12+ply:EyeAngles():Up()*-5
	local ang = ply:EyeAngles()
	ang:RotateAroundAxis(ang:Up(),-90)
	ang:RotateAroundAxis(ang:Right(),0)
	ang:RotateAroundAxis(ang:Forward(),90)
	ang:RotateAroundAxis(ang:Forward(),-20)
	ang:RotateAroundAxis(ang:Right(),-20)

	cam.Start3D()
	cam.Start3D2D(pos,ang,0.02)
		--drawblur(0,0,220,100)
		draw.RoundedBox(0,0,0,220,100,Color(0,0,0,128))
		draw.RoundedBox(0,10,10,200,24,Color(30,30,30,128))
		local maxhp  = LocalPlayer():GetMaxHealth()
		local hp     = LocalPlayer():Health()

		health = math.min(maxhp, (health == hp and health) or Lerp(0.05, health, hp))
		draw.RoundedBox(0,10,10,math.Clamp(health*2,0,200),24,Color(255,100,0))
		draw.RoundedBox(0,60,10,2,24,Color(0,0,0))
		draw.RoundedBox(0,110,10,2,24,Color(0,0,0))
		draw.RoundedBox(0,160,10,2,24,Color(0,0,0))
	cam.End3D2D()
	cam.End3D()
end)