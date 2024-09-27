
-----------------------------------------------------
--[[
	© 2014 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

local Clockwork = Clockwork;
local pairs = pairs;
local table = table;

Clockwork.setting = Clockwork.kernel:NewLibrary("Setting");
Clockwork.setting.stored = {};

-- A function to add a number slider setting.
function Clockwork.setting:AddNumberSlider(category, text, conVar, minimum, maximum, decimals, toolTip, Condition)
	local index = #self.stored + 1;
	
	self.stored[index] = {
		Condition = Condition,
		category = category,
		decimals = decimals,
		toolTip = toolTip,
		maximum = maximum,
		minimum = minimum,
		conVar = conVar,
		class = "numberSlider",
		text = text
	};
	
	return index;
end;

-- A function to add a multi-choice setting.
function Clockwork.setting:AddMultiChoice(category, text, conVar, options, toolTip, Condition)
	local index = #self.stored + 1;
	
	if (options) then
		table.sort(options, function(a, b) return a < b; end);
	else
		options = {};
	end;
	
	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		options = options,
		conVar = conVar,
		class = "multiChoice",
		text = text
	};
	
	return index;
end;

-- A function to add a number wang setting.
function Clockwork.setting:AddNumberWang(category, text, conVar, minimum, maximum, decimals, toolTip, Condition)
	local index = #self.stored + 1;
	
	self.stored[index] = {
		Condition = Condition,
		category = category,
		decimals = decimals,
		toolTip = toolTip,
		maximum = maximum,
		minimum = minimum,
		conVar = conVar,
		class = "numberWang",
		text = text
	};
	
	return index;
end;

-- A function to add a text entry setting.
function Clockwork.setting:AddTextEntry(category, text, conVar, toolTip, Condition)
	local index = #self.stored + 1;
	
	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "textEntry",
		text = text
	};
	
	return index;
end;

-- A function to add a check box setting.
function Clockwork.setting:AddCheckBox(category, text, conVar, toolTip, Condition)
	local index = #self.stored + 1;
	
	self.stored[index] = {
		Condition = Condition,
		category = category,
		toolTip = toolTip,
		conVar = conVar,
		class = "checkBox",
		text = text
	};
	
	return index;
end;

-- A function to remove a setting by its index.
function Clockwork.setting:RemoveByIndex(index)
	self.stored[index] = nil;
end;

-- A function to remove a setting by its convar.
function Clockwork.setting:RemoveByConVar(conVar)
	for k, v in pairs(self.stored) do
		if (v.conVar == conVar) then
			self.stored[k] = nil;
		end;
	end;
end;

-- A function to remove a setting.
function Clockwork.setting:Remove(category, text, class, conVar)
	for k, v in pairs(self.stored) do
		if ((!category or v.category == category)
		and (!conVar or v.conVar == conVar)
		and (!class or v.class == class)
		and (!text or v.text == text)) then
			self.stored[k] = nil;
		end;
	end;
end;

Clockwork.setting:AddNumberSlider("Игровой режим", "Качание головы:", "cwHeadbobScale", 0, 1, 1, "Множитель качания головы стоя, ходьбе, беге.");
--Clockwork.setting:AddNumberSlider("Чат", "Chat Lines:", "cwMaxChatLines", 1, 10, 0, "The amount of chat lines shown at once.");

Clockwork.setting:AddCheckBox("Игровой режим", "Включить Админский лог в консоли.", "cwShowLog", "Показывать логи действий в консоли.", function()
	return Clockwork.player:IsAdmin(Clockwork.Client);
end);

--Clockwork.setting:AddCheckBox("Игровой режим", "Enable the twelve hour clock.", "cwTwelveHourClock", "Whether or not to show a twelve hour clock.");
--Clockwork.setting:AddCheckBox("Игровой режим", "Show bars at the top of the screen.", "cwTopBars", "Whether or not to show bars at the top of the screen.");
Clockwork.setting:AddCheckBox("Игровой режим", "Показывать подсказки.", "cwShowHints", "Показывать подсказки в правом верхнем углу экрана.");
Clockwork.setting:AddCheckBox("Игровой режим", "Показывать время в сообщениях.", "cwShowTimeStamps", "Показывать время отправки сообщений в чате.");
--Clockwork.setting:AddCheckBox("Чат", "Show messages related to Clockwork.", "cwShowClockwork", "Whether or not to show you any Clockwork messages.");
--Clockwork.setting:AddCheckBox("Чат", "Show messages from the server.", "cwShowServer", "Whether or not to show you any server messages.");
--Clockwork.setting:AddCheckBox("Чат", "Show out-of-character messages.", "cwShowOOC", "Whether or not to show you any out-of-character messages.");
--Clockwork.setting:AddCheckBox("Чат", "Show in-character messages.", "cwShowIC", "Whether or not to show you any in-character messages.");

Clockwork.setting:AddCheckBox("Валлхак", "Включить Админский валлхак.", "cwAdminESP", "Позволяет видеть различные сущности сквозь стены.", function()
	return Clockwork.player:IsAdmin(Clockwork.Client);
end);