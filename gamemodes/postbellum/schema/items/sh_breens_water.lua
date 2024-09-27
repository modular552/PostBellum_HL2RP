
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New("alcohol_base");
ITEM.name = "Вода";
ITEM.plural = "Воды";
ITEM.uniqueID = "breens_water";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 4;
ITEM.thirst = 20;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/popcan01a.mdl";
ITEM.weight = 0.5;
ITEM.access = "1";
ITEM.useText = "Выпить";
ITEM.business = true;
ITEM.category = "Продукты";
ITEM.attributes = {Stamina = 2};
ITEM.description = "Голубая алюминиевая баночка с водой сомнительного качества.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 2, 0, player:GetMaxHealth()));
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, -1, 120);
	player:BoostAttribute(self.name, ATB_ENDURANCE, -1, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, -1, 120);
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