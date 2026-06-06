local buildingutil = { }

function buildingutil.make_residential_0_default()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "RESIDENTIAL",	
	rule = "DEFAULT",
	capacity = { 1, 4 },
	parcelWidth = { 2, 2 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = .0,
	groundTexEntrance = "building_path",
	groundTexEntranceCount = 1,	
	params = {
		assetFence = { "asset/fence_wood.mdl" },
		assetGarden = { "asset/barrel_water_wood.mdl" },
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_02.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" , "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .25,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = {	},
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },			
		matFlat = { },
		matCap = {	},
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 3.0, 6.0 },
		dimWidth = { 8.0, 13.0, 8.0, 13.0 },
		dimDepth = { 8.0, 13.0, 8.0, 13.0 },
		dimPosition = { .25, .75, .2, .4 },
		shapeSizeL = { 12.0, 13.0 }
	},
}
end


function buildingutil.make_residential_1_default()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "RESIDENTIAL",
	rule = "DEFAULT",
	capacity = { 5, 10 },
	parcelWidth = { 3, 3 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = .0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { "asset/fence_wood.mdl" },
		assetGarden = { "asset/barrel_water_wood.mdl" },
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_02.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" , "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},	
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .25,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },			
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },		
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 9.0, 15.0 },
		dimWidth = { 11.0, 16.0, 11.0, 16.0 },
		dimDepth = { 11.0, 16.0, 11.0, 16.0 },
		dimPosition = { .25, .75, .2, .4 },
		shapeSizeL = { 12.0, 16.0 }
	},
}
end


function buildingutil.make_residential_2_block()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "RESIDENTIAL",
	rule = "DEFAULT",
	capacity = { 11, 18 },
	parcelWidth = { 4, 4 },
	parcelDepth = {	3, 4 },
	groundTexLot = { "town_concrete", "building_paving" },
	groundTexBuilding = { "", "" },
	groundTexBuildingOffset = 3.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { "asset/barrel_water_wood.mdl" },
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_03.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl" },			
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_03.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl",  "asset/water_tank_res_01.mdl" },			
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .25,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },		
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 18.0, 27.0 },
		dimWidth = { 14.0, 20.0, 14.0, 20.0 },
		dimDepth = { 11.0, 16.0, 14.0, 20.0 },
		dimPosition = { .25, .75, .4, .6 },
		shapeSizeL = { 12.0, 16.0 }
	},
}
end


function buildingutil.make_residential_3_skyscraper()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "RESIDENTIAL",
	rule = "DEFAULT",
	capacity = { 19, 100 },
	parcelWidth = { 4, 6 },
	parcelDepth = {	4, 5 },
	groundTexLot = { "town_concrete", "building_paving" },
	groundTexBuilding = { "", "" },
	groundTexBuildingOffset = 6.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { "asset/barrel_water_wood.mdl" },
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_03.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl" ,   "asset/antenna_01.mdl" },			
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_03.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl" , "asset/water_tank_res_01.mdl",   "asset/antenna_01.mdl" },			
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .25,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },		
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 30.0, 150.0 },
		dimWidth = { 15.0, 20.0, 26.0, 34.0 },
		dimDepth = { 14.0, 18.0, 21.0, 29.0 },
		dimPosition = { .25, .75, .8, .9 },
		shapeSizeL = { 100.0, 101.0 }
	},
}
end


function buildingutil.make_commercial_0_default()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "COMMERCIAL",
	rule = "DEFAULT",
	capacity = { 1, 16 },
	parcelWidth = { 2, 2 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = 3.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { }, -- "asset/sun_curtain_res_01.mdl"
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_02.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" , "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },			
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 3.0, 6.0 },
		dimWidth = { 8.0, 13.0, 8.0, 13.0 },
		dimDepth = { 8.0, 13.0, 8.0, 13.0 },
		dimPosition = { .25, .75, .2, .4 },
		shapeSizeL = { 12.0, 13.0 }
	},
}
end


