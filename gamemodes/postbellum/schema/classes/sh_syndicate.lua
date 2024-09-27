
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Синдикат");
	CLASS.color = Color(100, 125, 200, 255);
	CLASS.factions = {FACTION_SYNDICATE};
	CLASS.isDefault = true;
	CLASS.description = "Обычный синдикатовец, живущий сам по себе.";
	CLASS.defaultPhysDesc = "Носит грязную одежду.";
CLASS_SYNDICATE = CLASS:Register();