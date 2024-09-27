
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CpInfo");
COMMAND.tip = "Запрос информации о гражданине.";
COMMAND.text = "<string CID>";
COMMAND.flags = bit.bor(CMD_DEFAULT, CMD_DEATHCODE, CMD_FALLENOVER);
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetFaction() == FACTION_MPF or player:GetFaction() == FACTION_INCOG) then
		local stringCID = arguments[1];
		
		for k,v in pairs(_player.GetAll()) do
			if (v:IsPlayer() and v:Alive()) then
				if (v:IsCitizen() and v:GetCharacterData("citizenid") == stringCID) then
					for k, v in pairs(_player.GetAll()) do
						if (Schema:PlayerIsCombine(v) and v:Alive()) then
							v:EmitSound("npc/combine_soldier/vo/on2.wav");
							Clockwork.chatBox:SendColored(v, Color(75, 150, 50), player:GetName().." передает ''<:: Запрашиваю информацию о гражданине #"..stringCID..". ::>''");
						end;
					end;
					
					for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get())) do
						if (IsValid(v) and v:IsPlayer()) then
							if (!Schema:PlayerIsCombine(v) and v:Alive()) then
								Clockwork.chatBox:SendColored(v, Color(255, 255, 175), player:GetName().." передает ''<:: Запрашиваю информацию о гражданине #"..stringCID..". ::>''");
							end;
						end;
					end;
					
					-- local civ_citizenid = v:GetCharacterData("citizenid");
					-- local civ_lid = v:GetCharacterData("civ_lid");
					-- local civ_job = v:GetCharacterData("civ_job");
					local civ_reputation = v:GetCharacterData("civ_reputation");
					local civ_blackmarks = v:GetCharacterData("civ_blackmarks");
					local civ_verdict = v:GetCharacterData("civ_verdict");
					local civ_jail_time = math.Round(v:GetCharacterData("civ_jail_time")/60)
					
					timer.Simple(2, function()
						player:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav");
						Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Запрос информации о гражданине #"..stringCID.." подтвержден. ::>''");
						Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Имя: "..v:GetName()..". ::>''");
						-- Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: CID: "..civ_citizenid..". ::>''");
						-- Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Апартаменты: "..civ_lid..". ::>''");
						--Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Job: "..civ_job..". ::>''");
						Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Очки лояльности: "..civ_reputation..". ::>''");
						Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Очки нарушения: "..civ_blackmarks..". ::>''");
						
						if (v:GetCharacterData("civ_jail_type") == "NULL") then
							Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Статус: "..civ_verdict..". ::>''");
						else
							Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Статус: ЗАКЛЮЧЕННЫЙ. ::>''");
							Clockwork.chatBox:SendColored(player, Color(75, 150, 50), "Центр: ''<:: Осталось времени: "..civ_jail_time..". ::>''");
						end
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