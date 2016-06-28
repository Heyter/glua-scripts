mclicker = {}
mclicker.coins = mclicker.coins or 0
mclicker.upgrades = {}
mclicker.upgrades.timer = mclicker.upgrades.timer or 0

function mclicker_open()
	local frame = vgui.Create("DFrame")
	frame:SetSize(640,480)
	frame:Center()
	frame:SetTitle("MetaClicker")
	frame:MakePopup()

	local text = vgui.Create("DLabel",frame)
	text:SetText("Coins: "..mclicker.coins)
	text:SetFont("DermaLarge")
	text:Dock(TOP)

	local upgrades = vgui.Create("DButton",frame)
	upgrades:Dock(RIGHT)
	upgrades:SetText("Upgrades")
	function upgrades:DoClick()
		mclicker_ShowUpgrades()
	end

	local button = vgui.Create("DButton",frame)
	button:Dock(FILL)
	button:SetText("Click Me!")
	function button:DoClick()
		mclicker.coins = mclicker.coins + 1
	end

	function frame:Think()
		text:SetText("Coins: "..mclicker.coins)
	end
end

function mclicker_ShowUpgrades()
	if IsValid(upgframe) then return end
	upgframe = vgui.Create("DFrame")
	upgframe:SetSize(256,480)
	upgframe:SetPos(ScrW()/2+640,ScrH()/2)
	upgframe:SetTitle("Upgrades")
	upgframe:MakePopup()

	local button1 = vgui.Create("DButton",upgframe)
	button1:Dock(TOP)
	button1:SetText("Timer Clicker (1000c)")
	if mclicker.upgrades.timer == 1 then button1:SetEnabled(false) end
	function button1:DoClick()
		if mclicker.upgrades.timer != 1 and mclicker.coins > 1000 then
			mclicker.upgrades.timer = 1
			mclicker.coins = mclicker.coins - 1000
		end
	end

	function upgframe:Think()
		if mclicker.upgrades.timer == 1 then button1:SetEnabled(false) end
	end
end

LocalPlayer():PrintMessage(3,"Type !mclicker to open MetaClicker window.")

hook.Add( "PlayerSay", "mclicker", function( ply, text, team, dead )
	if ( string.sub( text, 1, 9 ) == "!mclicker" ) then
		mclicker_open()
	end
end)

hook.Add("Think","mclicker_upgrades",function()
	if mclicker.upgrades.timer == 1 then
		mclicker.coins = mclicker.coins + 1
	end
end)