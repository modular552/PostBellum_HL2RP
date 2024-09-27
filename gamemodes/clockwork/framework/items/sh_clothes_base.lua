
-----------------------------------------------------
--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;

local ITEM = Clockwork.item:New(nil, true);
ITEM.name = "Clothes Base";
ITEM.model = "models/props_c17/suitcase_passenger_physics.mdl";
ITEM.weight = 2;
ITEM.useText = "Надеть";
ITEM.category = "Одежда";
ITEM.description = "A suitcase full of clothes.";

-- A function to get the model name.
function ITEM:GetModelName(player, group)
	local modelName = nil;
	
	if (!player) then
		player = Clockwork.Client;
	end;
	
	if (group) then
		modelName = string.gsub(string.lower(Clockwork.player:GetDefaultModel(player)), "^.-/.-/", "");
	else
		modelName = string.gsub(string.lower(Clockwork.player:GetDefaultModel(player)), "^.-/.-/.-/", "");
	end;
	
	if (modelName == "hl2_femalecp1.mdl" or modelName == "hl2_femalecp6.mdl") then return "female_01.mdl" end
	if (modelName == "hl2_femalecp2.mdl" or modelName == "hl2_femalecp4.mdl") then return "female_02.mdl" end
	if (modelName == "hl2_femalecp3.mdl" or modelName == "hl2_femalecp5.mdl") then return "female_06.mdl" end
	if (modelName == "hl2_malecp10.mdl" or modelName == "hl2_malecp12.mdl") then return "male_02.mdl" end
	if (modelName == "hl2_malecp9.mdl" or modelName == "hl2_malecp11.mdl") then return "male_04.mdl" end
	if (modelName == "hl2_malecp5.mdl" or modelName == "hl2_malecp6.mdl" or modelName == "hl2_malecp7.mdl" or modelName == "hl2_malecp8.mdl") then return "male_06.mdl" end
	if (modelName == "hl2_malecp1.mdl" or modelName == "hl2_malecp2.mdl" or modelName == "hl2_malecp3.mdl" or modelName == "hl2_malecp4.mdl") then return "male_07.mdl" end
	if (modelName == "hl2_malecp13.mdl" or modelName == "hl2_malecp14.mdl" or modelName == "hl2_malecp15.mdl" or modelName == "hl2_malecp16.mdl") then return "male_09.mdl" end
	
	if (modelName == "female_05.mdl" or modelName == "female_10.mdl") then return "female_01.mdl" end
	if (modelName == "female_08.mdl" or modelName == "female_11.mdl") then return "female_02.mdl" end
	if (modelName == "female_07.mdl" or modelName == "female_09.mdl") then return "female_06.mdl" end
	if (modelName == "male_17.mdl" or modelName == "male_14.mdl") then return "male_02.mdl" end
	if (modelName == "male_15.mdl") then return "male_03.mdl" end
	if (modelName == "male_18.mdl" or modelName == "male_16.mdl") then return "male_06.mdl" end
	if (modelName == "male_13.mdl" or modelName == "male_12.mdl") then return "male_07.mdl" end
	if (modelName == "male_10.mdl" or modelName == "male_11.mdl") then return "male_09.mdl" end
	
	if (modelName == "models/suits/male_01_closed_tie.mdl" or modelName == "models/suits/male_01_open_waistcoat.mdl") then return "male_01.mdl" end
	if (modelName == "models/suits/male_02_closed_tie.mdl" or modelName == "models/suits/male_02_open_waistcoat.mdl") then return "male_02.mdl" end
	if (modelName == "models/suits/male_03_closed_tie.mdl" or modelName == "models/suits/male_03_open_waistcoat.mdl") then return "male_03.mdl" end
	if (modelName == "models/suits/male_04_closed_tie.mdl" or modelName == "models/suits/male_04_open_waistcoat.mdl") then return "male_04.mdl" end
	if (modelName == "models/suits/male_05_closed_tie.mdl" or modelName == "models/suits/male_05_open_waistcoat.mdl") then return "male_05.mdl" end
	if (modelName == "models/suits/male_06_closed_tie.mdl" or modelName == "models/suits/male_06_open_waistcoat.mdl") then return "male_06.mdl" end
	if (modelName == "models/suits/male_07_closed_tie.mdl" or modelName == "models/suits/male_07_open_waistcoat.mdl") then return "male_07.mdl" end
	if (modelName == "models/suits/male_08_closed_tie.mdl" or modelName == "models/suits/male_08_open_waistcoat.mdl") then return "male_08.mdl" end
	if (modelName == "models/suits/male_09_closed_tie.mdl" or modelName == "models/suits/male_09_open.mdl" or modelName == "models/suits/male_09_shirt.mdl") then return "male_09.mdl" end
	
	if (!string.find(modelName, "male") and !string.find(modelName, "female")) then
		if (group) then
			group = "group17/";
		else
			group = "";
		end;
		
		if (SERVER) then
			if (player:GetGender() == GENDER_FEMALE) then
				return group.."female_02.mdl";
			else
				return group.."male_02.mdl";
			end;
		elseif (player:GetGender() == GENDER_FEMALE) then
			return group.."female_02.mdl";
		else
			return group.."male_02.mdl";
		end;
	else
		return modelName;
	end;
