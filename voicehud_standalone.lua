--[[
Voice chat HUD replacement
Reskinned from QBox (Metastruct)
--]]

if SERVER then
	include'sh_voice.lua'
	AddCSLuaFile'sh_voice.lua'
	return
end

local GM = GAMEMODE and GAMEMODE or gmod.GetGamemode()

-- Client pref cvar
--  1: on
--  0: server pref
-- -1: off
CreateClientConVar("cl_voicedistance","0",true,true)
local function nodraw()
	if hook.Call("HUDShouldDraw",gmod.GetGamemode(),"CHudVoiceStatus")==false then
		--print"nodraw"
		return true
	else
		--print"draw"
	end
end


local PANEL={}
function PANEL:Init()
    self:SetSize(200,32)
    self:SizeTo(200,32,1,0,4)
    self.ava=vgui.Create('AvatarImage',self)
    self.ava:Dock(RIGHT)
    self.ava:SetSize(32,32)
	self.alpha=0
end

function PANEL:PerformLayout()
end

function PANEL:PerformLayoutEx(k,maxh)
    if not self._y then
	self._y=maxh-self:GetTall()-(k-1)*(32+2)
    end
    if self._y!=y then self:GetParent():InvalidateLayout() end
    local t = maxh-self:GetTall()-(k)*(32+2)
    self._y=math.Approach(self._y,t,FrameTime()*300)
    self:SetPos(0,self._y)

end

local cola,colb=
Color(30,30,30,255),
Color(60,60,60,255)
function PANEL:Paint()
	local pl = self.pl

	local vol = IsValid(pl) and pl:VoiceVolume()
	if vol then
		vol=vol+0.5
		vol=vol>1 and 1 or vol<0 and 0 or vol
		vol=vol*90
	end
	local c=vol or 90
	colb.r=c
	colb.g=c
	colb.b=c
    draw.RoundedBoxEx(16,0,0,self:GetWide()-32,self:GetTall(),
       self.die and cola or colb,true,false,false,false
    )

    local txt=tostring(IsValid(self.pl) and pl:Name() or self.plname)
		surface.SetTextColor(128,128,128,255)
		surface.SetFont "Default"
		local w,h=surface.GetTextSize(txt)
		surface.SetTextPos(12,self:GetTall()*0.3-h*0.5)
    surface.DrawText(txt)

	local dist = IsValid(pl) and LocalPlayer():GetPos():Distance(pl:GetPos())



	if dist then
		local vari=130
		if not self.die then
			self.starttime=self.starttime or CurTime()
			vari=80 - 15 - math.cos((CurTime()-self.starttime)*5)*15
		end

		local frac = dist/4200
		frac = frac <0 and 0 or frac > 1 and 1 or frac
		frac=1-frac
		surface.SetDrawColor(0,0,0,vari)
		surface.DrawRect(0,self:GetTall()-8,self:GetWide(),8)
		surface.SetDrawColor(0,0,0,vari)
		surface.DrawRect(0,self:GetTall()-8,(self:GetWide()-16)*frac,8)
	end
end

function PANEL:SetPlayer(pl)
	self.plname=pl:Name()
	self.pl=pl
    self.ava:SetPlayer(pl,32)
end

function PANEL:Think()
    local pl = self.pl
	if IsValid(pl) and pl:IsSpeaking() then
		self.die = false
	else
		self.die = true
	end

	self.alpha=self.alpha>1300 and 1300 or self.alpha<0 and 0 or self.alpha
	self:SetAlpha(self.alpha>255 and 255 or self.alpha)

    if self.die then

		self.alpha = self.alpha - FrameTime()*800

		if self.alpha>0 then
			return
		end

		self:GetParent():InvalidateLayout()
		self:Remove()

	else
		self.alpha = self.alpha+FrameTime()*1800
    end


end

local voiceinfo = vgui.RegisterTable(PANEL,"DPanel")





local PANEL={}

