function data()
return {
	info = {
		minorVersion = 0,
		severityAdd = "NONE",
		severityRemove = "NONE",
		name = _("MOD_VEHICLES_NO_END_YEAR_NAME"),
		description = _("MOD_VEHICLES_NO_END_YEAR_DESCRIPTION"),
		tags = { "Script Mod" },
		authors = {
			{
				name = "Urban Games",
				role = 'CREATOR',
			},
		},
	},
	runFn = function (settings)
		addModifier("loadModel", function (fileName, data)
				if data.metadata.transportVehicle and data.metadata.availability then
					data.metadata.availability.yearTo = 0
				end

				return data
			end)
	end
}
end
