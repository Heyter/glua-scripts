--[[
███████╗██╗     ███████╗██╗  ██╗██████╗  ██████╗ ██╗  ██╗
██╔════╝██║     ██╔════╝╚██╗██╔╝██╔══██╗██╔═══██╗╚██╗██╔╝
█████╗  ██║     █████╗   ╚███╔╝ ██████╔╝██║   ██║ ╚███╔╝ 
██╔══╝  ██║     ██╔══╝   ██╔██╗ ██╔══██╗██║   ██║ ██╔██╗ 
██║     ███████╗███████╗██╔╝ ██╗██████╔╝╚██████╔╝██╔╝ ██╗
╚═╝     ╚══════╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝          
featuring
                                                                                                        
 _     _                .                  .            _            
 `.   /    ___    __.  _/_   `   ___       /       ___  \ ___    ____
   \,'    /   ` .'   \  |    | .'   `      |      /   ` |/   \  (    
  ,'\    |    | |    |  |    | |           |     |    | |    `  `--. 
 /   \   `.__/|  `._.'  \__/ /  `._.'      /---/ `.__/| `___,' \___.'
		   - Security is our priority -
                                                                   

This code is copyrighted by Flex. You are not allowed to redistribute.
The following code was made by Xaotic.
--]]
AddCSLuaFile()
surface.CreateFont( "XHUD", {
	font = "Century Gothic",
	size = 33,
	weight = 300,
	antialias = true,
} )


local oldmoney = 0
local money = 0

local TimeAdd = 0
local TimeTake = 0
local numadd = 0
local numtake = 0 
local flyup = 0
local transp = 255
//Century Gothic
hook.Add("HUDPaint", "xao_overlay", function()
	money = tonumber(LocalPlayer():GetMoney()) or tonumber(0)

if oldmoney < money then
	TimeTake = 0
	flyup = 0
	transp = 255
	TimeAdd = CurTime()+3
	numadd = money - oldmoney
	oldmoney = money

end

if oldmoney > money then
	TimeAdd = 0
	flyup = 0
	transp = 255
	numtake = oldmoney - money
	TimeTake = CurTime()+3
	oldmoney = money
end


	//End
surface.SetMaterial(Material("icon16/money.png"))
//icon32/money.png
surface.SetDrawColor(Color(0,0,0,255))
surface.DrawTexturedRect( ScrW()-33, ScrH()-33, 36, 36 )
surface.SetDrawColor(Color(255,255,255,255))
surface.DrawTexturedRect( ScrW()-30, ScrH()-30, 30, 30 )
money = string.format("%G", money)
//Shadow
draw.DrawText( "$"..money, "XHUD", ScrW()-30-1, ScrH()-33+1, Color( 0,0,0,255 ), TEXT_ALIGN_RIGHT )
draw.DrawText( "$"..money, "XHUD", ScrW()-30+1, ScrH()-33+1, Color( 0,0,0,255 ), TEXT_ALIGN_RIGHT )
draw.DrawText( "$"..money, "XHUD", ScrW()-30+1, ScrH()-33-1, Color( 0,0,0,255 ), TEXT_ALIGN_RIGHT )
draw.DrawText( "$"..money, "XHUD", ScrW()-30-1, ScrH()-33-1, Color( 0,0,0,255 ), TEXT_ALIGN_RIGHT )
//End

draw.DrawText( "$"..money, "XHUD", ScrW()-30, ScrH()-33, Color( 200,250,200,255 ), TEXT_ALIGN_RIGHT )



if TimeAdd > CurTime() then
flyup = flyup -0.2
transp = transp - 1.3
draw.DrawText( "+$"..numadd, "XHUD", ScrW()-30, ScrH()-33+flyup, Color( 50,250,50,transp ), TEXT_ALIGN_RIGHT )
end

if TimeTake > CurTime() then
flyup = flyup -0.4
transp = transp - 1.2
draw.DrawText( "-$"..numtake, "XHUD", ScrW()-30, ScrH()-33+flyup, Color( 250,100,100,transp ), TEXT_ALIGN_RIGHT )
end
end)
MsgN(" _     _                .                  .            _            \n `.   /    ___    __.  _/_   `   ___       /       ___  \\ ___    ____\n   \\,'    /   ` .'   \\  |    | .'   `      |      /   ` |/   \\  (    \n  ,'\\    |    | |    |  |    | |           |     |    | |    `  `--. \n /   \\   `.__/|  `._.'  \\__/ /  `._.'      /---/ `.__/| `___,' \\___.'\n		   - Security is our priority -\n")