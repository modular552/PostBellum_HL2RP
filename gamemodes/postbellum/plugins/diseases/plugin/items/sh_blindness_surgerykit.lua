
-----------------------------------------------------
--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local ITEM = Clockwork.item:New();
ITEM.name = 'Аптечка "для глаз"';
ITEM.plural = 'Аптечек "для глаз"';
ITEM.uniqueID = "blindness_surgerykit";
ITEM.model = "models/Items/BoxMRounds.mdl";
ITEM.weight = 0.2;
ITEM.access = "Q";
ITEM.category = "Медикаменты";
ITEM.description = "Аптечка со всем необходимым для профилактики зрения.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local lookingPly = player:GetEyeTrace().Entity
	
	if lookingPly:IsPlayer() then
		if lookingPly:GetCharacterData("diseases") == "blindness" then
			Clockwork.player:Notify(player, "You've used the surgery kit to cure the blindness.");
			lookingPly:SetCharacterData("diseases", "none");
		elseif lookingPly:GetCharacterData("diseases") == "colorblindness" then
			Clockwork.player:Notify(player, "Вы помогли пациенту избавиться от слепоты.");
			lookingPly:SetCharacterData("diseases", "none");
		else
			Clockwork.player:Notify(player, "Вы использовали эту аптечку, но ничего не изменилось.");
		end
	else
		Clockwork.player:Notify(player, "Вы должны смотреть на игрока!");
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();