local assetutil = {}

local function matVersion(base, num)
	local res = {}
	res[1] = base .. ".mdl"
	for i=2, num do
		res[i] = base .. "_" .. (i) .. ".mdl"
	end
	return res
end

assetutil.assets = {
	--era_a tf2 asset groups
	----------------------------------------------------------------------------
	-- era_a FOOD STORE
	["era_a_com_1_asset_food_sign_01"] = {
		"asset/commercial/era_a/com_1_asset_food_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_sign_01_b.mdl",
	},
	["era_a_com_1_asset_food_wall_sign_01"] = {
		"asset/commercial/era_a/com_1_asset_food_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_wall_sign_01_b.mdl",
	},
	["era_a_com_1_asset_food_ad_01"] = {
		"asset/commercial/era_a/com_1_asset_food_ad_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_ad_01_b.mdl",
	},
	["era_a_com_2_asset_food_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_food_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_food_sign_01_b.mdl",
	},
	["era_a_com_2_asset_food_wall_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_food_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_food_wall_sign_01_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a FOOD BOOTH
	["era_a_com_1_asset_food_booth_01"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_01_b.mdl",
	},
	["era_a_com_1_asset_food_booth_02"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_02_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_02_b.mdl",
	},
	["era_a_com_1_asset_food_booth_03"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_03_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_03_b.mdl",
	},
	["era_a_com_1_asset_food_booth_04"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_04_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_04_b.mdl",
	},
	["era_a_com_1_asset_food_booth_05"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_05_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_05_b.mdl",
	},
	["era_a_com_1_asset_food_booth_start"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_start_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_start_b.mdl",
	},
	["era_a_com_1_asset_food_booth_end"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_end_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_end_b.mdl",
	},
	["era_a_com_1_asset_food_empty_box"] = {
		"asset/commercial/era_a/com_1_asset_food_empty_box_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_empty_box_b.mdl",
	},
	["era_a_com_1_asset_food_box"] = {
		"asset/commercial/era_a/com_1_asset_food_box_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_box_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a FOOD BOOTH MARKET
	["era_a_com_1_asset_food_booth_m_01"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_m_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_m_01_b.mdl",
	},
	["era_a_com_1_asset_food_booth_m_02"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_m_02_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_m_02_b.mdl",
	},
	["era_a_com_1_asset_food_booth_m_03"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_m_03_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_m_03_b.mdl",
	},
	["era_a_com_1_asset_food_booth_m_04"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_m_04_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_m_04_b.mdl",
	},
	["era_a_com_1_asset_food_booth_m_05"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_m_05_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_m_05_b.mdl",
	},
	["era_a_com_1_asset_food_booth_m_start"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_m_start_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_m_start_b.mdl",
	},
	["era_a_com_1_asset_food_booth_m_end"] = {
		"asset/commercial/era_a/com_1_asset_food_booth_m_end_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_booth_m_end_b.mdl",
	},
	["era_a_com_1_asset_food_empty_box"] = {
		"asset/commercial/era_a/com_1_asset_food_empty_box_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_empty_box_b.mdl",
	},
	["era_a_com_1_asset_food_box"] = {
		"asset/commercial/era_a/com_1_asset_food_box_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_box_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a MARKET 01
	["era_a_market_01"] = {
		"asset/commercial/era_a/market_01.mdl",
		"asset/commercial/era_a/market_02.mdl",
		"asset/commercial/era_a/market_05.mdl",
	},
	-- era_a MARKET 02
	["era_a_market_02"] = {
		"asset/commercial/era_a/market_03.mdl",
		"asset/commercial/era_a/market_04.mdl",
	},
	-- era_a MARKET ROOF (mainly for horseware)
	["era_a_market_roof"] = {
		"asset/commercial/era_a/market_roof_01.mdl",
		"",
	},
	----------------------------------------------------------------------------
	-- era_a GENERAL STORE
	["era_a_com_2_asset_gstore_wall_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_gstore_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_gstore_wall_sign_01_b.mdl",
	},
	["era_a_com_2_asset_gstore_wall_sign_02"] = {
		"asset/commercial/era_a/com_2_asset_gstore_wall_sign_02_a.mdl",
		"asset/commercial/era_a/com_2_asset_gstore_wall_sign_02_b.mdl",
	},
	["era_a_com_1_asset_gstore_sign_01"] = {
		"asset/commercial/era_a/com_1_asset_gstore_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_gstore_sign_01_b.mdl",
	},
	["era_a_barn_open"] = {
		"asset/commercial/era_a/era_a_com_barn_open.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a HORSE HARDWARE
	["era_a_com_1_asset_horse_wall_sign_01"] = {
		"asset/commercial/era_a/com_1_asset_horse_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_horse_wall_sign_01_b.mdl",
	},
	["era_a_com_2_asset_horse_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_horse_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_horse_sign_01_b.mdl",
	},
	["era_a_com_2_asset_horse_wall_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_horse_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_horse_wall_sign_01_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a WAGGON
	["era_a_waggon_01"] = {
		"asset/commercial/era_a/waggon_01.mdl",
		"asset/commercial/era_a/waggon_02.mdl",
		"asset/commercial/era_a/waggon_03.mdl",
		"",
	},
	----------------------------------------------------------------------------
	-- era_a RESTAURANT 01
	["era_a_com_1_asset_restaurant_sign_01"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_sign_01_b.mdl",
	},
	["era_a_com_1_asset_restaurant_wall_sign_01"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_wall_sign_01_b.mdl",
	},
	["era_a_com_1_asset_restaurant_menu_01"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_menu_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_menu_01_b.mdl",
	},
	["era_a_com_2_asset_restaurant_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_restaurant_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_restaurant_sign_01_b.mdl",
	},
	["era_a_com_2_asset_restaurant_wall_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_restaurant_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_restaurant_wall_sign_01_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a RESTAURANT 02
	["era_a_com_1_asset_restaurant_sign_02"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_sign_02_a.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_sign_02_b.mdl",
	},
	["era_a_com_1_asset_restaurant_wall_sign_02"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_wall_sign_02_a.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_wall_sign_02_b.mdl",
	},
	["era_a_com_2_asset_restaurant_sign_02"] = {
		"asset/commercial/era_a/com_2_asset_restaurant_sign_02_a.mdl",
		"asset/commercial/era_a/com_2_asset_restaurant_sign_02_b.mdl",
	},
	["era_a_com_2_asset_restaurant_wall_sign_02"] = {
		"asset/commercial/era_a/com_2_asset_restaurant_wall_sign_02_a.mdl",
		"asset/commercial/era_a/com_2_asset_restaurant_wall_sign_02_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a HOTEL_01
	["era_a_com_1_asset_hotel_sign_01"] = {
		"asset/commercial/era_a/com_1_asset_hotel_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_hotel_sign_01_b.mdl",
	},
	["era_a_com_2_asset_hotel_roof_sign_3d_01"] = {
		"asset/commercial/era_a/com_2_asset_hotel_roof_sign_3d_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_roof_sign_3d_01_b.mdl",
	},
	["era_a_com_2_asset_hotel_wall_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_hotel_wall_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_wall_sign_01_b.mdl",
	},
	["era_a_com_2_asset_hotel_roof_sign_01"] = {
		"asset/commercial/era_a/com_2_asset_hotel_roof_sign_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_roof_sign_01_b.mdl",
	},
	["era_a_com_2_asset_hotel_porch_01_repeat"] = {
		"asset/commercial/era_a/com_2_asset_hotel_porch_01_repeat_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_porch_01_repeat_b.mdl",
	},
	["era_a_com_2_asset_hotel_porch_01_end"] = {
		"asset/commercial/era_a/com_2_asset_hotel_porch_01_end_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_porch_01_end_b.mdl",
	},
	["era_a_com_2_asset_hotel_porch_01_start"] = {
		"asset/commercial/era_a/com_2_asset_hotel_porch_01_start_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_porch_01_start_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a FURNITURES
	["era_a_com_1_asset_ground_chair"] = {
		"asset/commercial/era_a/com_1_ground_chair_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_chair_01_b.mdl",
		"asset/commercial/era_a/com_1_ground_chair_02_a.mdl",
		"asset/commercial/era_a/com_1_ground_chair_02_b.mdl",
		"asset/commercial/era_a/stool_01.mdl",
	},
	["era_a_com_1_asset_ground_sunshade"] = {
		"asset/commercial/era_a/com_1_ground_sunshade_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_sunshade_01_b.mdl",
		"asset/commercial/era_a/com_1_ground_sunshade_02_a.mdl",
		"asset/commercial/era_a/com_1_ground_sunshade_02_b.mdl",
		"",
		"",
	},
	["era_a_com_1_asset_ground_double_bench"] = {
		"asset/commercial/era_a/com_1_ground_double_bench_a.mdl",
		"asset/commercial/era_a/com_1_ground_double_bench_b.mdl",
		"asset/commercial/era_a/com_1_ground_double_bench_a.mdl",
		"asset/commercial/era_a/com_1_ground_double_bench_b.mdl",
		"asset/commercial/era_a/bench_01.mdl",
	},
	["era_a_com_1_asset_ground_table"] = {
		"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_b.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_b.mdl",
		"asset/commercial/era_a/table_01.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a AWNING RESTAURANT
	["era_a_com_1_asset_restaurant_awning_end"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_awning_01_a_end.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_01_b_end.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_02_a_end.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_02_b_end.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_03_a_end.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_03_b_end.mdl",
	},
	["era_a_com_1_asset_restaurant_awning_repeat"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_awning_01_a_repeat.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_01_b_repeat.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_02_a_repeat.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_02_b_repeat.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_03_a_repeat.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_03_b_repeat.mdl",
	},
	["era_a_com_1_asset_restaurant_awning_start"] = {
		"asset/commercial/era_a/com_1_asset_restaurant_awning_01_a_start.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_01_b_start.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_02_a_start.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_02_b_start.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_03_a_start.mdl",
		"asset/commercial/era_a/com_1_asset_restaurant_awning_03_b_start.mdl",
	},
	
	----------------------------------------------------------------------------
	-- era_a AWNING SHOP
	["era_a_com_2_asset_shop_awning_end"] = {
		"",
		"",
		"asset/commercial/era_a/com_2_asset_shop_awning_02_a_end.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_02_b_end.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_03_a_end.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_03_b_end.mdl",
	},
	["era_a_com_2_asset_shop_awning_repeat"] = {
		"asset/commercial/era_a/com_2_asset_shop_awning_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_01_b.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_02_a_repeat.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_02_b_repeat.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_03_a_repeat.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_03_b_repeat.mdl",
	},
	["era_a_com_2_asset_shop_awning_start"] = {
		"",
		"",
		"asset/commercial/era_a/com_2_asset_shop_awning_02_a_start.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_02_b_start.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_03_a_start.mdl",
		"asset/commercial/era_a/com_2_asset_shop_awning_03_b_start.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a ADVERTISEMENT
	["era_a_com_1_asset_ad_sign"] = {
		"asset/commercial/era_a/com_1_asset_ad_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_ad_sign_01_b.mdl",
		"asset/commercial/era_a/com_1_asset_ad_sign_02_a.mdl",
		"asset/commercial/era_a/com_1_asset_ad_sign_02_b.mdl",
	},
	["era_a_com_1_asset_ad_sign_same_size"] = {
		"asset/commercial/era_a/com_1_asset_ad_sign_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_ad_sign_01_b.mdl",
	},
	["era_a_com_1_asset_ad_sign_big"] = {
		"asset/commercial/era_a/com_1_asset_ad_sign_big_01_a.mdl",
		"asset/commercial/era_a/com_1_asset_ad_sign_big_01_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a AWNING HOTEL
	-- open close switch a and b color variation
	["era_a_com_2_asset_hotel_win_awning_a"] = {
		"asset/commercial/era_a/com_2_asset_hotel_win_awning_op_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_win_awning_cl_01_a.mdl",
	},
	["era_a_com_2_asset_hotel_win_awning_b"] = {
		"asset/commercial/era_a/com_2_asset_hotel_win_awning_op_01_b.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_win_awning_cl_01_b.mdl",
	},
	-- door awning a and b color variation
	["era_a_com_2_asset_hotel_door_awning_a"] = {
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_02_a.mdl",
	},
	["era_a_com_2_asset_hotel_door_awning_b"] = {
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_01_b.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_02_b.mdl",
	},
	-- door awning color variation (for level 1 --> no rounded awnings)
	["era_a_com_2_asset_hotel_door_awning_level_1"] = {
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_01_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_01_b.mdl",
	},
	-- rounded awnings
	["era_a_com_2_asset_hotel_door_awning_round"] = {
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_02_a.mdl",
		"asset/commercial/era_a/com_2_asset_hotel_door_awning_02_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_a BOXES and CONTAINERS
	["era_a_wooden_box"] = {
		"asset/industry/wooden_box_01.mdl",
		"asset/industry/wooden_box_02.mdl",
		"",
	},
	["era_a_wooden_box_on"] = {
		"asset/industry/wooden_box_01.mdl",
		"asset/industry/wooden_box_02.mdl",
	},
	["era_a_container"] = {
		"asset/ground/container_wood.mdl",
		"asset/ground/container_waste3_open.mdl",
		"asset/ground/container_waste3.mdl",
		"",
		"",
	},
	["era_a_barrel_wood"] = {
		"asset/ground/barrel_wood.mdl",
		"asset/ground/barrel_wood.mdl",
		"",
		"",
	},
	["era_a_com_1_asset_food_box_m"] = {
		"asset/commercial/era_a/com_1_asset_food_empty_box_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_empty_box_b.mdl",
		"asset/commercial/era_a/com_1_asset_food_box_a.mdl",
		"asset/commercial/era_a/com_1_asset_food_box_b.mdl",
		"",
		"",
		"",
	},
	----------------------------------------------------------------------------
	-- era_a GARDEN ASSETS
	["era_a_garden_chair"] = {
		"asset/ground/garden_chair_metal_01.mdl",
		"asset/ground/garden_chair_wood_01.mdl",
	},
	["garden_table_round"] = {
		"asset/ground/garden_table_round_metal_01.mdl",
		"asset/ground/garden_table_round_wood_01.mdl",
	},
	["era_a_garden_bench"] = {
		"asset/ground/garden_bench_stone_01.mdl",
		"asset/ground/garden_bench_wood_01.mdl",
		"asset/commercial/era_a/com_1_ground_double_bench_a.mdl",
		"asset/commercial/era_a/com_1_ground_double_bench_b.mdl",
		"asset/commercial/era_a/bench_01.mdl",
		"",
	},
	["era_a_garden_ladder"] = {
		"station/air/asset/ladder_low_a.mdl",
		"",
	},
	["era_a_garden_sunshade"] = {
	"asset/ground/era_a/garden_sunshade_01_a.mdl",
	"asset/ground/era_a/garden_sunshade_02_a.mdl",
	"asset/ground/era_a/garden_sunshade_01_b.mdl",
	"asset/ground/era_a/garden_sunshade_02_b.mdl",
	"",
	"",
	"",
	"",
	},
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ERA B
	--------------------------------------------------------------------------------------------------------------------------------------------------------
	-- era_b GARDEN ASSETS
	["era_b_garden_swing"] = {
		"asset/ground/garden_swing_01.mdl",
		"asset/ground/garden_swing_02.mdl",
		"asset/ground/garden_swing_03.mdl",
		"asset/ground/garden_swing_04.mdl",
		"asset/ground/garden_swing_05.mdl",
	},
	["era_b_sunshade_large"] = {
	"asset/ground/era_b/garden_sunshade_large_01_a.mdl",
	"asset/ground/era_b/garden_sunshade_large_02_a.mdl",
	"asset/ground/era_b/garden_sunshade_large_01_closed_a.mdl",
	"asset/ground/era_b/garden_sunshade_large_02_closed_a.mdl",
	"asset/ground/era_b/garden_sunshade_large_01_b.mdl",
	"asset/ground/era_b/garden_sunshade_large_02_b.mdl",
	"asset/ground/era_b/garden_sunshade_large_01_closed_b.mdl",
	"asset/ground/era_b/garden_sunshade_large_02_closed_b.mdl",
	},
	["era_b_sunshade_small"] = {
	"asset/ground/era_b/garden_sunshade_small_01_a.mdl",
	"asset/ground/era_b/garden_sunshade_small_02_a.mdl",
	"asset/ground/era_b/garden_sunshade_small_01_b.mdl",
	"asset/ground/era_b/garden_sunshade_small_02_b.mdl",
	},
	["era_b_garden_table"] = {
	"asset/ground/garden_table_wood_01.mdl",
	"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
	"asset/ground/garden_table_metal_01.mdl",
	},
	["era_b_garden_chair"] = {
	"asset/ground/garden_chair_wood_01.mdl",
	"asset/ground/garden_chair_plastic_01.mdl",
	"asset/ground/garden_chair_metal_01.mdl",
	},
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- era_b GARBAGE
	["era_b_garbage_container"] = {
		"asset/ground/container_waste1.mdl",
		"asset/ground/container_waste2.mdl",
	},
	
	----------------------------------------------------------------------------
	-- era_b NEON FOOD
	["era_b_neon_wall_sign_food"] = {
		"asset/commercial/era_b/com_neon_sign_coffee.mdl",
		"asset/commercial/era_b/com_neon_sign_dinner.mdl",
		"asset/commercial/era_b/com_neon_sign_eat.mdl",
	},
	-- era_b NEON FOOD FLAT
	["era_b_neon_wall_sign_food_flat"] = {
		"asset/commercial/era_b/com_neon_sign_coffee_flat.mdl",
		"asset/commercial/era_b/com_neon_sign_dinner_flat.mdl",
		"asset/commercial/era_b/com_neon_sign_eat_flat.mdl",
	},
	-- era_b NEON ENTERTAINMENT
	["era_b_neon_wall_sign_fun"] = {
		"asset/commercial/era_b/com_neon_sign_dancing.mdl",
		"asset/commercial/era_b/com_neon_sign_roller.mdl",
		"asset/commercial/era_b/com_neon_sign_billiards.mdl",
	},
	-- era_b NEON ENTERTAINMENT FLAT
	["era_b_neon_wall_sign_fun_flat"] = {
		"asset/commercial/era_b/com_neon_sign_dancing_flat.mdl",
		"asset/commercial/era_b/com_neon_sign_roller_flat.mdl",
		"asset/commercial/era_b/com_neon_sign_billiards_flat.mdl",
	},
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- era_b SUNSHADES ALL
	["com_sunshades_all"] = {
		"asset/commercial/era_b/com_sunshade_large_01_a.mdl",
		"asset/commercial/era_b/com_sunshade_large_01_b.mdl",
		"asset/commercial/era_b/com_sunshade_large_02_a.mdl",
		"asset/commercial/era_b/com_sunshade_large_02_b.mdl",
		"asset/commercial/era_b/com_sunshade_small_01_a.mdl",
		"asset/commercial/era_b/com_sunshade_small_01_b.mdl",
		"asset/commercial/era_b/com_sunshade_small_02_a.mdl",
		"asset/commercial/era_b/com_sunshade_small_02_b.mdl",
	},
	["com_sunshades_modern"] = {
		"asset/commercial/era_b/com_sunshade_small_01_a.mdl",
		"asset/commercial/era_b/com_sunshade_small_01_b.mdl",
		"asset/commercial/era_b/com_sunshade_small_02_a.mdl",
		"asset/commercial/era_b/com_sunshade_small_02_b.mdl",
	},
	["com_sunshades_vintage"] = {
		"asset/commercial/era_b/com_sunshade_large_01_a.mdl",
		"asset/commercial/era_b/com_sunshade_large_01_b.mdl",
		"asset/commercial/era_b/com_sunshade_large_02_a.mdl",
		"asset/commercial/era_b/com_sunshade_large_02_b.mdl",
	},
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- era_b RESTAURANT
	["era_b_restaurant_sign_big"] = {
		"asset/commercial/era_b/com_1_asset_sign_rest_big_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_rest_big_b.mdl",
	},
	["era_b_restaurant_wall_sign_big"] = {
		"asset/commercial/era_b/com_2_3_asset_wall_sign_rest_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_rest_big_b.mdl",
	},
	["era_b_restaurant_ground_sign"] = {
		"asset/commercial/era_b/com_1_asset_ground_sign_rest_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_ground_sign_rest_small_b.mdl",
	},
	["era_b_restaurant_sign_small"] = {
		"asset/commercial/era_b/com_1_asset_sign_rest_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_rest_small_b.mdl",
	},
	["era_b_restaurant_wall_sign_small"] = {
		"asset/commercial/era_b/com_1_asset_wall_sign_rest_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_rest_small_b.mdl",
	},
	["era_b_restaurant_table"] = {
		"asset/commercial/era_b/com_1_asset_ground_table_01_a.mdl",
		"asset/commercial/era_b/com_1_asset_ground_table_01_b.mdl",
	},
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- era_b RESTAURANT FURNITURES
	["era_b_com_restaurant_tables"] = {
		"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_b.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_b.mdl",
		"asset/ground/garden_table_wood_01.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
		"asset/ground/garden_table_metal_01.mdl",
	},
	["era_b_com_restaurant_bench_tables"] = {
		"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_b.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_a.mdl",
		"asset/commercial/era_a/com_1_ground_table_01_b.mdl",
		"asset/ground/garden_table_wood_01.mdl",
	},
	["era_a_com_restaurant_chairs"] = {
		"asset/commercial/era_a/com_1_ground_chair_01_a.mdl",
		"asset/ground/garden_chair_plastic_01.mdl",
		"asset/ground/garden_chair_plastic_01.mdl",
		"asset/commercial/era_a/com_1_ground_chair_02_b.mdl",
		"asset/ground/garden_chair_wood_01.mdl",
		"asset/ground/garden_chair_plastic_01.mdl",
		"asset/ground/garden_chair_plastic_01.mdl",
	},
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- era_b FOOD STORE
	["era_b_food_store_sign_big"] = {
		"asset/commercial/era_b/com_2_3_asset_sign_food_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_sign_food_big_b.mdl",
	},
	["era_b_food_store_sign_small"] = {
		"asset/commercial/era_b/com_1_asset_sign_food_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_food_small_b.mdl",
	},
	["era_b_food_store_ground_sign"] = {
		"asset/commercial/era_b/com_1_asset_ground_sign_food_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_ground_sign_food_small_b.mdl",
	},
	["era_b_food_store_sign_mini"] = {
		"asset/commercial/era_b/com_1_asset_sign_food_mini_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_food_mini_b.mdl",
	},
	["era_b_food_store_wall_sign"] = {
		"asset/commercial/era_b/com_1_asset_wall_sign_food_01_a.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_food_01_b.mdl",
	},
	-- era_b FOOD BOXES
	["era_b_food_store_box_01"] = {
		"asset/commercial/era_b/com_1_asset_food_box_01_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_box_01_b.mdl",
	},
	["era_b_food_store_box_02"] = {
		"asset/commercial/era_b/com_1_asset_food_box_02_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_box_02_b.mdl",
	},
	["era_b_food_store_box_03"] = {
		"asset/commercial/era_b/com_1_asset_food_box_03_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_box_03_b.mdl",
	},
	["era_b_food_store_box_04"] = {
		"asset/commercial/era_b/com_1_asset_food_box_04_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_box_04_b.mdl",
	},
	["era_b_food_store_box_05"] = {
		"asset/commercial/era_b/com_1_asset_food_box_05_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_box_05_b.mdl",
	},
	["era_b_food_store_box_06"] = {
		"asset/commercial/era_b/com_1_asset_food_box_06_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_box_06_b.mdl",
	},
	-- era_b FOOD BOOTH
	["era_b_food_booth_01"] = {
		"asset/commercial/era_b/com_1_asset_food_booth_01_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_booth_01_b.mdl",
	},
	["era_b_food_booth_02"] = {
		"asset/commercial/era_b/com_1_asset_food_booth_02_a.mdl",
		"asset/commercial/era_b/com_1_asset_food_booth_02_b.mdl",
	},
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	-- era_b GENERAL_STORE
	["era_b_general_store_sign_big"] = {
		"asset/commercial/era_b/com_1_asset_sign_general_big_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_general_big_b.mdl",
		"asset/commercial/era_b/com_2_3_asset_sign_general_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_sign_general_big_b.mdl",
	},
	["era_b_general_store_sign_small"] = {
		"asset/commercial/era_b/com_1_asset_sign_general_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_general_small_b.mdl",
		"asset/commercial/era_b/com_1_asset_sign_general_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_general_small_b.mdl",
	},
	["era_b_general_store_wall_sign_small"] = {
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_b.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_b.mdl",
	},
	["era_b_general_store_wall_sign_big"] = {
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_b.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_b AWNING_SHOPS
	["era_b_awning_shops_start"] = {
		"asset/commercial/era_b/com_1_asset_awning_shops_01_start_a.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_01_start_b.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_02_start_a.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_02_start_b.mdl",
	},
	["era_b_awning_shops_repeat"] = {
		"asset/commercial/era_b/com_1_asset_awning_shops_01_repeat_a.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_01_repeat_b.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_02_repeat_a.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_02_repeat_b.mdl",
	},
	["era_b_awning_shops_end"] = {
		"asset/commercial/era_b/com_1_asset_awning_shops_01_end_a.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_01_end_b.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_02_end_a.mdl",
		"asset/commercial/era_b/com_1_asset_awning_shops_02_end_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_b ADVERTISEMENT
	["era_b_advertisement"] = {
		"asset/commercial/era_b/com_2_3_asset_sign_ad_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_sign_ad_big_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_b HOTEL
	["era_b_hotel_sign_big"] = {
		"asset/commercial/era_b/com_2_3_asset_sign_hotel_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_sign_hotel_big_b.mdl",
	},
	["era_b_hotel_sign_small"] = {
		"asset/commercial/era_b/com_2_3_asset_sign_hotel_small_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_sign_hotel_small_b.mdl",
	},
	["era_b_hotel_sign_mini"] = {
		"asset/commercial/era_b/com_1_asset_sign_hotel_mini_a.mdl",
		"asset/commercial/era_b/com_1_asset_sign_hotel_mini_b.mdl",
	},
	["era_b_hotel_wall_sign_01"] = {
		"asset/commercial/era_b/com_2_3_asset_wall_sign_hotel_01_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_hotel_01_b.mdl",
	},
	["era_b_hotel_wall_sign_02"] = {
		"asset/commercial/era_b/com_2_3_asset_wall_sign_hotel_02_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_hotel_02_a.mdl",
	},
	["era_b_general_store_wall_sign_small"] = {
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_b.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_a.mdl",
		"asset/commercial/era_b/com_1_asset_wall_sign_general_small_b.mdl",
	},
	["era_b_general_store_wall_sign_big"] = {
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_b.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_wall_sign_general_big_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_b AWNING_HOTEL
	["era_b_awning_hotel_start"] = {
		"asset/commercial/era_b/com_2_3_asset_awning_hotel_01_start_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_awning_hotel_01_start_b.mdl",
	},
	["era_b_awning_hotel_repeat"] = {
		"asset/commercial/era_b/com_2_3_asset_awning_hotel_01_repeat_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_awning_hotel_01_repeat_b.mdl",
	},
	["era_b_awning_hotel_end"] = {
		"asset/commercial/era_b/com_2_3_asset_awning_hotel_01_end_a.mdl",
		"asset/commercial/era_b/com_2_3_asset_awning_hotel_01_end_b.mdl",
	},
	----------------------------------------------------------------------------
	-- era_b MARKET_STALL
	["era_b_market_stall"] = {
		"asset/commercial/era_b/market_stall_01_a.mdl",
		"asset/commercial/era_b/market_stall_02_a.mdl",
		"asset/commercial/era_b/market_stall_03_a.mdl",
		"asset/commercial/era_b/market_stall_01_b.mdl",
		"asset/commercial/era_b/market_stall_02_b.mdl",
		"asset/commercial/era_b/market_stall_03_b.mdl",
	},
	----------------------------------------------------------------------------
	["bench"] = {
		"asset/bench_old.mdl"
	},
	["com_2_to_4_asset_roof_sign_01"] = {
		"asset/commercial/era_c/com_2_to_4_roof_sign_01.mdl",
		"asset/commercial/era_c/com_2_to_4_roof_sign_01_02.mdl",
	},
	["com_2_to_4_asset_wall_sign_02"] = {
		"asset/commercial/era_c/com_2_to_4_wall_sign_02.mdl",
		"asset/commercial/era_c/com_2_to_4_wall_sign_02_02.mdl",
	},
	["com_2_to_4_asset_wall_store_sign_01"] = {
		"asset/commercial/era_c/com_2_to_4_wall_store_sign_01.mdl", 
		"asset/commercial/era_c/com_2_to_4_wall_store_sign_01_02.mdl", 
	},
	["silo_double_vertical_10m_02_w_catwalk"] = {
		matVersion("asset/ground/silo_double_vertical_10m_02_w_catwalk", 6),
	},
	["era_a_ind_random_loose_wood"] = {
		"asset/industry/loose_wood_01.mdl",
		"asset/industry/loose_wood_02.mdl",
		"asset/industry/loose_wood_03.mdl",
		"asset/industry/loose_wood_04.mdl",
		"",		
	},
	["era_a_ind_random_wooden_shed"] = {
		"asset/industry/wooden_shed_01.mdl",
		"asset/industry/wooden_shed_02.mdl",
		"asset/industry/wooden_shed_01.mdl",
		"asset/industry/wooden_shed_02.mdl",
		"",		
	},
	["era_a_ind_random_vertical_tank"] = {
		"asset/industry/vertical_tank_01.mdl",
		"asset/industry/vertical_tank_02.mdl",
		"asset/industry/vertical_tank_03.mdl",
	},
	["era_a_ind_random_tank"] = {
		"asset/industry/tank_01.mdl",
		"asset/industry/tank_02.mdl",
	},
	["era_a_ind_random_decoration"] = {
		"asset/industry/wooden_box_01.mdl",
		"asset/industry/wooden_box_02.mdl",
		"asset/industry/wooden_box_03.mdl",	
		"asset/industry/steal_pipes_01.mdl",	
		"asset/ground/barrel_steel.mdl",	
		"asset/ground/barrel_wood.mdl",	
		"asset/ground/container_small_steel.mdl",	
		"asset/ground/container_wood.mdl",		
		"asset/ground/wheelbarrow.mdl",		
		"asset/ground/cableroll.mdl",		
		"",		
		"",		
	},
	["era_b_ind_random_decoration"] = {
		"asset/industry/wooden_box_02.mdl",
		"asset/industry/wooden_box_04.mdl",	
		"asset/industry/steal_pipes_01.mdl",	
		"asset/ground/barrel_steel.mdl",	
		"asset/ground/container_small_steel.mdl",	
		"asset/ground/container_fluid.mdl",				
		"asset/ground/cableroll.mdl",				
		"asset/ground/pallet_01.mdl",		
		"asset/ground/wood_plates_01.mdl",		
		"asset/ground/wood_plates_02.mdl",	
		"",		
		"",		
	},
	["era_c_ind_random_decoration"] = {
		"asset/industry/wooden_box_02.mdl",
		"asset/industry/wooden_box_04.mdl",	
		"asset/industry/steal_pipes_01.mdl",	
		"asset/ground/barrel_steel.mdl",	
		"asset/ground/container_small_steel.mdl",	
		"asset/ground/container_fluid.mdl",	
		"asset/ground/container_waste2.mdl",		
		"asset/ground/container_waste3.mdl",		
		"asset/ground/container_waste3_open.mdl",		
		"asset/ground/pallet_01.mdl",		
		"asset/ground/wood_plates_01.mdl",		
		"asset/ground/wood_plates_02.mdl",		
		"",		
		"",		
		"",		
		"",		
	},
	
	["era_a_res_random_decoration"] = {
		"asset/ground/barrel_wood.mdl",	
		"asset/ground/container_wood.mdl",		
		"asset/ground/wooden_box_03.mdl",			
		"",		
		"",		
		"",		
		"",		
	},	
	["era_b_res_random_decoration"] = {
		"asset/ground/cardboard_box_01.mdl",	
		"asset/ground/container_waste1.mdl",		
		"asset/ground/container_waste2.mdl",		
		"asset/ground/container_waste3.mdl",		
		"asset/ground/container_waste3_open.mdl",		
		"asset/ground/wooden_box_02.mdl",			
		"",		
		"",		
		"",		
		"",		
	},
	["era_c_res_random_decoration"] = {
		"asset/ground/cardboard_box_01.mdl",	
		"asset/ground/container_waste1.mdl",		
		"asset/ground/container_waste2.mdl",		
		"asset/ground/container_waste3.mdl",		
		"asset/ground/container_waste3_open.mdl",		
		"asset/ground/wooden_box_02.mdl",			
		"",		
		"",		
		"",		
		"",		
	},
	["random_roof_decoration_small"] = {
		"asset/roof/ventilation_cube1.mdl",
		"asset/roof/ventilation_cube2.mdl",
		"asset/roof/ventilation_end_curved.mdl",
		"asset/roof/ventilation_sphere1.mdl",
		"",
	},
	["random_roof_decoration_large"] = {
		"asset/roof/generator1.mdl",
		"asset/roof/ventfan1.mdl",
		"asset/roof/ventfan2.mdl",
		"",
	},
	["solar_panel_on_off"] = {
		"asset/roof/solar_panel1.mdl",
		"",
	},
	["era_c_pavillion_on_off"] = {
		"asset/ground/garden_sun_pavillion_01.mdl",
		"",
	},
	["era_a_com_random_decoration"] = {
		"asset/industry/wooden_box_01.mdl",
		"asset/industry/wooden_box_02.mdl",
		"asset/industry/wooden_box_03.mdl",		
		"asset/ground/barrel_wood.mdl",		
		"asset/ground/container_wood.mdl",		
		"industry/cargo/livestock_small.mdl",		
		"industry/cargo/grain_small.mdl",		
		"industry/cargo/food_small.mdl",	
		"",		
		"",		
		"",		
	},
	["era_b_com_random_decoration"] = {	
		"asset/ground/barrel_steel.mdl",		
		"asset/ground/container_waste1.mdl",		
		"asset/ground/container_waste3.mdl",		
		"asset/ground/container_waste3_open.mdl",		
		"asset/ground/cardboard_box_02.mdl",		
		"industry/cargo/livestock_small.mdl",		
		"industry/cargo/grain_small.mdl",		
		"industry/cargo/food_small.mdl",	
		"",		
		"",		
		"",		
	},
	["era_b_com_1_ground_box"] = {
		"building/era_b/com_1_asset_ground_box_01.mdl",
		"building/era_b/com_1_asset_ground_box_02.mdl",
	},
	["era_b_com_1_ground_food_booth"] = {
		"building/era_b/com_1_asset_ground_food_booth_01.mdl",
		"building/era_b/com_1_asset_ground_food_booth_02.mdl",
	},
	["era_b_com_1_ground_sign"] = {
		"building/era_b/com_1_asset_ground_sign_01.mdl",
		"building/era_b/com_1_asset_ground_sign_02.mdl",
	},
	["era_b_com_1_wall_sign_big"] = {
		"building/era_b/com_1_asset_wall_sign_04.mdl",
		"building/era_b/com_1_asset_wall_sign_05.mdl",
	},
	["era_b_com_1_wall_sign_small"] = {
		"building/era_b/com_1_asset_wall_sign_02.mdl",
		"building/era_b/com_1_asset_wall_sign_03.mdl",
	},
	["era_b_com_1_wall_store_sign_big"] = {
		"building/era_b/com_1_asset_wall_store_sign_01.mdl",
		"building/era_b/com_1_asset_wall_store_sign_02.mdl",
		"building/era_b/com_1_asset_wall_store_sign_03.mdl",
	},	
	["era_b_com_1_wall_store_sign_small"] = {	
		"building/era_b/com_1_asset_wall_store_sign_04.mdl",
		"building/era_b/com_1_asset_wall_store_sign_05.mdl",
	},
	["era_b_com_2_to_3_wall_sign_big"] = {	
		"building/era_b/com_2_to_3_asset_wall_sign_02.mdl",
		"building/era_b/com_2_to_3_asset_wall_sign_04.mdl",
	},
	["era_b_com_2_to_3_wall_sign_small"] = {	
		"building/era_b/com_2_to_3_asset_wall_sign_01.mdl",
		"building/era_b/com_2_to_3_asset_wall_sign_03.mdl",
	},
	["era_b_com_2_to_3_wall_store_sign"] = {
		"building/era_b/com_2_to_3_asset_wall_store_sign_01.mdl",
		"building/era_b/com_2_to_3_asset_wall_store_sign_02.mdl",
		"building/era_b/com_2_to_3_asset_wall_store_sign_04.mdl",
		"building/era_b/com_2_to_3_asset_wall_store_sign_05.mdl",
	},
	["era_b_com_2_to_3_wall_store_sign_small"] = {
		"building/era_b/com_2_to_3_asset_wall_store_sign_06.mdl",
		"building/era_b/com_2_to_3_asset_wall_store_sign_07.mdl",
	},
	["era_c_com_random_decoration"] = {	
		"asset/ground/barrel_steel.mdl",		
		"asset/ground/container_waste1.mdl",		
		"asset/ground/container_waste3.mdl",		
		"asset/ground/container_waste3_open.mdl",		
		"asset/ground/cardboard_box_02.mdl",		
		"",		
		"",		
		"",		
	},
	["era_a_com_1_box"] = {
		"building/era_a/com_1_asset_ground_box.mdl",
		"building/era_a/com_1_asset_ground_empty_box.mdl",
	},
	["era_a_com_1_food_booth"] = {
		"building/era_a/com_1_asset_ground_food_booth_01.mdl",
		"building/era_a/com_1_asset_ground_food_booth_02.mdl",
		"building/era_a/com_1_asset_ground_food_booth_03.mdl",
		"building/era_a/com_1_asset_ground_food_booth_04.mdl",
		"building/era_a/com_1_asset_ground_food_booth_05.mdl",
	},
	["era_a_com_1_wall_sign"] = {
		"building/era_a/com_1_asset_wall_sign_01.mdl",
		"building/era_a/com_1_asset_wall_sign_02.mdl",
		"building/era_a/com_1_asset_wall_sign_06.mdl",
		"building/era_a/com_1_asset_wall_sign_07.mdl",
	},	
	["era_a_com_1_wall_sign_big"] = {		
		"building/era_a/com_1_asset_wall_sign_03.mdl",
		"building/era_a/com_1_asset_wall_sign_04.mdl",
		"building/era_a/com_1_asset_wall_sign_05.mdl",		
	},
	["era_a_com_1_ground_sign"] = {		
		"building/era_a/com_1_asset_ground_sign_01.mdl",
		"building/era_a/com_1_asset_ground_sign_02.mdl",				
	},
	["era_a_com_1_wall_store_sign"] = {
		"building/era_a/com_1_asset_wall_store_sign_01.mdl",
		"building/era_a/com_1_asset_wall_store_sign_02.mdl",
		"building/era_a/com_1_asset_wall_store_sign_03.mdl",
		"building/era_a/com_1_asset_wall_store_sign_04.mdl",		
	},
	["era_a_com_2_wall_sign"] = {
		"building/era_a/com_2_asset_wall_sign_01.mdl",	
		"building/era_a/com_2_asset_wall_sign_02.mdl",	
		"building/era_a/com_2_asset_wall_sign_03.mdl",	
	},
	["era_a_com_2_roof_sign"] = {
		"building/era_a/com_2_asset_roof_sign_01.mdl",	
		"building/era_a/com_2_asset_roof_sign_02.mdl",	
		"building/era_a/com_2_asset_roof_sign_03.mdl",	
	},
	["era_a_com_2_wall_store_sign"] = {
		"building/era_a/com_2_asset_wall_store_sign_01.mdl",
		"building/era_a/com_2_asset_wall_store_sign_04.mdl",		
		"building/era_a/com_2_asset_wall_store_sign_05.mdl",		
		"building/era_a/com_2_asset_wall_store_sign_06.mdl",		
		"building/era_a/com_2_asset_wall_store_sign_07.mdl",		
	},
	["era_a_com_2_wall_store_sign_big"] = {
		"building/era_a/com_2_asset_wall_store_sign_02.mdl",
		"building/era_a/com_2_asset_wall_store_sign_03.mdl",		
	},	
	["era_a_com_2_wall_awning_04"] = {
		"building/era_a/com_2_asset_wall_awning_04_open.mdl",
		"building/era_a/com_2_asset_wall_awning_04_open.mdl",
		"building/era_a/com_2_asset_wall_awning_04_open.mdl",
		"building/era_a/com_2_asset_wall_awning_04_open.mdl",
		"building/era_a/com_2_asset_wall_awning_04_closed.mdl",	
	},	
	["era_c_com_2_to_4_wall_sign_small"] = { 
		"asset/commercial/era_c/com_2_to_4_wall_sign_05.mdl", 
		"asset/commercial/era_c/com_2_to_4_wall_sign_05_02.mdl",
	},
	["era_c_com_2_to_4_wall_sign_small_2"] = {
		"asset/commercial/era_c/com_2_to_4_wall_sign_01_02.mdl",
		"asset/commercial/era_c/com_2_to_4_wall_sign_01.mdl",
	},
	["era_c_com_random_trash_container"] = {
		"asset/ground/container_waste3_open.mdl",
		"asset/ground/container_waste3.mdl",
		"asset/ground/container_waste2.mdl",
		"asset/ground/container_waste1.mdl",
	},
	["com_2_to_4_asset_wall_sign_03"] = {
		"asset/commercial/era_c/com_2_to_4_wall_sign_03.mdl",
		"asset/commercial/era_c/com_2_to_4_wall_sign_03_02.mdl",
	},		
	["era_c_com_2_to_4_wall_sign_large"] = {
		"asset/commercial/era_c/com_2_to_4_wall_sign_03.mdl",
		"asset/commercial/era_c/com_2_to_4_wall_sign_03_02.mdl",
		"asset/commercial/era_c/com_2_to_4_wall_sign_04.mdl",
		"asset/commercial/era_c/com_2_to_4_wall_sign_04_02.mdl",
	},	
	["era_c_com_2_to_4_wall_store_sign"] = {
		"asset/commercial/era_c/com_2_to_4_wall_store_sign_02.mdl", 
		"asset/commercial/era_c/com_2_to_4_wall_store_sign_02_02.mdl", 
		"asset/commercial/era_c/com_2_to_4_wall_store_sign_03.mdl", 
		"asset/commercial/era_c/com_2_to_4_wall_store_sign_03_02.mdl", 
	},
	["era_c_emissive_signs_wall"] = {
		"asset/commercial/era_c/com_sign_wok.mdl", 
		"asset/commercial/era_c/com_sign_rad_lobster.mdl", 
		"asset/commercial/era_c/com_sign_pin_king.mdl", 
		"asset/commercial/era_c/com_sign_music.mdl",
		"asset/commercial/era_c/com_sign_lift_gym.mdl", 		
	},
	["era_c_emissive_signs_pillar"] = {
		"asset/commercial/era_c/com_sign_wok_on_pillar.mdl", 
		"asset/commercial/era_c/com_sign_wieners_on_pillar.mdl",
		"asset/commercial/era_c/com_sign_pin_king_on_pillar.mdl", 
		"asset/commercial/era_c/com_sign_lift_gym_on_pillar.mdl", 		
	},	
	["era_c_com_random_trash_container"] = {
		"asset/ground/container_waste2.mdl", 
		"asset/ground/container_waste1.mdl", 
		"asset/ground/container_waste3.mdl", 	
	},	
	["silo_horizontal"] = {	
		"asset/industry/silo_horizontal_03.mdl", 
		"asset/industry/silo_horizontal_03_blue.mdl", 
		"asset/industry/silo_horizontal_03_green.mdl", 
		"asset/industry/silo_horizontal_03_orange.mdl", 
		"asset/industry/silo_horizontal_03_red.mdl", 
	},	
	["silo_vertical"] = {
		"asset/industry/silo_vertical_10m_02.mdl", 
		"asset/industry/silo_vertical_10m_04.mdl", 
		"asset/industry/silo_vertical_11m_01.mdl", 
		"asset/industry/silo_vertical_14m_02.mdl", 
		"asset/industry/silo_vertical_14m_03.mdl", 
		"asset/industry/silo_vertical_14m_04.mdl", 
		"asset/industry/silo_vertical_stilted_9m_03.mdl", 
	},	
	["silo_special"] = {
		"asset/industry/silo_spherical_01.mdl", 
		"asset/industry/silo_spherical_01_blue.mdl", 
		"asset/industry/silo_spherical_01_green.mdl", 
		"asset/industry/silo_spherical_01_orange.mdl", 
		"asset/industry/silo_spherical_01_red.mdl", 
		"asset/industry/silo_vertical_3m_01.mdl", 
		"asset/industry/silo_vertical_3m_01_blue.mdl", 
		"asset/industry/silo_vertical_3m_01_green.mdl", 
		"asset/industry/silo_vertical_3m_01_orange.mdl", 
		"asset/industry/silo_vertical_3m_01_red.mdl", 
	},	
	["garden_sunshade_large_01"] = {
		"asset/ground/garden_sunshade_large_01.mdl",
		"asset/ground/garden_sunshade_large_01.mdl",
		"asset/ground/garden_sunshade_large_closed_01.mdl",
		"",
	},	
	["garden_sunshade_large_02"] = {
		"asset/ground/garden_sunshade_large_02.mdl",
		"asset/ground/garden_sunshade_large_02.mdl",
		"asset/ground/garden_sunshade_large_closed_02.mdl",
		"",
	},	
	["garden_sunshade_small"] = {
		"asset/ground/garden_sunshade_small_01.mdl",
		"asset/ground/garden_sunshade_small_02.mdl",	
		"asset/ground/garden_sunshade_small_01.mdl",
		"asset/ground/garden_sunshade_small_02.mdl",		
		"",
	},	
	["random_restaurant"] = {
		"asset/commercial/era_c/com_sign_rad_lobster.mdl",
		"asset/commercial/era_c/com_sign_wieners.mdl",	
		"asset/commercial/era_c/com_sign_wok.mdl",
		"",
	},	
	["mailbox_old"] = {
		"street/street_asset_mix/mailbox_eu_a.mdl",
		--[[
		"street/street_asset_mix/mailbox_us_a.mdl",
		]]--
		"",
	},	
	["mailbox_new"] = {
		"street/street_asset_mix/mailbox_eu_c.mdl",
		--[[
		"street/street_asset_mix/mailbox_us_c.mdl",
		]]--
		"",
	},	
	["random_medium_tree"] = {
		"tree/european_linden.mdl",
		"tree/shingle_oak.mdl",
		"",
		
	},	
	["random_large_tree"] = {
		"tree/sugar_maple.mdl",	
		"",		
		
	},	
	["random_small_tree"] = {
		"tree/azalea.mdl",
		"tree/common_hazel.mdl",
		"tree/elderberry.mdl",
		"tree/red_delicious_apple.mdl",	
		"",
	},	
	["random_shrub"] = {
		"tree/azalea.mdl",
		"tree/common_hazel.mdl",
		"tree/elderberry.mdl",
	},	
	["random_shrub_europe"] = {
		"tree/azalea.mdl",
		"tree/common_hazel.mdl",
		"tree/elderberry.mdl",
	},	
	["random_shrub_usa"] = {
		"tree/usa/sagebrush.mdl",
		"tree/usa/broom_snakeweed.mdl",
		"tree/usa/ocotillo.mdl",
	},
}

return assetutil