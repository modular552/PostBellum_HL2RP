
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Бутылка газировки";
ITEM.plural = "Бутылок газировки";
ITEM.uniqueID = "large_soda";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 1;
ITEM.thirst = 70;
ITEM.sleep = 10;
ITEM.useSound = {"npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav"};
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.weight = 1.5;
ITEM.access = "w";
ITEM.useText = "Выпить";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Большая пластиковая бутылка, заполненная пузырящейся жидкостью.";
ITEM.vomit = 20;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 4, 0, player:GetMaxHealth()) );
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, -3, 120);
	player:BoostAttribute(self.name, ATB_ENDURANCE, -3, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, -3, 120);
	
	player:GiveItem(Clockwork.item:CreateInstance("large_soda_empty"), true);
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