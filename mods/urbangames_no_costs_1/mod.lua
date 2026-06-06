function data()
return {
	info = {
		minorVersion = 0,
		severityAdd = "NONE",
		severityRemove = "NONE",
		name = _("MOD_NO_COSTS_NAME"),
		description = _("MOD_NO_COSTS_DESCRIPTION"),
		tags = { "Script Mod" },
		authors = {
			{
				name = "Urban Games",
				role = 'CREATOR',
			},
		},
	},
	runFn = function (settings)
		game.config.noCosts = true
	end
}
end
