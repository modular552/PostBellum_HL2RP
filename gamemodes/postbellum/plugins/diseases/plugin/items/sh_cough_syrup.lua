
-----------------------------------------------------
--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Сироп от кашля";
ITEM.plural = "Сиропов от кашля";
ITEM.uniqueID = "cough_syrup";
ITEM.model = "models/props_junk/glassjug01.mdl";
ITEM.weight = 0.2;
ITEM.access = "q";
ITEM.useText = "Выпить";
ITEM.category = "Медикаменты";
ITEM.description = "Стеклянная бутыль наполненная липкой густой жидкостью.";
ITEM.customFunctions = {"Напоить"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if player:GetCharacterData("diseases") == "cough" then
		player:SetCharacterData( "diseases", "none" );
	end
end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Напоить") then
			local lookingPly = player:GetEyeTrace().Entity
			if lookingPly:IsPlayer() then
				if lookingPly:GetCharacterData("diseases") == "cough" then
					lookingPly:SetCharacterData( "diseases", "none" );
					Clockwork.player:Notify(player, "Вы дали больному сироп от кашля.");
					player:TakeItem(player:FindItemByID("cough_syrup"));
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