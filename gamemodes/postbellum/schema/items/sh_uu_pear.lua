
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Груша";
ITEM.plural = "Груш";
ITEM.uniqueID = "uu_pear";
ITEM.model = "models/bioshockinfinite/hext_pear.mdl";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.thirst = 4;
ITEM.hunger = 8;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.weight = 0.2;
ITEM.access = "v";
ITEM.useText = "Съесть";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Спелая груша, можно скушать.";
ITEM.vomit = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 3, 0, player:GetMaxHealth()) );
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, 2, 120);
	player:BoostAttribute(self.name, ATB_AGILITY, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();