local function addDefaultAttachments(defines)
	table.insert(defines, {"OUT_0", "0"})
	table.insert(defines, {"OUT_1", "1"})
	return defines
end

local function addFogOutputs(defines, startLocation)
	table.insert(defines, {"VPOS_LOC", tostring(startLocation)})
	table.insert(defines, {"FOGFACT_LOC", tostring(startLocation + 1)})
	table.insert(defines, {"EXTFACT_LOC", tostring(startLocation + 2)})
	table.insert(defines, {"INSCATT_LOC", tostring(startLocation + 3)})
	-- table.insert(defines, {"VPOS_LOC", "8"})
	-- table.insert(defines, {"FOGFACT_LOC", "9"})
	-- table.insert(defines, {"EXTFACT_LOC", "10"})
	-- table.insert(defines, {"INSCATT_LOC", "11"})
	return defines
end

local function terrainDefines(depth, tess, wireframe)
	-- POS_LOC uses vpos
	ret = { {"ATTR_POS_LOC", "0" }, {"OUT_0", "0"}, {"OUT_1", "1"}, }
	if wireframe then
		table.insert(ret, {"TC_TILEOFFSET_LOC", "UNDEF"})
	else 
		table.insert(ret, {"TC_TILEOFFSET_LOC", "0"})
	end
	if tess then
		table.insert(ret, {"TERRAIN_TESS", "1"})
	end
	if wireframe or depth then
		table.insert(ret, {"DEPTH_LOC", "1"})
		table.insert(ret, {"VPOS_LOC", "UNDEF"})
		table.insert(ret, {"FOGFACT_LOC", "UNDEF"})
		table.insert(ret, {"EXTFACT_LOC", "UNDEF"})
		table.insert(ret, {"INSCATT_LOC", "UNDEF"})
	else
		ret = addFogOutputs(ret, 1)
	end
	return ret
end

