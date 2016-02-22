local Tag = "FHUD"

--Get rid of default--

local remove = {
	CHudHealth          = true,
	CHudBattery         = true,
	CHudAmmo            = true,
	CHudSecondaryAmmo   = true,
	CHudCrosshair       = false,
	CHudWeaponSelection = false,
}

hook.Add("HUDShouldDraw","FlexHUD.Hide",function(name)
	if remove[name] then return false end
end )

--not called first frame :v
timer.Simple(0.1,function()
	--Overwriting with our own--
	hook.Remove("HUDPaint","PropInfo")

	--CakeHUD removal, saves some resources--
	hook.Remove("Think","CakeHUD")
	hook.Remove("HUDPaint","CakeHUD")
	hook.Remove("HUDShouldDraw","CakeHUD")

	--Kill IJWTB's HUD--
	for k, v in pairs(vgui.GetWorldPanel():GetChildren()) do
		if v:GetTable().ThisClass == "IHUD" then --yeah great panel name
			v:Remove()
		end
	end
end)

--ICONS + COLORS --

local FHUD = {}

FHUD.Colors = {
	Red    = Color(200, 100, 100),
	Green  = Color(100, 200, 100),
	Blue   = Color(100, 100, 200),
	Cyan   = Color(100, 200, 200),
	Yellow = Color(200, 200, 100),
	Pink   = Color(200, 100, 200),
}

FHUD.Icons = {
	Props    = Material("icon16/bricks.png"),
	Admin    = Material("icon16/shield.png"),
	Time     = Material("icon16/time.png"),
	Ping     = Material("icon16/transmit_blue.png"),
	FPS      = Material("icon16/computer.png"),
	Health   = Material("icon16/heart.png"),
	Armor    = Material("icon16/shield.png"),
	User     = Material("icon16/user.png"),
	PingBad  = Material("icon16/transmit.png"),
	FPSBad   = Material("icon16/computer_error.png"),
	Coins    = Material("icon16/coins.png"),
	NoCoins  = Material("icon16/coins_delete.png"),
	Velocity = Material("icon16/user_go.png"),
	Vehicle  = Material("icon16/car.png"),
}

FHUD.Ammo = {
	
}

--CVARS--

local Enabled        = CreateClientConVar("fhud_enabled"              ,1)

local BackR          = CreateClientConVar("fhud_bg_r"                 ,0)
local BackG          = CreateClientConVar("fhud_bg_g"                 ,0)
local BackB          = CreateClientConVar("fhud_bg_b"                 ,0)
local BackA          = CreateClientConVar("fhud_bg_a"                 ,200)
local OutlineR       = CreateClientConVar("fhud_outline_r"            ,128)
local OutlineG       = CreateClientConVar("fhud_outline_g"            ,200)
local OutlineB       = CreateClientConVar("fhud_outline_b"            ,200)
local OutlineA       = CreateClientConVar("fhud_outline_a"            ,255)
local HealthR        = CreateClientConVar("fhud_health_r"             ,100)
local HealthG        = CreateClientConVar("fhud_health_g"             ,50)
local HealthB        = CreateClientConVar("fhud_health_b"             ,50)
local HealthA        = CreateClientConVar("fhud_health_a"             ,255)
local ArmorR         = CreateClientConVar("fhud_armor_r"              ,50)
local ArmorG         = CreateClientConVar("fhud_armor_g"              ,50)
local ArmorB         = CreateClientConVar("fhud_armor_b"              ,100)
local ArmorA         = CreateClientConVar("fhud_armor_a"              ,255)
local TextR          = CreateClientConVar("fhud_text_r"               ,255)
local TextG          = CreateClientConVar("fhud_text_g"               ,255)
local TextB          = CreateClientConVar("fhud_text_b"               ,255)
local TextA          = CreateClientConVar("fhud_text_a"               ,255)

local TextUseOutline = CreateClientConVar("fhud_text_use_outline_col" ,1)

local ModulePlyInfo  = CreateClientConVar("fhud_module_plyinfo"       ,1)
local ModuleAmmo     = CreateClientConVar("fhud_module_ammo"          ,1)
local ModuleVelocity = CreateClientConVar("fhud_module_velocity"      ,1)
local ModuleCoins    = CreateClientConVar("fhud_module_coins"         ,1)

local UseMPH         = CreateClientConVar("fhud_velocity_use_mph"     ,0)

local TargetID       = CreateClientConVar("fhud_targetid"             ,1)
local Notifications  = CreateClientConVar("fhud_notifications"        ,1)

local PropInfo       = CreateClientConVar("fhud_propinfo"             ,0)

local FontText       = CreateClientConVar("fhud_font_text"            ,"Tahoma")
local FontBig        = CreateClientConVar("fhud_font_big"             ,"Tahoma")
local FontAmmo       = CreateClientConVar("fhud_font_ammo"            ,"Tahoma")
local FontPropInfo   = CreateClientConVar("fhud_font_propinfo"        ,"Tahoma")

--HUD--

function draw.OutlinedBox(x,y,w,h,thick,col)
	surface.SetDrawColor(col)
	for i=0, thick - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

local health = 0
local armor  = 0
local props  = {}
local moving = {}

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

--Fonts--
function FHUD_CreateFonts()
	surface.CreateFont(Tag.."_Text",{
		font = GetConVar("fhud_font_text"):GetString(),
		size = 14,
	})
	surface.CreateFont(Tag.."_Big",{
		font = GetConVar("fhud_font_big"):GetString(),
		size = 32,
	})
	surface.CreateFont(Tag.."_Ammo",{
		font = GetConVar("fhud_font_ammo"):GetString(),
		size = 64,
	})
	surface.CreateFont(Tag.."_PropInfo",{
		font = GetConVar("fhud_font_propinfo"):GetString(),
		size = 16,
		shadow = 1,
	})
end

FHUD_CreateFonts()

