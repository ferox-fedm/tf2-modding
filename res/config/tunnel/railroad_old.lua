function data()
return {
	name = _("Standard tunnel"),
	carriers = { "RAIL" },
	portals = {
		{ "railroad/tunnel_rail_single.mdl" },
		{ "railroad/tunnel_rail_double.mdl" },
		{ "railroad/tunnel_rail_repeat_left.mdl", "railroad/tunnel_rail_repeat_mid.mdl", "railroad/tunnel_rail_repeat_right.mdl" },
	},
	--minTracks = 1,
	--maxTracks = 4,
	cost = 600.0
}
end
