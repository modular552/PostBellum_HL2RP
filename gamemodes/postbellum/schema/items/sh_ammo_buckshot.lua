
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "12x70 мм";
	ITEM.plural = "12x70 мм";
	ITEM.uniqueID = "ammo_buckshot";
	--ITEM.cost = 30;
	ITEM.classes = {CLASS_EOW};
	ITEM.model = "models/items/boxbuckshot.mdl";
	ITEM.weight = 1;
	ITEM.business = true;
	ITEM.ammoClass = "buckshot";
	ITEM.ammoAmount = 16;
	ITEM.description = "Красная коробка с патронами для дробовика.";
ITEM:Register();