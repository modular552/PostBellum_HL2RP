
-----------------------------------------------------
--[[
	This script has been purchased for "Blt950's HL2RP & Clockwork plugins" from CoderHire.com
	© 2014 Blt950 do not share, re-distribute or modify
	without permission.
--]]

local PLUGIN = PLUGIN;

-- Called when the local player's motion blurs should be adjusted.
function PLUGIN:PlayerAdjustMotionBlurs(motionBlurs)
	if ( Clockwork.Client:HasInitialized() ) then
		local disease = Clockwork.Client:GetSharedVar("diseases");
		
		if (disease == "fever") then
			motionBlurs.blurTable["fever"] = 0.3;
		end;
		if (disease == "colorblindness") then
			DrawTexturize( 1, Material( "pp/texturize/plain.png" ) )
		end
		if (disease == "slow_deathinjection" or disease == "fast_deathinjection") then
			motionBlurs.blurTable["injection"] = 0.1;
		end;
	end;
end;