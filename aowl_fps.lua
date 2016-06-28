if SERVER then
	util.AddNetworkString("fbox_fps")

	aowl.AddCommand("fps",function(pl,line)
		net.Start("fbox_fps")
			net.WriteInt(1,3)
		net.Broadcast()
		ChatAddText(Color(220,70,100),"Player FPS:")
	end)

	net.Receive("fbox_fps",function(len,pl)
		local name_noc = pl:GetName()
		name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"%^(%d+%.?%d*)","")

		local plcol = net.ReadVector()
		local fps = net.ReadInt(16)
		local focus = net.ReadBool()
		local w,h = net.ReadInt(16),net.ReadInt(16)

		net.Start("fbox_fps")
			net.WriteInt(2,3)
			net.WriteString(name_noc)
			net.WriteVector(plcol)
			net.WriteInt(fps,16)
			net.WriteBool(focus)
			net.WriteInt(w,16)
			net.WriteInt(h,16)
		net.Broadcast()
	end)
end

if CLIENT then
	net.Receive("fbox_fps",function()
		if net.ReadInt(3) == 1 then
			net.Start("fbox_fps")
				local r,g,b = GetConVar("cl_playercolor"):GetString():match("(.+) (.+) (.+)")
				local fps = math.Round(1/RealFrameTime())
				net.WriteVector(Vector(r,g,b))
				net.WriteInt(fps,16)
				net.WriteBool(system.HasFocus())
				net.WriteInt(ScrW(),16)
				net.WriteInt(ScrH(),16)
			net.SendToServer()
		else
			local pl = net.ReadString()
			local plcol = net.ReadVector()
			plcol = Color(plcol.x*255,plcol.y*255,plcol.z*255)
			local fps = net.ReadInt(16)
			local focus = net.ReadBool()
			local w,h = net.ReadInt(16),net.ReadInt(16)

			surface.SetFont("chathud_chatprint")

			chat.AddText(plcol,pl,Color(255,255,255),(" "):rep(math.floor((100-surface.GetTextSize(pl))/surface.GetTextSize(" ")))," | FPS: ",Color(255,255,100),fps,(" "):rep(string.len(tostring(fps)) == 3 and 0 or string.len(tostring(fps)) == 2 and 1 or 2),Color(255,255,255)," | Resolution: ",Color(255,255,100),w,"x",h,Color(255,255,255),(" "):rep(string.len(h) == 3 and 1 or 0)," | Focused: ",Color(255,255,100),focus and "Yes" or "No")
		end
	end)
end