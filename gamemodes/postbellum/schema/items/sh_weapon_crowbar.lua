
-----------------------------------------------------
--[[
	Screw your green text!
--]]

local ITEM = Clockwork.item:New("weapon_base");
ITEM.name = "Монтировка";
ITEM.plural = "Монтировок";
ITEM.uniqueID = "weapon_crowbar";
--ITEM.cost = 200;  
ITEM.model = "models/weapons/w_crowbar.mdl";
ITEM.weight = 2;
ITEM.access = "v";
ITEM.business = true;
ITEM.isMeleeWeapon = true;
ITEM.description = "Старая ржавая монтировка.";
ITEM.isAttachment = true;
ITEM.loweredOrigin = Vector(3, 0, -4);
--ITEM.loweredAngles = Angle(0, 45, 0);
ITEM.attachmentBone = "ValveBiped.Bip01_Spine";
ITEM.attachmentOffsetAngles = Angle(0, 0, 0);
ITEM.attachmentOffsetVector = Vector(-2, 5, 4);
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