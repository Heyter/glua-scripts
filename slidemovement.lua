if SERVER then
	local SlideVelocity = 1000
	hook.Add("SetupMove","SlideMovement",function(ply,mv,cmd)
		if ply:KeyDown(IN_FORWARD) and ply:KeyDown(IN_WALK) and ply:KeyDown(IN_SPEED) and !ply.HasSlid then
			SlideVelocity = math.Approach(SlideVelocity, 1000, 0.5 )
			local AimPos = Angle( 0, ply:EyeAngles().y, 0):Forward()
			ply:SetVelocity(AimPos*SlideVelocity)
			ply.HasSlid = true
			timer.Simple(2,function() ply.HasSlid = false end)
		end
	end)
end