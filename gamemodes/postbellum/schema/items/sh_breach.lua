
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Взрывчатка";
ITEM.plural = "Взрывчаток";
ITEM.uniqueID = "breach";
--ITEM.cost = 10;
ITEM.model = "models/props_wasteland/prison_padlock001a.mdl";
ITEM.weight = 0.5;
ITEM.access = "V";
ITEM.useText = "Разместить";
ITEM.business = true;
ITEM.blacklist = {CLASS_MPR};
ITEM.description = "С ее помощью можно выломать дверь.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if (!IsValid(entity.breach)) then
				if (Clockwork.plugin:Call("PlayerCanBreachEntity", player, entity)) then
					local breach = ents.Create("cw_breach"); breach:Spawn();
					
					breach:SetBreachEntity(entity, trace);
				else
					Clockwork.player:Notify(player, "Этот объект не может быть заминирован!");
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, "Этот объект уже заминирован!");
				
				return false;
			end;
		else
			Clockwork.player:Notify(player, "Вы недостаточно близко к объекту!");
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, "Объект не найден!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();