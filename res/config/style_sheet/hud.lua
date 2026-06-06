require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5
local defaultMargin = hp

local receivingColor = ssu.makeColor(110, 120, 125) -- ssu.makeColor(75, 75, 75, 150)
local sendingColor = ssu.makeColor(70, 90, 120) -- ssu.makeColor(100, 100, 100, 150)

function data()
	local result = { }
	
	local a = ssu.makeAdder(result)
	
	a("TownItem", {
		backgroundImage1 = { fileName = "ui/hud/town_background.tga", horizontal = { 0, 3, 47, 50 }, vertical = { 0, 4, 46, 50 } },
		backgroundColor1 = ssu.makeColor(255, 255, 255),
		padding = { 2, 5, 2, 5 },
	})

	a("TownItem!hover", {
		backgroundColor1 = ssu.makeColor(200, 200, 200),
	})
	
	a("TownItem, IndustryItem", {
		scaling = 3 / 2
	})
	
	a("TownBuildingItem", {
		scaling = 3 / 4
	})
	
	a("TownItem BoxLayout", {
		innerSpacing = { 5, 5 }
	})
	
	a("TownItem::CargoItem", {
		scaling = 2 / 3
	})

	a("TownBuildingItem BoxLayout", {
		innerSpacing = { 0, 0 }
	})

	a([[StationItem!hover IndustryItem::RightArrow, 
			StationItem!hover IndustryItem::ReceivingArrow, 
			StationItem!hover IndustryItem::ReceivingCargo, 
			StationItem!hover IndustryItem::OnlyReceivingCargo, 
			StationItem!hover IndustryItem::SendingCargo, 
			StationItem!hover IndustryItem::OnlySendingCargo, 
			StationItem!hover IndustryItem::SendingArrow]], {
		color = ssu.makeColor(200, 200, 200),
		backgroundColor1 = ssu.makeColor(200, 200, 200),
	})

	a("IndustryItem BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("IndustryItem::ReceivingArrow", {
		color = receivingColor
	})
	
	a("IndustryItem::ReceivingCargo BoxLayout, IndustryItem::SendingCargo BoxLayout", {
		innerSpacing = { 5, 5 },
	})

	a("IndustryItem::ReceivingCargo", {
		padding = { 0, 5, 0, 10 },
		backgroundImage1 = { fileName = "ui/design/hud/background_cargo_items_side.tga", horizontal = { 0, 7, 7, 7 }, vertical = { 0, 12, 13, 25 } },
		backgroundColor1 = receivingColor
	})

	a("IndustryItem::OnlyReceivingCargo", {
		padding = { 0, 10, 0, 5 },
		backgroundImage1 = { fileName = "ui/design/hud/background_cargo_items_side.tga", horizontal = { 8, 8, 8, 14 }, vertical = { 0, 12, 13, 25 } },
		backgroundColor1 = receivingColor
	})
	
	a("IndustryItem::RightArrow", {
		color = sendingColor,
		backgroundImage1 = { fileName = "ui/design/hud/background_cargo_items_mittle_left.tga" },
		backgroundColor1 = receivingColor,
	})
	
	a("IndustryItem::SendingCargo", {
		padding = { 0, 10, 0, 5 },
		backgroundImage1 = { fileName = "ui/design/hud/background_cargo_items_side.tga", horizontal = { 8, 8, 8, 14 }, vertical = { 0, 12, 13, 25 } },
		backgroundColor1 = sendingColor
	})
	
	a("IndustryItem::OnlySendingCargo", {
		padding = { 0, 5, 0, 10 },
		backgroundImage1 = { fileName = "ui/design/hud/background_cargo_items_side.tga", horizontal = { 0, 7, 7, 7 }, vertical = { 0, 12, 13, 25 } },
		backgroundColor1 = sendingColor
	})
	
	a("IndustryItem::SendingArrow", {
		color = sendingColor
	})
	
	a("StationItem::CargoItems BoxLayout", {
		innerSpacing = { 0, 0 }
	})
	
	a("StationItem::CargoItems", {
		gravity = { .5, .5 }
	})
	
	a("StationItem::CargoItem", {
		scaling = 2 / 3
	})
	
	a("StationItem::LargeCargoItem", {
		scaling = 4 / 3,
	})
	
	a("StationItem::HugeCargoItem", {
		scaling = 8 / 3,
	})
	
	a("StationItem::CargoCount", {
		--fontSize = 12,
		padding = { 0, 5, 0, 5 },
		gravity = { 1.0, 1.0 },
		backgroundImage1 = { fileName = "ui/design/buttons/disk_arrow.tga", horizontal = { 0, 10, 11, 20 }, vertical = { 0, 10, 11, 20 } },
		backgroundColor1 = ssu.makeColor(40, 50, 60)
	})
	
	a("StationItem::CargoItemsAtStation, StationItem::StationIcons", {
		gravity = { .5, .5 }
	})
	
	a("StationItem ProgressBar", {
		gravity = { -1.0, 1.0 },
		size = { -1, 4 },
		padding = { 1, 1, 1, 1},
		backgroundColor = ssu.makeColor(255, 255, 255, 100)
	})

	a("VehicleDepotItem::Icon", {
		size = { 52, 68 },
		backgroundColor1 = ssu.makeColor(255, 255, 255, 255),
	})

	a("VehicleDepotItem::Icon!road", {
		backgroundImage1 = { fileName = "ui/hud/depot_road.tga" },
	})

	a("VehicleDepotItem::Icon!rail", {
		backgroundImage1 = { fileName = "ui/hud/depot_train.tga" },
	})

	a("VehicleDepotItem::Icon!tram", {
		backgroundImage1 = { fileName = "ui/hud/depot_tram.tga" },
	})

	a("VehicleDepotItem::Icon!air", {
		backgroundImage1 = { fileName = "ui/hud/depot_air.tga" },
	})

	a("VehicleDepotItem::Icon!water", {
		backgroundImage1 = { fileName = "ui/hud/depot_water.tga" },
	})

	a("VehicleDepotItem::Icon!hover", {
		backgroundColor1 = ssu.makeColor(200, 200, 200, 255),
		backgroundImage1 = { fileName = "ui/hud/depot_hover.tga" },
	})

	a("StationItem::StationIcon", {
		size = { 52, 68 },
		backgroundColor1 = ssu.makeColor(255, 255, 255, 255),
		backgroundImage1 = { fileName = "ui/hud/station_none.tga" },
	})

	a("StationItem::StationIcon!train", {
		backgroundImage1 = { fileName = "ui/hud/station_train.tga" },
	})

	a("StationItem::StationIcon!train-cargo", {
		backgroundImage1 = { fileName = "ui/hud/station_train_cargo.tga" },
	})

	a("StationItem::StationIcon!bus-and-tram", {
		size = { 32, 47 },
		backgroundImage1 = { fileName = "ui/hud/station_tram_and_bus.tga" },
	})
	
	a("StationItem::StationIcon!bus", {
		size = { 32, 47 },
		backgroundImage1 = { fileName = "ui/hud/station_bus.tga" },
	})

	a("StationItem::StationIcon!truck", {
		size = { 32, 47 },
		backgroundImage1 = { fileName = "ui/hud/station_truck.tga" },
	})

	a("StationItem::StationIcon!tram", {
		size = { 32, 47 },
		backgroundImage1 = { fileName = "ui/hud/station_tram.tga" },
	})
	
	a("StationItem::StationIcon!aircraft", {
		backgroundImage1 = { fileName = "ui/hud/station_aircraft.tga" },
	})

	a("StationItem::StationIcon!aircraft-cargo", {
		backgroundImage1 = { fileName = "ui/hud/station_aircraft_cargo.tga" },
	})

	a("StationItem::StationIcon!ship", {
		backgroundImage1 = { fileName = "ui/hud/station_ship.tga" },
	})

	a("StationItem::StationIcon!ship-cargo", {
		backgroundImage1 = { fileName = "ui/hud/station_ship_cargo.tga" },
	})

	a("StationItem::StationIcon!hover", {
		backgroundColor1 = ssu.makeColor(200, 200, 200, 255),
	})

	a("StationItem::StationIcon!train!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_train_hover.tga" },
	})

	a("StationItem::StationIcon!train-cargo!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_train_cargo_hover.tga" },
	})

	a("StationItem::StationIcon!bus-and-tram!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_tram_and_bus_hover.tga" },
	})
	
	a("StationItem::StationIcon!bus!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_bus_hover.tga" },
	})

	a("StationItem::StationIcon!truck!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_truck_hover.tga" },
	})

	a("StationItem::StationIcon!tram!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_tram_hover.tga" },
	})
	
	a("StationItem::StationIcon!aircraft!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_aircraft_hover.tga" },
	})

	a("StationItem::StationIcon!aircraft-cargo!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_aircraft_cargo_hover.tga" },
	})

	a("StationItem::StationIcon!ship!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_ship_hover.tga" },
	})

	a("StationItem::StationIcon!ship-cargo!hover", {
		backgroundImage1 = { fileName = "ui/hud/station_ship_cargo_hover.tga" },
	})

	return result
end
