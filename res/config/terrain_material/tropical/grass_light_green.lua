function data()
return {
	name = _("Grass light green"),
	
	detailColorTexture = "terrain/grass_light_green_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/grass_light_green_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/grass_light_green_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 32,
	overlaySize = 0.03,
	overlayStrength = 0.25,

	categories = {"grass"},
	order = -10000
}
end
