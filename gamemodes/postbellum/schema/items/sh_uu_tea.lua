
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Чай в пакетиках";
ITEM.plural = "Чая в пакетиках";
ITEM.uniqueID = "uu_tea";
ITEM.model = "models/probs_misc/tobbcco_box-1.mdl";
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Коробочка с чайными пакетиками.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();