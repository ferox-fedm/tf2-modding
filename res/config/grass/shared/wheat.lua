function data()
return {
	colorTexture = "terrain/grass/wheat_albedo_opacity.dds",
	metalGlossAoTexture = "terrain/grass/wheat_metal_gloss_ao.dds",
	normalTexture = "terrain/grass/wheat_normal.dds",
	translucencyTexture = "terrain/grass/wheat_translucency.dds",
	materials = {"shared/wheat.lua"},

	width = 1.8,
	height = 1.8,
	density = 4.0, -- stems per square meter (range allowed 0 to 16)
	lodDistance = 500.0
}
end
