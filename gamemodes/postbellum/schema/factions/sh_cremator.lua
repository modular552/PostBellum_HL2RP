
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Крематор");

FACTION.whitelist = true;
FACTION.singleGender = "Male";
FACTION.maximumAttributePoints = 130;
FACTION.material = "cdev2_pb/factions/cremator";
FACTION.startChatNoise = "npc/overwatch/radiovoice/on3.wav";
FACTION.endChatNoise = "npc/overwatch/radiovoice/off2.wav";
FACTION.models = {
	female = {"models/cdev2_pb/leet_police2.mdl"},
	male = {"models/cdev2_pb/leet_police2.mdl"};
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "C17.SYNTH.CREMATOR:"..Clockwork.kernel:ZeroNumberToDigits(math.random(1, 999), 3);
end;

-- Called when a player's model should be assigned for the faction.
function FACTION:GetModel(player, character)
	if (character.gender == GENDER_MALE) then
		return self.models.male[1];
	else
		return self.models.female[1];
	end;
end;

FACTION_CREMATOR = FACTION:Register();
