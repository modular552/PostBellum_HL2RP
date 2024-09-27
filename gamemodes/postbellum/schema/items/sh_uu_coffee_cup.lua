
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Кружка кофе";
ITEM.plural = "Кружек кофе";
ITEM.uniqueID = "uu_coffee_cup";
ITEM.thirst = 30;
ITEM.sleep = 20;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.weight = 0.5;
ITEM.useText = "Выпить";
ITEM.business = true;
ITEM.category = "Продукты";
ITEM.description = "Кружка с ароматным кофе.";
ITEM.vomit = 15;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 100);
	player:SetHealth(math.Clamp(player:Health() + 4, 0, player:GetMaxHealth()));
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, -5, 120);
	player:BoostAttribute(self.name, ATB_ENDURANCE, -5, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, -5, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();