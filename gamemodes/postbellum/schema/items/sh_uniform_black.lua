
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("clothes_base");
ITEM.name = "Черная броня Повстанцев";
ITEM.plural = "Черной брони Повстанцев";
ITEM.uniqueID = "uniform_black";
ITEM.weight = 8;
ITEM.protection = 0.4;
ITEM.description = "Броня черного цвета с металлическими пластинами.";
ITEM.whitelist = {
	FACTION_MPF,
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
	return "models/tactical_rebel.mdl";
end;

ITEM:Register();