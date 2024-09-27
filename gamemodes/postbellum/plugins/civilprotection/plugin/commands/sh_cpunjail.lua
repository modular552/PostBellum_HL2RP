
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local COMMAND = Clockwork.command:New("CpUnJail");
COMMAND.tip = "Рапорт на освобождение заключенного.";
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
					local stringCID = arguments[1];

					for k, v in pairs(_player.GetAll()) do
						if (Schema:PlayerIsCombine(v) and v:Alive()) then
							v:EmitSound("npc/combine_soldier/vo/on2.wav");
							Clockwork.chatBox:SendColored(v, Color(75, 150, 50), player:GetName().." передает ''<:: Рапорт об освобождении заключенного #"..stringCID..". ::>''");
						end;
					end;
					
					for k, v in pairs(ents.FindInSphere(player:GetPos(), Clockwork.config:Get("talk_radius"):Get())) do
						if (IsValid(v) and v:IsPlayer()) then
							if (!Schema:PlayerIsCombine(v) and v:Alive()) then
								Clockwork.chatBox:SendColored(v, Color(255, 255, 175), player:GetName().." передает ''<:: Рапорт об освобождении заключенного #"..stringCID..". ::>''");
							end;
						end;
					end;
					
					if (v:GetCharacterData("civ_jail_type") != "NULL") then
						v:SetCharacterData("civ_jail_type", "NULL");
						v:SetCharacterData("civ_jail_time", 0);

						timer.Simple(2, function()
							for k, v in pairs(_player.GetAll()) do
								if (Schema:PlayerIsCombine(v) and v:Alive()) then
									v:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav");
									Clockwork.chatBox:SendColored(v, Color(75, 150, 50), "Центр: ''<:: Рапорт об освобождении заключенного #"..stringCID.." подтвержден. ::>''");
								end;
							end;
						end);
					elseif (v:GetCharacterData("civ_jail_type") == "NULL") then
						timer.Simple(2, function()
							for k, v in pairs(_player.GetAll()) do
								if (Schema:PlayerIsCombine(v) and v:Alive()) then
									v:EmitSound("npc/combine_soldier/vo/off"..math.random(1, 2)..".wav");
									Clockwork.chatBox:SendColored(v, Color(75, 150, 50), "Центр: ''<:: Отказано. Гражданин #"..stringCID.." не в изоляции. ::>''");
								end;
							end;
						end);
					end;
					
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