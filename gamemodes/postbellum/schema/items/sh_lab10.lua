
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Бутыль с трубкой";
ITEM.plural = "Бутылей с трубкой";
ITEM.uniqueID = "lab10";
ITEM.model = "models/labware/washer.mdl";
ITEM.weight = 0.5;
ITEM.category = "Лаборатория";
ITEM.description = "Стеклянная бутыль с трубкой.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();