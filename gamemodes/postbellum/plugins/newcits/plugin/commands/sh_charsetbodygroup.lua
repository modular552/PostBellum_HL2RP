
-----------------------------------------------------
--[[
	© 2016 Source-CDev2 / PostBellum RP
	Something that you will never be.
--]]

local Clockwork = Clockwork

local COMMAND = Clockwork.command:New("CharSetBodygroup")
COMMAND.tip  = "Применить бодигруппу на модель персонажа."
COMMAND.text = "<string Name> <number Bodygroup> <string State>";
COMMAND.access = "a";
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local targetBodyGroups = target:GetCharacterData("BodyGroups") or {}
		local clbg = tonumber(arguments[2])
		local bodyGroupState = tonumber(arguments[3])
		local model = target:GetModel()

		if (clbg < target:GetNumBodyGroups())then
			targetBodyGroups[model] = targetBodyGroups[model] or {}
			targetBodyGroups[model][tostring(clbg)] = bodyGroupState

			target:SetBodygroup(clbg, bodyGroupState)
			target:SetCharacterData("BodyGroups", targetBodyGroups)
			
			Clockwork.player:Notify(player, "Вы изменили бодигруппу "..target:Name().." на "..clbg.." состояние "..bodyGroupState.."!")
			Clockwork.player:Notify(target, player:Name().." изменил вашу бодигруппу "..clbg.." на состояние "..bodyGroupState.."!")
		else
			Clockwork.player:Notify(player, "Модель "..target:Name().." не поддерживает такую бодигруппу!")
		end
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end

COMMAND:Register()