function buildingutil.make_commercial_1_default()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "COMMERCIAL",
	rule = "DEFAULT",
	capacity = { 17, 40 },
	parcelWidth = { 3, 3 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "town_concrete", "building_paving" },
	groundTexBuilding = { "", "" },
	groundTexBuildingOffset = 3.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { }, -- "asset/sun_curtain_res_01.mdl"
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_02.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" , "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl"},
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },			
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 9.0, 15.0 },
		dimWidth = { 11.0, 16.0, 11.0, 16.0 },
		dimDepth = { 11.0, 16.0, 11.0, 16.0 },
		dimPosition = { .25, .75, .2, .4 },
		shapeSizeL = { 12.0, 16.0 }
	},
}
end


function buildingutil.make_commercial_2_block()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "COMMERCIAL",
	rule = "DEFAULT",
	capacity = { 41, 72 },
	parcelWidth = { 4, 4 },
	parcelDepth = {	3, 4 },
	groundTexLot = { "town_concrete", "building_paving" },
	groundTexBuilding = { "", "" },
	groundTexBuildingOffset = 3.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = {  },	-- "asset/sun_curtain_res_01.mdl"
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_02.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl",   "asset/antenna_01.mdl"},
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" , "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl" , "asset/water_tank_res_01.mdl",   "asset/antenna_01.mdl" },
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 18.0, 27.0 },
		dimWidth = { 16.0, 22.0, 16.0, 22.0 },
		dimDepth = { 11.0, 16.0, 14.0, 19.0 },
		dimPosition = { .25, .75, .5, .7 },
		shapeSizeL = { 12.0, 16.0 }
	},
}
end


function buildingutil.make_commercial_3_skyscraper()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "COMMERCIAL",
	rule = "DEFAULT",
	capacity = { 73, 400 },
	parcelWidth = { 4, 6 },
	parcelDepth = {	4, 5 },
	groundTexLot = { "town_concrete", "building_paving" },
	groundTexBuilding = { "", "" },
	groundTexBuildingOffset = 6.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { }, -- "asset/sun_curtain_res_01.mdl"
		assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/chimney_res_03.mdl", "asset/chimney_res_04.mdl" , "asset/chimney_res_06.mdl",   "asset/antenna_01.mdl"  },
		assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" , "asset/water_tank_res_01.mdl" ,   "asset/antenna_01.mdl" },	
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .15,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .7,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 30.0, 150.0 },
		dimWidth = { 18.0, 24.0, 24.0, 30.0 },
		dimDepth = { 15.0, 21.0, 18.0, 24.0 },
		dimPosition = { .25, .75, .6, .8 },
		shapeSizeL = { 100.0, 101.0 }
	},
}
end


function buildingutil.make_industrial_0_default()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "INDUSTRIAL",
	rule = "DEFAULT",
	capacity = { 1, 8 },
	parcelWidth = { 3, 3 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = 3.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { "asset/industry/cardboard_box_01.mdl", "asset/industry/cardboard_box_02.mdl", "asset/industry/metal_beam_01.mdl", "asset/industry/pallet_01.mdl", "asset/industry/steal_pipes_01.mdl", "asset/industry/wood_plates_01.mdl", "asset/industry/wood_plates_02.mdl", "asset/industry/wooden_box_01.mdl", "asset/industry/wooden_box_02.mdl", "asset/industry/wooden_box_03.mdl", "asset/industry/wooden_box_04.mdl" },
		assetRoof = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetFlat = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .5,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .2,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = {	},
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },
		matFlat = { },
		matCap = {	},
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 3.0, 6.0 },
		dimWidth = { 12.0, 16.0, 14.0, 20.0 },
		dimDepth = { 9.0, 16.0, 11.0, 16.0 },
		dimPosition = { .25, .75, .6, .8 },
		shapeSizeL = { 10.5, 13.0 }
	},
}
end

