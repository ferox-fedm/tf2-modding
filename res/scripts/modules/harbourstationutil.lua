local vec3 = require "vec3"
local transf = require "transf"
local modulesutil = require "modulesutil"

local harbourutil = {}

function harbourutil.MakePreview(modelConfig, variant) 
	local result = { }
	
	local tf = transf.rotZTransl(math.rad(0), vec3.new(0,0,0))
	
	table.insert(result, { 
		id = modelConfig.main,
		transf = tf,
	})
	for k, addon in pairs(modelConfig.addons) do
		if variant then
			local tf2 = transf.rotZTransl(variant % 2 == 1 and math.pi or 0, vec3.new(0,0,0))
			
			table.insert(result, { 
				id = addon,
				transf = tf2,
			})
		else
			table.insert(result, { 
				id = addon,
				transf = tf,
			})
		end
	end
	for k, el in pairs(modelConfig.end_l) do
		table.insert(result, { 
			id = el,
			transf = tf,
		})
	end
	for k, er in pairs(modelConfig.end_r) do
		table.insert(result, { 
			id = er,
			transf = tf,
		})
	end
	if variant then
		local tf2 = transf.rotZTransl(variant % 2 == 1 and math.pi or 0, vec3.new(0,0,0))
		
		for k, el in pairs(modelConfig.flip_end_l) do
			table.insert(result, { 
				id = el,
				transf = tf2,
			})
		end
	end
	if variant then
		local tf2 = transf.rotZTransl(variant % 2 == 1 and math.pi or 0, vec3.new(0,0,0))
		
		for k, er in pairs(modelConfig.flip_end_r) do
			table.insert(result, { 
				id = er,
				transf = tf2,
			})
		end
	end
	for k, et in pairs(modelConfig.end_t) do
		table.insert(result, { 
			id = et,
			transf = tf,
		})
	end
	for k, eb in pairs(modelConfig.end_b) do
		table.insert(result, { 
			id = eb,
			transf = tf,
		})
	end
	
	return result
end

return harbourutil