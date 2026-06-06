function data()
return {
	name = _("Gravel 04"),
	
	detailColorTexture = "terrain/gravel_04_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/gravel_04_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/gravel_04_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 30,
	overlaySize = 0.1,
	overlayStrength = 0.3,

	categories = {"gravel"},
	order = -18,
	priority = 1000000
}
end
