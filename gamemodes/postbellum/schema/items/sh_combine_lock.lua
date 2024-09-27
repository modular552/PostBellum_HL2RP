
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Замок Альянса";
ITEM.plural = "Замков Альянса";
ITEM.uniqueID = "combine_lock";
--ITEM.cost = 40;
ITEM.model = "models/props_combine/combine_lock01.mdl";
ITEM.weight = 4;
ITEM.classes = {CLASS_EMP, CLASS_EOW};
ITEM.useText = "Разместить";
ITEM.business = true;
ITEM.description = "Приспособление Альянса. Надежно запирает любую дверь.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	local entity = trace.Entity;
	
	if (IsValid(entity)) then
		if (entity:GetPos():Distance( player:GetPos() ) <= 192) then
			if (!IsValid(entity.combineLock)) then
				if (!Clockwork.entity:IsDoorFalse(entity)) then
					local angles = trace.HitNormal:Angle() + Angle(0, 270, 0);
					local position;
					
					if (string.lower( entity:GetClass() ) == "prop_door_rotating") then
						position = trace;
					else
						position = trace.HitPos + (trace.HitNormal * 4);
					end;
					
					if (!IsValid( Schema:ApplyCombineLock(entity, position, angles) )) then
						return false;
					elseif (IsValid(entity.breach)) then
						entity.breach:CreateDummyBreach();
						entity.breach:Explode();
						entity.breach:Remove();
					end;
				else
					Clockwork.player:Notify(player, "Эту дверь нельзя закрыть замком Альянса!");
					
					return false;
				end;
			else
				Clockwork.player:Notify(player, "Эта дверь уже имеет замок Альянса!");
				
				return false;
			end;
		else
			Clockwork.player:Notify(player, "Вы недостаточно близко к двери!");
			
			return false;
		end;
	else
		Clockwork.player:Notify(player, "Дверь не найдена!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();