require "math"
require "bit32"
local vec2 = require "vec2"

local maputil = { }

function maputil.MakeColor(intrgb) 
	return { intrgb[1] / 255.0, intrgb[2] / 255.0, intrgb[3] / 255.0 }
end

local permutation = {
	  151,160,137,91,90,15,
	  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180,
	  151,160,137,91,90,15,
	  131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
	  190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
	  88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
	  77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
	  102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
	  135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
	  5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
	  223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
	  129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
	  251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
	  49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
	  138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
}

local function Shuffle(array)
	local s = #array
	
	for i = 1, s do
		local rand = math.random(s)
		array[i], array[rand] = array[rand], array[i]
	end
	
	return array
end

-- permutation = Shuffle(permutation)

function maputil.Perlin(x, y)
	local Grad = {
		[0] = function(x, y) return  x  + y end,
		[1] = function(x, y) return  -x + y end,
		[2] = function(x, y) return  x  - y end,
		[3] = function(x, y) return  -x - y end,
	}
	
	local function Fade(t)
		return t * t * t * (t * (t * 6 - 15) + 10)
	end

	local function Lerp(a, b, t)
		return a + t * (b - a)
	end

	local x0 = math.floor(x)
	local y0 = math.floor(y)
	
	local xi = bit32.band(x0, 255) + 1
	local yi = bit32.band(y0, 255) + 1
	
	local A = permutation[xi]
	local B = permutation[xi + 1]
	
	local AA = permutation[A + yi]
	local BA = permutation[B + yi]
	local AB = permutation[A + yi + 1]
	local BB = permutation[B + yi + 1]

	local xf = x - x0
	local yf = y - y0

	local g1 = Grad[bit32.band(AA, 3)](xf,     yf);
	local g2 = Grad[bit32.band(BA, 3)](xf - 1, yf);
	local g3 = Grad[bit32.band(AB, 3)](xf,     yf - 1);
	local g4 = Grad[bit32.band(BB, 3)](xf - 1, yf - 1);
	
	local u = Fade(xf);
	local v = Fade(yf);
	
	return Lerp(Lerp(g1, g2, u), Lerp(g3, g4, u), v);
end

function maputil.MakePerlin(Sx, Sy, scale, mapResolution)
	local shiftX = math.random() * 255
	local shiftY = math.random() * 255
	local scaleX = scale[1]
	local scaleY = scale[2]
	local data = { }
	for j = 0,Sy-1 do
		for i = 0,Sx-1 do
			data[Sx * j + i + 1] = maputil.Perlin(i * scaleX + shiftX, j * scaleY + shiftY)
		end 
	end
	return {
		size = {Sx, Sy},
		data = data,
		delta = mapResolution
	}
end

function maputil.Convert(valleys)
	-- HACKY USE CORRECT FORMAT FOR VECTORS
	for k, v in pairs(valleys) do
		for k2, v2 in pairs(v.points) do
			v2[1] = v2.x
			v2[2] = v2.y
		end
		for k2, v2 in pairs(v.tangents) do
			v2[1] = v2.x
			v2[2] = v2.y
		end
		for k2, v2 in pairs(v.widthTangents) do
			v2[1] = v2.x
			v2[2] = v2.y
		end
		for k2, v2 in pairs(v.widths) do
			v2[1] = v2.x
			v2[2] = v2.y
		end
	end
end

