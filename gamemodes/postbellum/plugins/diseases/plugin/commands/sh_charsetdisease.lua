--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

COMMAND = Clockwork.command:New("CharSetDisease");
COMMAND.tip = "Set a players disease.";
COMMAND.text = "<string Name> <String Disease>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] );
	local disease = arguments[2];
	
	if (target) then
		if ( player != target )	then
			Clockwork.player:Notify(target, player:Name().." has set your disease to "..disease..".");
			Clockwork.player:Notify(player, "You have set "..target:Name().."'s disease to "..disease..".");
		else
			Clockwork.player:Notify(player, "You have set your own disease to "..disease..".");
		end;
		target:SetCharacterData("diseases", disease);
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

COMMAND:Register()