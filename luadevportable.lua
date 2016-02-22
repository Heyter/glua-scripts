--Luadev Portable--
module("luadev",package.seeall)

local Tag = "luadev"

local function CMD(who)
	return CLIENT and "CMD" or who or "CMD"
end

local COMMAND = concommand.Add

COMMAND('run_sv',function(ply,_,script,who)
	RunOnServer(script,CMD(who),MakeExtras(ply))
end,true)

COMMAND('run_sh',function(ply,_,script,who)
	RunOnShared(script,CMD(who),MakeExtras(ply))
end,true)

COMMAND('run_clients',function(ply,_,script,who)
	RunOnClients(script,CMD(who),MakeExtras(ply))
end,true)

COMMAND('run_self',function(ply,_,script,who)
	RunOnSelf(script,CMD(who),MakeExtras(ply))
end,true)

COMMAND('run_client',function(ply,tbl,script,who)

	if !tbl[1] or !tbl[2] then Print("Syntax: lua_run_client (steamid/userid/uniqueid/part of name) script") return end

	local cl=FindPlayer(tbl[1])

	if !cl then Print("Client not found!\n") return end
	if CLIENT then
		Print("Running script on "..tostring(cl:Name()))
	end

	local _, e = script:find('^%s*"[^"]+')
	if e then
		script = script:sub(e+2)
	else
		local _, e = script:find('^%s*[^%s]+%s')
		if not e then
			Print("Invalid Command syntax.")
			return
		end
		script = script:sub(e)
	end

	script = script:Trim()

	RunOnClient(script,cl,CMD(who),MakeExtras(ply))

end)

COMMAND('send_cl',function(ply,tbl,cmd,who)

	if !tbl[1] or !tbl[2] then Print("Syntax: lua_send_cl (steamid/userid/uniqueid/part of name) \"path\"") return end

	local cl=FindPlayer(tbl[1])

	if !cl then Print("Client not found!\n") return end
	Print("Running script on "..tostring(cl:Name()))


	table.remove(tbl,1)
	local path=TableToString(tbl)

	local Path,searchpath=RealFilePath(path)
	if !Path then Print("Could not find the file\n") return end

	local content = Path and GiveFileContent(Path,searchpath)
	if !content then Print("Could not read the file\n") return end

	RunOnClient(content,cl,who or CMD(who),MakeExtras(ply))

end)

COMMAND('send_sv',function(ply,c,cmd,who)

	local Path,searchpath=RealFilePath(c[2] and TableToString(c) or c[1])
	if !Path then Print("Could not find the file\n") return end

	local content = Path and GiveFileContent(Path,searchpath)
	if !content then Print("Could not read the file\n") return end

	local who=string.GetFileFromFilename(Path)

	RunOnServer(content,who or CMD(who),MakeExtras(ply))

end)

COMMAND('send_clients',function(ply,c,cmd,who)

	local Path,searchpath=RealFilePath(c[2] and TableToString(c) or c[1])
	if !Path then Print("Could not find the file\n") return end

	local content = Path and GiveFileContent(Path,searchpath)
	if !content then Print("Could not read the file\n") return end

	local who=string.GetFileFromFilename(Path)

	RunOnClients(content,who or CMD(who),MakeExtras(ply))

end)

COMMAND('send_sh',function(ply,c,cmd,who)

	local Path,searchpath=RealFilePath(c[2] and TableToString(c) or c[1])
	if !Path then Print("Could not find the file\n") return end

	local content = Path and GiveFileContent(Path,searchpath)
	if !content then Print("Could not read the file\n") return end

	local who=string.GetFileFromFilename(Path)

	RunOnShared(content,who or CMD(who),MakeExtras(ply))

end)