hook.Add("EntityRemoved", Tag..".Props", function(ent)
	props[ent]  = nil
	moving[ent] = nil
end)
local pacx = 0
local function FHUD_Init()

	if pace and pace.IsActive() and pace.Editor:GetAlpha() ~= 0 then
		pacx = pace.Editor:GetWide()
	else
		pacx = 0
	end

	if Enabled:GetInt() == 0 then return end
	local bgcol      = Color(BackR:GetInt()    ,BackG:GetInt()    ,BackB:GetInt()    ,BackA:GetInt())
	local outlinecol = Color(OutlineR:GetInt() ,OutlineG:GetInt() ,OutlineB:GetInt() ,OutlineA:GetInt())
	local healthcol  = Color(HealthR:GetInt()  ,HealthG:GetInt()  ,HealthB:GetInt()  ,HealthA:GetInt())
	local armorcol   = Color(ArmorR:GetInt()   ,ArmorG:GetInt()   ,ArmorB:GetInt()   ,ArmorA:GetInt())

	local posx = 0 + pacx
	local posy = ScrH()-150

	local textcol    = Color(255,255,255)
	if TextUseOutline:GetBool() then
		textcol = outlinecol
	else
		textcol = Color(TextR:GetInt(),TextG:GetInt(),TextB:GetInt(),TextA:GetInt())
	end

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

	local name_noc = LocalPlayer():GetName()
	name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
	name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
	name_noc = string.gsub(name_noc,"%^(%d+%.?%d*)","")

	for k,v in pairs(ents.FindByClass("prop_*")) do
		if IsValid(v) and v.CPPIGetOwner and v:CPPIGetOwner() == LocalPlayer() then
			props[v] = true
			local pvel = v
			pvel = v:GetVelocity(v)
			if pvel.Length(pvel) > 0 then
				moving[v] = true
			else
				moving[v] = nil
			end
		end
	end

	----PLYINFO MODULE----

	if ModulePlyInfo:GetBool() then

		--boxes--

		draw.RoundedBox(0,posx,posy,300,150,bgcol)
		draw.OutlinedBox(posx,posy,300,150,1,outlinecol)

		--name--

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(LocalPlayer():IsAdmin() and FHUD.Icons.Admin or FHUD.Icons.User)
		surface.DrawTexturedRect(posx+4,posy+4,16,16)

		draw.DrawText(name_noc,Tag.."_Text",posx+24,posy+6,c,TEXT_ALIGN_LEFT)

		--time--

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(FHUD.Icons.Time)
		surface.DrawTexturedRect(posx+4,posy+24,16,16)

		local time = "N/A"
		if LocalPlayer().GetUTime and LocalPlayer().GetUTimeStart then
			time = math.Round((LocalPlayer():GetUTime() + CurTime() - LocalPlayer():GetUTimeStart())/60/60)
		else
			time = "N/A"
		end

		draw.DrawText(time.." hours",Tag.."_Text",posx+24,posy+25,textcol,TEXT_ALIGN_LEFT)

		--props--

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(FHUD.Icons.Props)
		surface.DrawTexturedRect(posx+4,posy+44,16,16)

		draw.DrawText("Props: "..table.Count(props).."/"..GetConVar("sbox_maxprops"):GetInt().." ("..table.Count(moving).." moving)",Tag.."_Text",posx+24,posy+45,(table.Count(props) < GetConVar("sbox_maxprops"):GetInt()-10) and textcol or Color(200,100,100),TEXT_ALIGN_LEFT)

		--ping--

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(LocalPlayer():Ping() >= 200 and FHUD.Icons.PingBad or FHUD.Icons.Ping)
		surface.DrawTexturedRect(posx+4,posy+64,16,16)

		draw.DrawText("Ping: "..LocalPlayer():Ping(),Tag.."_Text",posx+24,posy+65,textcol,TEXT_ALIGN_LEFT)

		--fps--

		local fpscolor = math.Round(1/RealFrameTime()) < 30 and FHUD.Colors.Red or FHUD.Colors.Green

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(math.Round(1/RealFrameTime()) < 30 and FHUD.Icons.FPSBad or FHUD.Icons.FPS)
		surface.DrawTexturedRect(posx+4,posy+84,16,16)

		draw.DrawText("FPS: "..math.Round(1/RealFrameTime()),Tag.."_Text",posx+24,posy+85,fpscolor,TEXT_ALIGN_LEFT)

		--hp--

		local maxhp = LocalPlayer():GetMaxHealth()
		local hp    = LocalPlayer():Health()

		health = math.min(maxhp, (health == hp and health) or Lerp(0.05, health, hp))

		draw.RoundedBox(0,posx+4,posy+150-24,290,20,Color(0,0,0))
		draw.RoundedBox(0,posx+4,posy+150-24,math.Clamp(health*3,0,290),20,healthcol)

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(FHUD.Icons.Health)
		surface.DrawTexturedRect(posx+180/2,posy+150-22,16,16)

		draw.DrawText("Health: "..hp.."/"..maxhp,Tag.."_Text",posx+110,posy+150-22,textcol,TEXT_ALIGN_LEFT)

		--armor--

		local maxar = 200
		local ar    = LocalPlayer():Armor()

		armor = math.min(maxar, (armor == ar and armor) or Lerp(0.05, armor, ar))

		draw.RoundedBox(0,posx+4,posy+150-48,290,20,Color(0,0,0))
		draw.RoundedBox(0,posx+4,posy+150-48,math.Clamp(armor*1.5,0,290),20,armorcol)

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(FHUD.Icons.Armor)
		surface.DrawTexturedRect(posx+180/2,posy+150-46,16,16)

		draw.DrawText("Armor: "..ar.."/"..maxar,Tag.."_Text",posx+110,posy+150-46,textcol,TEXT_ALIGN_LEFT)

	end

	----AMMO----

	if ModuleAmmo:GetBool() then

		local clip = "0"
		local reserve = "0"

		local weapon  = LocalPlayer():GetActiveWeapon()
		if weapon then
			clip    = weapon.Clip1 and weapon:Clip1() or "0"
			reserve = LocalPlayer().GetAmmoCount and LocalPlayer():GetAmmoCount(weapon.GetPrimaryAmmoType and weapon:GetPrimaryAmmoType() or "none") or ""
			clip2   = LocalPlayer().GetAmmoCount and LocalPlayer():GetAmmoCount(weapon.GetSecondaryAmmoType and weapon:GetSecondaryAmmoType() or "none") or ""

			clip  = string.gsub(clip,"-1",0)
			clip2 = string.gsub(clip2,"-1",0)
		else
			clip    = "0"
			reserve = "0"
			clip2   = "0"
		end

		local a_posx = posx+300
		local a_posy = posy+150-52

		draw.RoundedBox(0,a_posx,a_posy,164,52,bgcol)
		draw.OutlinedBox(a_posx,a_posy,164,52,1,outlinecol)

		draw.DrawText(clip,Tag.."_Ammo",a_posx+2,a_posy-4,textcol,TEXT_ALIGN_LEFT)
		draw.DrawText(reserve,Tag.."_Big",a_posx+100,a_posy+20,textcol,TEXT_ALIGN_LEFT)

		draw.RoundedBox(0,a_posx,a_posy-52,128,52,bgcol)
		draw.OutlinedBox(a_posx,a_posy-52,128,52,1,outlinecol)
	draw.DrawText(clip2,Tag.."_Ammo",a_posx+2,a_posy-56,textcol,TEXT_ALIGN_LEFT)

	end

	----VELOCITY METER----

	if ModuleVelocity:GetBool() then

		local v_posx = posx
		local v_posy = posy-24

		draw.RoundedBox(0,v_posx,v_posy,150,24,bgcol)
		draw.OutlinedBox(v_posx,v_posy,150,24,1,outlinecol)

		surface.SetDrawColor(Color(255,255,255))
		surface.SetMaterial(LocalPlayer():GetVehicle() != NULL and FHUD.Icons.Vehicle or FHUD.Icons.Velocity)
		surface.DrawTexturedRect(v_posx+4,v_posy+4,16,16)

		local mph = 0

		if LocalPlayer():GetVehicle() != NULL then
			if LocalPlayer():GetVehicle():GetClass() == "prop_vehicle_prisoner_pod" then
				if IsValid(LocalPlayer():GetVehicle():GetParent()) then
					local vel = LocalPlayer():GetVehicle():GetParent()
					vel = vel.GetVelocity(vel)
					vel.z = 0
					if UseMPH:GetBool() then
						mph = math.Round(vel.Length(vel)* 3600 / 16 / 5280).." MPH"
					else
						mph = math.Round(vel.Length(vel)).." ups"
					end
					draw.DrawText(mph,Tag.."_Text",v_posx+24,v_posy+5,textcol)
				else
					local vel = LocalPlayer():GetVehicle()
					vel = vel.GetVelocity(vel)
					vel.z = 0
					if UseMPH:GetBool() then
						mph = math.Round(vel.Length(vel)* 3600 / 16 / 5280).." MPH"
					else
						mph = math.Round(vel.Length(vel)).." ups"
					end
					draw.DrawText(mph,Tag.."_Text",v_posx+24,v_posy+5,textcol)
				end
			else
				local vel = LocalPlayer():GetVehicle()
				vel = vel.GetVelocity(vel)
				vel.z = 0
				if UseMPH:GetBool() then
					mph = math.Round(vel.Length(vel)* 3600 / 16 / 5280).." MPH"
				else
					mph = math.Round(vel.Length(vel)).." ups"
				end
				draw.DrawText(mph,Tag.."_Text",v_posx+24,v_posy+5,textcol)
			end
		else
			local vel = LocalPlayer()
			vel = vel.GetVelocity(vel)
			vel.z = 0
			if UseMPH:GetBool() then
				mph = math.Round(vel.Length(vel)* 3600 / 16 / 5280).." MPH"
			else
				mph = math.Round(vel.Length(vel)).." ups"
			end
			draw.DrawText(mph,Tag.."_Text",v_posx+24,v_posy+5,textcol)
		end

	end

	----COINS----

	if ModuleCoins:GetBool() then
		if LocalPlayer().GetCoins then
			local c_posx = posx+150
			local c_posy = posy-24

			draw.RoundedBox(0,c_posx,c_posy,150,24,bgcol)
			draw.OutlinedBox(c_posx,c_posy,150,24,1,outlinecol)

			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(LocalPlayer():GetCoins() <= 100 and FHUD.Icons.NoCoins or FHUD.Icons.Coins)
			surface.DrawTexturedRect(c_posx+4,c_posy+4,16,16)

			draw.DrawText(LocalPlayer():GetCoins(),Tag.."_Text",c_posx+24,c_posy+5,textcol)
		end
	end

	----PROP INFO----
	if PropInfo:GetBool() then

		local pi_x,pi_y = pacx+4,ScrH()/2
		surface.SetFont(Tag.."_PropInfo")

		if SrvInfo and SrvInfo.GetInfo then
			local pre_off1,pre_off2 = surface.GetTextSize("Precached Models: ")
			local models = SrvInfo.GetInfo("Models")
			local percent = SrvInfo.GetInfo("Models")/2048*100
			local percentcol = Color(100,200,100)

			if percent < 75 then
				percentcol = Color(100,200,100)
			elseif percent >= 75 and percent < 90 then
				Color(200,200,100)
			elseif percent >= 90 then
				percentcol = Color(200,100,100)
			else
				percentcol = Color(100,200,100)
			end

			draw.DrawText("Precached Models: ",Tag.."_PropInfo",pi_x,pi_y-80,outlinecol)
			draw.DrawText(models.." ("..math.Round(percent).."%)",Tag.."_PropInfo",pi_x+pre_off1,pi_y-80,percentcol)
		end

		--Player Info--
		local plypos_off1,plypos_off2 = surface.GetTextSize("Player Pos: ")
		local plypos = LocalPlayer():GetPos()
		draw.DrawText("Player Pos: ",Tag.."_PropInfo",pi_x,pi_y-64,outlinecol)
		draw.DrawText("X: "..math.Round(plypos.x).." Y: "..math.Round(plypos.y).." Z: "..math.Round(plypos.z),Tag.."_PropInfo",pi_x+plypos_off1,pi_y-64,Color(100,200,100))

		local plyang_off1,plyang_off2 = surface.GetTextSize("Player Ang: ")
		local plyang = LocalPlayer():GetAngles()
		draw.DrawText("Player Ang: ",Tag.."_PropInfo",pi_x,pi_y-48,outlinecol)
		draw.DrawText("X: "..math.Round(plyang.x).." Y: "..math.Round(plyang.y).." Z: "..math.Round(plyang.z),Tag.."_PropInfo",pi_x+plyang_off1,pi_y-48,Color(100,200,100))

		--Target Info--
		local pi_trace = LocalPlayer():GetEyeTrace()
		local pi_tr_ent = pi_trace.Entity

		if pi_tr_ent and pi_tr_ent:IsValid() and pi_tr_ent != game.GetWorld() then
			local entindex_off1,entindex_off2 = surface.GetTextSize("Target Index: ")
			local entindex = pi_tr_ent:EntIndex()
			draw.DrawText("Target Index: ",Tag.."_PropInfo",pi_x,pi_y-32,outlinecol)
			draw.DrawText("Entity("..entindex..")",Tag.."_PropInfo",pi_x+entindex_off1,pi_y-32,Color(100,200,200))

			local entclass_off1,entclass_off2 = surface.GetTextSize("Target Class: ")
			local entclass = pi_tr_ent:GetClass()
			draw.DrawText("Target Class: ",Tag.."_PropInfo",pi_x,pi_y-16,outlinecol) 
			draw.DrawText(entclass,Tag.."_PropInfo",pi_x+entclass_off1,pi_y-16,Color(100,200,200))

			local entmdl_off1,entmdl_off2 = surface.GetTextSize("Target Model: ")
			local entmdl = pi_tr_ent:GetModel()
			draw.DrawText("Target Model: ",Tag.."_PropInfo",pi_x,pi_y,outlinecol)
			draw.DrawText(entmdl,Tag.."_PropInfo",pi_x+entmdl_off1,pi_y,Color(100,200,200))

			local entmat_off1,entmat_off2 = surface.GetTextSize("Target Material: ")
			local entmat = pi_tr_ent:GetMaterial()
			draw.DrawText("Target Material: ",Tag.."_PropInfo",pi_x,pi_y+16,outlinecol)
			draw.DrawText(entmat,Tag.."_PropInfo",pi_x+entmat_off1,pi_y+16,Color(100,200,200))

			local entpos_off1,entpos_off2 = surface.GetTextSize("Target Pos: ")
			local entpos = pi_tr_ent:GetPos()
			draw.DrawText("Target Pos: ",Tag.."_PropInfo",pi_x,pi_y+32,outlinecol)
			draw.DrawText("X: "..math.Round(entpos.x).." Y: "..math.Round(entpos.y).." Z: "..math.Round(entpos.z),Tag.."_PropInfo",pi_x+entpos_off1,pi_y+32,Color(100,200,200))

			local entang_off1,entang_off2 = surface.GetTextSize("Target Ang: ")
			local entang = pi_tr_ent:GetAngles()
			draw.DrawText("Target Ang: ",Tag.."_PropInfo",pi_x,pi_y+48,outlinecol)
			draw.DrawText("X: "..math.Round(entang.x).." Y: "..math.Round(entang.y).." Z: "..math.Round(entang.z),Tag.."_PropInfo",pi_x+entang_off1,pi_y+48,Color(100,200,200))

			local entowner_off1,entowner_off2 = surface.GetTextSize("Target Owner: ")
			local entowner = pi_tr_ent.CPPIGetOwner and pi_tr_ent:CPPIGetOwner() or "No Prop Protection/CPPI based"
			if !pi_tr_ent:IsPlayer() and isentity(entowner) and IsValid(entowner) and entowner:IsPlayer() then
				local entowner_name = entowner.Name and entowner:Name() or "No Owner?"
				draw.DrawText("Target Owner: ",Tag.."_PropInfo",pi_x,pi_y+64,outlinecol)
				draw.DrawText(entowner_name.." ("..tostring(entowner)..")",Tag.."_PropInfo",pi_x+entowner_off1,pi_y+64,Color(100,200,200))
			end
		end
	end

