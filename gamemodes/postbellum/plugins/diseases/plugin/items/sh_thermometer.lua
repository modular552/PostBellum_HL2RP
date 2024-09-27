
-----------------------------------------------------
--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Термометр";
ITEM.plural = "Термометров";
ITEM.uniqueID = "thermometer";
ITEM.model = "models/props_c17/TrapPropeller_Lever.mdl";
ITEM.weight = 0.2;
ITEM.access = "q";
ITEM.category = "Медикаменты";
ITEM.description = "Электронный термометр, показывает температуру тела.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local lookingPly = player:GetEyeTrace().Entity
	
	if lookingPly:IsPlayer() then
		if lookingPly:GetCharacterData("diseases") == "fever" then
			Clockwork.player:Notify(player, "Температура: "..math.random(38.1, 42.6).." C");
		else
			Clockwork.player:Notify(player, "Температура: 36.6 C");
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