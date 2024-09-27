
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();
	ATTRIBUTE.name = "Стойкость";
	ATTRIBUTE.maximum = 100;
	ATTRIBUTE.uniqueID = "end";
	ATTRIBUTE.description = "Влияет на восприимчивость к урону.";
	ATTRIBUTE.isOnCharScreen = true;
ATB_ENDURANCE = Clockwork.attribute:Register(ATTRIBUTE);