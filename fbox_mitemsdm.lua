msitems.NPCShops["dmshop"] = {
	name = "Grigori",
	sentences = {
		"Greetings brother, and so we meet at last.",
		"I sell the finest guns",
	},
	msitems = {},
}
msitems.AddNPCShopItem("dmshop","dm_ak47",1000)
msitems.StartItem("dm_ak47",nil,"weapon_flex_base","base_anim")
	ITEM.PrintName    = "AK-47"

	ITEM.Slot    = 1
	ITEM.SlotPos = 1

	ITEM.HoldType = "ar2"

	ITEM.ViewModel  = "models/weapons/cstrike/c_rif_ak47.mdl"
	ITEM.WorldModel	= "models/weapons/w_rif_ak47.mdl"
	ITEM.UseHands   = true

	ITEM.Primary.Sound   = Sound("Weapon_AK47.Single")
	ITEM.Primary.Recoil  = 0.45
	ITEM.Primary.Damage  = 36
	ITEM.Primary.Cone    = 0.05
	ITEM.Primary.Bullets = 1

	ITEM.Primary.ClipSize    = 30
	ITEM.Primary.DefaultClip = 120
	ITEM.Primary.Automatic   = true
	ITEM.Primary.Ammo        = "ar2"

	ITEM.Secondary.ClipSize    = -1
	ITEM.Secondary.DefaultClip = -1
	ITEM.Secondary.Automatic   = false
	ITEM.Secondary.Ammo        = "none"

	ITEM.SelectionFont   = "CSSelectIcons"
	ITEM.SelectionLetter = "b"

	ITEM.IronSightsPos = Vector(-6.535, 0, 1.81)
	ITEM.IronSightsAng = Vector(2.93, 0.2, 0)

	--Start msitems
	ITEM.State = "both"

	ITEM.Inventory = {
		name = "AK-47",
		info = "Standard rifle",
	}
	function ITEM:Initialize()
		self.DermaMenuOptions = {}
		if CLIENT then
			self:AddBackpackOption()
			self:AddDropOption()
			self:AddSpacer()
		else
			if self:IsWeapon() then
				self:SetHoldType(self.HoldType)
			end
		end
	end
msitems.EndItem()