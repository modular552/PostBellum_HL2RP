
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Униформа Городского Ополчения";
ITEM.plural = "Униформ Городского Ополчения";
ITEM.uniqueID = "uniform_goo";
ITEM.group = "combine";
ITEM.weight = 4;
ITEM.protection = 0.4;
ITEM.description = "Униформа сотрудников Городского Ополчения.";
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