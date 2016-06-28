hook.Add("PlayerShouldTakeDamage","Flex_StopThat",function(pl,att)
	if pl != att and att == me then
		return true
	end

	if pl == me and att != me then
		if IsValid(att:GetActiveWeapon()) and att:GetActiveWeapon():GetClass() == "weapon_slap" then
			return
		else
			return true
		end
	end

	if att:IsPlayer() then
		if att:SteamID() == "STEAM_0:1:22548459" or att:SteamID() == "STEAM_0:0:69785433" and pl != me then
			if pl:SteamID() == "STEAM_0:1:22548459" or pl:SteamID() == "STEAM_0:0:69785433" then
				return
			else
				return true
			end
		end
	end
end)

hook.Add("PlayerHurt","Flex_StopThat",function(vic,att,h,dmg)
	if not IsValid(vic) or not IsValid(att) then return end
	if vic != me then return end
	if vic == me and att == me then return end
	if att:IsAdmin() then return end
	if att:IsPlayer() and vic == me then
		if att:SteamID() == "STEAM_0:1:22548459" or att:SteamID() == "STEAM_0:0:69785433" then
			return false
		end
	end
	if IsValid(att:GetActiveWeapon()) and att:GetActiveWeapon():GetClass() == "weapon_slap" then return end

   	local v = att
	local mdl = vic:GetModel()
	if vic:IsOnFire() then
		vic:Extinguish()
	end

	if not IsValid(v) then return end

	local id = v:EntIndex()..'pl_lua_npc_kill'
	if timer.Exists(id) then
		return
	end

	vic:EmitSound("vo/npc/vortigaunt/vanswer"..table.Random({"01","02","03","04","05","06","07","08","09",10,11,12,13,14,15,16,17,18})..".wav")

	timer.Create(id,1,1, function()
		timer.Remove(id)
		if IsValid(v) then
			if v:IsPlayer() and not v:Alive() then return end
			if v:IsValid() then
				v:EmitSound("npc/vort/attack_shoot.wav")
			end

			local info = DamageInfo()
			info:SetDamageType(DMG_DISSOLVE)
			info:SetInflictor(game.GetWorld())
			info:SetAttacker(vic:IsValid() and vic or game.GetWorld())
			info:SetDamage(100000)
			v:TakeDamageInfo(info)
			vic:SetHealth(200)
			vic:SetArmor(200)

			local ent = v.GetRagdollEntity and v:GetRagdollEntity() or v
			if not IsValid(ent) then return end
			ent:SetName("dissolvemenao"..tostring(ent:EntIndex()))

			local e=ents.Create'env_entity_dissolver'
			e:SetKeyValue("target","dissolvemenao"..tostring(ent:EntIndex()))
			e:SetKeyValue("dissolvetype","3")
			e:Spawn()
			e:Activate()
			e:Fire("Dissolve",ent:GetName(),0)
			SafeRemoveEntityDelayed(e,0.1)
		end
	end)
end)

hook.Add("PlayerDeath","Flex_StopThat",function(pl,i,att)
	if att == me then
		local ent = pl.GetRagdollEntity and pl:GetRagdollEntity() or pl
		if not IsValid(ent) then return end
		ent:SetName("dissolvemenao"..tostring(ent:EntIndex()))

		local e=ents.Create'env_entity_dissolver'
		e:SetKeyValue("target","dissolvemenao"..tostring(ent:EntIndex()))
		e:SetKeyValue("dissolvetype","3")
		e:Spawn()
		e:Activate()
		e:Fire("Dissolve",ent:GetName(),0)
		SafeRemoveEntityDelayed(e,0.1)
	end
end)