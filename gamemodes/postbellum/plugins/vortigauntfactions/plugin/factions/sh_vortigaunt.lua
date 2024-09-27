
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Вортигонт");

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = "Male";
FACTION.maximumAttributePoints = 60;
FACTION.material = "cdev2_pb/factions/vort";
FACTION.models = {
	female = {"models/vortigaunt.mdl"},
	male = {"models/vortigaunt.mdl"}
};

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_VORTSLAVE) then
		if (player:QueryCharacter("gender") == GENDER_MALE) then
			player:SetCharacterData("Model", self.models.male[1], true);
		else
			player:SetCharacterData("Model", self.models.female[1], true);
		end;
	else
		return false;
	end;
end;

FACTION_VORT = FACTION:Register();