local _G=_G

setfenv(1,_G or setmetatable({},{__index=function(self,k) print(k) return _G[k] end,__newindex=function(self,k,v) 

	print("SETTING?",k)
	
	_G[k] = v
	
end})
)

local ScrW     = ScrW
local ScrH     = ScrH
local render   = render
local RealTime = RealTime
local math     = math
local tonumber = tonumber
local isnumber = isnumber
local next     = next
local isstring = isstring
local CurTime = CurTime
local vgui = vgui
local string = string
local os = os
local util = util


pcall(include, "autorun/translation.lua") local L = translation and translation.L or function(s) return s end


--- remove when fixed ---
local SetClipboardText=function(txt)
    txt=tostring(txt or '')
    local _,count=txt:gsub("\n","\n")
    txt=txt..('_'):rep(count)

    local b=vgui.Create('DTextEntry',nil,'ClipboardCopyHelper')
        b:SetVisible(false)
        b:SetText(txt)
        b:SelectAllText()
        b:CutSelected()
        b:Remove()
end
--- end remove when fixed --


-- helpers --
local function GetFriendStatus(ent)

	if ent==LocalPlayer() then return end

	local state = ent:GetFriendStatus()=="friend"
	local overriden
	local GetFriendStatusOverride = friendsh and friendsh.GetFriendStatusOverride
	if GetFriendStatusOverride then
		local override = GetFriendStatusOverride( ent:SteamID() )
		if override != nil then
			state = override
			overriden = true
		end
	end
	return state,overriden
end


local Tag="scoreboard"
--surface.CreateFont("DermaDefault", {font =  "Roboto", size = 13, antialias = true, outline = false, weight = 550, })
--surface.CreateFont("scoreboard_hostname", {font =  "Roboto", size = 20, antialias = true, outline = false, weight = 800, })

local Config=setmetatable({},{__index={
Save=function(s)
	local data = util.TableToJSON(s)
	file.Write("scoreboard_config.txt",data)
end,
Load=function(s)
	local f=file.Read("scoreboard_config.txt")
	if not f then return end
	local t = util.JSONToTable(f)
	if not t then
		file.Write("scoreboard_config.txt",util.TableToJSON{})
		return
	end

	for k,v in pairs(t) do
		s[k]=v
	end
end}})

-- TODO: Save/Restore

local team_connecting=3211
local team_left=3210
team.SetUp(team_connecting, L"Connecting to server",Color(0,128,0,255),false)
team.SetUp(team_left, L"Recently disconnected",Color(33,33,33,255),false)

local surface=surface
local team=team
local draw=draw




local drawsprays = false
local hoveravatar
local dohover
local starthover = 0




local avatar_size=184
local avatars = {}
-- FUCK YOU GARRY
local function GetCachedAvatar184(sid64)
	local c = avatars[sid64]
	if c then
		c.shouldhide = false
		if c.hidden then
			c.hidden =false
			c:SetVisible(true)
		end
		return c
	end

	local a = vgui.Create'AvatarImage'
	a:SetPaintedManually(true)
	a:SetSize(1,1)
	a:ParentToHUD()
	a:SetAlpha(0)
	a:SetPos(ScrW()-1,ScrH()-1)
	a:SetSteamID(sid64,avatar_size)
	a.Think=function(self)
		if self.shouldhide then
			if not self.hidden then
				self.hidden = true
				self:SetVisible(false)
			end
		else
			self.shouldhide = true
		end
	end
	a.shouldhide = false
	avatars[sid64]=a
	return a
end


local avatar_size=32
local avatars = {}
-- FUCK YOU GARRY
local function GetCachedAvatar32(sid64)
	local c = avatars[sid64]
	if c then
		c.shouldhide = false
		if c.hidden then
			c.hidden =false
			c:SetVisible(true)
		end
		return c
	end

	local a = vgui.Create'AvatarImage'
	a:SetPaintedManually(true)
	a:SetSize(1,1)
	a:ParentToHUD()
	a:SetAlpha(0)
	a:SetPos(ScrW()-1,ScrH()-1)
	a:SetSteamID(sid64,avatar_size)
	a.Think=function(self)
		if self.shouldhide then
			if not self.hidden then
				self.hidden = true
				self:SetVisible(false)
			end
		else
			self.shouldhide = true
		end
	end
	a.shouldhide = false
	avatars[sid64]=a
	return a
end
local function SetAvatarTexture32(sid64)
	local cached = GetCachedAvatar32(sid64)
	surface.SetTexture(0)
	if cached then
		cached:SetPaintedManually(false)
		cached:PaintManual()
		cached:SetPaintedManually(true)
	end
end


-- avatar precaching --
local already={}
local function DoPrecache(sid64,bigonly)

	if not Config.avatarprecache or not sid64 or #sid64<5 or already[sid64] then return end

	already[sid64]=true

	timer.Simple(math.random(1,15),function()
		GetCachedAvatar184(sid64)
	end)
	if bigonly then return end
	timer.Simple(math.random(1,15),function()
		GetCachedAvatar32(sid64)
	end)

end

--local cl_precache_avatars=CreateClientConVar('cl_precache_avatars','0',true)
hook.Add("NetworkEntityCreated",Tag,function(pl)
	if pl:IsPlayer() and not pl:IsBot()
	then
		local sid64 = pl:SteamID64()
		DoPrecache(sid64)
	end
end)



hook.Add("PostRenderVGUI",Tag,function()
	if not dohover then return end
	dohover = false
	if not hoveravatar then return end

		local f = (RealTime()-starthover)*(1/0.1)
		f=f>1 and 1 or f<0 and 0 or f


	if drawsprays then
		if not hoveravatar.spraymat then return end



		local x,y = hoveravatar:LocalToScreen()
		local aw,ah = hoveravatar:GetSize()
		local cx,cy=x+aw*0.5,y+ah*0.5
		local sw,sh=	hoveravatar.sprayw ,	hoveravatar.sprayh
		x,y=cx-sw*0.5,cy-sh*0.5
		x=x<0 and 0 or x
		y=y+sh>ScrH() and ScrH()-sh or y
		surface.SetMaterial(hoveravatar.spraymat)

			surface.SetDrawColor(0,0,0,f*200)
			surface.DrawTexturedRect(x+1,y+1,sw,sh)
			surface.DrawTexturedRect(x-1,y-1,sw,sh)

		surface.SetDrawColor(255,255,255,f*255)
		surface.DrawTexturedRect(x,y,sw,sh)
		return
	end

	local sid = hoveravatar.sid64
	if sid then
		local x,y = hoveravatar:LocalToScreen()
		local aw,ah = hoveravatar:GetSize()
		local cx,cy=x,y+ah*0.5
		local w,h=184,184
		local cache = GetCachedAvatar184(sid)
		if cache then
		--	Msg"."
			cache:SetPaintedManually(false)
			cache:PaintManual()
			cache:SetPaintedManually(true)

		--	surface.DrawRect(cx-184*0.5,cy-184*0.5,w,h)
			local sx,sy = cx-184,cy-184*0.5
			sx=sx<0 and 0 or sx
			sy=sy+h>ScrH() and ScrH()-h or sy

			local sxx,syy = sx+w,sy+h
			local q=VERSION>140713 and 1 or 1.395
			render.SetScissorRect(sx,sy,sxx,syy,true)
			surface.SetDrawColor(255,255,255,f*255)
			surface.DrawTexturedRect(sx,sy,w*q,h*q)
			render.SetScissorRect(sx,sy,sxx,syy,false)
		end
	end
end)

----------------------------------- new scrollbar vgui -----------------------------------

	local function OverrideDrawing(scroller)
		if not scroller.btnDown then return end
		local dn = {{x=0,y=0},{x=1,y=0},{x=1*0.5,y=1}}
		scroller.btnDown.Paint = function (self,w,h)
			if self.Hovered then
				surface.SetDrawColor(30,30,30,222)
			else
				surface.SetDrawColor(30,30,30,111)
			end
			surface.SetTexture(0)
			dn[2].x=w
			dn[3].x=w*0.5
			dn[3].y=h
			surface.DrawPoly(dn)
		end
		local a,b,c={x=0,y=0},{x=0,y=0},{x=0,y=0}
		local up = {a,b,c}
		scroller.btnUp.Paint = function (self,w,h)
			if self.Hovered then
				surface.SetDrawColor(30,30,30,222)
			else
				surface.SetDrawColor(30,30,30,111)
			end
			surface.SetTexture(0)
			a.x=w*0.5
			b.x=w
			b.y=h
			c.y=h
			surface.DrawPoly(up)
		end

		scroller.btnGrip.Paint = function (self,w,h)
			if self.Hovered then
				surface.SetDrawColor(90,90,90,200)
			else
				surface.SetDrawColor(60,60,60,100)
			end
			surface.DrawRect(0,0,w,h)
		end

		scroller.Paint = function (self,w,h)
			--surface.SetDrawColor(200,200,200,200)
			--surface.DrawRect(0,0,w,h)
		end
	end






----------------------------------- AVATAR VGUI -----------------------------------
local avatar_factor
do
	local PANEL={}

	function PANEL:Init()

		self:SetSize(32,32)
		self:SetCursor 'hand'
	end
	function PANEL:PerformLayout()
	end

	function PANEL:OnMousePressed(mc)
		if mc==MOUSE_LEFT then
			drawsprays = not drawsprays
		end
	end


	function PANEL:Assign(pl)

		if self.bot~=nil and (self.player or self.sid64) then return end

		local sid64
		local valid
		if isentity(pl) then
			valid = IsValid(pl)
			sid64 = valid and pl:SteamID64() or player.UserIDToSteamID and util.SteamID64(player.UserIDToSteamID(player.ToUserID(pl)))
		elseif isstring(pl) then
			sid64 = pl
			pl = false
		elseif pl==false then

		else
			error"?"
		end

		local sidok = sid64 and sid64:len()>5

		if sidok then
			self.sid64=sid64
		end

		self.player=pl

		if self.bot == nil then
			if valid then

				self.bot = pl:IsBot() or false
			elseif pl == false then
				self.bot = false
			end
		end
		if sidok then
			DoPrecache(sid64)
			self.tryrespray = true
		end
	end

	function PANEL:ReSpray()
		if self.spraymat then return end

		if not self.player then return end
		local pl=self.player

		local info=pl and pl.IsValid and pl:IsValid() and pl:GetPlayerInfo()

		if not info then

			return

		end

		local customfiles=info.customfiles
		local customfile=customfiles[1]
		customfile=customfile and customfile:gsub("0",""):len()>0 and customfile

		if not customfile then return end

		local texpath = 'temp/'..customfile

		local params = {}
		params[ "$basetexture" ] = texpath
		params[ "$vertexcolor" ] = 1
		params[ "$vertexalpha" ] = 1
		params.Proxies={AnimatedTexture={animatedtexturevar='$basetexture',animatedtextureframenumvar='$frame',animatedtextureframerate=4}}


		local m = CreateMaterial( customfile .. "_sprayi", "UnlitGeneric", params )

		if m:IsError() then return end
		local tex = m:GetTexture("$basetexture")
		if not tex or tex:IsError() then return end
		self.sprayw = tex:Width()
		self.sprayh = tex:Height()
		self.spraymat = m
	end


	local c,cr=Color(255,255,255,255),Color(255,100,100,255)
	function PANEL:PaintSpray(w,h)
		if self.tryrespray then
			self.tryrespray = false
			self:ReSpray()
		end

		surface.SetDrawColor(40,40,40,100)
		--surface.SetMaterial(nope)

		surface.DrawRect(0,0,w,h)

		local spraymat=self.spraymat
		if spraymat then
			surface.SetMaterial(spraymat)
			local sw,sh=self.sprayw,self.sprayh
			surface.SetDrawColor(255,255,255,255)

			local scl=sw>sh and sw or sh
			local sz=w
			local nsw = sw/scl*sz
			local nsh = sh/scl*sz
			surface.DrawTexturedRect(w*0.5-nsw*0.5,h*0.5-nsh*0.5,nsw,nsh)
		end

		surface.SetDrawColor(255,255,255,255)
	end
	function PANEL:Paint(w,h)
		local sid64 = self.sid64
		local bot = self.bot

		if not sid64 and not bot then return end

		if not bot and (self.drawspray or drawsprays) then return self:PaintSpray(w,h) end

		surface.SetDrawColor(40,40,40,255)
		surface.DrawRect(0,0,w,h)

		surface.SetTextColor(255,255,255,255)
		local txt = bot and L"BOT" or "?"
		surface.SetFont("DefaultSmall")
		local tw,th = surface.GetTextSize(txt)
		surface.SetTextPos(w*0.5-tw*0.5,h*0.5-th*0.5)
		surface.DrawText(txt)

		if sid64 then
			SetAvatarTexture32(sid64)
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect(0,0,w,h)
		end

	end


	avatar_factor = vgui.RegisterTable(PANEL,"EditablePanel")

end

