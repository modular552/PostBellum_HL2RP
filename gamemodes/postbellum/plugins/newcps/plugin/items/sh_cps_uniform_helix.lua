
-----------------------------------------------------
local ITEM = Clockwork.item:New()
ITEM.name = "Униформа HELIX"
ITEM.plural = "Униформ HELIX"
ITEM.uniqueID = "cps_uniform_helix"
ITEM.model = "models/hl2rp/metropolice/suit/shirt_metrocop4.mdl"
ITEM.weight = 4
ITEM.useText = "Надеть"
ITEM.category = "Одежда"
ITEM.description = "Униформа отряда HELIX."
ITEM.customFunctions = {"Снять"}
ITEM.clsk = 4

-- Called when a player attempts to sell the item to salesman.
function ITEM:CanSell(player)
	if (player:GetFaction() == FACTION_MPF) then
		local targetSkin = player:GetCharacterData("Skin") or {}
		local model = player:GetModel()

		if (targetSkin[model] and targetSkin[model] == ITEM.clsk) then
			targetSkin[model] = nil

			player:SetSkin(0)
			player:SetCharacterData("Skin", targetSkin)
		end
	end

	return true
end

-- Called when a player attempts to give the item to storage.
function ITEM:CanGiveStorage(player, storageTable)
	if (player:GetFaction() == FACTION_MPF) then
		local targetSkin = player:GetCharacterData("Skin") or {}
		local model = player:GetModel()

		if (targetSkin[model] and targetSkin[model] == ITEM.clsk) then
			targetSkin[model] = nil

			player:SetSkin(0)
			player:SetCharacterData("Skin", targetSkin)
		end
	end

	return true
end

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:GetFaction() == FACTION_MPF) then
		local targetSkin = player:GetCharacterData("Skin") or {}
		local model = player:GetModel()

		if (targetSkin[model] and targetSkin[model] == ITEM.clsk) then
			targetSkin[model] = nil

			player:SetSkin(0)
			player:SetCharacterData("Skin", targetSkin)
		end
	end

	return true
end

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:GetFaction() == FACTION_MPF) then
		if (player:Alive() and !player:IsRagdolled()) then
			local targetSkin = player:GetCharacterData("Skin") or {}
			local model = player:GetModel()

			if (ITEM.clsk < player:SkinCount())then
				targetSkin[model] = ITEM.clsk

				player:SetSkin(ITEM.clsk)
				player:SetCharacterData("Skin", targetSkin)

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
				local targetSkin = player:GetCharacterData("Skin") or {}
				local model = player:GetModel()

				targetSkin[model] = nil

				player:SetSkin(0)
				player:SetCharacterData("Skin", targetSkin)
			end
		end
	end
end

ITEM:Register()