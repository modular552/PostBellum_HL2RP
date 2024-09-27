
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Гражданин");
	CLASS.color = Color(150, 125, 100, 255);
	CLASS.factions = {FACTION_CITIZEN};
	CLASS.isDefault = true;
	CLASS.description = "Обычный гражданин, живущий по законам Альянса.";
	CLASS.defaultPhysDesc = "На вид 25 лет | Носит грязную форму гражданского | Неадекватное поведение";
CLASS_CITIZEN = CLASS:Register();