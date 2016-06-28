local remove = {
	CHudCrosshair = true,
}

hook.Add("HUDShouldDraw","FCrosshair",function(name)
	if remove[name] then return false end
end )

hook.Add("HUDPaint","FCrosshair",function()
	local tr = LocalPlayer():GetEyeTrace()
	local c_col = IsValid(tr.Entity) and Color(33,91,51) or Color(0,150,130)
	local trp = {
		x=ScrW()/2,
		y=ScrH()/2,
	}
	draw.RoundedBox(0,trp.x+8,trp.y,16,4,Color(0,0,0))
	draw.RoundedBox(0,trp.x+9,trp.y+1,14,2,c_col)
	draw.RoundedBox(0,trp.x-20,trp.y,16,4,Color(0,0,0))
	draw.RoundedBox(0,trp.x-19,trp.y+1,14,2,c_col)
	draw.RoundedBox(0,trp.x,trp.y+8,4,16,Color(0,0,0))
	draw.RoundedBox(0,trp.x+1,trp.y+9,2,14,c_col)
	draw.RoundedBox(0,trp.x,trp.y-20,4,16,Color(0,0,0))
	draw.RoundedBox(0,trp.x+1,trp.y-19,2,14,c_col)
end)