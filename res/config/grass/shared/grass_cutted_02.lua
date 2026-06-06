function data()
return {
	colorTexture = "terrain/grass/grass_green_albedo_opacity.dds",
	metalGlossAoTexture = "terrain/grass/grass_light_green_metal_gloss_ao.dds",		-- same as light green
	normalTexture = "terrain/grass/grass_light_green_normal.dds",					-- same as light green
	translucencyTexture = "terrain/grass/grass_green_translucency.dds",
	materials = {"shared/grass_cutted_02.lua"},

	width = 0.6,
	height = 0.2,
	density = 16.0, -- stems per square meter (range allowed 0 to 16)
	lodDistance = 200.0
}
end
