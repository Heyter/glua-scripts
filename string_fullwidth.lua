function string.fullwidth(str)
	str = str:gsub("%l", function(c) return string.char(239, 189, 130 + (c:byte() - 98)) end)
	str = str:gsub("%u", function(c) return string.char(239, 188, 161 + (c:byte() - 65)) end)
	return str
end