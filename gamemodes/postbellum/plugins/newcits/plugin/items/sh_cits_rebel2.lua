
-----------------------------------------------------
local ITEM = Clockwork.item:New()
ITEM.name = "Униформа повстанцев другого цвета"
ITEM.plural = "Униформ повстанцев другого цвета"
ITEM.uniqueID = "cits_rebel2"
ITEM.model = "models/tnb/items/shirt_rebel1.mdl"
ITEM.skin = 1
ITEM.weight = 4
ITEM.useText = "Надеть"
ITEM.category = "Одежда"
ITEM.description = "Униформа для сил сопротивления."
ITEM.customFunctions = {"Снять"}
ITEM.clbg = 1
ITEM.clbgst = 9

-- Called when a player attempts to sell the item to salesman.
function ITEM:CanSell(player)
	if (!Schema:PlayerIsCombine(player)) then
		local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
		local bodyGroupState = ITEM.clbgst
		local model = player:GetModel()

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
	if (!Schema:PlayerIsCombine(player)) then
		local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
		local bodyGroupState = ITEM.clbgst
		local model = player:GetModel()

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
	if (!Schema:PlayerIsCombine(player)) then
		local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
		local bodyGroupState = ITEM.clbgst
		local model = player:GetModel()

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
	if (!Schema:PlayerIsCombine(player)) then
		if (player:Alive() and !player:IsRagdolled()) then
			local targetBodyGroups = player:GetCharacterData("BodyGroups") or {}
			local bodyGroupState = ITEM.clbgst
			local model = player:GetModel()

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
		if (!Schema:PlayerIsCombine(player)) then
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