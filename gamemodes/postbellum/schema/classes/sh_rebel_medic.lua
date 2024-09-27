
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Медик повстанцев");
	CLASS.color = Color(150, 125, 100, 255);
	CLASS.factions = {FACTION_REBELMEDIC};
	CLASS.isDefault = true;
	CLASS.description = "Обычный повстанец, живущий сам по себе.";
	CLASS.defaultPhysDesc = "Носит грязную одежду.";
CLASS_REBELMEDIC = CLASS:Register();