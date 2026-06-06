function data()
return {
	name = _("Gravel 02"),
	
	detailColorTexture = "terrain/gravel_02_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/gravel_02_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/gravel_02_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 16,
	overlaySize = 0.4,
	overlayStrength = 0.4,

	categories = {"gravel"},
	order = -20,
	priority = 1000000
}
end
