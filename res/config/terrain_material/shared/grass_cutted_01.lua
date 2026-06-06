function data()
return {
	name = _("Grass Cutted 01"),
	
	detailColorTexture = "terrain/grass_cutted_01_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/grass_cutted_01_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/grass_cutted_01_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 32,
	overlaySize = 0.03,
	overlayStrength = 0.25,
	hOffset = 0.3,

	categories = {"grass"},
	order = -40,
	priority = 1
}
end
