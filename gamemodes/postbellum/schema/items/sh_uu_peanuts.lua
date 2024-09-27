
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Мешочек с арахисом";
ITEM.plural = "Мешочков с арахисом";
ITEM.uniqueID = "uu_peanuts";
ITEM.model = "models/bioshockinfinite/rag_of_peanuts.mdl";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 3;
ITEM.hunger = 15;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.useText = "Съесть";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Соленый арахис. К пивку в самый раз.";
ITEM.vomit = 10;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 3, 0, player:GetMaxHealth()) );
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, 2, 120);
	player:BoostAttribute(self.name, ATB_AGILITY, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();