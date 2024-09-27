
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Колба А";
ITEM.plural = "Колб А";
ITEM.uniqueID = "lab6";
ITEM.model = "models/labware/flask1.mdl";
ITEM.weight = 0.5;
ITEM.category = "Лаборатория";
ITEM.description = "Стеклянная колба.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();