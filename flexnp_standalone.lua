local fnp_enable = CreateClientConVar("flexnp_enabled",1,true,true)
local fnp_chat   = CreateClientConVar("flexnp_chatprint",1,true,true)
local fnp_title  = CreateClientConVar("flexnp_title",1,true,true)

local tag = "Color(0,150,130),'[',Color(0,140,121),'F',Color(0,130,113),'l',Color(0,120,104),'e',Color(0,110,96),'x',Color(0,100,87),'N',Color(0,90,79),'P',Color(0,80,70),'] ',"

luadev.RunOnClients("CreateClientConVar(\"flexnp_showinchat\",1,true,true) chat.AddText("..tag.."color_white,'FlexNP is now active, do ',Color(255,0,0),'flexnp_showinchat 0 ',color_white,'to disable.')")

local np = file.Read("nowplaying.txt","DATA")
np = string.gsub(np,"  np: ","")
local oldnp = np
hook.Add("Think","npupdate",function()
    if GetConVar("flexnp_enabled"):GetInt() == 1 then
        local npshort = file.Read("nowplaying.txt","DATA")
        np = npshort
        np = string.gsub(np,"  np: ","")
        np = string.gsub(np,"'","")
        if oldnp != np then
            np = npshort
            np = string.gsub(np,"  np: ","")
            np = string.gsub(np,"'","")
            oldnp = np
            if fnp_title:GetInt() == 1 then
                me:SetCustomTitle(np)
            end
            if fnp_chat:GetInt() == 1 then
                luadev.RunOnClients("local enabled = GetConVar('flexnp_showinchat'):GetBool() if enabled then chat.AddText("..tag.."color_white,'"..tostring(np).."') end")
            end
        end
    end
end)
