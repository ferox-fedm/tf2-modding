function data()
return {
	name = _("Coal"),
	
	detailColorTexture = "terrain/coal_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/coal_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/coal_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 15,
	overlaySize = 0.05,
	overlayStrength = 0.5,

	categories = {"misc"},
	order = -12,
	priority = 1000000
}
end
