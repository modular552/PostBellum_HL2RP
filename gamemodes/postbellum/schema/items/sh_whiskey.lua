
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Виски";
ITEM.plural = "Виски";
ITEM.uniqueID = "whiskey";
ITEM.thirst = 25;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/glassjug01.mdl";
ITEM.weight = 1.5;
ITEM.access = "w";
ITEM.business = true;
ITEM.attributes = {Stamina = 2};
ITEM.expireTime = 600;
ITEM.vomit = 20;
ITEM.description = "Стеклянная бутылка с виски. Имеет приятный аромат.";

ITEM:Register();