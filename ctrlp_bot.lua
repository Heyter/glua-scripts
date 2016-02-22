// RUN ON CLIENTSIDE

if !CLIENT then return end

if !luadev then
	MsgC(Color(255,0,0),"fuck no\n")
end

CTRLP = {}
CTRLP.Player = LocalPlayer()
concommand.Add("ctrlp_setplayer",
	function(ply,_,args)
		if istable(args) then args = args[1] end 
		args = easylua.FindEntity(args) 
		if args == nil then 
			args = LocalPlayer()
		else
			if !args:IsBot() then
				MsgC(Color(255,0,0),"[CTRLP BOT] Cannot choose players.")
				CTRLP.Player = LocalPlayer()
			end
		end 

		CTRLP.Player = args 
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



concommand.Add("ctrlp_chat",
	function(_,__,args) 
		makechat(_,__,args)
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