local function CreateAvatar(ply,ply_panel)


	local avatar = vgui.CreateFromTable(avatar_factor, ply_panel)



	avatar:Dock(LEFT)

	-- context menu
	function avatar.OnMouseReleased(avatar,mc)
		if mc~=MOUSE_RIGHT then return end


		local a=DermaMenu()
			a:AddOption(L"Open Profile URL",function()
				local url="http://steamcommunity.com/profiles/" .. (ply.communityid or (ply.networkid and util.SteamID64 and util.SteamID64(ply.networkid)) or tostring(ply.SteamID64))
				gui.OpenURL(url)
			end):SetImage'icon16/transmit.png'
			a:AddOption(L"Copy Profile URL",function()
				SetClipboardText("http://steamcommunity.com/profiles/"..(ply.communityid or (ply.networkid and util.SteamID64 and util.SteamID64(ply.networkid)) or tostring(ply.SteamID64)))
			end):SetImage'icon16/link.png'
			a:AddSpacer()
			a:AddOption(L"Copy SteamID",function()
				SetClipboardText(ply.networkid or L"N/A")
			end):SetImage'icon16/book_edit.png'
			a:AddOption(L"Copy Community ID",function()
				SetClipboardText(ply.communityid or (ply.networkid and util.SteamID64 and util.SteamID64(ply.networkid)) or tostring(ply.SteamID64))
			end):SetImage'icon16/book_link.png'
			a:AddOption(L"Copy Name",function()
				SetClipboardText(ply.name or ply.Name)
			end):SetImage'icon16/user_suit.png'


			local pl = ply.Entity
			if pl and pl:IsValid() then
				local idx = pl:EntIndex()
				local sid = pl:SteamID()
				if MetaWorks then
					a:AddSpacer()
					a:AddOption(L"View achievements",function()
						RunConsoleCommand("achievements",idx)
					end):SetImage'icon16/award_star_gold_1.png'
					a:AddOption(L"View badges",function()
						RunConsoleCommand("badges",idx)
					end):SetImage'icon16/medal_gold_1.png'
				end



				a:AddSpacer()
				a:AddOption(L"PM",function()
					RunConsoleCommand("chat_open_pm",sid)
				end):SetImage'icon16/group.png'

				local fs = pl.FamilySharing and pl:FamilySharing()
				if fs then
					a:AddSpacer()
					a:AddOption(L"Open Owner Profile URL",function()
						local url="http://steamcommunity.com/profiles/" .. fs
						gui.OpenURL(url)
					end):SetImage'icon16/transmit.png'
					a:AddOption(L"Copy Owner Profile URL",function()
						SetClipboardText("http://steamcommunity.com/profiles/"..fs)
					end):SetImage'icon16/link.png'
					a:AddOption(L"Copy Owner Community ID",function()
						SetClipboardText(tostring(fs))
					end):SetImage'icon16/book_link.png'
				end

			end

		a:Open()
	end


	function avatar.MouseStatus(_,entered)

		if entered then
			hoveravatar = avatar
			starthover = RealTime()
			dohover = true
		else
			if hoveravatar==avatar then
				hoveravatar = false
			end
			dohover = false
		end
	end

	function avatar.Think(self)
		if hoveravatar==self then dohover = true end
		local x,y=avatar:CursorPos( )
		local out = x<0 or y<0 or x>self:GetWide() or y>self:GetTall()
		if out and self.__entered then
			self.__entered=false
			self:MouseStatus(false)
			if IsValid(ply_panel) and ply_panel.AvatarHovered then
				ply_panel:AvatarHovered(false)
			end

		elseif not out and not self.__entered and (ply.Entity or ply.SteamID64 or ply.networkid) then
			self.__entered=true
			self:MouseStatus(true)
			if IsValid(ply_panel) and ply_panel.AvatarHovered then
				ply_panel:AvatarHovered(true)
			end
		end
	end
	avatar:SetMouseInputEnabled(true)
	return avatar
end


