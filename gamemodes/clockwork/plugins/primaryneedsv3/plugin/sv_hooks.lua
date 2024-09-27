local PLUGIN = PLUGIN;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	if ( !data["hunger"] ) then
		data["hunger"] = 100;
	end;
	if ( !data["thirst"] ) then
		data["thirst"] = 100;
	end;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar( "hunger", math.Round( player:GetCharacterData("hunger") ) );
	player:SetSharedVar( "thirst", math.Round( player:GetCharacterData("thirst") ) );
	local position = player:GetPos();
	
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		if (player:GetCharacterData("thirst") == 0) then
			player:BoostAttribute("Thirst", ATB_ACROBATICS, -50);
			player:BoostAttribute("Thirst", ATB_ENDURANCE, -50);
			player:BoostAttribute("Thirst", ATB_STRENGTH, -50);
			player:BoostAttribute("Thirst", ATB_AGILITY, -50);
			player:BoostAttribute("Thirst", ATB_DEXTERITY, -50);
			player:BoostAttribute("Thirst", ATB_MEDICAL, -50);
		else
			player:BoostAttribute("Thirst", ATB_ACROBATICS, false);
			player:BoostAttribute("Thirst", ATB_ENDURANCE, false);
			player:BoostAttribute("Thirst", ATB_STRENGTH, false);
			player:BoostAttribute("Thirst", ATB_AGILITY, false);
			player:BoostAttribute("Thirst", ATB_DEXTERITY, false);
			player:BoostAttribute("Thirst", ATB_MEDICAL, false);
		end;
	end;
	if (player:Alive() and !player:IsRagdolled() and player:GetVelocity():Length() > 0) then
		if (tonumber(player:GetCharacterData("hunger")) >= 30) then
			player:BoostAttribute("Hunger", ATB_ACROBATICS, -10);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, -10);
			player:BoostAttribute("Hunger", ATB_STRENGTH, -10);
			player:BoostAttribute("Hunger", ATB_AGILITY, -10);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, -10);
			player:BoostAttribute("Hunger", ATB_MEDICAL, -10);
		elseif (tonumber(player:GetCharacterData("hunger")) >= 20) then
			player:BoostAttribute("Hunger", ATB_ACROBATICS, -25);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, -25);
			player:BoostAttribute("Hunger", ATB_STRENGTH, -25);
			player:BoostAttribute("Hunger", ATB_AGILITY, -25);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, -25);
			player:BoostAttribute("Hunger", ATB_MEDICAL, -25);
		elseif (tonumber(player:GetCharacterData("hunger")) >= 10) then
			player:BoostAttribute("Hunger", ATB_ACROBATICS, -30);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, -30);
			player:BoostAttribute("Hunger", ATB_STRENGTH, -30);
			player:BoostAttribute("Hunger", ATB_AGILITY, -30);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, -30);
			player:BoostAttribute("Hunger", ATB_MEDICAL, -30);
		else
			player:BoostAttribute("Hunger", ATB_ACROBATICS, false);
			player:BoostAttribute("Hunger", ATB_ENDURANCE, false);
			player:BoostAttribute("Hunger", ATB_STRENGTH, false);
			player:BoostAttribute("Hunger", ATB_AGILITY, false);
			player:BoostAttribute("Hunger", ATB_DEXTERITY, false);
			player:BoostAttribute("Hunger", ATB_MEDICAL, false);
		end;
	end;
end;

-- Called at an interval while a player is connected.
function PLUGIN:PlayerThink(player, curTime, infoTable)
	local alive = player:Alive();
	local faction = player:GetFaction();
	local curTime = CurTime();
	
	if ( player:Alive() and !faction == FACTION_OTA ) then
		if (!player.nextHunger or curTime >= player.nextHunger) then
			if (tonumber(player:GetCharacterData("hunger")) != -1) then
				player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") - 1, 0, 100) );
				player.nextHunger = curTime + 206;
				if player:GetCharacterData("hunger") == 81 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You could go for a snack.");
				elseif player:GetCharacterData("hunger") == 71 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You begin to feel hungry.");
				elseif player:GetCharacterData("hunger") == 51 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You begin to feel very hungry.");
				elseif player:GetCharacterData("hunger") == 31 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You are starving, and feel faint.");
				end;
			end;
		end;
		if (!player.nextThirst or curTime >= player.nextThirst) then
			if (tonumber(player:GetCharacterData("thirst")) != -1) then
				player:SetCharacterData( "thirst", math.Clamp(player:GetCharacterData("thirst") - 1, 0, 100) );
				player.nextThirst = curTime + 103;
				if player:GetCharacterData("thirst") == 81 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You could go for a small drink.");
				elseif player:GetCharacterData("thirst") == 71 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You begin to feel thirsty.");
				elseif player:GetCharacterData("thirst") == 51 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You begin to feel very thirsty.");
				elseif player:GetCharacterData("thirst") == 31 then
					Clockwork.chatBox:Add(player, nil, "sleep", "** You are dehydrated, and feel faint.");
				end;
			end;
		end;
	end;
end;

function PLUGIN:PlayerShouldStaminaRegenerate(player)
	local faction = player:GetFaction();
	if ( tonumber(player:GetCharacterData("hunger")) <= 35 ) then
		return false;
	end;
end;

-- Called when a player uses an item.
function PLUGIN:PlayerUseItem(player, itemTable, itemEntity)
	if itemTable.hunger then
		player:SetCharacterData( "hunger", math.Clamp(player:GetCharacterData("hunger") + itemTable.hunger, 0, 100) );
	end;
	
	if itemTable.thirst then
		player:SetCharacterData( "thirst", math.Clamp(player:GetCharacterData("thirst") + itemTable.thirst, 0, 100) );
	end;
end;