end;

-- Called when the item's client side model is needed.
function ITEM:GetClientSideModel()
	local replacement = nil;
	
	if (self.GetReplacement) then
		replacement = self:GetReplacement(Clockwork.Client);
	end;
	
	if (type(replacement) == "string") then
		return replacement;
	elseif (self("replacement")) then
		return self("replacement");
	elseif (self("group")) then
		return "models/humans/"..self("group").."/"..self:GetModelName();
	elseif (self("group_adv")) then
		return "models/"..self("group_adv").."/"..self:GetModelName();
	end;
end;

-- Called when a player changes clothes.
function ITEM:OnChangeClothes(player, bIsWearing)
	if (bIsWearing) then
		local replacement = nil;
		
		if (self.GetReplacement) then
			replacement = self:GetReplacement(player);
		end;
		
		if (type(replacement) == "string") then
			player:SetModel(replacement);
		elseif (self("replacement")) then
			player:SetModel(self("replacement"));
		elseif (self("group")) then
			player:SetModel("models/humans/"..self("group").."/"..self:GetModelName(player));
		elseif (self("group_adv")) then
			player:SetModel("models/"..self("group_adv").."/"..self:GetModelName(player));
		end;
	else
		Clockwork.player:SetDefaultModel(player);
		Clockwork.player:SetDefaultSkin(player);
	end;
	
	if (self.OnChangedClothes) then
		self:OnChangedClothes(player, bIsWearing);
	end;
end;

-- Called to get whether a player has the item equipped.
function ITEM:HasPlayerEquipped(player, bIsValidWeapon)
	if (CLIENT) then
		return Clockwork.player:IsWearingItem(self);
	else
		return player:IsWearingItem(self);
	end;
end;

-- Called when a player has unequipped the item.
function ITEM:OnPlayerUnequipped(player, extraData)
	player:RemoveClothes();
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player:IsWearingItem(self)) then
		Clockwork.player:Notify(player, "Вы не можете выбросить одежду, в которую одеты!");
		return false;
	end;
end;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (self("whitelist") and !table.HasValue(self("whitelist"), player:GetFaction())) then
		Clockwork.player:Notify(player, "Вы не можете надеть это!");
		return false;
	end;
	
	if (player:Alive() and !player:IsRagdolled()) then
		if (!self.CanPlayerWear or self:CanPlayerWear(player, itemEntity) != false) then
			player:SetClothesData(self);
			return true;
		end;
	else
		Clockwork.player:Notify(player, "Вы не можете сделать это в данный момент!");
	end;
	
	return false;
end;

if (CLIENT) then
	function ITEM:GetClientSideInfo()
		if (!self:IsInstance()) then return; end;
		
		if (Clockwork.player:IsWearingItem(self)) then
			return "Надето";
		else
			return "Не надето";
		end;
	end;
end;

Clockwork.item:Register(ITEM);