
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Сырое мясо Хэдкраба";
ITEM.plural = "Сырого мяса Хэдкраба";
ITEM.uniqueID = "cfood_headcrab";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 2;
ITEM.thirst = 10;
ITEM.hunger = 30;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.model = "models/Gibs/antlion_gib_small_2.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Странное склизкое мясо. Лучше не пробовать.";
ITEM.vomit = 100;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:TakeItem(self);
	player:TakeDamage(20, player, player);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();