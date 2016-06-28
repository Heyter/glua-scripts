hook.Add("HUDPaint","speedhud",function()
	local vel = LocalPlayer()
	vel = vel.GetVelocity(vel)
	vel.z = 0

	local rainbow = HSVToColor(RealTime()*100%360,1,1)

	draw.SimpleText("run: "..LocalPlayer():GetRunSpeed(),"DermaDefault",5,0,rainbow)
	draw.SimpleText("walk: "..LocalPlayer():GetWalkSpeed(),"DermaDefault",5,10,rainbow)
	draw.SimpleText("vel: "..math.Round(vel.Length(vel)).."ups","DermaDefault",5,20,rainbow)
end)

LocalPlayer():PrintMessage(3,"Want to remove Speedhud? !lm hook.Remove(\"HUDPaint\",\"speedhud\")")