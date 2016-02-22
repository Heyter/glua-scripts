--[[
===========
aowlcool v1
various custom commands
===========
]]--

if CLIENT then

local rand_bdg = {
	"#rekt",
	"xXx_MLG_xXx",
	"Micspammer",
	"Developer",
	"Greentexter",
}

local quality = {
	"<c=B2B2B2>Normal ",
	"<c=8650AC>Unusual ",
	"<c=38F3AB>Haunted ",
	"<c=FFD700>Unique ",
	"<c=CF6A32>Strange ",
	"<c=4D7455>Genuine ",
	"<color=71,98,145>Vintage ",
	"<c=AA0000>Collectors ",
	"<c=A50F79>Valve ",
	"<c=70B04A>Community ",
	"<color=211,44,230>StatTrak™ ",
	"<color=235,75,75>★ ",
}

local ClareStrings = {
	"Try asking again ^_^",
	"Ew, no. :c",
	"Why would you ask that? :v",
	"Ask Henke. :v",
	"I dunno. ¯\\_(^_^)_/¯",
	"Probably.",
	"This is illegal, you know. D:",
	"Yes! :D",
}

hook.Add( "PlayerSay", "aowlcool", function( ply, text, team, dead )

	--Travel

	if GetConVarNumber("ac_chatprint") == 1 then

	if ( string.sub( text, 1, 5 ) == "!goto" ) and ply == me then
		RunConsoleCommand("aowl","goto",string.gsub(text,"%!goto ",""))
		return "/me <color=200,200,200>→ <color=100,200,100>"..string.gsub(text,"%!goto ","")
	end
	if ( string.sub( text, 1, 6 ) == "!bring" ) and ply == me then
		RunConsoleCommand("aowl","bring",string.gsub(text,"%!bring ",""))
		return "/me <color=200,200,200>← <color=100,200,100>"..string.gsub(text,"%!bring ","")
	end
	if ( string.sub( text, 1, 5 ) == "!back" ) and ply == me then
		RunConsoleCommand("aowl","back")
		return "/me <color=200,200,200>→ <color=100,200,100>prev location"
	end

	--Lua

	if ( string.sub( text, 1, 6 ) == "!lfind" ) and ply == me then
		RunConsoleCommand("lua_find",string.gsub(text,"%!lfind ",""))
		return "/me <color=200,200,200>\xf0\x9f\x94\x8d <color=100,200,100>"..string.gsub(text,"%!lfind ","")
	end
	if ( string.sub( text, 1, 7 ) == "!lcfind" ) and ply == me then
		RunConsoleCommand("lua_find_cl",string.gsub(text,"%!lcfind ",""))
		return "/me <color=200,200,200>\xf0\x9f\x94\x8d <color=127,159,191>(client) <color=100,200,100>"..string.gsub(text,"%!lcfind ","")
	end

	end

	--Misc

	if ( string.sub( text, 1, 8 ) == "!fakeach" ) and ply == me then
		return "/me <color=255,255,255>earned the achievement <color=255,220,0>"..string.gsub(text,"%!fakeach ","").." <bday!!!>"
	end
	if ( string.sub( text, 1, 8 ) == "!fakebdg" ) and ply == me then
		return "/me <color=255,255,255>upgraded their badge to <color=0,220,255>"..string.gsub(text,"%!fakebdg ","").." <color=200,200,200>("..table.Random(rand_bdg).." Level "..math.random(1,25)..")"
	end
	if ( string.sub( text, 1, 6 ) == "!unbox" ) and ply == me then
		return "/me <color=255,255,255>has unboxed "..table.Random(quality)..string.gsub(text,"%!unbox ","")
	end
	if ( string.sub( text, 1, 7 ) == "!advert" ) and ply == me then
		return "/me <color=255,0,0>[<color=0,255,0>FAdvert<color=255,0,0>] <color=255,255,255>"..string.gsub(text,"%!advert ","")
	end
	if ( string.sub( text, 1, 4 ) == "!fps" ) and ply == me then
		return "/me <color=200,100,100>FPS: <color=100,200,100>"..math.Round(1/FrameTime())
	end
	if ( string.sub( text, 1, 3 ) == "!np" ) and ply == me then
		local np = string.gsub(file.Read("nowplaying/nptitle.txt","DATA"),"  np: ","")
		local np = string.gsub(np,"%(%d%d:%d%d | %d%d:%d%d%)","")
		local np = string.gsub(np,"%[(.+)%] ","")
		local np = string.gsub(np,"%d.+%. ","")
		return "/me <color=100,200,100>Now Playing: <color=200,100,200>"..np
	end
	if ( string.sub( text, 1 ,4) == "!abh" ) and ply == me then
		return "ABH \xf0\x9f\x8f\x83\xe2\x86\x92"
	end
end)

