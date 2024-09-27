
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();
	ATTRIBUTE.name = "Быстрота";
	ATTRIBUTE.maximum = 100;
	ATTRIBUTE.uniqueID = "agt";
	ATTRIBUTE.description = "Влияет на скорость бега.";
	ATTRIBUTE.isOnCharScreen = true;
ATB_AGILITY = Clockwork.attribute:Register(ATTRIBUTE);