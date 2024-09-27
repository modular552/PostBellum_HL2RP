
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Пищевые добавки";
ITEM.plural = "Пищевых добавок";
ITEM.uniqueID = "citizen_supplements";
ITEM.spawnType = "consumable";
ITEM.spawnValue = 1;
ITEM.hunger = 40;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.model = "models/props_lab/jar01a.mdl";
ITEM.weight = 0.6;
ITEM.useText = "Съесть";
ITEM.category = "Продукты";
ITEM.description = "Пластиковая баночка с серой вязкой массой. Какое-то дерьмо.";
ITEM.vomit = 20;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 3, 0, player:GetMaxHealth()) );
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();