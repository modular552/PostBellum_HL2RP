
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Баночка с Биогелем";
ITEM.plural = "Баночек с Биогелем";
ITEM.uniqueID = "health_vial";
--ITEM.cost = 15;
ITEM.model = "models/healthvial.mdl";
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.useText = "Выпить";
ITEM.factions = {FACTION_MPF, FACTION_OTA};
ITEM.category = "Медикаменты"
ITEM.business = true;
ITEM.useSound = "items/medshot4.wav";
ITEM.description = "Странная баночка, наполненная зеленой жидкостью.";
ITEM.customFunctions = {"Вылечить"};
ITEM.vomit = -20;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + Schema:GetHealAmount(player, 1.5), 0, player:GetMaxHealth() ) );
	
	Clockwork.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Вылечить") then
			Clockwork.player:RunClockworkCommand(player, "CharHeal", "health_vial");
		end;
	end;
end;

ITEM:Register();