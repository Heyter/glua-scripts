--[[
FAutoload v1
]]--

if CLIENT then
	local revive     = CreateClientConVar("fa_autorevive",1,true,true)
	local fnp_enable = CreateClientConVar("flexnp_enabled",1,true,true)
	local fnp_chat   = CreateClientConVar("flexnp_chatprint",1,true,true)
	local fnp_title  = CreateClientConVar("flexnp_title",1,true,true)

	hook.Add("Think","autorevive",function()
		if !LocalPlayer():Alive() and GetConVar("fa_autorevive"):GetInt() == 1 then
			if aowl then
				LocalPlayer():ConCommand("aowl revive")
			end
		end
	end)

	--[[local np = file.Read("nowplaying/nptitle.txt","DATA")
	np = string.gsub(np,"  np: ","")
	local oldnp = np
	hook.Add("Think","npupdate",function()
		if GetConVar("flexnp_enabled"):GetInt() == 1 then
			local npshort = file.Read("nowplaying/nptitle.txt","DATA")
			np = npshort
			np = string.gsub(np,"  np: ","")
			np = string.gsub(np,"'","")
			if oldnp != np then
				np = npshort
				np = string.gsub(np,"  np: ","")
				np = string.gsub(np,"'","")
				oldnp = np
				if fnp_title:GetInt() == 1 then
					me:SetCustomTitle(np)
				end
				if fnp_chat:GetInt() == 1 then
					luadev.RunOnClients("chat.AddText(Color(100,200,100),'[FlexNP] ',color_white,'"..tostring(np).."')")
				end
			end
		end
	end)--]]

	hook.Add( "PlayerSay", "fautoload_chatcmds", function( ply, text, team, dead )
		if text:match"^!np" then
			local np = file.Read("nowplaying/nptitle.txt","DATA")
			np = string.gsub(np,"  np: ","")
			luadev.RunOnClients("chat.AddText(Color(100,200,100),'[FlexNP] ',color_white,'"..tostring(np).."')")
		end

		if text:match"^!rcs" and ply == me then
		return select(2,table.Random(chatsounds.SortedListKeys))
		end

		if text:match"^!crashcs" and ply == me then
			timer.Create("crashcs",0.8,0,function()
				Say(select(2,table.Random(chatsounds.SortedListKeys)))
			end)
			--timer.Simple(2,function() timer.Remove("crashcs") end)
		end

		local cmd,mood = text:match"^!mood (.+)"
		if string.sub(text,1,5) == "!mood" and ply == me then
			if string.sub(text,7,10) == "sad" then
				me:SetCustomTitle("(\xe2\x97\xa1 \xe2\x81\x94 \xe2\x97\xa1 )")
			elseif string.sub(text,7,10) == "mad" then
				me:SetCustomTitle("(\xe2\x95\xaf\xc2\xb0\xe2\x96\xa1\xc2\xb0)\xe2\x95\xaf")
			elseif string.sub(text,7,12) == "happy" then
				me:SetCustomTitle("(\xe2\x97\xa1 \xe2\x80\xbf \xe2\x97\xa1 )")
			elseif string.sub(text,7,18) == "indifferent" then
				me:SetCustomTitle("(\xe2\x97\xa1 _ \xe2\x97\xa1 )")
			end
		end

		if text:match"^!goto_off" and ply == me then
			luadev.RunOnServer([[
					hook.Add("CanPlyGotoPly","LeaveMeAloneD:",function(ply,dply)
						if dply:SteamID() == "STEAM_0:0:58178275" then
							return false,"I just want to be left alone D:"
						end
					end)
				]])
		end

		if text:match"^!goto_on" and ply == me then
			luadev.RunOnServer([[hook.Remove("CanPlyGotoPly","LeaveMeAloneD:")]])
		end

		if text:match"^gravity noooo" or string.sub(text,1,38) == "gravity who gives a crap about gravity" and ply == me then
			luadev.RunOnServer([[me:SetGravity(0.1)]])
		end

		if text:match"^!gravity_normal" and ply == me then
			luadev.RunOnServer([[me:SetGravity(1)]])
		end

		if string.sub(text,1,9) == "!hostname" and ply == me then
			Say(GetHostName():match(".+ %- (.+)") or "failed!!")
		end
	end)

	chat.AddText(Color(100,200,100),"[FA]",Color(255,255,255)," FAutoload loaded")
end
