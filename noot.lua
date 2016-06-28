easylua.StartEntity("noot")

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Noot"
ENT.Author = "Flex"
ENT.Information = "NOOT NOOT"
ENT.Category = "Other"

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"NootTarget")
end

function ENT:FindClosest(position)
	local closest = nil
	local dist = math.huge
	local playerTable = player.GetAll()
	local npcTable = ents.FindByClass("*npc_*")

	local findme = table.Merge(playerTable, npcTable)

	for _,ent in pairs(findme) do
		if IsValid(ent) then
			local curdist = self:GetPos():Distance(ent:GetPos())
			if curdist < dist then
				closest = ent
				dist = curdist
			end
		end
	end
	return closest
end

if CLIENT then
	local noot = 500
	function ENT:Draw()
		local target
		if IsValid(self:GetNootTarget()) then
			target = self:GetNootTarget()
		else
			target = self
		end

		local t_ang = (target:GetPos()-self:GetPos()):Angle()
		local ent = ClientsideModel(self:GetModel())
		ent:SetMaterial(self:GetMaterial())
		ent:SetPos(self:GetPos())
		ent:SetAngles(Angle((-10*(noot/100)),t_ang.y,0))
		ent:DrawModel()

		local outline = ClientsideModel(self:GetModel())
		outline:SetMaterial(self:GetMaterial())
		outline:SetPos(ent:GetPos())
		outline:SetAngles(ent:GetAngles())
		local mat = Matrix()
		mat:Scale(Vector(-1.08,-1.08,-1.08))
		outline:EnableMatrix("RenderMultiply",mat)
		render.SetColorModulation(0,0,0)
		outline:DrawModel()
		outline:Remove()

		local l_eye = ClientsideModel(self:GetModel())
		l_eye:SetMaterial(self:GetMaterial())
		local pos,ang = ent:GetPos(),ent:GetAngles()
		pos:Add(ang:Forward()*6.5)
		pos:Add(ang:Right()*-4)
		pos:Add(ang:Up()*2)
		l_eye:SetPos(pos)
		local mat = Matrix()
		mat:Scale(Vector(0.12,0.12,0.12))
		l_eye:EnableMatrix("RenderMultiply",mat)
		l_eye:DrawModel()
		l_eye:Remove()

		local r_eye = ClientsideModel(self:GetModel())
		r_eye:SetMaterial(self:GetMaterial())
		local pos,ang = ent:GetPos(),ent:GetAngles()
		pos:Add(ang:Forward()*6.5)
		pos:Add(ang:Right()*4)
		pos:Add(ang:Up()*2)
		r_eye:SetPos(pos)
		local mat = Matrix()
		mat:Scale(Vector(0.12,0.12,0.12))
		r_eye:EnableMatrix("RenderMultiply",mat)
		r_eye:DrawModel()
		r_eye:Remove()

		render.SetColorModulation(1,1,1)
		local mouth = ClientsideModel("models/holograms/hq_tube.mdl")
		mouth:SetMaterial(self:GetMaterial())
		local pos,ang = ent:GetPos(),ent:GetAngles()
		pos:Add(ang:Forward()*(5+(noot/100)))
		pos:Add(ang:Right()*0)
		pos:Add(ang:Up()*-3)
		ang:RotateAroundAxis(ang:Right(),90)
		mouth:SetPos(pos)
		mouth:SetAngles(ang)
		local mat = Matrix()
		mat:Scale(Vector(0.65,0.65,0.65))
		mouth:EnableMatrix("RenderMultiply",mat)
		mouth:DrawModel()
		mouth:Remove()

		render.SetColorModulation(0,0,0)
		local m_out = ClientsideModel("models/holograms/hq_tube.mdl")
		m_out:SetMaterial(self:GetMaterial())
		local pos,ang = ent:GetPos(),ent:GetAngles()
		pos:Add(ang:Forward()*(5+(noot/100)))
		pos:Add(ang:Right()*0)
		pos:Add(ang:Up()*-3)
		ang:RotateAroundAxis(ang:Right(),90)
		m_out:SetPos(pos)
		m_out:SetAngles(ang)
		local mat = Matrix()
		mat:Scale(Vector(-0.7,-0.7,-0.7))
		m_out:EnableMatrix("RenderMultiply",mat)
		m_out:DrawModel()
		m_out:Remove()

		local m_in = ClientsideModel("models/holograms/hq_cylinder.mdl")
		m_in:SetMaterial(self:GetMaterial())
		local pos,ang = ent:GetPos(),ent:GetAngles()
		pos:Add(ang:Forward()*8)
		pos:Add(ang:Right()*0)
		pos:Add(ang:Up()*-3)
		ang:RotateAroundAxis(ang:Right(),90)
		m_in:SetPos(pos)
		m_in:SetAngles(ang)
		local mat = Matrix()
		mat:Scale(Vector(0.6,0.6,0.1*0.6))
		m_in:EnableMatrix("RenderMultiply",mat)
		m_in:DrawModel()
		m_in:Remove()

		local hat = ClientsideModel("models/player/items/spy/hat_third_nr.mdl")
		hat:SetMaterial(self:GetMaterial())
		local pos,ang = ent:GetPos(),ent:GetAngles()
		pos:Add(ang:Forward()*-4)
		pos:Add(ang:Right()*0)
		pos:Add(ang:Up()*-1)
		hat:SetPos(pos)
		hat:SetAngles(ang)
		local mat = Matrix()
		mat:Scale(Vector(1.7,1.7,1.7))
		hat:EnableMatrix("RenderMultiply",mat)
		hat:DrawModel()
		hat:Remove()

		ent:Remove()

		render.SetColorModulation(1,1,1)
		noot=noot/1.1
		if math.Round(noot) == 1 then sound.Play("npc/crow/alert"..math.random(2,3)..".wav",self:GetPos()) noot = 500 end
	end
end
--
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end


	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal + Vector(0,0,10))
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/pac/default.mdl")
		self:SetMaterial("models/debug/debugwhite")

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_BSP)
		self:SetUseType(SIMPLE_USE)
		self:AddToMotionController(self:GetPhysicsObject())
		self:StartMotionController()

		self:GetPhysicsObject():Wake()
	end
end

local noot = 400
function ENT:PhysicsSimulate(phys,delta)

	self:SetNootTarget(self:FindClosest(self:GetPos()	))
	phys:ApplyForceCenter((self:GetNootTarget():GetPos()-self:GetPos())/5)

	noot=noot/1.1
	if math.Round(noot) == 1 then phys:ApplyForceCenter(Vector(0,0,800)) noot = 400 end
end

easylua.EndEntity()