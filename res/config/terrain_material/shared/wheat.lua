function data()
return {
	name = _("Wheat"),
	
	detailColorTexture = "terrain/wheat_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/wheat_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/wheat_nrml.dds",
	overlayTexture = "terrain/overlay_19.dds",

	detailSize = 1 / 64,
	overlaySize = .1,
	overlayStrength = 1.0,

	categories = {"plant"},
	order = -5,
	priority = 1000000
}
end
