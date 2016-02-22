local function win98_boot()
	local i = 255
	win98_bootimg = vgui.Create("DHTML")
	win98_bootimg:Dock(FILL)
	win98_bootimg:DockMargin(-8,-8,-25,-8)
	win98_bootimg:SetHTML("<img src=\"http://orig14.deviantart.net/4c49/f/2015/154/b/4/windows_95_boot_screen_by_oscareczek-d8vvnwm.gif\" width=100% height=100%>")
	local fade = vgui.Create("EditablePanel",win98_bootimg)
	fade:Dock(FILL)
	local pixelsneeded = surface.ScreenWidth() / 1024
	function fade:Paint(w,h)
		i = i-1
		--[[for e = 1,100 do
			local rainbow = HSVToColor(math.mod(RealTime()*50+(e*2), 360),1,1)
			draw.RoundedBox(0,30*e-30,h-30,30,30,rainbow)
		end]]
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,i))
	end
	timer.Simple(30,function()
		win98_bootimg:Remove()
		win98_desktop()
	end)
end

function win98_desktop()
	local desktopicons = {
		browser = {
			icon = "icon16/world.png",
			name = "Browser",
			callback = function() w98_open_browser() end,
		},
		chatbox = {
			icon = "icon16/group.png",
			name = "Chatbox",
			callback = function() w98_open_chatbox() end,
		}
	}
	LocalPlayer():EmitSound("chatsounds/autoadd/windows/win98 startup.ogg")
	win98 = vgui.Create("DFrame")
	win98:SetSize(ScrW(),ScrH())
	win98:SetTitle("Windows 98")
	win98:SetIcon("icon16/computer.png")
	win98:MakePopup()
	win98:SetSizable(true)
	local bg = vgui.Create("EditablePanel",win98)
	bg:Dock(FILL)
	function bg:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,128,128))
	end

	function w98_open_chatbox()
		local chatbox = vgui.Create("DFrame",bg)
		chatbox:SetSize(400,54)
		chatbox:SetTitle("Chat")
		chatbox:SetIcon("icon16/group.png")
		chatbox:SetDraggable(true)
		local textarea = vgui.Create("DTextEntry",chatbox)
		textarea:Dock(FILL)
		textarea:SetText("")
		local send = vgui.Create("DButton",chatbox)
		send:Dock(RIGHT)
		send:SetWide(24)
		send:SetImage("icon16/arrow_right.png")
		send:SetText("")
		function send:DoClick()
			Say(textarea:GetText())
			textarea:SetText("")
		end
	end

	function w98_open_browser()
		local browser = vgui.Create("DFrame",bg)
		browser:SetSize(750,500)
		local back =vgui.Create("DButton",browser)
		back:Dock(LEFT)
		back:SetWide(24)
		back:SetImage("icon16/arrow_left.png")
		back:SetText("")
	end
	local taskbar = vgui.Create("EditablePanel",bg)
	taskbar:Dock(BOTTOM)
	taskbar:SetTall(24)
	function taskbar:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(192,192,192))
	end
	local startbutton = vgui.Create("DButton",taskbar)
	startbutton:Dock(LEFT)
	startbutton:DockMargin(2,2,2,2)
	startbutton:SetWide(54)
	startbutton:SetText("Start")
	startbutton:SetTextColor(Color(0,0,0))
	function startbutton:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
		draw.RoundedBox(0,1,1,w-2,h-2,Color(128,128,128))
		draw.RoundedBox(0,2,2,w-4,h-4,Color(192,192,192))
	end

	local timebox = vgui.Create("EditablePanel",taskbar)
	timebox:Dock(RIGHT)
	timebox:DockMargin(2,2,2,2)
	timebox:SetWide(54)
	function timebox:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(128,128,128))
		draw.RoundedBox(0,1,1,w-2,h-2,Color(192,192,192))
		draw.DrawText(os.date("%H:%M"),"DermaDefault",w/2,2,Color(0,0,0),TEXT_ALIGN_CENTER)
	end

	win98_desktopicons = vgui.Create("DIconLayout",bg)
	win98_desktopicons:Dock(FILL)
	win98_desktopicons:SetSpaceX(16)
	win98_desktopicons:SetSpaceY(16)

	for _,icon in pairs(desktopicons) do
		local shortcut = win98_desktopicons:Add("EditablePanel")
		shortcut:SetSize(48,48)
		local image = vgui.Create("DImageButton",shortcut)
		image:SetImage(icon.icon)
		image:SetSize(32,32)
		image:SetPos(4,4)
		image.DoClick = icon.callback
		local label = vgui.Create("DLabel",shortcut)
		label:SetPos(4,shortcut:GetTall()-16)
		label:SetTextColor(Color(255,255,255))
		label:SetText(icon.name)
		label:SizeToContents()
	end
end

hook.Add( "PlayerSay", "win98", function( ply, text, team, dead )
	if text:match"^!win98" and ply == LocalPlayer() then
		if text:find("noboot") then
			win98_desktop()
		else
			win98_boot()
		end
	end
end)