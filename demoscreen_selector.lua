local active = true
local clicked

surface.CreateFont("demomanpanelfont1", {
    font = "Roboto",
    size = 16,
    weight = 1000,
})

surface.CreateFont("demomanpanelfont2", {
    font = "Roboto",
    size = 16
})

local gradmat = Material("vgui/gradient_down")

local pnl
local demotable = table.Copy(demoman.demos)
local selpan
local scrpan
local function makeDemoPanel(name, author, idx, main, parent)
    local dp = vgui.Create("DPanel", parent)
    dp:DockPadding(4,4,4,4)
    dp:SetTall(24)
    dp:Dock(TOP)
    dp:SetCursor("hand")

    function dp:Paint(w,h)
        if idx.custom then
            surface.SetDrawColor(255,0,0,90)
        else
            surface.SetDrawColor(255,255,255,90)
        end
        surface.DrawRect(0,0,w,h)
    end

    function dp:ChooseDemo()
        if idx.custom then
            if table.HasValue(demoman.demos, idx) then
                table.RemoveByValue(demoman.demos, idx)
            end
            table.insert(demoman.demos, idx)
        end
        timer.Simple(0.1,function()
            demoman.SelectDemo(idx)
        end)
        main:CloseAlpha()
    end

    function dp:OnMousePressed(kc)
        if kc == MOUSE_LEFT then
            self.ll, self.mm = self:LocalCursorPos()
        end
    end

    local function posDiff(x1,x2)
        return math.abs(x1 - x2)
    end

    function dp:OnMouseReleased(kc)
        local x,y = self:LocalCursorPos()
        if kc == MOUSE_LEFT and posDiff(self.ll or 0, x) <= 1 and posDiff(self.mm or 0, y) then
            self:ChooseDemo()
        end
    end

    function dp:SetSelected()
        self.selected = true
        selpan = self
    end

    local lbl1 = vgui.Create("DLabel", dp)
    lbl1:SetText(name)
    lbl1:SetBright(true)
    lbl1:SetFont("demomanpanelfont1")
    lbl1:Dock(LEFT)
    lbl1:SizeToContents()

    local lbl2 = vgui.Create("DLabel", dp)
    lbl2:SetText(author)
    lbl2:SetFont("demomanpanelfont2")
    lbl2:Dock(LEFT)
    lbl2:DockMargin(2,0,0,0)
    lbl1:SizeToContents()

    return dp

end
local function openThing()

    print"wowow it works"

    if IsValid(pnl) then

        pnl:CloseAlpha()
        pnl = nil

    return end

    pnl = vgui.Create("DFrame")
    pnl:SetAlpha(0)
    pnl:AlphaTo(255, 0.25, 0, function() if not IsValid(pnl) then return end pnl:MakePopup() end)

    local max = 10

    pnl:SetSize(400, 24 * max + 4)
    pnl:ShowCloseButton(false)
    pnl:SetPos(0, ScrH() - (24 * max + 4))
    pnl:SetTitle("Demoman Panel")
    function pnl:Paint(w, h)
        surface.SetDrawColor(255, 255, 255, 100)
        surface.DrawRect(0, 0, w, 24)
    end

    function pnl:CloseAlpha()
        self:AlphaTo(0, 0.25, 0, function() if not IsValid(self) then return end self:Remove() end)
    end

    local dempanp = vgui.Create("DScrollPanel", pnl)
    dempanp:Dock(FILL)
    dempanp:GetVBar():SetAlpha(0)
    dempanp:GetVBar():SetWide(0)

    function dempanp:Scroll(a)
        a = math.Clamp(a, 0, self:GetCanvas():GetTall())
        self:GetVBar():SetScroll(a)
    end

    function dempanp:Think()
        local x,y = self:LocalCursorPos()
        if input.IsMouseDown(MOUSE_LEFT) and (x > 0 and y > 0 and x < self:GetWide() and y < self:GetTall()) and not self.sec then
            self.sec = true
            self.starty = y
            self.scroll = self:GetVBar().Scroll
        return end
        if not input.IsMouseDown(MOUSE_LEFT) then
            self.sec = nil
        return end
        if self.sec then
            local starty = self.starty
            y = starty - y
            local startscroll = self.scroll
            self:Scroll(startscroll + y)
            local now = startscroll + y
            now = math.Round(now / 24)
        end
    end

    scrpan = dempanp

    function dempanp:Paint() end

    local notcustom = {}
    for k,v in pairs(demotable) do
        if not v.custom then
            table.insert(notcustom,v)
        continue end
        local pnl = makeDemoPanel(v.Title, v.Author, v, pnl, dempanp)
    end
    for k,v in pairs(notcustom) do
        local pnl = makeDemoPanel(v.Title, v.Author, v, pnl, dempanp)
    end

end

hook.Add("Think", "demoman thing", function()

    if not active then return end

    if input.IsKeyDown(KEY_F4) then
        if not clicked then
            clicked = true
            openThing()
        end
    else
        clicked = nil
    end

end)

function MakeDemo(tbl)
    for k,v in pairs(demotable) do
        if v.custom and v.Title == tbl.Title and v.Author == tbl.Author then
            table.RemoveByValue(demoman.demos, v)
            demotable[k] = nil
        end
    end
    demoman.demo_time = 9999
    tbl.custom = true
    table.insert(demotable,tbl)
    print(table.HasValue(demotable, tbl))
end

print("[ok]")