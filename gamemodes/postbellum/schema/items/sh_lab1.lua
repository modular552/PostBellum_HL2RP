
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Бутыль А";
ITEM.plural = "Бутылей А";
ITEM.uniqueID = "lab1";
ITEM.model = "models/labware/bottle1.mdl";
ITEM.weight = 0.5;
ITEM.category = "Лаборатория";
ITEM.description = "Стеклянная бутыль с крышкой.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();