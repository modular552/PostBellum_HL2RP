
-----------------------------------------------------
--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;

local COMMAND = Clockwork.command:New("Roll");
COMMAND.tip = "Roll a number between 0 and the specified number.";

-- Called when the command has been run.	
function COMMAND:OnRun(player, arguments)
	local faction = player:GetFaction()
	local value = math.random(0, 100);
	local boost = 0;
	
	if (Schema:PlayerIsCombine(player)) then
		if (faction == FACTION_OTA) then
			if (Schema:IsPlayerCombineRank(player, "OWS")) then
				boost = 25;
			elseif (Schema:IsPlayerCombineRank(player, "EOW")) then
				boost = 30;
			else
				boost = 20;
			end;
		elseif (Schema:IsPlayerCombineRank(player, "RCT")) then
			boost = 5;
		elseif (Schema:IsPlayerCombineRank(player, "05")) then
			boost = 6;
		elseif (Schema:IsPlayerCombineRank(player, "04")) then
			boost = 10;
		elseif (Schema:IsPlayerCombineRank(player, "03")) then
			boost = 14;
		elseif (Schema:IsPlayerCombineRank(player, "02")) then
			boost = 18;
		elseif (Schema:IsPlayerCombineRank(player, "01")) then
			boost = 22;
		elseif (Schema:IsPlayerCombineRank(player, "GHOST")) then
			boost = 24;
		elseif (Schema:IsPlayerCombineRank(player, "BG")) then
			boost = 25;
		elseif (Schema:IsPlayerCombineRank(player, "OfC")) then
			boost = 26;
		elseif (Schema:IsPlayerCombineRank(player, "EpU")) then
			boost = 29;
		elseif (Schema:IsPlayerCombineRank(player, "CmR")) then
			boost = 32;
		elseif (Schema:IsPlayerCombineRank(player, "DvL")) then
			boost = 35;
		elseif (Schema:IsPlayerCombineRank(player, "SeC")) then
			boost = 38;
		elseif (faction == FACTION_INCOG) then
			boost = 30;
		--elseif (self:IsPlayerCombineRank(player, "SCN")) then
		--	if (!self:IsPlayerCombineRank(player, "SYNTH")) then
		--		boost = ;
		--	else
		--		boost = ;
		--	end;
		--else
		--	boost = ;
		end;
	elseif (faction == FACTION_GOO or faction == FACTION_CWU or faction == FACTION_CWUMEDIC) then
		boost = 4;
	elseif (faction == FACTION_REFUGEE or faction == FACTION_VORTSLAVE or faction == FACTION_RAIDER) then
		boost = 5;
	elseif (faction == FACTION_CWUBOSS) then
		boost = 10;
	elseif (faction == FACTION_REBEL or faction == FACTION_REBELMEDIC or faction == FACTION_SYNDICATE) then
		boost = 15;
	elseif (faction == FACTION_VORT) then
		boost = 20;
	elseif (faction == FACTION_REBELBOSS) then
		boost = 25;
	end;
	
	if (boost != 0) then
		Clockwork.chatBox:AddInRadius(player, "roll", "получил шанс "..value..". Прибавка фракции "..boost..". Итог: "..math.Clamp(value + boost, 0, 100).." из 100.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	else
		Clockwork.chatBox:AddInRadius(player, "roll", "получил шанс "..value.." из 100.", player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
	end;
end;

COMMAND:Register();