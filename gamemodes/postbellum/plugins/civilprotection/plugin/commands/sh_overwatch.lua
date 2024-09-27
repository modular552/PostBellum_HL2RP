
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CpOverwatch");
COMMAND.tip = "Сообщения от центра.";
COMMAND.text = "<string Text>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local text = table.concat(arguments, " ");
	
	if (text != "") then
		for k, v in pairs(cwPlayer.GetAll()) do
			if (Schema:PlayerIsCombine(v) or v:GetFaction() == FACTION_ADMIN) then
				if (v:Alive()) then
					v:EmitSound("npc/combine_soldier/vo/on2.wav");
					Clockwork.chatBox:SendColored(v, Color(75, 150, 50), "Центр: ''<:: "..text.." ::>''");
				end;
			end;
		end;
	end;
end;

COMMAND:Register();