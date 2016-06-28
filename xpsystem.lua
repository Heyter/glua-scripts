local ply = FindMetaTable("Player")

local fls_notify = {}
net.new("fls_notify",fls_notify,'net')
	:cl"xp_notify"
	:cl"level_notify"
	:cl"custom_msg"

local function FLSFancyPrint(text)
	MsgC(Color(100,200,100),"[FLS] ",Color(255,255,255),text.."\n")
end

function ply:SetLevel(value)
	self:SetPData("flex_xp_level",value)
	self:SetNWInt("flex_xp_level",value)
	self.XPLevel = value
end

function ply:GetLevel()
	return self:GetNWInt("flex_xp_level") or self:GetPData("flex_xp_level") or 1
end

function ply:SetXP(value)
	self:SetPData("flex_xp_value",value)
	self:SetNWInt("flex_xp_value",value)
	self.XPValue = value
end

function ply:GetXP(value)
	return self:GetNWInt("flex_xp_value") or self:GetPData("flex_xp_value") or 0
end

function ply:GetKills()
	return self:GetNWInt("flex_xp_kills") or self:GetPData("flex_xp_kills") or 0
end

function ply:SetKills(value)
	self:SetPData("flex_xp_kills",value)
	self:SetNWInt("flex_xp_kills",value)
end

function ply:AddKill()
	self:SetKills(self:GetKills()+1)
end

function ply:FixLevel()
	self:SetKills(self:GetPData("flex_xp_kills") or 0)
	self:SetLevel(self:GetPData("flex_xp_level") or 1)
	self:SetXP(self:GetPData("flex_xp_value") or 0)
end

function ply:ResetLevel()
	timer.Simple(0.1,function()
		self:SetLevel(1)
		self:SetXP(0)
		self:SetKills(0)
		if SERVER then
			FLSFancyPrint("Level reset for "..self:RealNick())
		end
	end)
end

if SERVER then

	hook.Add("PlayerDeath","FlexLevelSystem_PVP",function(vic,inf,att)
		if vic == att then return end
		if vic.IsBot and vic:IsBot() or att.IsBot and att:IsBot() then return end
		if att:IsPlayer() then
			local xp = math.random(10,100)
			att:SetXP(att:GetXP()+xp)
			if SERVER then
				fls_notify.net.xp_notify(att,vic,xp).Broadcast()
				att:AddKill()
			end
		end
	end)

	hook.Add("Think","FlexLevelSystem_LevelUp",function()
		local all = player.GetAll()
		for _,ply in pairs(all) do
			if tonumber(ply:GetXP()) >= 5000 then
				if timer.Exists("FixLevelUp") then return end
				timer.Create("FixLevelUp",1,1,function()
					ply:SetXP(ply:GetXP()-5000)
					ply:SetLevel(ply:GetLevel()+1)
					if SERVER then
						fls_notify.net.level_notify(ply,ply:GetLevel()).Broadcast()
					end
				end)
			end
		end
	end)

	hook.Add("PlayerInitialSpawn","FlexLevelSystem_SetLevel",function(ply)
		if ply:GetLevel() == nil or tonumber(ply:GetLevel()) == 0 or "" then
			ply:SetLevel(1)
		end
		if ply:GetKills() == nil or "" then
			ply:SetKills(0)
		end
		if ply:GetXP() == nil or "" then
			ply:SetXP(0)
		end
		ply:FixLevel()
		FLSFancyPrint("Data loaded for "..ply:RealName())
	end)

	hook.Add("PlayerDisconnected","FlexLevelSystem_SaveOnDC",function(ply)
		ply:SetPData("flex_xp_level",ply:GetLevel())
		ply:SetPData("flex_xp_value",ply:GetXP())
		ply:SetPData("flex_xp_kills",ply:GetKills())
		FLSFancyPrint("Data saved for "..ply:RealName())
	end)

end

