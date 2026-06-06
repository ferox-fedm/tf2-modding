function data()
return {
	name = _("Asphalt 03"),
	
	detailColorTexture = "terrain/asphalt_03_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/asphalt_03_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/asphalt_03_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 35,
	overlaySize = 0.12,
	overlayStrength = 0.5,

	categories = {"asphalt"},
	order = -13,
	priority = 1000000
}
end
