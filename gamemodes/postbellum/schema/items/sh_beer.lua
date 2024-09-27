
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Пиво";
ITEM.plural = "Пива";
ITEM.uniqueID = "beer";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.thirst = 20;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/garbage_glassbottle003a.mdl";
ITEM.weight = 1;
ITEM.access = "w";
ITEM.business = true;
ITEM.attributes = {Strength = 2};
ITEM.expireTime = 300;
ITEM.vomit = 15;
ITEM.description = "Стеклянная бутылка заполненная странной жидкостью.";

ITEM:Register();