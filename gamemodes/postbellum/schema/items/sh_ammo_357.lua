
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "9x33 мм R";
	ITEM.plural = "9x33 мм R";
	ITEM.uniqueID = "ammo_357";
	--ITEM.cost = 40;
	ITEM.classes = {CLASS_EOW};
	ITEM.model = "models/items/357ammo.mdl";
	ITEM.weight = 1;
	ITEM.access = "V";
	ITEM.business = true;
	ITEM.ammoClass = "357";
	ITEM.ammoAmount = 21;
	ITEM.description = "Небольшая коробка с патронами для револьвера.";
ITEM:Register();