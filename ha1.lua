local chars = {"#","$","£","§"}
surface.CreateFont("DOSFont",{
	font = "System",
	size = 32,
})
local font = "DOSFont"
local color = Color(200,255,200)

local function ondraw()
	local centerx,centery = ScrH()/2,ScrW()/2
	--draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0))
	local c = table.Random(chars)

	--h
	draw.DrawText(string.rep(c,4),font,0,0,color)
	draw.DrawText(string.rep(c,3),font,16,24,color)
	draw.DrawText(string.rep(c,3),font,16,24*2,color)
	draw.DrawText(string.rep(c,3),font,16,24*3,color)
	draw.DrawText(string.rep(c,3),font,16*6,24*3,color)
	draw.DrawText(string.rep(c,5),font,16,24*4,color)
	draw.DrawText(string.rep(c,3),font,16,24*5,color)
	draw.DrawText(string.rep(c,3),font,16,24*6,color)
	draw.DrawText(string.rep(c,3),font,16,24*7,color)
	draw.DrawText(string.rep(c,4),font,0,24*8,color)
	draw.DrawText(string.rep(c,3),font,16*7,24*4,color)
	draw.DrawText(string.rep(c,3),font,16*7,24*5,color)
	draw.DrawText(string.rep(c,3),font,16*7,24*6,color)
	draw.DrawText(string.rep(c,3),font,16*7,24*7,color)
	draw.DrawText(string.rep(c,3),font,16*7,24*8,color)
	--a
	draw.DrawText(string.rep(c,5),font,16*12,24*3,color)
	draw.DrawText(string.rep(c,3),font,16*16,24*4,color)
	draw.DrawText(string.rep(c,7),font,16*12,24*5,color)
	draw.DrawText(string.rep(c,3),font,16*11,24*6,color)
	draw.DrawText(string.rep(c,3),font,16*11,24*7,color)
	draw.DrawText(string.rep(c,4),font,16*12,24*8,color)
	draw.DrawText(string.rep(c,3),font,16*16,24*6,color)
	draw.DrawText(string.rep(c,3),font,16*16,24*7,color)
	draw.DrawText(string.rep(c,3),font,16*17,24*8,color)
	--!
	draw.DrawText(string.rep(c,3),font,16*23,0,color)
	draw.DrawText(string.rep(c,5),font,16*22,24*1,color)
	draw.DrawText(string.rep(c,5),font,16*22,24*2,color)
	draw.DrawText(string.rep(c,5),font,16*22,24*3,color)
	draw.DrawText(string.rep(c,3),font,16*23,24*4,color)
	draw.DrawText(string.rep(c,1),font,16*24,24*5,color)
	draw.DrawText(string.rep(c,3),font,16*23,24*7,color)
	draw.DrawText(string.rep(c,3),font,16*23,24*8,color)
	--version A
	draw.DrawText("version A",font,16*26/2,24*10,color,TEXT_ALIGN_CENTER)
end

hook.Add("HUDPaint","ha1",ondraw)