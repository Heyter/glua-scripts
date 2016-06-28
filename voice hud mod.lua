if CLIENT then
	local PANEL = {}
	PlayerVoicePanels = {}

	local PlayerColors = {
		["0"]  = Color(0, 0, 0),
		["1"]  = Color(128, 128, 128),
		["2"]  = Color(192, 192, 192),
		["3"]  = Color(255, 255, 255),
		["4"]  = Color(0, 0, 128),
		["5"]  = Color(0, 0, 255),
		["6"]  = Color(0, 128, 128),
		["7"]  = Color(0, 255, 255),
		["8"]  = Color(0, 128, 0),
		["9"]  = Color(0, 255, 0),
		["10"] = Color(128, 128, 0),
		["11"] = Color(255, 255, 0),
		["12"] = Color(128, 0, 0),
		["13"] = Color(255, 0, 0),
		["14"] = Color(128, 0, 128),
		["15"] = Color(255, 0, 255),
	}

	function PANEL:Init()

		self.LabelName = vgui.Create( "DLabel", self )
		self.LabelName:SetFont( "GModNotify" )
		self.LabelName:Dock( FILL )
		self.LabelName:DockMargin( 8, 0, 0, 0 )
		self.LabelName:SetTextColor( Color( 255, 255, 255, 255 ) )

		self.Avatar = vgui.Create( "AvatarImage", self )
		self.Avatar:Dock( LEFT )
		self.Avatar:SetSize( 32, 32 )

		self.Color = color_transparent

		self:SetSize( 250, 32 + 8 )
		self:DockPadding( 4, 4, 4, 4 )
		self:DockMargin( 2, 2, 2, 2 )
		self:Dock( BOTTOM )

	end

	function PANEL:Setup( ply )

		self.ply = ply

		local name_c
		for col in string.gmatch(ply:Nick(),"%^(%d)") do
		name_c = PlayerColors[col]
		end
		for col1,col2,col3 in string.gmatch(ply:Nick(),"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
		name_c = HSVToColor(col1,col2,col3)
		end
		for col1,col2,col3 in string.gmatch(ply:Nick(),"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>") do
		name_c = Color(col1,col2,col3,255)
		end
		local c = name_c and name_c or team.GetColor(ply:Team())

		local name_noc = ply:Nick()
		name_noc = string.gsub(name_noc,"<hsv=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"<color=(%d+%.?%d*),(%d+%.?%d*),(%d+%.?%d*)>","")
		name_noc = string.gsub(name_noc,"%^(%d+%.?%d*)","")

		self.LabelName:SetText(name_noc)
		self.LabelName:SetTextColor(c)
		self.Avatar:SetPlayer( ply )
		
		self.Color = team.GetColor( ply:Team() )
		
		self:InvalidateLayout()

	end

	function PANEL:Paint( w, h )
		local div = 31.25

		if ( !IsValid( self.ply ) ) then return end
		draw.RoundedBox( 4, 0, 0, w, h, Color(32,32,32,200))

	end

	function PANEL:Think()
		
		if ( IsValid( self.ply ) ) then
			self.LabelName:SetText( self.ply:Nick() )
		end

		if ( self.fadeAnim ) then
			self.fadeAnim:Run()
		end

		self.next = CurTime()

		local rainbow = HSVToColor(CurTime()*(self.ply:VoiceVolume())%360,0.5,0.5)
		local volbar = vgui.Create("DPanel",self)
		volbar:SetSize(4,(self:GetTall()-6)*self.ply:VoiceVolume())
		volbar:SetPos(self:GetTall()-6,(self:GetTall()-6)*(1-self.ply:VoiceVolume())+3)
		volbar.Think = function(bar)
			if bar.Next and CurTime()-bar.Next < .02 then return false end
			bar.Next = CurTime()

			local x,y = bar:GetPos()
			if x > self:GetWide()+14 then bar:Remove() return end

			bar:SetPos(x+6,y)
		end
		function volbar:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,rainbow)
		end
		volbar:MoveToBack()
		volbar:SetZPos(5)
	end

	function PANEL:FadeOut( anim, delta, data )
		
		if ( anim.Finished ) then
		
			if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
				PlayerVoicePanels[ self.ply ]:Remove()
				PlayerVoicePanels[ self.ply ] = nil
				return
			end
			
		return end
		
		self:SetAlpha( 255 - ( 255 * delta ) )

	end

	derma.DefineControl( "FVoicePnl", "", PANEL, "DPanel" )

	hook.Add("PlayerStartVoice","FBox_VoicePanel",function(ply)
		if ( !IsValid( g_VoicePanelList ) ) then return end

		-- There'd be an exta one if voice_loopback is on, so remove it.
		GAMEMODE:PlayerEndVoice( ply )

		if LocalPlayer():GetPos():Distance(ply:GetPos()) > 2048 then
			GAMEMODE:PlayerEndVoice( ply )
		end


		if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

			if ( PlayerVoicePanels[ ply ].fadeAnim ) then
				PlayerVoicePanels[ ply ].fadeAnim:Stop()
				PlayerVoicePanels[ ply ].fadeAnim = nil
			end

			PlayerVoicePanels[ ply ]:SetAlpha( 255 )

			return true

		end

		if ( !IsValid( ply ) ) then return end

		local pnl = g_VoicePanelList:Add( "FVoicePnl" )
		pnl:Setup( ply )

		PlayerVoicePanels[ ply ] = pnl
		return true
	end)

	local function VoiceClean()

		for k, v in pairs( PlayerVoicePanels ) do
		
			if not IsValid( k ) or LocalPlayer():GetPos():Distance(k:GetPos()) < 2048 then
				GAMEMODE:PlayerEndVoice( k )
			end
		
		end

	end
	timer.Create( "VoiceClean", 10, 0, VoiceClean )

	hook.Add("PlayerEndVoice","FBox_VoicePanel",function(ply)

		if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

			if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end

			PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
			PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )

		end

	end)

	local function CreateVoiceVGUI()

		g_VoicePanelList = vgui.Create( "DPanel" )

		g_VoicePanelList:ParentToHUD()
		g_VoicePanelList:SetPos( ScrW() - 300, 100 )
		g_VoicePanelList:SetSize( 250, ScrH() - 200 )
		g_VoicePanelList:SetDrawBackground( false )

	end

	hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )
end

if SERVER then
	hook.Add("PlayerCanHearPlayersVoice","FBox_VoicePanel",function(listener,talker)
	    return ( listener:GetPos():Distance( talker:GetPos() ) <= 1024 )
	end)
end