function data()
return {
	name = _("Rock"),
	
	detailColorTexture = "terrain/rock_albedo.dds",
	detailMetalGlossAoHTexture = "terrain/rock_metal_gloss_ao_h.dds",
	detailNormalTexture = "terrain/rock_nrml.dds",
	overlayTexture = "terrain/overlay_0.dds",

	detailSize = 1 / 45 ,
	overlaySize = 0.002,
	overlayStrength = 0.3,

	categories = {"rock"},
	order = -1079,
	priority = 10000
}
end