function buildingutil.make_industrial_1_default()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "INDUSTRIAL",
	rule = "DEFAULT",
	capacity = { 9, 20 },
	parcelWidth = { 4, 4 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = 3.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { "asset/industry/cardboard_box_01.mdl", "asset/industry/cardboard_box_02.mdl", "asset/industry/metal_beam_01.mdl", "asset/industry/pallet_01.mdl", "asset/industry/steal_pipes_01.mdl", "asset/industry/wood_plates_01.mdl", "asset/industry/wood_plates_02.mdl", "asset/industry/wooden_box_01.mdl", "asset/industry/wooden_box_02.mdl", "asset/industry/wooden_box_03.mdl", "asset/industry/wooden_box_04.mdl" },
		assetRoof = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetFlat = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .5,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .2,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = {	},
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },			
		matFlat = { },
		matCap = {	},
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 6.0, 9.0 },
		dimWidth = { 15.0, 20.0, 15.0, 20.0 },
		dimDepth = { 11.0, 16.0, 11.0, 16.0 },
		dimPosition = { .25, .75, .6, .8 },
		shapeSizeL = { 12.0, 16.0 }
	},
}
end


function buildingutil.make_industrial_2_block()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "INDUSTRIAL",
	rule = "DEFAULT",
	capacity = { 21, 36 },
	parcelWidth = { 4, 5 },
	parcelDepth = {	4, 4 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = 5.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { "asset/industry/cardboard_box_01.mdl", "asset/industry/cardboard_box_02.mdl", "asset/industry/metal_beam_01.mdl", "asset/industry/pallet_01.mdl", "asset/industry/steal_pipes_01.mdl", "asset/industry/wood_plates_01.mdl", "asset/industry/wood_plates_02.mdl", "asset/industry/wooden_box_01.mdl", "asset/industry/wooden_box_02.mdl", "asset/industry/wooden_box_03.mdl", "asset/industry/wooden_box_04.mdl" },
		assetRoof = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetFlat = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .5,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .2,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 9.0, 12.0 },
		dimWidth = { 18.0, 23.0, 21.0, 26.0 },
		dimDepth = { 15.0, 16.0, 15.0, 16.0 },
		dimPosition = { .25, .75, .6, .8 },
		shapeSizeL = { 13.0, 17.0 }
	},
}
end


function buildingutil.make_industrial_3_block()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "INDUSTRIAL",
	rule = "DEFAULT",
	capacity = { 37, 200 },
	parcelWidth = { 5, 6 },
	parcelDepth = {	5, 5 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = 6.0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
	params = {
		assetFence = { },
		assetGarden = { "asset/industry/cardboard_box_01.mdl", "asset/industry/cardboard_box_02.mdl", "asset/industry/metal_beam_01.mdl", "asset/industry/pallet_01.mdl", "asset/industry/steal_pipes_01.mdl", "asset/industry/wood_plates_01.mdl", "asset/industry/wood_plates_02.mdl", "asset/industry/wooden_box_01.mdl", "asset/industry/wooden_box_02.mdl", "asset/industry/wooden_box_03.mdl", "asset/industry/wooden_box_04.mdl" },
		assetRoof = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetFlat = { "asset/chimney_ind_00.mdl", "asset/chimney_ind_01.mdl", "asset/chimney_ind_02.mdl", "asset/chimney_ind_03.mdl" },
		assetTree = { "all" },
		assetWildWestRoof = { },
		assetProbGarden = .5,
		assetProbRoof = .2,
		assetProbFlat = .2,
		assetProbTree = .2,
		matWall = { },
		matGround = { },
		matDoor = { },
		matGarage = { },
		matMain = { },
		matTop = { },
		matCorner = { },
		matRoof = { },
		matRoofSide = { "wall_wood1.btd" },
		matFlat = { },
		matCap = { },
		matCapSide = { "wall_wood1.btd" },
		matBox = { },
		matProbBox = .2,
		matSizeBox = 4.0,
		dimHeight = { 12.0, 15.0 },
		dimWidth = { 24.0, 29.0, 32.0, 37.0 },
		dimDepth = { 20.0, 25.0, 22.0, 27.0 },
		dimPosition = { .25, .75, .6, .8 },
		shapeSizeL = { 19.0, 27.0 }
	},
}
end