end

hook.Add("HUDPaint",Tag,FHUD_Init)

--TARGET ID--

local out = true
local delay = 0.3
local text,text2,text3,ent=nil,nil,nil,NULL
local font = Tag.."_TargetID"
local cleanname = ""
local namecol = textcol
local function haxtr()
	local EyePos=EyePos()
	local tr = {}

	tr.start=EyePos
	tr.endpos=EyePos+EyeAngles():Forward()*6000

	return util.TraceLine( tr )
end

surface.CreateFont(Tag.."_TargetID",{
	name   = "Tahoma",
	size   = 22,
	weight = 500,
	shadow = true,
})

local function FHUD_TargetID()
	if TargetID:GetInt() == 0 then return end
	local bgcol      = Color(BackR:GetInt()    ,BackG:GetInt()    ,BackB:GetInt()    ,BackA:GetInt())
	local outlinecol = Color(OutlineR:GetInt() ,OutlineG:GetInt() ,OutlineB:GetInt() ,OutlineA:GetInt())
	local healthcol  = Color(HealthR:GetInt()  ,HealthG:GetInt()  ,HealthB:GetInt()  ,HealthA:GetInt())
	local armorcol   = Color(ArmorR:GetInt()   ,ArmorG:GetInt()   ,ArmorB:GetInt()   ,ArmorA:GetInt())

	local textcol    = Color(255,255,255)
	if TextUseOutline:GetBool() then
		textcol = outlinecol
	else
		textcol = Color(TextR:GetInt(),TextG:GetInt(),TextB:GetInt(),TextA:GetInt())
	end
	local tcol       = textcol
	if TextUseOutline:GetInt() == 1 then
		textcol = outlinecol
	else
		textcol = Color(TextR:GetInt(),TextG:GetInt(),TextB:GetInt(),TextA:GetInt())
	end

	local trace = LocalPlayer():Alive() and LocalPlayer():GetEyeTrace() or haxtr()
	if not trace.Hit then
		out = out or RealTime()+0.1
	elseif not trace.HitNonWorld then
		out = out or RealTime()+0.1
	end

	local ent = trace.Entity

	if ent:IsPlayer() and ent != LocalPlayer() then
		local name_c
		for col in string.gmatch(ent:Name(),"%^(%d)") do
		name_c = PlayerColors[col]
		end
		for col1,col2,col3 in string.gmatch(ent:Name(),"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
		name_c = HSVToColor(col1,col2,col3)
		end
		for col1,col2,col3 in string.gmatch(ent:Name(),"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
		name_c = Color(col1,col2,col3,255)
		end
		namecol = name_c and name_c or team.GetColor(ent:Team())

		local name_noc = ent:GetName()
		name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"%^(%d)","")
		cleanname = name_noc and name_noc or ent:GetName()
	end

	if ent:IsVehicle() then
		for k,v in pairs(player.GetAll()) do
			if v:InVehicle() and v~=LocalPlayer() then
				local veh=v:GetVehicle()
				if veh==ent then
					ent=v
				end
			end
		end
	end

	if ent:IsPlayer() then
		tcol = namecol
		out=false
		text = cleanname
	elseif ent:IsWeapon() then
		tcol = textcol
		out=false
		text2=false
		text = ent.PrintName or ent:GetClass():gsub("weapon_",""):gsub("_", " ")
	else
		out = out or RealTime()+0.1
	end

	if out==true then return end
	local frac = 1

	if out then
		frac = (RealTime()-out)/delay
		frac=frac>1 and 1 or frac<0 and 0 or frac
		frac = 1 - frac
	end
	if frac==0 then out = true end
	if not text then text = "" else text = text end

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX, MouseY = gui.MousePos()

	if ( MouseX == 0 && MouseY == 0 ) then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 2

	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,frac*120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,frac*50) )
	local preva=tcol.a or 255
		tcol.a=frac*255
		draw.SimpleText( text, font, x, y, tcol or textcol )
	tcol.a=preva or 255

	if ent:IsPlayer() then
		local h=ent:Health()
		text2 = h.." HP"
		local a=ent:Armor()
		if a>0 then
			text3 = a.." AP"
		else
			text3 = ""
		end
	--elseif not ent:IsPlayer() then

	end
	if not text2 then text2 = "" else text2 = text2 end

	y = y + h + 5


	surface.SetFont( font )
	local w, h = surface.GetTextSize( text2 )
	local x =  MouseX

	draw.SimpleText( text2, font, x+1, y+1, Color(0,0,0,frac*120), TEXT_ALIGN_CENTER )
	draw.SimpleText( text2, font, x+2, y+2, Color(0,0,0,frac*50), TEXT_ALIGN_CENTER )
	local preva=textcol.a
		textcol.a=frac*255
		draw.SimpleText( text2, font, x, y, healthcol, TEXT_ALIGN_CENTER )
	textcol.a=preva

	if not text3 then text3 = "" else text3 = text3 end

	y = y + h + 5


	surface.SetFont( font )
	local w, h = surface.GetTextSize( text2 )
	local x =  MouseX

	draw.SimpleText( text3, font, x+1, y+1, Color(0,0,0,frac*120), TEXT_ALIGN_CENTER )
	draw.SimpleText( text3, font, x+2, y+2, Color(0,0,0,frac*50), TEXT_ALIGN_CENTER )
	local preva=textcol.a
		textcol.a=frac*255
		draw.SimpleText( text3, font, x, y, armorcol, TEXT_ALIGN_CENTER )
	textcol.a=preva

	return true --Overwrite gamemode TargetID
