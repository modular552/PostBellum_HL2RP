
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Рация";
ITEM.plural = "Раций";
ITEM.uniqueID = "handheld_radio";
--ITEM.cost = 20;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.model = "models/cdev2_pb/handheld_radio.mdl";
ITEM.weight = 0.4;
ITEM.access = "v";
ITEM.business = true;
ITEM.description = "Рация с функцией настройки радиочастоты.";
ITEM.customFunctions = {"Частота"};

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Частота") then
			Clockwork.datastream:Start(player, "Frequency", player:GetCharacterData("frequency", ""));
		end;
	end;
end;

ITEM:Register();