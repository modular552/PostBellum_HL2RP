
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Костюм лоялиста";
ITEM.plural = "Костюмов лоялиста";
ITEM.uniqueID = "uniform_loyalist";
ITEM.group = "factory";
ITEM.weight = 2;
ITEM.protection = 0.2;
ITEM.description = "Специальная одежда для лоялистов.";
ITEM.whitelist = {
	FACTION_MPF,
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