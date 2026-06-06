function data()
return {
	name = _("Ballast"),
	
	detailColorTexture = "terrain/ballast_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/ballast_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/ballast_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 32,
	overlaySize = 0.08,
	overlayStrength = 0.3,
	
	categories = {"gravel"},
	priority = 1000000
}
end
