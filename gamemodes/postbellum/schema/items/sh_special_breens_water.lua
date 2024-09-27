
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Энергетик";
ITEM.plural = "Энергетиков";
ITEM.uniqueID = "special_breens_water";
ITEM.thirst = 40;
ITEM.sleep = 20;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.skin = 2;
ITEM.model = "models/props_junk/popcan01a.mdl";
ITEM.weight = 0.5;
ITEM.useText = "Выпить";
ITEM.business = true;
ITEM.factions = {FACTION_MPF};
ITEM.category = "Продукты";
ITEM.description = "Желтая алюминиевая баночка. Безалкогольный напиток, содержит кофеин.";
ITEM.vomit = 15;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 100);
	player:SetHealth(math.Clamp(player:Health() + 4, 0, player:GetMaxHealth()));
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, -3, 120);
	player:BoostAttribute(self.name, ATB_ENDURANCE, -3, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, -3, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item's functions should be edited.
function ITEM:OnEditFunctions(functions)
	if (Schema:PlayerIsCombine(Clockwork.Client, false)) then
		for k, v in pairs(functions) do
			if (v == "Выпить") then functions[k] = nil; end;
		end;
	end;
end;

ITEM:Register();