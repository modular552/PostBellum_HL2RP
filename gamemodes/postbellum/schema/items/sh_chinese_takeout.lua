
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Лапша";
ITEM.plural = "Лапши";
ITEM.uniqueID = "chinese_takeout";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.hunger = 30;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.model = "models/props_junk/garbage_takeoutcarton001a.mdl";
ITEM.weight = 0.8;
ITEM.access = "v";
ITEM.useText = "Съесть";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Картонная коробочка с холодной лапшой.";
ITEM.vomit = 15;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 5, 0, player:GetMaxHealth()) );
	
	player:BoostAttribute(self.name, ATB_ENDURANCE, 2, 120);
	player:BoostAttribute(self.name, ATB_ACCURACY, 1, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();