local PAYLOAD_SV=([===================[
local __SWP__=[[SWEPNAME]]
local SWEP,_REG_=weapons.GetStored(__SWP__),nil
if not SWEP then
	SWEP = {Primary={}, Secondary={},Base = "weapon_base",ClassName = __SWP__}
	_REG_ = true
end

CONTENT

if _REG_ and SWEP then
	weapons.Register(SWEP, __SWP__, true)
end
]===================]):gsub("\n"," ")
local PAYLOAD_CL=([===================[
local __SWP__=[[SWEPNAME]]
local SWEP,_REG_=weapons.GetStored(__SWP__),nil
if not SWEP then
	SWEP = {Primary={}, Secondary={},Base = "weapon_base",ClassName = __SWP__}
	_REG_ = true
end

CONTENT

if _REG_ and SWEP then
	weapons.Register(SWEP, __SWP__, true)
end
]===================]):gsub("\n"," ")
local PAYLOAD_SH=([===================[
local __SWP__=[[SWEPNAME]]
local SWEP,_REG_=weapons.GetStored(__SWP__),nil
if not SWEP then
	SWEP = {Primary={}, Secondary={},Base = "weapon_base",ClassName = __SWP__}
	_REG_ = true
end

CONTENT

if _REG_ and SWEP then
	local table_ForEach=table.ForEach table.ForEach=function()end timer.Simple(0,function() table.ForEach=table_ForEach end)
		weapons.Register(SWEP, __SWP__, true)
	table.ForEach=table_ForEach
end
]===================]):gsub("\n"," ")

