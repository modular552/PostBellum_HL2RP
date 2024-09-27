
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Стальной брус";
ITEM.plural = "Стальных брусов";
ITEM.uniqueID = "craft_bar";
ITEM.spawnType = "crafting";
ITEM.spawnValue = 3;
--ITEM.cost = 5;
ITEM.model = "models/gibs/metal_gib3.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Мусор";
ITEM.business = true;
ITEM.description = "Средней длинны стальной уголок.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();