function buildingutil.make_leisure_0_default()
	result = make_leisure_0()
	result.rule = "DEFAULT"
	result.params = make_leisure_params_default_0()
	return result
end

function buildingutil.make_leisure_1_default()
	result = make_leisure_1()
	result.rule = "DEFAULT"
	result.params = make_leisure_params_default_1()
	return result
end

function buildingutil.make_leisure_2_default()
	result = make_leisure_2()
	result.rule = "DEFAULT"
	result.params = make_leisure_params_default_2()
	return result
end

function buildingutil.make_leisure_3_default()
	result = make_leisure_3()
	result.rule = "DEFAULT"
	result.params = make_leisure_params_default_3()
	return result
end


function buildingutil.make_leisure_0_asset()
	result = make_leisure_0()
	result.rule = "ASSET"
	result.params = make_leisure_params_asset()
	return result
end

function buildingutil.make_leisure_1_asset()
	result = make_leisure_1()
	result.rule = "ASSET"
	result.params = make_leisure_params_asset()
	return result
end

function buildingutil.make_leisure_2_asset()
	result = make_leisure_2()
	result.rule = "ASSET"
	result.params = make_leisure_params_asset()
	return result
end

function buildingutil.make_leisure_3_asset()
	result = make_leisure_3()
	result.rule = "ASSET"
	result.params = make_leisure_params_asset()
	return result
end


function make_leisure_0()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "LEISURE",
	capacity = { 1, 16 },
	parcelWidth = { 2, 2 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = .0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
}
end

function make_leisure_1()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "LEISURE",
	capacity = { 17, 40 },
	parcelWidth = { 3, 3 },
	parcelDepth = {	3, 3 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = .0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
}
end

function make_leisure_2()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "LEISURE",
	capacity = { 41, 72 },
	parcelWidth = { 4, 4 },
	parcelDepth = {	3, 4 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = .0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
}
end

function make_leisure_3()
return {
	availability = {
		yearFrom = 0,
		yearTo = 0
	},
	type = "LEISURE",
	capacity = { 73, 400 },
	parcelWidth = { 4, 6 },
	parcelDepth = {	4, 5 },
	groundTexLot = { "", "" },
	groundTexBuilding = { "building_paving_fill", "building_paving" },
	groundTexBuildingOffset = .0,
	groundTexEntrance = "",
	groundTexEntranceCount = 1,
}
end


function make_leisure_params_default_0()
return {
	assetFence = { "asset/fence_wood.mdl" },
	assetGarden = { "asset/barrel_water_blue.mdl" },
	assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" },
	assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" },
	assetTree = { "all" },
	assetWildWestRoof = { },
	assetProbGarden = .15,
	assetProbRoof = .25,
	assetProbFlat = .2,
	assetProbTree = .7,
	matWall = { },
	matGround = { },
	matDoor = { },
	matGarage = { },
	matMain = { },
	matTop = {	},
	matCorner = { },
	matRoof = { },
	matRoofSide = { "wall_wood1.btd" },			
	matFlat = { },
	matCap = {	},
	matCapSide = { "wall_wood1.btd" },
	matBox = { },
	matProbBox = .2,
	matSizeBox = 4.0,
	dimHeight = { 3.0, 6.0 },
	dimWidth = { 8.0, 13.0, 8.0, 13.0 },
	dimDepth = { 8.0, 13.0, 8.0, 13.0 },
	dimPosition = { .25, .75, .2, .4 },
	shapeSizeL = { 12.0, 13.0 }
}
end