local function SendSWEP(cl,sh,sv,Path,ply,c,cmd,who)
	local who=string.GetFileFromFilename(Path)

	local swepname=string.GetFileFromFilename(Path):gsub("%.lua","")
	print("SendSWEP",swepname,cl and #cl,sh and #sh,sv and #sv)

	if cl then
		cl = PAYLOAD_CL:gsub("CONTENT",cl):gsub("SWEPNAME",swepname)
		RunOnClients(cl,who or CMD(who),MakeExtras(ply))
	end
	if sh then
		sh = PAYLOAD_SH:gsub("CONTENT",sh):gsub("SWEPNAME",swepname)
		RunOnShared(sh,who or CMD(who),MakeExtras(ply))
	end
	if sv then
		sv = PAYLOAD_SV:gsub("CONTENT",sv):gsub("SWEPNAME",swepname)
		RunOnServer(sv,who or CMD(who),MakeExtras(ply))
	end

end

COMMAND('send_wep',function(ply,c,cmd,who)
	local path = c[2] and TableToString(c) or c[1]

	local Path,searchpath=RealFilePath(path)
	if not Path then
		Print("Could not find the file\n")
		return
	end

	local content = GiveFileContent(Path,searchpath)
	if content then
		local sh = content
		SendSWEP(nil,sh,nil,Path,ply,c,cmd,who)
		return
	end

	local cl = GiveFileContent(Path..'/cl_init.lua',searchpath)
	local sh = GiveFileContent(Path..'/shared.lua',searchpath)
	local sv = GiveFileContent(Path..'/init.lua',searchpath)

	if sv or sh or cl then
		SendSWEP(cl,sh,sv,Path,ply,c,cmd,who)
		return
	else
		Print("Could not find required files from the folder\n")
	end

end)





-- entity
local PAYLOAD=([===================[
local _ENT_=[[ENTNAME]]
local ENT,_REG_=scripted_ents.GetStored(_ENT_),nil
if not ENT then
	ENT = {ClassName=_ENT_}
	_REG_ = true
end

CONTENT

if ENT then
	ENT.Model = ENT.Model or Model("models/props_borealis/bluebarrel001.mdl")
	if not ENT.Base then
		ENT.Base = "base_anim"
		ENT.Type = ENT.Type or "anim"
	end
	local table_ForEach=table.ForEach table.ForEach=function()end timer.Simple(0,function() table.ForEach=table_ForEach end)
		scripted_ents.Register(ENT, _ENT_)
	table.ForEach=table_ForEach
end

]===================]):gsub("\n"," "):gsub("\t\t"," "):gsub("  "," "):gsub("  "," ")

local function SendENT(cl,sh,sv,Path,ply,c,cmd,who)
	local who=string.GetFileFromFilename(Path)

	local entname=string.GetFileFromFilename(Path):gsub("%.lua","")
	print("SendENT",entname,cl and #cl,sh and #sh,sv and #sv)

	if cl then
		cl = PAYLOAD:gsub("CONTENT",cl):gsub("ENTNAME",entname)
		RunOnClients(cl,who or CMD(who),MakeExtras(ply))
	end
	if sh then
		sh = PAYLOAD:gsub("CONTENT",sh):gsub("ENTNAME",entname)
		RunOnShared(sh,who or CMD(who),MakeExtras(ply))
	end
	if sv then
		sv = PAYLOAD:gsub("CONTENT",sv):gsub("ENTNAME",entname)
		RunOnServer(sv,who or CMD(who),MakeExtras(ply))
	end

end

COMMAND('send_ent',function(ply,c,cmd,who)
	local path = c[2] and TableToString(c) or c[1]

	local Path,searchpath=RealFilePath(path)
	if not Path then
		Print("Could not find the file\n")
		return
	end

	local content = GiveFileContent(Path,searchpath)
	if content then
		local sh = content
		SendENT(nil,sh,nil,Path,ply,c,cmd,who)
		return
	end

	local cl = GiveFileContent(Path..'/cl_init.lua',searchpath)
	local sh = GiveFileContent(Path..'/shared.lua',searchpath)
	local sv = GiveFileContent(Path..'/init.lua',searchpath)

	if sv or sh or cl then
		SendENT(cl,sh,sv,Path,ply,c,cmd,who)
		return
	else
		Print("Could not find required files from the folder\n")
	end

end)



COMMAND('send_self',function(ply,c,cmd,who)

	local Path,searchpath=RealFilePath(c[2] and TableToString(c) or c[1])
	if !Path then Print("Could not find the file\n") return end

	local content = GiveFileContent(Path,searchpath)
	if !content then Print("Could not read the file\n") return end

	local who=string.GetFileFromFilename(Path)

	RunOnSelf(content,who or CMD(who),MakeExtras(ply))

end)


if SERVER then return end

net.Receive(Tag,function(...) _ReceivedData(...) end)

function _ReceivedData(len)

	local script = ReadCompressed()
	local decoded=net.ReadTable()

	local info=decoded.info
	local extra=decoded.extra

	local ok,err = Run(script,tostring(info),extra)

	-- no callback system yet
	if not ok then
		ErrorNoHalt(tostring(err)..'\n')
	end

end


function ToServer(data)
	if TransmitHook and TransmitHook(data)~=nil then return end

	net.Start(Tag)
		WriteCompressed(data.src or "")

		-- clear extra data
		data.src = nil
		if data.extra then
			data.extra.ply = nil
			if table.Count(data.extra)==0 then data.extra=nil end
		end

		net.WriteTable(data)
	net.SendToServer()
end


function RunOnClients(script,who,extra)

	if not who and extra and isentity(extra) then extra = {ply=extra} end

	local data={
		src=script,
		dst=TO_CLIENTS,
		info=who,
		extra=extra,
	}

	return ToServer(data)

end


function RunOnSelf(script,who,extra)
	if not isstring(who) then who = nil end
	if not who and extra and isentity(extra) then extra = {ply=extra} end

	return RunOnClient(script,LocalPlayer(),who,extra)
end

function RunOnClient(script,targets,who,extra)
	-- compat
		if not targets and isentity(who) then
			targets=who
			who = nil
		end

		if extra and isentity(extra) and who==nil then extra={ply=extra} end

	if (not istable(targets) and !IsValid(targets))
	or (istable(targets) and table.Count(targets)==0)
	then error"Invalid player(s)" end

	local data={
		src=script,
		dst=TO_CLIENT,
		dst_ply=targets,
		info=who,
		extra=extra,
	}

	return ToServer(data)

end

function RunOnServer(script,who,extra)
	if not who and extra and isentity(extra) then extra = {ply=extra} end

	local data={
		src=script,
		dst=TO_SERVER,
		--dst_ply=pl
		info=who,
		extra=extra,
	}
	return ToServer(data)

end

function RunOnShared(script,who,extra)
	if not who and extra and isentity(extra) then extra = {ply=extra} end

	local data={
		src=script,
		dst=TO_SHARED,
		--dst_ply=pl
		info=who,
		extra=extra,
	}

	return ToServer(data)

end

chat.AddText(Color(100,200,200),"[Luadev]",color_white,"Luadev Portable ran successfully")

--Socketdev--

if not luadev then
	print"nah"
	return
end

hook.Remove("Think", "LuaDev-Socket") -- upvalues will be lost

collectgarbage()
collectgarbage() -- finalizers will be scheduled for execution in the first pass, but will only execute in the second pass

local ok, why
if #file.Find("lua/bin/gmcl_luasocket*.dll", "GAME") > 0 then
	ok, why = pcall(require, "luasocket")
else
	why = "File not found"
end

if not ok then
	print(("\n\n\n\nUnable to load luasocket module (%s), LuaDev socket API will be unavailable\n\n\n\n"):format(tostring(why)))
	return
end

local sock = socket.tcp()
assert(sock:bind("127.0.0.1", 27099))
sock:settimeout(0)
assert(sock:listen(0))

local methods = {
	self = luadev.RunOnSelf,
	sv = luadev.RunOnServer,
	sh = luadev.RunOnShared,
	cl = luadev.RunOnClients,
	ent = function(contents, who)
		contents = "ENT = {}; local ENT=ENT; " .. contents .. "; scripted_ents.Register(ENT, '" .. who:sub(0, -5) .. "')"
		luadev.RunOnShared(contents, who)
	end,
	client = luadev.RunOnClient,
}

hook.Add("Think", "LuaDev-Socket", function()
	local cl, a, b, c = sock:accept()
	if cl then
		system.FlashWindow()

		if cl:getpeername() ~= "127.0.0.1" then
			print("Refused", cl:getpeername())
			cl:shutdown()
			return
		end

		cl:settimeout(0)

		local method = cl:receive("*l")
		local who = cl:receive("*l")

		if method and methods[method] then
			if method == "client" then
				local to = cl:receive("*l")
				local contents = cl:receive("*a")
				methods[method](contents, {easylua and easylua.FindEntity(to) or player.GetByID(tonumber(to))}, who)
			else
				local contents = cl:receive("*a")
				methods[method](contents, who)
			end
		end
		cl:shutdown()
	end
end)

chat.AddText(Color(100,200,200),"[Luadev]",color_white,"Socketdev ran successfully")

--Easylua--

easylua = {} local s = easylua

local function compare(a, b)

	if a == b then return true end
	if a:find(b, nil, true) then return true end
	if a:lower() == b:lower() then return true end
	if a:lower():find(b:lower(), nil, true) then return true end

	return false
end

local function comparenick(a, b)
	local MatchTransliteration = GLib and GLib.UTF8 and GLib.UTF8.MatchTransliteration
	if not MatchTransliteration then return compare (a, b) end

	if a == b then return true end
	if a:lower() == b:lower() then return true end
	if MatchTransliteration(a, b) then return true end

	return false
end

local function compareentity(ent, str)
	if ent.GetName and compare(ent:GetName(), str) then
		return true
	end

	if ent:GetModel() and compare(ent:GetModel(), str) then
		return true
	end

	return false
end

if CLIENT then
	function easylua.PrintOnServer(...)
		local args = {...}
		local new = {}

		for key, value in pairs(args) do
			table.insert(new, luadata and luadata.ToString(value) or tostring(value))
		end

		RunConsoleCommand("easylua_print", unpack(new))
	end
end

function easylua.Print(...)
	if CLIENT then
		easylua.PrintOnServer(...)
	end
	if SERVER then
		local args = {...}
		local str = ""

		Msg(string.format("[EasyLua %s] ", IsValid(me) and me:Nick() or "Sv"))

		for key, value in pairs(args) do
			str = str .. type(value) == "string" and value or luadata.ToString(value) or tostring(value)

			if key ~= #args then
				str = str .. ","
			end
		end

		print(str)
	end
end

if SERVER then
	function easylua.CMDPrint(ply, cmd, args)
		args = table.concat(args, ", ")

		Msg(string.format("[EasyLua %s] ", IsValid(ply) and ply:Nick() or "Sv"))
		print(args)
	end

	concommand.Add("easylua_print", easylua.CMDPrint)
end

function easylua.FindEntity(str)
	if not str then return NULL end

	str = tostring(str)

	if str == "#this" and IsEntity(this) and this:IsValid() then
		return this
	end

	if str == "#me" and IsEntity(me) and me:IsPlayer() then
		return me
	end

	if str == "#all" then
		return all
	end

	if str == "#randply" then
		return table.Random(player.GetAll())
	end

	if str:sub(1,1) == "#" then
		local str = str:sub(2)

		if #str > 0 then
			str = str:lower()
			local found
			for key, data in pairs(team.GetAllTeams()) do
				if data.Name:lower() == str then
					found = data.Name:lower()
					break
				end
			end

			if not found then
				local classes = {}

				for key, ent in pairs(ents.GetAll()) do
					classes[ent:GetClass():lower()] = true
				end

				for class in pairs(classes) do
					if class:lower() == str then
						print("found", class)
						found = class
					end
				end
			end

			if found then
				local func = CreateAllFunction(function(v) return v:GetClass():lower() == class end)
				print(func:GetName())
				return func
			end
		end
	end

	-- unique id
	local ply = player.GetByUniqueID(str)
	if ply and ply:IsPlayer() then
		return ply
	end

	-- steam id
	if str:find("STEAM") then
		for key, _ply in pairs(player.GetAll()) do
			if _ply:SteamID() == str then
				return _ply
			end
		end
	end

	if str:sub(1,1) == "_" and tonumber(str:sub(2)) then
		str = str:sub(2)
	end

	if tonumber(str) then
		ply = Entity(tonumber(str))
		if ply:IsValid() then
			return ply
		end
	end

	-- community id
	if #str == 17 then

	end

	-- ip
	if SERVER then
		if str:find("%d+%.%d+%.%d+%.%d+") then
			for key, _ply in pairs(player.GetAll()) do
				if _ply:IPAddress():find(str) then
					return _ply
				end
			end
		end
	end
	-- search in sensible order

	-- search exact
	for _,ply in pairs(player.GetAll()) do
		if ply:Nick()==str then
			return ply
		end
	end

	-- Search bots so we target those first
	for key, ply in pairs(player.GetBots()) do
		if comparenick(ply:Nick(), str) then
			return ply
		end
	end

	-- search from beginning of nick
	for _,ply in pairs(player.GetHumans()) do
		if ply:Nick():lower():find(str,1,true)==1 then
			return ply
		end
	end

	-- Search normally and search with colorcode stripped
	for key, ply in pairs(player.GetAll()) do
		if comparenick(ply:Nick(), str) then
			return ply
		end
		if comparenick(ply:Nick():gsub("%^%d", ""), str) then
			return ply
		end
	end

	for key, ent in pairs(ents.GetAll()) do
		if compareentity(ent, str) then
			return ent
		end
	end

	do -- class

		local _str, idx = str:match("(.-)(%d+)$")
		if idx then
			idx = tonumber(idx)
			str = _str
		else
			str = str
			idx = (me and me.easylua_iterator) or 0
		end

		local found = {}

		for key, ent in pairs(ents.GetAll()) do
			if compare(ent:GetClass(), str) then
				table.insert(found, ent)
			end
		end

		return found[math.Clamp(idx%#found, 1, #found)] or NULL
	end
end

function easylua.CreateEntity(class, callback)
	local mdl = "error.mdl"

	if IsEntity(class) and class:IsValid() then
		this = class
	elseif class:find(".mdl", nil, true) then
		mdl = class
		class = "prop_physics"

		this = ents.Create(class)
		this:SetModel(mdl)
	else
		this = ents.Create(class)
	end

	if callback and type(callback) == 'function' then
		callback(this);
	end

	this:Spawn()
	this:SetPos(there + Vector(0,0,this:BoundingRadius() * 2))
	this:DropToFloor()
	this:PhysWake()

	undo.Create(class)
		undo.SetPlayer(me)
		undo.AddEntity(this)
	undo.Finish()

	return this
end

function easylua.CopyToClipboard(var, ply)
	ply = ply or me
	if luadata then
		local str = luadata.ToString(var)

		if not str and IsEntity(var) and var:IsValid() then
			if var:IsPlayer() then
				str = string.format("player.GetByUniqueID(--[[%s]] %q)", var:GetName(), var:UniqueID())
			else
				str = string.format("Entity(%i)", var:EntIndex())
			end

		end

		if CLIENT then
			SetClipboardText(str)
		end

		if SERVER then
			local str = string.format("SetClipboardText(%q)", str)
			if #str > 255 then
				if luadev and luadev.RunOnClient then
					luadev.RunOnClient(str, ply)
				else
					error("Text too long to send and luadev not found",1)
				end
			else
				ply:SendLua(str)
			end
		end
	end
end


local started = false
function easylua.Start(ply)
	if started then
		Msg"[EasyLua] "print("Session not ended for ",_G.me or (s.vars and s.vars.me),", restarting session for",ply)
		easylua.End()
	end
	started = true

	ply = ply or CLIENT and LocalPlayer() or nil

	if not ply or not IsValid(ply) then return end

	local vars = {}
		local trace = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 10000, {ply, ply:GetVehicle()})

		if trace.Entity:IsWorld() then
			trace.Entity = NULL
		end

		vars.me = ply
		vars.this = trace.Entity
		vars.wep = ply:GetActiveWeapon()
		vars.veh = ply:GetVehicle()

		vars.we = {}

		for k, v in pairs(ents.FindInSphere(ply:GetPos(), 512)) do
			if v:IsPlayer() then
				table.insert(vars.we, v)
			end
		end

		vars.there = trace.HitPos
		vars.here = trace.StartPos
		vars.dir = ply:GetAimVector()

		vars.trace = trace
		vars.length = trace.StartPos:Distance(trace.HitPos)

		vars.copy = s.CopyToClipboard
		vars.create = s.CreateEntity
		vars.prints = s.PrintOnServer

		if vars.this:IsValid() then
			vars.phys = vars.this:GetPhysicsObject()
			vars.model = vars.this:GetModel()
		end

		vars.E = s.FindEntity
		vars.last = ply.easylua_lastvars


		s.vars = vars
		local old_G={}
		s.oldvars=old_G

	for k,v in pairs(vars) do old_G[k]=_G[k] _G[k] = v end

	-- let this gc. maybe allow few more recursions.
	if vars.last and istable(vars.last) then vars.last.last = nil end

	ply.easylua_lastvars = vars
	ply.easylua_iterator = (ply.easylua_iterator or 0) + 1
end

function easylua.End()
	if not started then
		Msg"[EasyLua] "print"Ending session without starting"
	end
	started = false

	if s.vars then
		for key, value in pairs(s.vars) do
			if s.oldvars and s.oldvars[key] then
				_G[key] = s.oldvars[key]
			else
				_G[key] = nil
			end
		end
	end
end

do -- env meta
	local META = {}

	local _G = _G
	local easylua = easylua
	local tonumber = tonumber

	local nils={
		["CLIENT"]=true,
		["SERVER"]=true,
	}
	function META:__index(key)
		local var = _G[key]

		if var ~= nil then
			return var
		end

		if not nils [key] then -- uh oh
			var = easylua.FindEntity(key)
			if var:IsValid() then
				return var
			end
		end

		return nil
	end

	function META:__newindex(key, value)
		_G[key] = value
	end

	easylua.EnvMeta = setmetatable({}, META)
end

function easylua.RunLua(ply, code, env_name)
	local data =
	{
		error = false,
		args = {},
	}

	easylua.Start(ply)
		local header = ""

		for key, value in next,(s.vars or {}) do
			header = header .. string.format("local %s = %s ", key, key)
		end

		code = header .. "; " .. code

		env_name = env_name or string.format("%s", tostring(
			IsValid(ply) and ply:IsPlayer()
				and	"["..ply:SteamID():gsub("STEAM_","").."]"..ply:Name()
				or ply))

		data.env_name = env_name

		local func = CompileString(code, env_name, false)

		if type(func) == "function" then
			setfenv(func, easylua.EnvMeta)

			local args = {pcall(func)}

			if args[1] == false then
				data.error = args[2]
			end

			table.remove(args, 1)
			data.args = args
		else
			data.error = func
		end
	easylua.End()

	return data
end

-- legacy luadev compatibility

local	STAGE_PREPROCESS=1
local	STAGE_COMPILED=2
local	STAGE_POST=3

local insession = false
hook.Add("LuaDevProcess","easylua",function(stage,script,info,extra,func)
	if stage==STAGE_PREPROCESS then

		if insession then
			insession=false
			easylua.End()
		end

		if not istable(extra) or not IsValid(extra.ply) or not script or extra.easylua==false then
			return
		end

		insession = true
		easylua.Start(extra.ply)

		local t={}
		for key, value in pairs(easylua.vars or {}) do
			t[#t+1]=key
		end
		if #t>0 then
			script=' local '..table.concat(t,", ")..' = '..table.concat(t,", ")..' ; '..script
		end

		--ErrorNoHalt(script)
		return script

	elseif stage==STAGE_COMPILED then

		if not istable(extra) or not IsValid(extra.ply) or not isfunction(func) or extra.easylua==false then
			if insession then
				insession=false
				easylua.End()
			end
			return
		end

		if insession then
			local env = getfenv(func)
			if not env or env==_G then
				setfenv(func, easylua.EnvMeta)
			end
		end

	elseif stage == STAGE_POST and insession then
		insession=false
		easylua.End()
	end
end)

function easylua.StartWeapon(classname)
	_G.SWEP = {
		Primary = {},
		Secondary = {},
		ViewModelFlip = false,
	}

	SWEP.Base = "weapon_base"

	SWEP.ClassName = classname
end

function easylua.EndWeapon(spawn, reinit)
	if not SWEP then error"missing SWEP" end
	if not SWEP.ClassName then error"missing classname" end

	weapons.Register(SWEP, SWEP.ClassName, true)

	for key, entity in pairs(ents.FindByClass(SWEP.ClassName)) do
		if entity:GetTable() then table.Merge(entity:GetTable(), SWEP) end
		if reinit then
			entity:Initialize()
		end
	end

	if SERVER and spawn then
		SafeRemoveEntity(me:GetWeapon(SWEP.ClassName))
		local me = me
		local class = SWEP.ClassName
		timer.Simple(0.2, function() if me:IsPlayer() then me:Give(class) end end)
	end

	SWEP = nil
end

function easylua.StartEntity(classname)
	_G.ENT = {}

	ENT.ClassName = classname or "no_ent_name_" .. me:Nick() .. "_" .. me:UniqueID()
end

function easylua.EndEntity(spawn, reinit)

	ENT.Model = ENT.Model or Model("models/props_borealis/bluebarrel001.mdl")

	if not ENT.Base then -- there can be Base without Type but no Type without base without redefining every function so um
		ENT.Base = "base_anim"
		ENT.Type = ENT.Type or "anim"
	end

	scripted_ents.Register(ENT, ENT.ClassName, true)

	for key, entity in pairs(ents.FindByClass(ENT.ClassName)) do
		table.Merge(entity:GetTable(), ENT)
		if reinit then
			entity:Initialize()
		end
	end

	if SERVER and spawn then
		create(ENT.ClassName)
	end

	ENT = nil
end

do -- all
	local META = {}

	function META:__index(key)
		return function(_, ...)
			local args = {}

			for _, ent in pairs(ents.GetAll()) do
				if (not self.func or self.func(ent)) then
					if type(ent[key]) == "function" or ent[key] == "table" and type(ent[key].__call) == "function" and getmetatable(ent[key]) then
						table.insert(args, {ent = ent, args = (ent[key](ent, ...))})
					else
						ErrorNoHalt("attempt to call field '" .. key .. "' on ".. tostring(ent) .." a " .. type(ent[key]) .. " value\n")
					end
				end
			end

			return args
		end
	end

	function META:__newindex(key, value)
		for _, ent in pairs(ents.GetAll()) do
			if not self.func or self.func(ent) then
				ent[key] = value
			end
		end
	end

	function CreateAllFunction(func)
		return setmetatable({func = func}, META)
	end

	all = CreateAllFunction(function(v) return v:IsPlayer() end)
	props = CreateAllFunction(function(v) return v:GetClass() == "prop_physics" end)
	-- props = CreateAllFunction(function(v) return util.IsValidPhysicsObject(vm) end)
	bots = CreateAllFunction(function(v) return v:IsPlayer() and v:IsBot() end)
	these = CreateAllFunction(function(v) return easylua and table.HasValue(constraint.GetAllConstrainedEntities(this), v) end)
end

chat.AddText(Color(100,200,200),"[Luadev]",color_white,"Easylua ran successfully")
