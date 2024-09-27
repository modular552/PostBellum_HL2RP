
-----------------------------------------------------
--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Медицинский фонарик";
ITEM.plural = "Медицинских фонариков";
ITEM.uniqueID = "eyelight";
ITEM.model = "models/lagmite/lagmite.mdl";
ITEM.weight = 0.2;
ITEM.access = "q";
ITEM.category = "Медикаменты";
ITEM.description = "Маленький фонарик для проверки глаз пациентов.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local lookingPly = player:GetEyeTrace().Entity
	
	if lookingPly:IsPlayer() then
		if lookingPly:GetCharacterData("diseases") == "blindness" then
			Clockwork.player:Notify(player, "The eyes of the person barely respond to the light.");
		elseif lookingPly:GetCharacterData("diseases") == "colorblindness" then
			Clockwork.player:Notify(player, "Глаза пациента не реагируют на свет.");
		else
			Clockwork.player:Notify(player, "Глаза пациента реагируют на свет.");
		end
		return false;
	else
		Clockwork.player:Notify(player, "Вы должны смотреть на игрока!");
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();