
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();
	ATTRIBUTE.name = "Акробатика";
	ATTRIBUTE.maximum = 100;
	ATTRIBUTE.uniqueID = "acr";
	ATTRIBUTE.description = "Влияет на высоту прыжка.";
	ATTRIBUTE.isOnCharScreen = true;
ATB_ACROBATICS = Clockwork.attribute:Register(ATTRIBUTE);