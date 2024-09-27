
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Отбеливатель";
ITEM.plural = "Отбеливателей";
ITEM.uniqueID = "bleach";
ITEM.spawnType = "misc";
ITEM.spawnValue = 4;
ITEM.thirst = 50;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/garbage_plasticbottle001a.mdl";
ITEM.weight = 0.8;
ITEM.access = "v";
ITEM.useText = "Выпить";
ITEM.business = true;
ITEM.category = "Продукты";
ITEM.description = "Пластиковая бутылка с отбеливателем. При попадании внутрь немедленно обратиться к врачу!";
ITEM.vomit = 100;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:TakeItem(self);
	player:TakeDamage(40, player, player);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();