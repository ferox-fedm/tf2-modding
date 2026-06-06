local vec3 = require "vec3"
local transf = require "transf"
local colliderutil = require "colliderutil"

local modulesutil = { }

function modulesutil.addCosts(result, mdle)
	if mdle.metadata.price then
		if not result.cost then result.cost = 0 end
		result.cost = result.cost + mdle.metadata.price
	end
	if mdle.metadata.bulldozePrice then
		if not result.bulldozeCost then result.bulldozeCost = 0 end
		result.bulldozeCost = result.bulldozeCost + mdle.metadata.bulldozePrice
	end

end

function modulesutil.getStationPoolCapacities(modules, result)
	local passCap = 0
	local cargoCap = 0		
	for num, slot in pairs(result.slots) do
		local constructionModule = modules[slot.id]
		if constructionModule and not (constructionModule.metadata.moreCapacity == nil) then
			if not (constructionModule.metadata.moreCapacity.cargo == nil) then
				cargoCap = cargoCap + constructionModule.metadata.moreCapacity.cargo
			end
			if not (constructionModule.metadata.moreCapacity.passenger == nil) then
				passCap = passCap + constructionModule.metadata.moreCapacity.passenger
			end
		end
	end
	return passCap, cargoCap
end

-- Inserts the module pool config into a temporary table in result (result.poolConfig)
-- @tparam result current construction result
-- @tparam cargo true if cargo, false if passenger
-- @tparam config a pair {modelIndex, edgeIndex}, with an absolute model index in result.model (starting from 0)
-- and an edgeIndex reference in the model's transport network provider struct
-- notice that the model index must be the index in the final result.model, starting from 0. as a convenience you can
-- use modelIndexOffset to add each modelIndex (typically #result.models, before adding any module model)
function modulesutil.addPoolEdges(result, cargo, config, modelIndexOffset)
	modelIndexOffset = modelIndexOffset or 0
	if not result.poolConfig then result.poolConfig = {} end
	if not result.poolConfig[cargo and "cargo" or "passenger"] then result.poolConfig[cargo and "cargo" or "passenger"] = {} end
	
	for k, v in pairs(config) do
		table.insert(result.poolConfig[cargo and "cargo" or "passenger"], {v[1] + modelIndexOffset, v[2]})
	end
end

-- Returns a structure ready to be set in pool.edges of the appropriate station
-- @tparam result current construction result
-- @tparam cargo true if cargo, false if passenger
function modulesutil.getStationPoolEdges(result, cargo) 
	if not result.poolConfig then return nil end
	return result.poolConfig[cargo and "cargo" or "passenger"]
end

function modulesutil.makeAutoTerminals(slots, modules, keywords, numModels, slot2node, result)
	-- It is assumed that the terminals are only in the slots with the biggest slot.id
	-- s.t. Terminals will be added to models at the end
	
	local countValidModules = function(slots, modules)
		local count = 0
		for num, slot in pairs(slots) do
			if modules[slot.id] ~= nil then
				count = count + 1 
			end
		end
		return count
	end
	local numModules = countValidModules(slots, modules)

	local colorMap = { }
	local count = 0
	
	local i = 0
	for num, slot in pairs(slots) do
		local constructionModule = modules[slot.id]
		if constructionModule ~= nil and keywords[slot.type] then
			i = i+1
		end
	end
	
	result.slotIdToTerminalGroupIndex = {}
	result.slotIdToTerminalNumber = {}
	
	local passCap = 0
	local cargoCap = 0
	passCap, cargoCap = modulesutil.getStationPoolCapacities(modules, result)

	local stationNumber2Type = {}

	local j = 0
	for num, slot in pairs(slots) do
		local constructionModule = modules[slot.id]
		if constructionModule ~= nil and keywords[slot.type] then

			if not result.terminalGroups then result.terminalGroups = {} end
			result.terminalGroups[#result.terminalGroups + 1] = { 
				terminals = { { numModels + numModules - i + j, 0 } }, 
				tag = slot.id,
			}
			if slot2node[slot.id].override ~= nil then
				result.terminalGroups[#result.terminalGroups].vehicleNodeOverride = slot2node[slot.id].override
			end
			result.slotIdToTerminalGroupIndex[slot.id] = #result.terminalGroups
			local color = slot2node[slot.id].color
			color = color == nil and 0 or color
			if constructionModule and constructionModule.metadata.cargo then 
				color = color + 200
			end
			if colorMap[color] == nil then
				local stationNumber = count + 1
				result.stations[stationNumber] = { 
					terminals = {}, 
					tag = constructionModule.metadata.cargo and 1 or 2, 
					pool = { 
						moreCapacity = constructionModule.metadata.cargo and cargoCap or passCap,
					}
				}

				stationNumber2Type[stationNumber] = constructionModule.metadata.cargo
				colorMap[color] = stationNumber
				count = count + 1
			end
			local stationNumber = colorMap[color]
			
			table.insert(result.stations[stationNumber]["terminals"], #result.terminalGroups - 1)
			result.slotIdToTerminalNumber[slot.id] = #result.stations[stationNumber]["terminals"]
			j = j+1
		end
	end

	-- Finalize pool edges only when all module functions have run
	result.terminateConstructionHook = function()
		for stationNumber, cargo in pairs(stationNumber2Type) do
			result.stations[stationNumber].pool.edges = modulesutil.getStationPoolEdges(result, cargo)
		end
	end
end

function modulesutil.makeSlots(id, keyword, rot, positions, slots, spacing)
	for num, pos in pairs(positions) do
		slots[#slots + 1] = {
			id = id,
			transf = transf.rotZYXTransl(rot, pos),
			type = keyword,
			spacing = spacing
		}
		id = id + 1
	end
	return id
end

local function gemv(mat, vec)
	return {
		mat[1]*vec[1] + mat[5]*vec[2] + mat[ 9]*vec[3] + mat[13]*vec[4],
		mat[2]*vec[1] + mat[6]*vec[2] + mat[10]*vec[3] + mat[14]*vec[4],
		mat[3]*vec[1] + mat[7]*vec[2] + mat[11]*vec[3] + mat[15]*vec[4],
		mat[4]*vec[1] + mat[8]*vec[2] + mat[12]*vec[3] + mat[16]*vec[4]
	}
end

function modulesutil.mul(mat, vec) 
	return gemv(mat, vec)
end

function modulesutil.TransformAlignmentFaces(transform, alignments)
	for i = 1, #alignments do
        for j = 1, #alignments[i].faces do
            for k = 1, #alignments[i].faces[j] do
                alignments[i].faces[j][k] = gemv(transform, alignments[i].faces[j][k])
            end
        end
	end
end

function modulesutil.TransformFaces(transform, faces)
	for i = 1, #faces do
		faces[i] = gemv(transform, faces[i])
	end
end

function modulesutil.makeAutoExtras(result, autoMaker)
	local terrain_faces = {}	
	for slotIndex, maker in pairs(autoMaker) do
		local slot = result.slots[slotIndex]
		
		local lb = gemv(slot.transf, { - slot.spacing[1], - slot.spacing[3], 0, 1})
		local rb = gemv(slot.transf, {   slot.spacing[2], - slot.spacing[3], 0, 1})
		local lt = gemv(slot.transf, { - slot.spacing[1],   slot.spacing[4], 0, 1})
		local rt = gemv(slot.transf, {   slot.spacing[2],   slot.spacing[4], 0, 1})
		
		if maker.collider == "box" then
			local coll = {} 
			local halfExtents = { (slot.spacing[1] + slot.spacing[2]) / 2, (slot.spacing[3] + slot.spacing[4]) / 2, slot.height or 1.0 }
			
			local offsetx = (slot.spacing[2] - slot.spacing[1]) / 2
			local offsety = (slot.spacing[4] - slot.spacing[3]) / 2
			
			coll.type = "BOX"
			coll.transf = transf.mul(slot.transf, transf.transl(vec3.new(offsetx, offsety, (slot.height or 1.0) / 2)))
			coll.params = { }
			coll.params.halfExtents = halfExtents
			
			result.colliders[#result.colliders + 1] = coll
		end
		
		if maker.alignment == true then
			terrain_faces[#terrain_faces + 1] = {
				{ lb[1], lb[2], 0}, 
				{ rb[1], rb[2], 0}, 
				{ rt[1], rt[2], 0}, 
				{ lt[1], lt[2], 0}
			}
		end
		
		if maker.ground_faces ~= nil then
			local faces = { 
				{ lb[1], lb[2]}, 
				{ rb[1], rb[2]},   
				{ rt[1], rt[2]}, 
				{ lt[1], lt[2]}
			}
			
			result.groundFaces[#result.groundFaces + 1] = {  
				face = faces,
				modes = maker.ground_faces
			}
		end
	end
	
	result.terrainAlignmentLists[#result.terrainAlignmentLists + 1] = {
		type = "EQUAL",
		faces = terrain_faces,
		slopeLow = 0.275,
		slopeHigh = 0.6
	}
end

function modulesutil.addAutoSnap(params, result)
	for slotId, module in pairs(params.modules) do
		if module.metadata then
			if module.metadata.snapPoint then

				for i, slot in pairs(result.slots) do
					if slot.id == slotId then
						result.snapPoint = {
							transf = transf.mul(slot.transf, module.metadata.snapPoint),
							baseEdges = {"STREET"},
						}
					end
				end
			end
		end
	end
end

return modulesutil
