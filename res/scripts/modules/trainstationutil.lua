local vec3 = require "vec3"
local transf = require "transf"
local modulesutil = require "modulesutil"

local trainstationutil = {}

function trainstationutil.findOrMakeNewEdgeListNum(result, trackType, catenary)
	local function makeEmptyTrack(type, catenary)
		return { 
			type = "TRACK",
			params = {
				type =  type,
				catenary = catenary,
			},
			edges = { },
			snapNodes = { },
			tag2nodes = { },
		}
	end

	for k,v in pairs(result.edgeLists) do
		if v.params.type == trackType and v.params.catenary == catenary then return k end
	end

	result.edgeLists[#result.edgeLists + 1] = makeEmptyTrack(trackType, catenary)
	return #result.edgeLists
end

function trainstationutil.makeTrack(result, transform, tag, slotId, addModuleFn, params, edgeListNum)
	local pos = vec3.new(transform[13], transform[14], transform[15])
	local nedges = #(result.edgeLists[edgeListNum].edges)
	
	result.models[#result.models + 1] = { 
		id = "station/rail/era_a/tn_underground_connection.mdl",
		transf = transf.mul(transform, transf.transl(vec3.new(0, 0, 0))),
		tag = tag
	}
	
	result.edgeLists[edgeListNum].edges[nedges + 1] = { { pos.x, pos.y - 18, .0 }, { .0, -2.0, .0 } }
	result.edgeLists[edgeListNum].edges[nedges + 2] = { { pos.x, pos.y - 20, .0 }, { .0, -2.0, .0 } }
	
	result.edgeLists[edgeListNum].edges[nedges + 3] = { { pos.x, pos.y - 2, .0 }, { .0, -16.0, .0 } }
	result.edgeLists[edgeListNum].edges[nedges + 4] = { { pos.x, pos.y - 18,  .0 }, { .0, -16.0, .0 } }
	
	result.edgeLists[edgeListNum].edges[nedges + 5] = { { pos.x, pos.y + 0,  .0 }, { .0, -2.0, .0 } }
	result.edgeLists[edgeListNum].edges[nedges + 6] = { { pos.x, pos.y - 2,  .0 }, { .0, -2.0, .0 } }
	
	result.edgeLists[edgeListNum].edges[nedges + 7] = { { pos.x, pos.y + 0,  .0 }, { .0, 2.0, .0 } }
	result.edgeLists[edgeListNum].edges[nedges + 8] = { { pos.x, pos.y + 2,  .0 }, { .0, 2.0, .0 } }
	
	result.edgeLists[edgeListNum].edges[nedges + 9] = { { pos.x, pos.y + 2,  .0 }, { .0, 16.0, .0 } }
	result.edgeLists[edgeListNum].edges[nedges + 10] = { { pos.x, pos.y + 18, .0 }, { .0, 16.0, .0 } }
	
	result.edgeLists[edgeListNum].edges[nedges + 11] = { { pos.x, pos.y + 18, .0 }, { .0, 2.0, .0 } }
	result.edgeLists[edgeListNum].edges[nedges + 12] = { { pos.x, pos.y + 20, .0 }, { .0, 2.0, .0 } }
	
	
	local coords = result.GetCoord(slotId)
	local i = coords[1]
	local j = coords[2]
	
	result.trackCoord2models[i][j].nodeCenterRight = {edgeListNum, nedges + 10}
	
	result.trackCoord2models[i][j].nodeRight = {edgeListNum, nedges + 7}
	result.trackCoord2models[i][j].nodeLeft = {edgeListNum, nedges + 5}
	
	result.trackCoord2models[i][j].nodeCenterLeft = {edgeListNum, nedges + 0}
	
	local function AddTerminal(i, j, leftOrRight, modelNum)
		if leftOrRight then result.trackCoord2models[i][j].left = modelNum
		else result.trackCoord2models[i][j].right =  modelNum end
	end
	
	local nextM = result.GetModuleAt(i, j-1)
	if not nextM or not nextM.metadata.track then
		table.insert(result.edgeLists[edgeListNum].snapNodes, nedges + 1)
	end
	local prevM = result.GetModuleAt(i, j+1)
	if not prevM or not prevM.metadata.track then
		table.insert(result.edgeLists[edgeListNum].snapNodes, nedges + 11)
	end
	local forwardM = result.GetModuleAt(i+1, j)
	if forwardM then
		if forwardM.metadata.cargo_platform then
			addModuleFn("station/rail/era_a/tn_cargo_wait_area.mdl", transf.rotZTransl(math.rad(180), vec3.new(3.5, 0, 0)))
			AddTerminal(i, j, false, {{#result.models - 1, 0}})
		elseif forwardM.metadata.passenger_platform then
			addModuleFn("station/rail/era_a/tn_passenger_wait_area.mdl", transf.rotZTransl(math.rad(180), vec3.new(3.5, 0, 0)))
			AddTerminal(i, j, false, {{#result.models - 1, 0}})
		end
	end
	local backwardM = result.GetModuleAt(i-1, j)
	if backwardM then
		if backwardM.metadata.cargo_platform then
			addModuleFn("station/rail/era_a/tn_cargo_wait_area.mdl", transf.transl(vec3.new(-3.5, 0, 0)))
			AddTerminal(i, j, true, {{#result.models - 1, 0}})
		elseif backwardM.metadata.passenger_platform then
			addModuleFn("station/rail/era_a/tn_passenger_wait_area.mdl", transf.transl(vec3.new(-3.5, 0, 0)))
			AddTerminal(i, j, true, {{#result.models - 1, 0}})
		end
	end
	
	
	if result.edgeLists[edgeListNum].tag2nodes[tag] == nil then
		result.edgeLists[edgeListNum].tag2nodes[tag] = {}
	end
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 0)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 1)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 2)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 3)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 4)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 5)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 6)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 7)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 8)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 9)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 10)
	table.insert(result.edgeLists[edgeListNum].tag2nodes[tag], nedges + 11)
end

trainstationutil.stationYMin = -10
trainstationutil.stationYMax = 10
	
function trainstationutil.MakeMainBuildingModule(result, transform, tag, slotId, addModuleFn, params, config)

	local modelTransf = transf.rotZTransl(math.rad(-90), vec3.new(7.5,0,0))
	local assetTransf = transf.mul(transform, modelTransf)

	local terrainAlignmentLists = {
	    { type = "EQUAL", faces = { {
			{ config.extend[1], config.extend[4],  0.0, 1.0 },
			{ config.extend[1], config.extend[3],  0.0, 1.0 },
			{ config.extend[2], config.extend[3],  0.0, 1.0 },
			{ config.extend[2], config.extend[4],  0.0, 1.0 },
		} } },
	}
	
	local groundFace = {
		{ config.extend[1], config.extend[4],  0.0, 1.0 },
		{ config.extend[1], config.extend[3],  0.0, 1.0 },
		{ config.extend[2], config.extend[3],  0.0, 1.0 },
		{ config.extend[2], config.extend[4],  0.0, 1.0 },
	}
	local frontDistance = 2
	local groundFace2 = {
		{ config.extend[1], config.extend[4] - frontDistance,  0.0, 1.0 },
		{ config.extend[1], config.extend[4],  0.0, 1.0 },
		{ config.extend[2], config.extend[4],  0.0, 1.0 },
		{ config.extend[2], config.extend[4] - frontDistance,  0.0, 1.0 },
	}
	
	local jMin = trainstationutil.stationYMin
	local jMax = trainstationutil.stationYMax
	
	modulesutil.TransformAlignmentFaces(assetTransf, terrainAlignmentLists)
	for i = 1, #terrainAlignmentLists do
		local t = terrainAlignmentLists[i]
		table.insert(result.terrainAlignmentLists, t)
	end
	
	modulesutil.TransformFaces(assetTransf, groundFace)
	modulesutil.TransformFaces(assetTransf, groundFace2)
	table.insert(result.groundFaces, {  
		face = groundFace,
		modes = {
			{
				type = "FILL",
				key = "shared/asphalt_01.gtex.lua"
			},
			{
				type = "STROKE_OUTER",
				key = "street_border.lua"
			},
		},
	})
	table.insert(result.groundFaces, {  
		face = groundFace2,
		modes = {
			{
				type = "FILL",
				key = "shared/gravel_03.gtex.lua"
			},
			{
				type = "STROKE_OUTER",
				key = "street_border.lua"
			},
		},
	})
	
	local center = vec3.new((config.extend[1] + config.extend[2]) / 2, (config.extend[3] + config.extend[4]) / 2, (config.extend[5] + config.extend[6]) /2)
	local halfExtends = { math.abs((config.extend[1] - config.extend[2]) / 2), math.abs((config.extend[3] - config.extend[4]) / 2), math.abs((config.extend[5] - config.extend[6]) / 2) }
	
	table.insert(result.colliders, { 
		type = "BOX",
		transf = transf.mul(assetTransf, transf.transl(center)),
		params = {
			halfExtents = halfExtends,
		}
	})
	
	local thisM = params.modules[slotId]
	
	local mainBuildingData = result.mainBuildingCoord[slotId-config.slotIdOffset]
	
	if mainBuildingData then 
		local head = mainBuildingData[1]
		local leftOrRight = mainBuildingData[2]
		local coordI = mainBuildingData[3]
		local coordJ = mainBuildingData[4]
		local coordK = mainBuildingData[5]
		
		addModuleFn(config.main, modelTransf)
		
		local linksLeft = false
		local linksRight = false
		local nextM = nil
		local prevM = nil
		
		if head then
			local size = thisM.metadata.span[2] - thisM.metadata.span[1]
		
			nextM = result.GetAddonAt(leftOrRight and 3 or 4, jMin, coordI - size - 2)
			prevM = result.GetAddonAt(leftOrRight and 3 or 4, jMin, coordI + size + 1)
			
			linksLeft = nextM and nextM[2] == coordJ and nextM[1].metadata.era == thisM.metadata.era
			linksRight = prevM and prevM[2] == coordJ and prevM[1].metadata.era == thisM.metadata.era
		else
			nextM = result.GetAddonAt(leftOrRight and 2 or 1, coordJ, coordK - 1 + thisM.metadata.span[1])
			prevM = result.GetAddonAt(leftOrRight and 2 or 1, coordJ, coordK + 1 + thisM.metadata.span[2])
			
			linksLeft = nextM and nextM[2] == coordI and nextM[1].metadata.era == thisM.metadata.era
			linksRight = prevM and prevM[2] == coordI and prevM[1].metadata.era == thisM.metadata.era
		end
		-- if linksLeft then linksLeft = nextM[1].metadata.level - thisM.metadata.level end
		-- if linksRight then linksRight = prevM[1].metadata.level - thisM.metadata.level end
		if linksLeft then linksLeft = nextM[1].metadata.level end
		if linksRight then linksRight = prevM[1].metadata.level end
		if not leftOrRight then 
			linksLeft, linksRight = linksRight, linksLeft
		end
	
		if linksLeft then
			if config.con_left[linksLeft] then addModuleFn(config.con_left[linksLeft], transf.rotZTransl(math.rad(-90), vec3.new(7.5,config.translationY ,0))) end
		else
			if config.end_left then addModuleFn(config.end_left, transf.rotZTransl(math.rad(-90), vec3.new(7.5,config.translationY ,0))) end
		end
		if linksRight then
			if config.con_right[linksRight] then addModuleFn(config.con_right[linksRight], transf.rotZTransl(math.rad(-90), vec3.new(7.5,-config.translationY ,0))) end
		else
			if config.end_right then addModuleFn(config.end_right, transf.rotZTransl(math.rad(-90), vec3.new(7.5,-config.translationY ,0))) end
		end
		
		if head then
			for i = 0,20 do
				local this = result.GetAddonAt(leftOrRight and 3 or 4, jMin, coordI + i - 1)
				local front = result.GetModuleAt(coordI + i, coordJ) 
				if front or this then
					local i2 = coordI + i
					local j = coordJ + (leftOrRight and -1 or 1)
					local l = leftOrRight and 7 or 0
					if result.GetModuleAt(i2, j) then
						break
					end
					result.connector[1000 * i2 + 100 * j + l] = {i2, j, l, 0}
				else 
					break
				end
			end
			for i = -1,-20,-1 do
				local this = result.GetAddonAt(leftOrRight and 3 or 4, jMin, coordI + i - 1)
				local front = result.GetModuleAt(coordI + i, coordJ) 
				if front or this then
					local i2 = coordI + i
					local j = coordJ + (leftOrRight and -1 or 1)
					local l = leftOrRight and 7 or 0
					if result.GetModuleAt(i2, j) then
						break
					end
					result.connector[1000 * i2 + 100 * j + l] = {i2, j, l, 0}
				else 
					break
				end
			end
		else
			-- local left = result.GetModuleAt(coordI, coordJ + 1)
			-- local right = result.GetModuleAt(coordI, coordJ - 1)
			-- if not right and coordK < 0 then
				-- for k = 0, 2 * (2 - thisM.metadata.span[1] - (coordK + 2)) - 1 do
					-- result.connector[1000 * coordI + 100 * (coordJ - 1) + (7 - k)] = {coordI, coordJ - 1, 7 - k, 1}
				-- end
			-- end
			-- if not left and coordK > 0 then
				-- for k = 0, 2 * (thisM.metadata.span[2] - 1 - (2 - coordK)) - 1 do
					-- result.connector[1000 * coordI + 100 * (coordJ + 1) + k] = {coordI, coordJ + 1, k, 1}
				-- end
			-- end
		end

		return assetTransf, coordI, coordJ, coordK, head, leftOrRight
	end
end

return trainstationutil
