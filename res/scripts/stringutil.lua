function string.starts(input, test)
	return string.sub(input, 1, string.len(test)) == test
end

function string.ends(input, test)
	return test == '' or string.sub(input, -string.len(test)) == test
end

function string.interp(s, tab)
	return s:gsub("($%b{})", function (w) return tab[w:sub(3, -2)] or w end)
end

function string.split(s, c)
	local result = { }
	for m in (s .. c):gmatch("(.-)" .. c) do
		table.insert(result, m)
	end
	return result
end

function string.strip(s, c)
	local cc = c or " "
	return string.gsub(string.gsub(s, "^" .. cc .. "*", ""), cc .. "*$", "")
end

function string.makeMoneyString(num)
	local str = tostring(math.floor(num))
	local pos = -1
	local res = ""
	while string.len(str)+pos+1 > 3 do
		res = string.sub(str, pos-2, pos) .. res
		pos = pos-3
		if string.len(str)+pos+1 > 0 then
			res = "'" .. res
		end
	end
	res = string.sub(str, 1, pos) .. res
	return res
end

function string.makeReadableNumber(num)
	local str = tostring(num)
	local pos = -1
	local res = ""
	while string.len(str)+pos+1 > 3 do
		res = string.sub(str, pos-2, pos) .. res
		pos = pos-3
		if string.len(str)+pos+1 > 0 then
			res = " " .. res
		end
	end
	res = string.sub(str, 1, pos) .. res
	return res
end
