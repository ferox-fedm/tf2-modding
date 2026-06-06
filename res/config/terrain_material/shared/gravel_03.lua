function data()
return {
	name = _("Gravel 03"),
	
	detailColorTexture = "terrain/gravel_03_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/gravel_03_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/gravel_03_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 36,
	overlaySize = 0.05,
	overlayStrength = 0.2,

	categories = {"gravel"},
	order = -19,
	priority = 1000000
}
end
