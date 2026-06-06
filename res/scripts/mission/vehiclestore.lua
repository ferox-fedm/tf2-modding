local t = {}

local state = {
	allowedvehicles = {},
	allowedvehicles2 = {},
	allowedvehiclegroups = {},
	lockedvehicles = {}, -- entity ids that may not be sold
	currentvehicles = {},
}

local guistate = {
	purchasedvehicles = {},
}

t.currentvehicles = state.currentvehicles

local function countVehicles()
	local vehicles = game.interface.getVehicles()
	local curr = {}
	for i = 1, #vehicles do
		local vehicle = game.interface.getEntity(vehicles[i])
		local istrain = vehicle.vehicles ~= nil
		if istrain then
			for j = 1, #vehicle.vehicles do
				local wagon = vehicle.vehicles[j]
				curr[wagon.fileName] = 1 + (curr[wagon.fileName] or 0)
			end
		else
			curr[vehicle.fileName] = 1 + (curr[vehicle.fileName] or 0)
		end
	end
	return curr
end

function t.setAllowedVehicleCount(modelname, count, minCount)
	assert(game.gui == nil)
	state.allowedvehicles2[modelname] = {count, (minCount and minCount or 0)}
end

function t.setAllowedVehicleGroupCount(id, modelnames, count)
	assert(game.gui == nil)
	state.allowedvehiclegroups[id] = { modelnames, count }
end

function t.lockVehicle(entity)
	assert(game.gui == nil)
	state.lockedvehicles[entity] = true
end

function t.unlockVehicle(entity)
	assert(game.gui == nil)
	state.lockedvehicles[entity] = nil
end

local function checkPurchase(current, delta, allowed, vehicleid, minCount)
	if current + delta > allowed then
		if allowed == 0 then
			return { _("Vehicle unavailable at this time") }
		else
			return { _("Not enough vehicles available at this time") }
		end
	end
	if minCount ~= nil and current + delta < minCount then
		return { _("Minimum number of vehicles to be purchased not met") }
	end
	guistate.purchasedvehicles[vehicleid] = (guistate.purchasedvehicles[vehicleid] or 0) + delta --assume purchase was successful
	guistate.resetcounter = 3
end

local function legacyhandling(state)
	if game.gui then return end
	state.currentvehicles = state.currentvehicles or {}
	state.lockedvehicles = state.lockedvehicles or {}

	if state.allowedvehicles2 == nil then
		state.allowedvehicles2 = {}

		assert(state.allowedvehicles ~= nil)
		for k, v in pairs(state.allowedvehicles) do
			if v ~= -1 then
				state.allowedvehicles2[k] = { v, 0 }
			end
		end
	end

	local todelete = {}
	for k, v in pairs(state.allowedvehiclegroups) do
		if v[2] == -1 then todelete[#todelete + 1] = k end
	end

	for i = 1, #todelete do
		state.allowedvehiclegroups[todelete[i]] = nil
	end
end

t.script = {
	save = function()
		return state
	end,
	load = function(loadedstate)
		state = loadedstate or state
		legacyhandling(state)

		t.currentvehicles = state.currentvehicles
		if guistate.resetcounter then
			guistate.resetcounter = guistate.resetcounter - 1
			if guistate.resetcounter <= 0 then
				guistate.resetcounter = nil
				guistate.purchasedvehicles = {}
			end
		end
	end,
	update = function()
		t.currentvehicles = countVehicles()
		state.currentvehicles = t.currentvehicles
	end,
	guiHandleEvent = function (id, name, param)
		if id == "vehicleManager" and name == "accept" then
			if state.lockedvehicles[param.entity] then
				return { "Vehicle locked" }
			end

			local oldvehiclecount = {}
			if param.entity >= 0 then
				local vehicles = game.interface.getEntity(param.entity).vehicles
				for i = 1, #vehicles do
					local f = vehicles[i].fileName
					oldvehiclecount[f] = (oldvehiclecount[f] or 0) + 1
				end
			end

			local vehiclecount = {}
			for i = 1, #param.vehicleConfig do
				local v = param.vehicleConfig[i]
				vehiclecount[v] = (vehiclecount[v] or 0) + 1
			end

			for k, v in pairs(vehiclecount) do
				vehiclecount[k] = v - (oldvehiclecount[k] or 0)
			end

			for k, delta in pairs(vehiclecount) do
				assert(state.allowedvehicles2 ~= nil)

				local allowedcount = state.allowedvehicles2[k] and state.allowedvehicles2[k][1]
				local minCount = state.allowedvehicles2[k] and state.allowedvehicles2[k][2]

				if allowedcount ~= nil then
					local c = (t.currentvehicles[k] or 0) + (guistate.purchasedvehicles[k] or 0)
					local err = checkPurchase(c, delta, allowedcount, k, minCount)
					if err then return err end
				end

				for _, groupcount in pairs(state.allowedvehiclegroups) do
					local modelnames = groupcount[1]
					local modelnamescount = groupcount[2]
					if modelnamescount ~= nil then
						local total = 0
						for _,m in pairs(modelnames) do
							total = total + (t.currentvehicles[m] or 0) + (guistate.purchasedvehicles[m] or 0)
						end
						local err = checkPurchase(total, delta, modelnamescount, k)
						if err then return err end
					end
				end
			end
		end
	end
}

return t
