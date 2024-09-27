
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New();
ITEM.name = "Пищевые добавки сотрудников ГО";
ITEM.plural = "Пищевых добавок сотрудников ГО";
ITEM.uniqueID = "metropolice_supplements";
ITEM.hunger = 70;
ITEM.thirst = 20;
ITEM.useSound = {"npc/barnacle/barnacle_crunch3.wav", "npc/barnacle/barnacle_crunch2.wav"};
ITEM.model = "models/props_lab/jar01a.mdl";
ITEM.weight = 0.6;
ITEM.useText = "Съесть";
ITEM.factions = {FACTION_MPF};
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Пластиковая баночка с ароматной кашей. Очень питательная.";
ITEM.vomit = 20;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetHealth( math.Clamp( player:Health() + 10, 0, player:GetMaxHealth()) );
	player:BoostAttribute(self.name, ATB_ENDURANCE, 2, 120);
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();