end

hook.Add("HUDDrawTargetID",Tag..".TargetID",FHUD_TargetID)

--NOTIFICATIONS--
notification.oldAddLegacy = notification.oldAddLegacy or notification.AddLegacy

surface.CreateFont(Tag.."_NotificationText",{
	name   = "Tahoma",
	size   = 18,
	weight = 500,
	shadow = true,
})

NOTIFY_GENERIC	= 0
NOTIFY_ERROR	= 1
NOTIFY_UNDO		= 2
NOTIFY_HINT		= 3
NOTIFY_CLEANUP	= 4

local Notices = {}

local function FHUDNotification( text, type, length )

	local parent = nil
	if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

	local Panel = vgui.Create( Tag.."_Notification", parent )
	Panel.StartTime = SysTime()
	Panel.Length = length
	Panel.VelX = -5
	Panel.VelY = 0
	Panel.fx = ScrW() + 200
	Panel.fy = ScrH()
	Panel:SetAlpha( 255 )
	Panel:SetText( text )
	Panel:SetLegacyType( type )
	Panel:SetPos( Panel.fx, Panel.fy )

	if type == NOTIFY_GENERIC then
		Panel.Image:SetImage("icon16/information.png")
	elseif type == NOTIFY_ERROR then
		Panel.Image:SetImage("icon16/exclamation.png")
	elseif type == NOTIFY_UNDO then
		Panel.Image:SetImage("icon16/arrow_undo.png")
	elseif type == NOTIFY_HINT then
		Panel.Image:SetImage("icon16/help.png")
	elseif type == NOTIFY_CLEANUP then
		Panel.Image:SetImage("icon16/brick_delete.png")
	else
		Panel.Image:SetImage("icon16/information.png")
	end


	table.insert( Notices, Panel )

