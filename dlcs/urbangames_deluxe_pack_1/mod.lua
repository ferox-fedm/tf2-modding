function data()
return {
	info = {
		minorVersion = 0,
		severityAdd = "NONE",
		severityRemove = "NONE",
		name = _("DLC_DELUXE_PACK_NAME"),
		description = _("DLC_DELUXE_PACK_DESCRIPTION"),
		tags = { },
		authors = {
			{
				name = "Urban Games",
				role = 'CREATOR',
			},
		},
		cosmetic = true,
		autoActivate = true,
	},
	runFn = function (settings)
		if settings.climate == "temperate" then
            addFileFilter("model/animal", function (fileName, data)
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_01.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_02.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_03.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_04.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cougar.mdl" then return false end
                return true   
            end)
        elseif settings.climate == "dry" then
            addFileFilter("model/animal", function (fileName, data)
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_01.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_02.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_03.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cr_fish_04.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/wolf.mdl" then return false end    
                return true
            end)
        elseif settings.climate == "tropical" then
            addFileFilter("model/animal", function (fileName, data)
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/wolf.mdl" then return false end
                if fileName == "dlcs/urbangames_deluxe_pack_1/res/models/model/animal/cougar.mdl" then return false end  
                return true
            end)
        end
	end
}
end
