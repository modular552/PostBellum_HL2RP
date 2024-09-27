
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Бинт";
ITEM.plural = "Бинтов";
ITEM.uniqueID = "bandage";
ITEM.spawnType = "medical";
ITEM.spawnValue = 1;
--ITEM.cost = 8;
ITEM.model = "models/props_wasteland/prison_toiletchunk01f.mdl";
ITEM.weight = 0.5;
ITEM.access = "1v";
ITEM.useText = "Использовать";
ITEM.category = "Медикаменты"
ITEM.business = true;
ITEM.description = "Стерильный бинт, используется для перевязки ран.";
ITEM.customFunctions = {"Вылечить"};

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + Schema:GetHealAmount(player), 0, player:GetMaxHealth() ) );
	
	Clockwork.plugin:Call("PlayerHealed", player, player, self);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Вылечить") then
			Clockwork.player:RunClockworkCommand(player, "CharHeal", "bandage");
		end;
	end;
end;

ITEM:Register();