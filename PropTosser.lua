hook.Add("Think","PropTosser_"..me:EntIndex(),function()
	local tr = me:GetEyeTrace()
	for _,prop in pairs(ents.GetAll()) do
		if prop.CPPIGetOwner and prop:CPPIGetOwner() == me and prop.tossme then
			local p = prop:GetPhysicsObject()
			if IsValid(p) then
				if me:KeyDown(IN_ATTACK) then
					local go = Vector(tr.HitPos.x-prop:GetPos().x,tr.HitPos.y-prop:GetPos().y,tr.HitPos.z-prop:GetPos().z)
					p:ApplyForceCenter(go)
				else
					local bring = Vector(me:EyePos().x-prop:EyePos().x,me:EyePos().y-prop:EyePos().y,me:EyePos().z-prop:EyePos().z)
					p:ApplyForceCenter(bring)
				end
			end
		end
	end

	if me:KeyDown(IN_USE) and IsValid(tr.Entity) then
		tr.Entity.tossme = true
	end
end)