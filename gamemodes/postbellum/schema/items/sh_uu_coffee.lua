
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Баночка с кофе";
ITEM.plural = "Баночек с кофе";
ITEM.uniqueID = "uu_coffee";
ITEM.model = "models/bioshockinfinite/xoffee_mug_closed.mdl";
ITEM.weight = 0.5;
ITEM.access = "v";
ITEM.category = "Продукты";
ITEM.business = true;
ITEM.description = "Банка с быстрорастворимым кофе.";

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();