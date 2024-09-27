local PLUGIN = PLUGIN;

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	for k, v in pairs( ents.FindByModel( "models/props_interiors/vendingmachinesoda01a.mdl" ) ) do
		print("SAH DUE")
		--  Grab POS and ANGLES of props.
		local vpos = v:GetPos()
		local vangles = v:GetAngles()
		v:Remove();
		-- Create the new nutvendor.
		local entity = ents.Create("nut_vend");
		entity:SetPos(vpos);
		entity:SetAngles(vangles);
		entity:Spawn();
		entity:Activate();
		entity:SetDTBool(0, true);
		--entity:SetSharedVar("stocks", v.stocks);
		entity:SetDTFloat(1, 9999);
		entity:SetDTFloat(2, 9999);
		entity:SetDTFloat(3, 9999);
		entity:SetDTFloat(4, 9999)
	end;
end;