function make_leisure_params_default_1()
return {
	assetFence = { "asset/fence_wood.mdl" },
	assetGarden = { "asset/barrel_water_blue.mdl" },
	assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" },			
	assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" },			
	assetTree = { "all" },
	assetWildWestRoof = { },
	assetProbGarden = .15,
	assetProbRoof = .25,
	assetProbFlat = .2,
	assetProbTree = .7,
	matWall = { },
	matGround = { },
	matDoor = { },
	matGarage = { },
	matMain = { },
	matTop = { },
	matCorner = { },
	matRoof = { },
	matRoofSide = { "wall_wood1.btd" },			
	matFlat = { },
	matCap = { },
	matCapSide = { "wall_wood1.btd" },
	matBox = { },		
	matProbBox = .2,
	matSizeBox = 4.0,
	dimHeight = { 9.0, 15.0 },
	dimWidth = { 11.0, 16.0, 11.0, 16.0 },
	dimDepth = { 11.0, 16.0, 11.0, 16.0 },
	dimPosition = { .25, .75, .2, .4 },
	shapeSizeL = { 12.0, 16.0 }
}
end

function make_leisure_params_default_2()
return {
	assetFence = { },
	assetGarden = { "asset/barrel_water_blue.mdl" },
	assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" },			
	assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/water_tank_res_01.mdl" },			
	assetTree = { "all" },
	assetWildWestRoof = { },
	assetProbGarden = .15,
	assetProbRoof = .25,
	assetProbFlat = .2,
	assetProbTree = .7,
	matWall = { },
	matGround = { },
	matDoor = { },
	matGarage = { },
	matMain = { },
	matTop = { },
	matCorner = { },
	matRoof = { },
	matRoofSide = { "wall_wood1.btd" },
	matFlat = { },
	matCap = { },
	matCapSide = { "wall_wood1.btd" },
	matBox = { },		
	matProbBox = .2,
	matSizeBox = 4.0,
	dimHeight = { 18.0, 27.0 },
	dimWidth = { 14.0, 20.0, 14.0, 20.0 },
	dimDepth = { 11.0, 16.0, 14.0, 20.0 },
	dimPosition = { .25, .75, .4, .6 },
	shapeSizeL = { 12.0, 16.0 }
}
end

function make_leisure_params_default_3()
return {
	assetFence = { },
	assetGarden = { "asset/barrel_water_blue.mdl" },
	assetRoof = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl" },			
	assetFlat = { "asset/chimney_res_00.mdl", "asset/chimney_res_01.mdl", "asset/water_tank_res_01.mdl" },			
	assetTree = { "all" },
	assetWildWestRoof = { },
	assetProbGarden = .15,
	assetProbRoof = .25,
	assetProbFlat = .2,
	assetProbTree = .7,
	matWall = { },
	matGround = { },
	matDoor = { },
	matGarage = { },
	matMain = { },
	matTop = { },
	matCorner = { },
	matRoof = { },
	matRoofSide = { "wall_wood1.btd" },
	matFlat = { },
	matCap = { },
	matCapSide = { "wall_wood1.btd" },
	matBox = { },		
	matProbBox = .2,
	matSizeBox = 4.0,
	dimHeight = { 30.0, 150.0 },
	dimWidth = { 15.0, 20.0, 23.0, 31.0 },
	dimDepth = { 14.0, 18.0, 20.0, 28.0 },
	dimPosition = { .25, .75, .8, .9 },
	shapeSizeL = { 100.0, 101.0 }
}
end

function make_leisure_params_asset()
return {	
	assetCenter = "",
	assetGarden = { },
	assetTree = { "all" },
	assetProbGarden = .0,
	assetProbTree = 1.0,
	matWall = { },
	shapeGridSize = 6.0
}
end


return buildingutil