end

local function UpdateNotice( i, Panel, Count )

	local x = Panel.fx
	local y = Panel.fy

	local w = Panel:GetWide()
	local h = Panel:GetTall()

	w = w + 16
	h = h + 16

	local ideal_y = ScrH() - (Count - i) * (h-12) - 150
	local ideal_x = ScrW() - w - 20

	local timeleft = Panel.StartTime - (SysTime() - Panel.Length)

	-- Cartoon style about to go thing
	if ( timeleft < 0.7  ) then
		ideal_x = ideal_x - 50
	end

	-- Gone!
	if ( timeleft < 0.2  ) then

		ideal_x = ideal_x + w * 2

	end

	local spd = FrameTime() * 15

	y = y + Panel.VelY * spd
	x = x + Panel.VelX * spd

	local dist = ideal_y - y
	Panel.VelY = Panel.VelY + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(Panel.VelY) < 0.1) then Panel.VelY = 0 end
	local dist = ideal_x - x
	Panel.VelX = Panel.VelX + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(Panel.VelX) < 0.1) then Panel.VelX = 0 end

	-- Friction.. kind of FPS independant.
	Panel.VelX = Panel.VelX * (0.95 - FrameTime() * 8 )
	Panel.VelY = Panel.VelY * (0.95 - FrameTime() * 8 )

	Panel.fx = x
	Panel.fy = y
	Panel:SetPos( Panel.fx, Panel.fy )

end


