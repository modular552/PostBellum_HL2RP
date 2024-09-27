
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local ITEM = Clockwork.item:New()
ITEM.name = "Защитные очки";
ITEM.plural = "Защитных очков";
ITEM.uniqueID = "medgoggles";
ITEM.model = "models/labware/goggles.mdl";
ITEM.weight = 0.1
ITEM.useText = "Надеть"
ITEM.category = "Медикаменты";
ITEM.description = "Средство защиты органов зрения от различных внешних факторов.";
ITEM.customFunctions = {"Снять"}
ITEM.AccForward = 0
ITEM.AccRight = 0
ITEM.AccUp = 1.5

-- Called when a player attempts to sell the item to salesman.
function ITEM:CanSell(player)
	local ID = ITEM.uniqueID

	if (player.Acc and IsValid(player.Acc[ID])) then
		player.Acc[ID]:Remove()
		player.Acc[ID] = nil

		local targetAccessories = player:GetCharacterData("Accessories2") or {}

		targetAccessories[ID] = nil
		player:SetCharacterData("Accessories2", targetAccessories)
	end

	return true
end

-- Called when a player attempts to give the item to storage.
function ITEM:CanGiveStorage(player, storageTable)
	local ID = ITEM.uniqueID

	if (player.Acc and IsValid(player.Acc[ID])) then
		player.Acc[ID]:Remove()
		player.Acc[ID] = nil

		local targetAccessories = player:GetCharacterData("Accessories2") or {}

		targetAccessories[ID] = nil
		player:SetCharacterData("Accessories2", targetAccessories)
	end

	return true
end

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	local ID = ITEM.uniqueID

	if (player.Acc and IsValid(player.Acc[ID])) then
		player.Acc[ID]:Remove()
		player.Acc[ID] = nil

		local targetAccessories = player:GetCharacterData("Accessories2") or {}

		targetAccessories[ID] = nil
		player:SetCharacterData("Accessories2", targetAccessories)
	end

	return true
end

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player:Alive() and !player:IsRagdolled()) then
		local faction = player:GetFaction()

		if (faction == FACTION_CITIZEN or faction == FACTION_REFUGEE or faction == FACTION_RAIDER or faction == FACTION_CWU or faction == FACTION_CWUMEDIC or faction == FACTION_CWUBOSS or faction == FACTION_GOO or faction == FACTION_REBEL or faction == FACTION_REBELMEDIC or faction == FACTION_REBELBOSS or faction == FACTION_SYNDICATE or faction == FACTION_ADMIN or faction == FACTION_INCOG) then
			local att = player:LookupAttachment("eyes")
			local attpos = player:GetAttachment(att)

			if (attpos) then
				if (!player.Acc) then
					player.Acc = {}
				end

				local ID = ITEM.uniqueID
				local AccF = ITEM.AccForward
				local AccR = ITEM.AccRight
				local AccU = ITEM.AccUp

				if (!IsValid(player.Acc[ID])) then
					player.Acc[ID] = ents.Create("cw_accessory2")
					player.Acc[ID]:SetModel(ITEM.model)
					player.Acc[ID]:SetAngles(attpos.Ang)
					player.Acc[ID]:SetPos(attpos.Pos - player.Acc[ID]:GetForward()*AccF - player.Acc[ID]:GetRight()*AccR - player.Acc[ID]:GetUp()*AccU)
					player.Acc[ID]:SetParent(player, att)
					player.Acc[ID]:Spawn()
				end

				local targetAccessories = player:GetCharacterData("Accessories2") or {}

				targetAccessories[ID] = true
				player:SetCharacterData("Accessories2", targetAccessories)

				return true
			else
				Clockwork.player:Notify(player, "Вы не можете надеть это.")

				return false
			end
		else
			Clockwork.player:Notify(player, "Вы не можете надеть это.")

			return false
		end
	end
end

if (SERVER) then
	function ITEM:OnCustomFunction(player, name)
		if (name == "Снять") then
			local ID = ITEM.uniqueID

			if (player.Acc and IsValid(player.Acc[ID])) then
				player.Acc[ID]:Remove()
				player.Acc[ID] = nil

				local targetAccessories = player:GetCharacterData("Accessories2") or {}

				targetAccessories[ID] = nil
				player:SetCharacterData("Accessories2", targetAccessories)
			end
		end
	end
end

ITEM:Register()