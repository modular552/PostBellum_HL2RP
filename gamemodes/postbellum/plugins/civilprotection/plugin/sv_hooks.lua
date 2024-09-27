local PLUGIN = PLUGIN;

Clockwork.player:AddCharacterData("cp_blackmarks", NWTYPE_NUMBER, 0, true)
Clockwork.player:AddCharacterData("civ_jail_type", NWTYPE_STRING, "NULL", true)
Clockwork.player:AddCharacterData("civ_jail_time", NWTYPE_NUMBER, 0, true)
Clockwork.player:AddCharacterData("civ_reputation", NWTYPE_NUMBER, 0, true)
Clockwork.player:AddCharacterData("civ_blackmarks", NWTYPE_NUMBER, 0, true)
Clockwork.player:AddCharacterData("civ_verdict", NWTYPE_STRING, "CITIZEN", true)

function PLUGIN:PlayerCharacterCreated(player, character)
	if character.faction == FACTION_MPF then
		character.data["cp_traitor"] = 0
	end
	character.data["civ_jail_type"] = "NULL"
	character.data["civ_jail_time"] = 0
	character.data["civ_reputation"] = 0
	character.data["civ_blackmarks"] = 0
	character.data["civ_verdict"] = "CITIZEN"
end