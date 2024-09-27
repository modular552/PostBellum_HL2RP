
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Elite Overwatch Soldier");
	CLASS.color = Color(150, 50, 50, 255);
	CLASS.wages = 50;
	CLASS.factions = {FACTION_OTA};
	CLASS.wagesName = "Денежное довольствие";
	CLASS.maleModel = "models/combine_super_soldier.mdl";
	CLASS.description = "An elite transhuman Overwatch soldier produced by the Combine.";
	CLASS.defaultPhysDesc = "Wearing shiny Overwatch gear";
CLASS_EOW = CLASS:Register();