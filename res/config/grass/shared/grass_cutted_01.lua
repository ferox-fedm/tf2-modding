function data()
return {
	colorTexture = "terrain/grass/grass_light_green_albedo_opacity.dds",
	metalGlossAoTexture = "terrain/grass/grass_light_green_metal_gloss_ao.dds",
	normalTexture = "terrain/grass/grass_light_green_normal.dds",
	translucencyTexture = "terrain/grass/grass_light_green_translucency.dds",
	materials = {"shared/grass_cutted_01.lua"},

	width = 0.5,
	height = 0.2,
	density = 16.0, -- stems per square meter (range allowed 0 to 16)
	lodDistance = 200.0
}
end