local function setDefines(defines)
	local defineKeys = {
		"AGE_LOC",
		"ATTR_NRML_LOC",
		"ATTR_OBJIDX_LOC",
		"ATTR_POS_LOC",
		"ATTR_SMOOTHLOD_POS_LOC",
		"ATTR_TC_1_LOC",
		"ATTR_TC_LOC",
		"ATTR_TNGT_LOC",
		"BINORM_LOC",
		"CBLEND_LOC",
		"COL_LOC",
		"DEPTH_LOC",
		"VPOS_LOC",
		"EXTFACT_LOC",
		"FOGFACT_LOC",
		"INSCATT_LOC",
		"INSTATTR_AGE_LOC",
		"INSTATTR_BBOX_LOC",
		"INSTATTR_CBLEND_LOC",
		"INSTATTR_COL_LOC",
		"INSTATTR_LOGO_LOC",
		"INSTATTR_MDL_LOC",
		"MATIDX_LOC",
		"NRML_LOC",
		"POS_LOC",
		"TC_1_LOC",
		"TC_LOC",
		"TC_LOGO_LOC",
		"TNGT_LOC",
		"OUT_0",
		"OUT_1"
	}

	local result = { }

	for i, k in ipairs(defineKeys) do
		table.insert(result, {k, "UNDEF"})
	end

	for i, def in ipairs(defines) do
		local found = false
		for j, res in ipairs(result) do
			if def[1] == res[1] then 
				res[2] = def[2] 
				found = true
			end
			if not found then result[#result + 1] = def end
		end
	end

	return result
end

local descriptorSetEmpty = { }

local descriptorSet1 = {
	{
		binding = 0,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet2 = {
	{
		binding = 0,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 1,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet3 = {
	{
		binding = 0,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 1,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 2,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 3,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet4 = {
	{
		binding = 0,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 1,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet5 = {
	{
		binding = 0,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSetUI = {
	{
		binding = 1,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet7 = {
	{
		binding = 3,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet8 = {
	{
		binding = 4,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 0,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet9 = {
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet10 = {
	{
		binding = 4,
		stage = "VERTEX",
		storageBuffer = { },
	},
	{
		binding = 5,
		stage = "VERTEX",
		storageBuffer = { },
	},
}

local descriptorSetPhysMaterialType = {
	{
		binding = 4,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 3,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet12 = {
	{
		binding = 7,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 3,
		stage = "VERTEX",
		storageBuffer = { },
	},
}

local descriptorSet13 = {
	{
		binding = 10,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 19,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 20,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 21,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 22,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 12,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 13,
		stage = "VERTEX",
		uniformTexelBuffer = { },
	},
	{
		binding = 6,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 0,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSetPhysWorld = {
	{
		binding = 10,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 19,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 20,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 21,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 22,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 12,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 13,
		stage = "VERTEX",
		uniformTexelBuffer = { },
	},
	{
		binding = 6,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 5,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 8,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 9,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 7,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet15 = {
	{
		binding = 11,
		dynamicUniformBuffer = { },
		stage = "VERTEX",
	},
}

local descriptorSet16 = {
	{
		binding = 11,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 15,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 29,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet17 = {
	{
		binding = 14,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet18 = {
	{
		binding = 14,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 15,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 16,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 17,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet19 = {
	{
		binding = 14,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 23,
		sampler = { },
		stage = "ALL_GRAPHIC",
	},
	{
		binding = 24,
		sampler = { },
		stage = "ALL_GRAPHIC",
	},
	{
		binding = 25,
		sampler = { },
		stage = "ALL_GRAPHIC",
	},
}

local descriptorSet20 = {
	{
		binding = 15,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet21 = {
	{
		binding = 15,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet22 = {
	{
		binding = 19,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 8,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet23 = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSetModelPhys = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet25 = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet26 = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet27 = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet28 = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSetModelPhysNrmlMap = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet30 = {
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet31 = {
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet32 = {
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet33 = {
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet34 = {
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet35 = {
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet36 = {
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet37 = {
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet38 = {
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 14,
		stage = "FRAGMENT",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet39 = {
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet40 = {
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet41 = {
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 29,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 11,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 15,
		stage = "ALL_GRAPHIC",
		uniformBuffer = {
			count = 1,
		},
	},
	{
		binding = 16,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet42 = {
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet43 = {
	{
		binding = 0,
		stage = "VERTEX",
		storageBuffer = { },
	},
	{
		binding = 1,
		stage = "VERTEX",
		storageBuffer = { },
	},
}

local descriptorSet44 = {
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet45 = {
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet46 = {
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet47 = {
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 26,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 27,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet48 = {
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet49 = {
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet50 = {
	{
		binding = 29,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 4,
		stage = "VERTEX",
		uniformBuffer = {
			count = 1,
		},
	},
}

local descriptorSet51 = {
	{
		binding = 29,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 30,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 31,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 32,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local descriptorSet52 = {
	{
		binding = 31,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 24,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 25,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 23,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 28,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 29,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 30,
		sampler = { },
		stage = "FRAGMENT",
	},
	{
		binding = 32,
		sampler = { },
		stage = "FRAGMENT",
	},
}

local pushConstantStandardTechnique = { -- int: inst_attr_tex
		offset = 0,
		size = 4,
		stage = "VERTEX",
}

local pushConstant2 = {
	offset = 0,
	size = 4,
	stage = "ALL_GRAPHIC",
}

local pushConstant3 = {
	offset = 0,
	size = 12,
	stage = "ALL_GRAPHIC",
}

local pushConstant4 = {
	offset = 0,
	size = 16,
	stage = "FRAGMENT",
}

local pushConstant5 = {
	offset = 0,
	size = 16,
	stage = "ALL_GRAPHIC",
}

local pushConstant6 = {
	offset = 0,
	size = 64,
	stage = "ALL_GRAPHIC",
}

local pushConstant7 = {
	offset = 0,
	size = 72,
	stage = "ALL_GRAPHIC",
}

local pushConstant8 = {
	offset = 0,
	size = 96,
	stage = "VERTEX",
}

local pushConstantUI = { -- mat4 , vec4, vec4: proj, alpha scale, colorMix
	offset = 0,
	size = 96,
	stage = "ALL_GRAPHIC",
}

local makeStdCol = function(descriptorSets) 
	return {
		descriptors = descriptorSets,
		pushConstants = { pushConstantUI },
		vertex = { "vs/std_col.vs", },
		fragment = { "fs/std_col.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_COL_LOC", "1"}, {"OUT_0", "0"}, {"COL_LOC", "0"}, },
	}
end

local makeTerrainPushConstant = function() 
	return { }
end

local makeTerrainColorPushConstant = function() 
	return { pushConstant4 }
end

local makeTerrainDescriptorSets = function() 
	return { descriptorSetPhysWorld, descriptorSet16, descriptorSet19,  }
end

local makeTerrainTessDescriptorSets = function() 
	return { descriptorSetPhysWorld, descriptorSet16, descriptorSet19, descriptorSet12  }
end

local makeTerrainDepthDescriptorSets = function() 
	return { descriptorSet13, descriptorSet16, descriptorSet19,  }
end

local makeTerrainDepthTessDescriptorSets = function() 
	return { descriptorSet13, descriptorSet16, descriptorSet19, descriptorSet12  }
end

function data()
return {
	phys = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetModelPhys,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physOp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet27,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetModelPhysNrmlMap,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMapCblend = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet46,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_cblend.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "6"}, {"CBLEND_LOC", "12"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "10"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMapCblendDirt = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet51,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_cblend_dirt.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/dirt_rust.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "6"}, {"CBLEND_LOC", "12"}, {"INSTATTR_AGE_LOC", "7"}, {"AGE_LOC", "13"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "8"}, {"ATTR_NRML_LOC", "9"}, {"ATTR_TC_LOC", "10"}, {"ATTR_TNGT_LOC", "11"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMapCblendDirtLogo = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet51,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_cblend_dirt_logo.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/dirt_rust.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "7"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "6"}, {"CBLEND_LOC", "12"}, {"INSTATTR_AGE_LOC", "7"}, {"AGE_LOC", "13"}, {"INSTATTR_LOGO_LOC", "8"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "9"}, {"ATTR_NRML_LOC", "10"}, {"ATTR_TC_LOC", "11"}, {"ATTR_TNGT_LOC", "12"}, {"ATTR_TC_1_LOC", "13"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMapOp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet25,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMapCblendOp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet47,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_cblend_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "6"}, {"CBLEND_LOC", "12"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "10"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMapUv1Ao = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet48,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_uv1_ao.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "10"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physNrmlMapOpUv1Ao = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet47,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_op_uv1_ao.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "10"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physGlossOnly = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_gloss_only.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physOpGlossOnly = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet30,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_op_gloss_only.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTransp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet32,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspDiffuse = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetEmpty },
		vertex = { "mat/vs/std/color_diffuse.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { { "POS_LOC", "0" }, { "NRML_LOC", "1" }, { "TC_LOC", "UNDEF" }, { "TNGT_LOC", "UNDEF" }, { "BINORM_LOC", "UNDEF" }, { "TC_1_LOC", "UNDEF" }, { "MATIDX_LOC", "UNDEF" }, { "TC_LOGO_LOC", "UNDEF" }, { "VPOS_LOC", "8" }, { "FOGFACT_LOC", "9" }, { "EXTFACT_LOC", "10" }, { "INSCATT_LOC", "12" }, { "INSTATTR_MDL_LOC", "0" }, { "INSTATTR_BBOX_LOC", "4" }, { "INSTATTR_CBLEND_LOC", "UNDEF" }, { "CBLEND_LOC", "UNDEF" }, { "INSTATTR_AGE_LOC", "UNDEF" }, { "AGE_LOC", "UNDEF" }, { "INSTATTR_LOGO_LOC", "UNDEF" }, { "DEPTH_LOC", "UNDEF" }, { "COL_LOC", "11" }, { "ATTR_POS_LOC", "6" }, { "ATTR_NRML_LOC", "7" }, { "ATTR_TC_LOC", "8" }, { "ATTR_TNGT_LOC", "UNDEF" }, { "ATTR_TC_1_LOC", "UNDEF" }, { "ATTR_SMOOTHLOD_POS_LOC", "UNDEF" }, { "ATTR_OBJIDX_LOC", "UNDEF" }, { "OUT_0", "0" }, { "OUT_1", "1" }, },
	},
	physTranspOp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet33,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspUv1Op = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet33,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_uv1_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "9"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspNrmlMapUv1Op = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet35,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_uv1_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "10"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspNrmlMapUv1OpSmoothLod = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet35,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_uv1_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "10"}, {"ATTR_SMOOTHLOD_POS_LOC", "11"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspNrmlMapSmoothLod = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "10"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspNrmlMapOp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet35,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "9"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspNrmlMapCblend = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet49,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_cblend.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "6"}, {"CBLEND_LOC", "12"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "10"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	physTranspNrmlMapCblendDirt = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet52,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_cblend_dirt.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/dirt_rust.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "6"}, {"CBLEND_LOC", "12"}, {"INSTATTR_AGE_LOC", "7"}, {"AGE_LOC", "13"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "8"}, {"ATTR_NRML_LOC", "9"}, {"ATTR_TC_LOC", "10"}, {"ATTR_TNGT_LOC", "11"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	depth = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSetEmpty,  },
		vertex = { "mat/vs/std/depth.vs", },
		fragment = { "mat/fs/depth/std.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "UNDEF"}, {"DEPTH_LOC", "12"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "UNDEF"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, },
	},
	depthAlpha = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/std/depth_alpha.vs", "util/fade_out.glsl", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"DEPTH_LOC", "12"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "7"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, },
	},
	depthAlphaDiffuse = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSetEmpty },
		vertex = { "mat/vs/std/depth_alpha_diffuse.vs", "util/fade_out.glsl", },
		fragment = { "mat/fs/depth/std_alpha_diffuse.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"DEPTH_LOC", "12"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "7"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, },
	},
	depthSmoothLod = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSetEmpty,  },
		vertex = { "mat/vs/std/depth.vs", },
		fragment = { "mat/fs/depth/std.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "UNDEF"}, {"DEPTH_LOC", "12"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "UNDEF"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "8"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, },
	},
	depthAlphaSmoothLod = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/std/depth_alpha.vs", "util/fade_out.glsl", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"DEPTH_LOC", "12"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "7"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "8"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, },
	},
	cblend = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet44,  },
		vertex = { "mat/vs/std/cblend.vs", },
		fragment = { "mat/fs/cblend/std.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "5"}, {"MATIDX_LOC", "6"}, {"TC_LOGO_LOC", "7"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "5"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	color = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetEmpty,  },
		vertex = { "mat/vs/std/color.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "UNDEF"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "UNDEF"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "9"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	colorNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet36,  },
		vertex = { "mat/vs/std/color.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "4"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "10"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "11"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	colorAlpha = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/std/color.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_alpha.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "10"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	colorAlphaDiffuse = {
		pushConstants = { pushConstantStandardTechnique },
			descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetEmpty },
		vertex = { "mat/vs/std/color_diffuse.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_alpha_diffuse.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "10"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	colorAlphaNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39,  },
		vertex = { "mat/vs/std/color.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "10"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "12"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	colorAlphaNrmlMapSmoothLod = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39,  },
		vertex = { "mat/vs/std/color.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "3"}, {"BINORM_LOC", "4"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "10"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "11"}, {"ATTR_OBJIDX_LOC", "12"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	emissive = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet31,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/emissive.fs", "util/lighting.fs", "util/fog.fs", },
		defines = { {"POS_LOC", "UNDEF"}, {"NRML_LOC", "UNDEF"}, {"TC_LOC", "0"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "7"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	leafCard = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34,  },
		vertex = { "mat/vs/leafcard/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "5"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_OFFSET_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_SMOOTHLOD_OFFSET_LOC", "9"}, {"ATTR_NRML_LOC", "10"}, {"ATTR_TNGT_LOC", "11"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	leafCardDepth = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/leafcard/depth.vs", "util/fade_out.glsl", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_OFFSET_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_SMOOTHLOD_OFFSET_LOC", "9"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"DEPTH_LOC", "10"}, {"COL_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	leafCardColor = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39,  },
		vertex = { "mat/vs/leafcard/color.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"ATTR_POS_LOC", "7"}, {"ATTR_OFFSET_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_SMOOTHLOD_OFFSET_LOC", "10"}, {"ATTR_NRML_LOC", "11"}, {"ATTR_TNGT_LOC", "12"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "10"}, {"ATTR_OBJIDX_LOC", "13"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTree = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34,  },
		vertex = { "mat/vs/billboard/normal.vs", "util/inst_attr.vs", },
		geometry = { "mat/vs/billboard/normal.gs", "mat/vs/billboard/billboard_util_p.glsl", "util/fade_out_p.glsl", "util/fog2_p.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_bb.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "5"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeDepth = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/billboard/normal.vs", "util/inst_attr.vs", },
		geometry = { "mat/vs/billboard/depth.gs", "mat/vs/billboard/billboard_util_p.glsl", "util/fade_out_p.glsl", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "11"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeColor = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39,  },
		vertex = { "mat/vs/billboard/color.vs", "util/inst_attr.vs", },
		geometry = { "mat/vs/billboard/normal.gs", "mat/vs/billboard/billboard_util_p.glsl", "util/fade_out_p.glsl", "util/fog2_p.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "4"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "5"}, {"ATTR_NRML_LOC", "6"}, {"ATTR_OBJIDX_LOC", "7"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMulti = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34,  },
		vertex = { "mat/vs/billboard/normal_multi.vs", "util/inst_attr.vs", },
		geometry = { "mat/vs/billboard/normal.gs", "mat/vs/billboard/billboard_util_p.glsl", "util/fade_out_p.glsl", "util/fog2_p.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_bb.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "UNDEF"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "5"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiDepth = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/billboard/normal_multi.vs", "util/inst_attr.vs", },
		geometry = { "mat/vs/billboard/depth.gs", "mat/vs/billboard/billboard_util_p.glsl", "util/fade_out_p.glsl", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "11"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiColor = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39,  },
		vertex = { "mat/vs/billboard/color_multi.vs", "util/inst_attr.vs", },
		geometry = { "mat/vs/billboard/normal.gs", "mat/vs/billboard/billboard_util_p.glsl", "util/fade_out_p.glsl", "util/fog2_p.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "4"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "5"}, {"ATTR_NRML_LOC", "6"}, {"ATTR_OBJIDX_LOC", "7"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinning = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetModelPhys, descriptorSet15,  },
		vertex = { "mat/vs/skinning/normal.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "1"}, {"ATTR_TC_LOC", "2"}, {"ATTR_INFLUENCE_LOC", "3"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningPhysCblend4 = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet28, descriptorSet15,  },
		vertex = { "mat/vs/skinning/normal.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_cblend4.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "5"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "0"}, {"CBLEND_LOC", "10"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_TC_LOC", "6"}, {"ATTR_INFLUENCE_LOC", "7"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningPhysNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetModelPhysNrmlMap, descriptorSet15,  },
		vertex = { "mat/vs/skinning/normal.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "1"}, {"ATTR_TC_LOC", "2"}, {"ATTR_INFLUENCE_LOC", "3"}, {"ATTR_TNGT_LOC", "4"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningPhysNrmlMapOp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet25, descriptorSet15,  },
		vertex = { "mat/vs/skinning/normal.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "1"}, {"ATTR_TC_LOC", "2"}, {"ATTR_INFLUENCE_LOC", "3"}, {"ATTR_TNGT_LOC", "4"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningPhysNrmlMapCblend4 = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet26, descriptorSet15,  },
		vertex = { "mat/vs/skinning/normal.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_nm_cblend4.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "0"}, {"CBLEND_LOC", "10"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_TC_LOC", "6"}, {"ATTR_INFLUENCE_LOC", "7"}, {"ATTR_TNGT_LOC", "8"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningTranspNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34, descriptorSet15,  },
		vertex = { "mat/vs/skinning/normal.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "5"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "1"}, {"ATTR_TC_LOC", "2"}, {"ATTR_INFLUENCE_LOC", "3"}, {"ATTR_TNGT_LOC", "4"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningTranspNrmlMapOp = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet35, descriptorSet15,  },
		vertex = { "mat/vs/skinning/normal.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_op.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "5"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "1"}, {"ATTR_TC_LOC", "2"}, {"ATTR_INFLUENCE_LOC", "3"}, {"ATTR_TNGT_LOC", "4"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningDepth = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSetEmpty, descriptorSet15, },
		vertex = { "mat/vs/skinning/depth.vs", "mat/vs/skinning/util.vs", },
		fragment = { "mat/fs/depth/std.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "10"}, {"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "UNDEF"}, {"ATTR_INFLUENCE_LOC", "1"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningDepthAlpha = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23, descriptorSet15, },
		vertex = { "mat/vs/skinning/depth_alpha.vs", "util/fade_out.glsl", "mat/vs/skinning/util.vs", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "5"}, {"FOGFACT_LOC", "6"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"DEPTH_LOC", "10"}, {"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "1"}, {"ATTR_INFLUENCE_LOC", "2"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningColor = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSetEmpty, descriptorSet15,  },
		vertex = { "mat/vs/skinning/color.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "5"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "0"}, {"COL_LOC", "10"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "1"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "UNDEF"}, {"ATTR_INFLUENCE_LOC", "2"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "3"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningColorNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet36, descriptorSet15,  },
		vertex = { "mat/vs/skinning/color.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "0"}, {"COL_LOC", "10"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "1"}, {"ATTR_NRML_LOC", "2"}, {"ATTR_TC_LOC", "3"}, {"ATTR_INFLUENCE_LOC", "4"}, {"ATTR_TNGT_LOC", "5"}, {"ATTR_OBJIDX_LOC", "6"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	skinningColorAlphaNrmlMap = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39, descriptorSet15,  },
		vertex = { "mat/vs/skinning/color.vs", "util/inst_attr.vs", "mat/vs/skinning/util.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "6"}, {"FOGFACT_LOC", "7"}, {"EXTFACT_LOC", "8"}, {"INSCATT_LOC", "9"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_COL_LOC", "0"}, {"COL_LOC", "10"}, {"DEPTH_LOC", "UNDEF"}, {"ATTR_POS_LOC", "1"}, {"ATTR_NRML_LOC", "2"}, {"ATTR_TC_LOC", "3"}, {"ATTR_INFLUENCE_LOC", "4"}, {"ATTR_TNGT_LOC", "5"}, {"ATTR_OBJIDX_LOC", "6"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	noTexture = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld, descriptorSet21,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/no_tex.fs", "util/lighting.fs", "util/fog.fs", },
		defines = { {"INSTATTR_MDL_LOC", "0"}, {"ATTR_NRML_LOC", "4"}, {"ATTR_POS_LOC", "5"}, {"ATTR_TNGT_LOC", "6"}, {"ATTR_TC_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"INSTATTR_BBOX_LOC", "UNDEF"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"COL_LOC", "2"}, {"VPOS_LOC", "3"}, {"FOGFACT_LOC", "4"}, {"EXTFACT_LOC", "5"}, {"INSCATT_LOC", "6"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"TC_DETAIL_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	labelText = {
		pushConstants = { pushConstant3 },
		descriptors = { descriptorSetPhysWorld, descriptorSet9, descriptorSet1,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/label_text.fs", "util/lighting.fs", "util/fog.fs", },
		defines = setDefines(addFogOutputs(addDefaultAttachments({ {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"COL_LOC", "3"}, {"INSTATTR_MDL_LOC", "0"}, {"ATTR_POS_LOC", "6"}, {"ATTR_TC_LOC", "7"}, { "ATTR_NRML_LOC", "4" }, { "ATTR_TNGT_LOC", "5" } }), 8)),
	},
	water = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld, descriptorSet42, descriptorSet17,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/water.fs", "mat/fs/water_common.fs", "util/lighting.fs", "util/fog.fs", },
		defines = setDefines(addFogOutputs(addDefaultAttachments({ {"POS_LOC", "0"}, {"INSTATTR_MDL_LOC", "0"}, {"ATTR_POS_LOC", "4"}, {"ATTR_TC_LOC", "5"} }), 8)),
	},
	waterNormals = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld, descriptorSet37, descriptorSet20,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/water_normals.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = setDefines(addFogOutputs(addDefaultAttachments({ {"POS_LOC", "0"}, {"TC_LOC", "1"}, {"INSTATTR_MDL_LOC", "0"}, {"ATTR_POS_LOC", "4"}, {"ATTR_TC_LOC", "5"} }), 8)),
	},
	waterColor = {
		pushConstants = { pushConstant5 },
		descriptors = { descriptorSetPhysWorld, descriptorSet9, descriptorSet17,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/water_color.fs", "mat/fs/water_common.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = setDefines(addFogOutputs(addDefaultAttachments({ {"POS_LOC", "0"}, {"INSTATTR_MDL_LOC", "0"}, {"ATTR_POS_LOC", "4"}, {"ATTR_TC_LOC", "5"} }), 8)),
	},
	waterWave = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld, descriptorSet45, descriptorSet38,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/water_waves.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "UNDEF"}, {"TC_LOC", "1"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "UNDEF"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "5"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	waterSkirt = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld, descriptorSet7, descriptorSetModelPhys,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/normal/phys_transp.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "6"}, {"ATTR_NRML_LOC", "7"}, {"ATTR_TC_LOC", "8"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	waterSkirtColor = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSet7, descriptorSetModelPhys,  },
		vertex = { "mat/vs/std/color.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/color/std_alpha.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "4"}, {"INSTATTR_COL_LOC", "6"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "7"}, {"ATTR_NRML_LOC", "8"}, {"ATTR_TC_LOC", "9"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "10"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	shipFoam = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld, descriptorSet40, descriptorSet38, },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/ship_foam.fs", "util/lighting.fs", "util/fog.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "UNDEF"}, {"TC_LOC", "1"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "UNDEF"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "5"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	shipFoamNormals = {
		pushConstants = { },
		descriptors = {  descriptorSetPhysWorld, descriptorSet50,  },
		vertex = { "mat/vs/std/normal.vs", "util/fade_out.glsl", "util/inst_attr.vs", "util/fog.glsl", },
		fragment = { "mat/fs/ship_foam_normals.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "UNDEF"}, {"TC_LOC", "1"}, {"TNGT_LOC", "UNDEF"}, {"BINORM_LOC", "UNDEF"}, {"TC_1_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"TC_LOGO_LOC", "UNDEF"}, {"VPOS_LOC", "8"}, {"FOGFACT_LOC", "9"}, {"EXTFACT_LOC", "10"}, {"INSCATT_LOC", "11"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_BBOX_LOC", "UNDEF"}, {"INSTATTR_CBLEND_LOC", "UNDEF"}, {"CBLEND_LOC", "UNDEF"}, {"INSTATTR_AGE_LOC", "UNDEF"}, {"AGE_LOC", "UNDEF"}, {"INSTATTR_LOGO_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "UNDEF"}, {"ATTR_TC_LOC", "5"}, {"ATTR_TNGT_LOC", "UNDEF"}, {"ATTR_TC_1_LOC", "UNDEF"}, {"ATTR_SMOOTHLOD_POS_LOC", "UNDEF"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	sky = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld,  },
		vertex = { "mat/vs/sky.vs", "util/fog.glsl", },
		fragment = { "mat/fs/sky.fs", "util/lighting.fs", "util/fog.fs", },
		defines = addDefaultAttachments(addFogOutputs({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"} }, 1)),
	},
	terrainSkirt = {
		pushConstants = { },
		descriptors = { descriptorSetPhysWorld, descriptorSetModelPhys,  },
		vertex = { "terrain/terrain_skirt.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_skirt.fs", "util/lighting.fs", "util/fog.fs", },
		defines = addDefaultAttachments(addFogOutputs({
				{"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "1"}, {"ATTR_TC_LOC", "2"},
				{"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TC_1_LOC", "3"},
			}, 4)),
	},
	terrainSkirtColor = {
		pushConstants = { pushConstant4 },
		descriptors = { descriptorSetPhysWorld, descriptorSetModelPhys,  },
		vertex = { "terrain/terrain_skirt.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_skirt_color.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = addDefaultAttachments(addFogOutputs({
				{"ATTR_POS_LOC", "0"}, {"ATTR_NRML_LOC", "1"}, {"ATTR_TC_LOC", "2"},
				{"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TC_LOC", "2"}, {"TC_1_LOC", "3"},
			}, 4)),
	},
	terrain3x3 = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrain3x3Tess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainTriplanar3x3 = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainTriplanar3x3Tess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColor3x3 = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColor3x3Tess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorTriplanar3x3 = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorTriplanar3x3Tess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrain3x3Sixteen = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrain3x3SixteenTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainTriplanar3x3Sixteen = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainTriplanar3x3SixteenTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColor3x3Sixteen = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColor3x3SixteenTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorTriplanar3x3Sixteen = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorTriplanar3x3SixteenTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrain3x3Special = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrain3x3SpecialTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainTriplanar3x3Special = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainTriplanar3x3SpecialTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColor3x3Special = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColor3x3SpecialTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorTriplanar3x3Special = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorTriplanar3x3SpecialTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special_3x3.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrain = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainTriplanar = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainTriplanarTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColor = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorTriplanar = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorTriplanarTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_eight.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainSixteen = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainSixteenTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainTriplanarSixteen = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainTriplanarSixteenTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorSixteen = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorSixteenTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorTriplanarSixteen = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorTriplanarSixteenTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_sixteen.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainSpecial = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainSpecialTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainTriplanarSpecial = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainTriplanarSpecialTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorSpecial = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorSpecialTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorTriplanarSpecial = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorTriplanarSpecialTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color_triplanar.fs", "terrain/filter_special.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainNoFilter = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_disable.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		defines = terrainDefines(false, false),
	},
	terrainNoFilterTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain.fs", "terrain/level_color.fs", "terrain/filter_disable.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainColorNoFilter = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain.vs", "util/fog.glsl", },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_disable.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		defines = terrainDefines(false, false),
	},
	terrainColorNoFilterTess = {
		pushConstants = makeTerrainColorPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_color.fs", "terrain/level_color.fs", "terrain/filter_disable.fs", "terrain/terrain_common.fs", "util/util.fs", "util/lighting.fs", "util/fog.fs", "util/color_map.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true),
	},
	terrainDepth = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDepthDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain_depth.vs", },
		fragment = { "terrain/terrain_depth.fs", "terrain/terrain_common.fs", "util/depth.fs", "util/util.fs", "terrain/level_color.fs", },
		defines = terrainDefines(true, false),
	},
	terrainDepthTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDepthTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_depth.fs", "terrain/terrain_common.fs", "util/depth.fs", "util/util.fs", "terrain/level_color.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = { "terrain/terrain_depth.tese", "terrain/terrainTess_common.glsl" },
		defines = terrainDefines(true, true),
	},
	terrainDepthZ = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainDescriptorSets(),
		vertex = { "terrain/terrain_common.vs", "terrain/terrain_depth.vs", },
		fragment = { "terrain/terrain_depth.fs", "terrain/terrain_common.fs", "util/depth_z.fs", "util/util.fs", "terrain/level_color.fs", },
		defines = terrainDefines(true, false),
	},
	terrainDepthZTess = {
		pushConstants = makeTerrainPushConstant(),
		descriptors = makeTerrainTessDescriptorSets(),
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrain_depth.fs", "terrain/terrain_common.fs", "util/depth_z.fs", "util/util.fs", "terrain/level_color.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = { "terrain/terrain_depth.tese", "terrain/terrainTess_common.glsl" },
		defines = terrainDefines(true, true),
	},
	terrainWireframeTess = {
		pushConstants = { pushConstant4 },
		descriptors = { descriptorSetPhysWorld, descriptorSet16, descriptorSet19, descriptorSet12,  },
		vertex = { "terrain/terrainTess.vs" },
		fragment = { "terrain/terrainWireframeTess.fs", },
		tessControl = { "terrain/terrain.tesc" },
		tessEvaluation = {"terrain/terrain.tese", "terrain/terrainTess_common.glsl", "util/fog.glsl" },
		defines = terrainDefines(false, true, true),
	},
	stdTex = {
		pushConstants = { pushConstant8 },
		descriptors = { descriptorSetUI, descriptorSet1,  },
		vertex = { "vs/std.vs", },
		fragment = { "fs/std.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "1"}, {"TC_LOC", "1"}, {"OUT_0", "0"}, },
	},
	stdColUI = makeStdCol({ descriptorSetUI }),
	-- stdColXX = makeStdCol({ descriptorSet1 }),
	stdColSimple = makeStdCol({ }),
	stdTexCol = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSetUI, descriptorSet1,  },
		vertex = { "vs/std_tex_col.vs", },
		fragment = { "fs/std_tex_col.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "1"}, {"ATTR_COL_LOC", "2"}, {"COL_LOC", "0"}, {"TC_LOC", "1"}, {"OUT_0", "0"}, },
	},
	stdPoint = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSet1,  },
		vertex = { "vs/std_point.vs", },
		fragment = { "fs/std_point.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_COL_LOC", "1"}, {"COL_LOC", "0"}, {"OUT_0", "0"}, },
	},
	one_mask_alpha = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSetUI, descriptorSet1,  },
		vertex = { "vs/std_tex_col.vs", },
		fragment = { "ui/one_mask_alpha.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "1"}, {"ATTR_COL_LOC", "2"}, {"TC_LOC", "0"}, {"COL_LOC", "1"}, {"OUT_0", "0"}, },
	},
	isocontours = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSet8,  },
		vertex = { "vs/std.vs", },
		fragment = { "fs/isocontours.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "1"}, {"TC_LOC", "0"}, {"OUT_0", "0"} },
	},
	linesColor = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSetUI,  },
		vertex = { "vs/std_col.vs", },
		fragment = { "ui/lines_col.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_COL_LOC", "1"}, {"COL_LOC", "0"}, {"OUT_0", "0"}, },
	},
	linesTexColor = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSetUI, descriptorSet1 },
		vertex = { "vs/std_tex_col.vs", },
		fragment = { "ui/lines_tex_col.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "2"}, {"ATTR_COL_LOC", "1"}, {"COL_LOC", "0"}, {"TC_LOC", "1"}, {"OUT_0", "0"}, },
	},
	hdrLum = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet5,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/lum.fs", "util/util.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"} }),
	},
	hdrScale = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet1,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/scale.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"} }),
	},
	hdrBlurH = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet5,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/blur.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"}, {"VERTICAL", "0"}, {"SIZE", "9"} }),
	},
	hdrBlurV = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet5,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/blur.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"}, {"VERTICAL", "1"}, {"SIZE", "9"} }),
	},
	hdrBlurH_15 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet5,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/blur.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"}, {"VERTICAL", "0"}, {"SIZE", "15"} }),
	},
	hdrBlurV_15 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet5,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/blur.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"}, {"VERTICAL", "1"}, {"SIZE", "15"} }),
	},
	hdrBlurCompose = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet3,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/blur_compose.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"} }),
	},
	mipmapGen = {
		pushConstants = { pushConstant7 },
		descriptors = { descriptorSet1,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "hdr/mipmap.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"} }),
	},
	hdrCompose = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSet4,  },
		vertex = { "vs/std.vs", },
		fragment = { "hdr/compose.fs", },
		defines = setDefines(addDefaultAttachments({ {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "1"}, {"TC_LOC", "1"} }), 8),
	},
	hdrHistogram = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSet5,  },
		vertex = { "vs/std.vs", },
		fragment = { "hdr/histogram.fs", "util/util.fs", },
		defines = setDefines(addDefaultAttachments({ {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "1"}, {"TC_LOC", "1"} }), 8),
	},
	ssaoMain = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet22,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "misc/ssao.fs", "util/lighting.fs", "util/fog.fs" },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"} }),
	},
	ssaoApply = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSet2,  },
		vertex = { "vs/std_auto_uv.vs", },
		fragment = { "misc/ssao_apply.fs", },
		defines = setDefines({ {"ATTR_POS_LOC", "0"}, {"TC_LOC", "0"}, {"OUT_0", "0"} }),
	},
	
	smoke = {
		pushConstants = { pushConstant2 },
		descriptors = { descriptorSetPhysWorld, descriptorSet18, descriptorSet10,  },
		vertex = { "misc/smoke.vs", "util/fog.glsl", },
		geometry = { "misc/smoke.gs", "util/fog.glsl", },
		fragment = { "misc/smoke.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addFogOutputs({
			{"ATTR_POS_LOC", "0"}, {"ATTR_COL_LOC", "1"},
			{"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BNRML_LOC", "3"}, 
				{"TC_LOC", "4"}, {"COL_LOC", "5"}, {"ALPHA_LOC", "6"}, {"RAND_LOC", "7"},
			{"OUT_0", "0"}, {"OUT_1", "1"},
		}, 8),
	},
	smokeSsbo = {
		pushConstants = { pushConstant2 },
		descriptors = { descriptorSetPhysWorld, descriptorSet18, descriptorSet10,  },
		vertex = { "misc/smoke2.vs", "util/fog.glsl", },
		fragment = { "misc/smoke.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addFogOutputs({
			{"ATTR_POS_LOC", "0"}, {"ATTR_COL_LOC", "1"},
			{"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BNRML_LOC", "3"}, 
				{"TC_LOC", "4"}, {"COL_LOC", "5"}, {"ALPHA_LOC", "6"}, {"RAND_LOC", "7"},
			{"OUT_0", "0"}, {"OUT_1", "1"},
		}, 8),
	},

	debug = {
		pushConstants = { pushConstantUI },
		descriptors = { descriptorSetUI, descriptorSet1,  },
		vertex = { "vs/std.vs", },
		fragment = { "misc/debug.fs", "util/util.fs", },
		defines = { {"ATTR_POS_LOC", "0"}, {"ATTR_TC_LOC", "1"}, {"TC_LOC", "0"}, {"OUT_0", "0"}, },
	},

	-- billboardCompute = {
	-- 	compute = {"comp/billboard.comp"},
	-- },
	bbTreeTess = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34,  },
		vertex = { "mat/vs/billboard/normal_tess.vs", "util/inst_attr.vs", "util/fog2.glsl", "util/fade_out.glsl"},
		tessControl = {"mat/vs/billboard/billboard.tesc"},
		tessEvaluation = {"mat/vs/billboard/billboard.tese"},
		fragment = { "mat/fs/normal/phys_transp_nm_bb.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "5"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeDepthTess = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/billboard/depth_tess.vs", "util/inst_attr.vs", "util/fade_out.glsl" },
		tessControl = {"mat/vs/billboard/billboard.tesc"},
		tessEvaluation = {"mat/vs/billboard/billboard_depth.tese"},
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "UNDEF"}, {"FOGFACT_LOC", "UNDEF"}, {"EXTFACT_LOC", "UNDEF"}, {"INSCATT_LOC", "UNDEF"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "11"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeColorTess = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39,  },
		vertex = { "mat/vs/billboard/color_tess.vs", "util/inst_attr.vs", "util/fog2.glsl", "util/fade_out.glsl" },
		tessControl = {"mat/vs/billboard/billboard.tesc"},
		tessEvaluation = {"mat/vs/billboard/billboard.tese"},
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "4"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "5"}, {"ATTR_NRML_LOC", "6"}, {"ATTR_OBJIDX_LOC", "7"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiTess = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34,  },
		vertex = { "mat/vs/billboard/normal_tess_multi.vs", "util/inst_attr.vs", "util/fog2.glsl", "util/fade_out.glsl"},
		tessControl = {"mat/vs/billboard/billboard.tesc"},
		tessEvaluation = {"mat/vs/billboard/billboard.tese"},
		fragment = { "mat/fs/normal/phys_transp_nm_bb.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "UNDEF"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "5"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiDepthTess = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23,  },
		vertex = { "mat/vs/billboard/depth_tess_multi.vs", "util/inst_attr.vs", "util/fade_out.glsl" },
		tessControl = {"mat/vs/billboard/billboard.tesc"},
		tessEvaluation = {"mat/vs/billboard/billboard_depth.tese"},
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "UNDEF"}, {"FOGFACT_LOC", "UNDEF"}, {"EXTFACT_LOC", "UNDEF"}, {"INSCATT_LOC", "UNDEF"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "11"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiColorTess = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39,  },
		vertex = { "mat/vs/billboard/color_tess_multi.vs", "util/inst_attr.vs", "util/fog2.glsl", "util/fade_out.glsl" },
		tessControl = {"mat/vs/billboard/billboard.tesc"},
		tessEvaluation = {"mat/vs/billboard/billboard.tese"},
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "4"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "5"}, {"ATTR_NRML_LOC", "6"}, {"ATTR_OBJIDX_LOC", "7"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},

	
	bbTreeSsbo = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34, descriptorSet43,  },
		vertex = { "mat/vs/billboard/normal_ssbo.vs", "util/inst_attr.vs", "util/fade_out.glsl", "util/fog.glsl", "mat/vs/billboard/billboard_util.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_bb.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "UNDEF"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "5"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeDepthSsbo = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23, descriptorSet43,  },
		vertex = { "mat/vs/billboard/depth_ssbo.vs", "util/inst_attr.vs", "util/fade_out.glsl", "util/fog.glsl", "mat/vs/billboard/billboard_util.glsl", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "UNDEF"}, {"FOGFACT_LOC", "UNDEF"}, {"EXTFACT_LOC", "UNDEF"}, {"INSCATT_LOC", "UNDEF"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "11"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeColorSsbo = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39, descriptorSet43,  },
		vertex = { "mat/vs/billboard/color_ssbo.vs", "util/inst_attr.vs", "util/fade_out.glsl", "util/fog.glsl", "mat/vs/billboard/billboard_util.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "4"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "5"}, {"ATTR_NRML_LOC", "6"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiSsbo = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet34, descriptorSet43,  },
		vertex = { "mat/vs/billboard/normal_multi_ssbo.vs", "util/inst_attr.vs", "util/fade_out.glsl", "util/fog.glsl", "mat/vs/billboard/billboard_util.glsl", },
		fragment = { "mat/fs/normal/phys_transp_nm_bb.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "UNDEF"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "5"}, {"MATIDX_LOC", "6"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiDepthSsbo = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSet13, descriptorSetPhysMaterialType, descriptorSet23, descriptorSet43,  },
		vertex = { "mat/vs/billboard/depth_multi_ssbo.vs", "util/inst_attr.vs", "util/fade_out.glsl", "util/fog.glsl", "mat/vs/billboard/billboard_util.glsl", },
		fragment = { "mat/fs/depth/std_alpha.fs", "util/depth.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "UNDEF"}, {"FOGFACT_LOC", "UNDEF"}, {"EXTFACT_LOC", "UNDEF"}, {"INSCATT_LOC", "UNDEF"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "UNDEF"}, {"DEPTH_LOC", "11"}, {"COL_LOC", "UNDEF"}, {"ATTR_POS_LOC", "4"}, {"ATTR_NRML_LOC", "5"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	bbTreeMultiColorSsbo = {
		pushConstants = { pushConstantStandardTechnique },
		descriptors = { descriptorSetPhysWorld, descriptorSetPhysMaterialType, descriptorSet39, descriptorSet43,  },
		vertex = { "mat/vs/billboard/color_multi_ssbo.vs", "util/inst_attr.vs", "util/fade_out.glsl", "util/fog.glsl", "mat/vs/billboard/billboard_util.glsl", },
		fragment = { "mat/fs/color/std_alpha_nm.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = { {"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BINORM_LOC", "3"}, {"TC_LOC", "4"}, {"OFFSET_LOC", "UNDEF"}, {"MATIDX_LOC", "UNDEF"}, {"VPOS_LOC", "7"}, {"FOGFACT_LOC", "8"}, {"EXTFACT_LOC", "9"}, {"INSCATT_LOC", "10"}, {"INSTATTR_MDL_LOC", "0"}, {"INSTATTR_COL_LOC", "4"}, {"DEPTH_LOC", "UNDEF"}, {"COL_LOC", "11"}, {"ATTR_POS_LOC", "5"}, {"ATTR_NRML_LOC", "6"}, {"ATTR_OBJIDX_LOC", "UNDEF"}, {"OUT_0", "0"}, {"OUT_1", "1"}, },
	},
	
	---- GRASS SHADERS
	grass_0 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass.vs", },
		geometry = { "terrain/grass_common.gs", "terrain/create_quad.gs", "util/fog.glsl", },
		fragment = { "terrain/grass.fs", "terrain/terrain_common.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, 
			{"TC_LOC", "3"}, {"MATTYPE_LOC", "4"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 6)),
	},
	grassDepthZ_0 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass.vs", },
		geometry = { "terrain/grass_depth.gs", "terrain/create_quad.gs", },
		fragment = { "terrain/grass_depth.fs", },
		defines = addDefaultAttachments({{"VPOS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, 
			{"TC_LOC", "3"}, {"MATTYPE_LOC", "4"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}),
	},
	grassColor_0 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass.vs", },
		geometry = { "terrain/grass_common.gs", "terrain/create_quad.gs", "util/fog.glsl", },
		fragment = { "terrain/grass_color.fs", "terrain/terrain_common.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, 
			{"TC_LOC", "3"}, {"MATTYPE_LOC", "4"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 6)),
	},
	grass_1 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass.vs", },
		geometry = { "terrain/grass_common.gs", "terrain/create_quad_1.gs", "util/fog.glsl", },
		fragment = { "terrain/grass.fs", "terrain/terrain_common.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, 
			{"TC_LOC", "3"}, {"MATTYPE_LOC", "4"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 6)),
	},
	grassDepthZ_1 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass.vs", },
		geometry = { "terrain/grass_depth.gs", "terrain/create_quad_1.gs", },
		fragment = { "terrain/grass_depth.fs", },
		defines = addDefaultAttachments({{"VPOS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, 
			{"TC_LOC", "3"}, {"MATTYPE_LOC", "4"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}),
	},
	grassColor_1 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass.vs", },
		geometry = { "terrain/grass_common.gs", "terrain/create_quad_1.gs", "util/fog.glsl", },
		fragment = { "terrain/grass_color.fs", "terrain/terrain_common.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, 
			{"TC_LOC", "3"}, {"MATTYPE_LOC", "4"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 6)),
	},
	
	grassTess = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_tess.vs", "util/fog2.glsl", },
		tessControl = {"terrain/grass.tesc"},
		tessEvaluation = {"terrain/grass.tese"},
		fragment = { "terrain/grass.fs", "terrain/terrain_common.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},
	grassDepthZTess = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_tess.vs", "util/fog2.glsl", },
		tessControl = {"terrain/grass.tesc"},
		tessEvaluation = {"terrain/grass.tese"},
		fragment = { "terrain/grass_depth.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},
	grassColorTess = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_tess.vs", "util/fog2.glsl", },
		tessControl = {"terrain/grass.tesc"},
		tessEvaluation = {"terrain/grass.tese"},
		fragment = { "terrain/grass_color.fs", "terrain/terrain_common.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},

	grassVert_0 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_vert.vs", "util/fog.glsl", },
		fragment = { "terrain/grass.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"GRASS_QUALITY", "0"}, {"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},
	grassDepthZVert_0 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_depth_vert.vs", },
		fragment = { "terrain/grass_depth.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"GRASS_QUALITY", "0"}, {"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},
	grassColorVert_0 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_vert.vs", "util/fog.glsl", },
		fragment = { "terrain/grass_color.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"GRASS_QUALITY", "0"}, {"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},
	grassVert_1 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_vert.vs", "util/fog.glsl", },
		fragment = { "terrain/grass.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"GRASS_QUALITY", "1"}, {"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},
	grassDepthZVert_1 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_depth_vert.vs", },
		fragment = { "terrain/grass_depth.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"GRASS_QUALITY", "1"}, {"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},
	grassColorVert_1 = {
		pushConstants = { pushConstant6 },
		descriptors = { descriptorSetPhysWorld, descriptorSet41, descriptorSet19,  },
		vertex = { "terrain/grass_vert.vs", "util/fog.glsl", },
		fragment = { "terrain/grass_color.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", "util/color_map.fs", },
		defines = addDefaultAttachments(addFogOutputs({{"GRASS_QUALITY", "1"}, {"NRML_LOC", "0"}, {"TNGT_LOC", "1"}, 
			{"TC_LOC", "2"}, {"MATTYPE_LOC", "3"}, {"TC_TILEOFFSET_LOC", "UNDEF"}}, 4)),
	},

	smokeTess = {
		pushConstants = { pushConstant2 },
		descriptors = { descriptorSetPhysWorld, descriptorSet18, descriptorSet10,  },
		vertex = { "misc/smoke_tess.vs", "util/fog2.glsl", },
		tessControl = {"misc/smoke.tesc"},
		tessEvaluation = {"misc/smoke.tese"},
		fragment = { "misc/smoke.fs", "util/lighting.fs", "util/fog.fs", "util/util.fs", },
		defines = addFogOutputs({
			{"ATTR_POS_LOC", "0"}, {"ATTR_COL_LOC", "1"},
			{"POS_LOC", "0"}, {"NRML_LOC", "1"}, {"TNGT_LOC", "2"}, {"BNRML_LOC", "3"}, 
				{"TC_LOC", "4"}, {"COL_LOC", "5"}, {"ALPHA_LOC", "6"}, {"RAND_LOC", "7"},
			{"OUT_0", "0"}, {"OUT_1", "1"},
		}, 8),
	},
	
}
end
