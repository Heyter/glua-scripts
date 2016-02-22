local WGM = {}
net.new("WGM",WGM,"net")
:cl"ran"

if SERVER then
	hook.Add("PlayerShouldTakeDamage","WhatsGodMode?",function(pl,att)
		if pl != att and att == me then
			return true
		end
	end)
	WGM.net.ran().Broadcast()
end

if CLIENT then
	function WGM:ran()
		chat.AddText(Color(128,200,200),"Better run and hide your minge devices. ",Color(128,200,128),"WhatsGodMode ",Color(128,200,200),"is active and you will die!")
	end
end
