
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Растительное масло";
ITEM.plural = "Растительного масла";
ITEM.uniqueID = "vegetable_oil";
ITEM.spawnType = "misc";
ITEM.spawnValue = 4;
ITEM.thirst = 30;
ITEM.hunger = 20;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/garbage_plasticbottle002a.mdl";
ITEM.weight = 0.6;
ITEM.access = "v";
ITEM.useText = "Выпить";
ITEM.business = false;
ITEM.category = "Продукты";
ITEM.description = "Бутылка с растительным маслом. Противное на вкус.";
ITEM.vomit = 60;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:TakeItem(self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();