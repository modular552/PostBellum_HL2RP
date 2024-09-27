
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");
ITEM.name = "Чемодан";
ITEM.plural = "Чемоданов";
ITEM.uniqueID = "cw_suitcase";
ITEM.spawnType = "misc";
ITEM.spawnValue = 5;
--ITEM.cost = 12;
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.weight = 2;
ITEM.access = "1";
ITEM.business = true;
ITEM.category = "Сумки";
ITEM.isMeleeWeapon = true;
ITEM.description = "Коричневый чемодан, в котором лежит немного старого тряпья.";
ITEM.isAttachment = true;
ITEM.attachmentBone = "ValveBiped.Bip01_R_Hand";
ITEM.attachmentOffsetAngles = Angle(0, 90, -10);
ITEM.attachmentOffsetVector = Vector(0, 0, 4);
ITEM.whitelist = {
	FACTION_MPF,
	FACTION_OTA,
	FACTION_CITIZEN,
	FACTION_CWU,
	FACTION_CWUMEDIC,
	FACTION_CWUBOSS,
	FACTION_GOO,
	FACTION_ADMIN,
	FACTION_REBEL,
	FACTION_REBELMEDIC,
	FACTION_REBELBOSS,
	FACTION_SYNDICATE,
	FACTION_REFUGEE,
	FACTION_RAIDER,
	FACTION_INCOG
};

ITEM:Register();