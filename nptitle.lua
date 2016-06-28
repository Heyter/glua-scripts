--local Config = {}
--Config.TextDistance = 6

local Util = {}

Util.strOld = ""

me:SetNetData("IL", true) -- plz python

local function generateScroll(tbl, position)
	local strFinal = ""
	for i=1,position do
		strFinal = string.format("%s%s", strFinal, tbl[i])
	end

	return strFinal

	-- OMITTED: Too lazy to complete/will do later.

	--local countChar = position - Config.TextDistance
	--if countChar >= 1 then
	--	for i=1,countChar do
	--		strFinal = strFinal .. " "
	--	end
	--	return strFinal --  .. tblChars[countChar]
	--else
	--	return ""
	--end
end

function string.fullwidth(str)
	str = str:gsub("%l", function(c) return string.char(239, 189, 130 + (c:byte() - 98)) end)
	str = str:gsub("%u", function(c) return string.char(239, 188, 161 + (c:byte() - 65)) end)
	return str
end

local function CheckFile()
	local strFileData = file.Read("nowplaying.txt", "DATA")
	if strFileData ~= Util.strOld then

		if strFileData == "" then return end

		chat.AddText(Color(200, 200, 0), "[NPTitle] ", Color(200, 200, 200), Util.strOld ~= "" and Util.strOld or "none", Color(200, 0, 0), " -> ", Color(200, 200, 200), strFileData)

		Util.strOld = strFileData

		strFileData = string.gsub(strFileData, "  np: ", "")

		local tblChars = {}
		local tblTitles = {}

		strFileData:gsub( ".", function( c ) table.insert( tblChars, c ) end )

		for position, char in pairs(tblChars) do -- Let's slice open the stream to being the effect
			tblTitles[position] = generateScroll(tblChars, position)
		end

		for position, phrase in pairs(tblTitles) do -- Time to compile this bitch into a table
			tblTitles[position] = {}
			tblTitles[position][1] = phrase
			tblTitles[position][2] = (position == #tblTitles) and 10 or .1
		end

		LocalPlayer():SetCustomTitles("High Quality Radio - I only micspam high quality video game rips.")

		LocalPlayer():SetCustomTitles(tblTitles) -- DONE

	end
end

function NPTitle()
	timer.Create("NPTitlev2", 2, 0, CheckFile)
end

function MainTitle()
	Util.strOld = ""
	timer.Destroy("NPTitlev2")

	local titles = [[
	↑_         ↑
	↕ -        ↕
	↓  ¯       ↓
	↕   -      ↕
	↑    _     ↑
	↕     -    ↕
	↓      ¯   ↓
	↕       -  ↕
	↑        _ ↑
	↕         -↕
	↓        ¯ ↓
	↕       -  ↕
	↑      _   ↑
	↕     -    ↕
	↓    ¯     ↓
	↕   -      ↕
	↑  _       ↑
	↕ -        ↕ ]]

	titles = string.Explode("\n",titles)

	LocalPlayer():ConCommand("titles_clearall")
	for _,title in pairs(titles) do
		LocalPlayer():ConCommand("titles_add 0.1 "..title.."")
	end
end