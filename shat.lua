
local silence = {"", ""} -- fill with 2 ""s to not say last 2

local me = LocalPlayer()
local p = printh and printh.shat or (function(a) chat.AddText('shat '..tostring(a)) end)

local function getnum(word,list)
	local t = chatsounds.SortedListKeys[word]

	local uniquepaths = {}
	for key,list in next,t do
		if key=='key' then continue end
		for k,v in next,list do
			uniquepaths[v.path or '']=true
		end
	end
	if table.Count(uniquepaths)==1 then return end

	local x = 1
	local left
	local right
	local listnum
	for k,v in next,t do
		if k=='key' then continue end
		local size = #v

		left = x
		right = x+(size-1)

		if k==list then
			listnum = math.random(left,right)
		end

		x = right+1
	end

	if x<=2 then return false end
	return listnum
end

local function doshat()
	p'loading'
	--chatsounds.List = {}
	local List = {}
	for k,v in next,chatsounds.SortedList do
		local key = ''
		for kk,vv in next,v do
			if kk=='key' then
				key=vv
			end
		end

		for kk,vv in next,v do
			if kk=='key' then continue end

			if not List[kk] then List[kk] = {} end

			local l = List[kk]
			l[#l+1] = key

		end
	end

	local lastc hook.Add('PostChatSound','shat',function(c) if c.ply!=me then return end lastc=c.key end)
	function shat(oh)
		local key = oh or _G.SHAT
		if not key then
			if not lastc then p'no last key' return false end

			local lists = {}
			for k,v in next,chatsounds.SortedListKeys[lastc] do
				if k!='key' then lists[#lists+1]=k end
			end

			key = lists[math.random(1,#lists)]
		end

		local tries = 0
		local str
		repeat
			local word = table.Random(List[key])
			local num = getnum(word,key)
			str = word..(num and ('#'..tostring(num)) or '')

			if #List[key] <= #silence then break end

			tries = tries + 1
			if tries>100 then error"can't find shat" return false end
		until (not table.HasValue(silence, str)) -- and (#str<128)

		Say(str)

		table.remove(silence, 1)
		silence[#silence+1] = str

		return str
	end

end // doshat

hook.Add('ChatsoundsUpdated','shat',function()
	doshat()
end)
if chatsounds and chatsounds.SortedList then doshat() end
