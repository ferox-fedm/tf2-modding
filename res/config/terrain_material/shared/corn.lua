function data()
return {
	name = _("Corn"),
	
	detailColorTexture = "terrain/corn_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/corn_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/corn_nrml.dds",
	overlayTexture = "terrain/overlay_14.dds",

	detailSize = 1 / 64,
	overlaySize = .05,
	overlayStrength = 1.0,

	categories = {"plant"},
	order = -5,
	priority = 1000000
}
end
