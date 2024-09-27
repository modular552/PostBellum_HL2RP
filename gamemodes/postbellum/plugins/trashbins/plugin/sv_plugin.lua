--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local PLUGIN = PLUGIN;

-- A function to load the trashbins.
function PLUGIN:LoadTrashBins()
	local trashbins = Clockwork.kernel:RestoreSchemaData("plugins/trashbins/"..game.GetMap());
	
	for k, v in pairs(trashbins) do
		local entity = ents.Create("cw_trashbin");
		
		entity:SetPos(v.position);
		entity:Spawn();
		
		if ( IsValid(entity) ) then
			entity:SetAngles(v.angles);
		end;
	end;
end;

-- A function to save the trashbins.
function PLUGIN:SaveTrashBins()
	local trashbins = {};
	
	for k, v in pairs(ents.FindByClass("cw_trashbin")) do
		trashbins[#trashbins + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/trashbins/"..game.GetMap(), trashbins);
end;