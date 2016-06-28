easylua.StartEntity("pet_ball")

ENT.PrintName		= "Pet Ball"
ENT.Author			= "Flex"
ENT.Information		= "Your own pet ball!"
ENT.Category		= "Pets"

ENT.Spawnable = true

local faces = {"^u^","UvU","^v^","\xe2\x97\x8fu\xe2\x97\x8f","\xe2\x97\x8fv\xe2\x97\x8f","OuO","OvO"}

if CLIENT then
	surface.CreateFont("BallFont",{
		font = "Tahoma",
		size = 64,
		weight = 500,
	})

	function ENT:Draw()
		self:DrawModel()
		local pos = self:GetPos()
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(),90)
		ang:RotateAroundAxis(ang:Forward(),180)
		ang:RotateAroundAxis(ang:Up(),-90)
		pos = pos+ang:Up()*7
		pos = pos+ang:Right()*-3.5

		cam.Start3D2D(pos,ang,0.1)
			draw.SimpleTextOutlined(self.face,"BallFont",0,0,self.face_col,TEXT_ALIGN_CENTER,nil,2,Color(0,0,0))
		cam.End3D2D()
	end
end

function ENT:Initialize()
	self:SetModel("models/holograms/hq_sphere.mdl")
	self:SetColor(ColorRand())
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(3)
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		self.physobj = phys
	end

	self.face = table.Random(faces)
	self.face_col = Color(255,255,255)
end

function ENT:PhysicsCollide( data, physobj )
	if IsValid(self:GetOwner()) then
		if self:GetPos():Distance(self:GetOwner():GetPos()) > 100 then
			physobj:SetVelocity(physobj:GetVelocity()+(( self:GetOwner():GetPos() - self:GetPos() ):GetNormal()*100)+Vector(0,0,200))
			self:EmitSound("garrysmod/balloon_pop_cute.wav")
		end
	else
		self:EmitSound("garrysmod/balloon_pop_cute.wav")
	end
end

function ENT:Think()
	if IsValid(self:GetOwner()) and (self:GetPos():Distance(self:GetOwner():GetPos()) < 100) then
		self:SetAngles((self:GetOwner():GetPos()-self:GetPos()):Angle()-Angle(30,0,0))
	end

	if IsValid(self:GetOwner()) and self:GetPos():Distance(self:GetOwner():GetPos()) > 2500 then
		self:SetPos(self:GetOwner():GetPos()+Vector(0,0,100))
	end
end

function ENT:OnTakeDamage(dmg)
	self.face = string.gsub(self.face,"v","\xca\x8c")
	self.face = string.gsub(self.face,"u","n")
	self.face_col = Color(200,100,100)

	timer.Simple(5,function()
		self.face = string.gsub(self.face,"\xca\x8c","v")
		self.face = string.gsub(self.face,"n","u")
		self.face_col = Color(255,255,255)
	end)
end

function ENT:CanProperty()
	return false
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
		return ent
	end
end

easylua.EndEntity()

easylua.StartEntity("pet_melon")

ENT.PrintName		= "Pet Melon"
ENT.Author			= "Flex"
ENT.Information		= "Your own pet melon!"
ENT.Category		= "Pets"

ENT.Spawnable = true

local faces = {"^u^","UvU","^-^","^v^","\xe2\x97\x8fu\xe2\x97\x8f","\xe2\x97\x8fv\xe2\x97\x8f","OuO","OvO"}

ENT.face = table.Random(faces)

if CLIENT then
	surface.CreateFont("BallFont",{
		font = "Tahoma",
		size = 64,
		weight = 500,
	})

	function ENT:Draw()
		self:DrawModel()
		local pos = self:GetPos()
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(),90)
		ang:RotateAroundAxis(ang:Forward(),180)
		ang:RotateAroundAxis(ang:Up(),-90)
		pos = pos+ang:Up()*8
		pos = pos+ang:Right()*-3.5

		cam.Start3D2D(pos,ang,0.1)
			draw.SimpleTextOutlined(self.face,"BallFont",0,0,self.face_col,TEXT_ALIGN_CENTER,nil,2,Color(0,0,0))
		cam.End3D2D()
	end
end

