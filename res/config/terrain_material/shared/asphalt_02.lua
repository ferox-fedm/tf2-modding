function data()
return {
	name = _("Asphalt 02"),
	
	detailColorTexture = "terrain/asphalt_02_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/asphalt_02_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/asphalt_02_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 15,
	overlaySize = 0.05,
	overlayStrength = 0.5,

	categories = {"asphalt"},
	order = -14,
	priority = 1000000
}
end
