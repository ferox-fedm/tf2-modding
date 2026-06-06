function data()
return {
	colorTexture = "terrain/grass/grass_brown_albedo_opacity.dds",
	metalGlossAoTexture = "terrain/grass/grass_brown_metal_gloss_ao.dds",
	normalTexture = "terrain/grass/grass_brown_normal.dds",
	translucencyTexture = "terrain/grass/grass_brown_translucency.dds",
	materials = {"usa/sand_yellow.lua"},

	width = 1.0,
	height = 1.0,
	density = 12.0, -- stems per square meter (range allowed 0 to 16)
	lodDistance = 200.0
}
end
