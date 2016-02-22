--CVARS--

local OutlineR    = CreateClientConVar("spawnmenu_lua_outline_r"    ,128)
local OutlineG    = CreateClientConVar("spawnmenu_lua_outline_g"    ,200)
local OutlineB    = CreateClientConVar("spawnmenu_lua_outline_b"    ,200)
local BackgroundR = CreateClientConVar("spawnmenu_lua_background_r" ,0)
local BackgroundG = CreateClientConVar("spawnmenu_lua_background_g" ,0)
local BackgroundB = CreateClientConVar("spawnmenu_lua_background_b" ,0)

local OutlineCol    = Color(OutlineR:GetInt()    ,OutlineG:GetInt()    ,OutlineB:GetInt()    ,255)
local BackgroundCol = Color(BackgroundR:GetInt() ,BackgroundG:GetInt() ,BackgroundB:GetInt() ,255)

function draw.OutlinedBox(x,y,w,h,thick,col)
	surface.SetDrawColor(col)
	for i=0, thick - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

--SPAWNMENU--

spawnmenu.AddCreationTab("Lua Editor",function()
    local panel = vgui.Create("DPanel")
    function panel:Paint() end

    local editor = vgui.Create("DPanel",panel)
    local glua = vgui.Create("HTML",panel)
    local gwiki = vgui.Create("HTML",panel)
    local config = vgui.Create("DPanel",panel)

    glua:OpenURL("http://samuelmaddock.github.io/glua-docs/")
    gwiki:OpenURL("http://wiki.garrysmod.com")

    function editor:Paint() end
    function config:Paint() end

    local tabs = vgui.Create("DPropertySheet",panel)
    tabs:Dock(FILL)
    tabs:AddSheet("Editor"    ,editor ,"icon16/application_edit.png")
    tabs:AddSheet("GLua Docs" ,glua   ,"icon16/page_white_code.png")
    tabs:AddSheet("GMod Wiki" ,gwiki  ,"games/16/garrysmod.png")
    tabs:AddSheet("Config"    ,config ,"icon16/cog_edit.png")
    function tabs:Paint(w,h)
        draw.RoundedBox(0,0,19,w,h-19,BackgroundCol)
        draw.OutlinedBox(0,19,w,h-19,1,OutlineCol)
    end

    for _,tab in pairs(tabs.tabScroller.Panels) do
        function tab:Paint(w,h)
            draw.RoundedBox(0,0,0,w-4,20,BackgroundCol)
            draw.OutlinedBox(0,0,w-4,20,1,OutlineCol)
        end
        tab:SetTextColor(OutlineCol)
    end

    --EDITOR--

    local editor_bar = vgui.Create("DPanel",editor)
    editor_bar:Dock(TOP)
    editor_bar:SetTall(20)
    function editor_bar:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,BackgroundCol)
        draw.OutlinedBox(0,0,w,h,1,OutlineCol)
    end

    local editor_sidebar = vgui.Create("DPanel",editor)
    editor_sidebar:Dock(LEFT)
    editor_sidebar:SetWide(100)
    function editor_sidebar:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,BackgroundCol)
        draw.OutlinedBox(0,0,w,h,1,OutlineCol)
    end

    local code_imitator = vgui.Create("EditablePanel",editor)
    code_imitator:Dock(FILL)

	local editor_tabs = vgui.Create( "lua_editor_TabControl",editor)
	editor_tabs:Dock(FILL)
	function editor_tabs:Paint(w,h)
        draw.RoundedBox(0,0,19,w,h-19,BackgroundCol)
        draw.OutlinedBox(0,19,w,h-19,1,OutlineCol)
    end

    for _,tab in pairs(editor_tabs.tabScroller.Panels) do
        function tab:Paint(w,h)
            draw.RoundedBox(0,0,0,w-4,20,BackgroundCol)
            draw.OutlinedBox(0,0,w-4,20,1,OutlineCol)
        end
        tab:SetTextColor(OutlineCol)
    end

	local editor_filelist = vgui.Create("DPanel",editor)
    editor_filelist:Dock(RIGHT)
    editor_filelist:SetWide(240)
    function editor_filelist:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,BackgroundCol)
        draw.OutlinedBox(0,0,w,h,1,OutlineCol)
    end

	local editor_console = vgui.Create("DPanel",editor)
	editor_console:Dock(BOTTOM)
	editor_console:SetTall(240)
	function editor_console:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,BackgroundCol)
        draw.OutlinedBox(0,0,w,h,1,OutlineCol)
    end

	local console_log = vgui.Create("RichTextX",editor_console)
	console_log:Dock(FILL)
	console_log:DockMargin(4,4,4,0)
	console_log:InsertColorChange(128,200,200,255)
	console_log:SetFont("DermaDefault")
	console_log:AppendText("Spawnmenu Lua Editor loaded\n")

	local console_input = vgui.Create("DPanel")

	local console_input = vgui.Create("DTextEntry",editor_console)
	console_input:Dock(BOTTOM)
	console_input:DockMargin(4,4,4,4)
	function console_input:OnEnter()
		if self:GetText() != "" then
			luadev.RunOnSelf(self:GetText())
			self:SetText("")
			local code = self:GetText()
			code = string.gsub(code,"\"","\xef\xbc\x82")
			console_log:AppendText("Code -> Self: "..code.."\n")
		end
	end

	local console_run = vgui.Create("DButton",editor_console)
	console_run:Dock(LEFT)

    --CONFIG--

    local button_reload = vgui.Create("DButton",config)
    button_reload:Dock(TOP)
    button_reload:DockMargin(0,0,0,5)
    button_reload:SetText("Reload")
    button_reload:SetTextStyleColor(OutlineCol)
    function button_reload:UpdateColours()
        return self:SetTextStyleColor(OutlineCol)
    end
    function button_reload:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,BackgroundCol)
        draw.OutlinedBox(0,0,w,h,1,OutlineCol)
    end
    function button_reload:DoClick()
        RunConsoleCommand("spawnmenu_reload")
    end

    local cat_colors = vgui.Create("DCollapsibleCategory",config)
	cat_colors:Dock(TOP)
	cat_colors:SetExpanded(1)
	cat_colors:SetLabel("Colors")
	cat_colors.Header:SetIcon("icon16/color_wheel.png")
    cat_colors.Header:SetTextColor(OutlineCol)
	cat_colors.AddItem = function(cat,ctrl) ctrl:SetParent(cat) ctrl:Dock(TOP) end
    function cat_colors:Paint(w,h)
        draw.RoundedBox(0,0,0,w,20,BackgroundCol)
        draw.OutlinedBox(0,0,w,20,1,OutlineCol)
        draw.RoundedBox(0,0,19,w,h-19,BackgroundCol)
        draw.OutlinedBox(0,19,w,h-19,1,OutlineCol)
    end

    local label_bg = vgui.Create("DLabel",config)
	label_bg:DockMargin(5,5,0,0)
	label_bg:SetFont("DermaDefault")
	label_bg:SetText("Background Color:")
	label_bg:SetColor(OutlineCol)
	label_bg:SizeToContents()
	cat_colors:AddItem(label_bg)

	local color_bg = vgui.Create("DColorMixer",config)
	color_bg:DockMargin(5,5,0,0)
	color_bg:SetPalette(true)
	color_bg:SetAlphaBar(false)
	color_bg:SetWangs(true)
	color_bg:SetColor(Color(BackgroundR:GetInt(),BackgroundG:GetInt(),BackgroundB:GetInt(),255))
	color_bg:SetConVarR("spawnmenu_lua_background_r")
	color_bg:SetConVarG("spawnmenu_lua_background_g")
	color_bg:SetConVarB("spawnmenu_lua_background_b")
	cat_colors:AddItem(color_bg)

	local label_outline = vgui.Create("DLabel",config)
	label_outline:DockMargin(5,5,0,0)
	label_outline:SetFont("DermaDefault")
	label_outline:SetText("Outline/Text Color:")
	label_outline:SetColor(OutlineCol)
	label_outline:SizeToContents()
	cat_colors:AddItem(label_outline)

	local color_outline = vgui.Create("DColorMixer",config)
	color_outline:DockMargin(5,5,0,0)
	color_outline:SetPalette(true)
	color_outline:SetAlphaBar(false)
	color_outline:SetWangs(true)
	color_outline:SetColor(Color(OutlineR:GetInt(),OutlineG:GetInt(),OutlineB:GetInt(),255))
	color_outline:SetConVarR("spawnmenu_lua_outline_r")
	color_outline:SetConVarG("spawnmenu_lua_outline_g")
	color_outline:SetConVarB("spawnmenu_lua_outline_b")
	cat_colors:AddItem(color_outline)

    local button_apply = vgui.Create("DButton",config)
    button_apply:DockMargin(5,5,0,0)
    button_apply:SetText("Apply Colors")
    button_apply:SetTextStyleColor(OutlineCol)
    function button_apply:UpdateColours()
        return self:SetTextStyleColor(OutlineCol)
    end
    function button_apply:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,BackgroundCol)
        draw.OutlinedBox(0,0,w,h,1,OutlineCol)
    end
    function button_apply:DoClick()
        OutlineCol    = Color(OutlineR:GetInt()    ,OutlineG:GetInt()    ,OutlineB:GetInt()    ,255)
        BackgroundCol = Color(BackgroundR:GetInt() ,BackgroundG:GetInt() ,BackgroundB:GetInt() ,255)
    end
    cat_colors:AddItem(button_apply)

    return panel
end,"icon16/page_white_code.png",300)

RunConsoleCommand("spawnmenu_reload")
