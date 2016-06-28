function FlexAndHenkeHouse()

	ClearFNHHouse()

local HousePropTable = {
	--kitchen
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/plates/plate4x5.mdl" , ["pos"] = Vector(-871 , -1345 , -14318), ["ang"] = Angle(0 , -180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "sprops/textures/sprops_metal6" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/blocks/cube075x5x075.mdl" , ["pos"] = Vector(-954 , -1345 , -14305), ["ang"] = Angle(0 , 180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "phoenix_storms/Fender_wood" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/blocks/cube075x2x075.mdl" , ["pos"] = Vector(-883 , -1238 , -14305), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "phoenix_storms/Fender_wood" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/plates/plate1x5.mdl" , ["pos"] = Vector(-949 , -1345 , -14280), ["ang"] = Angle(0 , -180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "models/gibs/metalgibs/metal_gibs" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/plates/plate1.mdl" , ["pos"] = Vector(-949 , -1225 , -14281), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "models/gibs/metalgibs/metal_gibs" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/plates/plate1.mdl" , ["pos"] = Vector(-949 , -1222 , -14281), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "models/gibs/metalgibs/metal_gibs" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/hunter/plates/plate1x2.mdl" , ["pos"] = Vector(-883 , -1245 , -14280), ["ang"] = Angle(0 , 91 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "models/gibs/metalgibs/metal_gibs" , ["color"] = color_white }, 

	--kitchen props
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_interiors/sinkkitchen01a.mdl" , ["pos"] = Vector(-892 , -1452 , -14283), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_wasteland/kitchen_stove001a.mdl" , ["pos"] = Vector(-837 , -1445 , -14320), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furniturefridge001a.mdl" , ["pos"] = Vector(-791 , -1457 , -14279), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_militia/shelves.mdl" , ["pos"] = Vector(-776 , -1360 , -14244), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "fb_microwave" , ["model"] = "models/props/cs_office/microwave.mdl" , ["pos"] = Vector(-941 , -1254 , -14278), ["ang"] = Angle(0 , -135 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_militia/barstool01.mdl" , ["pos"] = Vector(-987 , -1303 , -14320), ["ang"] = Angle(0 , -180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_militia/barstool01.mdl" , ["pos"] = Vector(-991 , -1351 , -14320), ["ang"] = Angle(0 , 180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_militia/barstool01.mdl" , ["pos"] = Vector(-992 , -1401 , -14320), ["ang"] = Angle(0 , 180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	--living room
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/shelfunit01a.mdl" , ["pos"] = Vector(-1033 , -1454 , -14321), ["ang"] = Angle(0 , 0 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furnituredrawer001a.mdl" , ["pos"] = Vector(-1110 , -1450 , -14300), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furnituredrawer001a.mdl" , ["pos"] = Vector(-1152 , -1450 , -14300), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furnituredrawer003a.mdl" , ["pos"] = Vector(-1093 , -1457 , -14257), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furnituredrawer003a.mdl" , ["pos"] = Vector(-1169 , -1457 , -14257), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furniturecupboard001a.mdl" , ["pos"] = Vector(-1111 , -1453 , -14233), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furniturecupboard001a.mdl" , ["pos"] = Vector(-1142 , -1453 , -14233), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furniturecupboard001a.mdl" , ["pos"] = Vector(-1173 , -1453 , -14233), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furniturecouch001a.mdl" , ["pos"] = Vector(-1132 , -1345 , -14303), ["ang"] = Angle(0 , -90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_interiors/furniture_lamp01a.mdl" , ["pos"] = Vector(-1190 , -1347 , -14286), ["ang"] = Angle(0 , 45 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	{ ["entity"] = "gmod_playx_proximity" , ["model"] = "models/props/cs_office/tv_plasma.mdl" , ["pos"] = Vector(-1131 , -1464 , -14277), ["ang"] = Angle(0 , 90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	--bed area
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/de_inferno/bed.mdl" , ["pos"] = Vector(-1163 , -1166 , -14320), ["ang"] = Angle(0 , 0 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/de_inferno/bed.mdl" , ["pos"] = Vector(-1163 , -1119 , -14320), ["ang"] = Angle(0 , 0 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/furnituredrawer002a.mdl" , ["pos"] = Vector(-1198 , -1213 , -14303), ["ang"] = Angle(0 , 0 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_combine/breenclock.mdl" , ["pos"] = Vector(-1198 , -1212 , -14282), ["ang"] = Angle(0 , 27 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	--misc
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_interiors/furniture_desk01a.mdl" , ["pos"] = Vector(-1025 , -1114 , -14300), ["ang"] = Angle(0 , -90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white }, 
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_office/computer.mdl" , ["pos"] = Vector(-1025 , -1112 , -14280), ["ang"] = Angle(0 , -90 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_office/computer_caseb.mdl" , ["pos"] = Vector(-1048 , -1110 , -14280), ["ang"] = Angle(0 , -87 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	{ ["entity"] = "prop_physics" , ["model"] = "models/props_junk/trashbin01a.mdl" , ["pos"] = Vector(-790 , -1182 , -14300), ["ang"] = Angle(0 , -180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_c17/door01_left.mdl" , ["pos"] = Vector(-772 , -1113 , -14266), ["ang"] = Angle(0 , 180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_office/offpaintingm.mdl" , ["pos"] = Vector(-1158 , -1097 , -14244), ["ang"] = Angle(0 , 180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props/cs_office/offinspd.mdl" , ["pos"] = Vector(-1026 , -1096 , -14230), ["ang"] = Angle(0 , -180 , 0), ["owner"] = nil , ["static"] = true , ["material"] = "" , ["color"] = color_white },

	--winders
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_building_details/storefront_template001a_bars.mdl" , ["pos"] = Vector(-1211 , -1177 , -14253), ["ang"] = Angle(0 , 180 , -90), ["owner"] = nil , ["static"] = true , ["material"] = "models/debug/debugwhite" , ["color"] = Color(33,91,51) },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_building_details/storefront_template001a_bars.mdl" , ["pos"] = Vector(-1211 , -1282 , -14252), ["ang"] = Angle(0 , 180 , -90), ["owner"] = nil , ["static"] = true , ["material"] = "models/debug/debugwhite" , ["color"] = Color(33,91,51) },
	{ ["entity"] = "prop_physics" , ["model"] = "models/props_building_details/storefront_template001a_bars.mdl" , ["pos"] = Vector(-1211 , -1387 , -14252), ["ang"] = Angle(0 , 180 , -90), ["owner"] = nil , ["static"] = true , ["material"] = "models/debug/debugwhite" , ["color"] = Color(33,91,51) },

}

LoadPropTable( HousePropTable , "FNHHouse" )

end

function ClearFNHHouse()

	ClearTableProps( "FNHHouse" )

end