local function Update()

	if ( !Notices ) then return end

	local i = 0
	local Count = table.Count( Notices )
	for key, Panel in pairs( Notices ) do

		i = i + 1
		UpdateNotice( i, Panel, Count )

	end

	for k, Panel in pairs( Notices ) do

		if ( !IsValid(Panel) || Panel:KillSelf() ) then Notices[ k ] = nil end

	end

end

hook.Add( "Think", "NotificationThink", Update )

local PANEL = {}

function PANEL:Init()

	local outlinecol = Color(OutlineR:GetInt() ,OutlineG:GetInt() ,OutlineB:GetInt() ,OutlineA:GetInt())

	local textcol    = Color(255,255,255)
	if TextUseOutline:GetBool() then
		textcol = outlinecol
	else
		textcol = Color(TextR:GetInt(),TextG:GetInt(),TextB:GetInt(),TextA:GetInt())
	end


	self:DockPadding( 3, 3, 3, 3 )

	--[[self.Title = vgui.Create( "DLabel", self )
	self.Title:SetText("Notification")
	self.Title:Dock( TOP )
	self.Title:DockMargin(2,2,0,0)
	self.Title:SetFont( "DermaDefault" )
	self.Title:SetTextColor(textcol)
	self.Title:SetContentAlignment( 5 )]]

	self.Image = vgui.Create("DImage",self)
	self.Image:Dock(LEFT)
	self.Image:SetImage("icon16/information.png")
	self.Image:SetSize(16,16)
	self.Image:DockMargin(4,2,2,2)

	self.Label = vgui.Create( "DLabel", self )
	self.Label:Dock( TOP )
	self.Label:SetFont( Tag.."_NotificationText" )
	self.Label:SetTextColor(textcol)
	self.Label:SetContentAlignment( 5 )

	--self:SetBackgroundColor( Color( 20, 20, 20, 255*0.6) )
end

function PANEL:SetText( txt )

	self.Label:SetText( txt )
	self.Label:SizeToContents()
	--self.Title:SizeToContents()
	self:SizeToContents()

end

function PANEL:Paint(w,h)
	local bgcol      = Color(BackR:GetInt()    ,BackG:GetInt()    ,BackB:GetInt()    ,BackA:GetInt())
	local outlinecol = Color(OutlineR:GetInt() ,OutlineG:GetInt() ,OutlineB:GetInt() ,OutlineA:GetInt())
	draw.RoundedBox(0,0,0,w,h,bgcol)
	draw.OutlinedBox(0,0,w,h,1,outlinecol)
end

function PANEL:SizeToContents()

	self.Label:SizeToContents()

	local width = self.Label:GetWide()

	if ( IsValid( self.Image ) ) then

		width = width + 16 + 8

	end

	width = width + 20
	self:SetWidth( width )

	self:SetHeight( 24 )

	self:InvalidateLayout()

end

function PANEL:SetLegacyType( t )

	self:SizeToContents()

end


function PANEL:SetProgress()

	self.Paint = function( s, w, h )

		self.BaseClass.Paint( self, w, h )


		surface.SetDrawColor( 0, 100, 0, 150 )
		surface.DrawRect( 4, self:GetTall() - 10, self:GetWide() - 8, 5 )

		surface.SetDrawColor( 0, 50, 0, 255 )
		surface.DrawRect( 5, self:GetTall() - 9, self:GetWide() - 10, 3 )

		local w = self:GetWide() * 0.25
		local x = math.fmod( SysTime() * 200, self:GetWide() + w ) - w

		if ( x + w > self:GetWide() - 11 ) then w = ( self:GetWide() - 11 ) - x end
		if ( x < 0 ) then w = w + x; x = 0 end

		surface.SetDrawColor( 0, 255, 0, 255 )
		surface.DrawRect( 5 + x, self:GetTall() - 9, w, 3 )

	end

end

function PANEL:KillSelf()

	if ( self.StartTime + self.Length < SysTime() ) then

		self:Remove()
		return true

	end

	return false
end

vgui.Register( Tag.."_Notification", PANEL, "DPanel" )

--SPAWNMENU--

