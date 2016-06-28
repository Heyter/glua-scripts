local META = FindMetaTable("Player")

function META:Freeze()
    if self.Frozen then return end
    local iceblock = ents.Create("prop_physics")
    iceblock:SetModel("models/hunter/blocks/cube1x2x1.mdl")
    iceblock:SetRenderMode(RENDERMODE_TRANSALPHA)
    iceblock:SetMaterial("models/player/shared/ice_player")
    iceblock:SetColor(Color(0,128,255,128))
    iceblock:SetPos(self:GetPos()+Vector(0,0,50))
    iceblock:SetAngles(self:GetAngles()+Angle(0,0,-90))
    iceblock:Spawn()
    iceblock:Activate()
    iceblock:SetMoveType(0)
    iceblock.frozen_ply = self
    self:EmitSound(Sound("weapons/icicle_freeze_victim_01.wav"))
    self:AddFlags( FL_FROZEN )
    self:PrintMessage(3,"You are now frozen.")
    self.Frozen = true
    hook.Add("PhysgunPickup","iceblock_"..self:EntIndex(),function(ply,ent) if ent == iceblock then return false end end)
end

function META:Unfreeze()
    self:RemoveFlags( FL_FROZEN )
    self:SetMaterial()
    self:PrintMessage(3,"You have been unfrozen.")
    self:EmitSound("physics/glass/glass_largesheet_break1.wav")
    self.Frozen = false
    for _,ent in pairs(ents.FindByClass("prop_physics")) do
        if ent.frozen_ply == self then
            ent:Remove()
        end
    end
    hook.Remove("PhysgunPickup","iceblock_"..self:EntIndex())
end
