AddCSLuaFile()

easylua.StartWeapon("weapon_physlauncher_admin") --testing

SWEP.PrintName			= "Stuff Launcher (No Removal)"
SWEP.Author				= "Flex"
SWEP.Purpose 			= "Based on weapon from <color=0,128,255>SMOD Redux</color>"
SWEP.Contact 			= ""
SWEP.Warnings			= "<color=200,200,100> \xe2\x97\x8f I (Flex) am</color> <color=200,100,100>NOT</color> <color=200,200,100>responsible for crashes caused by this weapon</color>\n\n<color=200,200,100> \xe2\x97\x8f If crashes commonly occur, uninstall this addon</color>"
SWEP.Controls 			= "<color=100,200,100> \xe2\x97\x8f Left Click:</color> Fire object\n\n<color=100,200,100> \xe2\x97\x8f Right Click:</color> Set object to what you're looking at\n\n<color=200,100,100> \xe2\x97\x8f Use + Right Click:</color> Ignite mode toggle <color=100,200,100>(Custom Feature)</color>\n\n<color=200,100,100> \xe2\x97\x8f Use + Left Click:</color> Fire 10 objects at once <color=100,200,100>(Custom Feature)</color>"
SWEP.Category			= "Flex's Weapons"

SWEP.Spawnable			= true
SWEP.AdminOnly 			= true

SWEP.Slot 				= 5
SWEP.SlotPos 			= 6

SWEP.Holdtype 			= "rpg"

SWEP.ViewModel 			= "models/weapons/c_rpg.mdl"
SWEP.WorldModel 		= "models/weapons/w_rocket_launcher.mdl"
SWEP.UseHands 			= true

SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip= -1
SWEP.Primary.Automatic	= true
SWEP.Primary.Ammo		= "none"
SWEP.Primary.Delay 		= 0.2

SWEP.Secondary.ClipSize	= -1
SWEP.Secondary.DefaultClip= -1
SWEP.Secondary.Automatic= false
SWEP.Secondary.Ammo		= "none"

SWEP.stuffClass 		= "prop_physics"
SWEP.stuffModel			= "models/props_junk/watermelon01.mdl"
SWEP.stuffIgnite 		= false

SWEP.Sounds = {}
SWEP.Sounds.Fire = Sound("Weapon_Crossbow.Single")
SWEP.Sounds.Grab = Sound("Weapon_PhysCannon.Pickup")
SWEP.Sounds.Toggle = Sound("Weapon_SMG1.Empty")

function SWEP:Initialize()
	self:SetHoldType(self.Holdtype)
end

