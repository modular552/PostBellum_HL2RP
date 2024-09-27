
-----------------------------------------------------
--[[
	© Songbird aka Alko -  do not re-distribute without permission of its author (ael9000 gmail.com).
--]]

local COMMAND = Clockwork.command:New("CpRefugee");
COMMAND.tip = "Начислить 45 ОН игроку.";
COMMAND.text = "<string Name>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.access = "o";
COMMAND.arguments = 1

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target and target:GetCharacterData("citizenid")) then
		target:SetCharacterData("civ_blackmarks", 45);
		target:SetCharacterData("civ_verdict", "ANTI-CITIZEN");
							
		Clockwork.chatBox:SendColored(nil, Color(150, 100, 100), "Диспетчер сообщает \"".."Гражданин #"..target:GetCharacterData("citizenid").." - "..target:GetName()..", вы обвиняетесь в тяжком несоответствии. Асоциальный статус подтвержден.".."\"");
		BroadcastLua("LocalPlayer():EmitSound('npc/overwatch/cityvoice/f_capitalmalcompliance_spkr.wav')");

		local musics = {
			"music/hl2_song4.mp3",
			"music/hl2_song20_submix0.mp3",
			"music/hl2_song20_submix4.mp3",
			"music/hl2_song14.mp3",
			"music/hl2_song12_long.mp3",
			"music/hl2_song16.mp3",
			"music/hl1_song15.mp3",
			"music/hl1_song10.mp3"
		}
		
		target:SendLua("LocalPlayer():EmitSound('"..musics[math.random(1, #musics)].."')");
		
		Clockwork.player:Notify(player, "Успешно!");
	else
		Clockwork.player:Notify(player, "Игрок не найден!");
	end
end

COMMAND:Register();


