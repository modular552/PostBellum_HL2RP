
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();
	ATTRIBUTE.name = "Познания в медицине";
	ATTRIBUTE.maximum = 100;
	ATTRIBUTE.uniqueID = "med";
	ATTRIBUTE.description = "Влияет на эффективность использования медикаментов.";
	ATTRIBUTE.isOnCharScreen = true;
ATB_MEDICAL = Clockwork.attribute:Register(ATTRIBUTE);