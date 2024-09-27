
-----------------------------------------------------
local CLASS = Clockwork.class:New("Директор ГСР");
	CLASS.color = Color(250, 200, 100, 255);
	CLASS.factions = {FACTION_CWUBOSS};
	CLASS.wages = 40;
	CLASS.isDefault = true;
	CLASS.wagesName = "Зарплата";
	CLASS.description = "Citizens who are loyal to the Universal Union, all working together for a better Earth.";
	CLASS.defaultPhysDesc = "Wearing a uniform with their name etched in as well as the words 'Civil Workers' Union'.";
CLASS_CWUBOSS = CLASS:Register();