function ENT:Initialize()
	self:SetModel("models/props_junk/watermelon01.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(3)
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		self.physobj = phys
	end

	self.face = table.Random(faces)
	self.face_col = Color(255,255,255)
end

function ENT:PhysicsCollide( data, physobj )
	if IsValid(self:GetOwner()) then
		if self:GetPos():Distance(self:GetOwner():GetPos()) > 100 then
			physobj:SetVelocity(physobj:GetVelocity()+(( self:GetOwner():GetPos() - self:GetPos() ):GetNormal()*100)+Vector(0,0,200))
			self:EmitSound("garrysmod/balloon_pop_cute.wav")
		end
	else
		self:EmitSound("garrysmod/balloon_pop_cute.wav")
	end
end

function ENT:Think()
	if IsValid(self:GetOwner()) and (self:GetPos():Distance(self:GetOwner():GetPos()) < 100) then
		self:SetAngles((self:GetOwner():GetPos()-self:GetPos()):Angle()-Angle(30,0,0))
	end

	if IsValid(self:GetOwner()) and self:GetPos():Distance(self:GetOwner():GetPos()) > 2500 then
		self:SetPos(self:GetOwner():GetPos()+Vector(0,0,100))
	end
end

function ENT:CanProperty()
	return false
end

function ENT:OnTakeDamage(dmg)
	self.face = string.gsub(self.face,"v","\xca\x8c")
	self.face = string.gsub(self.face,"u","n")
	self.face_col = Color(200,100,100)

	timer.Simple(5,function()
		self.face = string.gsub(self.face,"\xca\x8c","v")
		self.face = string.gsub(self.face,"n","u")
		self.face_col = Color(255,255,255)
	end)
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
		return ent
	end
end

easylua.EndEntity()

easylua.StartEntity("pet_cube")

ENT.PrintName		= "Pet Cube"
ENT.Author			= "Flex"
ENT.Information		= "Your own pet cube!"
ENT.Category		= "Pets"

ENT.Spawnable = true

local faces = {"^u^","UvU","^-^","^v^","\xe2\x97\x8fu\xe2\x97\x8f","\xe2\x97\x8fv\xe2\x97\x8f","OuO","OvO"}

ENT.face = table.Random(faces)

if CLIENT then
	surface.CreateFont("BallFont",{
		font = "Tahoma",
		size = 64,
		weight = 500,
	})

	function ENT:Draw()
		self:DrawModel()
		local pos = self:GetPos()
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(),90)
		ang:RotateAroundAxis(ang:Forward(),180)
		ang:RotateAroundAxis(ang:Up(),-90)
		pos = pos+ang:Up()*8
		pos = pos+ang:Right()*-3.5

		cam.Start3D2D(pos,ang,0.1)
			draw.SimpleTextOutlined(self.face,"BallFont",0,0,self.face_col,TEXT_ALIGN_CENTER,nil,2,Color(0,0,0))
		cam.End3D2D()
	end
end

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(3)
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		self.physobj = phys
	end

	self.face = table.Random(faces)
	self.face_col = Color(255,255,255)
end

function ENT:PhysicsCollide( data, physobj )
	if IsValid(self:GetOwner()) then
		if self:GetPos():Distance(self:GetOwner():GetPos()) > 100 then
			physobj:SetVelocity(physobj:GetVelocity()+(( self:GetOwner():GetPos() - self:GetPos() ):GetNormal()*100)+Vector(0,0,200))
			self:EmitSound("garrysmod/balloon_pop_cute.wav")
		end
	else
		self:EmitSound("garrysmod/balloon_pop_cute.wav")
	end
end

function ENT:Think()
	if IsValid(self:GetOwner()) and (self:GetPos():Distance(self:GetOwner():GetPos()) < 100) then
		self:SetAngles((self:GetOwner():GetPos()-self:GetPos()):Angle()-Angle(30,0,0))
	end

	if IsValid(self:GetOwner()) and self:GetPos():Distance(self:GetOwner():GetPos()) > 2500 then
		self:SetPos(self:GetOwner():GetPos()+Vector(0,0,100))
	end
end

function ENT:CanProperty()
	return false
end

function ENT:OnTakeDamage(dmg)
	self.face = string.gsub(self.face,"v","\xca\x8c")
	self.face = string.gsub(self.face,"u","n")
	self.face_col = Color(200,100,100)

	timer.Simple(5,function()
		self.face = string.gsub(self.face,"\xca\x8c","v")
		self.face = string.gsub(self.face,"n","u")
		self.face_col = Color(255,255,255)
	end)
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
		return ent
	end
end

easylua.EndEntity()
