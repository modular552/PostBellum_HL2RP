
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Пробирка Б";
ITEM.plural = "Пробирок Б";
ITEM.uniqueID = "lab4";
ITEM.model = "models/labware/tube2.mdl";
ITEM.weight = 0.3;
ITEM.category = "Лаборатория";
ITEM.description = "Стеклянная пробирка с пробкой.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();