function PANEL:Init()
    self:ParentToHUD()
    self:SetMouseInputEnabled(true)
	self.players={}
end
function PANEL:Think()
	local nodraw=nodraw()
	if nodraw and not self.nodrawed then
		self:SetAlpha(0)
		self.nodrawed=true
	elseif not nodraw and self.nodrawed then
		self:SetAlpha(255)
		self.nodrawed=false
	end

end
function PANEL:PerformLayout()
    local w,h=ScrW(),ScrH()
    self:SetSize(200,h)
    self:SetPos(w-self:GetWide()-32,0)
    for k,v in pairs(self.players) do
		if ValidPanel(v) then
			v:PerformLayoutEx(k,self:GetTall())
		else
			self.players[k]=nil
		end
    end
end

function PANEL:AddPlayer(pl)
    local pnl=self:GetPnl(pl)

    if ValidPanel(pnl) then
		if  pnl.die==true  then
			pnl.die=false
		else
			pnl.lastadd=RealTime()
		end
	else
		pnl = self:GetPnl(pl,true)
	end
end

function PANEL:GetPnl(pl,create)
    for k,v in pairs(self.players) do
		if pl==v.pl then return v end
	end
	if create then
		local pnl = vgui.CreateFromTable(voiceinfo,self)
		pnl:SetPlayer(pl)
		self:InvalidateLayout()
		table.insert(self.players,pnl)
    end
end

local voicepanel = vgui.RegisterTable(PANEL,"EditablePanel")
if ValidPanel(g_VoicePnl) then
    g_VoicePnl:Remove()
end
g_VoicePnl=nil

local function DoInit()
    g_VoicePnl=g_VoicePnl or vgui.CreateFromTable(voicepanel,vgui.GetWorldPanel(),"CHudVoiceStatus")
    return g_VoicePnl
end

-- Old vgui
hook.Remove( "InitPostEntity", "CreateVoiceVGUI")



-- VOICE RING THING --
local mic_speaking={}
local CircleMat = Material( "SGM/playercircle" )
local function DrawVoiceRing( pl )

	if 		mic_speaking[pl]and pl.IsValid and	pl:IsValid()
	and 	pl:Alive() then

		local trace = {}
		trace.start 	= pl:GetPos() + Vector(0,0,50)
		trace.endpos 	= trace.start + Vector(0,0,-300)
		trace.filter 	= pl

		local tr = util.TraceLine( trace )

		if not tr.HitWorld then
			tr.HitPos = pl:GetPos()
		end

		local color = team.GetColor( pl:Team() )
		color.a=120 * pl:VoiceVolume()

		render.SetMaterial( CircleMat )
		render.DrawQuadEasy( pl:GetPos()+Vector(0,0,1), Vector(0,0,1), 128, 128, color )
	end
end

hook.Add( "PrePlayerDraw", "VoiceRing", DrawVoiceRing )

local createtimers={}
function GM:PlayerStartVoice( pl )
	if not IsValid( pl ) then return end

	mic_speaking[ pl ] = true

	-- new voice panel
	local pnl = DoInit()
	local tid=pl:UserID()..'_voice'
	createtimers[pl]=tid
	if timer.Exists(tid) then return end
	timer.Create(tid,1/66,1,function() -- distance voice delay is about this long (tickrate?), thankfully mostly unnoticeable. In fact it's always just one frame, so now this requires full recoding.. At least we have a solid way of detecting when voice distance is used.
		if pl:IsValid() then
			pnl:AddPlayer(pl)
		end
	end)


end

function GM:PlayerEndVoice( pl )

	local tid=createtimers[pl]
	if tid then
		timer.Remove(tid)
	end

	mic_speaking[ pl ] = nil

end

timer.Simple(0,function()
	local icntlk_pl=Material("voice/icntlk_pl")
	if icntlk_pl then
		icntlk_pl:SetFloat("$alpha", 0)
	end
end)