if CLIENT then
	function FLS_Debug()
		for _,ply in pairs(player.GetAll()) do
			print(ply:Name(),ply:GetLevel(),ply:GetXP(),ply:GetKills())
		end
	end

	function fls_notify:xp_notify(who,who2,value)
		chat.AddText(Color(100,200,100,255),"[FLS] ",who,Color(255,255,255,255)," got ",Color(100,200,100,255),tostring(value),Color(255,255,255,255)," XP for killing ",who2)
	end
	function fls_notify:level_notify(who,value)
		chat.AddText(Color(100,200,100,255),"[FLS] ",who,Color(255,255,255,255)," is now level ",Color(100,200,100,255),tostring(value))
	end
	function fls_notify:custom_msg(msg)
		chat.AddText(Color(100,200,100),"[FLS] ",Color(255,255,255),tostring(msg))
	end

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

	CreateClientConVar("flex_xp_hud",0,true,false)
	CreateClientConVar("flex_xp_hud_leaderboard",0,true,false)
	CreateClientConVar("flex_xp_hud_left",0,true,false)
	CreateClientConVar("flex_xp_hud_use_plyc",1,true,false)
	CreateClientConVar("flex_xp_hud_fullcolor",0,true,false)
	CreateClientConVar("flex_xp_hud_color_r",0,true,false)
	CreateClientConVar("flex_xp_hud_color_g",0,true,false)
	CreateClientConVar("flex_xp_hud_color_b",0,true,false)
	CreateClientConVar("flex_xp_hud_color_a",200,true,false)
	CreateClientConVar("flex_xp_hud_text_r",255,true,false)
	CreateClientConVar("flex_xp_hud_text_g",255,true,false)
	CreateClientConVar("flex_xp_hud_text_b",255,true,false)
	CreateClientConVar("flex_xp_hud_text_a",255,true,false)
	CreateClientConVar("flex_xp_hud_bar_r",100,true,false)
	CreateClientConVar("flex_xp_hud_bar_g",200,false)
	CreateClientConVar("flex_xp_hud_bar_b",100,true,false)
	CreateClientConVar("flex_xp_hud_bar_a",255,true,false)


	hook.Add("Think","FlexLevelSystem_XPFix",function()
			LocalPlayer():SetXP(LocalPlayer():GetNWInt("flex_xp_value"))
			LocalPlayer():SetKills(LocalPlayer():GetNWInt("flex_xp_kills"))
	end)

	local xp = tonumber(LocalPlayer():GetXP()/0.25-10)
	local value = 0

	hook.Add("HUDPaint","FlexLevelSystem_HUD",function()
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

		local plycol = Color(GetConVar("flex_xp_hud_color_r"):GetInt(),GetConVar("flex_xp_hud_color_g"):GetInt(),GetConVar("flex_xp_hud_color_b"):GetInt(),GetConVar("flex_xp_hud_color_a"):GetInt())
		local hudcol = Color(0,0,0,200)
		local txtcol = Color(GetConVar("flex_xp_hud_text_r"):GetInt(),GetConVar("flex_xp_hud_text_g"):GetInt(),GetConVar("flex_xp_hud_text_b"):GetInt(),GetConVar("flex_xp_hud_text_a"):GetInt())
		local barcol = Color(GetConVar("flex_xp_hud_bar_r"):GetInt(),GetConVar("flex_xp_hud_bar_g"):GetInt(),GetConVar("flex_xp_hud_bar_b"):GetInt(),GetConVar("flex_xp_hud_bar_a"):GetInt())

		local pos = 0

		if GetConVar("flex_xp_hud_use_plyc"):GetInt() == 1 then hudcol = c else hudcol = plycol end
		if GetConVar("flex_xp_hud_left"):GetInt() == 1 then pos = 0 else pos = ScrW()-250 end

		if LocalPlayer():GetXP() == nil or LocalPlayer():GetLevel() == nil or LocalPlayer():GetKills() == nil then return end
		if GetConVar("flex_xp_hud"):GetInt() == 1 then
			xp = tonumber(LocalPlayer():GetXP()/10/2-10)
			draw.RoundedBox(0,pos,0,250,70,hudcol)
			draw.DrawText("Level: "..LocalPlayer():GetLevel(),"DermaDefault",pos+5,5,txtcol,TEXT_ALIGN_LEFT)
			draw.DrawText("Kills: "..LocalPlayer():GetKills(),"DermaDefault",pos+245,5,txtcol,TEXT_ALIGN_RIGHT)
			value = Lerp(FrameTime()*5,value,xp)
			draw.RoundedBox(0,pos+5,5+16+4,250-10,20,Color(0,0,0))
			draw.RoundedBox(0,pos+5,5+16+4,value-10,20,barcol)
			draw.DrawText("XP: "..LocalPlayer():GetXP().."/5000","DermaDefault",pos+128,5+16+6,txtcol,TEXT_ALIGN_CENTER)
			--draw.DrawText("NPCs: "..#ents.FindByClass("npc_*"),"DermaDefault",ScrW()-5,50+2,txtcol,TEXT_ALIGN_RIGHT)
			draw.DrawText("Players: "..#player.GetAll(),"DermaDefault",pos+5,50+2,txtcol,TEXT_ALIGN_LEFT)
		end

		local ltf = 0

		if GetConVar("flex_xp_hud_leaderboard"):GetInt() == 1 and GetConVar("flex_xp_hud"):GetInt() == 1 then
			local fullcol = Color(0,0,0,200)
			ltf = Lerp(FrameTime()*0.1,ltf,ltf+1)
			if GetConVar("flex_xp_hud_fullcolor"):GetInt() == 1 then fullcol = hudcol else fullcol = Color(0,0,0,200) end
			draw.RoundedBox(0,pos,100,250,20*(#player.GetAll()),fullcol)
			draw.RoundedBox(0,pos,80,250,20,hudcol)
			draw.RoundedBox(0,pos,80,ltf,20,barcol)
			draw.DrawText("Leaderboard","DermaDefault",pos+128,80+3,txtcol,TEXT_ALIGN_CENTER)

			local plytab = {}

			for _,ply in pairs(player.GetAll()) do
				table.insert(plytab,{player=ply,kills=tonumber(ply:GetKills())})
			end

			table.SortByMember(plytab,"kills")

			for num,list in pairs(plytab) do
				local name_noc = list["player"]:GetName()
				name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
				name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
				name_noc = string.gsub(name_noc,"%^(%d)","")

				local name_c
				for col in string.gmatch(list["player"]:Name(),"%^(%d)") do
				name_c = PlayerColors[col]
				end
				for col1,col2,col3 in string.gmatch(list["player"]:Name(),"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
				name_c = HSVToColor(col1,col2,col3)
				end
				for col1,col2,col3 in string.gmatch(list["player"]:Name(),"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
				name_c = Color(col1,col2,col3,255)
				end
				local c = name_c and name_c or team.GetColor(list["player"]:Team())

				draw.DrawText(name_noc,"DermaDefault",pos+5,80+20*num,name_c or team.GetColor(list["player"]:Team()),TEXT_ALIGN_LEFT)
				draw.DrawText("Level: "..list["player"]:GetLevel(),"DermaDefault",pos+128,80+20*num,txtcol,TEXT_ALIGN_CENTER)
				draw.DrawText("Kills: "..list["player"]:GetKills(),"DermaDefault",pos+245,80+20*num,txtcol,TEXT_ALIGN_RIGHT)
			end
		end
	end)

	function FLSMenu()
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
		name_noc = string.gsub(name_noc,"%^(%d)","")

		local frame_icon = Material("icon16/script_add.png")

		flsframe = vgui.Create("DFrame")
		flsframe:SetSize(800,500)
		flsframe:SetTitle("")
		flsframe:Center()
		flsframe:MakePopup()

		function flsframe:Paint(w,h)

			draw.RoundedBoxEx(10,0,0,w,24,c,true,true,false,false)
			draw.RoundedBoxEx(10,0,24,w,h-24,Color(0,0,0,200),false,false,true,true)

			draw.DrawText("Flex's Level System","DermaDefault",26,5,Color(255,255,255),TEXT_ALIGN_LEFT)

			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(frame_icon)
			surface.DrawTexturedRect(5,5,16,16)
		end

		local tabs = vgui.Create("DPropertySheet",flsframe)
		tabs:Dock(FILL)

		function tabs:Paint() end

		local stats = vgui.Create("DScrollPanel",tabs)
		function stats:Paint() end
		tabs:AddSheet("Stats",stats,"icon16/vcard.png")

		local welcome = vgui.Create("DLabel",stats)
		welcome:SetFont("DermaLarge")
		welcome:SetText("Welcome, "..name_noc)
		welcome:SetColor(Color(255,255,255))
		welcome:SizeToContents()
		welcome:Dock(TOP)

		local xp = tonumber(LocalPlayer():GetXP())
		local xpbar = tonumber(LocalPlayer():GetXP()/10/2)
		local value = 0
		local level = vgui.Create("DPanel",stats)
		level:Dock(TOP)
		level:SetSize(500,32)
		level:DockMargin(0,5,0,0)
		function level:Paint(w,h)
			draw.RoundedBox(0,0,0,500,32,Color(255,255,255))
			value = Lerp(FrameTime()*5,value,xpbar)
			draw.RoundedBox(0,0,0,value,32,Color(100,200,100))
			draw.DrawText("Level: "..LocalPlayer():GetLevel()..", XP: "..xp.."/5000","DermaDefault",250,10,Color(0,0,0),TEXT_ALIGN_CENTER)
		end

		----

		local options = vgui.Create("DScrollPanel",tabs)
		function options:Paint() end
		tabs:AddSheet("Options",options,"icon16/cog.png")

		--HUD OPTIONS--

		local hud_opts = vgui.Create("DCollapsibleCategory",options)
		hud_opts:Dock(TOP)
		hud_opts:SetExpanded(0)
		hud_opts:SetLabel("HUD Options")
		hud_opts.Header:SetIcon("icon16/application_edit.png")
		hud_opts.AddItem = function(cat,ctrl) ctrl:SetParent(cat) ctrl:Dock(TOP) end
		function hud_opts:Paint(w,h) draw.RoundedBox(4,0,0,w,20,c) end

		local hud = vgui.Create("DCheckBoxLabel",options)
		hud:DockMargin(5,5,0,0)
		hud:SetText("XP HUD Enabled?")
		hud:SetValue(0)
		hud:SetConVar("flex_xp_hud")
		hud_opts:AddItem(hud)

		local leaderboard = vgui.Create("DCheckBoxLabel",options)
		leaderboard:DockMargin(5,5,0,0)
		leaderboard:SetText("Leaderboard Enabled?")
		leaderboard:SetValue(0)
		leaderboard:SetConVar("flex_xp_hud_leaderboard")
		hud_opts:AddItem(leaderboard)

		local leftmode = vgui.Create("DCheckBoxLabel",options)
		leftmode:DockMargin(5,5,0,0)
		leftmode:SetText("Move HUD to the left side?")
		leftmode:SetValue(0)
		leftmode:SetConVar("flex_xp_hud_left")
		hud_opts:AddItem(leftmode)

		--COLOR OPTIONS--

		local col_opts = vgui.Create("DCollapsibleCategory",options)
		col_opts:Dock(TOP)
		col_opts:SetExpanded(0)
		col_opts:SetLabel("Color Options")
		col_opts.Header:SetIcon("icon16/palette.png")
		col_opts.AddItem = function(cat,ctrl) ctrl:SetParent(cat) ctrl:Dock(TOP) end
		function col_opts:Paint(w,h) draw.RoundedBox(4,0,0,w,20,c) end

		local plyc = vgui.Create("DCheckBoxLabel",options)
		plyc:DockMargin(5,5,0,0)
		plyc:SetText("Use name/team color?")
		plyc:SetValue(0)
		plyc:SetConVar("flex_xp_hud_use_plyc")
		col_opts:AddItem(plyc)

		local full = vgui.Create("DCheckBoxLabel",options)
		full:DockMargin(5,5,0,0)
		full:SetText("Use full color on leaderboard?")
		full:SetValue(0)
		full:SetConVar("flex_xp_hud_fullcolor")
		col_opts:AddItem(full)

		local bglbl = vgui.Create("DLabel",options)
		bglbl:DockMargin(5,5,0,0)
		bglbl:SetFont("DermaDefault")
		bglbl:SetText("Background Color:")
		bglbl:SetColor(Color(255,255,255))
		bglbl:SizeToContents()
		col_opts:AddItem(bglbl)

		local bgcol = vgui.Create("DColorMixer",options)
		bgcol:DockMargin(5,5,0,0)
		bgcol:SetPalette(true)
		bgcol:SetAlphaBar(true)
		bgcol:SetWangs(true)
		bgcol:SetColor(Color(0,0,0,200))
		bgcol:SetConVarR("flex_xp_hud_color_r")
		bgcol:SetConVarG("flex_xp_hud_color_g")
		bgcol:SetConVarB("flex_xp_hud_color_b")
		bgcol:SetConVarA("flex_xp_hud_color_a")
		col_opts:AddItem(bgcol)

		local txtlbl = vgui.Create("DLabel",options)
		txtlbl:DockMargin(5,5,0,0)
		txtlbl:SetFont("DermaDefault")
		txtlbl:SetText("Text Color:")
		txtlbl:SetColor(Color(255,255,255))
		txtlbl:SizeToContents()
		col_opts:AddItem(txtlbl)

		local txtcol = vgui.Create("DColorMixer",options)
		txtcol:DockMargin(5,5,0,0)
		txtcol:SetPalette(true)
		txtcol:SetAlphaBar(true)
		txtcol:SetWangs(true)
		txtcol:SetColor(Color(255,255,255,255))
		txtcol:SetConVarR("flex_xp_hud_text_r")
		txtcol:SetConVarG("flex_xp_hud_text_g")
		txtcol:SetConVarB("flex_xp_hud_text_b")
		txtcol:SetConVarA("flex_xp_hud_text_a")
		col_opts:AddItem(txtcol)

		local xplbl = vgui.Create("DLabel",options)
		xplbl:DockMargin(5,5,0,0)
		xplbl:SetFont("DermaDefault")
		xplbl:SetText("XP Bar Color:")
		xplbl:SetColor(Color(255,255,255))
		xplbl:SizeToContents()
		col_opts:AddItem(xplbl)

		local xpcol = vgui.Create("DColorMixer",options)
		xpcol:DockMargin(5,5,0,0)
		xpcol:SetPalette(true)
		xpcol:SetAlphaBar(true)
		xpcol:SetWangs(true)
		xpcol:SetColor(Color(100,200,100,255))
		xpcol:SetConVarR("flex_xp_hud_bar_r")
		xpcol:SetConVarG("flex_xp_hud_bar_g")
		xpcol:SetConVarB("flex_xp_hud_bar_b")
		xpcol:SetConVarA("flex_xp_hud_bar_a")
		col_opts:AddItem(xpcol)
	end

	hook.Add( "PlayerSay", "FLSMenu", function(ply,text)
		if (string.sub(text,1,8) == "!flsmenu") or (string.sub(text,1,8) == "/flsmenu") and ply == LocalPlayer() then
			FLSMenu()
		end
	end)
end