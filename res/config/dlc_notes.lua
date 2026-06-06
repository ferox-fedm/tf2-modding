function data()
	return {
		title = _("DLC_TITLE"),  -- window title
		infoItemsPerPage = 2, -- how many text-image items per page are shown
		infoItems = {		
			{
				title = _("DLC_TITLE_1"),
				description = _("DLC_DESCRIPTION_1"), 
				image = "ui/deluxe_dialog_box/deluxe_thankyou.tga",
				leftImage = true,
			},
			{
				title = _("DLC_TITLE_2"),
				description = _("DLC_DESCRIPTION_2"), 
				image = "ui/deluxe_dialog_box/deluxe_content.tga",
				leftImage = true,
			},
			{
				title = _("DLC_TITLE_3"),
				description = _("DLC_DESCRIPTION_3"), 
				image = "ui/deluxe_dialog_box/deluxe_howto_pc.tga",
				leftImage = true,
				filterOutVendor = {"ps", "xbox"},  -- show only for pc edition
			},					
			{
				title = _("DLC_TITLE_4"),
				description = _("DLC_DESCRIPTION_4"), 
				image = "ui/deluxe_dialog_box/deluxe_legacy.tga",
				leftImage = true,
				filterOutVendor = {"ps", "xbox"}, -- show only for pc edition
			},
			{
				title = _("DLC_TITLE_5"),
				description = _("DLC_DESCRIPTION_5"), 
				image = "ui/deluxe_dialog_box/deluxe_howto_xbox.tga",
				leftImage = true,
				filterOutVendor = {"steam", "gog", "eos", "mac", "ps"}, -- show only for xbox
			},		
			{
				title = _("DLC_TITLE_5"),
				description = _("DLC_DESCRIPTION_5"), 
				image = "ui/deluxe_dialog_box/deluxe_howto_ps.tga",
				leftImage = true,
				filterOutVendor = {"steam", "gog", "eos", "mac", "xbox"}, -- show only for ps
			},				
		}
	}
end