function maputil.ValidateRiver(rivers) 
	for k, r in pairs(rivers) do
		if #r.points ~= #r.tangents then print("Not enough/too many tangents " .. k .. " " .. #r.points .. " " .. #r.tangents) end
		if #r.points ~= #r.depths then print("Not enough/too many depths " .. k .. " " .. #r.points .. " " .. #r.depths) end
		if #r.points ~= #r.widths then print("Not enough/too many widths in river " .. k .. " " .. #r.points .. " " .. #r.widths) end
		if #r.points ~= #r.depthTangents then print("Not enough/too many depth tangents " .. k .. " " .. #r.points .. " " .. #r.depthTangents) end
		if #r.points ~= #r.widthTangents then print("Not enough/too many width tangents " .. k .. " " .. #r.points .. " " .. #r.widthTangents) end
		for i = 1,#r.points do
			if r.points[i].x == nil or r.points[i].y == nil then print("P Error at " .. i .. " of " .. k) end
			if r.tangents[i].x == nil or r.tangents[i].y == nil then print("T Error at " .. i .. " of " .. k) end
			if r.widths[i].x == nil or r.widths[i].y == nil then print("W Error at " .. i .. " of " .. k) end
			if r.widthTangents[i].x == nil or r.widthTangents[i].y == nil then print("WT Error at " .. i .. " of " .. k) end
			if r.depths[i] == nil then print("D Error at " .. i .. " of " .. k) end
			if r.depthTangents[i] == nil then print("DT Error at " .. i .. " of " .. k) end
		end
	end
end

function maputil.PrintRiver(rivers) 
	local str = "river = ["
	for i = 1, #rivers do
		str = str .. "["
		for j = 1, #rivers[i].points do
			str = str .. "[" .. rivers[i].points[j][1] .. "," .. rivers[i].points[j][2] .. "],"
		end
		str = str .. "],\n"
	end
	str = str .. "]" 
	print(str)
	str = "width = ["
	for i = 1, #rivers do
		str = str .. "["
		for j = 1, #rivers[i].widths do
			str = str .. "[" .. rivers[i].widths[j].x .. "," .. rivers[i].widths[j].y .. "],"
		end
		str = str .. "],\n"
	end
	str = str .. "]"
	print(str)
end

