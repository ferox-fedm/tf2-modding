function data()
return {
	name = _("Forest ground"),
	
	detailColorTexture = "terrain/forest_ground_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/forest_ground_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/forest_ground_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 27,
	overlaySize = 0.03,
	overlayStrength = 0.4,

	categories = {"ground"},
	order = -1094,
	priority = 1
}
end
