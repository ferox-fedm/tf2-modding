function data()
return {
	colorTexture = "terrain/grass/corn_albedo_opacity.dds",
	metalGlossAoTexture = "terrain/grass/corn_metal_gloss_ao.dds",
	normalTexture = "terrain/grass/corn_normal.dds",
	translucencyTexture = "terrain/grass/corn_translucency.dds",
	materials = {"shared/corn.lua"},

	width = 2.5,
	height = 2.5,
	density = 2.0, -- stems per square meter (range allowed 0 to 16)
	lodDistance = 500.0
}
end
