
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Активированный уголь";
ITEM.plural = "Активированных углей";
ITEM.uniqueID = "health_carbon";
ITEM.spawnType = "medical";
ITEM.spawnValue = 2;
--ITEM.cost = 15;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.1;
ITEM.access = "v";
ITEM.useText = "Употребить";
ITEM.category = "Медикаменты";
ITEM.business = true;
ITEM.description = "Металлическая баночка с таблетками активированного угля. Помогает при отравлении.";
ITEM.vomit = -40;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:TakeItem(self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();