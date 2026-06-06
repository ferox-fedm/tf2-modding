local function serializeRec(o, prefix, writeFn, indentSym, maxCount)
	maxCount = maxCount or 1024 * 1024 * 1024
	if indentSym == nil then indentSym = "\t" end
	local function writeKey(k)
		if type(k) == "string" and string.find(k, "^[_%a][_%w]*$") then
			writeFn(k, " = ")
		else
			writeFn("[")
			serializeRec(k, "", writeFn, indentSym, maxCount)
			writeFn("] = ")
		end
	end

	if type(o) == "nil" then
		writeFn("nil")
	elseif type(o) == "boolean" then
		writeFn(tostring(o))
	elseif type(o) == "number" then
		writeFn(o)
	elseif type(o) == "string" then
		writeFn(string.format("%q", o))
	elseif type(o) == "table" then
		local metatag = o["__metatag__"]
		if metatag then
			if metatag == 0 then
				writeFn("_(")
				serializeRec(o.val, prefix, writeFn, indentSym, maxCount)
				writeFn(")")
			else
				error("invalid metatag: " .. metatag)
			end
			return
		end
		
		local oneLine = true
		local listKeys = {}
		local tableKeys = {}
		for k,v in ipairs(o) do
			listKeys[k] = true
		end
		for k,v in pairs(o) do
			if type(v) == "table" then oneLine = false end
			if not listKeys[k] then
				table.insert(tableKeys, k)
				oneLine = false
			end
		end
		table.sort(tableKeys, function(a, b) return type(a) < type(b) or (type(a) == type(b) and a < b) end)
		
		if oneLine then
			writeFn("{ ")
			local count = 0

			for k,v in ipairs(o) do			
				count = count + 1
				if count >= maxCount then writeFn("[truncated] ") break end

				serializeRec(v, "", writeFn, indentSym, maxCount)
				writeFn(", ")
			end
			for i,k in ipairs(tableKeys) do
				count = count + 1
				if count >= maxCount then writeFn("[truncated] ") break end

				local v = o[k]
				writeKey(k)
				serializeRec(v, "", writeFn, indentSym, maxCount)
				writeFn(", ")	
			end
			writeFn("}")
		else
			local prefix2 = prefix .. indentSym
			local count = 0
			writeFn("{\n")
			for k,v in ipairs(o) do
				count = count + 1
				if count >= maxCount then writeFn("[truncated] ") break end

				writeFn(prefix2)
				serializeRec(v, prefix2, writeFn, indentSym, maxCount)
				writeFn(",\n")
			end
			for i,k in ipairs(tableKeys) do
				count = count + 1
				if count >= maxCount then writeFn("[truncated] ") break end

				local v = o[k]
				writeFn(prefix2)
				writeKey(k)
				serializeRec(v, prefix2, writeFn, indentSym, maxCount)
				writeFn(",\n")	
			end
			writeFn(prefix, "}")
		end
	elseif type(o) == "userdata" then
		local mt = getmetatable(o)
		local pr, v = pcall(function() return mt.pairs end)
		local pr2, members = pcall(function() return mt.__members end)
		if mt and pr and v then 
			local prefix2 = prefix .. indentSym
			local count = 0

			writeFn("{\n")
			for k,v in pairs(o) do
				count = count + 1
				if count >= maxCount then writeFn("[truncated] ") break end

				writeFn(prefix2)
				writeKey(k)
				serializeRec(v, prefix2, writeFn, indentSym, maxCount)
				writeFn(",\n")
			end
			writeFn(prefix, "}")
		elseif mt and pr2 and members then
			local prefix2 = prefix .. indentSym
			local count = 0
			writeFn("{\n")
			for i = 1, #members do
				count = count + 1
				if count >= maxCount then writeFn("[truncated] ") break end

				local k = members[i]
				local l, v = pcall(function() return o[k] end)
				if l then
					writeFn(prefix2)
					writeKey(k)
					serializeRec(v, prefix2, writeFn, indentSym, maxCount)
					writeFn(",\n")
				end
			end
			writeFn(prefix, "}")
		else
			writeFn(tostring(o))
		end
	elseif type(o) == "function" then
		writeFn("<function>")
	end
end

local function serialize2(o, writeFn, maxCount)
	writeFn("function data()", "\n")
	writeFn("return ")
	serializeRec(o, "", writeFn, nil, maxCount)
	writeFn("\n", "end", "\n")
end

function serialize(o, maxCount)
	serialize2(o, io.write, maxCount)
	io.flush()
end

function serializeStr(o, maxCount)
	local s = ""

	-- TODO not efficient

	local function write(...)
		local arg = {...}
		for i, v in ipairs(arg) do
			s = s .. v
		end
	end

	serialize2(o, write, maxCount)

	return s
end

function toString(o, sep, maxCount)
	local s = ""

	local function write(...)
		local arg = {...}
		for i, v in ipairs(arg) do
			s = s .. v
		end
	end
	serializeRec(o, "", write, "  ", maxCount)

	return s
end
