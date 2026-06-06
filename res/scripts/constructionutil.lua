local polygonutil = require "polygonutil"
local transf = require "transf"
local vec3 = require "vec3"
local colliderutil = require "colliderutil"
local streetutil = require "streetutil"
local assetutil = require "assetutil"
local mathutil = require "mathutil"

local constructionutil = { }

function constructionutil.rotateTransf(params, tf)
	return transf.mul(transf.mul(transf.rotX(params.paramX), transf.rotY(params.paramY)), tf)
end
		
function constructionutil.makeTree(result, model, params, scale)
	local s = params.randomize == 0 and 1 or math.randf(0.8, 1.2)
	local r = params.randomize == 0 and 0 or math.random() * math.pi * 2.0
	result.models = { {
		id = model,
		transf = transf.scaleRotZTransl(s, r, vec3.new(.0, .0, .0))
	} }
end

local function getPlatform(config, i, numPlatforms, evenNumTracks)
	if (i == 1 and #config.firstPlatform.parts > 0) then
		return { data = config.firstPlatform, terminalIndices = { 0 } }
	elseif (i == numPlatforms and evenNumTracks) then
		if (config.lastPlatform and #config.lastPlatform.parts > 0) then
			return { data = config.lastPlatform, terminalIndices = { 0 } }
		else
			return { data = config.platform, terminalIndices = { 0 } }
		end	
	end
	
	return { data = config.platform, terminalIndices = { 0, 1 } } 
end

local function subtract(a, b)
	return { a[1] - b[1], a[2] - b[2], a[3] - b[3] }
end 

local function scale(a, b)
	return { a[1] * b, a[2] * b, a[3] * b }
end 

function constructionutil.addEdges(data, result, type, params, free)
	assert(data ~= nil)
	
	local edges = {}
	
	for i=1, #data do
		local edge = {}
		local points = data[i]
		if #points == 2 then
			local tangent = subtract(points[2], points[1])
			table.insert(edges, { points[1], tangent })
			table.insert(edges, { points[2], tangent })
		elseif #points == 3 then
			local tangent1 = scale(subtract(points[2], points[1]), 2.0)
			local tangent2 = scale(subtract(points[3], points[2]), 2.0)
			table.insert(edges, { points[1], tangent1 })
			table.insert(edges, { points[3], tangent2 })
		elseif #points == 4 then
			local tangent1 = scale(subtract(points[2], points[1]), 3.0)
			local tangent2 = scale(subtract(points[4], points[3]), 3.0)
			table.insert(edges, { points[1], tangent1 })
			table.insert(edges, { points[4], tangent2 })
		else
			assert(false)
		end
	end
	
	if result.edgeLists == nil then result.edgeLists = {} end
	
	local res = {
		type = type,
		params = params,
		edges = edges,
		snapNodes = { }
	}
	if free then
		res.freeNodes = streetutil.freeAllNodes(edges)
	end
	
	result.edgeLists[#result.edgeLists + 1] = res
end

function constructionutil.addModels(data, result, transform, tag)
	if data.models then
		for key, value in orderedPairs(data.models) do
			for i = 1, #value do
				local t = value[i]
				if (transform ~= nil) then t = transf.mul(transform, t) end
			
				result[#result + 1] = {
					id = key,
					transf = t,
					tag = tag,
				}
			end
		end
	end
end

local function randomSeedFix(seed)
	math.randomseed(seed * 1839)
end

local function checkIgnore(params, n)
	if not n.ignore then return false end
	
	randomSeedFix(params.seed + n.ignore[1])
	return (math.random(100) <= n.ignore[2])
end

local function addModels(params, data, result, tag, transform)
	if not data.models then return end
	
	if not result.models then result.models = { } end
	
	for k, v in orderedPairs(data.models) do
		for i=1, #v do
			if not checkIgnore(params, v[i]) then
				result.models[#result.models + 1] = { id = k, transf = transform and transf.mul(transform, v[i]) or v[i], tag = tag }
			end
		end
	end
end

local function addGroups(params, data, result, tag, transform)
	if not data.groups then return end
	
	if not result.models then result.models = { } end
	
	local modelId = 1
	for k, v in orderedPairs(data.groups) do
		local actualGroupName = string.sub(k, 1, -5)
		local group = params.state.groups[actualGroupName]
		
		if not group then
			group = assetutil.assets[actualGroupName]
		end
		
		if (group == nil) then error("group '" .. actualGroupName .. "' not found") end
		
		for i=1, #v do
			modelId = modelId + 1
			
			if not checkIgnore(params, v[i]) then
				if v[i].seed then
					randomSeedFix(params.seed + v[i].seed)
				else
					randomSeedFix(params.seed + modelId)
				end
			
				local id = group[math.random(#group)]
				if type(id) == "table" then
					local newId = id[math.random(#id)]--id[groupConfigNum % #id]
					result.models[#result.models + 1] = { id = newId, transf = transform and transf.mul(transform, v[i]) or v[i] }
				elseif id ~= "" then
					result.models[#result.models + 1] = { id = id, transf = transform and transf.mul(transform, v[i]) or v[i] }
				end
			end
		end
	end
end

local everyThird = function(face)
	local newFace = {}
	for i=1, #face, 3 do
		table.insert(newFace, face[i])
	end
	return newFace
end

local function addGroundFaces(data, result)
	if not data.curves then return end
	
	if not result.groundFaces then result.groundFaces = { } end
	
	for k, v in orderedPairs(data.curves) do
		if string.find(k, ".gtex") then
			local borderTex = nil
			local mainTex = nil
			
			local textures = string.split(k, ";")

			local modes = {}
			if textures[1] and textures[1] ~= "" then
				table.insert(modes, { type = "FILL", key = textures[1] })
			end

			if textures[2] and textures[2] ~= "" then
				table.insert(modes, { type = "STROKE_OUTER", key = textures[2] })
			end

			if textures[3] and textures[3] ~= "" then
				table.insert(modes, { type = "STROKE_INNER", key = textures[3] })
			end
			
			assert(#modes > 0)
			
			for i=1, #v do
				local face = v[i]
				table.insert(result.groundFaces, { 
						face = everyThird(face), 
						modes = modes
					} 
				)
			end
		end
	end
end

local addTerrainAlignmentMeshes = function(meshes, type, optional, result)
	local triangles = {}
	for i=1, #meshes do
		for j=1, # meshes[i] do
			triangles[#triangles + 1] = meshes[i][j]
		end
	end

	if not result.terrainAlignmentLists then result.terrainAlignmentLists = {} end
	
	result.terrainAlignmentLists[#result.terrainAlignmentLists + 1] = {
		type = type,
		triangles = triangles,
		optional = optional,
	}
end

local addTerrainAlignments = function(data, result)
	if data.meshes then
		if data.meshes.equal then
			addTerrainAlignmentMeshes(data.meshes.equal, "EQUAL", false, result)
		end
		if data.meshes.greater then
			addTerrainAlignmentMeshes(data.meshes.greater, "GREATER", true, result)
		end
		if data.meshes.less then
			addTerrainAlignmentMeshes(data.meshes.less, "LESS", true, result)
		end
	end
end

local addCollider = function(data, result)
	if data.curves and data.curves.collider then
	
		if not result.colliders then result.colliders = { } end
	
		for i=1, #data.curves.collider do
			local col = data.curves.collider[i]
			table.insert(result.colliders, colliderutil.createPointCloud(col))
		end
	end
end

function constructionutil.addModelsAndGroups(params, data, result, tag, transform)
	assert(params.seed)
	
	addModels(params, data, result, tag, transform)
	addGroups(params, data, result, tag, transform)
	addGroundFaces(data, result)
	addTerrainAlignments(data, result)
	addCollider(data, result)
end

function constructionutil.makeTrainStation(config, params)
	local result = { }

	result.models = { 
		{
			id = config.building,
			transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1 }
		}
	}

	local numTracks = params.numTracksIndex + 1
	
	local len = 40.0
	
	local tracksWidth = params.state.track.shapeWidth + params.state.track.trackDistance

	local num1 = math.floor(numTracks / 2) + 1									-- num platforms (y)
	local num2 = #config.platform.parts - 2										-- num platforms (x)
	
	local edges = { }
	local snapNodes = { }
	
	local py = .0
	
	for i = 1, numTracks do
		if i % 2 == 1 then
			local platform = getPlatform(config, (i + 1) / 2, num1, numTracks % 2 == 0)
			py = py - (platform.data.bounds[2] - platform.data.bounds[1])
		else
			py = py - params.state.track.trackDistance + params.state.track.shapeWidth
		end
		
		local dx = .5 * len * num2 + 10.0			-- TODO 10?
				
		local dy = -.5 * params.state.track.shapeWidth

		local i4 = 4 * i
	
		local y = py + dy
		
		edges[i4 - 3] = { { -dx, y, .0 }, 	{ dx, .0, .0 } }
		edges[i4 - 2] = { { .0, y, .0 },	{ dx, .0, .0 } }
		edges[i4 - 1] = { { .0, y, .0 }, 	{ dx, .0, .0 } }
		edges[i4] 	  = { { dx, y, .0 }, 	{ dx, .0, .0 } }

		local i2 = 2 * i

		snapNodes[i2 - 1] = i4 - 4
		snapNodes[i2]     = i4 - 1
		
		py = py - params.state.track.shapeWidth
	end
	
	py = .0
	
	result.terminalGroups = { }
	
	for i = 1, num1 do
		local platform = getPlatform(config, i, num1, numTracks % 2 == 0)
		
		local dx = .5 * len * num2
		local dy = -platform.data.bounds[2]
		
		local y = py + dy
		
		local numModels = #result.models
				
		if #platform.data.parts[1] >= 0 then
			result.models[#result.models + 1] = {
				id = platform.data.parts[1],
				transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, dx, y, 0, 1 }
			}
		end
		
		for j = 1, num2 do
			local rev = #platform.data.parts[j + 1] == 0
			result.models[#result.models + 1] = {
				id = rev and platform.data.parts[num2 + 2 - j] or platform.data.parts[j + 1],
				transf = { rev and -1 or 1, 0, 0, 0, 0, rev and -1 or 1, 0, 0, 0, 0, 1, 0, dx - (j - .5) * len, y, 0, 1 }
			}			
		end

		if #platform.data.parts[num2 + 2] > 0 or #platform.data.parts[1] > 0 then
			local rev = #platform.data.parts[num2 + 2] == 0
			result.models[#result.models + 1] = {
				id = rev and platform.data.parts[1] or platform.data.parts[num2 + 2],
				transf = { rev and -1 or 1, 0, 0, 0, 0, rev and -1 or 1, 0, 0, 0, 0, 1, 0, dx - (num2) * len, y, 0, 1 }
			}
		end

		for j, terminalIndex in ipairs(platform.terminalIndices) do
			local terminals = { }
			for k = numModels + 1, #result.models do
				terminals[#terminals + 1] = { k - 1, terminalIndex }
			end
			result.terminalGroups[#result.terminalGroups + 1] = { terminals = terminals, vehicleNodeOverride = 2 + 4 * #result.terminalGroups }
		end

		py = py - (platform.data.bounds[2] - platform.data.bounds[1]) - tracksWidth
	end	
	
	result.edgeLists = { { 
		type = "TRACK",
		params = { },
		edges = edges,
		snapNodes = snapNodes
	}, {
		type = "STREET",
		params = { type = "standard/town_small_old.lua" },
		edges = {
			{ { .0, 18.0, .0 }, { .0, 15.0, .0 } },
			{ { .0, 33.0, .0 }, { .0, 15.0, .0 } }
		},
		snapNodes = { 1 }
	} 
	}

	result.cost = 60000 + numTracks * 24000
	result.maintenanceCost = result.cost / 6
		
	return result

end


-- ############################## 
-- ##### PLATFORMS / TRACKS ##### 
-- ############################## 

 local function makePlatformsAndTracks(config, result)

	result.models = { }
	result.terminalGroups = { }
	result.colliders = { }
	
	local snapNodes = { }
	local tag2nodes = { }

	-- inputs
	local trackMultiplier = config.trackMultiplier												-- for debug only
	local numTracks = config.numTracks * trackMultiplier										-- number of tracks
	local trackDistance = config.trackDistance													-- distance between tracks
	local platformDistance = config.platformDistance											-- distance between pattforms
	local segmentLength = config.segmentLength													-- length of platform segments
	local stationType = config.stationType														-- head / through
	
	-- calculated
	local stationLength = #config.platformConfig.firstPlatformParts * config.segmentLength		-- total length of the station
	local numSegments = #config.platformConfig.firstPlatformParts								-- total width of the station
	--numSegments = config.stationLength
	
	local stationWidth = math.floor(numTracks / 2) * trackDistance + math.floor(numTracks / 2 - 0.5) * platformDistance
	config.stationWidth = stationWidth
		
	local edges = { }
	
	local terminalOrder = { }
	local trackOffsets = { }
	
	for tracks = 0, numTracks do	
		if (stationType == "head" and tracks > 0) then
			trackOffsets[tracks] = (((tracks % 2) * 2) - 1) * (trackDistance / 2 + math.floor((tracks + 1) / 4) * platformDistance + math.floor((tracks - 1) / 4) * trackDistance)
			terminalOrder[tracks] = math.floor(10 * trackOffsets[tracks])
		end
		
		if (stationType == "through") then
			trackOffsets[tracks] = math.floor(tracks / 2) * trackDistance + math.floor(tracks / 2 - 0.5) * platformDistance
			terminalOrder[tracks] = tracks
		end
		
	end
	
	local function addEdge(position, tangent, id)
		table.insert(edges, { position, tangent })
		
		local tag = stationType .. "Track" .. tostring(id)
		
		if tag2nodes[tag] == nil then
			tag2nodes[tag] = { }
		end
		table.insert(tag2nodes[tag], #edges - 1)
	end

	for tracks = 0, numTracks do		
		local trackOffset
		local platformModel
		local terminals = { }
		local terminalsLeft = { }
		local terminalsRight = { }
		
		local xOffset
		local yOffset
		
		local trackAddLength = 2.0
		
		local trackSign = (((tracks % 2) * 2) - 1)
		
		if (stationType == "head" and tracks > 0) then
			trackOffset = trackOffsets[tracks]
			
			if (tracks % 4 == 0) or ((tracks - 1) % 4 == 0) then
				addEdge({ trackOffset,  .0 ,  .0 },  					  			{ .0, stationLength / 2, .0 }, tracks)
				addEdge({ trackOffset,  .0 + stationLength / 2,  .0 }, 			 	{ .0, stationLength / 2, .0 }, tracks)
				addEdge({ trackOffset,  .0 + stationLength / 2,  .0 },  			{ .0, stationLength / 2 + trackAddLength, .0 }, tracks)
				addEdge({ trackOffset,  .0 + stationLength + trackAddLength,  .0 }, { .0, stationLength / 2 + trackAddLength, .0 }, tracks)
				table.insert(snapNodes, (tracks - 1) * 4 + 3)
			else
				addEdge({ trackOffset,  .0 + stationLength + trackAddLength,  .0 }, { .0, -stationLength / 2 - trackAddLength, .0 }, tracks)
				addEdge({ trackOffset,  .0 + stationLength / 2,  .0 },  			{ .0, -stationLength / 2 - trackAddLength, .0 }, tracks)
				addEdge({ trackOffset,  .0 + stationLength / 2,  .0 },  			{ .0, -stationLength / 2, .0 }, tracks)
				addEdge({ trackOffset,  .0 ,  .0 }, 					  			{ .0, -stationLength / 2, .0 }, tracks)
				table.insert(snapNodes, (tracks - 1) * 4)
			end
						
			for segements = 1, numSegments do	
				
				xOffset = trackOffset + trackSign * (platformDistance / 2)
				yOffset = segements * segmentLength - segmentLength / 2
				
				if ((tracks - 1) % 4 == 0 and tracks < numTracks - 1) then -- track 1, 5, 9 ... but not last two -> double
					result.models[#result.models + 1] = {
						id = config.platformConfig.middlePlatformParts[segements].part,
						transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.middlePlatformParts[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = stationType .. "Platform" .. tracks
					}
					if (config.platformConfig.middlePlatformParts[segements].orientation == 0) then
						terminalsLeft[#terminalsLeft + 1] = { #result.models - 1, 0 }
						terminalsRight[#terminalsRight + 1] = { #result.models - 1, 1 }
					else
						terminalsLeft[#terminalsLeft + 1] = { #result.models - 1, 1 }
						terminalsRight[#terminalsRight + 1] = { #result.models - 1, 0 }
					end
					
					if (config.platformConfig.middlePlatformRoof[segements].part ~= "") then
						result.models[#result.models + 1] = {
							id = config.platformConfig.middlePlatformRoof[segements].part,
							transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.middlePlatformRoof[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
							tag = stationType .. "Platform" .. tracks
						}
					end
					
				end	

							
				if ((tracks - 2) % 4 == 0 and tracks < numTracks - 1 ) then -- track 2, 6, 10 ... but not last two -> double		
					result.models[#result.models + 1] = {
						id = config.platformConfig.middlePlatformParts[segements].part,
						transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.middlePlatformParts[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = stationType .. "Platform" .. tracks
					}
					if (config.platformConfig.middlePlatformParts[segements].orientation == 0) then
						terminalsLeft[#terminalsLeft + 1] = { #result.models - 1, 0 }
						terminalsRight[#terminalsRight + 1] = { #result.models - 1, 1 }
					else
						terminalsLeft[#terminalsLeft + 1] = { #result.models - 1, 1 }
						terminalsRight[#terminalsRight + 1] = { #result.models - 1, 0 }
					end
					
					if (config.platformConfig.middlePlatformRoof[segements].part ~= "") then
						result.models[#result.models + 1] = {
							id = config.platformConfig.middlePlatformRoof[segements].part,
							transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.middlePlatformRoof[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
							tag = stationType .. "Platform" .. tracks
						}
					end
				end	
				
				if ((tracks - 1) % 4 == 0  and tracks >= numTracks - 1) then -- odd, in last 2 tracks -> single plattform right
					result.models[#result.models + 1] = {
						id = config.platformConfig.lastPlatformParts[segements].part,
						transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.lastPlatformParts[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = stationType .. "Platform" .. tracks
					}
					terminals[#terminals + 1] = { #result.models - 1, 0 }
					
					if (config.platformConfig.lastPlatformRoof[segements].part ~= "") then
						result.models[#result.models + 1] = {
							id = config.platformConfig.lastPlatformRoof[segements].part,
							transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.lastPlatformRoof[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
							tag = stationType .. "Platform" .. tracks
						}
					end
				end
	
				if ((tracks - 2) % 4 == 0  and tracks >= numTracks - 1) then -- even, in last 2 tracks -> single plattform left
					result.models[#result.models + 1] = {
						id = config.platformConfig.firstPlatformParts[segements].part,
						transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.firstPlatformParts[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = stationType .. "Platform" .. tracks
					}
					terminals[#terminals + 1] = { #result.models - 1, 0 }
					
					if (config.platformConfig.firstPlatformRoof[segements].part ~= "") then
						result.models[#result.models + 1] = {
							id = config.platformConfig.firstPlatformRoof[segements].part,
							transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.firstPlatformRoof[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
							tag = stationType .. "Platform" .. tracks
						}
					end
				end
	
			end
			
			if ((tracks - 1) % 4 == 0 and tracks < numTracks - 1) then
				result.terminalGroups[tracks] = { terminals = terminalsLeft, vehicleNodeOverride = tracks * 4 - 2, order = terminalOrder[tracks] }	
				result.terminalGroups[tracks + 2] = { terminals = terminalsRight, vehicleNodeOverride = (tracks + 2) * 4 - 2, order = terminalOrder[tracks + 2] }	
			end
			
			if ((tracks - 2) % 4 == 0 and tracks < numTracks - 1) then
				result.terminalGroups[tracks] = { terminals = terminalsRight, vehicleNodeOverride = tracks * 4 - 2, order = terminalOrder[tracks] }	
				result.terminalGroups[tracks + 2] = { terminals = terminalsLeft, vehicleNodeOverride = (tracks + 2) * 4 - 2, order = terminalOrder[tracks + 2] }	
			end
			
			if ((tracks - 1) % 4 == 0  and tracks >= numTracks - 1) then 
				result.terminalGroups[tracks] = { terminals = terminals, vehicleNodeOverride = tracks * 4 - 2, order = terminalOrder[tracks] }	
			end	
			
			if ((tracks - 2) % 4 == 0  and tracks >= numTracks - 1) then 
				result.terminalGroups[tracks] = { terminals = terminals, vehicleNodeOverride = tracks * 4 - 2, order = terminalOrder[tracks] }	
			end	
		end
		
		
		if (stationType == "through") then
			
			local trackOffset = trackOffsets[tracks]
			
			if (tracks > 0) then
				local trackLength = stationLength + 2.0 * trackAddLength
				
				if (tracks % 2 == 0) then
					addEdge({ trackOffset,  .0 - trackLength / 2 ,  .0 },	{ .0, trackLength / 2, .0 }, tracks)
					addEdge({ trackOffset,  .0 ,  .0 }, 					{ .0, trackLength / 2, .0 }, tracks)
					addEdge({ trackOffset,  .0 ,  .0 },  					{ .0, trackLength / 2, .0 }, tracks)
					addEdge({ trackOffset,  .0 + trackLength / 2 ,  .0 },	{ .0, trackLength / 2, .0 }, tracks)
				else
					addEdge({ trackOffset,  .0 + trackLength / 2 ,  .0 },	{ .0, -trackLength / 2, .0 }, tracks)
					addEdge({ trackOffset,  .0 ,  .0 },  					{ .0, -trackLength / 2, .0 }, tracks)
					addEdge({ trackOffset,  .0 ,  .0 }, 					{ .0, -trackLength / 2, .0 }, tracks)
					addEdge({ trackOffset,  .0 - trackLength / 2 ,  .0 },	{ .0, -trackLength / 2, .0 }, tracks)
				end
				
				table.insert(snapNodes, (tracks - 1) * 4)
				table.insert(snapNodes, (tracks - 1) * 4 + 3)
			end

			for segements = 1, numSegments do	
				xOffset = trackOffset + platformDistance / 2
				yOffset = segements * segmentLength - segmentLength / 2 - stationLength / 2
						
				if (tracks % 2 == 0 and tracks == 0) then							-- even, first track -> first single platform
					result.models[#result.models + 1] = {
						id = config.platformConfig.firstPlatformParts[segements].part,
						transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.firstPlatformParts[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = stationType .. "Platform" .. tracks
					}
					
					terminals[#terminals + 1] = { #result.models - 1, 0 }
									
					if (config.platformConfig.firstPlatformRoof[segements].part ~= "") then
						result.models[#result.models + 1] = {
							id = config.platformConfig.firstPlatformRoof[segements].part,
							transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.firstPlatformRoof[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
							tag = stationType .. "Platform" .. tracks
						}
					end
				end		
				
				if (tracks % 2 == 0 and tracks == numTracks) then					--- even, last track -> last single pattform				
					result.models[#result.models + 1] = {
						id = config.platformConfig.lastPlatformParts[segements].part,
						transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.lastPlatformParts[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = stationType .. "Platform" .. tracks
					}

					terminals[#terminals + 1] = { #result.models - 1, 0 }
							
					if (config.platformConfig.lastPlatformRoof[segements].part ~= "") then
						result.models[#result.models + 1] = {
							id = config.platformConfig.lastPlatformRoof[segements].part,
							transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.lastPlatformRoof[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
							tag = stationType .. "Platform" .. tracks
						}
					end
				end
			
				if (tracks % 2 == 0 and (tracks ~= 0 and tracks ~= numTracks)) then	-- even, not first or last -> build double platform
					result.models[#result.models + 1] = {
						id = config.platformConfig.middlePlatformParts[segements].part,
						transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.middlePlatformParts[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = stationType .. "Platform" .. tracks
					}
								
					if (config.platformConfig.middlePlatformParts[segements].orientation == 0) then
						terminalsLeft[#terminalsLeft + 1] = { #result.models - 1, 0 }
						terminalsRight[#terminalsRight + 1] = { #result.models - 1, 1 }
					else
						terminalsLeft[#terminalsLeft + 1] = { #result.models - 1, 1 }
						terminalsRight[#terminalsRight + 1] = { #result.models - 1, 0 }
					end								
									
					if (config.platformConfig.middlePlatformRoof[segements].part ~= "") then
						result.models[#result.models + 1] = {
							id = config.platformConfig.middlePlatformRoof[segements].part,
							transf = transf.rotZYXTransl(transf.degToRad(config.platformConfig.middlePlatformRoof[segements].orientation, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
							tag = stationType .. "Platform" .. tracks
						}
					end
				end	
			end
			
			if (tracks % 2 == 0 and tracks == 0) then	
				result.terminalGroups[#result.terminalGroups + 1] = { terminals = terminals, vehicleNodeOverride = 2 }	
			end
		
			if (tracks % 2 == 0 and tracks == numTracks) then	
				result.terminalGroups[#result.terminalGroups + 1] = { terminals = terminals, vehicleNodeOverride = #edges - 2 }	
			end
			
			if (tracks % 2 == 0 and (tracks ~= 0 and tracks ~= numTracks)) then
				result.terminalGroups[#result.terminalGroups + 1] = { terminals = terminalsLeft, vehicleNodeOverride = tracks * 4 - 2 }	
				result.terminalGroups[#result.terminalGroups + 1] = { terminals = terminalsRight, vehicleNodeOverride = tracks * 4 + 2 }	
			end	
			
		end


		
	end	
	
	result.edgeLists = {
		{ 
			type = "TRACK",
			params = {
				type = config.trackType,
				catenary = config.catenary
			},
			edges = edges,
			snapNodes = snapNodes,
			tag2nodes = tag2nodes
		},
	}	
	
end



-- ################# 
-- ##### FACES ##### 
-- ################# 

 local function makeFaces(config, result)
	
	-- inputs
	local trackMultiplier = config.trackMultiplier												-- for debug only
	local numTracks = config.numTracks * trackMultiplier										-- number of tracks
	local trackDistance = config.trackDistance													-- distance between tracks
	local platformDistance = config.platformDistance											-- distance between pattforms
	local segmentLength = config.segmentLength													-- length of platform segments
	local stationType = config.stationType														-- head / through
	
	-- calculated
	local stationLength = #config.platformConfig.firstPlatformParts * config.segmentLength		-- total length of the station
	local numSegments = #config.platformConfig.firstPlatformParts								-- total width of the station	
	
	local terrainFaces = { }
	local groundFaces = { }
	
	local xOffset, yOffset, xMin, xMax
	
	if config.stationType == "head" then
		local stationWidth = math.floor(numTracks / 2) * trackDistance + math.floor(numTracks / 2 - 0.5) * platformDistance
	
		xOffset = .0
		yOffset = stationLength / 2
		
		xMin = -stationWidth / 2 - config.platformDistance / 2 + xOffset + (  5 * (config.numTracks % 2))
		xMax =  stationWidth / 2 + config.platformDistance / 2 + xOffset + (2.5 * (config.numTracks % 2))
	end
	
	if config.stationType == "through" then
		local firstPlatformWidthHACK = 5
		local trackWidthHACK = 4
		local doubleTrackWidthHACK = trackDistance + trackWidthHACK
		local fullPlatformWidthHACK = platformDistance - trackWidthHACK
		local halfPlatformWidthSUPERHACK = math.ceil(.5 * fullPlatformWidthHACK)
	
		local numDoubleTracks = math.floor(numTracks / 2)
		local numSingleTracks = numTracks % 2
		local numFullPlatforms = math.max(math.floor(numTracks / 2 - .5), 0)
		local numHalfPlatforms = numDoubleTracks - numFullPlatforms
		
		local stationWidth = firstPlatformWidthHACK + numDoubleTracks * doubleTrackWidthHACK + numSingleTracks * trackWidthHACK +
			numFullPlatforms * fullPlatformWidthHACK + numHalfPlatforms * halfPlatformWidthSUPERHACK

		xOffset = -trackWidthHACK / 2 - firstPlatformWidthHACK
		yOffset = .0
		
		xMin = xOffset
		xMax = xMin + stationWidth
	end
	
	local yMin = -stationLength / 2 + yOffset
	local yMax =  stationLength / 2 + yOffset
		
	local terrainFaces = { 
		{ 
			{ xMin, yMin, 0 },
			{ xMax, yMin, 0 },
			{ xMax, yMax, 0 },
			{ xMin, yMax, 0 }
		},
	}

	groundFaces[#groundFaces + 1] = { face = terrainFaces[#terrainFaces], modes = { { type = "FILL", key = "industry_gravel_small_01.lua" } } }
	groundFaces[#groundFaces + 1] = { face = terrainFaces[#terrainFaces], modes = { { type = "STROKE_OUTER", key = "building_paving.lua" } } }		

	result.terrainAlignmentLists = {
		{
			type = "EQUAL",
			faces = terrainFaces,
		}
	}
	
	result.groundFaces = groundFaces

	result.colliders[#result.colliders + 1] = colliderutil.createBox({ .5 * (xMax + xMin), .5 * (yMax +yMin), 2 }, { .5 * (xMax - xMin), .5 * (yMax - yMin), 4 })
end

-- #################### 
-- ##### BUILDING ##### 
-- #################### 

local function makeStationBuilding(config, result)

	local stationBuilding = config.stationBuilding

	-- inputs
	local trackMultiplier = config.trackMultiplier												-- for debug only
	local numTracks = config.numTracks * trackMultiplier										-- number of tracks
	local trackDistance = config.trackDistance													-- distance between tracks
	local platformDistance = config.platformDistance											-- distance between pattforms
	local segmentLength = config.segmentLength													-- length of platform segments
	local stationType = config.stationType														-- head / through
	
	-- calculated
	local stationLength = #config.platformConfig.firstPlatformParts * config.segmentLength		-- total length of the station
	local numSegments = #config.platformConfig.firstPlatformParts								-- total width of the station
	local stationWidth = math.floor(numTracks / 2) * trackDistance + math.floor(numTracks / 2 - 0.5) * platformDistance

	local xOffset
	local yOffset
	
	if (config.stationType == "head") then
		result.models[#result.models + 1] = {
			id = stationBuilding,
			transf = transf.rotZYXTransl(transf.degToRad(.0, .0, .0), vec3.new(.0, -10.0, .0)),
			tag = "stationBuilding"
		}
		
		for tracks = 1, numTracks do	
					
				local trackOffset = ( ( ( tracks % 2 ) * 2 ) - 1) * ((math.floor((tracks + 3) / 4)) * trackDistance + (math.floor((tracks + 1) / 4) ) * platformDistance - trackDistance / 2)
						
								
				if (numTracks == 1) then
					xOffset = trackOffset - trackDistance / 2 - platformDistance / 2
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.singleTrackLast,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}	
				end
				
				if ((tracks) % 4 == 1) then -- track 1, 5, 9 ... 
				
					xOffset = trackOffset - trackDistance / 2
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.doubleTrack,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}
				end	
					
				if ((tracks) % 4 == 2 and tracks > 2) then -- track 2, 6, 10 ... 	
					
					xOffset = trackOffset + trackDistance / 2
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.doubleTrack,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}
				end	
				
				
					
				if ((tracks - 1) % 4 == 0 and tracks >= numTracks - 1) then -- track 1, 5, 9 ... and last two -> close single terminal
				
					xOffset = trackOffset + platformDistance / 2
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.singleTerminalLast,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}					
				end	
				
				if ((tracks - 2) % 4 == 0 and tracks >= numTracks - 1) then -- track 2, 6, 10 ... and last two -> close single terminal
				
					xOffset = trackOffset - platformDistance / 2 
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.singleTerminalFirst,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}					
				end	
				
				
				if ((tracks - 1) % 4 == 0 and tracks < numTracks - 1) then -- track 1, 5, 9 ... and not last two -> close terminal
				
					xOffset = trackOffset + platformDistance / 2
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.doubleTerminal,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}					
				end	
				
				if ((tracks - 2) % 4 == 0 and tracks < numTracks - 1) then -- track 2, 6, 10 ... and not last two -> close terminal
				
					xOffset = trackOffset - platformDistance / 2 
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.doubleTerminal,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}					
				end	
				
				
				if ((tracks + 1 ) % 4 == 0 and tracks >= numTracks - 1) then -- track 3, 7, 11 ... and last two close single track
				
					xOffset = trackOffset - trackDistance / 2
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.singleTrackFirst,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}					
				end	
				
				
				if (tracks % 4 == 0 and tracks >= numTracks - 1) then -- track 4, 8, 12 ... and last two close single track
				
					xOffset = trackOffset + trackDistance / 2
					yOffset = 0
				
					result.models[#result.models + 1] = {
						id = config.platformConfig.headParts.singleTrackLast,
						transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(xOffset, yOffset, 0)),
						tag = "stationBuilding"
					}					
				end	
				
				
				
		
		end
		
	end
	
	if (config.stationType == "through") then
		result.models[#result.models + 1] = {
			id = stationBuilding,
			transf = transf.rotZYXTransl(transf.degToRad(270.0, .0, .0), vec3.new(-10.0, .0, .0)),
			tag = "stationBuilding"
		}
	end

end


-- ################## 
-- ##### STREET ##### 
-- ################## 

local function makeStreet(config, result)

	local stationLength = #config.platformConfig.firstPlatformParts * config.segmentLength		-- total length of the station

	if (config.streetType == nil) then config.streetType = "old_small" end
	if (config.stairs == nil) then config.stairs = "station/train/passenger/1850/platform_stairs.mdl" end 
	if (config.stairsPlatform == nil) then config.stairsPlatform = "station/train/passenger/1850/platform_single_stairs_second.mdl" end 
		
	local roadEdges = { }
	local snapNodes = { }
	
	local cargoOffset
	local terrainFaces

	if (config.stationType == "head" and config.streetSecondConnection == 1) then 
		
		if ((config.numTracks - 1) % 4 == 0) then -- track 1, 5, 9 ... 
		
			if config.type == "cargo" then cargoOffset = 2.5 else cargoOffset = 0.0 end

			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth / 2 + 5.0 + config.trackDistance / 2, stationLength - config.segmentLength,  0.0))					
			}				
						
			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(180.0, 0.0, 0.0), vec3.new(-config.stationWidth / 2 - 5.0 + config.trackDistance / 2 + cargoOffset, stationLength - config.segmentLength,  0.0))					
			}			
			result.models[#result.models + 1] = {
				id = config.stairsPlatform,
				transf = transf.rotZYXTransl(transf.degToRad(180.0, 0.0, 0.0), vec3.new(-config.stationWidth / 2 - config.platformDistance / 2  + config.trackDistance / 2 + cargoOffset, stationLength - config.segmentLength,  0.0))					
			}
			
			terrainFaces = { 
				{ 
					{ -config.stationWidth / 2 -  8.5 + config.trackDistance / 2 + cargoOffset, stationLength - config.segmentLength - config.segmentLength / 2 - 3, .0},  
					{ config.stationWidth / 2 +  8.5 + config.trackDistance / 2, stationLength - config.segmentLength - config.segmentLength / 2 - 3, .0},  
					{ config.stationWidth / 2 +  8.5 + config.trackDistance / 2, stationLength - config.segmentLength + config.segmentLength / 2 + 3, .0},  
					{ -config.stationWidth / 2 -  8.5 + config.trackDistance / 2 + cargoOffset, stationLength - config.segmentLength + config.segmentLength / 2 + 3, .0},  
				},
			}
	
			result.terrainAlignmentLists[#result.terrainAlignmentLists+1] = 
			{
					type = "EQUAL",
					faces = terrainFaces,
			}
						
		end
		
		if ((config.numTracks - 2) % 4 == 0) then -- track 2, 6, 10 ... 

			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth / 2 + 5.0, stationLength - config.segmentLength,  0.0))					
			}				
			
			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(180.0, 0.0, 0.0), vec3.new(-config.stationWidth / 2 - 5.0, stationLength - config.segmentLength,  0.0))					
			}				
		end
		
		if ((config.numTracks  + 1 ) % 4 == 0) then -- track 3, 7, 11 ... and last two close single track
		
			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth / 2 + 5.0 + config.trackDistance -.5, stationLength - config.segmentLength, 0.0))					
			}			
			
			result.models[#result.models + 1] = {
				id = config.stairsPlatform,
				transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth / 2 + config.platformDistance / 2 + config.trackDistance -.5, stationLength - config.segmentLength, 0.0))	
			}
			
			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(180.0, 0.0, 0.0), vec3.new( - config.stationWidth / 2 - 5.0 + config.platformDistance / 2, stationLength - config.segmentLength,  0.0))					
			}	

			terrainFaces = { 
				{ 
					{ -config.stationWidth / 2 -  8.5 + config.platformDistance / 2, stationLength - config.segmentLength - config.segmentLength / 2 - 3, .0},  
					{ config.stationWidth / 2 +  8.5 + config.trackDistance -.5, stationLength - config.segmentLength - config.segmentLength / 2 - 3, .0},  
					{ config.stationWidth / 2 +  8.5 + config.trackDistance -.5, stationLength - config.segmentLength + config.segmentLength / 2 + 3, .0},  
					{ -config.stationWidth / 2 -  8.5 + config.platformDistance / 2, stationLength - config.segmentLength + config.segmentLength / 2 + 3, .0},  
				},
			}
	
			result.terrainAlignmentLists[#result.terrainAlignmentLists+1] = 
			{
					type = "EQUAL",
					faces = terrainFaces,
			}			
			
		end
		
		if (config.numTracks  % 4 == 0) then -- track 4, 8, 12 ... 

			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth / 2 + 5.0 + config.trackDistance / 2 -.5, stationLength - config.segmentLength, 0.0))					
			}							
			result.models[#result.models + 1] = {
				id = config.stairsPlatform,
				transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth / 2 + config.trackDistance / 2 + config.platformDistance / 2 -.5, stationLength - config.segmentLength, 0.0))	
			}			
						
			result.models[#result.models + 1] = {
				id = config.stairs,
				transf = transf.rotZYXTransl(transf.degToRad(180.0, 0.0, 0.0), vec3.new(-config.stationWidth / 2 - 5.0 - config.trackDistance / 2 +.5, stationLength - config.segmentLength,  0.0))					
			}			
			result.models[#result.models + 1] = {
				id = config.stairsPlatform,
				transf = transf.rotZYXTransl(transf.degToRad(180.0, 0.0, 0.0), vec3.new(-config.stationWidth / 2 - config.platformDistance / 2 - config.trackDistance / 2 +.5, stationLength - config.segmentLength,  0.0))					
			}
			
			terrainFaces = { 
				{ 
					{ -config.stationWidth / 2 -  8.5 - config.trackDistance / 2 +.5, stationLength - config.segmentLength - config.segmentLength / 2 - 3, .0},  
					{ config.stationWidth / 2 +  8.5 + config.trackDistance / 2 -.5, stationLength - config.segmentLength - config.segmentLength / 2 - 3, .0},  
					{ config.stationWidth / 2 +  8.5 + config.trackDistance / 2 -.5, stationLength - config.segmentLength + config.segmentLength / 2 + 3, .0},  
					{ -config.stationWidth / 2 -  8.5 - config.trackDistance / 2 +.5, stationLength - config.segmentLength + config.segmentLength / 2 + 3, .0},  
				},
			}
	
			result.terrainAlignmentLists[#result.terrainAlignmentLists+1] = 
			{
					type = "EQUAL",
					faces = terrainFaces,
			}
			
		end
		
	end	
	
	if (config.stationType == "through" and config.streetSecondConnection == 1 and config.numTracks % 2 == 0) then 

		result.models[#result.models + 1] = {
			id = config.stairs,
			transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth + 5.0, 0.0,  0.0))					
		}				
				
	end
	
	if (config.stationType == "through" and config.streetSecondConnection == 1 and config.numTracks % 2 ~= 0 ) then
	
		if config.type == "cargo" then cargoOffset = 2.5 else cargoOffset = 0.0 end
		
		result.models[#result.models + 1] = {
			id = config.stairs,
			transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth + 5.0 - cargoOffset, 0.0,  0.0))	
		}		
				
		result.models[#result.models + 1] = {
			id = config.stairsPlatform,
			transf = transf.rotZYXTransl(transf.degToRad(0.0, 0.0, 0.0), vec3.new(config.stationWidth + config.platformDistance / 2  - cargoOffset, 0.0,  0.0))	
		}	
		
		terrainFaces = { 
			{ 
				{ config.stationWidth +  8.5 - cargoOffset, - config.segmentLength / 2 - 3, .0},  
				{ config.stationWidth, - config.segmentLength / 2 - 3, .0},  
				{ config.stationWidth,   config.segmentLength / 2 + 3, .0},  
				{ config.stationWidth +  8.5 - cargoOffset, config.segmentLength / 2 + 3, .0},  
			},
		}

		result.terrainAlignmentLists[#result.terrainAlignmentLists+1] = 
		{
				type = "EQUAL",
				faces = terrainFaces,
		}
	
	end
	
	local groundFace 
	
	if (config.stationType == "through") then
		local xx = -19.9
		result.terrainAlignmentLists[1].faces[#result.terrainAlignmentLists[1].faces + 1] = { { xx, -config.buildingWidth / 2, .0 }, { .0, -config.buildingWidth / 2.0, .0 }, { .0, config.buildingWidth / 2.0, .0 }, { xx, config.buildingWidth / 2.0 , .0 } }
		result.terrainAlignmentLists[1].faces[#result.terrainAlignmentLists[1].faces + 1] = { { -20.0, -7.0, .0 }, { xx, -7.0, .0 }, { xx, 7.0, .0 }, { -20.0, 7.0, .0 } }
		
		groundFace = { { .0, -config.buildingWidth / 2}, { .0, config.buildingWidth/2}, { xx, config.buildingWidth / 2 }, 
		{ xx, 6 }, { -20, 6 }, { -20, -6 }, { xx, -6 },	{xx, -config.buildingWidth / 2 } }
		
		result.colliders[#result.colliders + 1] = colliderutil.createBox({ xx / 2, 0, 5 }, { -xx / 2, config.buildingWidth / 2, 7 })
	end
	
	if (config.stationType == "head") then
		local yy = -19.9
		result.terrainAlignmentLists[1].faces[#result.terrainAlignmentLists[1].faces + 1] = { { -config.buildingWidth / 2.0, yy, .0 }, { config.buildingWidth / 2.0, yy, .0 }, { config.buildingWidth / 2.0, .0, .0 }, { -config.buildingWidth / 2.0, .0, .0 } }
		result.terrainAlignmentLists[1].faces[#result.terrainAlignmentLists[1].faces + 1] = { { -6.0, -20.0, .0 }, { 6.0, -20.0, .0 }, { 6.0, yy, .0 }, { -6.0, yy, .0 } }
		
		groundFace = { { -config.buildingWidth / 2, yy }, { -6.0, yy }, { -6.0, -20.0 }, { 6.0, -20.0 }, { 6.0, yy }, { config.buildingWidth / 2, yy }, { config.buildingWidth / 2 , .0 }, { -config.buildingWidth / 2 , .0 } }
		
		result.colliders[#result.colliders + 1] = colliderutil.createBox({ 0, yy / 2, 5 }, { config.buildingWidth / 2, -yy / 2, 7 })
	end
		
	result.groundFaces[#result.groundFaces + 1] = { face = groundFace, modes = { { type = "FILL", key = "industry_concrete_01.lua" } } }
	result.groundFaces[#result.groundFaces + 1] = { face = groundFace, modes = { { type = "STROKE_OUTER", key = "building_paving.lua" } } }
	
	if (config.stationType == "through" and config.streetSecondConnection == 1) then
		result.terrainAlignmentLists[1].faces[#result.terrainAlignmentLists[1].faces + 1] = { { config.stationWidth, 6.0, 0.0 }, { config.stationWidth, -6.0, 0.0 }, { config.stationWidth + 15.0, -6.0, 0.0 }, { config.stationWidth + 15.0, 6.0, 0.0 } }
		
		groundFace = { { config.stationWidth, 6.0 }, { config.stationWidth, -6.0 }, { config.stationWidth + 6.0, -6.0 }, { config.stationWidth + 6.0, 6.0 } }
		result.groundFaces[#result.groundFaces + 1] = { face = groundFace, modes = { { type = "FILL", key = "industry_concrete_01.lua" } } }
		result.groundFaces[#result.groundFaces + 1] = { face = groundFace, modes = { { type = "STROKE_OUTER", key = "building_paving.lua" } } }
		
		result.colliders[#result.colliders + 1] = colliderutil.createBox({ config.stationWidth + 3, 0, 2 }, { 3, 6, 4 })
	end
	
	if (config.stationType == "head" and config.streetSecondConnection == 1) then
		
		groundFace = { { - config.stationWidth / 2 - 6.0, stationLength - config.segmentLength + 6 }, { - config.stationWidth / 2 - 6.0, stationLength - config.segmentLength - 6 }, { config.stationWidth / 2 + 14.0, stationLength - config.segmentLength - 6 }, { config.stationWidth / 2 + 14.0, stationLength - config.segmentLength + 6 } }
		result.groundFaces[#result.groundFaces + 1] = { face = groundFace, modes = { { type = "FILL", key = "industry_concrete_01.lua" } } }
		result.groundFaces[#result.groundFaces + 1] = { face = groundFace, modes = { { type = "STROKE_OUTER", key = "building_paving.lua" } } }
		
		result.colliders[#result.colliders + 1] = colliderutil.createBox({ 0, stationLength - config.segmentLength, 2 }, { config.stationWidth / 2 + 6.0, 6, 4 })
	end
end


function constructionutil.makeTrainStationNew(config) 
	local result = {}

	makePlatformsAndTracks(config, result)
	makeFaces(config, result)
	makeStationBuilding(config, result)
	makeStreet(config, result)

	result.cost = 60000 + config.numTracks * 24000
	result.maintenanceCost = result.cost / 6

	return result
end


function constructionutil.makeStocks(config, result)
	local dim = 8.0
	
	for stock = 1, #config.stocks do
		local stockConfig = config.stocks[stock]
		
		local angle = stockConfig.angle == nil and .0 or stockConfig.angle		
		
		local cz = math.cos(angle)
		local sz = math.sin(angle)
				
		local dirx0 = cz * dim
		local diry0 = sz * dim
		
		local dirx1 = -diry0
		local diry1 = dirx0

		local dirx0_ = dirx0 * stockConfig.sizex * .5
		local diry0_ = diry0 * stockConfig.sizex * .5
		
		local dirx1_ = dirx1 * stockConfig.sizey * .5
		local diry1_ = diry1 * stockConfig.sizey * .5
		
		local px0 = stockConfig.x - dirx0_ - dirx1_
		local py0 = stockConfig.y - diry0_ - diry1_

		local px1 = stockConfig.x + dirx0_ - dirx1_
		local py1 = stockConfig.y + diry0_ - diry1_

		local px2 = stockConfig.x + dirx0_ + dirx1_
		local py2 = stockConfig.y + diry0_ + diry1_

		local px3 = stockConfig.x - dirx0_ + dirx1_
		local py3 = stockConfig.y - diry0_ + diry1_
		
		local pz = stockConfig.z or 0
		
		local groundFaceTextureFill = { 
			RECEIVING = "building_paving_fill.lua",
			SENDING = "building_paving_fill.lua"
		}
		
		local groundFaceTextureStroke = { 
			RECEIVING = "building_paving.lua",
			SENDING = "building_paving.lua"
		}
				
		result.groundFaces[#result.groundFaces + 1] = { 
			face = { { px0, py0 }, { px1, py1 }, { px2, py2 }, { px3, py3 } }, 
			modes = { { type = "FILL", key = groundFaceTextureFill[stockConfig.type] } } 
		}
		
		result.groundFaces[#result.groundFaces + 1] = { 
			face = { { px0, py0 }, { px1, py1 }, { px2, py2 }, { px3, py3 } }, 
			modes = { { type = "STROKE_OUTER", key = groundFaceTextureStroke[stockConfig.type] } } 
		}

		px0 = px0 + dirx1 * .5
		py0 = py0 + diry1 * .5
		
		local stockEdges = { }
		
		for i = 0, stockConfig.sizex - 1 do
			for j = 0, stockConfig.sizey - 1 do
				stockEdges[#stockEdges + 1] = { #result.models, 0 }

				result.models[#result.models + 1] = {
					id = "industry/common/stock_lane_8m.mdl",
					transf = { cz, sz, .0, .0, -sz, cz, .0, .0, .0, .0, 1.0, .0, px0 + i * dirx0 + j * dirx1, py0 + i * diry0 + j * diry1, pz, 1.0 }				
				}
			end
		end
		
		result.stocks[#result.stocks + 1] = {
			cargoType = stockConfig.cargoType,
			type = stockConfig.type,
			edges = stockEdges
		}
	end
	
	result.rule = config.rule
end


function constructionutil.makeFence(points, modelId, length, loop, result, squeezeLast, angle)

	local num1 = #points + 1
	local num = loop and num1 or #points
	
	for i = 2, num do
		
		-- get start and end coordinates
		local coordStart = points[i - 1]
		local xStart = coordStart[1]
		local yStart = coordStart[2]
		local zStart = coordStart[3]
		
		local coordEnd = points[i == num1 and 1 or i]
		local xEnd = coordEnd[1]
		local yEnd = coordEnd[2]
		local zEnd = coordEnd[3]
		
		-- calculate the fence vector
		local fenceVector = vec3.new(xEnd-xStart, yEnd-yStart, zEnd-zStart)
		local fenceVectorLength = vec3.length(fenceVector)
		
		-- calculate segments
		local segments = fenceVectorLength / length
		local fenceVectorSegment = vec3.new((xEnd-xStart) / segments, (yEnd-yStart) / segments, (zEnd-zStart) / segments)

		-- place along vector and rotate z axis with xyAngle, offset with half segment length
		for build_fence = 1, math.floor(segments) do
		
			local fence_point = vec3.sub(vec3.add(vec3.new(xStart, yStart, zStart), vec3.mul(build_fence, fenceVectorSegment)), vec3.mul(0.5, fenceVectorSegment))
						
			result[#result + 1] = {
				id = modelId,
				transf = transf.rotZTransl(vec3.xyAngle(fenceVector) + (angle or 0), fence_point),
			}
		end
		local remainder = segments - math.floor(segments)
		if squeezeLast and remainder > 0.1 then
			local fence_point = vec3.add(vec3.add(vec3.new(xStart, yStart, zStart), vec3.mul(math.floor(segments), fenceVectorSegment)), vec3.mul(remainder / 2, fenceVectorSegment))
			result[#result + 1] = {
				id = modelId,
				transf = transf.scaleXYZRotZTransl(vec3.new(remainder, 1, 1), vec3.xyAngle(fenceVector) + (angle or 0), fence_point),
			}
		end
		
	end	
			
end


function constructionutil.distributeModels(p0, p1, models, obstacleFace, randomRot, result)
	if #models == 0 then
		return
	end

	local dim = 5
	
	local numx = math.floor((p1[1] - p0[1]) / dim)
	local numy = math.floor((p1[2] - p0[2]) / dim)
	
	for i = 1, numx do
		for j = 1, numy do
			if (math.random() < .33) then
				local x = p0[1] + (i - .5) * dim
				local y = p0[2] + (j - .5) * dim
				
				if #obstacleFace == 0 or not polygonutil.contains(obstacleFace, { x, y }) then				
					local w = (i - .5) / numx
					local z = p0[3] * (1.0 - w) + p1[3] * w

					local angle = randomRot and math.random() * 2.0 * math.pi or math.random(1, 4) * math.pi * .5
					
					result[#result + 1] = {
						id = models[math.random(1, #models)],
						transf = transf.rotZTransl(angle, vec3.new(x, y, z)),
					}
				end
			end
		end
	end
end

function constructionutil.getTree(state, category)
	local models = state.groups[category]
	if (not models) or #models == 0 then models = state.groups["random_small_tree"] end
	return models[math.random(1, #models)]	
end

function constructionutil.reverseFace(face)
	local reversed = {}
	for i = #face, 1, -1 do
		reversed[#reversed+1] = face[i]
	end
	
	return reversed
end

return constructionutil
