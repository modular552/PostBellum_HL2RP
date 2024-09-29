
-----------------------------------------------------
--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("CharSetGender");
COMMAND.tip = "Сменить пол персонажа.";
COMMAND.text = "<string Name> <string Gender>";
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local gender = string.lower(arguments[2])
	
	if (gender == "f" or gender == "female" or gender == "fem") then
		gender = "Female";
	elseif (gender == "m" or gender == "male") then
		gender = "Male";
	else
		Clockwork.player:Notify(player, "Вы должны указать Female или Male!");
		
		return;
	end;
	
	for k, v in pairs(cwPlayer.GetAll()) do
		if (v:HasInitialized()) then
			if (v:Name() == arguments[1]) then
				Clockwork.player:NotifyAll(player:Name().." сменил пол '"..arguments[1].."' на "..gender..".");
				
				v:SetCharacterData("Gender", gender, true);
				v:SetSharedVar("Gender", 1);
				v:SaveCharacter();
				
				return;
			else
				for k2, v2 in pairs(v:GetCharacters()) do
					if (v2.name == arguments[1]) then
						Clockwork.player:NotifyAll(player:Name().." сменил пол '"..arguments[1].."' на "..gender..".");
						
						v2.gender = gender;
						
						return;
					end;
				end;
			end;
		end;
	end;
	
	local charactersTable = Clockwork.config:Get("mysql_characters_table"):Get();
	local charName = arguments[1];
	
	local queryObj = Clockwork.database:Select(charactersTable);
		queryObj:SetCallback(function(result)
			if (Clockwork.database:IsResult(result)) then
				local queryObj = Clockwork.database:Update(charactersTable);
					queryObj:SetValue("_Gender", gender);
					queryObj:AddWhere("_Name = ?", charName);
				queryObj:Push();
				
				Clockwork.player:NotifyAll(player:Name().." сменил пол '"..arguments[1].."' на "..gender..".");
			else
				Clockwork.player:Notify(player, "This is not a valid character!");
			end;
		end);
		queryObj:AddWhere("_Name = ?", charName);
	queryObj:Pull();
end;

COMMAND:Register();
