AddCSLuaFile()

easylua.StartWeapon("flex_laserrifle")

SWEP.PrintName 				= "Laser Rifle"
SWEP.Purpose 				= "Pew Pew Pew"
SWEP.Author 				= "Flex"
SWEP.Category 				= "Flex's Weapons"

SWEP.Slot 					= 1
SWEP.SlotPos 				= 1

SWEP.HoldType 				= "ar2"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= true

SWEP.ViewModel 				= "models/weapons/c_smg1.mdl"
SWEP.WorldModel				= "models/weapons/w_smg1.mdl"
SWEP.UseHands 				= true

SWEP.Primary.Sound 			= Sound("weapons/airboat/airboat_gun_energy1.wav")
SWEP.Primary.Delay 			= 0
SWEP.Primary.Damage 		= 10
SWEP.Primary.Recoil 		= 0

SWEP.Primary.ClipSize 		= -1
SWEP.Primary.DefaultClip 	= -1
SWEP.Primary.Automatic 		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-6.378, 0, 1.024)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunArmOffset 		= Vector (9.071, 0, 1.6418)
SWEP.RunArmAngle 			= Vector (-12.9765, 26.8708, 0)

local beam = Material("sprites/physbeama")

function SWEP:Initialize()
	self:SetHoldType("smg")
end

if CLIENT then
	function SWEP:Setup(ply)
		if ply.GetViewModel and ply:GetViewModel():IsValid() then
			local attachmentIndex = ply:GetViewModel():LookupAttachment("muzzle")
			if attachmentIndex == 0 then attachmentIndex = ply:GetViewModel():LookupAttachment("1") end
			if LocalPlayer():GetAttachment(attachmentIndex) then
				self.VM = ply:GetViewModel()
				self.Attach = attachmentIndex
			end
		end
		if ply:IsValid() then
			local attachmentIndex = ply:LookupAttachment("anim_attachment_RH")
			if ply:GetAttachment(attachmentIndex) then
				self.WM = ply
				self.WAttach = attachmentIndex
			end
		end
	end
	function SWEP:Initialize()
		self:Setup(self:GetOwner())
		self:SetHoldType("smg")
	end
	function SWEP:Deploy(ply)
		self:Setup(self:GetOwner())
	end

	function SWEP:ViewModelDrawn()
		if self:GetNWBool("BeamActive") == true and self.VM then
	        //Draw the laser beam.
	        render.SetMaterial( beam )
			render.DrawBeam(self.VM:GetAttachment(self.Attach).Pos, self:GetOwner():GetEyeTrace().HitPos, 2, 0, 12.5, Color(128, 0, 255, 255))
	    end
	end
	function SWEP:DrawWorldModel()
		self.Weapon:DrawModel()
		if self:GetNWBool("BeamActive") == true and self.WM then
	        //Draw the laser beam.
	        render.SetMaterial( beam )
			local posang = self.WM:GetAttachment(self.WAttach)
			if not posang then self.WM = nil ErrorNoHalt("Laserpointer CL: Attachment lost, did they change model or something?\n") return end
			render.DrawBeam(posang.Pos + posang.Ang:Forward()*10 + posang.Ang:Up()*4.4 + posang.Ang:Right(), self:GetOwner():GetEyeTrace().HitPos, 2, 0, 12.5, Color(128, 0, 255, 255))
	    end
	end
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime()+0.5)
	local trace = util.QuickTrace(self.Owner:EyePos(), self.Owner:GetAimVector() * 10000, {self.Owner, self.Owner:GetVehicle()})
	local tr_ent = trace.Entity
	if !trace and !trace.Entity and !trace.Entity:IsPlayer() then
		self:EmitSound("weapons/clipempty_pistol.wav")
		return
	end

	if tr_ent:IsPlayer() then
		if self.Owner:KeyDown(IN_USE) then
			self:EmitSound(self.Primary.Sound,100,20)
			self.Owner:ViewPunch(Angle(-40,0,0))
			self:SetNWBool("BeamActive",true)
			timer.Simple(0.3,function() self:SetNWBool("BeamActive",false) end)
			if SERVER then
				tr_ent:SetHealth(tr_ent:Health()-tr_ent:Health())
				timer.Simple(0.1,function()
					local info = DamageInfo()
					info:SetInflictor(self)
					info:SetAttacker(IsValid(self.Owner) and self.Owner)
					tr_ent:TakeDamageInfo(info)
					if tr_ent:IsPlayer() then
						tr_ent:ConCommand("cl_dmg_mode 3")
					end

					local ent = tr_ent:GetRagdollEntity()
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
						if !tr_ent:IsPlayer() then return end
						tr_ent:ConCommand("cl_dmg_mode 1")
					end)
				end)
			end
		end
		if tr_ent:Health() > 10 then
			if self.Owner:KeyDown(IN_USE) then return end
			if SERVER then
				local info = DamageInfo()
				info:SetInflictor(self)
				info:SetAttacker(IsValid(self.Owner) and self.Owner)
				tr_ent:SetHealth(tr_ent:Health()-5)
				tr_ent:TakeDamageInfo(info)
			end
			self:EmitSound(self.Primary.Sound,100,60)
			self.Owner:ViewPunch(Angle(-10,0,0))
			self:SetNWBool("BeamActive",true)
			timer.Simple(0.3,function() self:SetNWBool("BeamActive",false) end)
		elseif tr_ent:Health() <= 10 then
			if self.Owner:KeyDown(IN_USE) then return end
			self:EmitSound(self.Primary.Sound,100,40)
			self.Owner:ViewPunch(Angle(-20,0,0))
			self:SetNWBool("BeamActive",true)
			timer.Simple(0.3,function() self:SetNWBool("BeamActive",false) end)
			if SERVER then
				tr_ent:SetHealth(tr_ent:Health()-10)
				timer.Simple(0.1,function()
					local info = DamageInfo()
					info:SetInflictor(self)
					info:SetAttacker(IsValid(self.Owner) and self.Owner)
					tr_ent:TakeDamageInfo(info)
					if tr_ent:IsPlayer() then
						tr_ent:ConCommand("cl_dmg_mode 3")
					end

					local ent = tr_ent:GetRagdollEntity()
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
						if !tr_ent:IsPlayer() then return end
						tr_ent:ConCommand("cl_dmg_mode 1")
					end)
				end)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	bIronsights = !self.Weapon:GetDTBool(1)
	self:SetIronsights(bIronsights)
