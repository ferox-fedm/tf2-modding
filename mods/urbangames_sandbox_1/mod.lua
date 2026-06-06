function data()
return {
	info = {
		minorVersion = 0,
		severityAdd = "NONE",
		severityRemove = "NONE",
		name = _("MOD_SANDBOX_NAME"),
		description = _("MOD_SANDBOX_DESCRIPTION"),
		tags = { "Script Mod" },
		authors = {
			{
				name = "Urban Games",
				role = 'CREATOR',
			},
		},
	},
	runFn = function (settings)
		game.config.sandboxButton = true
	end
}
end
