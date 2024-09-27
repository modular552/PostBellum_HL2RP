
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Светлое пиво";
ITEM.plural = "Светлого пива";
ITEM.uniqueID = "beer_white";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.thirst = 15;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/GlassBottle01a.mdl";
ITEM.weight = 0.6;
ITEM.access = "w";
ITEM.business = true;
ITEM.expireTime = 120;
ITEM.vomit = 5;
ITEM.description = "Бутылка светлого пива. Мягкий вкус.";

ITEM:Register();