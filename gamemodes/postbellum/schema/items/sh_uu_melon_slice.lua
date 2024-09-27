
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Арбузная долька";
ITEM.plural = "Арбузных долек";
ITEM.uniqueID = "uu_melon_slice";
ITEM.model = "models/props_junk/watermelon01_chunk01b.mdl";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 2;
ITEM.thirst = 6;
ITEM.hunger = 6;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.useText = "Съесть";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Долька красного арбуза. Виднеются большие семечки.";
ITEM.vomit = 5;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp(player:Health() + 2, 0, player:GetMaxHealth()) );
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, 2, 120);
	player:BoostAttribute(self.name, ATB_AGILITY, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();