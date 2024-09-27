
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("ammo_base");
	ITEM.name = "4.6x30 мм";
	ITEM.plural = "4.6x30 мм";
	ITEM.uniqueID = "ammo_smg1";
	--ITEM.cost = 30;
	ITEM.classes = {CLASS_EMP, CLASS_EOW};
	ITEM.model = "models/items/boxmrounds.mdl";
	ITEM.weight = 2;
	ITEM.access = "V";
	ITEM.business = true;
	ITEM.ammoClass = "smg1";
	ITEM.ammoAmount = 45;
	ITEM.description = "Контейнер с патронами для автомата.";
ITEM:Register();