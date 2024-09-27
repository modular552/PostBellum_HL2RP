
-----------------------------------------------------
--[[
	© 2016 Source-CDev2 / PostBellum RP
	Something that you will never be.
--]]

local Clockwork = Clockwork

local COMMAND = Clockwork.command:New("CharSetSkin")
COMMAND.tip  = "Применить скин на модель персонажа."
COMMAND.text = "<string Name> <number Skin>";
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	
	if (target) then
		local targetSkin = target:GetCharacterData("Skin") or {}
		local clsk = tonumber(arguments[2])
		local model = target:GetModel()

		if (clsk < target:SkinCount())then
			targetSkin[model] = clsk

			target:SetSkin(clsk)
			target:SetCharacterData("Skin", targetSkin)
			
			Clockwork.player:Notify(player, "Вы изменили скин "..target:Name().." на "..clsk.."!")
			Clockwork.player:Notify(target, player:Name().." изменил ваш скин на "..clsk.."!")
		else
			Clockwork.player:Notify(player, "Модель "..target:Name().." не поддерживает такой скин!")
		end
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end

COMMAND:Register()