
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Раб вортигонт");

FACTION.useFullName = true;
FACTION.whitelist = true;
FACTION.singleGender = "Male";
FACTION.material = "cdev2_pb/factions/vortslave";
FACTION.models = {
	female = {"models/vortigaunt_slave.mdl"},
	male = {"models/vortigaunt_slave.mdl"}
};

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_VORT) then
		if (player:QueryCharacter("gender") == GENDER_MALE) then
			player:SetCharacterData("Model", self.models.male[1], true);
		else
			player:SetCharacterData("Model", self.models.female[1], true);
		end;
	else
		return false;
	end;
end;

FACTION_VORTSLAVE = FACTION:Register();