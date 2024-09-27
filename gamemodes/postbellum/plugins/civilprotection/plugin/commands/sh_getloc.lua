
-----------------------------------------------------
--[[
	© Songbird aka Alko -  do not re-distribute without permission of its author (ael9000 gmail.com).
--]]

local COMMAND = Clockwork.command:New("GetLoc");
COMMAND.tip = "Получить геолокацию игрока.";
COMMAND.text = "<string Name>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.access = "o";
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (Schema:PlayerIsCombine(player)) then
		if (target) then
			local location = Schema:PlayerGetLocation(target);
			
			player:EmitSound("npc/overwatch/radiovoice/on3.wav");
			Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Геолокация "..target:Name()..": "..location..". ::>''");
		else
			Clockwork.player:Notify(player, "Игрок не найден!");
		end
	else
		Clockwork.player:Notify(player, "У вас нет доступа к этой команде!");
	end;
end

COMMAND:Register();


