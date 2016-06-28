AddCSLuaFile()

easylua.StartWeapon("flex_spellcaster")

SWEP.PrintName = "Spellcaster"
SWEP.Purpose   = "Cast spells"
SWEP.Author    = "Flex"
SWEP.Category  = "Flex's Weapons"

SWEP.Slot   = 1
SWEP.SlotPo = 4

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.ViewModel  = "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands   = true

SWEP.ReloadTime = CurTime()

SWEP.Primary.ClipSize    = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic   = true
SWEP.Primary.Ammo        = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

SWEP.Sounds = {}
SWEP.Sounds.Throw = Sound("misc/halloween/spell_fireball_cast.wav")
SWEP.Sounds.Heal  = Sound("misc/halloween/spell_overheal.wav")

if CLIENT then
	function SWEP:DrawWorldModel()
		local sonr = self:GetOwner()

		if not IsValid(sonr) then
			self:DrawModel()
			return
		else
			self:DrawShadow(false)
		end
	end

	function SWEP:DrawWeaponSelection(x,y,w,h,a)

		// Borders
		y = y + 10
		x = x + 10
		w = w - 20

		draw.DrawText("z","CreditsLogo",x+w/2,y,Color(255,220,0,255),TEXT_ALIGN_CENTER)

		// Draw weapon info box
		self:PrintWeaponInfo(x + w + 20, y + h * 0.95, a)
	end
end

function SWEP:Initialize()
	self:SetHoldType("melee")
end

function SWEP:OnDrop()
	SafeRemoveEntity(self)
end

function SWEP:PrimaryAttack()
	local owner = self.Owner
	self:SetNextPrimaryFire(CurTime()+0.5)
	owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(self.Sounds.Throw)

	local tr = util.TraceHull({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos()+(owner:GetAimVector()*2500),
		filter = owner,
		mins = Vector(-4,-4,-4),
		maxs = Vector(4,4,4),
		mask = MASK_SHOT_HULL
	})
	local ent = tr.Entity

	if SERVER then
		if IsValid(ent) then
			local dmg = DamageInfo()
			dmg:SetAttacker(owner)
			dmg:SetInflictor(self)
			dmg:SetDamage(10)
			dmg:SetDamageType(DMG_ALWAYSGIB)
			dmg:SetDamageForce(owner:GetAimVector()*(175*10))
			dmg:SetDamagePosition(tr.HitPos)

			ent:TakeDamageInfo(dmg)
		end
	end
end

function SWEP:SecondaryAttack()
	local owner = self.Owner
	self:SetNextSecondaryFire(CurTime()+0.5)
	owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound(self.Sounds.Heal)

	local tr = util.TraceHull({
		start = owner:GetShootPos(),
		endpos = owner:GetShootPos()+(owner:GetAimVector()*2500),
		filter = owner,
		mins = Vector(-4,-4,-4),
		maxs = Vector(4,4,4),
		mask = MASK_SHOT_HULL
	})
	local ent = tr.Entity
	if SERVER then
		if IsValid(ent) then
			ent:SetHealth(math.Clamp(ent:Health()+20,0,100))
		end
	end
end

function SWEP:Reload()
	if CurTime() > self.ReloadTime then
		self.ReloadTime = CurTime()+10
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:EmitSound(self.Sounds.Heal)
		self.Owner:SetHealth(100)
	end
end

easylua.EndWeapon(true,true)
