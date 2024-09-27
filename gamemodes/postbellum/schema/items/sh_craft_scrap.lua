
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Металлолом";
ITEM.plural = "Металлолома";
ITEM.uniqueID = "craft_scrap";
ITEM.spawnType = "crafting";
ITEM.spawnValue = 5;
--ITEM.cost = 5;
ITEM.model = "models/gibs/manhack_gib01.mdl";
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.category = "Мусор";
ITEM.business = true;
ITEM.description = "Кучка металлического хлама.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();