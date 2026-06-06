function data()
return {
	name = _("Soil 01"),
	
	detailColorTexture = "terrain/soil_01_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/soil_01_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/soil_01_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 25,
	overlaySize = 0.12,
	overlayStrength = 0.3,

	categories = {"ground"},
	order = -5,
	priority = 1000000
}
end
