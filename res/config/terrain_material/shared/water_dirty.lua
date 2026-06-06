function data()
return {
	name = _("Water Dirty"),
	
	detailColorTexture = "terrain/water_dirty_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/water_dirty_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/water_dirty_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 32,
	overlaySize = 0.12,
	overlayStrength = 0.0,

	categories = {"misc"},
	order = -10,
	priority = 1000000
}
end