CreateClientConVar("ac_autorevive",1,true,true)
CreateClientConVar("ac_chatprint",1,true,true)
CreateClientConVar("ac_speedhud",1,true,true)

hook.Add("Think","autorevive",function()
	if !LocalPlayer():Alive() and GetConVarNumber("ac_autorevive") == 1 then
		LocalPlayer():ConCommand("aowl revive")
	end
end)

hook.Add("HUDPaint","speedhud",function()
	if GetConVarNumber("ac_speedhud") == 1 then
	local vel = LocalPlayer()
	vel = vel.GetVelocity(vel)
	vel.z = 0

	local rainbow = HSVToColor(RealTime()*100%360,1,1)

	draw.SimpleText("run: "..LocalPlayer():GetRunSpeed(),"DermaDefault",5,0,rainbow)
	draw.SimpleText("walk: "..LocalPlayer():GetWalkSpeed(),"DermaDefault",5,10,rainbow)
	draw.SimpleText("vel: "..math.Round(vel.Length(vel)).."ups","DermaDefault",5,20,rainbow)
	end
end)

local WasAFK = false

local AFKPhrases = {
	"Rest well.",
	"I'll be right by you. :3",
	"Enjoy your nap master.",
	"Don't mind me. ^_^ *noms on tail*"
}
local BackPhrases = {
	"Wakey wakey! ^_^",
	"Ah, you're awake now! Fun will begin!",
	"Master is awake, playtime begins. ^_^",
	"*plays with tail* Oh, you're awake now. ^_^",
}

hook.Add("Think","AFKPhrases",function()
	if !LocalPlayer().IsAFK then return end
	if LocalPlayer():IsAFK() and WasAFK == false then
		chat.AddText(Color(33,91,51),"Clare",color_white,": "..table.Random(AFKPhrases))
		WasAFK = true
	elseif !LocalPlayer():IsAFK() and WasAFK == true then
		chat.AddText(Color(33,91,51),"Clare",color_white,": "..table.Random(BackPhrases))
		WasAFK = false
	end
end)

local HealPhrases = {
	"Here, patch yourself up. c:",
	"You don't look okay. Take this.",
	"Take this medkit.",
	"Don't die on me Master!",
}

function AC_HealText()
	chat.AddText(Color(33,91,51),"Clare",color_white,": "..table.Random(HealPhrases))
end

end

if SERVER then

timer.Create("FlexHeal",10,0,function()
	if me:Health() < 100 then
		me:SetHealth(me:Health()+10)
		me:EmitSound("vo/npc/female01/health0"..math.random(1,5)..".wav")
		me:SendLua("AC_HealText()")
	end
end)

hook.Add("PlayerHurt","FlexRevenge",function(vic,att,hp,dmg)
	if vic == me and att != me and att != wardenn then
		--me:SetHealth(me:Health()+dmg)
		att:TakeDamage(dmg,me,att:GetActiveWeapon())
		me:PrintMessage(3,"<color=33,91,51>Clare<color=255,255,255>: Don't worry, I got you covered. ^_^")
		if att:IsPlayer() then
			att:PrintMessage(3,"<color=33,91,51>Clare<color=255,255,255>: Cya bitch. ^_^")
		end
	end
	--[[if vic == sea and att != sea then
		sea:SetHealth(sea:Health()+dmg)
		att:TakeDamage(dmg,sea,att:GetActiveWeapon())
		sea:PrintMessage(3,"<color=33,91,51>Clare<color=255,255,255>: Don't worry, I got you covered. ^_^")
		att:PrintMessage(3,"<color=33,91,51>Clare<color=255,255,255>: Cya bitch. ^_^")
	end]]

	if vic == wardenn and att != wardenn and att != me then
		wardenn:SetHealth(wardenn:Health()+dmg)
		att:TakeDamage(dmg,wardenn,att:GetActiveWeapon())
		wardenn:PrintMessage(3,"<color=125,255,255>Alice<color=255,255,255>: I got you covered.")
		if att:IsPlayer() then
			att:PrintMessage(3,"<color=125,255,255>Alice<color=255,255,255>: Bye!")
		end
	end
end)

--[[hook.Add( "PlayerSay", "askclare", function( ply, text, team, dead )
	--Clare stuff ^_^
	if ( string.sub( text, 1, 9) == "!askclare" ) then
		if string.gsub(text,"%!askclare ","") == "whats 9+10" then
			PrintMessage(3,"<color=33,91,51>Clare<color=255,255,255>: Twentyone ^_^")
		else
			PrintMessage(3,"<color=33,91,51>Clare<color=255,255,255>: "..table.Random(ClareStrings))
		end
	end
end)]]

end