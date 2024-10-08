
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Крепкое пиво";
ITEM.plural = "Крепкого пива";
ITEM.uniqueID = "beer_strong";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.thirst = 15;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/GlassBottle01a.mdl";
ITEM.skin = 1;
ITEM.weight = 0.6;
ITEM.access = "w";
ITEM.business = true;
ITEM.expireTime = 600;
ITEM.vomit = 20;
ITEM.description = "Бутылка крепкого пива. Очень крепкого.";

ITEM:Register();