
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Кружка чая";
ITEM.plural = "Кружек чая";
ITEM.uniqueID = "uu_tea_cup";
ITEM.thirst = 35;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.weight = 0.5;
ITEM.useText = "Выпить";
ITEM.business = true;
ITEM.category = "Продукты";
ITEM.description = "Кружка с горячем чаем.";
ITEM.vomit = 10;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth(math.Clamp(player:Health() + 4, 0, player:GetMaxHealth()));
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, 3, 120);
	player:BoostAttribute(self.name, ATB_ENDURANCE, 3, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, 3, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();