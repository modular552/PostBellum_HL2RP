
-----------------------------------------------------
local FACTION = Clockwork.faction:New("Секретный агент");
local PLUGIN = PLUGIN;
FACTION.useFullName = false;
FACTION.maximumAttributePoints = 700;
FACTION.whitelist = true;
FACTION.material = "cdev2_pb/factions/citizen";

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (Schema:PlayerIsCombine(player)) then
		if (name) then
			local models = self.models[ string.lower( player:QueryCharacter("gender") ) ];
			
			if (models) then
				player:SetCharacterData("Model", models[ math.random(#models) ], true);
				
				Clockwork.player:SetName(player, name, true);
			end;
		else
			return false, "Вы должны указать имя в качестве третьего аргумента!";
		end;
	end;
end;

-- Called when a player's scoreboard class is needed.
function PLUGIN:GetPlayerScoreboardClass(player)
	local faction1 = player:GetFaction();
	local clientfaction = Clockwork.Client:GetFaction();
		if (faction1 == FACTION_INCOG) then
		if (Clockwork.Client:GetFaction() == FACTION_INCOG) then
			return "Секретный агент";
		elseif (Clockwork.Client:IsAdmin()) then
			return "Секретный агент (Скрыто)";
		else
			return false;
		end;
	end;
end;
 
FACTION_INCOG = FACTION:Register();