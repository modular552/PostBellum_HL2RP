
-----------------------------------------------------
--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Антидот";
ITEM.plural = "Антидотов";
ITEM.uniqueID = "green_antidote";
ITEM.model = "models/healthvial.mdl";
ITEM.weight = 0.2;
ITEM.factions = {FACTION_MPF};
ITEM.category = "Медикаменты";
ITEM.description = 'Шприц с надписью "Антидот"';
ITEM.customFunctions = {"Вколоть"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if player:GetCharacterData("diseases") == "slow_deathinjection" then
		player:SetCharacterData( "diseases", "none" );
		Clockwork.player:Notify(player, "Вы вкололи себе шприц.");
	elseif player:GetCharacterData("diseases") == "fast_deathinjection" then
		Clockwork.player:Notify(player, "Вы вкололи себе шприц, но кажется это не помогает");
	end
end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Вколоть") then
			local lookingPly = player:GetEyeTrace().Entity
			if lookingPly:IsPlayer() then
				if lookingPly:GetCharacterData("diseases") == "slow_deathinjection" then
					lookingPly:SetCharacterData( "diseases", "none" );
				elseif lookingPly:GetCharacterData("diseases") == "fast_deathinjection" then
					Clockwork.player:Notify(player, "Вы вкололи шприц пациенту, но кажется это не помогает.");
				end
				Clockwork.player:Notify(player, "Вы вкололи шприц пациенту.");
				return true;
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