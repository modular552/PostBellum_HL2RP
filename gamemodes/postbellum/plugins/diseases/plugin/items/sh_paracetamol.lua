
-----------------------------------------------------
--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Парацетамол";
ITEM.plural = "Парацетамола";
ITEM.uniqueID = "paracetamol";
ITEM.model = "models/props_junk/garbage_metalcan001a.mdl";
ITEM.weight = 0.2;
ITEM.access = "q";
ITEM.useText = "Употребить";
ITEM.category = "Медикаменты";
ITEM.description = "Баночка с таблетками. Применяются при высокой температуре.";
ITEM.customFunctions = {"Дать"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if player:GetCharacterData("diseases") == "fever" then
		player:SetCharacterData( "diseases", "none" );
	end
end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Дать") then
			local lookingPly = player:GetEyeTrace().Entity
			if lookingPly:IsPlayer() then
				if lookingPly:GetCharacterData("diseases") == "fever" then
					lookingPly:SetCharacterData( "diseases", "none" );
					Clockwork.player:Notify(player, "Вы дали больному несколько таблеток.");
					player:TakeItem(player:FindItemByID("paracetamol"));
				end
			else
				Clockwork.player:Notify(player, "Вы должны смотреть на игрока!");
				return false;
			end;
		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();