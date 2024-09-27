
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Глава повстанцев");
	CLASS.color = Color(150, 125, 100, 255);
	CLASS.factions = {FACTION_REBELBOSS};
	CLASS.wages = 40;
	CLASS.isDefault = true;
	CLASS.wagesName = "Выручка";
	CLASS.description = "Обычный повстанец, живущий сам по себе.";
	CLASS.defaultPhysDesc = "Носит грязную одежду.";
CLASS_REBELBOSS = CLASS:Register();