local URL = "http://flexbox.us.to:8000/stream"
local StatusURL = LocalPlayer() == me and "http://10.0.0.3:8000/status-json.xsl" or "http://flexbox.us.to:8000/status-json.xsl"

surface.CreateFont("FBR_NP",{
	font = "Roboto Medium",
	size = 24,
})

--[[
too much damage done
StreamStatus = {}

local function FetchStatus()
	http.Fetch(StatusURL,
	function(data)
		print("got status")
		StreamStatus = util.JSONToTable(data)
	end,
	function(err)
		print(err)
	end)
end
FetchStatus()

timer.Create("FBoxStream_Status",10,0,FetchStatus)]]--

local sndcontrol = NULL
local cooldown = false
local pixelsneeded = surface.ScreenWidth() / 1024
local samples = {}

hook.Remove( "HUDPaint", "MusicEQ" )

LocalPlayer():ConCommand("stopsound")

local function ChatPrint(msg)
    chat.AddText( Color( 48, 48, 48 ), "\xe3\x80\x90", Color( 0,150,130 ), "FlexBox Radio", Color( 48, 48, 48 ), "\xe3\x80\x91", Color( 255, 255, 255), " " .. msg )
end

local function Play( internal_url, data )
    sound.PlayURL( internal_url, "", function (snd)
    	sndcontrol = snd
        sndcontrol:Play()
        timer.Simple( math.Round(sndcontrol:GetLength()), function()
            local runtime = 2
            local timerset = CurTime() + runtime
        end)
        local boxsize = 24
        local move = ScrW()
        local listeners = {}
        local num_listeners = 0
        hook.Add( "HUDPaint", "MusicEQ", function ()
            sndcontrol:FFT( samples, FFT_1024 )
            sndcontrol:SetVolume(GetConVar("snd_musicvolume"):GetFloat())
            local spacer = 0

            move = (move-2)%(ScrW()+20)
            for k, v in pairs(samples) do
                local rainbow = HSVToColor(math.mod(RealTime()*50+(k*2), 360),1,1)
                surface.SetDrawColor(rainbow)
                local size = v * (ScrH())
                surface.DrawRect( spacer, 0, 4,math.Clamp(size,3,ScrH()*1.5))
                spacer = spacer + pixelsneeded + 4
            end

            draw.RoundedBox(4,10,10,300,boxsize,Color(0,0,0,200))
            draw.DrawText("Players listening:","DermaDefault",14,14,Color(255,255,255))
            for _,ply in pairs(player.GetAll()) do
            	if ply:GetNWBool("fbr_listening") then
            		listeners[ply] = true
            	else
            		listeners[ply] = nil
            	end
            end
            for ply,_ in pairs(listeners) do
            	num_listeners = #listeners
            	boxsize = 24+(24*num_listeners)
           		draw.DrawText(ply:Name(),"DermaDefault",14,(24*num_listeners),Color(255,255,255))
           	end
            --draw.DrawText( "Now Playing: "..StreamStatus.icestats.source.artist .." - "..StreamStatus.icestats.source.title,"FBR_NP",move,4,HSVToColor(RealTime()*50%360,math.sin(RealTime()*2)*1,math.sin(RealTime()*2)*1),TEXT_ALIGN_CENTER)
        end )
    end )
    --ChatPrint( "Now Playing: " .. StreamStatus.icestats.source.artist .." - "..StreamStatus.icestats.source.title )
    ChatPrint("Source: "..URL)
end
ChatPrint("FlexBox Radio is now active, do !tunein to listen.")
hook.Add( "PlayerSay", "FlexBoxRadio", function( ply, text, team, dead )
	if text:match"^!tunein" and ply == LocalPlayer() then
		LocalPlayer():ConCommand("stopsound")
		Play(URL)
		ChatPrint("Want to stop listening? Do !tuneout.")
		LocalPlayer():SetNWBool("fbr_listening",true)
	end

	if text:match"^!tuneout" and ply == LocalPlayer() then
		LocalPlayer():ConCommand("stopsound")
		hook.Remove( "HUDPaint", "MusicEQ" )
		LocalPlayer():SetNWBool("fbr_listening",false)
	end
end)

concommand.Add("fbr_tunein",function()
	LocalPlayer():ConCommand("stopsound")
	Play(URL)
	ChatPrint("Want to stop listening? Do !tuneout.")
	LocalPlayer():SetNWBool("fbr_listening",true)
end)

concommand.Add("fbr_tuneout",function()
	LocalPlayer():ConCommand("stopsound")
	hook.Remove( "HUDPaint", "MusicEQ" )
	LocalPlayer():SetNWBool("fbr_listening",false)
end)