aowl.AddCommand("stopthat",function(ply,target)
	local vic = ply
	local v = easylua.FindEntity(target)
	local mdl = vic:GetModel()
	if v:IsPlayer() then
		v:ConCommand("cl_dmg_mode 3")
	end

	vic:EmitSound("vo/trainyard/male01/cit_hit0"..math.random(1, 3)..".wav")

	if vic:IsOnFire() then
		vic:Extinguish()
	end

	if not IsValid(v) then return end
	if not v:IsPlayer() then
		v = v:CPPIGetOwner()
		if not IsValid(v) or not v:IsPlayer() then
			return
		end
	end

	local id = v:UserID()..'pl_lua_npc_kill'
	if timer.Exists(id) then
		return
	end

	timer.Create(id,1,1, function()
		timer.Remove(id)
		if IsValid(v) then
			if v:Alive() then
				if v:IsValid() then
					v:EmitSound("ambient/explosions/explode_2.wav")
				end
				if v:IsPlayer() then
					local weapon = v:GetActiveWeapon()
					weapon = IsValid(weapon) and weapon:GetClass() or nil
				end
				local info = DamageInfo()
				info:SetInflictor(game.GetWorld())
				info:SetAttacker(vic:IsValid() and vic or game.GetWorld())
				info:SetDamage(v:Health())
				v:TakeDamageInfo(info)

				local ent = v:GetRagdollEntity()
				if not IsValid(ent) then return end
				ent:SetName("dissolvemenao"..tostring(ent:EntIndex()))

				local e=ents.Create'env_entity_dissolver'
				e:SetKeyValue("target","dissolvemenao"..tostring(ent:EntIndex()))
				e:SetKeyValue("dissolvetype","1")
				e:Spawn()
				e:Activate()
				e:Fire("Dissolve",ent:GetName(),0)
				SafeRemoveEntityDelayed(e,0.1)
				timer.Simple(0.5,function()
					if !v:IsPlayer() then return end
					v:ConCommand("cl_dmg_mode 1")
				end)
			end
		end
	end)
end,"developers")