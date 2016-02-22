AddCSLuaFile()

easylua.StartWeapon("flex_sniper_grenade")

SWEP.Base 					= "weapon_mad_base_sniper"

SWEP.PrintName 				= "Grenade Sniper"
SWEP.Purpose 				= "Spice up your killing with explosions"
SWEP.Author 				= "Flex"
SWEP.Category 				= "Flex's Weapons"

SWEP.Slot 					= 1
SWEP.SlotPos 				= 1

SWEP.HoldType 				= "ar2"

SWEP.Spawnable 				= true

SWEP.AdminOnly = true

SWEP.ViewModel 				= "models/weapons/cstrike/c_snip_awp.mdl"
SWEP.WorldModel				= "models/weapons/w_snip_awp.mdl"
SWEP.UseHands 				= true

SWEP.Primary.Sound 			= Sound("Weapon_AWP.Single")
SWEP.Primary.Delay 			= 0
SWEP.Primary.Damage 		= 10
SWEP.Primary.Recoil 		= 0

SWEP.Primary.ClipSize 		= 1
SWEP.Primary.DefaultClip 	= 21
SWEP.Primary.Automatic 		= false
SWEP.Primary.Ammo			= "SMG1_Grenade"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:PrimaryAttack()
	if CLIENT then return end
	if self:Clip1() > 0 then
		self.Weapon:EmitSound(self.Primary.Sound)
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

		local grenade = ents.Create("grenade_ar2")
		grenade:SetOwner(self.Owner)
		grenade:SetAngles(self.Owner:EyeAngles())

		local pos = self.Owner:GetShootPos()
		pos = pos + self.Owner:GetForward() * 5
		pos = pos + self.Owner:GetRight() * 9
		pos = pos + self.Owner:GetUp() * -5

		grenade:SetPos(pos)

		grenade:SetOwner(self.Owner)
		grenade:SetPhysicsAttacker(self.Owner)
		grenade:Spawn()
		grenade:Activate()
		grenade:SetVelocity(self.Owner:GetAimVector() * 10000)

		self:TakePrimaryAmmo(1)
		timer.Simple(1,function()
			self:Reload()
		end)
	end
end

easylua.EndWeapon(true,true)