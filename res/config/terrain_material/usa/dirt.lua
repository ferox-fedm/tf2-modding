function data()
return {
	name = _("Dirt"),
	
	detailColorTexture = "terrain/usa/dirt_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/usa/dirt_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/usa/dirt_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 32,
	overlaySize = 0.05,
	overlayStrength = 0.2,

	categories = {"ground"},
	order = -1096,
	priority = 110000
}
end
