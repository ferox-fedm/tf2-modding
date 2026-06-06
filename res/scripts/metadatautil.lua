
local result = { }

local function vecSequence(from, to)
	local t = {}
	for i = from, to do
		table.insert(t, i)
	end
	return t
end

local getYearEmissionReduction2 = function(x)
	return -7.0 * x
end

local getYearEmissionReduction = function(metadata)
	if (not metadata.availability) or not metadata.availability.yearFrom or metadata.availability.yearFrom == 0 then return 1.0 end
	local year = metadata.availability.yearFrom
	return getYearEmissionReduction2(math.clamp((year - 1850) / 150.0, .0, 1.0))
end

local addEngineTypeEmission = function(engine, metadata)
	--if not metadata.emission then return end
	if engine and metadata.emission.idleEmissionAuto then
		if engine.type == "HORSE" then
			metadata.emission.idleEmission = metadata.emission.idleEmission - 4
		elseif engine.type == "DIESEL" then
			metadata.emission.idleEmission = metadata.emission.idleEmission + 8
		elseif engine.type == "STEAM" then
			metadata.emission.idleEmission = metadata.emission.idleEmission + 11
		elseif engine.type == "ELECTRIC" then
			metadata.emission.idleEmission = metadata.emission.idleEmission + 3
		else
			assert(false)
		end
	else
		--metadata.emission.idleEmission = metadata.emission.idleEmission - 2
	end
end

local addPseudoRandomEmission2 = function(metadata, weight, speed)
	if (not metadata.emission.idleEmissionAuto) then return .0 end
	if (not metadata.availability) or not metadata.availability.yearFrom or metadata.availability.yearFrom == 0 then return .0 end
	
	local year = metadata.availability.yearFrom

	metadata.emission.idleEmission = metadata.emission.idleEmission + ((year * weight / speed) % 6) - 1
end

local addPseudoRandomEmission = function(carrier, metadata)
	if carrier == "TRAM" then
		addPseudoRandomEmission2(metadata, metadata.railVehicle.weight, metadata.railVehicle.topSpeed)
	elseif carrier == "RAIL" then
		addPseudoRandomEmission2(metadata, metadata.railVehicle.weight, metadata.railVehicle.topSpeed)
	elseif carrier == "ROAD" then
		addPseudoRandomEmission2(metadata, metadata.roadVehicle.weight, metadata.roadVehicle.topSpeed)
	elseif carrier == "WATER" then
		addPseudoRandomEmission2(metadata, metadata.waterVehicle.weight, metadata.waterVehicle.topSpeed)
	elseif carrier == "AIR" then
		addPseudoRandomEmission2(metadata, metadata.airVehicle.weight, metadata.airVehicle.topSpeed)
	end
end

function result.addEmissionMetadata(fileName, data)
	if not data.metadata.emission then return data end

	--print("model: " .. fileName)
	
	local function patchAddDefaultEmission(metadata, idleEmission, speedEmission, powerEmission)
		if metadata.emission.idleEmission == nil or metadata.emission.idleEmission < 0 then 
			metadata.emission.idleEmissionAuto = true 
			local yearEmission = getYearEmissionReduction(metadata)
			--print("  yearEmission: " .. yearEmission)
			metadata.emission.idleEmission = idleEmission + yearEmission
		end
		if metadata.emission.speedEmission == nil or metadata.emission.speedEmission < 0 then 
			metadata.emission.speedEmissionAuto = true
			metadata.emission.speedEmission = speedEmission 
		end
		if metadata.emission.powerEmission == nil or metadata.emission.powerEmission < 0 then 
			metadata.emission.powerEmissionAuto = true
			metadata.emission.powerEmission = powerEmission 
		end
	end

	if data.metadata.car then
		patchAddDefaultEmission(data.metadata, 47, 1.0, 0)
		
		local engine = data.metadata.roadVehicle.engine
		addEngineTypeEmission(engine, data.metadata)
		
	elseif data.metadata.transportVehicle then
		local carrier = data.metadata.transportVehicle.carrier
		if carrier == "TRAM" then
			patchAddDefaultEmission(data.metadata, 68, 1.0, 0)	
			local engine = data.metadata.railVehicle.engines[1]
			addEngineTypeEmission(engine, data.metadata)
			addPseudoRandomEmission(carrier, data.metadata)
		elseif carrier == "RAIL" then
			patchAddDefaultEmission(data.metadata, 65, 0.8, 0)
			local engine = data.metadata.railVehicle.engines[1]
			addEngineTypeEmission(engine, data.metadata)
			addPseudoRandomEmission(carrier, data.metadata)
		elseif carrier == "ROAD" then
			patchAddDefaultEmission(data.metadata, 66, 0.8, 0)
			local engine = data.metadata.roadVehicle.engine
			addEngineTypeEmission(engine, data.metadata)
			addPseudoRandomEmission(carrier, data.metadata)
		elseif carrier == "WATER" then
			patchAddDefaultEmission(data.metadata, 80, 1.0, 0.0) --0.000015
			addPseudoRandomEmission(carrier, data.metadata)
		elseif carrier == "AIR" then
			patchAddDefaultEmission(data.metadata, 90, 0.6, 0.00006)
			addPseudoRandomEmission(carrier, data.metadata)
		elseif carrier == nil then
			patchAddDefaultEmission(data.metadata, 10, 0, 0)
		end
	end

	return data
end

return result
