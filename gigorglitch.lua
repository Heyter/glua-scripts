easylua.StartEntity("grigorglitch")

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Grigorglitch"
ENT.Author = "Flex"
ENT.Information = "sodomy"
ENT.Category = "Other"

ENT.Spawnable = true
ENT.AdminOnly = false

if CLIENT then
	function ENT:Draw()
		local ent = ClientsideModel(self:GetModel())
		ent:SetMaterial(self:GetMaterial())
		local mat = Matrix()
		mat:Scale(Vector(math.Rand(1,5),math.Rand(1,5),math.Rand(1,5)))
		ent:EnableMatrix("RenderMultiply",mat)
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		local rand = ColorRand()
		render.SetColorModulation(rand.r/255,rand.g/255,rand.b/255)

		ent:DrawModel()
		ent:Remove()
	end
end
--
function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end


	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal + Vector(0,0,100))
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/dav0r/hoverball.mdl")
		self:SetMaterial("models/monk/grigori_head")

		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:RebuildPhysics()
	end
end

function ENT:RebuildPhysics( value )

	local value = 5
	self:PhysicsInitSphere( value, "metal_bouncy" )
	self:SetCollisionBounds( Vector(-value,-value,-value), Vector(value,value,value) )
	self:PhysWake()
end

function ENT:OnBallSizeChanged( varname, oldvalue, newvalue )

	-- Do not rebuild if the size wasn't changed
	if ( oldvalue == newvalue ) then return end

	self:RebuildPhysics( newvalue )

end

--[[---------------------------------------------------------
	Name: PhysicsCollide
-----------------------------------------------------------]]

function ENT:PhysicsCollide( data, physobj )

	-- Play sound on bounce
	if ( data.Speed > 60 && data.DeltaTime > 0.2 ) then

		local pitch = 32 + 128 - math.random(0,100)
		sound.Play( Sound("vo/ravenholm/madlaugh0"..math.random(1,4)..".wav"), self:GetPos(), 75, math.random( pitch - 10, pitch + 10 ), math.Clamp( data.Speed / 150, 0, 1 ) )

	end

	-- Bounce like a crazy bitch
	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = physobj:GetVelocity()
	NewVelocity:Normalize()

	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )

	local TargetVelocity = NewVelocity * LastSpeed * 0.9

	physobj:SetVelocity( TargetVelocity )

end

function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

easylua.EndEntity()