function maputil.PrintGraph(result)
	local currentMaps = {}
	local names = {}
	local lastWrite = {}
	local str = "digraph G {\n"
	local label = true
	local function makeLabel(name) 
		return label and ("[label=" .. name .. "]") or ""
	end
	
	if result.mixingLayer then
		names[0] = "heightmap"
		lastWrite["heightmap"] = 0
		currentMaps["heightmap"] = 0
	end
	
	local readWrite = {
		AXPY = true,
		MAD = true,
		AXPBYPZ = true,
		MASK = true,
		RIVER = true
	}
	local colored = {
		GRADIENT = "red",
		GAUSS = "red"
	}
	
	local color = -1
	for k, layer in ipairs(result.layers) do
		if result.layers.colors[k] ~= nil then color = result.layers.colors[k] end
	
		names[k] = layer.params.type .. "_" .. k
		
		local innerColorT = color ~= -1 and (", style=filled, fillcolor=\"" .. color .. "\"") or ""
		local borderColor = "black"
		if colored[layer.params.type] then
			borderColor = colored[layer.params.type]
		end
		-- print(k)
		-- print(layer.type)
		-- print(layer.params.type)
		if layer.type == "FEATURE" then
			str = str .. names[k] .. " [shape=box, color=" .. borderColor .. innerColorT .. "]".. "\n"
			if readWrite[layer.params.type] then
				if currentMaps[layer.params.output] == nil then print("Error in output (rw): map not found " .. layer.params.output) end
				if names[currentMaps[layer.params.output]] == nil then print("Error in output (rw): " .. currentMaps[layer.params.output]) end
				str = str .. names[currentMaps[layer.params.output]] .. " -> " ..  names[k] .. makeLabel(layer.params.output) .. "\n"
			end
		elseif layer.type == "OP" then
			if names[k] == nil then print("Error " .. k) end
			if currentMaps[layer.params.input] == nil then print("Error in input: map not found " .. layer.params.input) end
			if names[currentMaps[layer.params.input]] == nil then print("Error in input: " .. currentMaps[layer.params.input]) end
			str = str .. names[k] .. " [shape=octagon, color=" .. borderColor .. innerColorT .. "]" .. "\n"
			if not names[currentMaps[layer.params.input]] then
				print("Warning: uninitialized input " .. layer.params.input)
			else
				str = str .. names[currentMaps[layer.params.input]] .. " -> " .. names[k] .. makeLabel(layer.params.input) .. "\n"
			end
			if readWrite[layer.params.type] then
				str = str .. names[currentMaps[layer.params.output]] .. " -> " ..  names[k] .. makeLabel(layer.params.output) .. "\n"
			end
		elseif layer.type == "MIX" then
			if names[k] == nil then print("Error " .. k) end
			if currentMaps[layer.params.input1] == nil then print("Error in input1: map not found " .. layer.params.input1) end
			if names[currentMaps[layer.params.input1]] == nil then print("Error in input1: " .. currentMaps[layer.params.input1]) end
			if currentMaps[layer.params.input2] == nil then print("Error in input2: map not found " .. layer.params.input2) end
			if names[currentMaps[layer.params.input2]] == nil then print("Error in input2: " .. currentMaps[layer.params.input2]) end
			str = str .. names[k] .. " [shape=polygon, color=" .. borderColor .. innerColorT .. "]" .. "\n"
			str = str .. names[currentMaps[layer.params.input1]] .. " -> " ..  names[k] .. makeLabel(layer.params.input1) .. "\n"
			str = str .. names[currentMaps[layer.params.input2]] .. " -> " ..  names[k] .. makeLabel(layer.params.input2) .. "\n"
			if readWrite[layer.params.type] then
				if not names[currentMaps[layer.params.output]] then
					print("Warning: uninitialized input " .. layer.params.output)
				else
					str = str .. names[currentMaps[layer.params.output]] .. " -> " ..  names[k] .. makeLabel(layer.params.output) .. "\n"
				end
			end
		elseif layer.type == "MIX_THREE" then
			if names[k] == nil then print("Error " .. k) end
			if currentMaps[layer.params.input1] == nil then print("Error in input1: map not found " .. layer.params.input1) end
			if names[currentMaps[layer.params.input1]] == nil then print("Error in input1: " .. currentMaps[layer.params.input1]) end
			if currentMaps[layer.params.input2] == nil then print("Error in input2: map not found " .. layer.params.input2) end
			if names[currentMaps[layer.params.input2]] == nil then print("Error in input2: " .. currentMaps[layer.params.input2]) end
			if currentMaps[layer.params.input3] == nil then print("Error in input3: map not found " .. layer.params.input3) end
			if names[currentMaps[layer.params.input3]] == nil then print("Error in input3: " .. currentMaps[layer.params.input3]) end
			str = str .. names[k] .. " [shape=ellipse, color=" .. borderColor .. innerColorT .. "]" .. "\n"
			str = str .. names[currentMaps[layer.params.input1]] .. " -> " ..  names[k] .. makeLabel(layer.params.input1) .. "\n"
			str = str .. names[currentMaps[layer.params.input2]] .. " -> " ..  names[k] .. makeLabel(layer.params.input2) .. "\n"
			str = str .. names[currentMaps[layer.params.input3]] .. " -> " ..  names[k] .. makeLabel(layer.params.input3) .. "\n"
		end
		lastWrite[layer.params.output] = k
		currentMaps[layer.params.output] = k
	end
	
	local outputLayers = {}
	if result.mixingLayer then
		outputLayers[result.mixingLayer.backgroundMaterial] = result.mixingLayer.backgroundMaterial
		for i, p in pairs(result.mixingLayer.layers) do
			outputLayers[p.map] = p.map
		end
	end
	
	for name, layer in pairs(lastWrite) do
		local color = "red"
		if name == result.heightmapLayer then color = "blue" end
		if name == result.forestMap then color = "green" end
		if name == result.assetsMap then color = "yellow" end
		if outputLayers[name] then
			color = "purple"
		end
		str = str .. name .. " [style=filled, fillcolor=" .. color .. "]" .. "\n"
		str = str .. names[layer] .. " -> " .. name .. "\n"
	end
	str = str .. "}\n"
	print(str)
end

return maputil
