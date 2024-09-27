
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ATTRIBUTE = Clockwork.attribute:New();
	ATTRIBUTE.name = "Ловкость рук";
	ATTRIBUTE.maximum = 100;
	ATTRIBUTE.uniqueID = "dex";
	ATTRIBUTE.description = "Влияет на то, как быстро вы можете связать/освободить.";
	ATTRIBUTE.isOnCharScreen = true;
ATB_DEXTERITY = Clockwork.attribute:Register(ATTRIBUTE);