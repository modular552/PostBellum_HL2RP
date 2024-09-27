
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Униформа специалиста ГСР";
ITEM.plural = "Униформ специалиста ГСР";
ITEM.uniqueID = "uniform_cwu_white";
ITEM.group_adv = "betacz/group03";
ITEM.weight = 2;
ITEM.protection = 0.1;
ITEM.description = "Униформа специалиста ГСР с повязкой на руке.";
ITEM.whitelist = {
	FACTION_MPF,
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