local function FHUDMenu(panel)
	local cat_toggle = vgui.Create("DCollapsibleCategory",panel)
	cat_toggle:Dock(TOP)
	cat_toggle:SetExpanded(1)
	cat_toggle:SetLabel("Toggleables")
	cat_toggle.Header:SetIcon("icon16/tick.png")
	cat_toggle.AddItem = function(cat,ctrl) ctrl:SetParent(cat) ctrl:Dock(TOP) end

	local check_hud = vgui.Create("DCheckBoxLabel",panel)
	check_hud:DockMargin(5,5,0,0)
	check_hud:SetText("Enabled?")
	check_hud:SetValue(1)
	check_hud:SetConVar("fhud_enabled")
	check_hud:SetTextColor(Color(0,0,0))
	cat_toggle:AddItem(check_hud)

	local check_textcol = vgui.Create("DCheckBoxLabel",panel)
	check_textcol:DockMargin(5,5,0,0)
	check_textcol:SetText("Use outline color for text color?")
	check_textcol:SetValue(0)
	check_textcol:SetConVar("fhud_text_use_outline_col")
	check_textcol:SetTextColor(Color(0,0,0))
	cat_toggle:AddItem(check_textcol)

	local check_targetid = vgui.Create("DCheckBoxLabel",panel)
	check_targetid:DockMargin(5,5,0,0)
	check_targetid:SetText("TargetID")
	check_targetid:SetValue(1)
	check_targetid:SetConVar("fhud_targetid")
	check_targetid:SetTextColor(Color(0,0,0))
	cat_toggle:AddItem(check_targetid)

	local check_notifications = vgui.Create("DCheckBoxLabel",panel)
	check_notifications:DockMargin(5,5,0,0)
	check_notifications:SetText("Custom Notifications")
	check_notifications:SetValue(1)
	check_notifications:SetConVar("fhud_notifications")
	check_notifications:SetTextColor(Color(0,0,0))
	cat_toggle:AddItem(check_notifications)

	local check_propinfo = vgui.Create("DCheckBoxLabel",panel)
	check_propinfo:DockMargin(5,5,0,0)
	check_propinfo:SetText("Prop Info")
	check_propinfo:SetValue(1)
	check_propinfo:SetConVar("fhud_propinfo")
	check_propinfo:SetTextColor(Color(0,0,0))
	cat_toggle:AddItem(check_propinfo)


	----

	local cat_modules = vgui.Create("DCollapsibleCategory",panel)
	cat_modules:Dock(TOP)
	cat_modules:SetExpanded(1)
	cat_modules:SetLabel("Modules")
	cat_modules.Header:SetIcon("icon16/application_view_tile.png")
	cat_modules.AddItem = function(cat,ctrl) ctrl:SetParent(cat) ctrl:Dock(TOP) end

	local check_m_plyinfo = vgui.Create("DCheckBoxLabel",panel)
	check_m_plyinfo:DockMargin(5,5,0,0)
	check_m_plyinfo:SetText("Player Info")
	check_m_plyinfo:SetValue(1)
	check_m_plyinfo:SetConVar("fhud_module_plyinfo")
	check_m_plyinfo:SetTextColor(Color(0,0,0))
	cat_modules:AddItem(check_m_plyinfo)

	local check_m_ammo = vgui.Create("DCheckBoxLabel",panel)
	check_m_ammo:DockMargin(5,5,0,0)
	check_m_ammo:SetText("Ammo")
	check_m_ammo:SetValue(1)
	check_m_ammo:SetConVar("fhud_module_ammo")
	check_m_ammo:SetTextColor(Color(0,0,0))
	cat_modules:AddItem(check_m_ammo)

	local check_m_velocity = vgui.Create("DCheckBoxLabel",panel)
	check_m_velocity:DockMargin(5,5,0,0)
	check_m_velocity:SetText("Player/Vehicle Velocity")
	check_m_velocity:SetValue(1)
	check_m_velocity:SetConVar("fhud_module_velocity")
	check_m_velocity:SetTextColor(Color(0,0,0))
	cat_modules:AddItem(check_m_velocity)

	local check_m_coins = vgui.Create("DCheckBoxLabel",panel)
	check_m_coins:DockMargin(5,5,0,0)
	check_m_coins:SetText("Show Coins")
	check_m_coins:SetValue(1)
	check_m_coins:SetConVar("fhud_module_coins")
	check_m_coins:SetTextColor(Color(0,0,0))
	cat_modules:AddItem(check_m_coins)

	----

	local cat_font = vgui.Create("DCollapsibleCategory",panel)
	cat_font:Dock(TOP)
	cat_font:SetExpanded(1)
	cat_font:SetLabel("Fonts")
	cat_font.Header:SetIcon("icon16/text_smallcaps.png")
	cat_font.AddItem = function(cat,ctrl) ctrl:SetParent(cat) ctrl:Dock(TOP) end

	local label_font_text = vgui.Create("DLabel",panel)
	label_font_text:DockMargin(5,5,0,0)
	label_font_text:SetFont("DermaDefault")
	label_font_text:SetText("Main Text Font:")
	label_font_text:SetColor(Color(0,0,0))
	label_font_text:SizeToContents()
	cat_font:AddItem(label_font_text)

	local txt_font_text = vgui.Create("DTextEntry",panel)
	txt_font_text:Dock(TOP)
	txt_font_text:SetTall(18)
	txt_font_text:SetText(GetConVar("fhud_font_text"):GetString())
	cat_font:AddItem(txt_font_text)

	local label_font_big = vgui.Create("DLabel",panel)
	label_font_big:DockMargin(5,5,0,0)
	label_font_big:SetFont("DermaDefault")
	label_font_big:SetText("Big Text Font:")
	label_font_big:SetColor(Color(0,0,0))
	label_font_big:SizeToContents()
	cat_font:AddItem(label_font_big)

	local txt_font_big = vgui.Create("DTextEntry",panel)
	txt_font_big:Dock(TOP)
	txt_font_big:SetTall(18)
	txt_font_big:SetText(GetConVar("fhud_font_big"):GetString())
	cat_font:AddItem(txt_font_big)

	local label_font_ammo = vgui.Create("DLabel",panel)
	label_font_ammo:DockMargin(5,5,0,0)
	label_font_ammo:SetFont("DermaDefault")
	label_font_ammo:SetText("Ammo Number Font:")
	label_font_ammo:SetColor(Color(0,0,0))
	label_font_ammo:SizeToContents()
	cat_font:AddItem(label_font_ammo)

	local txt_font_ammo = vgui.Create("DTextEntry",panel)
	txt_font_ammo:Dock(TOP)
	txt_font_ammo:SetTall(18)
	txt_font_ammo:SetText(GetConVar("fhud_font_ammo"):GetString())
	cat_font:AddItem(txt_font_ammo)

	local label_font_propinfo = vgui.Create("DLabel",panel)
	label_font_propinfo:DockMargin(5,5,0,0)
	label_font_propinfo:SetFont("DermaDefault")
	label_font_propinfo:SetText("Prop Info Font:")
	label_font_propinfo:SetColor(Color(0,0,0))
	label_font_propinfo:SizeToContents()
	cat_font:AddItem(label_font_propinfo)

	local txt_font_propinfo = vgui.Create("DTextEntry",panel)
	txt_font_propinfo:Dock(TOP)
	txt_font_propinfo:SetTall(18)
	txt_font_propinfo:SetText(GetConVar("fhud_font_propinfo"):GetString())
	cat_font:AddItem(txt_font_propinfo)

	local btn_font_apply = vgui.Create("DButton",panel)
	btn_font_apply:Dock(TOP)
	btn_font_apply:DockMargin(0,5,0,0)
	btn_font_apply:SetTall(20)
	btn_font_apply:SetText("Apply Fonts")
	cat_font:AddItem(btn_font_apply)

	function btn_font_apply:DoClick()
		LocalPlayer():ConCommand("fhud_font_text "..txt_font_text:GetText())
		LocalPlayer():ConCommand("fhud_font_big "..txt_font_big:GetText())
		LocalPlayer():ConCommand("fhud_font_ammo "..txt_font_ammo:GetText())
		LocalPlayer():ConCommand("fhud_font_propinfo "..txt_font_propinfo:GetText())
		timer.Simple(1,function()
			FHUD_CreateFonts()
			FHUD_CreateFonts()
		end)
	end

	----

	local cat_color = vgui.Create("DCollapsibleCategory",panel)
	cat_color:Dock(TOP)
	cat_color:SetExpanded(1)
	cat_color:SetLabel("Colors")
	cat_color.Header:SetIcon("icon16/color_wheel.png")
	cat_color.AddItem = function(cat,ctrl) ctrl:SetParent(cat) ctrl:Dock(TOP) end

	local label_bg = vgui.Create("DLabel",panel)
	label_bg:DockMargin(5,5,0,0)
	label_bg:SetFont("DermaDefault")
	label_bg:SetText("Background Color:")
	label_bg:SetColor(Color(0,0,0))
	label_bg:SizeToContents()
	cat_color:AddItem(label_bg)

	local color_bg = vgui.Create("DColorMixer",panel)
	color_bg:DockMargin(5,5,0,0)
	color_bg:SetPalette(true)
	color_bg:SetAlphaBar(true)
	color_bg:SetWangs(true)
	color_bg:SetColor(Color(BackR:GetInt(),BackG:GetInt(),BackB:GetInt(),BackA:GetInt()))
	color_bg:SetConVarR("fhud_bg_r")
	color_bg:SetConVarG("fhud_bg_g")
	color_bg:SetConVarB("fhud_bg_b")
	color_bg:SetConVarA("fhud_bg_a")
	cat_color:AddItem(color_bg)

	local label_outline = vgui.Create("DLabel",panel)
	label_outline:DockMargin(5,5,0,0)
	label_outline:SetFont("DermaDefault")
	label_outline:SetText("Outline Color:")
	label_outline:SetColor(Color(0,0,0))
	label_outline:SizeToContents()
	cat_color:AddItem(label_outline)

	local color_outline = vgui.Create("DColorMixer",panel)
	color_outline:DockMargin(5,5,0,0)
	color_outline:SetPalette(true)
	color_outline:SetAlphaBar(true)
	color_outline:SetWangs(true)
	color_outline:SetColor(Color(OutlineR:GetInt(),OutlineG:GetInt(),OutlineB:GetInt(),OutlineA:GetInt()))
	color_outline:SetConVarR("fhud_outline_r")
	color_outline:SetConVarG("fhud_outline_g")
	color_outline:SetConVarB("fhud_outline_b")
	color_outline:SetConVarA("fhud_outline_a")
	cat_color:AddItem(color_outline)

	local label_text = vgui.Create("DLabel",panel)
	label_text:DockMargin(5,5,0,0)
	label_text:SetFont("DermaDefault")
	label_text:SetText("Text Color: (fallback if not using outline color as text color)")
	label_text:SetColor(Color(0,0,0))
	label_text:SizeToContents()
	cat_color:AddItem(label_text)

	local color_text = vgui.Create("DColorMixer",panel)
	color_text:DockMargin(5,5,0,0)
	color_text:SetPalette(true)
	color_text:SetAlphaBar(true)
	color_text:SetWangs(true)
	color_text:SetColor(Color(TextR:GetInt(),TextG:GetInt(),TextB:GetInt(),TextA:GetInt()))
	color_text:SetConVarR("fhud_text_r")
	color_text:SetConVarG("fhud_text_g")
	color_text:SetConVarB("fhud_text_b")
	color_text:SetConVarA("fhud_text_a")
	cat_color:AddItem(color_text)

	local label_health = vgui.Create("DLabel",panel)
	label_health:DockMargin(5,5,0,0)
	label_health:SetFont("DermaDefault")
	label_health:SetText("Health Bar Color:")
	label_health:SetColor(Color(0,0,0))
	label_health:SizeToContents()
	cat_color:AddItem(label_health)

	local color_health = vgui.Create("DColorMixer",panel)
	color_health:DockMargin(5,5,0,0)
	color_health:SetPalette(true)
	color_health:SetAlphaBar(true)
	color_health:SetWangs(true)
	color_health:SetColor(Color(HealthR:GetInt(),HealthG:GetInt(),HealthB:GetInt(),HealthA:GetInt()))
	color_health:SetConVarR("fhud_health_r")
	color_health:SetConVarG("fhud_health_g")
	color_health:SetConVarB("fhud_health_b")
	color_health:SetConVarA("fhud_health_a")
	cat_color:AddItem(color_health)

	local label_armor = vgui.Create("DLabel",panel)
	label_armor:DockMargin(5,5,0,0)
	label_armor:SetFont("DermaDefault")
	label_armor:SetText("Armor Bar Color:")
	label_armor:SetColor(Color(0,0,0))
	label_armor:SizeToContents()
	cat_color:AddItem(label_armor)

	local color_armor = vgui.Create("DColorMixer",panel)
	color_armor:DockMargin(5,5,0,0)
	color_armor:SetPalette(true)
	color_armor:SetAlphaBar(true)
	color_armor:SetWangs(true)
	color_armor:SetColor(Color(ArmorR:GetInt(),ArmorG:GetInt(),ArmorB:GetInt(),ArmorA:GetInt()))
	color_armor:SetConVarR("fhud_armor_r")
	color_armor:SetConVarG("fhud_armor_g")
	color_armor:SetConVarB("fhud_armor_b")
	color_armor:SetConVarA("fhud_armor_a")
	cat_color:AddItem(color_armor)
end

function FHUD_Spawnmenu()
	spawnmenu.AddToolMenuOption( "Options",
	"Visuals",
	Tag,
	Tag,
	"",
	"",
	FHUDMenu )
end

hook.Add( "PopulateToolMenu", Tag..".Spawnmenu", FHUD_Spawnmenu )

local hooks = hook.GetTable()
hook.Add("Think",Tag..".Reinit",function()
	if !hooks.HUDPaint[Tag] then
		ErrorNoHalt("FHUD missing, reiniting!")
		hook.Add("HUDPaint",Tag,FHUD_Init)
	end
	if !hooks.HUDDrawTargetID[Tag..".TargetID"] then
		ErrorNoHalt("TragetID missing, reiniting!")
		hook.Add("HUDDrawTargetID",Tag..".TargetID",FHUD_TargetID)
	end

	--I guess this is a good place to put this
	if Notifications:GetBool() then
		notification.AddLegacy = FHUDNotification
	else
		notification.AddLegacy = notification.oldAddLegacy
	end
end)
