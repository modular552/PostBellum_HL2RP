--[[
	� 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

Clockwork.kernel:IncludePrefixed("cl_schema.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_theme.lua");
Clockwork.kernel:IncludePrefixed("sh_hooks.lua");
Clockwork.kernel:IncludePrefixed("sv_schema.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");

Schema.customPermits = {};

--------------------------------------------------------------------
Clockwork.animation:AddFemaleHumanModel("models/humans/group17/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/group17/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/group17/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/group17/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/group17/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/group17/female_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/group17/male_09.mdl");
--------------------------------------------------------------------
Clockwork.animation:AddMaleHumanModel("models/citizen_17.mdl");
Clockwork.animation:AddMaleHumanModel("models/conscript.mdl");
Clockwork.animation:AddMaleHumanModel("models/tactical_rebel.mdl");

Clockwork.animation:AddFemaleHumanModel("models/betacz/group01/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group01/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group01/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group01/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group01/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group01/female_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group01/male_09.mdl");

Clockwork.animation:AddFemaleHumanModel("models/betacz/group02/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group02/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group02/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group02/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group02/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group02/female_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group02/male_09.mdl");

Clockwork.animation:AddFemaleHumanModel("models/betacz/group03/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03/female_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03/male_09.mdl");

Clockwork.animation:AddFemaleHumanModel("models/betacz/group03m/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03m/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03m/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03m/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03m/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/betacz/group03m/female_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/betacz/group03m/male_09.mdl");

Clockwork.animation:AddFemaleHumanModel("models/humans/airex/airex_female.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/airex/airex_male.mdl");

Clockwork.animation:AddFemaleHumanModel("models/humans/factory/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/factory/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/factory/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/factory/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/factory/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/factory/female_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/factory/male_09.mdl");

Clockwork.animation:AddMaleHumanModel("models/suits/male_01_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_01_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_02_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_02_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_03_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_03_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_04_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_04_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_05_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_05_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_06_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_06_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_07_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_07_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_08_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_08_open_waistcoat.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_09_closed_tie.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_09_open.mdl");
Clockwork.animation:AddMaleHumanModel("models/suits/male_09_shirt.mdl");
--------------------------------------------------------------------
Clockwork.animation:AddFemaleHumanModel("models/humans/combine/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/combine/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/combine/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/combine/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/combine/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/combine/female_07.mdl");
Clockwork.animation:AddFemaleHumanModel("models/humans/combine/female_ga.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/humans/combine/male_09.mdl");
--------------------------------------------------------------------
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_elitfemalecp1.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_elitfemalecp2.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_elitfemalecp3.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_elitfemalecp4.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_elitfemalecp5.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_elitfemalecp6.mdl");

Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp1.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp6.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp7.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp8.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp9.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp10.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp11.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp12.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_elitmalecp13.mdl");

Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp1.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp2.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp3.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp4.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp5.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp6.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp7test.mdl");
Clockwork.animation:AddFemaleHumanModel("models/hl2rp/metropolice/hl2_femalecp8.mdl");

Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp1.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp2.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp3.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp4.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp5.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp6.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp7.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp8.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp9.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp10.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp11.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp12.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp13.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp14.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp15.mdl");
Clockwork.animation:AddCivilProtectionModel("models/hl2rp/metropolice/hl2_malecp16.mdl");

Clockwork.animation:AddFemaleHumanModel("models/re5/jill.mdl");
Clockwork.animation:AddMaleHumanModel("models/re5/wesker.mdl");
--------------------------------------------------------------------
Clockwork.animation:AddFemaleHumanModel("models/humans/suitfem/female_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/taggart/gallahan.mdl");

Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_01.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_02.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_03.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_04.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_05.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_06.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_07.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_08.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_09.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_10.mdl");
Clockwork.animation:AddFemaleHumanModel("models/tnb/citizens/female_11.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_01.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_02.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_03.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_04.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_05.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_06.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_07.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_08.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_09.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_10.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_11.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_12.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_13.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_14.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_15.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_16.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_17.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/citizens/male_18.mdl");

Clockwork.animation:AddFemaleHumanModel("models/tnb/combine/metrocop_female.mdl");
Clockwork.animation:AddMaleHumanModel("models/tnb/combine/metrocop.mdl");
--------------------------------------------------------------------

Clockwork.option:SetKey("default_date", {month = 1, year = 2016, day = 1});
Clockwork.option:SetKey("default_time", {minute = 0, hour = 0, day = 1});
Clockwork.option:SetKey("format_singular_cash", "%a");
Clockwork.option:SetKey("model_shipment", "models/items/item_item_crate.mdl");
Clockwork.option:SetKey("intro_image", "cdev2_pb/menu_logo");
Clockwork.option:SetKey("schema_logo", "cdev2_pb/menu_logo");
Clockwork.option:SetKey("format_cash", "%a жетонов");
Clockwork.option:SetKey("menu_music", "music/hl1_song3.mp3");
Clockwork.option:SetKey("name_cash", "Tokens");
Clockwork.option:SetKey("model_cash", "models/props_lab/box01a.mdl");
Clockwork.option:SetKey("gradient", "halfliferp/bg_gradient");

Clockwork.config:ShareKey("intro_text_small");
Clockwork.config:ShareKey("intro_text_big");
Clockwork.config:ShareKey("business_cost");
Clockwork.config:ShareKey("permits");

Clockwork.quiz:SetEnabled(false);
Clockwork.quiz:AddQuestion("Вы понимаете, что РП очень медленный режим?", 1, "Да.", "Нет.");
Clockwork.quiz:AddQuestion("Вы понимаете, что вы должны писать грамотно, используя заглавные буквы?", 2, "Окей.", "Да, я понимаю.", "Нет.");
Clockwork.quiz:AddQuestion("Что вы будете делать если на вас наставят оружие?", 3, "Попробую сразу же убежать.", "Попробую убить врага.", "Буду делать все, что мне скажут.");
Clockwork.quiz:AddQuestion("В глобальном чате написали, что вас идут убить. Ваши действия?", 2, "Убегу от туда, или займу оборону.", "Ничего не буду предпринимать.");
Clockwork.quiz:AddQuestion("Как вы понимаете РП режим (ролевая игра)?", 2, "Убийство других игроков.", "Развитие своего персонажа.", "Строительство.", "Выживание, добыча ресурсов.");
Clockwork.quiz:AddQuestion("В какой вселенной происходят действия данного РП режима?", 2, "Реальная жизнь", "Half-Life 2", "Garry's Mod", "Roleplay");

Clockwork.flag:Add("v", "Light Blackmarket", "Access to light blackmarket goods.");
Clockwork.flag:Add("V", "Heavy Blackmarket", "Access to heavy blackmarket goods.");
Clockwork.flag:Add("m", "Resistance Manager", "Access to the resistance manager's goods.");
Clockwork.flag:Add("D", "D-flag", "Your character will never get permakill.");
Clockwork.flag:Add("k", "Clerk", "It allows you to edit the notelibs.");

-- A function to add a custom permit.
function Schema:AddCustomPermit(name, flag, model)
	local formattedName = string.gsub(name, "[%s%p]", "");
	local lowerName = string.lower(name);
	
	self.customPermits[ string.lower(formattedName) ] = {
		model = model,
		name = name,
		flag = flag,
		key = Clockwork.kernel:SetCamelCase(formattedName, true)
	};
end;

-- A function to check if a string is a Combine rank.
function Schema:IsStringCombineRank(text, rank)
	if (type(rank) == "table") then
		for k, v in ipairs(rank) do
			if (self:IsStringCombineRank(text, v)) then
				return true;
			end;
		end;
	elseif (rank == "EpU") then
		if (string.find(text, "%pSeC%p") or string.find(text, "%pDvL%p")
		or string.find(text, "%pEpU%p")) then
			return true;
		end;
	else
		return string.find(text, "%p"..rank.."%p");
	end;
end;

-- A function to check if a player is a Combine rank.
function Schema:IsPlayerCombineRank(player, rank, realRank)
	local name = player:Name();
	local faction = player:GetFaction();
	
	if (self:IsCombineFaction(faction)) then
		if (type(rank) == "table") then
			for k, v in ipairs(rank) do
				if (self:IsPlayerCombineRank(player, v, realRank)) then
					return true;
				end;
			end;
		elseif (rank == "EpU" and !realRank) then
			if (string.find(name, "%pSeC%p") or string.find(name, "%pDvL%p")
			or string.find(name, "%pEpU%p")) then
				return true;
			end;
		else
			return string.find(name, "%p"..rank.."%p");
		end;
	end;
end;

-- A function to get a player's Combine rank.
function Schema:GetPlayerCombineRank(player)
	local faction = player:GetFaction();
	
	if (faction == FACTION_OTA) then
		if (self:IsPlayerCombineRank(player, "OWS")) then
			return 0;
		elseif (self:IsPlayerCombineRank(player, "EOW")) then
			return 2;
		else
			return 1;
		end;
	elseif (self:IsPlayerCombineRank(player, "RCT")) then
		return 0;
	elseif (self:IsPlayerCombineRank(player, "05")) then
		return 1;
	elseif (self:IsPlayerCombineRank(player, "04")) then
		return 2;
	elseif (self:IsPlayerCombineRank(player, "03")) then
		return 3;
	elseif (self:IsPlayerCombineRank(player, "02")) then
		return 4;
	elseif (self:IsPlayerCombineRank(player, "01")) then
		return 5;
	elseif (self:IsPlayerCombineRank(player, "OfC")) then
		return 7;
	elseif (self:IsPlayerCombineRank(player, "EpU", true)) then
		return 8;
	elseif (self:IsPlayerCombineRank(player, "CmR")) then
		return 9;
	elseif (self:IsPlayerCombineRank(player, "DvL")) then
		return 10;
	elseif (self:IsPlayerCombineRank(player, "SeC")) then
		return 11;
	elseif (self:IsPlayerCombineRank(player, "SCN")) then
		if (!self:IsPlayerCombineRank(player, "SYNTH")) then
			return 12;
		else
			return 13;
		end;
	else
		return 6;
	end;
end;

-- A function to get if a faction is Combine.
function Schema:IsCombineFaction(faction)
	return (faction == FACTION_MPF or faction == FACTION_OTA or faction == FACTION_CREMATOR or faction == FACTION_INCOG);
end;