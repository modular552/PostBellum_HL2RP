
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Темное пиво";
ITEM.plural = "Темного пива";
ITEM.uniqueID = "beer_black";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.thirst = 25;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/garbage_glassbottle001a.mdl";
ITEM.weight = 1.5;
ITEM.access = "w";
ITEM.business = true;
ITEM.attributes = {Strength = 2};
ITEM.expireTime = 300;
ITEM.vomit = 10;
ITEM.description = "Полторашка темного пива.";

ITEM:Register();