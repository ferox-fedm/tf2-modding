require "mathutil"
require "stringutil"
require "tableutil"

getmetatable("").__mod = string.interp

function debugPrint(x)
	require "serialize"

	-- local backup = io.output()
	-- io.output(io.stdout)

	-- serialize(x)

	-- io.output(backup)

	print(toString(x))
end


--[[
Ordered table iterator, allow to iterate on the natural order of the keys of a table.
]]

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        --for i = 1,table.getn(t.__orderedIndex) do
        for i = 1,getTableSize(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end


local unpackhelper
unpackhelper = function(t, i)
	if t[i] == nil then return end
	return t[i], unpackhelper(t, i + 1)
end

local oldunpack = table.unpack
table.unpack = function(t)
	if type(t) == "userdata" then
		return unpackhelper(t, 1)
	else
		return oldunpack(t)
	end
end

api = {}
app = false
addFileFilter = false
clearFileFilter = false
addModifier = false
applyFileFilters = false
applyModifiers = false
cmd_finish = false
cmd_next = false
cmd_step = false
data = false
game = false
getCurrentModId = false
getTextRes = false
pGetTextRes = false
gui = false
menu = false
serialize = false
serializeStr = false
setStrings = false
toString = false
translateModStr = false
_getTextNow = false
_ = false
pGetText = false
ug = {}

setmetatable(_G, {
	__newindex = function(table, key, value)
		local function isSolName(key)
			return type(key) == "string" and string.starts(key, "sol.")
		end

		rawset(table, key, value)
		if key ~= "_currentModIdTr" and not isSolName(key) then
			if getCurrentModId() == nil or string.starts(getCurrentModId(), "urbangames_") then
				error("creating globals by assignment is not allowed (variable was " .. tostring(key) .. ")\nDid you forget to add 'local' before your variable?")
			else
				--print("global variable in mod " .. getCurrentModId() .. ": " .. tostring(key))
			end
		end
	end,
})
