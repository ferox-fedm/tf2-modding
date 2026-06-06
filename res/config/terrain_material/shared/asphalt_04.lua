function data()
return {
	name = _("Asphalt 04"),
	
	detailColorTexture = "terrain/asphalt_04_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/asphalt_04_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/asphalt_04_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 25,
	overlaySize = 0.02,
	overlayStrength = 0.3,

	categories = {"asphalt"},
	order = -12,
	priority = 1000000
}
end
