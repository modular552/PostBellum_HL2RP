
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Спецодежда рабочего";
ITEM.plural = "Спецодежд рабочего";
ITEM.uniqueID = "uniform_factory";
ITEM.weight = 6;
ITEM.protection = 0.3;
ITEM.description = "Спецодежда для работы в опасных условиях.";
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

-- Called when a replacement is needed for a player.
function ITEM:GetReplacement(player)
	return "models/citizen_17.mdl";
end;

ITEM:Register();