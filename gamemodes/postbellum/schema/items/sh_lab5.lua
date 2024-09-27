
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Горелка";
ITEM.plural = "Горелок";
ITEM.uniqueID = "lab5";
ITEM.model = "models/labware/burner.mdl";
ITEM.weight = 1;
ITEM.category = "Лаборатория";
ITEM.description = "Горелка из химической лаборатории.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();