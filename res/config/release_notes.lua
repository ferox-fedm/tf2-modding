function data()
	return {
		updateMessageID = 7, -- increment by 1 for each new update
		title = _("NEWS_TITLE"),  -- window title
		infoItemsPerPage = 2, -- how many text-image items per page are shown
		infoItems = {
			{
				title = _("NEWS_TITLE_1"),
				description = _("NEWS_DESCRIPTION_1"), 
				image = "ui/news_dialog_box/autumn_update_banner_map.tga",
				leftImage = false,
				filterOutVendor = {"gog", "eos", "mac", "xbox", "ps"},
			},
			{
				title = _("NEWS_TITLE_2"),
				description = _("NEWS_DESCRIPTION_2"), 
				image = "ui/news_dialog_box/autumn_update_banner_map.tga",
				leftImage = false,
				filterOutVendor = {"steam"},
				filterOutPlatform = {"PS4", "XboxOne"},
			},
			{
				title = _("NEWS_TITLE_5"), 
				description = _("NEWS_DESCRIPTION_5"), 
				image = "ui/news_dialog_box/autumn_update_traffic.tga",
				leftImage = true,
			},
			{
				title = _("NEWS_TITLE_3"),
				description = _("NEWS_DESCRIPTION_3"), 
				image = "ui/news_dialog_box/autumn_update_road_tools.tga",
				leftImage = true,
			},
			{
				title = _("NEWS_TITLE_4"), 
				description = _("NEWS_DESCRIPTION_4"),
				image = "ui/news_dialog_box/autumn_update_auto_snapping.tga",
				leftImage = false,
			},
			{
				title = _("NEWS_TITLE_7"), 
				description = _("NEWS_DESCRIPTION_7"),
				image = "ui/news_dialog_box/autumn_update_switch.tga",
				leftImage = false,
			},
			{
				title = _("NEWS_TITLE_6"), 
				description = _("NEWS_DESCRIPTION_6"),
				image = "ui/news_dialog_box/autumn_update_others.tga",
				leftImage = true,
			}
		}
	}
end
