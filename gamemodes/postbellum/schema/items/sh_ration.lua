
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Рацион";
ITEM.plural = "Рационов";
ITEM.uniqueID = "ration";
ITEM.model = "models/weapons/w_package.mdl";
ITEM.weight = 2;
ITEM.useText = "Открыть";
ITEM.description = "Содержит немного пищи и небольшое количество жетонов.";

-- Called when a player attempts to pick up the item.
function ITEM:CanPickup(player, quickUse, itemEntity)
	if (quickUse) then
		if (!player:CanHoldWeight(self.weight)) then
			Clockwork.player:Notify(player, "У вас недостаточно места в инвентаре!");
			
			return false;
		end;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (Schema:PlayerIsCombine(player)) then
		Clockwork.player:Notify(player, "Вы не можете открыть этот рацион!");
		
		return false;
	elseif (player:GetFaction() == FACTION_ADMIN) then
		Clockwork.player:Notify(player, "Вы не можете открыть этот рацион!");
		
		return false;
	elseif (player:GetFaction() == FACTION_CITIZEN or player:GetFaction() == FACTION_GOO or player:GetFaction() == FACTION_CWU or player:GetFaction() == FACTION_CWUMEDIC) then
		Clockwork.player:GiveCash(player, 30, "Рацион");
		player:GiveItem(Clockwork.item:CreateInstance("citizen_supplements"), true);
		Clockwork.plugin:Call("PlayerUseRation", player);
	else
		Clockwork.player:GiveCash(player, 10, "Рацион");
		player:GiveItem(Clockwork.item:CreateInstance("citizen_supplements"), true);
		Clockwork.plugin:Call("PlayerUseRation", player);
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();