local META = FindMetaTable("Player")

local FLSNotify = {}
net.new("FLSNotify",FLSNotify,"net")
:cl"xp"
:cl"lvlup"
:cl"headshot"

local function FLSPrint(msg)
	MsgC(Color(100,200,100),"[FLS] ",Color(255,255,255),msg,"\n")
end

function META:SetLevel(lvl)
	self:SetPData("fls_level",lvl)
	self:SetNWInt("fls_level",lvl)
end

function META:SetXP(xp)
	self:SetPData("fls_xp",xp)
	self:SetNWInt("fls_xp",xp)
end

function META:SetKills(kills)
	self:SetPData("fls_kills",kills)
	self:SetNWInt("fls_kills",kills)
end

function META:GetLevel()
	return self:GetNWInt("fls_level")
end

function META:GetXP()
	return self:GetNWInt("fls_xp")
end

function META:GetKills()
	return self:GetNWInt("fls_kills")
end

function META:ResetLevel()
	timer.Simple(0.1,function()
		self:SetLevel(1)
		self:SetXP(0)
		self:SetKills(0)
		if SERVER then
			FLSPrint("Level reset for "..tostring(self))
		end
	end)
end

function META:FixLevel()
	self:SetLevel(self:GetPData("fls_level") or 1)
	self:SetKills(self:GetPData("fls_kills") or 0)
	self:SetXP(self:GetPData("fls_xp") or 0)
end

if SERVER then
	hook.Add("PlayerDeath","FLS.PVP",function(vic,inf,att)
		if vic == att then return end
		if vic.IsBot and vic:IsBot() or att.IsBot and att:IsBot() then return end
		if att:IsPlayer() then
			local xp = math.random(10,100)
			att:SetXP(att:GetXP()+xp)
			att:SetKills(att:GetKills()+1)
			FLSNotify.net.xp(att,vic,xp).Broadcast()
			if vic:LastHitGroup() == HITGROUP_HEAD then
				local hs_xp = math.random(10,20)
				att:SetXP(att:GetXP()+hs_xp)
				FLSNotify.net.headshot(att,hs_xp).Broadcast()
			end
		end
	end)

	hook.Add("PlayerInitialSpawn","FLS.LoadOnJoin",function(ply)
		ply:SetLevel(ply:GetPData("fls_level") or 1)
		ply:SetXP(ply:GetPData("fls_xp") or 0)
		ply:SetKills(ply:GetPData("fls_kills") or 0)
		ply:FixLevel()
		FLSPrint("Data loaded for "..tostring(ply))
	end)

	hook.Add("PlayerDisconnected","FLS.SaveOnExit",function(ply)
		ply:FixLevel()
		ply:SetPData("fls_level",ply:GetLevel())
		ply:SetPData("fls_xp",ply:GetXP())
		ply:SetPData("fls_kills",ply:GetKills())
		FLSPrint("Data saved for "..tostring(ply))
	end)

	timer.Create("FLS.LevelUp",2,0,function()
		for _,ply in pairs(player.GetAll()) do
			if tonumber(ply:GetXP()) >= 5000 then
				ply:SetXP(ply:GetXP()-5000)
				ply:SetLevel(ply:GetLevel()+1)
				FLSNotify.net.lvlup(ply,ply:GetLevel()).Broadcast()
			end
		end
	end)

	FLSPrint("Loaded FLS")
end

if CLIENT then
	function FLSNotify:xp(who,who2,xp)
		chat.AddText(Color(100,200,100),"[FLS] ",who,Color(255,255,255)," got ",tostring(xp)," XP for killing ",who2)
	end
	function FLSNotify:lvlup(who,lvl)
		chat.AddText(Color(100,200,100),"[FLS] ",who,Color(255,255,255)," is now level ",Color(100,200,100),tostring(lvl))
	end
	function FLSNotify:headshot(who,xp)
		chat.AddText(Color(100,200,100),"[FLS] ",Color(200,0,0),"HEADSHOT! ",who,Color(255,255,255)," got ",tostring(xp)," bonus XP!")
		who:EmitSound("chatsounds/autoadd/instagib/headshot.ogg")
	end

	CreateClientConVar("fls_hud",0)
	CreateClientConVar("fls_hud_barcol",1)
	CreateClientConVar("fls_hud_top",0)

	local xp = tonumber(LocalPlayer():GetXP()/10-10)
	local posx = ScrW()/2-250
	local posy = ScrH()-55
	local bar = 0
	local barcol = Color(100,200,100)

	hook.Add("HUDPaint","FLS.HUD",function()
		if GetConVar("fls_hud_barcol"):GetInt() == 1 then
			barcol = Color(100,200,100)
		elseif GetConVar("fls_hud_barcol"):GetInt() == 2 then
			barcol = Color(200,100,100)
		elseif GetConVar("fls_hud_barcol"):GetInt() == 3 then
			barcol = Color(100,100,200)
		elseif GetConVar("fls_hud_barcol"):GetInt() == 4 then
			barcol = Color(200,200,100)
		elseif GetConVar("fls_hud_barcol"):GetInt() == 5 then
			barcol = Color(100,200,200)
		elseif GetConVar("fls_hud_barcol"):GetInt() == 6 then
			barcol = Color(200,100,200)
		elseif GetConVar("fls_hud_barcol"):GetInt() == 7 then
			barcol = Color(100,100,100)
		elseif GetConVar("fls_hud_barcol"):GetInt() == 8 then
			barcol = Color(200,200,200)
		else
			barcol = Color(100,200,100)
		end

		if GetConVar("fls_hud_top"):GetBool() then
			posy = 0
		else
			posy = ScrH()-55
		end

		if GetConVar("fls_hud"):GetInt() == 1 then
			xp = tonumber(LocalPlayer():GetXP()/10-10)
			draw.RoundedBox(0,posx,posy,500,55,Color(0,0,0,200))
			draw.DrawText("Level: "..LocalPlayer():GetLevel(),"DermaDefault",posx+5,posy+5,Color(255,255,255),TEXT_ALIGN_LEFT)
			draw.DrawText("Kills: "..LocalPlayer():GetKills(),"DermaDefault",posx+495,posy+5,Color(255,255,255),TEXT_ALIGN_RIGHT)
			bar = Lerp(FrameTime()*5,bar,xp)
			draw.RoundedBox(0,posx+5,posy+25,500-10,20,Color(0,0,0))
			draw.RoundedBox(0,posx+5,posy+25,bar-10,20,barcol)
			draw.DrawText("XP: "..LocalPlayer():GetXP().."/5000","DermaDefault",posx+250,posy+27,txtcol,TEXT_ALIGN_CENTER)
		end
	end)
end