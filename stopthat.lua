hook.Add("PlayerShouldTakeDamage","Flex_StopThat",function(pl,att)
	if pl != att and att == me then
		return true
	end
end)

hook.Add("PlayerHurt","Flex_StopThat",function(vic,att)
	if vic != me then return end
	if vic == me and att == me then return end
   	local v = att
	local mdl = vic:GetModel()

	vic:EmitSound("vo/trainyard/male01/cit_hit02.wav")

	if vic:IsOnFire() then
		vic:Extinguish()
	end

	if not IsValid(v) then return end
	if not v:IsPlayer() then
		v = v:CPPIGetOwner()
		if not IsValid(v) then
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

				local weapon = v:GetActiveWeapon()
				weapon = IsValid(weapon) and weapon:GetClass() or nil
				local info = DamageInfo()
				info:SetInflictor(game.GetWorld())
				info:SetAttacker(vic:IsValid() and vic or game.GetWorld())
				info:SetDamage(v:Health())
				v:TakeDamageInfo(info)
				vic:SetHealth(10000)

				local ent = v:GetRagdollEntity()
				if not IsValid(ent) then return end
				ent:SetName("dissolvemenao"..tostring(ent:EntIndex()))

				for i = 1,10 do
					local e=ents.Create'env_entity_dissolver'
					e:SetKeyValue("target","dissolvemenao"..tostring(ent:EntIndex()))
					e:SetKeyValue("dissolvetype","1")
					e:Spawn()
					e:Activate()
					e:Fire("Dissolve",ent:GetName(),0)
					SafeRemoveEntityDelayed(e,0.1)
				end
				if vic:IsValid() then
					if MetAchievements and MetaWorks.FireEvent then MetaWorks.FireEvent("ms_npcdissolve", v, vic, weapon) end
				end
			end
		end
	end)
end)
