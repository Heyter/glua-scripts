--[[
________/\\\\\\\\\\\\\________/\\\__________________/\\\\\\\\\\\______________________/\\\\\_____________________________________________________________________________________________________________________
 _______\/\\\/////////\\\__/\\\\\\\_________________\/////\\\///_____________________/\\\///______________________________________________________________________________________________________________________
  _______\/\\\_______\/\\\_\/////\\\_____________________\/\\\_______________________/\\\____________________________________/\\\__/\\\__________________/\\\______________________________________________________
   _______\/\\\\\\\\\\\\\\______\/\\\_____________________\/\\\______/\\/\\\\\\____/\\\\\\\\\_______/\\\\\_____/\\\\\\\\\\___\//\\\/\\\___/\\\\\\\\\\__/\\\\\\\\\\\_____/\\\\\\\\_____/\\\\\__/\\\\\____/\\\\\\\\\\_
    __/\\\_\/\\\/////////\\\_____\/\\\__/\\\_______________\/\\\_____\/\\\////\\\__\////\\\//______/\\\///\\\__\/\\\//////_____\//\\\\\___\/\\\//////__\////\\\////____/\\\/////\\\__/\\\///\\\\\///\\\_\/\\\//////__
     _\///__\/\\\_______\/\\\_____\/\\\_\///________________\/\\\_____\/\\\__\//\\\____\/\\\_______/\\\__\//\\\_\/\\\\\\\\\\_____\//\\\____\/\\\\\\\\\\____\/\\\_______/\\\\\\\\\\\__\/\\\_\//\\\__\/\\\_\/\\\\\\\\\\_
      _______\/\\\_______\/\\\_____\/\\\_____________________\/\\\_____\/\\\___\/\\\____\/\\\______\//\\\__/\\\__\////////\\\__/\\_/\\\_____\////////\\\____\/\\\_/\\__\//\\///////___\/\\\__\/\\\__\/\\\_\////////\\\_
       __/\\\_\/\\\\\\\\\\\\\/______\/\\\__/\\\____________/\\\\\\\\\\\_\/\\\___\/\\\____\/\\\_______\///\\\\\/____/\\\\\\\\\\_\//\\\\/_______/\\\\\\\\\\____\//\\\\\____\//\\\\\\\\\\_\/\\\__\/\\\__\/\\\__/\\\\\\\\\\_
        _\///__\/////////////________\///__\///____________\///////////__\///____\///_____\///__________\/////_____\//////////___\////________\//////////______\/////______\//////////__\///___\///___\///__\//////////__
	Code Protected by :B1: Infosystems | REMOVAL OF THIS WILL RESULT IN PUNISHMENT | See Flex for more info

	GCapitalist v1
		by Flex
]]--

surface.CreateFont("CoolveticaBig",
	{
		font = "Coolvetica",
		size = 32,
	})
surface.CreateFont("CoolveticaBigger",
	{
		font = "Coolvetica",
		size = 64,
	})

if !file.Exists("gcap/savedata.txt","DATA") then
	file.CreateDir("gcap","DATA")
	file.Write("gcap/savedata.txt",util.TableToJSON({}))
end

if file.Exists("gcap/savedata.txt","DATA") then
	LocalPlayer():PrintMessage(3,"[GCapitalist] Data found")
	gcap_data = util.JSONToTable(file.Read("gcap/savedata.txt","DATA"))
end

--[[timer.Create("GCap_SaveGame",300,0,function()
	LocalPlayer():PrintMessage(3,"[GCapitalist] Data saved")
end)]]

local GCap_Frame = vgui.Create("DFrame")
GCap_Frame:SetSize(1200,900)
GCap_Frame:Center()
GCap_Frame:SetTitle("")
GCap_Frame:MakePopup()
GCap_Frame.btnMinim:SetVisible(false)
GCap_Frame.btnMaxim:SetVisible(false)

function GCap_Frame.btnClose:Paint(w,h)
	draw.RoundedBox(0,0,2,32,16,Color(128,0,0))
	draw.SimpleTextOutlined("r","Marlett",8,2,color_white,0,0,1,color_black)
end

local fade = 0

local gcap_phrases = {
	"NA HAVAI SUKA!",
	"PAPALI PAPALI SUKA!",
	"Song Name: Darude - Sandstorm",
	"Made by Flex of course",
	""
}

local randphrase = table.Random(gcap_phrases)

function GCap_Frame:Paint(w,h)
	if fade != 255 then fade = fade + 1 end
	draw.RoundedBox(10,0,0,w,h,Color(40,40,35))
	draw.RoundedBox(4,5,5,48,48,Color(0,128,255))
	draw.SimpleText("g","CoolveticaBig",20,10,color_white)
	draw.SimpleText("Capitalist","CoolveticaBig",58,16,color_white)
	draw.SimpleText("Welcome to GCapitalist","CoolveticaBigger",w/4,72,Color(255,255,255,fade))
	draw.SimpleText(randphrase,"DermaDefault",w/4+100,136,Color(255,255,255,fade))
end

function GCap_Frame:Close()
	if gcap_music then gcap_music:Stop() end
	self:Remove()
end

sound.PlayURL("https://dl.dropboxusercontent.com/u/67402346/Garry%27s%20Mod/Bandit%20Radio.mp3","",function(station)
	if IsValid(station) then
		gcap_music = station
		station:Play()
	end
end)