local sitting = false

hook.Add("Think","PACSittingOnMe",function()
	local seat = LocalPlayer():GetParent()
	if IsValid(seat) and seat:GetClass() == "prop_vehicle_prisoner_pod" then
		for _,ent in pairs(ents.FindInSphere(seat:GetPos(),20)) do
			if ent != seat then
				if ent:IsValid() and ent:IsPlayer() then
					if ent:GetAngles() == LocalPlayer():GetAngles() and sitting != true then
						sitting = true
						RunConsoleCommand("pac_event","sithug",1)
					end
				elseif sitting == true and LocalPlayer():GetSequence() == "sit_rollercoaster" and !ent:IsPlayer() then
					sitting = false
					RunConsoleCommand("pac_event","sithug",1)
				end
			end
		end
	end
end)