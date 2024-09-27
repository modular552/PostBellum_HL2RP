
-----------------------------------------------------
local CLASS = Clockwork.class:New("Городское Ополчение");
	CLASS.color = Color(250, 200, 100, 255);
	CLASS.factions = {FACTION_GOO};
	CLASS.wages = 20;
	CLASS.isDefault = true;
	CLASS.wagesName = "Денежное довольствие";
	CLASS.description = "Citizens who are loyal to the Universal Union, all working together for a better Earth.";
	CLASS.defaultPhysDesc = "Wearing a uniform with their name etched in as well as the words 'Civil Workers' Union'.";
CLASS_GOO = CLASS:Register();