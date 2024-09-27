
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();
	ATTRIBUTE.name = "Сила";
	ATTRIBUTE.maximum = 100;
	ATTRIBUTE.uniqueID = "str";
	ATTRIBUTE.description = "Влияет на силу удара и вместительность инвентаря.";
	ATTRIBUTE.isOnCharScreen = true;
ATB_STRENGTH = Clockwork.attribute:Register(ATTRIBUTE);