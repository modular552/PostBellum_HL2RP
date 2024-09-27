
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("weapon_base");
ITEM.name = "Фонарик";
ITEM.plural = "Фонариков";
ITEM.uniqueID = "cw_flashlight";
--ITEM.cost = 15;
ITEM.model = "models/lagmite/lagmite.mdl";
ITEM.weight = 0.8;
ITEM.access = "v";
ITEM.business = true;
ITEM.isFakeWeapon = true;
ITEM.isMeleeWeapon = true;
ITEM.description = "Обычный фонарик с кнопкой.";
ITEM:Register();