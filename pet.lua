easylua.StartEntity("flex_pet")

ENT.PrintName		= "Pet"
ENT.Author			= "Flex"
ENT.Category		= "Other"

ENT.Spawnable = true
ENT.Editable = true

local eyes   = {"^","U","\xe2\x97\x8f","O"}
local mouths = {"u","v","-","o"}
local models = {"models/holograms/hq_sphere.mdl","models/props_junk/watermelon01.mdl","models/hunter/blocks/cube025x025x025.mdl"}

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"PetEyes")
	self:NetworkVar("String",1,"PetMouth")
	self:NetworkVar("Vector",0,"PetColor")
end

function ENT:Initialize()
	if SERVER then
		self:SetModel(table.Random(models))
		self:SetColor(ColorRand())
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(3)

		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
			self:AddToMotionController(phys)
			self:StartMotionController()
		end

		self:SetPetEyes(table.Random(eyes))
		self:SetPetMouth(table.Random(mouths))
		--self:SetPetColor(self:GetColor():ToVector())
	end
end

if CLIENT then
	surface.CreateFont("PetFont",{
		font = "Tahoma",
		size = 64,
		weight = 500,
	})

	function ENT:Draw()
		local e_ang = self:GetAngles()
		if IsValid(self:GetOwner()) and (self:GetPos():Distance(self:GetOwner():GetPos()) < 100) and not self:GetOwner():InVehicle() then
			e_ang = (self:GetOwner():EyePos()-self:GetPos()):Angle()
		else
			e_ang = self:GetAngles()
		end
		local ent = ClientsideModel(self:GetModel())
		ent:SetMaterial(self:GetMaterial())
		ent:SetPos(self:GetPos())
		ent:SetAngles(e_ang)
		ent:DrawModel()
		local pos = ent:GetPos()
		local ang = ent:GetAngles()
		local face = "\xe2\x97\x8fu\xe2\x97\x8f"
		ang:RotateAroundAxis(ang:Right(),90)
		ang:RotateAroundAxis(ang:Forward(),180)
		ang:RotateAroundAxis(ang:Up(),-90)
		pos = pos+ang:Up()*8
		pos = pos+ang:Right()*-3.5

		if self:GetOwner():SteamID() == "STEAM_0:0:58178275" then
			face = "\xe2\x97\x8fu\xe2\x97\x8f"

			local hat = ClientsideModel("models/player/items/spy/hat_third_nr.mdl")
			local pos,ang = ent:GetPos(),ent:GetAngles()
			pos:Add(ang:Forward()*-3)
			pos:Add(ang:Right()*0)
			pos:Add(ang:Up()*0.1)
			hat:SetPos(pos)
			hat:SetAngles(ang)
			local mat = Matrix()
			mat:Scale(Vector(1.5,1.5,1.5))
			hat:EnableMatrix("RenderMultiply",mat)
			render.SetColorModulation(0,150/255,130/255)
			hat:DrawModel()
			hat:Remove()
			render.SetColorModulation(1,1,1)

		else
			face = (self:GetPetEyes()..self:GetPetMouth()..self:GetPetEyes()) or "\xe2\x97\x8fu\xe2\x97\x8f"
		end

		cam.Start3D2D(pos,ang,0.1)
			draw.SimpleTextOutlined(face,"PetFont",0,0,Color(255,255,255),TEXT_ALIGN_CENTER,nil,2,Color(0,0,0))
		cam.End3D2D()

		ent:Remove()
	end
end

function ENT:PhysicsCollide( data, phys )
	if IsValid(self:GetOwner()) then
		if self:GetPos():Distance(self:GetOwner():GetPos()) > 100 then
			phys:SetVelocity(Vector(0,0,300))
			self:EmitSound("garrysmod/balloon_pop_cute.wav")
		end
	else
		self:EmitSound("garrysmod/balloon_pop_cute.wav")
	end
end

function ENT:CanProperty(pl,prop)
	return false
end

local bounce = 400
function ENT:PhysicsSimulate(phys,delta)
	if not self:GetOwner():InVehicle() then
		phys:ApplyForceCenter((self:GetOwner():GetPos()-self:GetPos())/10)
	end
	bounce=bounce/1.1
	if math.Round(bounce) == 1 then phys:ApplyForceCenter(Vector(0,0,10)) bounce = 400 end
end

if SERVER then
	function ENT:SpawnFunction(ply,tr)
		if not tr.Hit then return end
		local pos=tr.HitPos+tr.HitNormal*10
		local ent=ents.Create(ClassName)
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
		ent:SetOwner(ply)
		if ent:GetOwner():SteamID() == "STEAM_0:0:58178275" then
			ent:SetModel("models/props_junk/watermelon01.mdl")
			ent:SetColor(Color(255,255,255))
		end
		return ent
	end
end

function ENT:Think()
	if CLIENT then return end

	if not IsValid(self:GetOwner()) then
		self:Remove()
		print("Pet removed due to non-existant owner!")
	end

	if self:GetPos():Distance(self:GetOwner():GetPos()) > 2500 then
		self:SetPos(self:GetOwner():GetPos())
	end

	if self:GetOwner():InVehicle() and self:GetParent() != self:GetOwner() then
		local pos,ang = self:GetOwner():GetPos(),self:GetOwner():GetAngles()
		pos:Add(ang:Right()*20)
		self:SetPos(pos)
		self:SetParent(self:GetOwner())
	else
		if not IsValid(self:GetParent()) then return end
		self:SetParent(NULL)
	end
end

easylua.EndEntity()