
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");
ITEM.name = "Импульсная винтовка L";
ITEM.plural = "Импульсных винтовок L";
ITEM.uniqueID = "weapon_ar2_hack";
ITEM.weaponClass = "weapon_ar2";
--ITEM.cost = 400;
ITEM.model = "models/weapons/w_irifle.mdl";
ITEM.weight = 4;
ITEM.classes = {CLASS_EOW};
ITEM.business = true;
ITEM.description = "Мощное оружие инопланетного происхождения. Био блокировка взломана.";
ITEM.isAttachment = true;
ITEM.hasFlashlight = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
--ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-3.96, 4.95, -2.97);
ITEM.whitelist = {
	FACTION_MPF,
	FACTION_OTA,
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