local menupanel,menupanel_parent,menupanel_wanth
local function GrabMenu(parent,remove,wanth)
	wanth=wanth or parent:GetTall()
	if remove and parent~=menupanel_parent then return end

	if not ValidPanel(menupanel) then

		menupanel=vgui.Create('EditablePanel',parent)

		menupanel.AddSpacer=function()
			if #menupanel:GetChildren()<=1 then return end
			local pnl = vgui.Create( "EditablePanel", menupanel )
			pnl:Dock(LEFT)
			pnl:SetWide(1)
			pnl:DockMargin(2,0,2,0)
			pnl.Paint=function(b,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawRect(0,0,w,h)
			end
		end
		menupanel.OpenSubMenu=function()  end
		menupanel.AddOption=function ( menupanel, strText, funcFunction )

			local pnl = vgui.Create( "DMenuOption", menupanel )
			pnl:SetText( strText )
			pnl.DoClick = function(pnl,...)
				if funcFunction then
					funcFunction(pnl,...)
				end
				for k,v in pairs(menupanel:GetChildren()) do
					--print("Remove",v)
					v:Remove()
				end
				menupanel:GetParent():PopulateMenu(menupanel)
			end
			pnl:SetWide(100)
			pnl:Dock(LEFT)




			function pnl:PerformLayout()

					self:SizeToContents()
					self:SetWide( self:GetWide() + 5 )

					self:SetTall(self:GetParent():GetTall())

					DButton.PerformLayout( self )

			end

			return pnl

		end
		menupanel.Paint=function(b,w,h)
			--surface.SetDrawColor(255,255,255,255)
			--surface.DrawRect(0,0,w,h)
		end
	end

	for k,v in pairs(menupanel:GetChildren()) do
		--print("Remove",v)
		v:Remove()
	end

	if menupanel:GetParent()==parent then

		return menupanel
	end


	menupanel:Dock(BOTTOM)
	menupanel:SetTall(20)
	menupanel:DockMargin(2,0,2,0)
	menupanel:SetParent(parent)
	menupanel:SetVisible(true)

	-- remove old children

	if remove and parent==menupanel_parent then
		menupanel:SetVisible(false)
	--	menupanel:InvalidateLayout()
	--	menupanel_parent:InvalidateLayout()
		return
	end

	if ValidPanel(menupanel_parent) then
		menupanel_parent:SetTall(menupanel_wanth)
		menupanel_parent:InvalidateLayout()
	end
	menupanel_parent=parent
	menupanel_wanth=wanth
	parent:SetTall(wanth+20)

	menupanel:InvalidateLayout()
	return menupanel
end



local PANEL={} -- Player panel

function PANEL:Init()
	self:SetTall((Config.pnlsz or 24))
	self:Dock(TOP)
	self:DockMargin(0,0,0,0)
	self:DockPadding(16+2,0,0,0)

end


function PANEL:PopulateMenu(a)
	if not a then return end
	local data=self:GetPlayerData()
	local ent=data.Entity
	local eid
	local bot
	local afk
	local me=LocalPlayer()
	local admin=me:IsAdmin()
	if IsValid(ent) then
		eid=ent:EntIndex()
		bot=ent:IsBot()
		afk=ent:IsAFK()
	end

	-- Gotoing
	local gotomenu
	local canlocal = IsValid(ent) and ( ent~=me or bot )
	local canremote = data.ServerID and data.ServerID ~= 0 and data.ServerID ~= 5001
	if canlocal or canremote then
		local m,b = a:AddSubMenu(canremote and L"Cross server Goto" or L"Goto",function()
			if canremote then

			elseif IsValid(ent) then
				RunConsoleCommand("aowl","goto",'_'..ent:EntIndex())
			end
		end)

		gotomenu=m
		b:SetImage'icon16/bullet_go.png'
		a:AddSpacer()

		if canremote then -- confirmation submenu
			local b = gotomenu:AddOption(L"Confirm",function()
				RunConsoleCommand("aowl","goto",'#'..data.ServerID)
			end)
			b:SetImage'icon16/stop.png'
		end
	end

	if data.ServerID==0 then
		a:AddOption(L"Open Web Chat",function()
			gui.OpenURL("http://metastruct.org/webchat")
		end):SetImage'icon16/arrow_right.png'
	end

	-- Bring or TP
	if eid and ent==me then
		local b = a:AddOption(L"Blink",function()
			if IsValid(ent) then
				RunConsoleCommand("aowl","tp")
			end
		end)
		b:SetImage'icon16/bullet_go.png'
	elseif eid and (bot or afk or admin) then
		gotomenu = gotomenu or a

		local b = gotomenu:AddOption(L"Bring",function()
			if IsValid(ent) then
				RunConsoleCommand("aowl","bring",'_'..eid)
			end
		end)
		b:SetImage'icon16/arrow_inout.png'
	end

	if ent==me then
		a:AddOption(L"Rename",function()
			Derma_StringRequest(
				L"Rename yourself",
				L"Type in a new name for you.",
				"",
				function(txt) RunConsoleCommand("aowl","name",txt) end,
				function(txt) return false end
				)
			end):SetImage'icon16/textfield_rename.png'
		if ctp then
			local m,b = a:AddSubMenu(ctp:IsEnabled() and L"Disable" or L"CTP",function() ctp:Toggle() end) b:SetImage'icon16/find.png'
			m2,b2 = m:AddSubMenu("Custom Presets") b2:SetImage("icon16/folder.png")
			for _,f in pairs(file.Find("ctp/cvar_presets/*","DATA")) do
				local nf = f:gsub("%.txt","")
				m2:AddOption(nf,function() ctp:Enable() ctp:LoadCVarPreset(nf) end):SetImage'icon16/find.png'
			end
			m:AddOption(L"Thirdperson",function() ctp:Enable() ctp:LoadCVarPreset("Valve Thirdperson") end):SetImage'icon16/find.png'
			m:AddOption(L"Cinematic",function() ctp:Enable() ctp:LoadCVarPreset("Cinematic") end):SetImage'icon16/find.png'
			m:AddOption(L"Cinematic".." 2",function() ctp:Enable() ctp:LoadCVarPreset("Cinematic 2") end):SetImage'icon16/find.png'
			m:AddOption(L"Helicopter View",function() ctp:Enable() ctp:LoadCVarPreset("Helicopter View") end):SetImage'icon16/find.png'
			m:AddOption(L"Isometric",function() ctp:Enable() ctp:LoadCVarPreset("Isometric") end):SetImage'icon16/find.png'
			m:AddOption(L"Slow",function() ctp:Enable() ctp:LoadCVarPreset("Slow") end):SetImage'icon16/find.png'
		end
	end

	local cleanupmenu
	if IsValid(ent) and (ent==me or admin) then
		local m,b = a:AddSubMenu(L"Spawn",function()
			if eid then
				RunConsoleCommand("aowl","spawn",'_'..eid)
			end
		end)
		b:SetImage'icon16/heart.png'

		if ent:Alive() and ent == me then
			m:AddOption(L"Kill",function()
				if eid then
					RunConsoleCommand("aowl","kill",'_'..eid)
				end
			end):SetImage'icon16/cancel.png'
		else
			m:AddOption(L"Revive",function()
				if eid then
					RunConsoleCommand("aowl","revive",'_'..eid)
				end
			end):SetImage'icon16/heart_add.png'
		end
		if (ent==me) then
			local dying = GetConVarNumber"cl_dmg_mode"==3
			a:AddOption(dying and L"Enable god" or L"Disable god",function()
				RunConsoleCommand("cl_dmg_mode",dying and "1" or "3")
			end):SetImage(dying and 'icon16/lightning_add.png' or  'icon16/lightning_delete.png')
		end
		local m,b = a:AddSubMenu(L"Cleanup",function()
			if eid then
				RunConsoleCommand("aowl","cleanup",'_'..eid)
			end
		end)
		b:SetImage'icon16/bin_empty.png'
		cleanupmenu = m
	end

	cleanupmenu = cleanupmenu or a

	if ent==LocalPlayer() then
		cleanupmenu:AddOption(L"Disconnect",function()
			RunConsoleCommand("disconnect")
		end):SetImage'icon16/stop.png'
	end

	if admin and IsValid(ent) and ent~=me then
		a:AddSpacer()
	end


	if admin then

		if IsValid(ent) then

			if ent~=LocalPlayer() then
				local adminmenu,b = a:AddSubMenu(L"Admin Menu",function() end)
				b:SetImage'icon16/lock_open.png'


				local m,b = adminmenu:AddSubMenu(L"Kick",function()
					if eid then
						RunConsoleCommand("aowl","kick",'_'..eid)
					else

					end
				end)
				b:SetImage'icon16/door_out.png'
				m:AddOption(("%s (%s)"):format(L"kick", L"Posting pornographic content"),function()
					if eid then
						RunConsoleCommand("aowl","kick",'_'..eid, L"Posting pornographic content")
					end
				end):SetImage('icon16/door_out.png')
				m:AddOption(("%s (%s)"):format(L"kick", L"Chat Spam"),function()
					if eid then
						RunConsoleCommand("aowl","kick",'_'..eid, L"Chat Spam")
					end
				end):SetImage('icon16/door_out.png')
				m:AddOption(("%s (%s)"):format(L"kick", L"Prop Spam"),function()
					if eid then
						RunConsoleCommand("aowl","kick",'_'..eid, L"Prop Spam")
					end
				end):SetImage('icon16/door_out.png')
				m:AddOption(("%s (%s)"):format(L"kick", L"Annoying other players"),function()
					if eid then
						RunConsoleCommand("aowl","kick",'_'..eid, L"Annoying other players")
					end
				end):SetImage('icon16/door_out.png')
				m:AddSpacer()
				m:AddOption(("%s (%s)"):format(L"kick", L"Custom Reason"),function()
						if eid then
							Derma_StringRequest(
								L"Kick with custom reason",
								L"Type in a custom kick reason",
								"",
								function(txt) RunConsoleCommand("aowl","kick",'_'..eid,txt) end,
								function(txt) return false end
							)
						else

						end
					end):SetImage('icon16/door_out.png')

				if not ent.GetRestricted or not ent:GetRestricted() then
					local m,b = adminmenu:AddSubMenu(L"Ban",function()
						RunConsoleCommand("aowl", "ban",'_'..eid)
					end)
					b:SetImage'icon16/stop.png'
					m:AddOption(("%s (%s)"):format(L"Ban", L"Posting pornographic content"),function()
						if eid then
							RunConsoleCommand("aowl","ban",'_'..eid,30, L"Posting pornographic content")
						end
					end):SetImage('icon16/stop.png')
					m:AddOption(("%s (%s)"):format(L"Ban", L"Chat Spam"),function()
						if eid then
							RunConsoleCommand("aowl","ban",'_'..eid,30, L"Chat Spam")
						end
					end):SetImage('icon16/stop.png')
					m:AddOption(("%s (%s)"):format(L"Ban", L"Prop Spam"),function()
						if eid then
							RunConsoleCommand("aowl","ban",'_'..eid,30, L"Prop Spam")
						end
					end):SetImage('icon16/stop.png')
					m:AddOption(("%s (%s)"):format(L"Ban", L"Annoying other players"),function()
						if eid then
							RunConsoleCommand("aowl","ban",'_'..eid,30, L"Annoying other players")
						end
					end):SetImage('icon16/stop.png')
					m:AddSpacer()
					m:AddOption(("%s (%s)"):format(L"Ban", L"Custom Reason"),function()
						if eid then
							Derma_StringRequest(
								L"Ban with custom reason",
								L"Type in a custom ban reason",
								"",
								function(txt) RunConsoleCommand("aowl","ban",'_'..eid,10,txt) end,
								function(txt) return false end
							)
						else

						end
					end):SetImage('icon16/stop.png')
				else
					adminmenu:AddOption(L"UnBan",function()
						RunConsoleCommand("aowl","unban",'_'..eid)
					end):SetImage'icon16/weather_sun.png'
				end
			end
		elseif (data.ServerID and data.ServerID>0) then
			a:AddOption(L"Cross server Kick",function()
				local str=[=[for k,v in pairs(player.GetAll())do if v:UserID()==]=]..self:GetPlayerData().UserID..[=[ then v:Kick[[Kicked]] return true end end]=]
				RunConsoleCommand("aowl","cl"..data.ServerID,str)
			end):SetImage'icon16/stop.png'
		elseif data.userid and data.networkid and data.state==4 then

			a:AddOption(L"Ban SteamID ("..data.networkid..")",function()
				RunConsoleCommand("aowl", "ban",data.networkid)
			end):SetImage'icon16/stop.png'

			a:AddOption(L"Unban SteamID ("..data.networkid..")",function()
				RunConsoleCommand("aowl","unban",data.networkid)
			end):SetImage'icon16/weather_sun.png'

		elseif data.userid and data.networkid and data.state~=4 and not data.Entity then
			a:AddOption(L"Drop connection",function()
				Derma_Query(L"Are you sure you want to drop the connection?", L"Drop connection?",
					"Yes", function() RunConsoleCommand("aowl","rcon","kickid "..tostring(data.userid).." Kicked") end,
					"Cancel", function() end)
			end):SetImage'icon16/stop.png'

		end

	end
	if ent~=me then
		a:AddSpacer()
	end
	if IsValid(ent) and ent~=me then

		local BlockMenu, BlockMenuBtn = a:AddSubMenu( L"(Un)Block" )
		BlockMenuBtn:SetImage( "icon16/contrast.png" )

		-- MUTE
		local muted = ent:IsMuted()
		BlockMenu:AddOption( muted and L"UnMute" or L"Mute", function()
			ent:SetMuted(not muted)
		end ):SetImage( muted and 'icon16/sound_add.png' or 'icon16/sound_delete.png' )

		-- GAG
		local gagged = ms_gagged and ms_gagged[ ent ]
		BlockMenu:AddOption( gagged and L"UnGag" or L"Gag", function()
			ms_gagged[ ent ] = not gagged
		end ):SetImage( gagged and 'icon16/comment_add.png' or 'icon16/comment_delete.png' )

		-- SPRAY
		if SprayList then
			local blkd = ent:IsSprayBlocked()
			BlockMenu:AddOption( blkd and L"Unblock Spray" or L"Block Spray", function()
				RunConsoleCommand("blockspray",ent:EntIndex())
			end):SetImage( blkd and 'icon16/picture.png' or 'icon16/picture_empty.png' )
		end

		-- PAC OUTFIT
		if pac and easylua then
			local exec = ent.pac_ignored and pac.UnIgnoreEntity or pac.IgnoreEntity
			BlockMenu:AddOption( ent.pac_ignored and L"Unignore PAC outfit" or L"Ignore PAC outfit", function()
				exec( ent )
			end ):SetImage( ent.pac_ignored and 'icon16/status_online.png' or 'icon16/status_offline.png' )
		end

		-- SCAP
		if scap then
			local isblocked = ent.IsSCAPBlocked
			BlockMenu:AddOption( isblocked and "Unblock SCAPS" or "Block SCAPS", function()

				ent.IsSCAPBlocked = not isblocked

			end ):SetImage( isblocked and "icon16/camera_add.png" or "icon16/camera_delete.png" )
		end

		-- VOTEKICK
		if GVote then
			local m,b = a:AddSubMenu(L"Votekick",function()
				RunConsoleCommand("aowl","votekick",'_'..eid,L"Votekick")
			end)
			b:SetImage('icon16/door_in.png')
			m:AddOption(("%s (%s)"):format(L"Votekick", L"Mingebag"),function() RunConsoleCommand("aowl","votekick",'_'..eid,L"Mingebag") end):SetImage('icon16/door_in.png')
			m:AddOption(("%s (%s)"):format(L"Votekick", L"Spam"),function() RunConsoleCommand("aowl","votekick",'_'..eid,L"Spam") end):SetImage('icon16/door_in.png')
			m:AddOption(("%s (%s)"):format(L"Votekick", L"Hacker"),function() RunConsoleCommand("aowl","votekick",'_'..eid,L"Hacker") end):SetImage('icon16/door_in.png')
			m:AddOption(("%s (%s)"):format(L"Votekick", L"Asshole"),function() RunConsoleCommand("aowl","votekick",'_'..eid,L"Asshole") end):SetImage('icon16/door_in.png')
		end
	end

	hook.Call("MS_PopulateScoreboardMenu",GAMEMODE,ent,a)
end



function PANEL:GotoDoubleclick()

	if not self.__doubleclickwindow or self.__doubleclickwindow<RealTime() then
		self.__doubleclickwindow = RealTime()+0.4
		return
	end
	self.__doubleclickwindow = nil

	local data=self:GetPlayerData()
	local ent=data.Entity
	if ent==LocalPlayer() then
		RunConsoleCommand("aowl","tp")
	elseif IsValid(ent) then
		RunConsoleCommand("aowl","goto",'_'..ent:EntIndex())
		self.__gotoed = true
	end

end

function PANEL:FriendMenu()
	local x,y = self:CursorPos()
	-- toggle friend status
	if x>17 then return end

	local SetFriendStatusOverride = friendsh and friendsh.SetFriendStatusOverride
	if not SetFriendStatusOverride then return end
	local GetFriendStatusOverride = friendsh and friendsh.GetFriendStatusOverride
	if not GetFriendStatusOverride then return end

	local data=self:GetPlayerData()
	local ent=data.Entity
	if not IsValid(ent) or ent==LocalPlayer() then return end

	local sid = ent:SteamID()
	local curstate = GetFriendStatusOverride(sid)
	local newstate

	if 		curstate==nil 	then newstate = true
	elseif 	curstate==true 	then newstate = false
	elseif 	curstate==false	then newstate = nil
	end

	local a=DermaMenu()
		a:AddOption(L"default",function()
			SetFriendStatusOverride(sid,nil)
		end):SetImage'icon16/user_gray.png'

		a:AddSpacer()

		a:AddOption(L"friend",function()
			SetFriendStatusOverride(sid,true)
		end):SetImage'icon16/user_add.png'

		a:AddOption(L"unfriend",function()
			SetFriendStatusOverride(sid,false)
		end):SetImage'icon16/user_delete.png'

	a:Open()

	return true
end

function PANEL:OnMousePressed(mc)

	if mc==MOUSE_LEFT then

		self.__mleftdown = true
		self:GotoDoubleclick()
	end
end

function PANEL:OnMouseReleased(mc)
	if mc==MOUSE_LEFT then
		self.__mleftdown = false
	end

	if self.__gotoed then
		self.__gotoed = false
		if (mc==MOUSE_RIGHT and input.IsMouseDown(MOUSE_LEFT)) or (mc==MOUSE_LEFT and input.IsMouseDown(MOUSE_RIGHT)) then
			RunConsoleCommand("aowl","back")
			return
		end
	end

	if mc==MOUSE_LEFT then
		self:FriendMenu()
		return
	elseif mc~=MOUSE_RIGHT then
		return
	end

	if self:FriendMenu() then return end

	-- end tutorial
	if not Config.rightclicked then
		Config.rightclicked=true
	end

	local a=DermaMenu()
	a.Think=function(a) if not self.scoreboard_panel or not self.scoreboard_panel:IsVisible() then a:Remove() end end
		self:PopulateMenu(a)
	a:Open()
	self.mright = false
end

function PANEL:SetPlayerData(ply)
	self.data=ply
	local avatar = self.avatar
	if not ValidPanel(avatar) then
		avatar = CreateAvatar(ply,self)
		avatar:InvalidateLayout()
		self.avatar = avatar
	end
	avatar:SetSize((Config.pnlsz or 24),(Config.pnlsz or 24))

	avatar:Assign(
			( ply.Entity and isentity(ply.Entity) and ply.Entity 		)
		or 	( ply.SteamID64 and ply.SteamID64:len()>4 and ply.SteamID64 )
		or	( ply.networkid and ply.networkid:find("STEAM_",1,true) and util.SteamID64 and util.SteamID64(ply.networkid) )
		or	false
	)

	if ply.bot==true or ply.bot==1
		or ply.networkid=="BOT" or ply.SteamID64=="BOT"
		or (ply.Entity and IsValid(ply.Entity) and ply.Entity:IsBot()) then

		avatar.bot = true
	end



	self:CreateInfos()

	if self.data and self.data.Entity==LocalPlayer() then
		self.localpl=true
		--local m = GrabMenu(self,false,32)
		--m:Dock(BOTTOM)
		--self:PopulateMenu(m)
	end

	if IsValid(ply.Entity) and ply.Entity.CustomTitle and #ply.Entity.CustomTitle>0 then
		self.__Tooltip = ply.Entity.CustomTitle
	else
		self.__Tooltip = nil
	end

end

local server=Material"icon16/server.png"
local money_delete=Material"icon16/money_delete.png"
local moneypng=Material"icon16/money.png"
local wrench=Material"icon16/wrench.png"
local bug=Material"icon16/bug.png"
local timepng=Material"icon16/time.png"
local clock_pause=Material"icon16/clock_pause.png"
local clock_red=Material"icon16/clock_red.png"
local cup=Material"icon16/clock_pause.png"
local connect=Material"icon16/connect.png"
local disconnect=Material"icon16/disconnect.png"
local group=Material"icon16/group.png"
local transmit_blue = Material"icon16/transmit_blue.png"
local transmit = Material"icon16/transmit.png"
local vcard = Material"icon16/vcard.png"
local transmit_error = Material"icon16/transmit_error.png"
local money_max_w=24
local ptime_max_w=24
local country_max_w=24
local clock_max_w=32
local ping_max_w=24
local biasdiff
local ok,err=pcall(function()
	require"date"
	if date then
		biasdiff = date():getbias()*60
	end
end)
if not ok then MsgN(err) end

local function timeToStr( time )
	local tmp = time / 60 / 60 -- seconds->hours

	if tmp<1 then
		tmp = math.Round(tmp * 60 )
		return tmp..' m'
	elseif tmp<10 then
		local minutes = tmp-math.floor(tmp)
		minutes=(math.Round(minutes*60))
		return math.floor(tmp)..':'..Format("%.2d",minutes)..' h'
	else
		tmp = math.Round(tmp)
		return tmp..' h'
	end
end





local flags = {}
for k, v in pairs( file.Find( "resource/localization/*.png", "MOD" ) ) do
	flags[ string.StripExtension( v ) ] = Material( "resource/localization/" .. v )
end

local PLAYER = FindMetaTable("Player")
-- these are redirected because of unmatching country code
flags.gb = Material( "resource/localization/en.png" )
flags.se = Material( "resource/localization/sv-SE.png" )
flags.es = Material( "resource/localization/es-ES.png" )
flags.br = Material( "resource/localization/pt-BR.png" )
flags.il = Material( "resource/localization/he.png" )
flags.dk = Material( "resource/localization/da.png" )
flags.si = Material( "resource/localization/en-pt.png" ) -- geography not your strong side eh? http://www.slovensko.com/slovakia/slo.htm
flags.ua = Material( "resource/localization/uk.png" )
flags.cz = Material( "resource/localization/cs.png" )
flags.kr = Material( "resource/localization/ko.png" )
flags.us = flags.gb -- wtf us doesnt exists
flags.ca = flags.gb -- same for canada, sorry!!!

local SHOW_COUNTRY=true
local SHOW_DIFF=nil
local SHOW_TIME=false
local country_mode = SHOW_COUNTRY
local ostime

local SHOW_UTIME=true
local SHOW_UTIMEX=nil
local SHOW_ACCOUNTAGE=false

local maxutime=1
local ut_showrelative
local playtime_mode=SHOW_UTIME
function PANEL:CreateInfos()

	if Config.adhd then
		for k,v in pairs(self.infos or {}) do
			if IsValid(v) then
				v:Remove()
			end
		end
		self.infos=false
		return
	end

	if self.infos then
		return
	end
	self.infos={}

	ping_max_w=24
	local b=vgui.Create('EditablePanel',self,"PingColumn")
		b:Dock(RIGHT)
		b:DockMargin(1,1,1,1)
		b:SetZPos(101)
		b:SetWide(42)

		local data=self:GetPlayerData()
		local ent=data.Entity

		b:SetTooltip(ent and ent:IsValid() and ent.IsAFK and ent:IsAFK() and "Away Time" or "Ping")
		b.Paint=function(b,w,h)
			--surface.SetDrawColor(30,33,30,150)
			--surface.DrawRect(0,0,w,h)

			local data=self:GetPlayerData()
			local ent=data.Entity			local serverid=data.ServerID
			if ent and ent:IsValid() then

				local ping=ent:Ping()
				surface.SetFont"DermaDefault"
				surface.SetTextColor(0,0,0,255)

				local afk = ent.IsAFK and ent:IsAFK()

				surface.SetDrawColor(afk and 100 or
									ping > 300 and 255 or
									ping > 200 and 220 or
									ping > 100 and 180 or
									ping > 50 and 150 or 100,
									ping > 50 and 150 or 100,
									afk and 100 or
									ping <=50 and 255 or 100,
									100)
				surface.DrawRect(0,0,w,h)


				surface.SetMaterial(afk and cup or ping>200 and transmit or transmit_blue)
				surface.SetDrawColor(afk and 255 or 222,
									 afk and 255 or 255,
									 afk and 255 or 222,
									 afk and 100 or 200)

				if afk then
					local afkt = ent:AFKTime()
					local m=math.floor(afkt/60)
					local s=math.floor(afkt%60)
					if m>=10 then
						ping=m..":.."
					else
						ping=string.format("%d:%.2d",m,s)
					end
				elseif ping<0 then
					surface.SetDrawColor(255,111,111,255)
					surface.SetMaterial(transmit)
					ping=false
				elseif ping==0 then
					surface.SetDrawColor(255,255,255,150)
					surface.SetTextColor(0,0,0,50)
				elseif ping>200 and not afk then
					surface.SetDrawColor(230,255,255,255)
				end
				surface.DrawTexturedRect(1,h*0.5-8,16,16)
				if not ping then return end
				local tw,th=surface.GetTextSize(ping)
				ping_max_w=ping_max_w<tw+16+6 and tw+16+6 or ping_max_w
				surface.SetTextPos(16+3,h*0.5-th*0.5)
				surface.DrawText(ping)
			elseif serverid then
				local txt=tostring(serverid==0 and "WEB" or serverid==5001 and "IRC" or serverid)
				surface.SetFont"DermaDefault"
				surface.SetTextColor(200,200,200,255)

				surface.SetMaterial(serverid==0 and group or server)
				surface.SetDrawColor(200,200,200,255)
				surface.DrawTexturedRect(1,h*0.5-8,16,16)

				local tw,th=surface.GetTextSize(txt)
				ping_max_w=ping_max_w<tw+16+6 and tw+16+6 or ping_max_w
				surface.SetTextPos(16+3,h*0.5-th*0.5)
				surface.DrawText(txt)
			elseif data.Entity and data.Entity:IsPlayer() then
				surface.SetMaterial(disconnect)
				surface.SetDrawColor(255,255,255,255)
				surface.DrawTexturedRect(5+math.abs(math.sin(CurTime()*5))*16,h*0.5-8,16,16)
			elseif data.statetime then
				local time=math.Round(RealTime()-(data.statetime or RealTime()))
				local s=time%60
				local m=math.floor(time/60)
				time=m..':'..(s < 10 and "0"..s or s)
				surface.SetFont"DermaDefault"
				surface.SetTextColor(200,200,200,255)

				surface.SetMaterial(connect)
				surface.SetDrawColor(255,255,255,255)
				surface.DrawTexturedRect(1,h*0.5-8,16,16)
				if not time then return end
				local tw,th=surface.GetTextSize(time)
				surface.SetTextPos(16+3,h*0.5-th*0.5)
				surface.DrawText(time)
				ping_max_w=ping_max_w<tw+16+6 and tw+16+6 or ping_max_w
			--else -- connecting?
				--data.statetime=data.statetime or RealTime()
				--surface.SetMaterial(connect)
				--surface.SetDrawColor(255,255,255,255)
				--surface.DrawTexturedRect(5+math.abs(math.sin(CurTime()*5))*16,h*0.5-8,16,16)
			end
			b:SetWide(ping_max_w)
		end
	table.insert(self.infos,b)


	if PLAYER.GetCountryCode then
		local DrawFlag=surface.DrawFlag
		local b=vgui.Create('EditablePanel',self)
			b:Dock(RIGHT)
			b:DockMargin(1,1,1,1)
			b:SetZPos(104)
			b:SetWide(52)
			b:SetTooltip( "Country/Time" )
			b.OnMousePressed =function()
				if country_mode==SHOW_COUNTRY then
					country_mode=SHOW_DIFF
				elseif country_mode==SHOW_DIFF then
					country_mode=SHOW_TIME
				else
					country_mode=SHOW_COUNTRY
				end
			end
			b.Paint=function(b,w,h)
				local data=self:GetPlayerData()

				local ply = data and data.Entity

				if not ply or not ply:IsValid() or not ply.GetCountryCode then return end

				local code = ply:GetCountryCode()
				local country
				local flagWidth=0
				if code then
					code=code:lower()
					country = code and ply:GetCountryName() or code
					flagWidth = country and 16 or 0
					local flag = flags[ code ]

					if not b.tooltip then b:SetToolTip( Format( "%s (%s)", country, code:upper() ) ) b.tooltip = true end -- :/
					if false then
						flagWidth = 16
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( flag )
						surface.DrawTexturedRect( w - 18, h/2 - 5.5, 16, 11 )
					elseif DrawFlag then
						flagWidth = 16
						DrawFlag(code, w - 18, h/2 - 5.5)
					end
				end
				local stime=not country_mode
				if self.__entered or stime then

					surface.SetFont"DermaDefault"
					surface.SetTextColor(200,200,200,255)

					local txt
					if country_mode==SHOW_COUNTRY then
						txt = country or code or ""
					else
						local tz = ply.GetNetData and ply:GetNetData("tz")
						if tz and biasdiff then

							if country_mode==SHOW_DIFF then
								local t = math.Round(biasdiff/60-tz)
								if t==0 then
									txt = "0"
								else
									t=t/60
									txt = (t>0 and "+" or "")..t..'h'
								end
							else--if country_mode==SHOW_TIME then
								txt = os.date("%H:%M",ostime+biasdiff-tz*60) or "???"
							end

						end
					end
					if txt then
						local tw,th=surface.GetTextSize(txt)
						surface.SetTextPos(w - flagWidth - tw-5,h*0.5-th*0.5)

						surface.DrawText(txt)
						country_max_w=country_max_w<tw+16+5 and tw+16+5 or country_max_w
					end

				end

				b:SetWide(country_max_w)
			end
		table.insert(self.infos,b)
	end

	if PLAYER.GetUTimeTotalTime then
		local b=vgui.Create('EditablePanel',self)
			b:Dock(RIGHT)
			b:DockMargin(1,1,1,1)
			b:SetZPos(104)
			b:SetWide(52)
			b:SetTooltip("Playtime")
			b.OnMousePressed =function()
				if playtime_mode==SHOW_UTIME then
					playtime_mode=SHOW_UTIMEX
				elseif playtime_mode==SHOW_UTIMEX then
					playtime_mode=SHOW_ACCOUNTAGE
				else
					playtime_mode=SHOW_UTIME
				end
			end
			b.Paint=function(b,w,h)
				local data=self:GetPlayerData()
				local ply=data.Entity
				b:SetWide(ptime_max_w)

				if playtime_mode==SHOW_ACCOUNTAGE then
					local txt = ply and ply:IsValid()
						and os.date("%Y",ply:AccountCreated()) or ""
					surface.SetFont"DermaDefault"
					surface.SetTextColor(0,0,0,255)

					local tw,th=surface.GetTextSize(txt)
					surface.SetTextPos(w-16-tw-5,h*0.5-th*0.5)

					surface.DrawText(txt)
					ptime_max_w=ptime_max_w<tw+16+5 and tw+16+5 or ptime_max_w
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(vcard)
					surface.DrawTexturedRect(ptime_max_w- 17,h*0.5-th*0.5-2,16,16)

					return
				end
				if ply and ply:IsValid() and ply.GetUTime and !ply:IsBot() then

					local t = ply:GetUTime() + CurTime() - ply:GetUTimeStart()
					if playtime_mode==SHOW_UTIMEX then
						local t=t
						if t > maxutime then
							maxutime = t
						end
						local frac = t/maxutime
						frac=frac>1 and 1 or frac<0 and 0 or frac
						surface.SetDrawColor(40,80,200,100)
						surface.DrawRect(0,0,w*frac,h)
					end

					local txt = timeToStr( t )

					surface.SetFont"DermaDefault"
					surface.SetTextColor(200,200,200,255)

					local tw,th=surface.GetTextSize(txt)
					surface.SetTextPos(w-16-tw-5,h*0.5-th*0.5)

					surface.DrawText(txt)
					ptime_max_w=ptime_max_w<tw+16+5 and tw+16+5 or ptime_max_w
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(timepng)
					surface.DrawTexturedRect(ptime_max_w- 17,h*0.5-th*0.5-2,16,16)

				end
			end
		table.insert(self.infos,b)
	end


	if PLAYER.GetMoney then
		local b=vgui.Create('EditablePanel',self)
			b:Dock(RIGHT)
			b:DockMargin(1,1,1,1)
			b:SetZPos(104)
			b:SetWide(52)
			b:SetTooltip("Money")
			b.Paint=function(b,w,h)
				local data=self:GetPlayerData()
				local ent=data.Entity
				if ent and ent:IsValid() and ent.GetMoney then


					local money=ent:GetMoney()
					surface.SetFont"DermaDefault"
					surface.SetTextColor(200,200,200,255)

					surface.SetMaterial(money<=100 and money_delete or moneypng)
					money= isnumber(money) and money==0 and "" or money
					surface.SetDrawColor(255,255,255,255)

					surface.DrawTexturedRect(w-16-2,h*0.5-8,16,16)
					if not money then return end
					money=isnumber(money) and string.format("%.0f",money) or money
					local tw,th=surface.GetTextSize(money)
					surface.SetTextPos(w-16-tw-5,h*0.5-th*0.5)

					surface.DrawText(money)
					money_max_w=money_max_w<tw+16+5 and tw+16+5 or money_max_w

				end
					b:SetWide(money_max_w)
			end
		table.insert(self.infos,b)
	end

end
function PANEL:AvatarHovered(hover)
	self:ShowExtra(self.__entered or hover,hover)
end
local gradient_up = Material"VGUI/gradient_up.vmt"

local ShouldDrawLocalPlayer = false
hook.Add("ShouldDrawLocalPlayer",Tag,function() if ShouldDrawLocalPlayer then return true end end)

function PANEL:ShowExtra(show,moreextra)
	if IsValid(self.extra) then
		if self.extra.mdl then
			moreextra = true
		end
		self.extra:Remove()

	end

	if not show then
		return
	end

	self.extra = vgui.Create("EditablePanel",self)
	local extra = self.extra

	-- THIS LEVEL OF HAX IS BAD
	extra.Think=function(extra,w,h)
		local parent = extra.parentpanel

		local ok = IsValid(parent) and (parent.__Tooltip  or extra.mdl)

		local p = parent
		while IsValid(p) do
			if not p:IsVisible() then
				ok = nil
				break
			end
			p = p:GetParent()
		end

		if not ok then
			extra:Remove()
			return
		end

		local w=extra:GetWide()
			local tw = extra.__ttw
			w=tw and w<tw and tw or w

			local mw = extra.mdl and  extra.mdl:GetWide()
			w=mw and w<mw and mw or w
			local maxw = parent:GetWide() - (Config.pnlsz or 24) - 1
			w=w>maxw and maxw or w

			extra:SetWide(w)

		local h=extra:GetTall()
			local th = extra.__tth
			h=th and h<th and th or h

			local mh = extra.mdl and  extra.mdl:GetTall()
			h=mh and h<mh and mh or h

			extra:SetTall(h)
		if extra.mdl then
			extra.mdl.colAmbientLight=Color(255,255,255,255)
			extra.mdl.colColor=Color(255,255,255,extra:GetAlpha())
		end
		local x,y=parent:LocalToScreen()
		x,y=x+(Config.pnlsz or 24)+1,y-extra:GetTall()-1
		y=y<0 and 0 or y
		extra:SetPos(x,y)
	end

	extra.Paint=function(extra,w,h)
		local tth = extra.__tth or 0
		if tth then

			surface.SetDrawColor(0,0,0,200)
			surface.DrawRect(0,h-tth-1,w,tth+1)

			local sz = h*0.4
			surface.SetMaterial(gradient_up)
			surface.SetDrawColor(33,33,33,200)
			surface.DrawTexturedRect(0,h-tth-sz,w,sz)


		end

		local parent = extra.parentpanel

		local txt = IsValid(parent) and parent.__Tooltip

		if not txt then return end

		surface.SetFont"BudgetLabel"
		surface.SetTextColor(255,255,255,255)

		local tw,th=surface.GetTextSize(txt)
		extra.__ttw = tw+8
		extra.__tth = th
		surface.SetTextPos(4,h-th)
		surface.DrawText(txt)

	end


	local extra = self.extra
	extra:ParentToHUD()
	extra:SetDrawOnTop(true)
	extra.parentpanel = self
	extra:SetTall(16)


	local data=self:GetPlayerData()
	local ply=data and data.Entity
	if moreextra and ply and ply:IsValid() and ply:GetModel() then
		local a = vgui.Create( "DModelPanel", extra )
			--a:SetModel( ply:GetModel() )
			a.Entity=ply
			a.OnRemove = nil
			a:Dock(LEFT)
			a:SetWide(184)
			function a:Paint()

				if  !IsValid( self.Entity ) or drawsprays then return end

				local x, y = self:LocalToScreen( 0, 0 )


				local ang = self.aLookAngle
				if ( !ang ) then
					ang = Angle( 0, RealTime()*25,  0)
				end

				local w, h = self:GetSize()
				cam.Start3D( self.Entity:LocalToWorld(self.Entity:OBBCenter())-ang:Forward()*100, ang, self.fFOV, x, y, w, h, 5, 4096 )
				cam.IgnoreZ( true )
				ShouldDrawLocalPlayer = true
				local pac=pac
				if pac then
					pac.ForceRendering(true)
					pac.RenderOverride(self.Entity, "opaque")
					pac.RenderOverride(self.Entity,  "translucent", true)
				end
				self.Entity:DrawModel()

				if pac then
					pac.ForceRendering(false)
				end
				ShouldDrawLocalPlayer = false
				cam.IgnoreZ( false )
				cam.End3D()

				self.LastPaint = RealTime()

			end

			extra:SetTall(184)
		extra.mdl = a
	end

	extra:SetVisible(false)
	extra:SetPaintedManually(true)
		extra:Paint(extra:GetWide(),extra:GetTall())
		extra:Think()
		extra:Paint(extra:GetWide(),extra:GetTall())
		extra:Think()
		extra:InvalidateLayout(true)
	extra:SetPaintedManually(false)
	extra:SetVisible(true)
	if not moreextra then
		extra:SetAlpha(0)
		extra:AlphaTo(255,0.1,0)
	end
end

function PANEL:CreateButtons()
	if self.buttons then return end
	self.buttons={}

	-- entid, uid
	if not LocalPlayer():IsAdmin() then return end


	local b=vgui.Create('EditablePanel',self)
		function b.DoShow(b)
			if not Config.showdev then return end
			b._cachewide=b._cachewide or b:GetWide()
			b:SetVisible(true)
			b:SetWide(0)
			b:SizeTo(0,b:GetTall(),0,0,0)
			b:SizeTo(b._cachewide,b:GetTall(),0.1,0,1)
		end
		function b.DoHide(b)
			b:SetWide(0)
			b:SetVisible(false)
		end
		function b.OnMouseReleased(b,mc)
			if mc~=MOUSE_RIGHT then return end
			local a=DermaMenu()
				a.Think=function(a)
					if not self.scoreboard_panel or not self.scoreboard_panel:IsVisible() then a:Remove() end
				end

				local data=self:GetPlayerData()
				local ent=data.Entity
				local eid
				local admin=LocalPlayer():IsAdmin()
				if IsValid(ent) then
					eid=ent:EntIndex()
				end
				local uid = data.userid or data.UserID
				a:AddOption(L"Copy User ID" .. " ("..uid..")",function()
					SetClipboardText(uid)
				end):SetImage'icon16/bug_edit.png'
				if IsValid(ent) then
					local unid=ent:UniqueID()
					a:AddOption((L"Copy Entity ID") .. " ("..eid..")",function()
						SetClipboardText(eid)
					end):SetImage'icon16/bug_edit.png'
					a:AddOption((L"Copy Unique ID") .. " ("..unid..")",function()
						SetClipboardText("player.GetByUniqueID(\""..unid.."\")")
					end):SetImage'icon16/bug_edit.png'
					local unid=ent:UniqueID()
					a:AddOption(L"Copy Player",function()
						SetClipboardText(eid)
					end):SetImage'icon16/bug_edit.png'
				end


			a:Open()
			local x,y=a:GetPos()
			a:SetPos(x,y-a:GetTall()*0.5-32)
		end

		b:Dock(RIGHT)
		b:SetTooltip(L"User ID / Entity ID")
		b:DockMargin(1,1,1,1)
		b:SetZPos(102)
		b:SetWide(0)  -- how wide?
		b._cachewide = 28 -- this wide
		b.Paint=function(b,w,h)
			--surface.SetDrawColor(30,33,30,200)
			--surface.DrawRect(0,0,w,h)

			local data=self:GetPlayerData()
			local data2=data.Entity and data.Entity:IsValid() and data.Entity:EntIndex()
			data=data.userid or data.UserID
			if data then

				surface.SetDrawColor(0,0,0,90)
				--surface.DrawLine(0,0,0,h)
				--surface.DrawLine(w-1,0,w-1,h)
				local txt=tostring(data)

				surface.SetFont"DefaultSmall"
				surface.SetTextColor(99,99,99,255)

				surface.SetMaterial(wrench)
				surface.SetDrawColor(255,255,255,150)
				--surface.DrawTexturedRect(6,h*0.5-8,16,16)

				local tw,th=surface.GetTextSize(txt)

				surface.SetTextPos(6,h*0.5-(data2 and th-2 or th*0.5))
				surface.DrawText(txt)

				if not data2 then return end
				local txt=tostring(data2)

				local tw,th=surface.GetTextSize(txt)
				surface.SetTextPos(6,h*0.5-2)
				surface.DrawText(txt)

			end
		end
	table.insert(self.buttons,b)
end



function PANEL:ShowButtons(show)
	self:CreateButtons()
	for k,v in pairs(self.buttons) do
		v:DoShow()
		if not show then
			v:DoHide()
		end
		self:InvalidateLayout()
	end
end

function PANEL:Think(w,h) -- AGGGHH
	ostime=os.time()
	local vis = vgui.CursorVisible()
	if vis and not self.shown then
		self.shown=true
		self:ShowButtons(true)
	elseif not vis and self.shown then
		self.shown=false
		self:ShowButtons(false)
	end
	local off=0
	local x,y=self:CursorPos( )
	local out = not vis or x<0 or y<1 or x>self:GetWide() or y>self:GetTall()-1
	if out and self.__entered then
		self.__entered=false
		self:ShowExtra(false)
	elseif not out and not self.__entered then
		self.__entered=true
		self:ShowExtra(true)
	end

end

function PANEL:RefreshPlayer()
	self:SetPlayerData(self:GetPlayerData())
	--if self.localpl then return end

	self:SetTall((Config.pnlsz or 24))
end

function PANEL:PerformLayout()
	if self.invalid then
		self.die=true
	end
end

function PANEL:GetPlayerData()
	return self.data
end

local heart_delete=Material"icon16/heart_delete.png"
local user_green=Material"icon16/user_green.png"
local user_add=Material"icon16/user_add.png"
local user_delete=Material"icon16/user_delete.png"
local soundpng=Material"icon16/sound.png"
local sound_delete=Material"icon16/sound_delete.png"
local stop=Material"icon16/stop.png"
local car=Material"icon16/car.png"
local water=Material"icon16/water.png"
local shield_delete=Material"icon16/shield_delete.png"
local flag_red=Material"icon16/flag_red.png"
local flag_yellow=Material"icon16/flag_yellow.png"
local flag_orange=Material"icon16/flag_orange.png"
local group_link=Material"icon16/group_link.png"
local user_edit=Material"icon16/user_edit.png"
local metalogo=Material"metastruct/logo1.png"
metalogo=metalogo:IsError() and user_edit or metalogo
local in_easter=Material"icon16/plugin.png"

local cog=Material"icon16/cog.png"
local sound_mute=Material"icon16/sound_mute.png"
local gagged=Material"icon16/comment_delete.png"
local anchor=Material"icon16/anchor.png"
local palette=Material"icon16/palette.png"
local bricks=Material"icon16/bricks.png"
local user_comment=Material"icon16/user_comment.png"
local computer=Material"icon16/computer.png"
local shield=Material"icon16/shield.png"
local page_white_swoosh=Material"icon16/page_white_swoosh.png"
local sport_shuttlecock=Material"icon16/sport_shuttlecock.png"
local shading=Material"icon16/shading.png"
local drive_network=Material"icon16/drive_network.png"
local vinesauce = Material"metastruct/vinesaucelogo.png"
local family = Material"icon16/group.png"
local page_code = Material"icon16/page_code.png"
local page_white_code_red = Material"icon16/page_white_code_red.png"
local map_edit = Material"icon16/map_edit.png"
local page_paintbrush = Material"icon16/page_paintbrush.png"

local il_modes = {
	[true] = "Lua coder",
	[false] = "Mapper",
	[1] = "Maybe coder/mapper",
	[2] = "Modeler",
} 
local il_icons = {
	[true] = page_code,
	[false] = map_edit,
	[1] = page_white_code_red,
	[2] = page_paintbrush,
}

local tag_names = {
	["builder"] = "Builder",
	["pac"] = "PACer",
	["meme"] = "Memer"
}

local tag_icons = {
	["builder"] = Material"icon16/brick.png",
	["pac"] = Material"icon16/user_edit.png",
	["meme"] = Material"icon16/rainbow.png",
}

local vinesauceSteamIDs = {

	["STEAM_0:0:5580434"] = true,		// Vinny
	["STEAM_0:0:19107622"] = true,	// Darren
	["STEAM_0:1:35418707"] = true,	// Jen
	["STEAM_0:0:41138679"] = true,	// Joel
	["STEAM_0:1:21768016"] = true,	// Limes
	["STEAM_0:1:6902724"] = true,		// Dire
	["STEAM_0:1:33499245"] = true,	// Fred
	["STEAM_0:0:25675925"] = true,	// Reg
	["STEAM_0:0:35588478"] = true,	// Rev
	["STEAM_0:1:28984643"] = true,	// Ky
	["STEAM_0:0:27506289"] = true,	// Dem

}

local Tags = {
	{
		f=function(ply)
			local x=not ply:IsBot() and ply:GetFriendStatus()
			if x and x~="none" and x~="friend" then
				return x,user_green
			end
		end,
	},
	{
		f=function(ply)
			if ply.GetNetData and ply:GetNetData("MS") then return "Member",metalogo end
		end,
	},
	{
		f=function(ply)
			if pac then
				if ply:GetNWBool("in pac3 editor") then
					return "PAC3",palette
				elseif ply.pac_parts and next(ply.pac_parts) then
					return "Outfit",user_edit
				end
			end
		end,
	},
	{
		f=function(ply)
			if not ply:Alive() then return "",heart_delete end
		end,
	},
	{
		f=function(ply)
			if ply:IsMuted() then return "",sound_mute end
		end,
	},
	{
		f=function(ply)
			if ms_gagged and ms_gagged[ ply ] then return "gag",gagged end
		end,
	},
	{
		f=function(ply)
			if ply.GetRestricted and ply:GetRestricted() then return "BANNED",stop end
		end,
	},
	--[[{
		f=function(ply)
			if ply:IsBot() then return "Bot",computer end
		end,
	},]]
	{
		f=function(ply)
			if ply:InVehicle() then
				local veh = ply:GetVehicle()
				if IsValid(veh) and veh:GetClass()=="prop_vehicle_prisoner_pod" then
					return "Sitting",anchor
				end
				return "in vehicle",car
			end
		end,
	},
	{
		f=function(ply)
			if not LocalPlayer():IsUserGroup("owners") then return end
			if ply:IsAdmin() then
				return "Admin",shield
			end
		end,
	},
	{
		f=function(ply)
			local wep=ply:GetActiveWeapon()
			local class = wep:IsValid() and not ply:InVehicle() and wep:GetClass()
			if not class then return end
			if (class=="gmod_tool" or class=="weapon_physgun" ) then
				return "Building",wrench
			end
		end,
	},
	{
		f=function(ply)
			if ply.IsAFK and ply:IsAFK() then return "AFK",cup end
		end,
	},
	{
		f=function(ply)
			if ply.GetNetData and ply:GetNetData("pirate") then
				local limited = ply:GetNetData("limited")
				return 	limited==true and "Limited" or limited==false and "Suspicious" or "Pirate",
						limited==true and flag_orange  or limited==false and flag_yellow 		or flag_red

			end
		end,
	},
	--[[{
		f=function(ply)
			local m = ply.GetNetData 
			if m then
				m = m(ply,'IL')
				if m ~= nil then
					return 	il_modes[m],il_icons[m]
				end
			end
		end,
	},--]]
	{
		f=function(ply)
			if ply.GetNetData and ply:GetNetData("VAC") and ( not ply:IsAdmin() ) then return "VAC Ban",shield_delete end
		end,
	},
	{
		f=function(ply)
			if ply:GetMoveType()==MOVETYPE_NOCLIP and not ply:InVehicle() then
				return "Noclip",sport_shuttlecock
			end
		end,
	},
	{
		f=function(ply)
			if ply:WaterLevel()>1 then
				return "Submerged",shading
			end
		end,
	},
	{
		f=function(ply)
			if ply.has_vfs then
				return "VFS",drive_network
			end
		end,
	},
	{
		f=function(ply)
			if vinesauceSteamIDs[ ply:SteamID() ] then
				return "Vinesauce", vinesauce
			end
		end,
	},
    {
        f=function(ply)
            if ply.IsFamilySharing and ply:IsFamilySharing() then
                return "Family Sharing", family
            end
        end,
    },
	{
		f=function(ply)
			if ply:IsSpeaking() then return "",soundpng end
		end,
	},
	{
		f=function(ply)
			if ply:GetTypingMessage() then
				return "Typing",user_comment
			end
		end,
	},
	--being tags--
	{
		f=function(ply)
			if ply.GetTags then
				local tags = ply:GetTags()
				if tags["builder"] then
					return tag_names["builder"],tag_icons["builder"]
				end
			end
		end,
	},
	{
		f=function(ply)
			if ply.GetTags then
				local tags = ply:GetTags()
				if tags["pac"] then
					return tag_names["pac"],tag_icons["pac"]
				end
			end
		end,
	},
	{
		f=function(ply)
			if ply.GetTags then
				local tags = ply:GetTags()
				if tags["meme"] then
					return tag_names["meme"],tag_icons["meme"]
				end
			end
		end,
	},
}
local skiplist={}
local hadactivity={}

function PANEL:RefreshTags()
	if Config.adhd or Config.notags==true then
		self.tagscache = nil
		return
	end
	local pl = self.data
	local tagscache=self.tagscache or {}
	self.tagscache=tagscache

	local ent=pl and pl.Entity
	if ent and ent:IsValid() then

		local friendstatus,override = GetFriendStatus(ent)
		if override then
			friendstatus = friendstatus==true and 1 or friendstatus==false and 2 or friendstatus
		end

		tagscache[1]=friendstatus
		tagscache[2]=ent:Name()
		tagscache[3]=ent:IsSpeaking()

		local x=3
		for k,v in next,Tags do
			local txt,ico = v.f(ent)
			if txt then
				x = x+1
				tagscache[x]=L(txt) -- translate here instead
			end
			if ico then
				x = x+1
				tagscache[x]=ico
			end
			if not txt and not ico then
				x = x+1
				tagscache[x]=k
			else
				if not hadactivity[k] then hadactivity[k]=true end
				if skiplist[k] then skiplist[k]=false end
			end
		end

		-- clear old tags if any
		x=x+1
		while tagscache[x] do
			tagscache[x]=nil
			x = x+1
		end
	else
		self.tagscache=nil
	end
end

local NameFont = "scoreboard_names"
surface.CreateFont(NameFont,
{
 font = "Roboto",
 size = 17,
 weight = 650,
 blursize = 0,
 scanlines = 0,
 antialias = true,
 underline = false,
 italic = false,
 strikeout = false,
 symbol = false,
 rotary = false,
 shadow = false,
 additive = false,
 outline = false
})

local NameText =
{
	pos = {0,0}                     ,
	color = Color(255,255,255,255)  ,
	text = ""                       ,
	font = NameFont                 ,
	xalign = TEXT_ALIGN_LEFT        ,
	yalign = TEXT_ALIGN_TOP
}

local name_col_default_fg = Color(200,200,200,255)
local bgcol = Color(55,66,55,200)

local realblack_col = Color(0,0,0,255)

local PlayerColors = {
	["0"]  = Color(0,0,0),
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
local util=util

local gradhoriz = Material"vgui/gradient-l.vmt"
local color_order_cache={}
local txt_parts_cache={}
local lpad = 16 + 2 + 2 + 4 -- friend tag + some more pad
function PANEL:Paint(w,h)
	if self.die then self:Remove() return end

	local pl=self.data
	local ent = pl and pl.Entity and pl.Entity:IsValid() and pl.Entity

	local tagscache=self.tagscache

		--surface.SetDrawColor(255,255,255,200)
	--surface.DrawRect((Config.pnlsz or 24)+2,0,w-(Config.pnlsz or 24)-2,h)
	if self.__mleftdown then -- hover
		surface.SetDrawColor(60,60,60,230)
	elseif self.__entered then -- hover
		surface.SetDrawColor(60,60,60,240)
	elseif self.localpl then  -- me
		surface.SetDrawColor(60,60,60,250)
	elseif ent and tagscache and tagscache[3] then
		local v = 200+ent:VoiceVolume()*30
		surface.SetDrawColor(0,v,v-100,v)
	elseif(ent and ent.IsAFK and ent:IsAFK()) or (pl and (pl.state==4 or pl.left)) then
		surface.SetDrawColor(0,0,0,180)
	else
		surface.SetDrawColor(30,30,30,230)
	end

	local pnlsz = Config.pnlsz or 24

	surface.DrawRect(pnlsz+lpad,0,w-pnlsz-lpad,h)


	surface.SetDrawColor(100,100,100,40)
	surface.DrawRect(pnlsz+lpad,h-1,w,1)

	-- MEH OVERRIDE
	h = pnlsz

	if not pl then return end-- Draw name and tags

	local extra=""

	local teamid = ent and ent:Team() or tonumber(pl.teamid) or tonumber(pl.team) or tonumber(pl.Team) or team_connecting
	if teamid==0 or teamid==team_connecting and (pl.state == 4 or pl.left) then
		teamid = team_left
	end
	local teamcol=team.GetColor(teamid)

	--team vert line
	surface.SetDrawColor(teamcol.r,teamcol.g,teamcol.b,200)
	surface.DrawRect(8-1,0,4,h)


	surface.SetFont(NameFont)
	surface.SetTextPos(pnlsz+2+4+16+2,0)

	local pos_x = pnlsz+lpad+4

	local txt = (tagscache and tagscache[2]) or ent and ent:Name() or pl.name or pl.Name or "???"

	-- disassembling nicknames to support colorcodes --
	local color_order = color_order_cache[txt]
	if not color_order then
		color_order = {}
		for col in string.gmatch(txt, "%^(%d+)") do
			table.insert(color_order, PlayerColors[col] or realblack_col)
		end
		for h, s, v in string.gmatch(txt,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
			table.insert(color_order, HSVToColor(h, s, v) or realblack_col)
		end
		for r, g, b in string.gmatch(txt,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
			table.insert(color_order, Color(r, g, b, 255) or realblack_col)
		end
		for r, g, b, a in string.gmatch(txt,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
			table.insert(color_order, Color(r, g, b, a) or realblack_col)
		end
		color_order_cache[txt] = color_order
	end

	local parts = txt_parts_cache[txt]
	if not parts then
		parts = string.Explode("%^%d+", txt, true)
		txt_parts_cache[txt] = parts

		if parts[1] == "" then
			table.remove(parts,1)
		end

	end

	-- drawing nick
	for num, part in next, parts do
		NameText.pos[2] = 3
		NameText.pos[1] = pos_x+1
		NameText.text = part:gsub("<(.-)=(.-)>", "")

		NameText.color = bgcol

		-- bg
		pos_x = pos_x + draw.Text( NameText )

		NameText.pos[1] = NameText.pos[1] - 1
		NameText.pos[2] = NameText.pos[2] - 1

		if self.scoreboard_panel and self.scoreboard_panel.how~=1 then
			NameText.color = teamcol
		else

			NameText.color = color_order[num] or name_col_default_fg
		end

		draw.Text( NameText )


	end


	-- Draw tags (aka icons)
	local offx=pnlsz+2+4
	offx=128*2.7


	self.tagsw = self.tagsw or 32
	if not Config.ocd_fix then
		offx=offx + self.tagsw*0.5
	end

	local startoff = offx
	local friend

	if ent and tagscache then
		surface.SetTextColor(name_col_default_fg)
		surface.SetDrawColor(255,255,255,220)

		local ocd_fix = Config.ocd_fix
		surface.SetFont"DermaDefault"
		for i=4,#tagscache do
			local val = tagscache[i]
			if isnumber(val) then
				if ocd_fix then
					local skip = skiplist[val]
					if skip==nil then
						skip = true
					end
					if not skip then
						offx=offx+16+2
					end
				end
			elseif isstring(val) then
				if val=="" or not self.__entered then continue end
				local tw2,th2=surface.GetTextSize(val)
				if ocd_fix then
					offx=offx+tw2+4
				else
					offx=offx-tw2-4
				end
				surface.SetTextPos(offx,h*0.5-th2*0.5)
				surface.DrawText(val)
			else
				surface.SetMaterial(val)
				if ocd_fix then
					offx=offx+16+2
				else
					offx=offx-16-2
				end
				surface.DrawTexturedRect(offx,h*0.5-8,16,16)
			end


		end

		local curtagsw = math.abs(startoff-offx)
		self.tagsw = curtagsw

		friend = tagscache[1]


	elseif pl.ServerID and pl.SteamID64 and util.IsSteamIDFriend then
		friend = util.IsSteamIDFriend(pl.SteamID64)
	end

	-- left friends tag



	if self.__entered then
		local mx,my = self:CursorPos()
		local bg = mx < 17
		if bg then
			surface.SetDrawColor(0,0,0,250)
			surface.SetMaterial(user_green)
			surface.DrawTexturedRect(1,h*0.5-8,16,16)
		end
	end

	if friend then
		if friend==1 then
			surface.SetDrawColor(211,255,211,220)
			surface.SetMaterial(user_add)
		elseif friend==2 then
			surface.SetDrawColor(255,211,211,220)
			surface.SetMaterial(user_delete)
		else
			surface.SetDrawColor(211,255,211,220)
			surface.SetMaterial(user_green)
		end
		surface.DrawTexturedRect(1,h*0.5-8,16,16)
	end


end
local player_panel_factory = vgui.RegisterTable(PANEL,"EditablePanel")







-- Header for scoreboard GUI
local PANEL={}

function PANEL:Init()
	self:SetTall(24)
	self:Dock(TOP)
	self:DockPadding(1,1,1,1)
	self:DockMargin(0,0,0,0)
	local container=vgui.Create('EditablePanel',self)
	self.container=container
	container:Dock(TOP)
	container:SetTall(24)
	container:SetCursor 'hand'
	container:DockPadding(30,0,5,0)
	container.OnMousePressed=function(container,...) self:OnMousePressed(...) end

end

function PANEL:SelectionMenu()
	local a=DermaMenu()

		local function AddOption(cfg,txt)

			local set = Config[cfg]

			local bt = a:AddOption(txt,function()
				Config[cfg] = not set

				self:GetParent():RefreshPlayers()
				self:GetParent():InvalidateLayout()

			end)

			if not set then return end
			bt:SetImage('icon16/accept.png')
		end

		if crosschat then
			AddOption("hideotherservers",L"Hide other servers")

			if crosschat.serverdata and crosschat.serverdata[5001] then
				AddOption("hideirc",L"Hide IRC")
			end

		end

		AddOption("hideconnecting",L"Hide connecting")
		AddOption("notags",L"Hide tags")
		a:AddSpacer()
		AddOption("adhd",L"Minimal")
		AddOption("noblur",L"Disable zen")
		AddOption("rightalign",L"Align right")
		a:AddSpacer()
		AddOption("avatarprecache",L"Preload avatars")
		AddOption("showdev",L"Devmode")
		a:AddSpacer()
		AddOption("ocd_fix",L"Line icons")


		local m,b = a:AddSubMenu(L"Panel Size")

		local function AddOption(sz)

			local bt = m:AddOption(sz,function()
				Config.pnlsz  = sz
				self:GetParent():RefreshPlayers()
				self:GetParent():InvalidateLayout()
			end)

			if (Config.pnlsz or 24) == sz then
				bt:SetImage('icon16/bullet_add.png')
			end

		end

		AddOption(16)
		AddOption(20)
		AddOption(24)
		AddOption(32)
		AddOption(48)
		AddOption(64)

		local m,b = a:AddSubMenu(L"Wide Size")

		local function AddOption(sz)
			local bt = m:AddOption(sz,function()
				RunConsoleCommand("scoreboard_wide",sz)
			end)
			if (LocalPlayer():GetInfoNum("scoreboard_wide",0) or 800) == sz then
				bt:SetImage('icon16/bullet_add.png')
			end
		end

		AddOption(640)
		AddOption(720)
		AddOption(800)
		AddOption(1024)
		AddOption(1280)
		AddOption(1600)

	a:AddSpacer()

		local q = a:AddOption(L"Sort By")
		--q:SetImage'icon16/table.png'
		q.DoClickInternal=function() end
		q.DoClick=function() end
		q.OnMousePressed=function() end
		q.OnMouseReleased=function() end
		q.OnCursorEntered=function() end
		q.OnCursorExited=function() end
		q:SetDisabled(true)
		q:SetContentAlignment( 0 )
		q:SetTextInset( 8, 0 )
		local function AddOption(txt,how)


			local bt = a:AddOption(txt,function()
				self:GetParent():SortPlayers(how)
				self:GetParent():RefreshPlayers()
				self:GetParent():InvalidateLayout()
			end)

			if Config.how == how then
				bt:SetImage('icon16/bullet_add.png')
			end

		end

		AddOption(L"Team",1)
		if crosschat then
			AddOption(L"Server",2)
		end
		AddOption(L"Join Order",0)
		AddOption(L"Name",3)
		AddOption(L"Entity ID",4)
		AddOption(L"Playing Time",5)
		AddOption(L"Account Age",6)


	a:Open()
end

function PANEL:OnMousePressed(mc)
	if mc==MOUSE_RIGHT then
		self:SelectionMenu()
		return
	end
	if self.opened then
		self.opened=false
		self:SizeTo(self:GetWide(),24,0.1,0,1)
	else
		self.opened=true
		self:SizeTo(self:GetWide(),64,0.1,0,1)
	end
end

function PANEL:Think(w,h)
	local vis = vgui.CursorVisible()
	if vis and not self.shown then
		self.shown=true
		self.container:SetVisible(true)
	elseif not vis and self.shown then
		self.shown=false
		self.container:SetVisible(false)
	end
end

local fade = surface.GetTextureID "gui/gradient_down"
local white=Color(255,255,255,255)

local dark=Color(120,120,120,255)
local highlight=Color(222,120,120,200)

local with = " "..L("with").." "
local players = " "..L("players").."   "
local tickrate = "    "..L("tickrate")..": "
local curtime = "    "..L("curtime")..": "
local server_fps = "    "..L("Server FPS")..": "
local cpu = "    "..L("CPU")..": "
local moving_ents = "    " .. L("Moving ents") .. ": "
local avgfps = "    " .. L("Avg FPS") .. ": "

surface.CreateFont("fbox_scoreboard_title",{
	font = "Roboto Medium",
	size = 18,
})

function PANEL:Paint(w,h)
	local hh=h*0.5
	local H = self.container.Hovered
	local q=H and 100 or 80
	surface.SetDrawColor(0,q,q-20,230)
	surface.DrawRect(0,0,w,hh)
	surface.DrawOutlinedRect(0,0,w,hh)

	local q=q+3
	surface.SetDrawColor(0,q,q-20,230)
	surface.DrawRect(0,hh,w,hh)


	local q=q-15
	surface.SetDrawColor(0,q,q-20,230)
	surface.DrawOutlinedRect(0,0,w,h)

	if h>24 then

		surface.SetDrawColor(200,200,200,5)
		surface.DrawRect(0,24,w,h-24)

		surface.SetTextColor(255,255,255,230)
		surface.SetFont"DermaDefault"
		local txt= game.GetMap()
		local tw,th=surface.GetTextSize(txt)
		surface.SetTextPos((h-th)*0.5,24+(h-24)*0.5-th*0.5)

		surface.DrawText(txt)

		local txt = #player.GetHumans() -- UGH
		surface.DrawText(with)
		surface.DrawText(txt)
		surface.DrawText(players)

		surface.DrawText(tickrate)
		surface.DrawText(math.Round(1/engine.TickInterval()))

		local txt = timeToStr(CurTime()) -- UGH
		surface.DrawText(curtime)
		surface.DrawText(txt)



		if SrvInfo then
			local txt = SrvInfo.GetInfo"FPS"
			surface.DrawText(server_fps)
			surface.DrawText(txt)
			local txt = SrvInfo.GetInfo"CPU"
			if txt and txt!=-1 then
				surface.DrawText(cpu)
				surface.DrawText(txt)
			end
			local txt = SrvInfo.GetInfo"Moving"
			surface.DrawText(moving_ents)
			surface.DrawText(txt)

			local txt = SrvInfo.GetInfo"CLFPS"
			surface.DrawText(avgfps)
			surface.DrawText(txt)
		end

		h=24
	end

	-- hostname drawing
	surface.SetFont"fbox_scoreboard_title"
	local txt=GetHostName()


	local tw,th=surface.GetTextSize(txt)
	local tx,ty=(h-th)*0.5,h*0.5-th*0.5

	local px,py=self:LocalToScreen()
	tx=tx+16

	local s=render.SetScissorRect
	local f=0.61
	s(	px+tx,		py+ty,
		px+tx+tw,	py+ty+th*f
	,true)
	surface.SetTextPos(tx,ty)
	surface.SetTextColor(255,255,255,250)
	surface.DrawText(txt)
	s(	px+tx,		py+ty,
		px+tx+tw,	py+ty+th*f
	,false)

	s(	px+tx,		py+ty+th*f,
		px+tx+tw,	py+ty+th
	,true)
	surface.SetTextPos(tx,ty)
	surface.SetTextColor(245,245,245,250)
	surface.DrawText(txt)
	s(	px+tx,		py+ty+th*f,
		px+tx+tw,	py+ty+th
	,false)


	-- HELP

	surface.SetTextColor(255,255,255,230)
	if Config.rightclicked then return end
	surface.DisableClipping(true)

			local x,y,w,h=-64,0,50,70

			draw.RoundedBoxEx( 16, x, y, w, h, white, true,true,false,false )
			surface.SetDrawColor(dark)
			surface.DrawLine(x+1,y+(Config.pnlsz or 24),x+w-2,y+(Config.pnlsz or 24))
			surface.DrawLine(x+w*0.5,y+2,x+w*0.5,y+(Config.pnlsz or 24)-2)
			highlight.a=math.abs(math.sin(CurTime()*5))*150
			draw.RoundedBoxEx( 4, x+w*0.5, y, w*0.5-1, h*0.5-4, highlight, true,true,false,false )

	surface.DisableClipping(false)
end

local header_factory = vgui.RegisterTable(PANEL,"EditablePanel")


local PANEL={} -- scoreboard main GUI

local scoreboard_wide = CreateClientConVar("scoreboard_wide","800",true,false)

function PANEL:Init()
	self:SetVisible(false)

	self:SetSize(scoreboard_wide:GetInt(), ScrH()/1.2)
	self:Center()
	local P=1
	self:DockPadding(P,P,P,P+3)
	self.playerpanels={}

	self.Scores = self:Add( "DScrollPanel" )
	self.Scores:Dock( FILL )

	OverrideDrawing(self.Scores.VBar)

	self.Header=vgui.CreateFromTable(header_factory,self)
end

function PANEL:ResizeToPlayerPanels()
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	self:SetWide(Config.adhd and 500 or scoreboard_wide:GetInt())
	self.Scores:Rebuild()
	self.Scores:InvalidateLayout(true)
	self.Scores:SizeToContents()
	self:SizeToChildren( false, true )

	local tall=self:GetTall()
	local maxtall = ScrH()-32


	tall=tall<64 and 64 or tall<ScrH()*0.1 and ScrH()*0.1 or tall>maxtall and maxtall or tall
	self:SetTall(tall)

	self:Center()

	if Config.rightalign then
		local x,y = self:GetPos()
		self:SetPos(ScrW()-self:GetWide(),y)
	end
end

function PANEL:RemovePlPanel(pnl)
	--print("removing",pnl:GetPlayerData().name or pnl:GetPlayerData().Name)
	pnl:DockPadding(0,0,0,0)
	pnl:DockMargin(0,0,0,0)
	pnl:SetTall(0)
	pnl.invalid = true
	pnl:InvalidateLayout(true)
	--pnl:SetParent(self)
	--pnl:Remove()
	for k,v in pairs(self.playerpanels) do
		if pnl==v then
			self.playerpanels[k] = nil
		end
	end
	self:SweepTeamCols()
	self.Scores:InvalidateLayout()
	self.Scores:Rebuild()
	self:ResizeToPlayerPanels()
end



function PANEL:PurgeIfObsolete(pnl)

	local pl=pnl:GetPlayerData()

	if self:ShouldShowPlayer( pl ) then return end
	self:RemovePlPanel(pnl)

end

function PANEL:PurgeObsoletes()
	for pnlpl,pnl in pairs(self.playerpanels) do
		self:PurgeIfObsolete(pnl)
	end
end
function PANEL:ShouldShowPlayer( pl )
	if not pl
		or (   (pl.state == 4 or pl.left) and ( ( (pl.statetime or 0)+30 ) < RealTime() )  )
		or (pl.ServerID and (Config.hideotherservers or (pl.ServerID == 5001 and (player.GetBySteamID64(pl.SteamID64) or Config.hideirc))))
	then -- player_disconnect
		return false
	end
	if Config.hideconnecting then
		local t = pl.Entity and pl.Entity:IsValid() and pl.Entity:Team() or tonumber(pl.teamid) or tonumber(pl.team) or tonumber(pl.Team)
		if not t or t==0 or t==team_connecting then
			return false
		end
	end
	return true
end

function PANEL:RefreshPlayer(pl)

	-- lets not create players who dont exist anymore
	if not self:ShouldShowPlayer( pl ) then return end

	for pnlpl,pnl in pairs(self.playerpanels) do
		if pnl:GetPlayerData() == pl then
			return pnl:RefreshPlayer(pl)
		end
	end

	local pnl = vgui.CreateFromTable(player_panel_factory,self)
	pnl:SetPlayerData(pl)
	pnl.scoreboard_panel=self
	pnl:SetZPos(tonumber(pl.teamid) or tonumber(pl.team) or tonumber(pl.Team) or -10000)
	self.Scores:AddItem(pnl)
	self:SweepTeamCols()
	self.playerpanels[pl] = pnl
end
--_G.skiplist=skiplist
--_G.hadactivity=hadactivity
--_G.Tags=Tags
function PANEL:AllRefreshed()

	if not Config.ocd_fix then return end

	for k,had in next,hadactivity do
		if had then
			skiplist[k]=false
			--Msg"X"
		else
			skiplist[k]=true
			--Msg"_"
		end

	end
	--Msg"\n"
	--for k,v in next,skiplist do
	--	Msg(v and "X" or " ")
	--end
	--Msg"\n"

	for k,v in next,hadactivity do
		hadactivity[k]=false
	end
end

function PANEL:RefreshTags()
	local previt = self.__previt
	local it = self.playerpanels
	if not it[previt] then
		previt=nil
		self:AllRefreshed()
	end
	local pnl
	self.__previt,pnl=next(it,previt)
	if pnl then
		pnl:RefreshTags()
	end
end

function PANEL:SetTeamCols(teamid)
	if not teamid then
		if self.teamcols then
			for k,v in pairs(self.teamcols) do
				v:Remove()
				self:InvalidateLayout()
			end
		end
		self.teamcols=false
		return
	end
	if not self.teamcols then
		self.teamcols={}
	end

	self:CreateTeamCol(teamid)
end
function PANEL:SweepTeamCols()
	if not self.teamcols then return end
	local temp={}
	for teamid,pnl in pairs(self.teamcols) do
		temp[teamid]={0,pnl}
	end
	for k,pnl in pairs(self.playerpanels) do
		local pl=pnl:GetPlayerData()
		local teamid = pl.Entity and pl.Entity:IsValid() and pl.Entity:Team() or tonumber(pl.teamid) or tonumber(pl.team) or tonumber(pl.Team) or team_connecting
		if teamid==0 or teamid==team_connecting and (pl.state == 4 or pl.left) then
			teamid = team_left
		end

		if teamid and temp[teamid] then
			temp[teamid][1]=temp[teamid][1]+1
		end
	end
	for teamid,tempdata in pairs(temp) do
		local count=tempdata[1]
		local pnl=tempdata[2]
		pnl.count=count

		if count == 0 then
			pnl:Remove()
			self.teamcols[teamid]=nil
		end
	end

end


function PANEL:CreateTeamCol(teamid)
	if self.teamcols[teamid] then return end
	local col=vgui.Create('EditablePanel',self.Scores or self)
	col:SetTall(16+5)
	col:Dock(TOP)
	col:DockPadding(0,0,0,0)
	col:DockMargin(0,8,0,0)
	col.teamid=teamid
	local tcol = team.GetColor(teamid)
	local r,g,b=tcol.r,tcol.g,tcol.b
	local rev=0.2126*r + 0.7152*g + 0.0722*b

	local tn = team.GetName(teamid)
	local ltn = L(tn)
	local tname = ltn:sub(0,1):upper()..ltn:sub(2)
	tname = tname--..' '..rev
	rev=rev>170 -- arbitrary

	local ba = { x = 0, y = 0 }
	local bb = { x = 0, y = 0 }
	local bc = { x = 0, y = 0 }
	local bd = { x = 0, y = 0 }

	local poly ={ba,bb,		bc,		bd}
	function col:Paint(w,h)
		h=h-5
		surface.SetFont(NameFont)


		if rev then
			surface.SetTextColor(90,90,90,255)
		else
			surface.SetTextColor(255,255,255,255)
		end

		local txt2=self.count or 0
		if txt2 < 2 then txt2=false else
			txt2=(txt2<10 and "  " or " ")..txt2..' '
		end

		local txt = tname..'  '
		local tw,th=surface.GetTextSize(txt)

		local pad = 4+16+1

		surface.SetDrawColor(r,g,b,200)
			draw.NoTexture()

			ba.y=h
			ba.x=8-1
			bb.x=pad
			bc.x=tw+pad
			bd.x=tw+pad
			bd.y=h
			--surface.DrawRect(0,0,tw+pad,h)


			if txt2 then
				local tw2,th2=surface.GetTextSize(txt2 or "")
	--			surface.SetDrawColor(90,90,90,200)
	--			surface.DrawRect(tw+pad,0,tw2,h)
				bc.x=tw+pad+tw2
				bd.x=tw+pad+tw2
			end
		surface.DrawPoly( poly )
		surface.DrawRect(8-1,h,4,5)

		local ty = h*0.5-th*0.5

		surface.SetTextPos(pad,ty)
		surface.DrawText(txt)
		if txt2 then
			--surface.SetTextColor(200,200,200,255)
			surface.DrawText(txt2)
		end

	end
	self.teamcols[teamid]=col or true
	col:SetZPos(teamid*2-1)
	self.Scores:AddItem(col)
	self:InvalidateLayout()
	self:SweepTeamCols()
	return col
end

local errored_clamp
function PANEL:SortPlayers(how) -- how should persist?
	how=how or Config.how or self.how or 1
	self.how=how
	Config.how=how


	local namesort
	if how==3 then
		local sort={}
		namesort={}
		local k=0
		for pnlpl,pnl in pairs(self.playerpanels) do
			k=k+1
			local pl=pnl:GetPlayerData()
			sort[#sort+1]={k,tostring(pl.name)}
		end
		table.sort(sort,function(a,b) return a[2]<b[2] end)
		for k,v in pairs(sort) do
			namesort[v[1]]=k
		end
	elseif how==5 then
		local sort={}
		namesort={}
		local k=0
		for pnlpl,pnl in pairs(self.playerpanels) do
			k=k+1
			local time = -math.huge
			local data=pnl:GetPlayerData()
				local ply=data.Entity
				if ply and ply:IsValid() and ply.GetUTimeStart then
					time = ply:GetUTime() + CurTime() - ply:GetUTimeStart()
				end

			sort[#sort+1]={k,time}
		end
		table.sort(sort,function(a,b) return a[2]>b[2] end)
		for k,v in pairs(sort) do
			namesort[v[1]]=k
		end
	end

	local manyteam,lastteam=nil,nil
	local k=0
	for pnlpl,pnl in pairs(self.playerpanels) do
		k=k+1
		local sortpos

		local pl=pnl:GetPlayerData()

		if how==1 then -- by teamid
			sortpos = pl.Entity and pl.Entity:IsValid() and pl.Entity:Team() or tonumber(pl.teamid) or tonumber(pl.team) or tonumber(pl.Team) or team_connecting
			if sortpos==0 or sortpos==team_connecting and (pl.state == 4 or pl.left) then
				sortpos = team_left
			end
		elseif how==2 then
			sortpos = tonumber(pl.ServerID) or -5000
		elseif how==3 then
			assert(namesort[k]~=nil)
			sortpos = namesort[k]
		elseif how==6 then
			sortpos = pl.Entity and pl.Entity:IsValid() and pl.Entity:AccountID()
				or (pl.networkid and util.AccountIDFromSteamID(pl.networkid))
				or (pl.SteamID64 and util.AccountIDFromSteamID(util.SteamIDFrom64(pl.SteamID64)))
				or 0
			if sortpos==0 then -- put to lowest
				sortpos = 31997
			else
				sortpos = sortpos * 1.39697e-05 - 30000
				sortpos = math.Clamp(sortpos,-32000,32000)
			end
		elseif how==5 then
			sortpos = namesort[k]  or 31997
		elseif how==4 then
			sortpos = tonumber(pl.index) or 31997
		end

		if not sortpos then
			sortpos = tonumber(pl.userid) or tonumber(pl.UserID)
		end
		sortpos=tonumber(sortpos) or -1
		if math.abs(sortpos)>31998 then
			if true or not errored_clamp then
				errored_clamp =true
				Msg(('[SB] Clamping sortpos %f for %s\n'):format(sortpos,tostring(pl.Name)))
			end
			sortpos = math.Clamp(sortpos,-31998,31998)
		end

		if how==1 then
			self:SetTeamCols(sortpos) --teamid
			if lastteam==nil then
				lastteam=sortpos
			else
				if lastteam~=sortpos then
					manyteam=true
				end
			end
			sortpos=sortpos*2 -- place for team panel, SIGH..............
		else
			self:SetTeamCols(false)
		end

		--print("Sorting",pnl.Entity,"by",how,how==1 and "teamid" or how==2 and "serverid" or "userid","("..sortpos..")")
		pnl:SetZPos(sortpos)
	end
	if lastteam and not manyteam then
		--print("not many teams")
		self:SetTeamCols(false)
	end
end

local gameevent=gameevent

local function OnIRC(pl)
	local cc = crosschat and crosschat.serverdata
	
	if not cc or not cc[5001] or not cc[5001].players then return end
	
	for id, user in next, cc[5001].players do
		if pl.steamid64 == user.SteamID64 and not user.left then
			return true 
		end
	end	
end

function PANEL:RefreshPlayers()
	if not gameevent.eventcache then error"gamevent extension missing" end
	
	for userid,pl in next,gameevent.eventcache do
		if IsValid( pl.Entity ) then
			local onirc = OnIRC(pl)
			pl.Entity.__onirc = onirc
		end
		self:RefreshPlayer(pl)
	end
	
	local cross_data = crosschat and crosschat.serverdata
	if cross_data then
		for _,server in next,cross_data do
			for k,pl in next,server.players do
				self:RefreshPlayer(pl)
			end
		end
	end
	self:PurgeObsoletes()

	self:SortPlayers()
	self:SweepTeamCols()
	self:ResizeToPlayerPanels()
end

function PANEL:Think()
	if _G.scoreboard_panel~=self then
		self:Remove()
	end
	self:RefreshTags()

	local vis = vgui.CursorVisible()
	if self.cursorvis~=vis then
		self.cursorvis = vis
		self:EnableScrollbar(vis)
	end
end

function PANEL:ScrollHack(dlta)
	self.Scores.VBar.Enabled = true
	if self.Scores and self.Scores.VBar  and self.Scores.VBar.AddScroll then
		self.Scores.VBar:AddScroll( dlta * -2 )
	end
end

function PANEL:EnableScrollbar(enable)
	--self.Scores.VBar.forceoff = not enable
	self:InvalidateLayout( true )
end

local gradient_down = Material("VGUI/gradient_down.vmt")

function PANEL:Paint(w,h)
	local off = 16+2
	local sz = 8
	--surface.SetDrawColor(66,66,66,150) surface.DrawRect(off,0,w-off,h)


end

------ showhide logics below -------


function PANEL:Show()
	if not self:IsVisible() then
		self:SetVisible(true)
		self:SetKeyboardInputEnabled( true )
		self:SetMouseInputEnabled( true )
	end
	self:RefreshPlayers()
	self:SetZPos(30000)


	hook.Add("CreateMove",Tag,function(ucmd)
		local d = ucmd:GetMouseWheel()
		if d~=0 and self:IsValid() and self:IsVisible() and not self.cursorvis then
			self:ScrollHack(d)
		end
	end)

end


function PANEL:Close()
	self:SetVisible(false)
	if CloseDermaMenus then CloseDermaMenus() end
	ShouldDrawLocalPlayer = false

	hook.Remove("CreateMove",Tag)
	RunConsoleCommand"cancelselect"
end

local scoreboard_factory = vgui.RegisterTable(PANEL,"EditablePanel")


local scoreboard_panel
if _G.scoreboard_panel and IsValid(_G.scoreboard_panel) then _G.scoreboard_panel:Remove() end



local function HidePanel()
	if scoreboard_panel then
		scoreboard_panel:Close()
	end
	if not Config.loaded then return end
	Config:Save()
end


local function ShowPanel()
	if not ValidPanel(scoreboard_panel) then
		Config:Load()
		Config.loaded=true
		scoreboard_panel=vgui.CreateFromTable(scoreboard_factory)
		_G.scoreboard_panel=scoreboard_panel
	end

	scoreboard_panel:Show()

end


-- Hooking --


local matBlurScreen = Material( "pp/blurscreen" )

local starttime = 0
local stoptime = 2

local function HUDPaintBackground(   )
	local now = RealTime()

	if scoreboard_panel and scoreboard_panel:IsVisible() then
		stoptime = now
	end

    local frac = (now - starttime) * 5
	frac=frac>1 and 1 or frac<0 and 0 or frac
	frac=math.sin(frac*math.pi*0.5)


	local f2 = (now - stoptime)* 5

	local sw,sh = ScrW(), ScrH()

	f2=f2>1 and 1 or f2<0 and 0 or f2
	frac=frac-f2
	frac=frac>1 and 1 or frac<0 and 0 or frac

	if f2==1 then
		hook.Remove("HUDPaintBackground","scoreboardbg")
		--	print"remove"
	end

    surface.SetMaterial( matBlurScreen )
    surface.SetDrawColor( 255, 255, 255, frac*255 )

    for i=0.33, 1, 0.33 do
        matBlurScreen:SetFloat( "$blur", frac * 5 * i )
        matBlurScreen:Recompute()
        if ( render ) then render.UpdateScreenEffectTexture() end
        surface.DrawTexturedRect( 0,0, sw, sh )
    end
    surface.SetDrawColor(10,10,10,frac*55)
    surface.DrawRect(0,0,sw,sh)
end


local function ShowBlur()
	if not Config.noblur then
		starttime = RealTime()
		stoptime = RealTime()+4
		hook.Add("HUDPaintBackground","scoreboardbg",HUDPaintBackground)
	end
end

local function CreateScoreboard()
end

local function ScoreboardShow()
	local ok,err = pcall(ShowPanel)
	if not ok then ErrorNoHalt("Scoreboard Show error: "..err) end
	local ok,err = pcall(ShowBlur)
	if not ok then ErrorNoHalt("Scoreboard Blur error: "..err) end
	return true
end

local function ScoreboardHide()
	gui.EnableScreenClicker(false)
	local ok,err = pcall(HidePanel)
	if not ok then ErrorNoHalt("Scoreboard Hide error: "..err) end
	return true
end

local function PlayerBindPress(ply, bind, pressed)

	if pressed and bind == "+attack2" and scoreboard_panel and scoreboard_panel:IsVisible() then

		--local x,y=scoreboard_panel.Header:LocalToScreen()
		--x=x+scoreboard_panel.Header:GetWide()*0.5
		--gui.SetMousePos(x,y)
		gui.EnableScreenClicker(true)
		return true
	end
end




hook.Add("CreateScoreboard", Tag, CreateScoreboard)
hook.Add("ScoreboardShow", Tag, ScoreboardShow)
hook.Add("ScoreboardHide", Tag, ScoreboardHide)
hook.Add("PlayerBindPress", Tag, PlayerBindPress)