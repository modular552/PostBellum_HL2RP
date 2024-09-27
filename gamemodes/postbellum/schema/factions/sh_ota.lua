
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Сверхчеловеческий Отдел");

FACTION.whitelist = true;
FACTION.singleGender = "Male";
FACTION.maximumAttributePoints = 80;
FACTION.material = "cdev2_pb/factions/ota";
FACTION.models = {
	female = {"models/combine_soldier.mdl"},
	male = {"models/combine_soldier.mdl"}
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "C17.OTA.SWORD.OWS:"..Clockwork.kernel:ZeroNumberToDigits(math.random(1, 999), 3);
end;

-- Called when a player's model should be assigned for the faction.
function FACTION:GetModel(player, character)
	if (character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_MPF) then
		Clockwork.player:SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d%d%d)", "C17.OTA.GUARD.OWS:%1"), true);
	else
		Clockwork.player:SetName(player, self:GetName(player, player:GetCharacter()), true);
	end;
	
	if (player:QueryCharacter("gender") == GENDER_MALE) then
		player:SetCharacterData("Model", self.models.male[1], true);
	else
		player:SetCharacterData("Model", self.models.female[1], true);
	end;
end;

FACTION_OTA = FACTION:Register();