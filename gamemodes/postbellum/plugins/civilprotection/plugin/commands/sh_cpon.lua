
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CpON");
COMMAND.tip = "Запрос на зачисление ОН.";
COMMAND.text = "<string CID> <number Amount> <string Reason>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetFaction() == FACTION_MPF or player:GetFaction() == FACTION_INCOG) then
		local stringCID = arguments[1];
		local numberAMOUNT = tonumber(arguments[2]);
		local stringREASON = table.concat(arguments, " ", 3);
		
		if (!numberAMOUNT) then
			Clockwork.player:Notify(player, "Неверно указано количество!");
			
			return
		end
		
		for k, v in pairs(_player.GetAll()) do
			if (v:IsPlayer() and v:Alive()) then
				if (v:IsCitizen() and v:GetCharacterData("citizenid") == stringCID) then
					for k, v in pairs(_player.GetAll()) do
						if (Schema:PlayerIsCombine(v) and v:Alive()) then
							v:EmitSound("npc/combine_soldier/vo/on2.wav");
							Clockwork.chatBox:SendColored(v, Color(75, 150, 50), player:GetName().." передает ''<:: Центр, зачислите очки нарушения гражданину #"..stringCID..", причина: "..stringREASON..", количество очков: "..numberAMOUNT..". ::>''");
						end;
					end;

					for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get())) do
						if (IsValid(v) and v:IsPlayer()) then
							if (!Schema:PlayerIsCombine(v) and v:Alive()) then
								Clockwork.chatBox:SendColored(v, Color(255, 255, 175), player:GetName().." передает ''<:: Центр, зачислите очки нарушения гражданину #"..stringCID..", причина: "..stringREASON..", количество очков: "..numberAMOUNT..". ::>''");
							end;
						end;
					end;

					-- if (v:GetCharacterData("civ_blackmarks") < 45) then
						local points = math.Clamp(v:GetCharacterData("civ_blackmarks") + numberAMOUNT, 0, 45)
						local goodpoints = v:GetCharacterData("civ_reputation")
						local realpoints = goodpoints - points
						
						v:SetCharacterData("civ_blackmarks", points);
						
						if (points == 45) then
							v:SetCharacterData("civ_verdict", "ANTI-CITIZEN");
							
							Clockwork.chatBox:SendColored(nil, Color(150, 100, 100), "Диспетчер сообщает \"".."Гражданин #"..v:GetCharacterData("citizenid").." - "..v:GetName()..", вы обвиняетесь в тяжком несоответствии. Асоциальный статус подтвержден.".."\"");
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
							
							v:SendLua("LocalPlayer():EmitSound('"..musics[math.random(1, #musics)].."')");
						elseif (realpoints == 100) then
							v:SetCharacterData("civ_verdict", "LOYALIST 5");
						elseif (realpoints >= 60) then
							v:SetCharacterData("civ_verdict", "LOYALIST 4");
						elseif (realpoints >= 30) then
							v:SetCharacterData("civ_verdict", "LOYALIST 3");
						elseif (realpoints >= 10) then
							v:SetCharacterData("civ_verdict", "LOYALIST 2");
						elseif (realpoints > 0) then
							v:SetCharacterData("civ_verdict", "LOYALIST 1");
						else
							v:SetCharacterData("civ_verdict", "CITIZEN");
						end;
					-- end;

					local newBMD = v:GetCharacterData("civ_blackmarks");
					timer.Simple(2, function()
						for k, v in pairs(_player.GetAll()) do
							if (Schema:PlayerIsCombine(v) and v:Alive()) then
								v:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav");
								Clockwork.chatBox:SendColored(v, Color(75, 150, 50), "Центр: ''<:: Очки нарушения гражданину #"..stringCID.." начислены. Гражданин получил "..numberAMOUNT.." очков нарушения, общее количество "..newBMD.."/45. ::>''");
							end;
						end;
					end);
					
					return
				end;
			end;
		end;
		
		Clockwork.player:Notify(player, "Игрок не найден!");
	else
		Clockwork.player:Notify(player, "Вы не сотрудник ГО!");
	end;
end;

COMMAND:Register();