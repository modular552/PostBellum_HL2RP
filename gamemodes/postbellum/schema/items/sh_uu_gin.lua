
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Джин";
ITEM.plural = "Джина";
ITEM.uniqueID = "uu_gin";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.thirst = 20;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/bioshockinfinite/jin_bottle.mdl";
ITEM.weight = 1.5;
ITEM.access = "w";
ITEM.business = true;
ITEM.attributes = {Stamina = 2};
ITEM.expireTime = 600;
ITEM.vomit = 30;
ITEM.description = "Стеклянная бутылка заполненная странной жидкостью.";

ITEM:Register();