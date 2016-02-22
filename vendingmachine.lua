AddCSLuaFile()

easylua.StartEntity("flex_vending_machine")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName		= "Vending Machine"
ENT.Author			= "Flex"
ENT.Category		= "Other"
ENT.Spawnable 		= true
ENT.AdminOnly		= true

if msitems then
	msitems.NPCShops["flex_vending"] = {
		name = "Vending Machine",
		sentences = {
			"Drink Barry's Cola!",
		},
	}
	msitems.AddNPCShopItem("flex_vending","coke",25)
	msitems.AddNPCShopItem("flex_vending","coffee",20)
end

if CLIENT then
	local matScreen = CreateMaterial("fbox_vendingmachine","VertexLitGeneric",{["$basetexture"] = "models/props_interiors/sodamachine01a"})
	local RTTexture = GetRenderTarget( "FBox_VendingMachine",512,512)
	local base = CreateMaterial("fbox_vendingmachine_base","VertexLitGeneric",{["$basetexture"] = "models/props_interiors/sodamachine01a"}):GetTexture("$basetexture")
	local function TextRotated( text, x, y, color, font, ang )
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
		surface.SetFont( font )
		surface.SetTextColor( color )
		surface.SetTextPos( 0, 0 )
		local textWidth, textHeight = surface.GetTextSize( text )
		local rad = -math.rad( ang )
		x = x - ( math.cos( rad ) * textWidth / 2 + math.sin( rad ) * textHeight / 2 )
		y = y + ( math.sin( rad ) * textWidth / 2 + math.cos( rad ) * textHeight / 2 )
		local m = Matrix()
		m:SetAngles( Angle( 0, ang, 0 ) )
		m:SetTranslation( Vector( x, y, 0 ) )
		cam.PushModelMatrix( m )
			surface.DrawText( text )
		cam.PopModelMatrix()
		render.PopFilterMag()
		render.PopFilterMin()
	end

	surface.CreateFont("vending_title",{
		font = "Coolvetica",
		size = 64,
	})
	surface.CreateFont("vending_tag",{
		font = "Roboto Medium",
		size = 20,
	})

	local TEX_SIZE = 512
	local NewRT = RTTexture
	local oldW = ScrW()
	local oldH = ScrH()

	function ENT:Draw()
		self:DrawModel()

		-- Set the material of the screen to our render target
		matScreen:SetTexture( "$basetexture", NewRT )
		local OldRT = render.GetRenderTarget()

		render.SetRenderTarget( NewRT )
		render.SetViewPort( 0, 0, TEX_SIZE, TEX_SIZE )
		cam.Start2D()
			render.Clear(0,0,0,255)
			surface.SetDrawColor(Color(128,0,0))
			surface.DrawRect(9,11,246,490)
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawRect(84,374,96,60)
			TextRotated("BARRY'S",130,50,Color(255,255,255),"vending_title",-25)
			draw.DrawText("Flavored Cola","vending_tag",120,150,Color(255,255,255))
			surface.SetDrawColor(Color(128,0,0))
			surface.DrawRect(274,230,22,10)
			surface.SetDrawColor(Color(0,128,0))
			surface.DrawRect(298,230,6,10)
			surface.SetDrawColor(Color(0,0,128))
			surface.DrawRect(274,242,22,10)
			surface.SetDrawColor(Color(0,128,0))
			surface.DrawRect(298,242,6,10)
			surface.SetDrawColor(Color(128,128,0))
			surface.DrawRect(274,254,22,10)
			surface.SetDrawColor(Color(0,128,0))
			surface.DrawRect(298,254,6,10)
			surface.SetDrawColor(Color(128,64,0))
			surface.DrawRect(274,266,22,10)
			surface.SetDrawColor(Color(0,128,0))
			surface.DrawRect(298,266,6,10)
			surface.SetDrawColor(Color(64,0,64))
			surface.DrawRect(274,278,22,10)
			surface.SetDrawColor(Color(0,128,0))
			surface.DrawRect(298,278,6,10)
			surface.SetDrawColor(Color(128,128,128))
			surface.DrawRect(274,290,22,10)
			surface.DrawRect(298,290,6,10)
			surface.DrawRect(274,302,22,10)
			surface.DrawRect(298,302,6,10)
			surface.DrawRect(274,314,22,10)
			surface.DrawRect(298,314,6,10)
		cam.End2D()
		render.SetRenderTarget( OldRT )
		render.SetViewPort( 0, 0, oldW, oldH )

		self:SetMaterial("!fbox_vendingmachine")
	end
end

function ENT:Initialize()
	self:SetModel("models/props_interiors/vendingmachinesoda01a.mdl")
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		util.AddNetworkString("fbox_vendingmachine_"..self:EntIndex())
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(3)
	end

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self.role = "flex_vending"
end


if SERVER then
	function ENT:SpawnFunction(ply,tr)
		if not tr.Hit then return end
		local pos=tr.HitPos+tr.HitNormal*64
		local ent=ents.Create(ClassName)
		ent:SetPos(pos)
		ent:SetAngles(ent:GetAngles()+Angle(0,180,0))
		ent:Spawn()
		ent:Activate()
		return ent
	end
end

easylua.EndEntity(false,true)