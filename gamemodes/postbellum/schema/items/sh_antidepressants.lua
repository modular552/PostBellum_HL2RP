
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Антидепрессанты";
ITEM.plural = "Антидепрессантов";
ITEM.uniqueID = "antidepressants";
ITEM.spawnType = "medical";
ITEM.spawnValue = 3;
--ITEM.cost = 10;
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.2;
ITEM.access = "w";
ITEM.useText = "Употребить";
ITEM.category = "Медикаменты";
ITEM.business = true;
ITEM.description = "Металлическая баночка с таблетками, которые помогут вам расслабиться.";
ITEM.vomit = 30;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetSharedVar("antidepressants", CurTime() + 600);
	
	player:BoostAttribute(self.name, ATB_ENDURANCE, 10, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, -2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();