if (SERVER) then AddCSLuaFile() return end

local PACSpawnlist = CreateClientConVar("pac_spawnlist", 1)

local function AppendToKV(kvtype, kvdata, kvtab)
	if kvtype == "header" then
	kvtab.ContentsNum = kvtab.ContentsNum+1
	kvtab.Contents = kvtab.Contents.."\n".."\""..kvtab.ContentsNum.."\"".." { ".."\"type\" ".."\""..kvtype.."\"   ".."\"text\" ".."\""..kvdata.."\"".." }"
	elseif kvtype == "model" then
		kvtab.ContentsNum = kvtab.ContentsNum+1
	kvtab.Contents = kvtab.Contents.."\n".."\""..kvtab.ContentsNum.."\"".." { ".."\"type\" ".."\""..kvtype.."\"   ".."\"model\" ".."\""..kvdata.."\"".." }"
	end
end

local PACSpawnTables = {}
PACSpawnTables["Main"] = {}
PACSpawnTables["Main"].UID = "2000-PAC3"
PACSpawnTables["Main"].Name = "PAC3"
PACSpawnTables["Main"].Contents = [["TableToKeyValues"{ "1"{ "type" "header"   "text" "PAC3 Spawnlist made by Flex" } ]]
PACSpawnTables["Main"].Icon = "icon16/user_edit.png"
PACSpawnTables["Main"].ID = 2000
PACSpawnTables["Main"].ParentID = 0

PACSpawnTables["Weapons"] = {}
PACSpawnTables["Weapons"].UID = "20000-TF2Weapons"
PACSpawnTables["Weapons"].Name = "TF2 Weapons"
PACSpawnTables["Weapons"].Contents = [["TableToKeyValues"{ ]]
PACSpawnTables["Weapons"].ContentsNum = 0
PACSpawnTables["Weapons"].Icon = "games/16/tf.png"
PACSpawnTables["Weapons"].ID = 20000
PACSpawnTables["Weapons"].ParentID = 2000

PACSpawnTables["Hats"] = {}
PACSpawnTables["Hats"].UID = "20001-TF2Hats"
PACSpawnTables["Hats"].Name = "Hats"
PACSpawnTables["Hats"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Hats"].ContentsNum = 0
PACSpawnTables["Hats"].Icon = "spawnicons/models/player/items/all_class/all_domination_b_medic.png"
PACSpawnTables["Hats"].ID = 20001
PACSpawnTables["Hats"].ParentID = 2000

PACSpawnTables["AllClass"] = {}
PACSpawnTables["AllClass"].UID = "200011-AllClass"
PACSpawnTables["AllClass"].Name = "All Class"
PACSpawnTables["AllClass"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["AllClass"].ContentsNum = 0
PACSpawnTables["AllClass"].Icon = "icon16/folder.png"
PACSpawnTables["AllClass"].ID = 200011
PACSpawnTables["AllClass"].ParentID = 20001
PACSpawnTables["Scout"] = {}
PACSpawnTables["Scout"].UID = "200012-Scout"
PACSpawnTables["Scout"].Name = "Scout"
PACSpawnTables["Scout"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Scout"].ContentsNum = 0
PACSpawnTables["Scout"].Icon = "icon16/folder.png"
PACSpawnTables["Scout"].ID = 200012
PACSpawnTables["Scout"].ParentID = 20001
PACSpawnTables["Soldier"] = {}
PACSpawnTables["Soldier"].UID = "200013-Soldier"
PACSpawnTables["Soldier"].Name = "Soldier"
PACSpawnTables["Soldier"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Soldier"].ContentsNum = 0
PACSpawnTables["Soldier"].Icon = "icon16/folder.png"
PACSpawnTables["Soldier"].ID = 200013
PACSpawnTables["Soldier"].ParentID = 20001
PACSpawnTables["Pyro"] = {}
PACSpawnTables["Pyro"].UID = "200014-Pyro"
PACSpawnTables["Pyro"].Name = "Pyro"
PACSpawnTables["Pyro"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Pyro"].ContentsNum = 0
PACSpawnTables["Pyro"].Icon = "icon16/folder.png"
PACSpawnTables["Pyro"].ID = 200014
PACSpawnTables["Pyro"].ParentID = 20001
PACSpawnTables["Demo"] = {}
PACSpawnTables["Demo"].UID = "200015-Demo"
PACSpawnTables["Demo"].Name = "Demo"
PACSpawnTables["Demo"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Demo"].ContentsNum = 0
PACSpawnTables["Demo"].Icon = "icon16/folder.png"
PACSpawnTables["Demo"].ID = 200015
PACSpawnTables["Demo"].ParentID = 20001
PACSpawnTables["Heavy"] = {}
PACSpawnTables["Heavy"].UID = "200016-Heavy"
PACSpawnTables["Heavy"].Name = "Heavy"
PACSpawnTables["Heavy"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Heavy"].ContentsNum = 0
PACSpawnTables["Heavy"].Icon = "icon16/folder.png"
PACSpawnTables["Heavy"].ID = 200016
PACSpawnTables["Heavy"].ParentID = 20001
PACSpawnTables["Engineer"] = {}
PACSpawnTables["Engineer"].UID = "200017-Engineer"
PACSpawnTables["Engineer"].Name = "Engineer"
PACSpawnTables["Engineer"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Engineer"].ContentsNum = 0
PACSpawnTables["Engineer"].Icon = "icon16/folder.png"
PACSpawnTables["Engineer"].ID = 200017
PACSpawnTables["Engineer"].ParentID = 20001
PACSpawnTables["Medic"] = {}
PACSpawnTables["Medic"].UID = "200017-Medic"
PACSpawnTables["Medic"].Name = "Medic"
PACSpawnTables["Medic"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Medic"].ContentsNum = 0
PACSpawnTables["Medic"].Icon = "icon16/folder.png"
PACSpawnTables["Medic"].ID = 200017
PACSpawnTables["Medic"].ParentID = 20001
PACSpawnTables["Sniper"] = {}
PACSpawnTables["Sniper"].UID = "200018-Sniper"
PACSpawnTables["Sniper"].Name = "Sniper"
PACSpawnTables["Sniper"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Sniper"].ContentsNum = 0
PACSpawnTables["Sniper"].Icon = "icon16/folder.png"
PACSpawnTables["Sniper"].ID = 200018
PACSpawnTables["Sniper"].ParentID = 20001
PACSpawnTables["Spy"] = {}
PACSpawnTables["Spy"].UID = "200019-Spy"
PACSpawnTables["Spy"].Name = "Spy"
PACSpawnTables["Spy"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["Spy"].ContentsNum = 0
PACSpawnTables["Spy"].Icon = "icon16/folder.png"
PACSpawnTables["Spy"].ID = 200019
PACSpawnTables["Spy"].ParentID = 20001

PACSpawnTables["WS"] = {}
PACSpawnTables["WS"].UID = "30001-TF2WS"
PACSpawnTables["WS"].Name = "Workshop"
PACSpawnTables["WS"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WS"].ContentsNum = 0
PACSpawnTables["WS"].Icon = "icon16/wrench.png"
PACSpawnTables["WS"].ID = 30001
PACSpawnTables["WS"].ParentID = 2000

PACSpawnTables["WSAllClass"] = {}
PACSpawnTables["WSAllClass"].UID = "300011-AllClass"
PACSpawnTables["WSAllClass"].Name = "All Class"
PACSpawnTables["WSAllClass"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSAllClass"].ContentsNum = 0
PACSpawnTables["WSAllClass"].Icon = "icon16/folder.png"
PACSpawnTables["WSAllClass"].ID = 300011
PACSpawnTables["WSAllClass"].ParentID = 30001
PACSpawnTables["WSScout"] = {}
PACSpawnTables["WSScout"].UID = "300012-Scout"
PACSpawnTables["WSScout"].Name = "Scout"
PACSpawnTables["WSScout"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSScout"].ContentsNum = 0
PACSpawnTables["WSScout"].Icon = "icon16/folder.png"
PACSpawnTables["WSScout"].ID = 300012
PACSpawnTables["WSScout"].ParentID = 30001
PACSpawnTables["WSSoldier"] = {}
PACSpawnTables["WSSoldier"].UID = "300013-Soldier"
PACSpawnTables["WSSoldier"].Name = "Soldier"
PACSpawnTables["WSSoldier"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSSoldier"].ContentsNum = 0
PACSpawnTables["WSSoldier"].Icon = "icon16/folder.png"
PACSpawnTables["WSSoldier"].ID = 300013
PACSpawnTables["WSSoldier"].ParentID = 30001
PACSpawnTables["WSPyro"] = {}
PACSpawnTables["WSPyro"].UID = "300014-Pyro"
PACSpawnTables["WSPyro"].Name = "Pyro"
PACSpawnTables["WSPyro"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSPyro"].ContentsNum = 0
PACSpawnTables["WSPyro"].Icon = "icon16/folder.png"
PACSpawnTables["WSPyro"].ID = 300014
PACSpawnTables["WSPyro"].ParentID = 30001
PACSpawnTables["WSDemo"] = {}
PACSpawnTables["WSDemo"].UID = "300015-Demo"
PACSpawnTables["WSDemo"].Name = "Demo"
PACSpawnTables["WSDemo"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSDemo"].ContentsNum = 0
PACSpawnTables["WSDemo"].Icon = "icon16/folder.png"
PACSpawnTables["WSDemo"].ID = 300015
PACSpawnTables["WSDemo"].ParentID = 30001
PACSpawnTables["WSHeavy"] = {}
PACSpawnTables["WSHeavy"].UID = "300016-Heavy"
PACSpawnTables["WSHeavy"].Name = "Heavy"
PACSpawnTables["WSHeavy"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSHeavy"].ContentsNum = 0
PACSpawnTables["WSHeavy"].Icon = "icon16/folder.png"
PACSpawnTables["WSHeavy"].ID = 300016
PACSpawnTables["WSHeavy"].ParentID = 30001
PACSpawnTables["WSEngineer"] = {}
PACSpawnTables["WSEngineer"].UID = "300017-Engineer"
PACSpawnTables["WSEngineer"].Name = "Engineer"
PACSpawnTables["WSEngineer"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSEngineer"].ContentsNum = 0
PACSpawnTables["WSEngineer"].Icon = "icon16/folder.png"
PACSpawnTables["WSEngineer"].ID = 300017
PACSpawnTables["WSEngineer"].ParentID = 30001
PACSpawnTables["WSMedic"] = {}
PACSpawnTables["WSMedic"].UID = "300017-Medic"
PACSpawnTables["WSMedic"].Name = "Medic"
PACSpawnTables["WSMedic"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSMedic"].ContentsNum = 0
PACSpawnTables["WSMedic"].Icon = "icon16/folder.png"
PACSpawnTables["WSMedic"].ID = 300017
PACSpawnTables["WSMedic"].ParentID = 30001
PACSpawnTables["WSSniper"] = {}
PACSpawnTables["WSSniper"].UID = "300018-Sniper"
PACSpawnTables["WSSniper"].Name = "Sniper"
PACSpawnTables["WSSniper"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSSniper"].ContentsNum = 0
PACSpawnTables["WSSniper"].Icon = "icon16/folder.png"
PACSpawnTables["WSSniper"].ID = 300018
PACSpawnTables["WSSniper"].ParentID = 30001
PACSpawnTables["WSSpy"] = {}
PACSpawnTables["WSSpy"].UID = "300019-Spy"
PACSpawnTables["WSSpy"].Name = "Spy"
PACSpawnTables["WSSpy"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSSpy"].ContentsNum = 0
PACSpawnTables["WSSpy"].Icon = "icon16/folder.png"
PACSpawnTables["WSSpy"].ID = 300019
PACSpawnTables["WSSpy"].ParentID = 30001
PACSpawnTables["WSWep"] = {}
PACSpawnTables["WSWep"].UID = "30002-Weapons"
PACSpawnTables["WSWep"].Name = "Weapons"
PACSpawnTables["WSWep"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["WSWep"].ContentsNum = 0
PACSpawnTables["WSWep"].Icon = "icon16/gun.png"
PACSpawnTables["WSWep"].ID = 30002
PACSpawnTables["WSWep"].ParentID = 30001

PACSpawnTables["MvM"] = {}
PACSpawnTables["MvM"].UID = "20002-MvM"
PACSpawnTables["MvM"].Name = "MvM"
PACSpawnTables["MvM"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["MvM"].ContentsNum = 0
PACSpawnTables["MvM"].Icon = "spawnicons/models/player/items/mvm_loot/all_class/mvm_badge.png"
PACSpawnTables["MvM"].ID = 20002
PACSpawnTables["MvM"].ParentID = 2000

PACSpawnTables["PModels"] = {}
PACSpawnTables["PModels"].UID = "20003-PModels"
PACSpawnTables["PModels"].Name = "Playermodels"
PACSpawnTables["PModels"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["PModels"].Icon = "icon16/user.png"
PACSpawnTables["PModels"].ID = 20003
PACSpawnTables["PModels"].ParentID = 2000
PACSpawnTables["PM_HL2"] = {}
PACSpawnTables["PM_HL2"].UID = "200031-PM-HL2"
PACSpawnTables["PM_HL2"].Name = "Half-Life 2"
PACSpawnTables["PM_HL2"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["PM_HL2"].ContentsNum = 0
PACSpawnTables["PM_HL2"].Icon = "games/16/hl2.png"
PACSpawnTables["PM_HL2"].ID = 200031
PACSpawnTables["PM_HL2"].ParentID = 20003
PACSpawnTables["PM_CIT"] = {}
PACSpawnTables["PM_CIT"].UID = "2000311-PM-CIT"
PACSpawnTables["PM_CIT"].Name = "Citizens"
PACSpawnTables["PM_CIT"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["PM_CIT"].ContentsNum = 0
PACSpawnTables["PM_CIT"].Icon = "icon16/user_green.png"
PACSpawnTables["PM_CIT"].ID = 2000311
PACSpawnTables["PM_CIT"].ParentID = 200031
PACSpawnTables["PM_CSS"] = {}
PACSpawnTables["PM_CSS"].UID = "200032-PM-CSS"
PACSpawnTables["PM_CSS"].Name = "Counter-Strike"
PACSpawnTables["PM_CSS"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["PM_CSS"].ContentsNum = 0
PACSpawnTables["PM_CSS"].Icon = "games/16/cstrike.png"
PACSpawnTables["PM_CSS"].ID = 200032
PACSpawnTables["PM_CSS"].ParentID = 20003
PACSpawnTables["PM_GM"] = {}
PACSpawnTables["PM_GM"].UID = "200033-PM-GM"
PACSpawnTables["PM_GM"].Name = "Other"
PACSpawnTables["PM_GM"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["PM_GM"].ContentsNum = 0
PACSpawnTables["PM_GM"].Icon = "games/16/garrysmod.png"
PACSpawnTables["PM_GM"].ID = 200033
PACSpawnTables["PM_GM"].ParentID = 20003

PACSpawnTables["PACMDL"] = {}
PACSpawnTables["PACMDL"].UID = "20004-PACMDL"
PACSpawnTables["PACMDL"].Name = "PAC Models"
PACSpawnTables["PACMDL"].Contents = [["TableToKeyValues"{]]
PACSpawnTables["PACMDL"].ContentsNum = 0
PACSpawnTables["PACMDL"].Icon = "spawnicons/models/pac/default.png"
PACSpawnTables["PACMDL"].ID = 20004
PACSpawnTables["PACMDL"].ParentID = 2000

-- Not gonna automate because we dunno what players have --

--HL2--
AppendToKV("header", "Resistance", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/alyx.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/barney.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/eli.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/gman_high.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/kleiner.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/magnusson.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/monk.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/mossman_arctic.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/odessa.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("header", "Combine", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/breen.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/combine_soldier.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/combine_soldier_prisonguard.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/combine_super_soldier.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/police.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/police_fem.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/soldier_stripped.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("header", "Zombies/Misc", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/charple.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/corpse1.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/zombie_classic.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/zombie_fast.mdl", PACSpawnTables["PM_HL2"])
AppendToKV("model", "models/player/zombie_soldier.mdl", PACSpawnTables["PM_HL2"])

--HL2 Citizens--
AppendToKV("header", "City", PACSpawnTables["PM_CIT"])
for i = 1,9 do
	AppendToKV("model", "models/player/group01/male_0"..i..".mdl", PACSpawnTables["PM_CIT"])
end
for i = 1,6 do
	AppendToKV("model", "models/player/group01/female_0"..i..".mdl", PACSpawnTables["PM_CIT"])
end
AppendToKV("header", "Refugees", PACSpawnTables["PM_CIT"])
AppendToKV("model", "models/player/group02/male_02.mdl", PACSpawnTables["PM_CIT"])
AppendToKV("model", "models/player/group02/male_04.mdl", PACSpawnTables["PM_CIT"])
AppendToKV("model", "models/player/group02/male_06.mdl", PACSpawnTables["PM_CIT"])
AppendToKV("model", "models/player/group02/male_08.mdl", PACSpawnTables["PM_CIT"])
AppendToKV("header", "Resistance", PACSpawnTables["PM_CIT"])
for i = 1,9 do
	AppendToKV("model", "models/player/group03/male_0"..i..".mdl", PACSpawnTables["PM_CIT"])
end
for i = 1,6 do
	AppendToKV("model", "models/player/group03/female_0"..i..".mdl", PACSpawnTables["PM_CIT"])
end
AppendToKV("header", "Medics", PACSpawnTables["PM_CIT"])
for i = 1,9 do
	AppendToKV("model", "models/player/group03m/male_0"..i..".mdl", PACSpawnTables["PM_CIT"])
end
for i = 1,6 do
	AppendToKV("model", "models/player/group03m/female_0"..i..".mdl", PACSpawnTables["PM_CIT"])
end

--CSS--
AppendToKV("header", "Terrorists", PACSpawnTables["PM_CSS"])
AppendToKV("model", "models/player/arctic.mdl", PACSpawnTables["PM_CSS"])
AppendToKV("model", "models/player/guerilla.mdl", PACSpawnTables["PM_CSS"])
AppendToKV("model", "models/player/leet.mdl", PACSpawnTables["PM_CSS"])
AppendToKV("model", "models/player/phoenix.mdl", PACSpawnTables["PM_CSS"])

AppendToKV("header", "Counter-Terrorists", PACSpawnTables["PM_CSS"])
AppendToKV("model", "models/player/gasmask.mdl", PACSpawnTables["PM_CSS"])
AppendToKV("model", "models/player/swat.mdl", PACSpawnTables["PM_CSS"])
AppendToKV("model", "models/player/urban.mdl", PACSpawnTables["PM_CSS"])
AppendToKV("header", "Hostages", PACSpawnTables["PM_CSS"])
for i = 1,4 do
	AppendToKV("model", "models/player/hostage/hostage_0"..i..".mdl", PACSpawnTables["PM_CSS"])
end

--Other--
AppendToKV("model", "models/player/dod_american.mdl", PACSpawnTables["PM_GM"])
AppendToKV("model", "models/player/dod_german.mdl", PACSpawnTables["PM_GM"])
AppendToKV("model", "models/player/p2_chell.mdl", PACSpawnTables["PM_GM"])
AppendToKV("model", "models/player/skeleton.mdl", PACSpawnTables["PM_GM"])

--PAC Models--
AppendToKV("model", "models/pac/default.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female_jiggle.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female_arm_l.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female_arm_r.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female_leg_l.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female_leg_r.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female_torso.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/female/base_female_torso_jiggle.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/male/base_male.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/male/base_male_arm_l.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/male/base_male_arm_r.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/male/base_male_leg_l.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/male/base_male_leg_r.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/male/base_male_torso.mdl", PACSpawnTables["PACMDL"])
AppendToKV("header", "Jiggles", PACSpawnTables["PACMDL"])
for i = 0,5 do
	AppendToKV("model", "models/pac/jiggle/base_cloth_"..i..".mdl", PACSpawnTables["PACMDL"])
end
for i = 0,5 do
	AppendToKV("model", "models/pac/jiggle/base_cloth_"..i.."_gravity.mdl", PACSpawnTables["PACMDL"])
end
for i = 0,5 do
	AppendToKV("model", "models/pac/jiggle/base_jiggle_"..i..".mdl", PACSpawnTables["PACMDL"])
end
for i = 0,5 do
	AppendToKV("model", "models/pac/jiggle/base_jiggle_"..i.."_gravity.mdl", PACSpawnTables["PACMDL"])
end
AppendToKV("header", "Capes", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/jiggle/clothing/base_cape_1.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/jiggle/clothing/base_cape_2.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/jiggle/clothing/base_cape_1_gravity.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/jiggle/clothing/base_cape_2_gravity.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/jiggle/clothing/base_trench_1.mdl", PACSpawnTables["PACMDL"])
AppendToKV("model", "models/pac/jiggle/clothing/base_trench_1_gravity.mdl", PACSpawnTables["PACMDL"])

-- AUTOMATION BELOW --
--Weapons
for _,mdl in pairs(file.Find("models/weapons/c_models/*","GAME")) do
	if not mdl:find(".mdl") or not mdl:find("arms") or not mdl:find("animations") then continue end
	AppendToKV("model", "models/weapons/c_models/"..mdl, PACSpawnTables["Weapons"])
end
for _,dir in next,select(2,file.Find("models/weapons/c_models/*","GAME")) do
	for _,mdl in pairs(file.Find("models/weapons/c_models/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/weapons/c_models/"..dir.."/"..mdl, PACSpawnTables["Weapons"])
	end
end

--Hats
for _,mdl in pairs(file.Find("models/player/items/all_class/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/all_class/"..mdl, PACSpawnTables["AllClass"])
end
for _,mdl in pairs(file.Find("models/player/items/scout/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/scout/"..mdl, PACSpawnTables["Scout"])
end
for _,mdl in pairs(file.Find("models/player/items/soldier/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/soldier/"..mdl, PACSpawnTables["Soldier"])
end
for _,mdl in pairs(file.Find("models/player/items/pyro/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/pyro/"..mdl, PACSpawnTables["Pyro"])
end
for _,mdl in pairs(file.Find("models/player/items/demo/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/demo/"..mdl, PACSpawnTables["Demo"])
end
for _,mdl in pairs(file.Find("models/player/items/heavy/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/heavy/"..mdl, PACSpawnTables["Heavy"])
end
for _,mdl in pairs(file.Find("models/player/items/engineer/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/engineer/"..mdl, PACSpawnTables["Engineer"])
end
for _,mdl in pairs(file.Find("models/player/items/medic/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/medic/"..mdl, PACSpawnTables["Medic"])
end
for _,mdl in pairs(file.Find("models/player/items/sniper/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/sniper/"..mdl, PACSpawnTables["Sniper"])
end
for _,mdl in pairs(file.Find("models/player/items/spy/*","GAME")) do
	if not mdl:find(".mdl") then continue end
	AppendToKV("model", "models/player/items/spy/"..mdl, PACSpawnTables["Spy"])
end

--MvM
for _,dir in next,select(2,file.Find("models/player/items/mvm_loot/*","GAME")) do
	for _,mdl in pairs(file.Find("models/player/items/mvm_loot/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/player/items/mvm_loot/"..dir.."/"..mdl, PACSpawnTables["MvM"])
	end
end

--Workshop
for _,dir in next,select(2,file.Find("models/workshop/player/items/all_class/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/all_class/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/all_class/"..dir.."/"..mdl, PACSpawnTables["WSAllClass"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/scout/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/scout/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/scout/"..dir.."/"..mdl, PACSpawnTables["WSScout"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/soldier/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/soldier/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/soldier/"..dir.."/"..mdl, PACSpawnTables["WSSoldier"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/pyro/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/pyro/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/pyro/"..dir.."/"..mdl, PACSpawnTables["WSPyro"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/demo/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/demo/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/demo/"..dir.."/"..mdl, PACSpawnTables["WSDemo"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/heavy/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/heavy/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/heavy/"..dir.."/"..mdl, PACSpawnTables["WSHeavy"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/engineer/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/engineer/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/engineer/"..dir.."/"..mdl, PACSpawnTables["WSEngineer"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/medic/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/medic/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/medic/"..dir.."/"..mdl, PACSpawnTables["WSMedic"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/sniper/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/sniper/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/sniper/"..dir.."/"..mdl, PACSpawnTables["WSSniper"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/player/items/spy/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/player/items/spy/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/player/items/spy/"..dir.."/"..mdl, PACSpawnTables["WSSpy"])
	end
end
for _,dir in next,select(2,file.Find("models/workshop/weapons/c_models/*","GAME")) do
	for _,mdl in pairs(file.Find("models/workshop/weapons/c_models/"..dir.."/*","GAME")) do
		if not mdl:find(".mdl") then continue end
		AppendToKV("model", "models/workshop/weapons/c_models/"..dir.."/"..mdl, PACSpawnTables["WSWep"])
	end
end

hook.Add("PopulatePropMenu", "PACSpawnlistAdd", function()
	if not tobool(LocalPlayer():GetInfo("pac_spawnlist")) then return end
	for k, v in pairs(PACSpawnTables) do
		spawnmenu.AddPropCategory("settings/spawnlist/" .. v.UID, v.Name, util.KeyValuesToTable(v.Contents.."\n}"), v.Icon, v.ID, v.ParentID)
	end
end)
