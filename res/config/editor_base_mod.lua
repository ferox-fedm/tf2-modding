local ffu = require "filefilterutil"
local bridgeutil = require "bridgeutil"
local metadatautil = require "metadatautil"

function data()
return {
	runFn = function (settings)
		addModifier("loadModel", function(fileName, data)
			local tv = data.metadata.transportVehicle
			
			if tv then
				if tv.seats and not data.metadata.seatProvider then
					local sp = { }
					sp.seats = tv.seats
					if tv.carrier == "AIR" then sp.drivingLicense = "AIR" end
					if tv.carrier == "RAIL" then sp.drivingLicense = "RAIL" end
					if tv.carrier == "ROAD" then sp.drivingLicense = "BUS" end
					if tv.carrier == "TRAM" then sp.drivingLicense = "TRAM" end
					if tv.carrier == "WATER" then sp.drivingLicense = "WATER" end
					sp.crewModels = tv.crewModels
					
					data.metadata.seatProvider = sp
					
					for k,v in pairs(data.metadata.seatProvider.seats) do
						if v.animation == nil then
							v.animation = v.standing and "idle" or "sitting"
						end
					end
				end
			end
			
			return data
		end)
		
		addModifier("loadModel", function(fileName, data)
			if data.collider and data.collider.params and data.collider.params.center then
				local c = data.collider.params.center
				data.collider.transf = { 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, c[1], c[2], c[3], 1 }
			end
			
			return data
		end)
	end
}
end
