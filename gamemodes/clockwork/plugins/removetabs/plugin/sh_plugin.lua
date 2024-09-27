local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when the menu's items should be destroyed.
function PLUGIN:MenuItemsDestroy(items)
	if (CLIENT) then
		items:Destroy("Community");
		items:Destroy("Классы");
		items:Destroy("Магазин");
	end;
end;