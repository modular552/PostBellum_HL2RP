--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_trainstation/trashcan_indoor001a.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:Touch( ent )
	if (ent:GetClass() == "cw_item" and (ent:GetModel() == "models/props_c17/paper01.mdl" or ent:GetModel() == "models/props_office/notepad_office.mdl")) or (ent:GetClass() == "cw_paper" or ent:GetClass() == "cw_notepad") then
		ent:Remove()
	end
end


-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;