
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Стальная пластина";
ITEM.plural = "Стальных пластин";
ITEM.uniqueID = "craft_plate";
ITEM.spawnType = "crafting";
ITEM.spawnValue = 4;
--ITEM.cost = 5;
ITEM.model = "models/gibs/scanner_gib02.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Мусор";
ITEM.business = true;
ITEM.description = "Небольшая металлическая пластина.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();