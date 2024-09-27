
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Ржавый MP7";
ITEM.plural = "Ржавых MP7";
ITEM.uniqueID = "craft_smg1";
ITEM.isRareSpawn = true;
ITEM.spawnValue = 0.6;
--ITEM.cost = 5;
ITEM.model = "models/weapons/w_smg1.mdl";
ITEM.weight = 2;
ITEM.access = "v";
ITEM.category = "Мусор";
ITEM.business = true;
ITEM.description = "Старое заклинившее оружие. Заржавело и забилось грязью.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();