
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "BCAA";
ITEM.plural = "BCAA";
ITEM.uniqueID = "craft_bcaa";
ITEM.spawnType = "misc";
ITEM.spawnValue = 2;
--ITEM.cost = 5;
ITEM.model = "models/props_lab/jar01b.mdl";
ITEM.weight = 1;
ITEM.access = "v";
--ITEM.category = "Мусор";
ITEM.business = true;
ITEM.description = "Аминокислоты с разветвленными боковыми цепями. Нейтрализуют вредное воздействие воды Альянса.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();