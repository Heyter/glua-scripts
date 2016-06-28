local PlayerColors = {
	["0"]  = Color(0,0,0),
	["1"]  = Color(128,128,128),
	["2"]  = Color(192,192,192),
	["3"]  = Color(255,255,255),
	["4"]  = Color(0,0,128),
	["5"]  = Color(0,0,255),
	["6"]  = Color(0,128,128),
	["7"]  = Color(0,255,255),
	["8"]  = Color(0,128,0),
	["9"]  = Color(0,255,0),
	["10"] = Color(128,128,0),
	["11"] = Color(255,255,0),
	["12"] = Color(128,0,0),
	["13"] = Color(255,0,0),
	["14"] = Color(128,0,128),
	["15"] = Color(255,0,255),
	["16"] = Color(199, 76, 58),
	["17"] = Color(127, 0, 95),
}

local ColorModifiers = { 	-- a bit shitty
	function( txt )			-- ^N modifier
		local Colors = {}

		for before, n, s in txt:gmatch("(.-)%^(%d+)([^%^]+)") do -- before is the string before the modifier and s is the string after it
			if PlayerColors[ n ] then

				if before != "" then
					table.insert( Colors, before )
				end

				table.insert( Colors, PlayerColors[n] )
				table.insert( Colors, s )
			end
		end

		return Colors
	end,
	function( txt )			-- <color> modifier
		local Modifier, Colors = "<color=%s*(%d*)%s*,?%s*(%d*)%s*,?%s*(%d*)%s*,?%s*(%d*)%s*>", {}

		for before, r, g, b, a, s in txt:gmatch( "(.-)" .. Modifier .. "([^<]*)" ) do
			if before != "" then
				table.insert( Colors, before )
			end

			r = tonumber( r ); r = r and r or 0
			g = tonumber( g ); g = g and g or 0
			b = tonumber( b ); b = b and b or 0
			a = tonumber( a ); a = a and a or 255

			table.insert( Colors, Color( r, g, b, a ) )
			table.insert( Colors, s )
		end

		return Colors
	end
}

local function ParseName(v)

	local TextTable = { v }

	for _, GetColors in pairs( ColorModifiers ) do

		for k, v in pairs( TextTable ) do
			if not isstring( v ) then continue end

			local Colors = GetColors( v )

			if table.Count( Colors ) > 0 then
				TextTable[ k ] = nil

				for i, content in pairs( Colors ) do
					table.insert( TextTable, k + (i - 1), content )
				end
			end
		end

	end

	return TextTable
end