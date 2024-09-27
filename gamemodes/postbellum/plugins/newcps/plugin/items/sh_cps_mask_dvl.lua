
-----------------------------------------------------
local ITEM = Clockwork.item:New()
ITEM.name = "Маска DvL"
ITEM.plural = "Масок DvL"
ITEM.uniqueID = "cps_mask_dvl"
ITEM.model = "models/hl2rp/metropolice/suit/gasmask5.mdl"
ITEM.weight = 1
ITEM.useText = "Надеть"
ITEM.category = "Одежда"
ITEM.description = "Маска Division Leader."
ITEM.customFunctions = {"Снять"}
ITEM.clbg = 2
ITEM.fclbgst = 2
ITEM.clbgst = 5

-- Called when a player attempts to sell the item to salesman.
function ITEM:CanSell(player)
	if (player:GetFaction() == FACTION_MPF) then
		local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
		local bodyGroupState = clbgst
		local model = player:GetModel()

		if (player:QueryCharacter("gender") == GENDER_FEMALE) then
			bodyGroupState = fclbgst
		end
		
		if (ITEM.clbg < player:GetNumBodyGroups())then
			targetBodyGroups[model] = targetBodyGroups[model] or {}
			
			if (targetBodyGroups[model][tostring(ITEM.clbg)] and targetBodyGroups[model][tostring(ITEM.clbg)] == bodyGroupState) then
				targetBodyGroups[model][tostring(ITEM.clbg)] = nil

				player:SetBodygroup(ITEM.clbg, 0)
				player:SetCharacterData("BodyGroups", targetBodyGroups)
			end
		end
	end

	return true
end

-- Called when a player attempts to give the item to storage.
function ITEM:CanGiveStorage(player, storageTable)
	if (player:GetFaction() == FACTION_MPF) then
		local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
		local bodyGroupState = clbgst
		local model = player:GetModel()

		if (player:QueryCharacter("gender") == GENDER_FEMALE) then
			bodyGroupState = fclbgst
		end
		
		if (ITEM.clbg < player:GetNumBodyGroups())then
			targetBodyGroups[model] = targetBodyGroups[model] or {}
			
			if (targetBodyGroups[model][tostring(ITEM.clbg)] and targetBodyGroups[model][tostring(ITEM.clbg)] == bodyGroupState) then
				targetBodyGroups[model][tostring(ITEM.clbg)] = nil

				player:SetBodygroup(ITEM.clbg, 0)
				player:SetCharacterData("BodyGroups", targetBodyGroups)
			end
		end
	end

	return true
end

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:GetFaction() == FACTION_MPF) then
		local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
		local bodyGroupState = clbgst
		local model = player:GetModel()

		if (player:QueryCharacter("gender") == GENDER_FEMALE) then
			bodyGroupState = fclbgst
		end
		
		if (ITEM.clbg < player:GetNumBodyGroups())then
			targetBodyGroups[model] = targetBodyGroups[model] or {}
			
			if (targetBodyGroups[model][tostring(ITEM.clbg)] and targetBodyGroups[model][tostring(ITEM.clbg)] == bodyGroupState) then
				targetBodyGroups[model][tostring(ITEM.clbg)] = nil

				player:SetBodygroup(ITEM.clbg, 0)
				player:SetCharacterData("BodyGroups", targetBodyGroups)
			end
		end
	end

	return true
end

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:GetFaction() == FACTION_MPF) then
		if (player:Alive() and !player:IsRagdolled()) then
			local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
			local bodyGroupState = clbgst
			local model = player:GetModel()

			if (player:QueryCharacter("gender") == GENDER_FEMALE) then
				bodyGroupState = fclbgst
			end

			if (ITEM.clbg < player:GetNumBodyGroups())then
				targetBodyGroups[model] = targetBodyGroups[model] or {}
				targetBodyGroups[model][tostring(ITEM.clbg)] = bodyGroupState

				player:SetBodygroup(ITEM.clbg, bodyGroupState)
				player:SetCharacterData("BodyGroups", targetBodyGroups)

				return true
			else
				Clockwork.player:Notify(player, "Вы не можете надеть это.")
				
				return false
			end
		end
	else
		Clockwork.player:Notify(player, "Вы не можете надеть это.")
		
		return false
	end
end

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (player:GetFaction() == FACTION_MPF) then
			if (name == "Снять") then
				local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
				local bodyGroupState = 0
				local model = player:GetModel()

				if (ITEM.clbg < player:GetNumBodyGroups())then
					targetBodyGroups[model] = targetBodyGroups[model] or {}
					targetBodyGroups[model][tostring(ITEM.clbg)] = nil

					player:SetBodygroup(ITEM.clbg, bodyGroupState)
					player:SetCharacterData("BodyGroups", targetBodyGroups)
				end
			end
		end
	end
end

ITEM:Register()