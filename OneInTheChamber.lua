if SERVER then
    local pos1 = Vector(-4224.96875, 784.24627685547, -15791.96875)
    local pos2 = Vector(-145.23863220215, 5311.6811523438, -13600.03125)

    hook.Add("PlayerDeath","OneInTheChamber",function(vic,inf,att)
        att:GiveAmmo(1,"9mmRound",true)
        timer.Simple(0.1,function()
            if att:GetActiveWeapon():GetClass() == "oitc_gun" then
                att:GetActiveWeapon():Reload()
            end
        end)
    end)
    hook.Add("PlayerSpawn","OneInTheChamber",function(ply)
        ply:StripWeapons()
        timer.Simple(0.1,function()
            ply:SetPos(Vector(math.random(pos1.x,pos2.x),math.random(pos1.y,pos2.y),math.random(pos1.z,pos2.z)))
            ply:Give("oitc_gun")
            ply:Give("oitc_knife")
        end)
    end)
end

if CLIENT then

end

----WEAPONS----
--Gun--
local oitc_gun = {Primary={},Secondary={}}

oitc_gun.Base      = "weapon_flex_base"
oitc_gun.PrintName = "Desert Eagle"
oitc_gun.Author    = "Flex"
oitc_gun.Category  = "Minigames"

oitc_gun.Slot    = 1
oitc_gun.SlotPos = 1

oitc_gun.HoldType = "revolver"

oitc_gun.Spawnable = false
oitc_gun.AdminOnly = false

oitc_gun.ViewModel  = "models/weapons/cstrike/c_pist_deagle.mdl"
oitc_gun.WorldModel = "models/weapons/w_pist_deagle.mdl"
oitc_gun.UseHands   = true

oitc_gun.Primary.Sound   = Sound("Weapon_Deagle.Single")
oitc_gun.Primary.Recoil  = 0.2
oitc_gun.Primary.Damage  = 73
oitc_gun.Primary.Cone    = 0.01
oitc_gun.Primary.Delay   = 0.25
oitc_gun.Primary.Bullets = 1

oitc_gun.Primary.ClipSize    = 1
oitc_gun.Primary.DefaultClip = 1
oitc_gun.Primary.Automatic   = false
oitc_gun.Primary.Ammo        = "9mmRound"

oitc_gun.Secondary.ClipSize    = -1
oitc_gun.Secondary.DefaultClip = -1
oitc_gun.Secondary.Automatic   = false
oitc_gun.Secondary.Ammo        = "none"

oitc_gun.SelectionFont   = "CSSelectIcons"
oitc_gun.SelectionLetter = "f"

oitc_gun.IronSightsPos = Vector(-6.378, 0, 2.125)
oitc_gun.IronSightsAng = Vector(0, 0, 0)

weapons.Register(oitc_gun,"oitc_gun")

--Knife--
local oitc_knife = {Primary={},Secondary={}}

oitc_knife.Base      = "weapon_flex_base"
oitc_knife.PrintName = "Knife"
oitc_knife.Author    = "Flex"
oitc_knife.Category  = "Minigames"

oitc_knife.Slot    = 0
oitc_knife.SlotPos = 1

oitc_knife.HoldType = "knife"

oitc_knife.Spawnable = false
oitc_knife.AdminOnly = false

oitc_knife.ViewModel  = "models/weapons/cstrike/c_knife_t.mdl"
oitc_knife.WorldModel = "models/weapons/w_knife_t.mdl"
oitc_knife.UseHands   = true

oitc_knife.Primary.Sound    = Sound("Weapon_Knife.Slash")
oitc_knife.Primary.SoundHit = Sound("Weapon_Knife.Hit")
oitc_knife.Primary.Recoil   = 0
oitc_knife.Primary.Damage   = 50
oitc_knife.Primary.Cone     = 0
oitc_knife.Primary.Delay    = 0.8
oitc_knife.Primary.Bullets  = 1

oitc_knife.Primary.ClipSize    = -1
oitc_knife.Primary.DefaultClip = -1
oitc_knife.Primary.Automatic   = true
oitc_knife.Primary.Ammo        = "none"

oitc_knife.Secondary.ClipSize    = -1
oitc_knife.Secondary.DefaultClip = -1
oitc_knife.Secondary.Automatic   = false
oitc_knife.Secondary.Ammo        = "none"

oitc_knife.SelectionFont   = "CSSelectIcons"
oitc_knife.SelectionLetter = "j"

function oitc_knife:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:ViewPunch(Angle(5,5,0))
	local tracedata = {}
	tracedata.start = self.Owner:EyePos()
	tracedata.endpos = self.Owner:EyePos()+(self.Owner:GetAimVector()*75)
	tracedata.filter = {self.Owner}
	local trace = util.TraceLine(tracedata) --I should be using hull traces here.
	if trace.Hit then
		self:SendWeaponAnim(ACT_VM_IDLE)
		local vm = self.Owner:GetViewModel()
		vm:SetSequence(vm:LookupSequence("midslash" .. math.random(1, 2)))
		self:EmitSound(self.Primary.SoundHit)
		if not trace.Entity or not trace.Entity:IsValid() then return end
		local dmg = DamageInfo()
		dmg:SetDamage(self.Primary.Damage)
		dmg:SetDamageType(DMG_CLUB)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamageForce(self.Owner:GetAimVector()*10)

		if not trace.Entity.TakeDamageInfo then return end
		trace.Entity:TakeDamageInfo(dmg)
	else
		self:SendWeaponAnim(ACT_VM_IDLE)
		local vm = self.Owner:GetViewModel()
		vm:SetSequence(vm:LookupSequence("midslash" .. math.random(1, 2)))
		self:EmitSound(self.Primary.Sound)
	end
end


weapons.Register(oitc_knife,"oitc_knife")
