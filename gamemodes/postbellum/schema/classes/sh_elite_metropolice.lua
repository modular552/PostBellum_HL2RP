
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Elite Metropolice");
	CLASS.color = Color(50, 100, 150, 255);
	CLASS.wages = 50;
	CLASS.factions = {FACTION_MPF};
	CLASS.wagesName = "Денежное довольствие";
	CLASS.description = "An elite metropolice unit working as Civil Protection.";
	CLASS.defaultPhysDesc = "Wearing a metrocop jacket with a radio";
CLASS_EMP = CLASS:Register();