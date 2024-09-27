
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local FACTION = Clockwork.faction:New("Гражданская Оборона");

FACTION.whitelist = true;
FACTION.maximumAttributePoints = 45;
FACTION.material = "cdev2_pb/factions/mpf";
FACTION.models = {
	female = {
		"models/hl2rp/metropolice/hl2_femalecp1.mdl",
		"models/hl2rp/metropolice/hl2_femalecp2.mdl",
		"models/hl2rp/metropolice/hl2_femalecp3.mdl",
		"models/hl2rp/metropolice/hl2_femalecp4.mdl",
		"models/hl2rp/metropolice/hl2_femalecp5.mdl",
		"models/hl2rp/metropolice/hl2_femalecp6.mdl"
	},
	male = {
		"models/hl2rp/metropolice/hl2_malecp1.mdl",
		"models/hl2rp/metropolice/hl2_malecp2.mdl",
		"models/hl2rp/metropolice/hl2_malecp3.mdl",
		"models/hl2rp/metropolice/hl2_malecp4.mdl",
		"models/hl2rp/metropolice/hl2_malecp5.mdl",
		"models/hl2rp/metropolice/hl2_malecp6.mdl",
		"models/hl2rp/metropolice/hl2_malecp7.mdl",
		"models/hl2rp/metropolice/hl2_malecp8.mdl",
		"models/hl2rp/metropolice/hl2_malecp9.mdl",
		"models/hl2rp/metropolice/hl2_malecp10.mdl",
		"models/hl2rp/metropolice/hl2_malecp11.mdl",
		"models/hl2rp/metropolice/hl2_malecp12.mdl"
	};
};

-- Called when a player's name should be assigned for the faction.
function FACTION:GetName(player, character)
	return "C17.MPF.GU.RCT:"..Clockwork.kernel:ZeroNumberToDigits(math.random(1, 999), 3);
end;

-- Called when a player is transferred to the faction.
function FACTION:OnTransferred(player, faction, name)
	if (faction.name == FACTION_OTA) then
		Clockwork.player:SetName(player, string.gsub(player:QueryCharacter("name"), ".+(%d%d%d%d%d)", "C17.MPF.GU.RCT:%1"), true);
	else
		Clockwork.player:SetName(player, self:GetName(player, player:GetCharacter()), true);
	end;
	
	local models = self.models[ string.lower( player:QueryCharacter("gender") ) ];
	
	if (models) then
		player:SetCharacterData("Model", models[ math.random(#models) ], true);
	end;
end;

FACTION_MPF = FACTION:Register();