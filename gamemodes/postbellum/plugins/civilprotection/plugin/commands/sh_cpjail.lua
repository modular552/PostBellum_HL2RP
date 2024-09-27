
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CpJail");
COMMAND.tip = "Запрос на изоляцию нарушителя.";
COMMAND.text = "<string CID> <number Time(min)> <string Reason>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 3;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetFaction() == FACTION_MPF or player:GetFaction() == FACTION_INCOG) then
		local stringCID = arguments[1];
		local numberTIME = tonumber(arguments[2]);
		local stringREASON = table.concat(arguments, " ", 3);
		
		if (!numberTIME or numberTIME < 1) then
			Clockwork.player:Notify(player, "Неверно указано время!");
			
			return
		end
		
		for k, v in pairs(_player.GetAll()) do
			if (v:IsPlayer() and v:Alive()) then
				if (v:IsCitizen() and v:GetCharacterData("citizenid") == stringCID) then
					for k, v in pairs(_player.GetAll()) do
						if (Schema:PlayerIsCombine(v) and v:Alive()) then
							v:EmitSound("npc/combine_soldier/vo/on2.wav");
							Clockwork.chatBox:SendColored(v, Color(75, 150, 50), player:GetName().." передает ''<:: Запрос на изоляцию нарушителя #"..stringCID..", причина: "..stringREASON..", время изоляции: "..numberTIME.." минут. ::>''");
						end;
					end;
					
					for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get())) do
						if (IsValid(v) and v:IsPlayer()) then
							if (!Schema:PlayerIsCombine(v) and v:Alive()) then
								Clockwork.chatBox:SendColored(v, Color(255, 255, 175), player:GetName().." передает ''<:: Запрос на изоляцию нарушителя #"..stringCID..", причина: "..stringREASON..", время изоляции: "..numberTIME.." минут. ::>''");
							end;
						end;
					end;
					
					local realtime = v:GetCharacterData("civ_jail_time") + numberTIME*60
					local realmin = math.Round(realtime/60)
					
					v:SetCharacterData("civ_jail_time", realtime);
					
					timer.Simple(2, function()
						if (v:GetCharacterData("civ_jail_type") == "NULL") then
							v:SetCharacterData("civ_jail_type", stringREASON);
							
							for k, v in pairs(_player.GetAll()) do
								if (Schema:PlayerIsCombine(v) and v:Alive()) then
									v:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav");
									Clockwork.chatBox:SendColored(v, Color(75, 150, 50), "Центр: ''<:: Запрос на изоляцию нарушителя #"..stringCID.." подтвержден. ::>''");
								end;
							end;
						else
							for k, v in pairs(_player.GetAll()) do
								if (Schema:PlayerIsCombine(v) and v:Alive()) then
									v:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav");
									Clockwork.chatBox:SendColored(v, Color(75, 150, 50), "Центр: ''<:: Нарушитель уже был изолирован. Время изоляции заключенного #"..stringCID.." обновлено, осталось "..realmin.." минут. ::>''");
								end;
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