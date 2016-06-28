--[[
███████╗██╗     ███████╗██╗  ██╗██████╗  ██████╗ ██╗  ██╗
██╔════╝██║     ██╔════╝╚██╗██╔╝██╔══██╗██╔═══██╗╚██╗██╔╝
█████╗  ██║     █████╗   ╚███╔╝ ██████╔╝██║   ██║ ╚███╔╝ 
██╔══╝  ██║     ██╔══╝   ██╔██╗ ██╔══██╗██║   ██║ ██╔██╗ 
██║     ███████╗███████╗██╔╝ ██╗██████╔╝╚██████╔╝██╔╝ ██╗
╚═╝     ╚══════╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝          
featuring
                                                                                                        
 _     _                .                  .            _            
 `.   /    ___    __.  _/_   `   ___       /       ___  \ ___    ____
   \,'    /   ` .'   \  |    | .'   `      |      /   ` |/   \  (    
  ,'\    |    | |    |  |    | |           |     |    | |    `  `--. 
 /   \   `.__/|  `._.'  \__/ /  `._.'      /---/ `.__/| `___,' \___.'
		   - Security is our priority -
                                                                   

This code is copyrighted by Flex. You are not allowed to redistribute.
--]]

local META = FindMetaTable("Player")

function META:GetMoney()
	if SERVER then 
	if tonumber(self:GetPData("fbox_player_money",100)) < 0 then self:SetPData("fbox_player_money",0) end
	self:SetNWInt("fbox_money", self:GetPData("fbox_player_money")) end
	return tonumber(self:GetNWInt("fbox_money"))
end

function META:CanAfford(price)
	return price <= self:GetMoney()
end

function META:TransferMoney(ply,num)
	if ply:IsBot() or not ply:IsPlayer() or ply == self then return false end
	if self:GetMoney() < num then num = self:GetMoney() end
	
	if SERVER then
	if num <= 0 then return false end
	self:TakeMoney(num)
	ply:GiveMoney(num)
	end
	hook.Run("fbox_transfermoney", self,ply,num)
end

function META:SetMoney(num)
	if SERVER then 
	self:SetPData("fbox_player_money",num)
	self:SetNWInt("fbox_money", self:GetPData("fbox_player_money")) 
	end
	hook.Run("fbox_setmoney", self,num)
end

function META:GiveMoney(num)
	if SERVER then 
	self:SetPData("fbox_player_money",self:GetPData("fbox_player_money", 100) + num )
	self:SetNWInt("fbox_money", self:GetPData("fbox_player_money")) 
	end
	hook.Run("fbox_givemoney", self,num)
end

function META:TakeMoney(num)
	if SERVER then
	if self:GetMoney() < 0 then return end
	self:SetPData("fbox_player_money",self:GetPData("fbox_player_money",100) - num )
	self:SetNWInt("fbox_money", self:GetPData("fbox_player_money"))
	self:GetMoney()
	end
	hook.Run("fbox_takemoney", self,num)
end

function META:SaveMoney()
	self:SetPData("fbox_player_money", self:GetPData("fbox_player_money")) --useless code but yolo
end

function META:LoadMoney()
	if SERVER then self:SetNWInt("fbox_money", self:GetPData("fbox_player_money")) end
end

function META:Katching()
sound.Play("chatsounds/autoadd/dota2/buy.ogg",self:GetPos())
end

hook.Add("PlayerDisconnected","fbox_money_save",function(ply)
if CLIENT then return end
	ply:SaveMoney()
	MsgN("Money saved for disconnected player: "..ply:Name())
end)

hook.Add("PlayerInitialSpawn","fbox_money_load",function(ply)
	ply:LoadMoney()
end)

hook.Add("PlayerInitialSpawn","fbox_money_firstjoin",function(ply)

	if !ply:GetPData("fboxhasjoined") then
		ply:SetPData("fboxhasjoined", true)
		ply:GiveMoney(500)
	end
end)

hook.Add("PlayerDeath","fbox_money_death_reward",function(vic,wep,att)
	if vic == att then return
	elseif vic:IsAFK() then
		att:PrintMessage(3,"You got no money as "..vic:GetName().." is AFK.")
		return false
	elseif vic:IsBot() then 
		att:PrintMessage(3,"You got no money as "..vic:GetName().." is a BOT.")
		return false
	elseif not att:IsPlayer() then return
	elseif att:IsBot() then return --bots dont need money, they are slaves.
	elseif vic:IsWeapon() then return --Just because i love this function.
	elseif att:HasGodMode() then 
	att:PrintMessage(3,"You killed "..vic:Name().." but did not receive any money because you are in Godmode.")
	return
	end
	local value = math.Round(math.Rand(40,120))
	if value > tonumber(vic:GetMoney()) and tonumber(vic:GetMoney()) >= 0 then value = tonumber(vic:GetMoney()) end
	
	if tonumber(vic:GetMoney()) <= 0 then att:PrintMessage(3,"You got no money as "..vic:Name().." had no money on him") vic:PrintMessage(3,att:Name().." killed you but you had no money on you") return end
	att:PrintMessage(3,"You killed "..vic:Name().." and recieved $"..value)
	att:GiveMoney(value)
	vic:TakeMoney(value)
	vic:PrintMessage(3,att:Name().." killed you and received $"..value)

end)

hook.Add("fbox_transfermoney","fbox_transfermoney_notice",function(sender,receiver,num)
sender:PrintMessage(3,"You gave "..receiver:GetName().." $"..num)
reciever:PrintMessage(3,sender:GetName().." gave you :money:$"..num)
receiver:Katching()
sender:Katching()
end)
hook.Add("fbox_givemoney","fbox_givemoney",function(ply,num)
ply:Katching()
end)
hook.Add("fbox_takemoney","fbox_takemoney",function(ply,num)
ply:Katching()
end)
hook.Add("fbox_setmoney","fbox_setmoney",function(ply,num)
ply:Katching()
end)



if SERVER then //Commands
aowl.AddCommand("transfermoney", function(ply,line,target)
	target = easylua.FindEntity(target)
	local amount = tonumber(string.sub(line,string.find(line,",")+1))
	if not isnumber(amount) or not IsValid(target) then Fply:PrintMessage(3,"Invalid target or amount") return end
	ply:TransferMoney(target,amount)
end, "players")
aowl.AddCommand("givemoney", function(ply,line,target)
	target = easylua.FindEntity(target)
	local amount = tonumber(string.sub(line,string.find(line,",")+1))
	if not isnumber(amount) or not IsValid(target) then ply:PrintMessage(3,"Invalid target or amount") return end
	target:GiveMoney(amount)
end, "developers")
aowl.AddCommand("takemoney", function(ply,line,target)
	target = easylua.FindEntity(target)
	local amount = tonumber(string.sub(line,string.find(line,",")+1))
	if not isnumber(amount) or not IsValid(target) then ply:PrintMessage(3,"Invalid target or amount") return end
	target:TakeMoney(amount)
end, "developers")
aowl.AddCommand("setmoney", function(ply,line,target)
	target = easylua.FindEntity(target)
	local amount = tonumber(string.sub(line,string.find(line,",")+1))
	if not isnumber(amount) or not IsValid(target) then ply:PrintMessage(3,"Invalid target or amount") return end
	target:SetMoney(amount)
end, "developers")
end

hook.Add("OnNPCKilled","Zomberino",function( npc,att, infl)
if npc:GetClass() == "npc_zombie" and att:IsPlayer() and not att:HasGodMode() then
	amount = math.random(10,100)
	att:GiveMoney(amount)
end
end)