
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local CLASS = Clockwork.class:New("Беженец");
	CLASS.color = Color(150, 125, 100, 255);
	CLASS.factions = {FACTION_REFUGEE};
	CLASS.isDefault = true;
	CLASS.description = "Обычный беженец, живущий сам по себе.";
	CLASS.defaultPhysDesc = "Грязная жопа.";
CLASS_REFUGEE = CLASS:Register();