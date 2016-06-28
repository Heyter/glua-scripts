aowl.AddCommand("fakeban",function(ply,line,target,reason)
	local t = easylua.FindEntity(target)
	for _,p in pairs(player.GetAll()) do
		p:SendLua([[chat.AddText(Color(255,11,11,255),"\xe2\x97\x84 ",Color(]]..team.GetColor(ply:Team()).r..","..team.GetColor(ply:Team()).g..","..team.GetColor(ply:Team()).b..[[),"]]..ply:Name()..[[",
					Color(255,11,11,255)," banned ",Color(]]..team.GetColor(t:Team()).r..","..team.GetColor(t:Team()).g..","..team.GetColor(t:Team()).b..[[),"]]..t:Name()..[[",
					Color(255,111,111,255)," until ",
					Color(150,200,255,255),"never",
					Color(255,111,111,255),": ",
					Color(255,255,255,255),"]]..reason..[[",
					Color(255,11,11,255)," \xe2\x96\xba")
					surface.PlaySound"ambient/alarms/apc_alarm_pass1.wav"]])
	end
end,"developers")