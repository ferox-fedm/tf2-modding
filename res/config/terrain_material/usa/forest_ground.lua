function data()
return {
	name = _("Forest Ground"),
	
	detailColorTexture = "terrain/usa/forrest_ground_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/usa/forrest_ground_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/usa/forrest_ground_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 32,
	overlaySize = 0.06,
	overlayStrength = 0.2,

	categories = {"ground"},
	order = -1020,
	priority = -1
}
end
