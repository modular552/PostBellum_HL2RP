
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Sniper Overwatch Soldier");
	CLASS.color = Color(150, 50, 50, 255);
	CLASS.wages = 35;
	CLASS.factions = {FACTION_OTA};
	CLASS.wagesName = "Денежное довольствие";
	CLASS.maleModel = "models/combine_soldier_prisonguard.mdl";
	CLASS.description = "A transhuman Overwatch soldier produced by the Combine.";
	CLASS.defaultPhysDesc = "Wearing dirty Overwatch gear";
CLASS_SOW = CLASS:Register();