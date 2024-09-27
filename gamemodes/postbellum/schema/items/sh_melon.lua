
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Арбуз";
ITEM.plural = "Арбузов";
ITEM.uniqueID = "melon";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
--ITEM.cost = 8;
ITEM.model = "models/props_junk/watermelon01.mdl";
ITEM.weight = 3;
ITEM.access = "v";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Большой зеленый арбуз.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();