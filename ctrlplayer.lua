-- INSTRUCTIONS
-- Run on SELF

if !luadev then
	MsgC(Color(255,0,0),"fuck no\n")
end

CTRLP = {}
CTRLP.Player = me
CTRLP.Controler = me
concommand.Add("ctrlp_setplayer",
	function(ply,_,args)
		if istable(args) then args = args[1] end 
		args = easylua.FindEntity(args) 
		if args == nil then 
			args = me 
		end 
		CTRLP.Player = args 
	end
) 
concommand.Add("+ctrlp_forward",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("+forward")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)
concommand.Add("-ctrlp_forward",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("-forward")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)
concommand.Add("+ctrlp_moveright",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("+moveright")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)
concommand.Add("-ctrlp_moveright",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("-moveright")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)
concommand.Add("+ctrlp_moveleft",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("+moveleft")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)
concommand.Add("-ctrlp_moveleft",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("-moveleft")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)

concommand.Add("+ctrlp_back",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("+back")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)
concommand.Add("-ctrlp_back",
	function() 
		if !IsValid(CTRLP.Player) then 
			return 
		end 
		local ei = CTRLP.Player:EntIndex()
		local code =
[[Entity(]] .. ei .. [[):ConCommand("-back")]]
		luadev.RunOnServer(code,NULL,{ply=NULL})
	end
)
local function makechat(_,_,args)
		if istable(args) then args = args[1] end
		if !args then return end
		if !isstring(args) then return end
		if string.StartWith(args,[["]]) then args = " " .. args end
		local ei = CTRLP.Player:EntIndex()
		local chat = args
		local code =
[[Entity(]] .. ei .. [[):Say(]] .. "[[" .. chat .. "]]" .. [[)]]
		luadev.RunOnServer(code,NULL,{ply=NULL})

end
local function makeccmd(_,_,args)
		if istable(args) then args = args[1] end
		if !args then return end
		if !isstring(args) then return end
		if string.StartWith(args,[["]]) then args = " " .. args end
		local ei = CTRLP.Player:EntIndex()
		local chat = args
		local code =
[[Entity(]] .. ei .. [[):ConCommand(]] .. "[[" .. chat .. "]]" .. [[)]]
		luadev.RunOnServer(code,NULL,{ply=NULL})

end
local function makepm(_,_,args)
		if istable(args) then args = args[1] end
		if !args then return end
		if !isstring(args) then return end
		if string.StartWith(args,[["]]) then args = " " .. args end
		local ei = CTRLP.Player:EntIndex()
		local chat = args
		local code =
[[Entity(]] .. ei .. [[):PrintMessage(3,]] .. "[[" .. chat .. "]]" .. [[)]]
		luadev.RunOnServer(code,NULL,{ply=NULL})

end
local function makelua(_,_,args)
		if istable(args) then args = args[1] end
		if !args then return end
		if !isstring(args) then return end
		if string.StartWith(args,[["]]) then args = " " .. args end
		local ei = CTRLP.Player:EntIndex()
		local chat = args
		
		luadev.RunOnClient(code,{Entity(ei)},NULL,{ply=NULL})

end

concommand.Add("ctrlp_chat",
	function(_,__,args) 
		makechat(_,__,args)
	end
)
concommand.Add("ctrlp_concommand",
	function(_,__,args) 
		makeccmd(_,__,args)
	end
)
concommand.Add("ctrlp_pmessage",
	function(_,__,args) 
		makepm(_,__,args)
	end
)
concommand.Add("ctrlp_luarun",
	function(_,__,args) 
		makelua(_,__,args)
	end
)

concommand.Add("ctrlp_popupchat",
	function() 
		Derma_StringRequest(
			"CTRLP Prompt",
			"Chat text?","",
			function(e) makechat(nil,nil,e) end
			,function() end,"Send","Cancel"
			)
	end
)

concommand.Add("ctrlp_popupccmd",
	function() 
		Derma_StringRequest(
			"CTRLP Prompt",
			"ConCommand?","",
			function(e) makeccmd(nil,nil,e) end
			,function() end,"Send","Cancel"
			)
	end
)
concommand.Add("ctrlp_popuppm",
	function() 
		Derma_StringRequest(
			"CTRLP Prompt",
			"Message to print?","",
			function(e) makepm(nil,nil,e) end
			,function() end,"Send","Cancel"
			)
	end
)

