if (SERVER) then AddCSLuaFile() return end

local PACSpawnlist = CreateClientConVar("pac_spawnlist", 1)

//oh dear

local function PACAppendToKV(kvtype, kvdata, kvtab)
	if kvtype == "header" then
	kvtab.ContentsNum = kvtab.ContentsNum+1
	kvtab.Contents = kvtab.Contents.."\n".."\""..kvtab.ContentsNum.."\"".." { ".."\"type\" ".."\""..kvtype.."\"   ".."\"text\" ".."\""..kvdata.."\"".." }"
	elseif kvtype == "model" then
		kvtab.ContentsNum = kvtab.ContentsNum+1
	kvtab.Contents = kvtab.Contents.."\n".."\""..kvtab.ContentsNum.."\"".." { ".."\"type\" ".."\""..kvtype.."\"   ".."\"model\" ".."\""..kvdata.."\"".." }"
	end
end

//Spawnlist Table Setup

local PACSpawnTables = {}
//Playset 2
PACSpawnTables["Main"] = {}
PACSpawnTables["Main"].UID = "413-Playset_2"
PACSpawnTables["Main"].Name = "PAC3"
PACSpawnTables["Main"].Contents = [["TableToKeyValues"{ "1"{ "type" "header"   "text" "PAC3 Spawnlist made by Flex" } ]] //this table intentionally left unclosed
PACSpawnTables["Main"].Icon = "icon16/user_edit.png"
PACSpawnTables["Main"].ID = 413
PACSpawnTables["Main"].ParentID = 0
//Characters
PACSpawnTables["Characters"] = {}
PACSpawnTables["Characters"].UID = "4131-PS2Characters"
PACSpawnTables["Characters"].Name = "Characters"
PACSpawnTables["Characters"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Characters"].ContentsNum = 0
PACSpawnTables["Characters"].Icon = "icon16/hs_captcha.png"
PACSpawnTables["Characters"].ID = 4131
PACSpawnTables["Characters"].ParentID = 413
//Clothing
PACSpawnTables["Clothing"] = {}
PACSpawnTables["Clothing"].UID = "4132-PS2Clothing"
PACSpawnTables["Clothing"].Name = "Clothing"
PACSpawnTables["Clothing"].Contents = [["TableToKeyValues"{ "1"{ "type" "header"   "text" "" } ]] //this table intentionally left unclosed
PACSpawnTables["Clothing"].ContentsNum = 0
PACSpawnTables["Clothing"].Icon = "icon16/hs_clothes.png"
PACSpawnTables["Clothing"].ID = 4132
PACSpawnTables["Clothing"].ParentID = 413
//Clothing - Head
PACSpawnTables["Head"] = {}
PACSpawnTables["Head"].UID = "41321-PS21Head"
PACSpawnTables["Head"].Name = "Head"
PACSpawnTables["Head"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Head"].ContentsNum = 0
PACSpawnTables["Head"].Icon = "icon16/color_wheel.png"
PACSpawnTables["Head"].ID = 41321
PACSpawnTables["Head"].ParentID = 4132
//Clothing - Male
PACSpawnTables["Male"] = {}
PACSpawnTables["Male"].UID = "41322-PS22Male"
PACSpawnTables["Male"].Name = "Male"
PACSpawnTables["Male"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Male"].ContentsNum = 0
PACSpawnTables["Male"].Icon = "icon16/male.png"
PACSpawnTables["Male"].ID = 41322
PACSpawnTables["Male"].ParentID = 4132
//Clothing - Female
PACSpawnTables["Female"] = {}
PACSpawnTables["Female"].UID = "41323-PS23Female"
PACSpawnTables["Female"].Name = "Female"
PACSpawnTables["Female"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Female"].ContentsNum = 0
PACSpawnTables["Female"].Icon = "icon16/female.png"
PACSpawnTables["Female"].ID = 41323
PACSpawnTables["Female"].ParentID = 4132
//Weapons
PACSpawnTables["Weapons"] = {}
PACSpawnTables["Weapons"].UID = "4133-PS2Weapons"
PACSpawnTables["Weapons"].Name = "Weapons"
PACSpawnTables["Weapons"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Weapons"].ContentsNum = 0
PACSpawnTables["Weapons"].Icon = "icon16/hs_strife.png"
PACSpawnTables["Weapons"].ID = 4133
PACSpawnTables["Weapons"].ParentID = 413



///!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\!!WARNING - A LOT OF WORDS AHEAD!!/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\\\
///!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\!!WARNING - A LOT OF WORDS AHEAD!!/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\\\

//Characters
PACAppendToKV("header", "Kids", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/base_lib.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/npc_lib.mdl", PACSpawnTables["Characters"])
PACAppendToKV("header", "Trolls", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/base_lib.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/npc_lib.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/karkat.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/aradia.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/sollux.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/nepeta.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/kanaya.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/terezi.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/vriska.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/gamzee.mdl", PACSpawnTables["Characters"])
PACAppendToKV("model", "models/homestuck/actors/eridan.mdl", PACSpawnTables["Characters"])


//Clothing - Head
PACAppendToKV("header", "???", PACSpawnTables["Head"])
PACAppendToKV("header", "Horns", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_karkat.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_aradia.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_sollux.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_nepeta.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_kanaya.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_terezi.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_vriska.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_gamzee.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_eridan.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/horns_shrek.mdl", PACSpawnTables["Head"])
PACAppendToKV("header", "Hair", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_karkat.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_aradia.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_sollux.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_nepeta.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_kanaya.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_terezi.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_vriska.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_gamzee.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_eridan.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/hair_garnet.mdl", PACSpawnTables["Head"])
PACAppendToKV("header", "Face", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_sollux.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_terezi.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_vriska.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_occuloid.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/ear_triangle.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/ear_hoop.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/ear_grist.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_blackframe.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_blackshades.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_wiresquare.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_wireshades.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_rectangle.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_gendo.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_connie.mdl", PACSpawnTables["Head"])
PACAppendToKV("model", "models/homestuck/clothes/glasses_blindfold.mdl", PACSpawnTables["Head"])


//Clothing - Male
PACAppendToKV("header", "Neck", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_blacktie_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_bowtie.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_utie.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_headphones.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_pentagram.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_collar.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_beads.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/neck_scarf.mdl", PACSpawnTables["Male"])
PACAppendToKV("header", "Over", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/over_trenchcoat_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/over_cape.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/over_denimvest.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/over_vcoat_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/over_vcoat_torn_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("header", "Upper", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_cancer_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_aries_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_gemini_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_leo_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_virgo_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_libra_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_scorpio_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_capricorn_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_aquarius_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/tee_white_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_casual_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_football_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_grunge_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_grunge_alt_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_pikachu_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_clefable_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_gengar_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_batman_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_beetee_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_invaders_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_nitemagic_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_beesweater_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_blouse_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_dotsweater_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_stripedsweater_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_sweater_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_hoodie_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_hoodie_alt_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_shirtless_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_tanktop_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_athletic_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/top_tubetop_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("text", "Arms", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/arm_robo_l.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/arm_robo_r.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/arm_robo_lr.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_sleeves.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_punkbracelet.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_crabwatch.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_sweatbands.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/gloves_brute.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/gloves_standard.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/gloves_sapphire.mdl", PACSpawnTables["Male"])
PACAppendToKV("text", "Lower", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/pants_grey_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/pants_black_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/pants_dots_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/pants_stripes_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/pants_leggings_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/pants_bikeshorts_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_undies_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_dragon_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_dolphin_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/body_onepiece_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/body_onepiece_alt_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_swimtrunks_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/pants_pantsless_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_long_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_kanaya_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_knee_black_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_tartan_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_punk1_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_ruffle_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_short_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("text", "Socks", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/socks_leggings_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/socks_bikeshorts_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/socks_short.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/socks_knee_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/socks_knee_striped_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/socks_high_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/socks_high_striped_m.mdl", PACSpawnTables["Male"])
PACAppendToKV("text", "Shoes", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_sollux.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_vriska.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_black.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_colourable.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_classicheels.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_flats.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_flipflops.mdl", PACSpawnTables["Male"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_wedges.mdl", PACSpawnTables["Male"])


//Clothing - Female
PACAppendToKV("header", "Neck", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_blacktie_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_bowtie.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_utie.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_headphones.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_pentagram.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_collar.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_beads.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/neck_scarf.mdl", PACSpawnTables["Female"])
PACAppendToKV("header", "Over", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/over_trenchcoat_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/over_cape.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/over_denimvest.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/over_vcoat_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/over_vcoat_torn_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("header", "Upper", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_cancer_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_aries_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_gemini_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_leo_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_virgo_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_libra_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_scorpio_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_capricorn_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_aquarius_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/tee_white_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_casual_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_football_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_grunge_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_grunge_alt_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_pikachu_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_clefable_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_gengar_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_batman_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_beetee_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_invaders_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_nitemagic_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_beesweater_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_blouse_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_dotsweater_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_stripedsweater_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_sweater_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_hoodie_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_hoodie_alt_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_shirtless_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_tanktop_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_athletic_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/top_tubetop_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("text", "Arms", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/arm_robo_l.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/arm_robo_r.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/arm_robo_lr.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_sleeves.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_punkbracelet.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_crabwatch.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/wrist_sweatbands.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/gloves_brute.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/gloves_standard.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/gloves_sapphire.mdl", PACSpawnTables["Female"])
PACAppendToKV("text", "Lower", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/pants_grey_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/pants_black_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/pants_dots_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/pants_stripes_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/pants_leggings_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/pants_bikeshorts_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_undies_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_dragon_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_dolphin_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/body_onepiece_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/body_onepiece_alt_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shorts_swimtrunks_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/pants_pantsless_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_long_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_kanaya_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_knee_black_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_tartan_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_punk1_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_ruffle_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/skirt_short_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("text", "Socks", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/socks_leggings_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/socks_bikeshorts_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/socks_short.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/socks_knee_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/socks_knee_striped_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/socks_high_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/socks_high_striped_f.mdl", PACSpawnTables["Female"])
PACAppendToKV("text", "Shoes", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_sollux.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_vriska.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_black.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_colourable.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_classicheels.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_flats.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_flipflops.mdl", PACSpawnTables["Female"])
PACAppendToKV("model", "models/homestuck/clothes/shoes_wedges.mdl", PACSpawnTables["Female"])


//Weapons
PACAppendToKV("header", "Kids", PACSpawnTables["Weapons"])
PACAppendToKV("header", "Trolls", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_ksickle.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_nclaws.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_kchainsaw.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_tcane.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_v8ball.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_gclubs.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_gclub.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_eahab.mdl", PACSpawnTables["Weapons"])
PACAppendToKV("model", "models/homestuck/weapons/w_torch.mdl", PACSpawnTables["Weapons"])

///!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\!!WARNING - LOT OF WORDS FINISHED!!/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\**/!\\\


hook.Add("PopulatePropMenu", "PACSpawnlistAdd", function()
	if not tobool(LocalPlayer():GetInfo("hs_spawnlist")) then return end
	for k, v in pairs(PACSpawnTables) do
		spawnmenu.AddPropCategory("settings/spawnlist/" .. v.UID, v.Name, util.KeyValuesToTable(v.Contents.."\n}"), v.Icon, v.ID, v.ParentID)
	end
end)
