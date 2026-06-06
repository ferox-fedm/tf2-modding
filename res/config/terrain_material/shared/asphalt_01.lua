function data()
return {
	name = _("Asphalt 01"),
	
	detailColorTexture = "terrain/asphalt_01_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/asphalt_01_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/asphalt_01_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 32,
	overlaySize = 0.08,
	overlayStrength = 0.35,

	categories = {"asphalt"},
	order = -15,
	priority = 1000000
}
end