function SWEP:PrintWeaponInfo(x, y, alpha)

	if (self.DrawWeaponInfoBox == false) then return end

	if (self.InfoMarkup == nil) then
		local str
		local title_color = "<color=200,200,200>"
		local text_color = "<color=255,255,255>"

		str = "<font=HudSelectionText>"
		if (self.Author ~= "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if (self.Contact ~= "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if (self.Purpose ~= "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end
		if (self.Instructions~= "") then str = str .. title_color .. "Instructions:</color>\n" .. text_color .. self.Instructions .. "</color>\n\n" end
		if (self.Warnings~= "") then str = str .. title_color .. "Notes/Warnings:</color>\n" .. text_color .. self.Warnings .. "</color>\n\n" end
		if (self.Controls ~= "") then str = str .. title_color .. "Controls:</color>\n" .. text_color .. self.Controls .. "</color>\n" end
		str = str .. "</font>"

		self.InfoMarkup = markup.Parse(str, 250)
	end

	alpha = 180

	surface.SetDrawColor(0, 0, 0, alpha)
	surface.SetTexture(self.SpeechBubbleLid)

	surface.DrawTexturedRect(x, y - 69.5, 128, 64)
	draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, Color(0, 0, 0, alpha))

	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end

function SWEP:DrawWeaponSelection(x, y, w, h, a)
	-- Borders
	y = y+0
	x = x+40

	draw.SimpleText("i","creditslogo",x+w/2-40,y+20,Color(0,128,255,a),TEXT_ALIGN_CENTER)

	surface.SetDrawColor(Color(255,255,255,a))
	surface.SetMaterial(Material("spawnicons/models/props_junk/watermelon01.png"))
	surface.DrawTexturedRect(x+w/2, y+80, 64, 64)

	surface.SetMaterial(Material("icon16/shield.png"))
	surface.DrawTexturedRect(x, y+100, 32, 32)

	-- Draw weapon info box
	self:PrintWeaponInfo(x+w+20, y+h*.95, a)
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

	if SERVER then

		if not self.Owner:KeyDown(IN_USE) then
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Weapon:EmitSound(self.Sounds.Fire)

			local stuff = ents.Create(self.stuffClass and self.stuffClass or "prop_physics")
			stuff:SetModel(self.stuffModel)
			stuff:SetOwner(self.Owner)
			stuff:SetAngles(self.Owner:EyeAngles())

			local pos = self.Owner:GetShootPos()
			pos = pos + self.Owner:GetForward() * 5
			pos = pos + self.Owner:GetRight() * 9
			pos = pos + self.Owner:GetUp() * -5

			stuff:SetPos(pos)

			stuff:SetOwner(self.Owner)
			stuff:SetPhysicsAttacker(self.Owner)
			for key,val in pairs(self.stuffKeys) do
				stuff:SetKeyValue(tostring(key),val)
			end
			stuff:Spawn()
			stuff:Activate()
			stuff:SetSolid(2)

			local phys = stuff:GetPhysicsObject()
			phys:SetVelocity(self.Owner:GetAimVector() * 1500)
			phys:AddAngleVelocity(Vector(0, 500, 0))

			if self.stuffIgnite == true and IsValid(stuff) then
				stuff:Ignite(math.huge,10)
			end
		end

		if self.Owner:KeyDown(IN_USE) then
			for i = 1,10 do
				timer.Create("stuffX10",0.075,i,function()
					self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
					self.Weapon:EmitSound(self.Sounds.Fire)

					local stuff = ents.Create(self.stuffClass and self.stuffClass or "prop_physics")
					stuff:SetModel(self.stuffModel)
					stuff:SetOwner(self.Owner)
					stuff:SetAngles(self.Owner:EyeAngles())

					local pos = self.Owner:GetShootPos()
					pos = pos + self.Owner:GetForward() * 5
					pos = pos + self.Owner:GetRight() * 9
					pos = pos + self.Owner:GetUp() * -5

					stuff:SetPos(pos)

					stuff:SetOwner(self.Owner)
					stuff:SetPhysicsAttacker(self.Owner)
					for key,val in pairs(self.stuffKeys) do
						stuff:SetKeyValue(tostring(key),val)
					end
					stuff:Spawn()
					stuff:Activate()
					stuff:SetSolid(2)

					local phys = stuff:GetPhysicsObject()
					phys:SetVelocity(self.Owner:GetAimVector() * 1500)
					phys:AddAngleVelocity(Vector(0, 500, 0))

					if self.stuffIgnite == true and IsValid(stuff) then
						stuff:Ignite(math.huge,10)
					end
				end)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if self.Owner:KeyDown(IN_USE) then
		if self.stuffIgnite == true then
			self.stuffIgnite = false
			self.Owner:PrintMessage(3,"Ignite mode: OFF.")
		elseif self.stuffIgnite == false then
			self.stuffIgnite = true
			self.Owner:PrintMessage(3,"Ignite mode: ON.")
		end
		self.Weapon:EmitSound("weapons/pistol/pistol_empty.wav")
		self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
	end

	local trace = util.QuickTrace(self.Owner:EyePos(), self.Owner:GetAimVector() * 10000, {self.Owner, self.Owner:GetVehicle()})
	if !trace and !trace.Entity then return end
	if trace.Entity:IsPlayer() then return end
	if IsValid(trace.Entity) then
		if !self.Owner:KeyDown(IN_USE) then
			self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
			self.Weapon:EmitSound("weapons/physcannon/physcannon_charge.wav")
			self.stuffClass = trace.Entity.ClassName and trace.Entity.ClassName or "prop_physics"
			self.stuffModel = trace.Entity:GetModel()

			local ent = trace.Entity
			if not IsValid(ent) then return end
			ent:SetName("dissolveprop_"..tostring(ent:EntIndex()))

			local e=ents.Create'env_entity_dissolver'
			e:SetKeyValue("target","dissolveprop_"..tostring(ent:EntIndex()))
			e:SetKeyValue("dissolvetype","1")
			e:Spawn()
			e:Activate()
			e:Fire("Dissolve",ent:GetName(),0)
			SafeRemoveEntityDelayed(e,0.1)

			timer.Simple(0,function()
				self.Owner:PrintMessage(3,"Stuff Launcher class set to "..self.stuffClass.." with model: "..self.stuffModel)
			end)
		end
	end
end

easylua.EndWeapon(true,true) --testing