end

function SWEP:SetIronsights(b)

	if (self.Owner) then
		if (b) then
			if (SERVER) then
				self.Owner:SetFOV(65, 0.2)
			end

			if self.AllowIdleAnimation then
				if self.Weapon:GetDTBool(3) and self.Type == 2 then
					self.Weapon:SendWeaponAnim(ACT_VM_IDLE_SILENCED)
				else
					self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
				end

				self.Owner:GetViewModel():SetPlaybackRate(0)
			end

			self.Weapon:EmitSound("/weapons/draw_default.wav")
			self:SetHoldType("rpg")
		else
			if (SERVER) then
				self.Owner:SetFOV(0, 0.2)
			end

			if self.AllowPlaybackRate and self.AllowIdleAnimation then
				self.Owner:GetViewModel():SetPlaybackRate(1)
			end

			self.Weapon:EmitSound("/weapons/draw_default.wav")
			self:SetHoldType(self.HoldType)
		end
	end

	if (self.Weapon) then
		self.Weapon:SetDTBool(1, b)
	end
end

local IRONSIGHT_TIME = 0.2

function SWEP:GetViewModelPosition(pos, ang)

	local bIron = self.Weapon:GetDTBool(1)

	if (bIron ~= self.bLastIron) then
		self.bLastIron = bIron
		self.fIronTime = CurTime()

		if (bIron) then
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end

	end

	local fIronTime = self.fIronTime or 0

	if (!bIron and fIronTime < CurTime() - IRONSIGHT_TIME) then
		return pos, ang
	end

	local Mul = 1.0

	if (fIronTime > CurTime() - IRONSIGHT_TIME) then
		Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)

		if (!bIron) then Mul = 1 - Mul end
	end

	if (self.IronSightsAng) then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(), 	self.IronSightsAng.x * Mul)
		ang:RotateAroundAxis(ang:Up(), 	self.IronSightsAng.y * Mul)
		ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
	end

	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()

	pos = pos + self.IronSightsPos.x * Right * Mul
	pos = pos + self.IronSightsPos.y * Forward * Mul
	pos = pos + self.IronSightsPos.z * Up * Mul

	return pos, ang
end

easylua.EndWeapon(true,true)