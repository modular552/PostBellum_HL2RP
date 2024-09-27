
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Жаренное мясо Хэдкраба";
ITEM.plural = "Жаренного мяса Хэдкраба";
ITEM.uniqueID = "food_headcrab";
ITEM.thirst = 5;
ITEM.hunger = 50;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.model = "models/Gibs/antlion_gib_medium_1.mdl";
ITEM.weight = 1;
ITEM.access = "v";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "На вкус как курица.";
ITEM.vomit = 15;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 10, 0, player:GetMaxHealth()) );
	
	player:BoostAttribute(self.name, ATB_ENDURANCE, 2, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();