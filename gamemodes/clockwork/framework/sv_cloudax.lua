--[[ 
	© 2015 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

CloudAuthX = {}
function CloudAuthX.External(...)
	MsgN("[CloudAuthX] ERROR, FOUND A ENCRYPTED CODE!");
end

function util.Base64Decode(data)
	if !data then return end
	local char = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	
	data = string.gsub(data, "[^"..char.."=]", "")
	return (data:gsub(".", function(x)
		if (x == "=") then return "" end
		local r, f = "",(char:find(x) - 1)
		for i = 6, 1, -1 do r = r .. (f%2^i - f%2^(i - 1) > 0 and "1" or "0") end
		return r
	end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if #x ~= 8 then return "" end
		local c = 0
		for i = 1, 8 do c = c + (x:sub(i, i) == "1" and 2^(8 - i) or 0) end
		return string.char(c)
	end))
end

MsgC(Color(0, 255, 255, 255), "[CloudAuthX] Loading encrypted Clockwork externals, please wait...\n");
MsgN("[CloudAuthX] Applying temporary fix for GMod update -- SteamID64.");

local playerMeta = FindMetaTable("Player");
playerMeta.ClockworkSteamID64 = playerMeta.ClockworkSteamID64 or playerMeta.SteamID64;
function playerMeta:SteamID64()
	local value = self:ClockworkSteamID64();
	
	if (value == nil) then
		print("Temporary fix for SteamID64 has been used.");
		return "";
	else
		return value;
	end;
end;
MsgN("[CloudAuthX] Removing gm_save command to fix GMod exploit.");
concommand.Add("gm_save", function(ply)
	MsgN("[CloudAuthX] "..ply:Name().." tried to use gm_save -- beware!");
end);

if (not system.IsLinux()) then
	require("tmysql4");
else
	require("mysqloo");
end;

local oldInclude = include;
function include(fileName)
	if (fileName == "sv_cloudax.lua") then
		return;
	end;
	
	return oldInclude(fileName);
end;
MsgN("[Cloudnet] Loading shared Cloudnet code...");
Clockwork.cloudnet = Clockwork.cloudnet or {};
Clockwork.cloudnet.cache = Clockwork.cloudnet.cache or {};
Clockwork.cloudnet.stored = Clockwork.cloudnet.stored or {};
Clockwork.cloudnet.NET_KEY = "CloudNet";
Clockwork.cloudnet.PRUNE_KEY = "PruneNet";
	
Clockwork.cloudnet.INT = 1;
Clockwork.cloudnet.FLOAT = 2;
Clockwork.cloudnet.BOOL = 3;
Clockwork.cloudnet.VECTOR = 4;
Clockwork.cloudnet.ANGLE = 5;
Clockwork.cloudnet.ENTITY = 6;
Clockwork.cloudnet.STRING = 7;
function Clockwork.cloudnet:GetVar(entity, key, default)
	local index = entity:EntIndex();
	
	if (self.stored[index]) then
		if (self.stored[index][key] ~= nil) then
			return self.stored[index][key];
		end;
	end;
	
	return default;
end;
function Clockwork.cloudnet:Debug(text)
	if (Clockwork.DeveloperVersion) then
		MsgN(text);
	end;
end;
MsgN("[Cloudnet] Loading server Cloudnet code...");
Clockwork.cloudnet.sendQueue = Clockwork.cloudnet.sendQueue or {};
util.AddNetworkString(Clockwork.cloudnet.NET_KEY);
util.AddNetworkString(Clockwork.cloudnet.PRUNE_KEY);
	
net.Receive(Clockwork.cloudnet.PRUNE_KEY, function(length, player)
	local entIndexes = {};
	local numEntities = net.ReadUInt(32);
	
	for i = 1, numEntities do
		entIndexes[#entIndexes + 1] = net.ReadUInt(32);
	end;
	
	for k, v in ipairs(entIndexes) do
		if (IsValid(Entity(v))) then
			Clockwork.cloudnet:SendEntity(player, v, true);
		end;
	end;
end);
function Clockwork.cloudnet:SetSendCallback(callback)
	self.sendCallback = callback;
end;
function Clockwork.cloudnet:CanSend(entity, target, key)
	if (not self.sendCallback or self.sendCallback(entity, target, key)) then
		return true;
	end;
	
	return false;
end;
function Clockwork.cloudnet:SetVar(entity, key, value)
	if (!IsValid(entity)) then
		return;
	end;
	
	if (value == nil) then
		ErrorNoHalt("You cannot set a CloudNet var to nil. Please find another way!\n");
		return;
	end;
	
	local index = entity:EntIndex();
	
	if (not self.stored[index]) then
		self.stored[index] = {};
	end;
	
	if (self.stored[index][key] == value) then
		return;
	end;
	
	self.stored[index][key] = value;
	
	for k, v in ipairs(player.GetAll()) do
		if (self:CanSend(entity, v, key)) then
			local uniqueID = v:UniqueID();
			self:AddToQueue(uniqueID, index, key, value);
		end;
	end;
end;
function Clockwork.cloudnet:AddToQueue(uniqueID, index, key, value, isForced)
	if (not self.cache[uniqueID]) then
		self.cache[uniqueID] = {};
	end;
	
	if (not self.cache[uniqueID][index]) then
		self.cache[uniqueID][index] = {};
	end;
	
	if (isForced or self.cache[uniqueID][index][key] ~= value) then
		self.cache[uniqueID][index][key] = value;
	
		if (not self.sendQueue[uniqueID]) then
			self.sendQueue[uniqueID] = {};
			self.sendQueue[uniqueID].numEntities = 0;
		end;
	
		if (not self.sendQueue[uniqueID][index]) then
			self.sendQueue[uniqueID][index] = {};
			self.sendQueue[uniqueID][index].numVars = 0;
			self.sendQueue[uniqueID].numEntities = self.sendQueue[uniqueID].numEntities + 1;
		end;
	
		if (self.sendQueue[uniqueID][index][key] == nil) then
			self.sendQueue[uniqueID][index].numVars = self.sendQueue[uniqueID][index].numVars + 1;
		end;
	
		self.sendQueue[uniqueID][index][key] = value;
	end;
end;
function Clockwork.cloudnet:SendEntity(player, index, isForced)
	local uniqueID = player:UniqueID();
	local data = self.stored[index];
	local entity = Entity(index);
	
	if (data and IsValid(entity)) then
		for k, v in pairs(data) do
			if (self:CanSend(entity, player, k)) then
				self:AddToQueue(uniqueID, index, k, v, isForced);
			end;
		end;
	end;
end;
function Clockwork.cloudnet:SendAll(player)
	local uniqueID = player:UniqueID();
	
	for k, v in pairs(self.stored) do
		local entity = Entity(k);
		
		if (IsValid(entity)) then
			for k2, v2 in pairs(v) do
				if (self:CanSend(entity, player, k2)) then
					self:AddToQueue(uniqueID, k, k2, v2);
				end;
			end;
		end;
	end;
end;
function Clockwork.cloudnet:WriteData(key, value)
	net.WriteString(key);
	
	if (type(value) == "number") then
		net.WriteUInt(self.INT, 32);
		net.WriteFloat(value);
	elseif (type(value) == "string") then
		net.WriteUInt(self.STRING, 32);
		net.WriteString(value);
	elseif (type(value) == "boolean") then
		net.WriteUInt(self.BOOL, 32);
		net.WriteBool(value);
	elseif (type(value) == "Vector") then
		net.WriteUInt(self.VECTOR, 32);
		net.WriteVector(value);
	end;
end;
Clockwork.cloudnet.nextSendUpdate = 0;
hook.Add("PlayerAuthed", "Clockwork.cloudnet.PlayerAuthed", function(player)
	Clockwork.cloudnet:SendAll(player);
end);
hook.Add("EntityRemoved", "Clockwork.cloudnet.EntityRemoved", function(entity)
	local index = entity:EntIndex();
	
	for k, v in pairs(Clockwork.cloudnet.cache) do
		Clockwork.cloudnet.cache[k][index] = nil;
	end;
	
	Clockwork.cloudnet.stored[index] = nil;
end);
hook.Add("PlayerDisconnected", "Clockwork.cloudnet.PlayerDisconnected", function(player)
	local uniqueID = player:UniqueID();
	
	Clockwork.cloudnet.cache[uniqueID] = nil;
	Clockwork.cloudnet.sendQueue[uniqueID] = nil;
end);
Clockwork.cloudnet.NUM_VARS_STRING = "numVars";
hook.Add("Think", "Clockwork.cloudnet.Think", function()
	if (CurTime() >= Clockwork.cloudnet.nextSendUpdate) then
		for k, v in ipairs(player.GetAll()) do
			local uniqueID = v:UniqueID();
			local sendTable = Clockwork.cloudnet.sendQueue[uniqueID];
			
			if (sendTable) then
				net.Start(Clockwork.cloudnet.NET_KEY);
				net.WriteUInt(sendTable.numEntities, 32);
				
				for k2, v2 in pairs(sendTable) do
					if (tonumber(k2)) then
						net.WriteUInt(k2, 32);
						net.WriteUInt(v2.numVars, 32);
						
						for k3, v3 in pairs(v2) do
							if (k3 ~= Clockwork.cloudnet.NUM_VARS_STRING) then
								Clockwork.cloudnet:WriteData(k3, v3);
							end;
						end;
					end;
				end;
				
				net.Send(v);
			end;
		end;
		
		Clockwork.cloudnet.sendQueue = {};
		Clockwork.cloudnet.nextSendUpdate = CurTime() + 0.05;
	end;
end);
MsgN("[Cloudnet] Finished initializing Cloudnet networking tools.");
-------------------------------------------------
--- *** SHA-1 algorithm for Lua *** ---
-------------------------------------------------
--- Author: Martin Huesser ---
--- Date: 2008-06-16 ---
--- License: You may use this code in your ---
--- projects as long as this header ---
--- stays intact. ---
-------------------------------------------------
local strlen = string.len
local strchar = string.char
local strbyte = string.byte
local strsub = string.sub
local floor = math.floor
local bnot = bit.bnot
local band = bit.band
local bor = bit.bor
local bxor = bit.bxor
local shl = bit.lshift
local shr = bit.rshift
local h0, h1, h2, h3, h4
local function LeftRotate(val, nr)
	return shl(val, nr) + shr(val, 32 - nr)
end
local function ToHex(num)
	local i, d
	local str = ""
	for i = 1, 8 do
		d = band(num, 15)
		if (d < 10) then
			str = strchar(d + 48) .. str
		else
			str = strchar(d + 87) .. str
		end
		num = floor(num / 16)
	end
	return str
end
local function PreProcess(str)
	local bitlen, i
	local str2 = ""
	bitlen = strlen(str) * 8
	str = str .. strchar(128)
	i = 56 - band(strlen(str), 63)
	if (i < 0) then
		i = i + 64
	end
	for i = 1, i do
		str = str .. strchar(0)
	end
	for i = 1, 8 do
		str2 = strchar(band(bitlen, 255)) .. str2
		bitlen = floor(bitlen / 256)
	end
	return str .. str2
end
-------------------------------------------------
local function MainLoop(str)
	local a, b, c, d, e, f, k, t
	local i, j
	local w = {}
	while (str ~= "") do
		for i = 0, 15 do
			w[i] = 0
			for j = 1, 4 do
				w[i] = w[i] * 256 + strbyte(str, i * 4 + j)
			end
		end
		for i = 16, 79 do
			w[i] = LeftRotate(bxor(bxor(w[i - 3], w[i - 8]), bxor(w[i - 14], w[i - 16])), 1)
		end
		a = h0
		b = h1
		c = h2
		d = h3
		e = h4
		for i = 0, 79 do
			if (i < 20) then
				f = bor(band(b, c), band(bnot(b), d))
				k = 1518500249
			elseif (i < 40) then
				f = bxor(bxor(b, c), d)
				k = 1859775393
			elseif (i < 60) then
				f = bor(bor(band(b, c), band(b, d)), band(c, d))
				k = 2400959708
			else
				f = bxor(bxor(b, c), d)
				k = 3395469782
			end
			t = LeftRotate(a, 5) + f + e + k + w[i]
			e = d
			d = c
			c = LeftRotate(b, 30)
			b = a
			a = t
		end
		h0 = band(h0 + a, 4294967295)
		h1 = band(h1 + b, 4294967295)
		h2 = band(h2 + c, 4294967295)
		h3 = band(h3 + d, 4294967295)
		h4 = band(h4 + e, 4294967295)
		str = strsub(str, 65)
	end
end
function Sha1(str)
	str = PreProcess(str)
	h0 = 1732584193
	h1 = 4023233417
	h2 = 2562383102
	h3 = 0271733878
	h4 = 3285377520
	MainLoop(str)
	return ToHex(h0) ..
	ToHex(h1) ..
	ToHex(h2) ..
	ToHex(h3) ..
	ToHex(h4)
end
function Clockwork.kernel:ModifyPhysDesc(description)
	if (string.len(description) <= 256) then
		if (!string.find(string.sub(description, -2), "%p")) then
			return description..".";
		else
			return description;
		end;
	else
		return string.sub(description, 1, 253).."...";
	end;
end;
resource.AddFile("materials/icon16/illuminati.png");
resource.AddFile("materials/icon16/cloud16.png");
function SimpleBan(name, steamId, duration, reason, fullTime)
	if (not fullTime) then
		duration = os.time() + duration;
	end;
	
	Clockwork.bans.stored[steamId] = {
	unbanTime = duration,
	steamName = name,
	duration = duration,
	reason = reason
	};
end;
function Clockwork:LoadPostSchemaExternals()
	SimpleBan("Sim2014ftw", "STEAM_0:1:49947232", 1460410678, "Terms of Service Violation", true);
end;
function Clockwork:LoadPreSchemaExternals()
	include = oldInclude;
	
	Clockwork.plugin.__Register = Clockwork.plugin.Register;
	Clockwork.plugin.__Add = Clockwork.plugin.Add;
	function Clockwork.plugin:Register(...)
		self:__Register(...);
		
		if (self.ClearHookCache) then
			self:ClearHookCache();
			self.sortedModules = nil;
			self.sortedPlugins = nil;
		end;
	end;
	function Clockwork.plugin:Add(...)
		self:__Add(...);
		
		if (self.ClearHookCache) then
			self:ClearHookCache();
			self.sortedModules = nil;
			self.sortedPlugins = nil;
		end;
	end;
	if (Clockwork.UseCloudnet) then
		function Clockwork.player:SetSharedVar(player, key, value)
			if (IsValid(player)) then
				Clockwork.cloudnet:SetVar(player, key, value);
			end;
		end;
		function Clockwork.player:GetSharedVar(player, key)
			if (IsValid(player)) then
				local sharedVars = Clockwork.kernel:GetSharedVars():Player();
				local cloudnetVar = Clockwork.cloudnet:GetVar(player, key);
				
				if (cloudnetVar == nil and sharedVars and sharedVars[key]) then
					return Clockwork.kernel:GetDefaultNetworkedValue(sharedVars[key].class);
				else
					return cloudnetVar;
				end;
			end;
		end;
	
		Clockwork.cloudnet:SetSendCallback(function(entity, target, key)
			if (not entity:IsPlayer()) then
				return true;
			end;
			
			local sharedVars = Clockwork.kernel:GetSharedVars():Player();
			
			if (sharedVars and sharedVars[key] and sharedVars[key].bPlayerOnly) then
				return (entity == target);
			else
				return true;
			end;
		end);
	end;
	
	if (cwXCS) then
		ErrorNoHalt("Disabling CrossServerChat::ClockworkDatabaseConnected hook.\n");
		cwXCS.ClockworkDatabaseConnected = nil;
	end;
	Clockwork.database.updateTable = nil;
	Clockwork.database.runQueue = {};
	Clockwork.database.liteSql = false;
	MYSQL_UPDATE_CLASS = {__index = MYSQL_UPDATE_CLASS};
	function MYSQL_UPDATE_CLASS:SetTable(tableName)
		self.tableName = tableName;
		return self;
	end;
	function MYSQL_UPDATE_CLASS:SetValue(key, value)
		if (Clockwork.NoMySQL) then return self; end;
		self.updateVars[key] = "\""..Clockwork.database:Escape(tostring(value)).."\"";
		return self;
	end;
	function MYSQL_UPDATE_CLASS:Replace(key, search, replace)
		if (Clockwork.NoMySQL) then return self; end;
		
		search = "\""..Clockwork.database:Escape(tostring(search)).."\"";
		replace = "\""..Clockwork.database:Escape(tostring(replace)).."\"";
		self.updateVars[key] = "REPLACE("..key..", "..search..", "..replace..")";
		
		return self;
	end;
	function MYSQL_UPDATE_CLASS:AddWhere(key, value)
		if (Clockwork.NoMySQL) then return self; end;
		
		value = Clockwork.database:Escape(tostring(value));
		self.updateWhere[#self.updateWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
		return self;
	end;
	function MYSQL_UPDATE_CLASS:SetCallback(Callback)
		self.Callback = Callback;
		return self;
	end;
	function MYSQL_UPDATE_CLASS:SetFlag(value)
		self.Flag = value;
		return self;
	end;
	function MYSQL_UPDATE_CLASS:Push()
		if (Clockwork.NoMySQL) then return; end;
		if (!self.tableName) then return; end;
		
		local updateQuery = "";
		
		for k, v in pairs(self.updateVars) do
			if (updateQuery == "") then
				updateQuery = "UPDATE "..self.tableName.." SET "..k.." = "..v;
			else
				updateQuery = updateQuery..", "..k.." = "..v;
			end;
		end;
		
		if (updateQuery == "") then return; end;
		
		local whereTable = {};
		
		for k, v in pairs(self.updateWhere) do
			whereTable[#whereTable + 1] = v;
		end;
		
		local whereString = table.concat(whereTable, " AND ");
		
		if (whereString != "") then
			Clockwork.database:Query(updateQuery.." WHERE "..whereString, self.Callback, self.Flag);
		else
			Clockwork.database:Query(updateQuery, self.Callback, self.Flag);
		end;
	end;
	MYSQL_INSERT_CLASS = {__index = MYSQL_INSERT_CLASS};
	function MYSQL_INSERT_CLASS:SetTable(tableName)
		self.tableName = tableName;
		return self;
	end;
	function MYSQL_INSERT_CLASS:SetValue(key, value)
		self.insertVars[key] = value;
		return self;
	end;
	function MYSQL_INSERT_CLASS:SetCallback(Callback)
		self.Callback = Callback;
		return self;
	end;
	function MYSQL_INSERT_CLASS:SetFlag(value)
		self.Flag = value;
		return self;
	end;
	function MYSQL_INSERT_CLASS:Push()
		if (Clockwork.NoMySQL) then return; end;
		if (!self.tableName) then return; end;
		
		local keyList = {};
		local valueList = {};
		
		for k, v in pairs(self.insertVars) do
			keyList[#keyList + 1] = k;
			valueList[#valueList + 1] = "\""..Clockwork.database:Escape(tostring(v)).."\"";
		end;
		
		if (#keyList == 0) then return; end;
		
		local insertQuery = "INSERT INTO "..self.tableName.." ("..table.concat(keyList, ", ")..")";
		insertQuery = insertQuery.." VALUES("..table.concat(valueList, ", ")..")";
		Clockwork.database:Query(insertQuery, self.Callback, self.Flag);
	end;
	MYSQL_SELECT_CLASS = {__index = MYSQL_SELECT_CLASS};
	function MYSQL_SELECT_CLASS:SetTable(tableName)
		self.tableName = tableName;
		return self;
	end;
	function MYSQL_SELECT_CLASS:AddColumn(key)
		self.selectColumns[#self.selectColumns + 1] = key;
		return self;
	end;
	function MYSQL_SELECT_CLASS:AddWhere(key, value)
		if (Clockwork.NoMySQL) then return self; end;
		
		value = Clockwork.database:Escape(tostring(value));
		self.selectWhere[#self.selectWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
		return self;
	end;
	function MYSQL_SELECT_CLASS:SetCallback(Callback)
		self.Callback = Callback;
		return self;
	end;
	function MYSQL_SELECT_CLASS:SetFlag(value)
		self.Flag = value;
		return self;
	end;
	function MYSQL_SELECT_CLASS:SetOrder(key, value)
		self.Order = key.." "..value;
		return self;
	end;
	function MYSQL_SELECT_CLASS:Pull()
		if (Clockwork.NoMySQL) then return; end;
		if (!self.tableName) then return; end;
		
		if (#self.selectColumns == 0) then
			self.selectColumns[#self.selectColumns + 1] = "*";
		end;
		
		local selectQuery = "SELECT "..table.concat(self.selectColumns, ", ").." FROM "..self.tableName;
		local whereTable = {};
		
		for k, v in pairs(self.selectWhere) do
			whereTable[#whereTable + 1] = v;
		end;
		
		local whereString = table.concat(whereTable, " AND ");
		
		if (whereString != "") then
			selectQuery = selectQuery.." WHERE "..whereString;
		end;
		
		if (self.selectOrder != "") then
			selectQuery = selectQuery.." ORDER BY "..self.selectOrder;
		end;
		
		Clockwork.database:Query(selectQuery, self.Callback, self.Flag);
	end;
	MYSQL_DELETE_CLASS = {__index = MYSQL_DELETE_CLASS};
	function MYSQL_DELETE_CLASS:SetTable(tableName)
		self.tableName = tableName;
		return self;
	end;
	function MYSQL_DELETE_CLASS:AddWhere(key, value)
		if (Clockwork.NoMySQL) then return self; end;
		
		value = Clockwork.database:Escape(tostring(value));
		self.deleteWhere[#self.deleteWhere + 1] = string.gsub(key, '?', "\""..value.."\"");
		return self;
	end;
	function MYSQL_DELETE_CLASS:SetCallback(Callback)
		self.Callback = Callback;
		return self;
	end;
	function MYSQL_DELETE_CLASS:SetFlag(value)
		self.Flag = value;
		return self;
	end;
	function MYSQL_DELETE_CLASS:Push()
		if (Clockwork.NoMySQL) then return; end;
		if (!self.tableName) then return; end;
		
		local deleteQuery = "DELETE FROM "..self.tableName;
		local whereTable = {};
		
		for k, v in pairs(self.deleteWhere) do
			whereTable[#whereTable + 1] = v;
		end;
		
		local whereString = table.concat(whereTable, " AND ");
		
		if (whereString != "") then
			Clockwork.database:Query(deleteQuery.." WHERE "..whereString, self.Callback, self.Flag);
		else
			Clockwork.database:Query(deleteQuery, self.Callback, self.Flag);
		end;
	end;
	function Clockwork.database:Update(tableName)
		local object = Clockwork.kernel:NewMetaTable(MYSQL_UPDATE_CLASS);
		object.updateVars = {};
		object.updateWhere = {};
		object.tableName = tableName;
		return object;
	end;
	function Clockwork.database:Insert(tableName)
		local object = Clockwork.kernel:NewMetaTable(MYSQL_INSERT_CLASS);
		object.insertVars = {};
		object.tableName = tableName;
		return object;
	end;
	function Clockwork.database:Select(tableName)
		local object = Clockwork.kernel:NewMetaTable(MYSQL_SELECT_CLASS);
		object.selectColumns = {};
		object.selectWhere = {};
		object.selectOrder = "";
		object.tableName = tableName;
		return object;
	end;
	function Clockwork.database:Delete(tableName)
		local object = Clockwork.kernel:NewMetaTable(MYSQL_DELETE_CLASS);
		object.deleteWhere = {};
		object.tableName = tableName;
		return object;
	end;
	function Clockwork.database:Error(text) end;
	function Clockwork.database:Query(query, Callback, flag, bRawQuery)
		if (Clockwork.NoMySQL) then
			MsgN("[Clockwork] Cannot run a database query with no connection!");
			return;
		end;
		
		if (self.MDB) then
			local sqlObject = self.MDB:query(query);
			
			sqlObject:setOption(mysqloo.OPTION_NAMED_FIELDS);
			
			function sqlObject.onSuccess(sqlObject, data)
				if (Callback and !bRawQuery) then
					Callback(data, sqlObject:lastInsert());
				end;
			end;
		
			function sqlObject.onError(sqlObject, errorText)
				local databaseStatus = self.MDB:status();
				if (databaseStatus == mysqloo.DATABASE_NOT_CONNECTED) then
					table.insert(self.runQueue, {query, Callback, bRawQuery});
					self.MDB:connect();
				end;
				
				if (errorText) then
					MsgN(errorText);
				end;
			end;
		
			sqlObject:start();
			
			return;
		end;
		
		if (!bRawQuery) then
			if (self.liteSql) then
				local data = sql.Query(query);
				local lastError = sql.LastError();
			
				if (lastError) then
					MsgN(query);
					MsgN(lastError);
				end;
		
				if (data == false) then
					Clockwork.database:Error(lastError);
					return;
				end;
		
				if (Callback) then
					Callback(data, lastError, tonumber(sql.QueryValue("SELECT last_insert_rowid()")))
				end
			else
				tmysql.query(query, function(result, status, text, other)
				--MsgN("[Clockwork] Result: "..tostring(result).." Status: "..tostring(status).." Text: "..tostring(text).." Other: "..tostring(other));
					if (Callback) then
						Callback(result, status, text);
					end;
				end, (flag or 1));
			end;
		elseif (self.liteSql) then
			local data = sql.Query(query);
				
			if (data == false) then
				MsgN(query);
				MsgN(sql.LastError());
			end;
		else
			tmysql.query(query, function(result, status, text, other)
				--MsgN("[Clockwork] Result: "..tostring(result).." Status: "..tostring(status).." Text: "..tostring(text).." Other: "..tostring(other));
			end);
		end;
	end;
	function Clockwork.database:IsResult(result)
		return (result and type(result) == "table" and #result > 0);
	end;
	function Clockwork.database:Escape(text)
		if (self.MDB) then
			return self.MDB:escape(text);
		elseif (self.liteSql) then
			return sql.SQLStr(string.Replace(text, '"', '""'), true);
		else
			return tmysql.escape(text);
		end;
	end;
	function Clockwork.database:OnConnected()
		local BANS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_bans_table"):Get()..[[` (
		`_Key` int(11) NOT NULL AUTO_INCREMENT,
		`_Identifier` text NOT NULL,
		`_UnbanTime` int(11) NOT NULL,
		`_SteamName` varchar(150) NOT NULL,
		`_Duration` int(11) NOT NULL,
		`_Reason` text NOT NULL,
		`_Schema` text NOT NULL,
		PRIMARY KEY (`_Key`));
		]];
		
		local LITE_BANS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_bans_table"):Get()..[[` (
		`_Key` INTEGER PRIMARY KEY AUTOINCREMENT,
		`_Identifier` TEXT,
		`_UnbanTime` INTEGER,
		`_SteamName` TEXT,
		`_Duration` INTEGER,
		`_Reason` TEXT,
		`_Schema` TEXT);
		]];
		
		local CHARACTERS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_characters_table"):Get()..[[` (
		`_Key` smallint(11) NOT NULL AUTO_INCREMENT,
		`_Data` text NOT NULL,
		`_Name` varchar(150) NOT NULL,
		`_Ammo` text NOT NULL,
		`_Cash` varchar(150) NOT NULL,
		`_Model` varchar(250) NOT NULL,
		`_Flags` text NOT NULL,
		`_Schema` text NOT NULL,
		`_Gender` varchar(50) NOT NULL,
		`_Faction` varchar(50) NOT NULL,
		`_SteamID` varchar(60) NOT NULL,
		`_SteamName` varchar(150) NOT NULL,
		`_Inventory` text NOT NULL,
		`_OnNextLoad` text NOT NULL,
		`_Attributes` text NOT NULL,
		`_LastPlayed` varchar(50) NOT NULL,
		`_TimeCreated` varchar(50) NOT NULL,
		`_CharacterID` varchar(50) NOT NULL,
		`_RecognisedNames` text NOT NULL,
		PRIMARY KEY (`_Key`));
		]];
		
		local LITE_CHARACTERS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_characters_table"):Get()..[[` (
		`_Key` INTEGER PRIMARY KEY AUTOINCREMENT,
		`_Data` TEXT,
		`_Name` TEXT,
		`_Ammo` TEXT,
		`_Cash` INTEGER,
		`_Model` TEXT,
		`_Flags` TEXT,
		`_Schema` TEXT,
		`_Gender` TEXT,
		`_Faction` TEXT,
		`_SteamID` TEXT,
		`_SteamName` TEXT,
		`_Inventory` TEXT,
		`_OnNextLoad` TEXT,
		`_Attributes` TEXT,
		`_LastPlayed` INTEGER,
		`_TimeCreated` INTEGER,
		`_CharacterID` INTEGER,
		`_RecognisedNames` TEXT);
		]];
		local PLAYERS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_players_table"):Get()..[[` (
		`_Key` smallint(11) NOT NULL AUTO_INCREMENT,
		`_Data` text NOT NULL,
		`_Schema` text NOT NULL,
		`_SteamID` varchar(60) NOT NULL,
		`_Donations` text NOT NULL,
		`_UserGroup` text NOT NULL,
		`_IPAddress` varchar(50) NOT NULL,
		`_SteamName` varchar(150) NOT NULL,
		`_OnNextPlay` text NOT NULL,
		`_LastPlayed` varchar(50) NOT NULL,
		`_TimeJoined` varchar(50) NOT NULL,
		PRIMARY KEY (`_Key`));
		]];
		
		local LITE_PLAYERS_TABLE_QUERY = [[
		CREATE TABLE IF NOT EXISTS `]]..Clockwork.config:Get("mysql_players_table"):Get()..[[` (
		`_Key` INTEGER PRIMARY KEY AUTOINCREMENT,
		`_Data` TEXT,
		`_Schema` TEXT,
		`_SteamID` TEXT,
		`_Donations` TEXT,
		`_UserGroup` TEXT,
		`_IPAddress` TEXT,
		`_SteamName` TEXT,
		`_OnNextPlay` TEXT,
		`_LastPlayed` INTEGER,
		`_TimeJoined` INTEGER);
		]];
		if (self.liteSql) then
			self:Query(string.gsub(LITE_BANS_TABLE_QUERY, "%s", " "), nil, nil, true);
			self:Query(string.gsub(LITE_CHARACTERS_TABLE_QUERY, "%s", " "), nil, nil, true);
			self:Query(string.gsub(LITE_PLAYERS_TABLE_QUERY, "%s", " "), nil, nil, true);
		else
			self:Query(string.gsub(BANS_TABLE_QUERY, "%s", " "), nil, nil, true);
			self:Query(string.gsub(CHARACTERS_TABLE_QUERY, "%s", " "), nil, nil, true);
			self:Query(string.gsub(PLAYERS_TABLE_QUERY, "%s", " "), nil, nil, true);
		end;
		
		Clockwork.NoMySQL = false;
		Clockwork.plugin:Call("ClockworkDatabaseConnected");
		
		if (self.MDB) then
			for k, v in pairs(self.runQueue) do
				self:Query(v[1], v[2], nil, v[3]);
			end;
			self.runQueue = {};
		end;
	end;
	function Clockwork.database:OnConnectionFailed(errText)
		ErrorNoHalt("Clockwork::Database - "..errText.."\n");
		Clockwork.NoMySQL = errText;
		Clockwork.plugin:Call("ClockworkDatabaseConnectionFailed", errText);
	end;
	function Clockwork.database:Connect(host, username, password, database, port)
		if (host == "example.com") then
			ErrorNoHalt("[Clockwork] No MySQL details found. Connecting to database using SQLite...\n");
			
			self.liteSql = true;
			self:OnConnected();
			return;
		end;
		
		if (host == "localhost") then
			host = "127.0.0.1";
		end;
		
		if (system.IsLinux() and mysqloo) then
			self.MDB = mysqloo.connect(host, username, password, database, port);
			
			ErrorNoHalt("[Clockwork] Connecting to database using MySQLOO...\n");
			
			function self.MDB.onConnected(db)
				Clockwork.database:OnConnected();
			end;
			function self.MDB.onConnectionFailed(db, errText)
				Clockwork.database:OnConnectionFailed(errText);
			end;
			
			self.MDB:connect();
			
			return;
		end;
		
		local success, databaseConnection, errText = pcall(tmysql.initialize, host, username, password, database, port);
		
		ErrorNoHalt("[Clockwork] Connecting to database using tmysql4...\n");
		if (databaseConnection) then
			self:OnConnected();
		else
			self:OnConnectionFailed(errText);
		end;
	end;
	Clockwork.chatBox.multiplier = nil;
	function Clockwork.chatBox:Add(listeners, speaker, class, text, data)
		if (type(listeners) != "table") then
			if (!listeners) then
				listeners = cwPlayer.GetAll();
			else
				listeners = {listeners};
			end;
		end;
		
		local info = {
			bShouldSend = true,
			multiplier = self.multiplier,
			listeners = listeners,
			speaker = speaker,
			class = class,
			text = text,
			data = data
		};
		
		if (type(info.data) != "table") then
			info.data = {info.data};
		end;
		
		Clockwork.plugin:Call("ChatBoxAdjustInfo", info);
		Clockwork.plugin:Call("ChatBoxMessageAdded", info);
		
		if (info.bShouldSend) then
			if (IsValid(info.speaker)) then
				Clockwork.datastream:Start(info.listeners, "ChatBoxPlayerMessage", {
				multiplier = info.multiplier,
				speaker = info.speaker,
				class = info.class,
				text = info.text,
				data = info.data
				});
			else
				Clockwork.datastream:Start(info.listeners, "ChatBoxMessage", {
				multiplier = info.multiplier,
				class = info.class,
				text = info.text,
				data = info.data
				});
			end;
		end;
		
		self.multiplier = nil;
		return info;
	end;
	function Clockwork.chatBox:AddInTargetRadius(speaker, class, text, position, radius, data)
		local listeners = {};
		
		for k, v in pairs(cwPlayer.GetAll()) do
			if (v:HasInitialized()) then
				if (Clockwork.player:GetRealTrace(v).HitPos:Distance(position) <= (radius / 2) or position:Distance(v:GetPos()) <= radius) then
					listeners[#listeners + 1] = v;
				end;
			end;
		end;
		self:Add(listeners, speaker, class, text, data);
	end;
	function Clockwork.chatBox:AddInRadius(speaker, class, text, position, radius, data)
		local listeners = {};
		
		for k, v in pairs(cwPlayer.GetAll()) do
			if (v:HasInitialized()) then
				if (position:Distance(v:GetPos()) <= radius) then
					listeners[#listeners + 1] = v;
				end;
			end;
		end;
		self:Add(listeners, speaker, class, text, data);
	end;
	function Clockwork.chatBox:SendColored(listeners, ...)
		Clockwork.datastream:Start(listeners, "ChatBoxColorMessage", {...});
	end;
	function Clockwork.chatBox:SetMultiplier(multiplier)
		self.multiplier = multiplier;
	end;
	function Clockwork.player:RestoreData(player, data)
		for k, v in pairs(data) do
			self:UpdatePlayerData(player, k, v);
		end;
		for k, v in pairs(self.playerData) do
			if (data[k] == nil) then
				player:SetData(k, v.default);
			end;
		end;
	end;
	function Clockwork.player:RestoreCharacterData(player, data)
		for k, v in pairs(data) do
			self:UpdateCharacterData(player, k, v);
		end;
		
		for k, v in pairs(self.characterData) do
			if (data[k] == nil) then
				player:SetCharacterData(k, v.default);
			end;
		end;
	end;
	function Clockwork.player:UpdateCharacterData(player, key, value)
		local characterData = self.characterData;
		if (characterData[key]) then
			if (characterData[key].callback) then
				value = characterData[key].callback(player, value);
			end;
			player:SetSharedVar(key, value);
		end;
	end;
	function Clockwork.player:UpdatePlayerData(player, key, value)
		local playerData = self.playerData;
		if (playerData[key]) then
			if (playerData[key].callback) then
				value = playerData[key].callback(player, value);
			end;
			player:SetSharedVar(key, value);
		end;
	end;
	Clockwork.lang.fileList = {};
	function Clockwork.lang:Add(language, fileName)
		if (not self.fileList[language]) then
			self.fileList[language] = {};
		end;
		
		table.insert(self.fileList[language], fileName);
	end;
	function Clockwork.lang:Set(language) end;
	function Clockwork.inventory:SendUpdateByInstance(player, itemTable)
		if (itemTable) then
			Clockwork.datastream:Start(player, "InvUpdate", {Clockwork.item:GetDefinition(itemTable, true)});
		end;
	end;
	function Clockwork.inventory:SendUpdateAll(player)
		local inventory = player:GetInventory();
		
		for k, v in pairs(inventory) do
			self:SendUpdateByID(player, k);
		end;
	end;
	function Clockwork.inventory:SendUpdateByID(player, uniqueID)
		local itemTables = self:GetItemsByID(player:GetInventory(), uniqueID);
		
		if (itemTables) then
			local definitions = {};
			
			for k, v in pairs(itemTables) do
				definitions[#definitions + 1] = Clockwork.item:GetDefinition(v, true);
			end;
			
			Clockwork.datastream:Start(player, "InvUpdate", definitions);
		end;
	end;
	function Clockwork.inventory:Rebuild(player)
		Clockwork.kernel:OnNextFrame("RebuildInv"..player:UniqueID(), function()
			if (IsValid(player)) then
				Clockwork.datastream:Start(player, "InvRebuild");
			end;
		end);
	end;
	_player, _team, _file = player, team, file;
	json = {};
	local array_mt = {};
	local null = {};
	if getmetatable and getmetatable(null) then
		getmetatable(null).__tostring = function() return "null"; end;
	end
	json.null = null;
	local escapes = {
		["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b",
		["\f"] = "\\f", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t"};
	local unescapes = {
		["\""] = "\"", ["\\"] = "\\", ["/"] = "/",
		b = "\b", f = "\f", n = "\n", r = "\r", t = "\t"};
	for i=0,31 do
		local ch = string.char(i);
		if not escapes[ch] then escapes[ch] = ("\\u%.4X"):format(i); end
	end
	local function codepoint_to_utf8(code)
		if code < 0x80 then return string.char(code); end
		local bits0_6 = code % 64;
		if code < 0x800 then
			local bits6_5 = (code - bits0_6) / 64;
			return string.char(0x80 + 0x40 + bits6_5, 0x80 + bits0_6);
		end
		local bits0_12 = code % 4096;
		local bits6_6 = (bits0_12 - bits0_6) / 64;
		local bits12_4 = (code - bits0_12) / 4096;
		return string.char(0x80 + 0x40 + 0x20 + bits12_4, 0x80 + bits6_6, 0x80 + bits0_6);
	end
	local valid_types = {
		number = true,
		string = true,
		table = true,
		boolean = true
	};
	local special_keys = {
		__array = true;
		__hash = true;
	};
	local simplesave, tablesave, arraysave, stringsave;
	function stringsave(o, buffer)
		table.insert(buffer, "\""..(o:gsub(".", escapes)).."\"");
	end
	function arraysave(o, buffer)
		table.insert(buffer, "[");
		if next(o) then
			for i,v in ipairs(o) do
				simplesave(v, buffer);
				table.insert(buffer, ",");
			end
			table.remove(buffer);
		end
		table.insert(buffer, "]");
	end
	function tablesave(o, buffer)
		local __array = {};
		local __hash = {};
		local hash = {};
		for i,v in ipairs(o) do
			__array[i] = v;
		end
		for k,v in pairs(o) do
			local ktype, vtype = type(k), type(v);
			if valid_types[vtype] or v == null then
				if ktype == "string" and not special_keys[k] then
					hash[k] = v;
				elseif (valid_types[ktype] or k == null) and __array[k] == nil then
					__hash[k] = v;
				end
			end
		end
		if next(__hash) ~= nil or next(hash) ~= nil or next(__array) == nil then
			table.insert(buffer, "{");
			local mark = #buffer;
			if buffer.ordered then
				local keys = {};
				for k in pairs(hash) do
					table.insert(keys, k);
				end
				table.sort(keys);
				for _,k in ipairs(keys) do
					stringsave(k, buffer);
					table.insert(buffer, ":");
					simplesave(hash[k], buffer);
					table.insert(buffer, ",");
				end
			else
				for k,v in pairs(hash) do
					stringsave(k, buffer);
					table.insert(buffer, ":");
					simplesave(v, buffer);
					table.insert(buffer, ",");
				end
			end
			if next(__hash) ~= nil then
				table.insert(buffer, "\"__hash\":[");
				for k,v in pairs(__hash) do
					simplesave(k, buffer);
					table.insert(buffer, ",");
					simplesave(v, buffer);
					table.insert(buffer, ",");
				end
				table.remove(buffer);
				table.insert(buffer, "]");
				table.insert(buffer, ",");
			end
			if next(__array) then
				table.insert(buffer, "\"__array\":");
				arraysave(__array, buffer);
				table.insert(buffer, ",");
			end
			if mark ~= #buffer then table.remove(buffer); end
			table.insert(buffer, "}");
		else
			arraysave(__array, buffer);
		end
	end
	function simplesave(o, buffer)
		local t = type(o);
		if t == "number" then
			table.insert(buffer, tostring(o));
		elseif t == "string" then
			stringsave(o, buffer);
		elseif t == "table" then
			local mt = getmetatable(o);
			if mt == array_mt then
				arraysave(o, buffer);
			else
				tablesave(o, buffer);
			end
		elseif t == "boolean" then
			table.insert(buffer, (o and "true" or "false"));
		else
			table.insert(buffer, "null");
		end
	end
	function json.encode(obj)
		local t = {};
		simplesave(obj, t);
		return table.concat(t);
	end
	function json.encode_ordered(obj)
		local t = { ordered = true };
		simplesave(obj, t);
		return table.concat(t);
	end
	function json.encode_array(obj)
		local t = {};
		arraysave(obj, t);
		return table.concat(t);
	end
	local function _skip_whitespace(json, index)
		return json:find("[^ \t\r\n]", index) or index;
	end
	local function _fixobject(obj)
		local __array = obj.__array;
		if __array then
			obj.__array = nil;
			for i,v in ipairs(__array) do
				table.insert(obj, v);
			end
		end
		local __hash = obj.__hash;
		if __hash then
			obj.__hash = nil;
			local k;
			for i,v in ipairs(__hash) do
				if k ~= nil then
					obj[k] = v; k = nil;
				else
					k = v;
				end
			end
		end
		return obj;
	end
	local _readvalue, _readstring;
	local function _readobject(json, index)
		local o = {};
		while true do
			local key, val;
			index = _skip_whitespace(json, index + 1);
			if json:byte(index) ~= 0x22 then
				if json:byte(index) == 0x7d then return o, index + 1; end
				return nil, "key expected";
			end
			key, index = _readstring(json, index);
			if key == nil then return nil, index; end
			index = _skip_whitespace(json, index);
			if json:byte(index) ~= 0x3a then return nil, "colon expected"; end
			val, index = _readvalue(json, index + 1);
			if val == nil then return nil, index; end
			o[key] = val;
			index = _skip_whitespace(json, index);
			local b = json:byte(index);
			if b == 0x7d then return _fixobject(o), index + 1; end
			if b ~= 0x2c then return nil, "object eof"; end
		end
	end
	local function _readarray(json, index)
		local a = {};
		local oindex = index;
		while true do
			local val;
			val, index = _readvalue(json, index + 1);
			if val == nil then
			if json:byte(oindex + 1) == 0x5d then return setmetatable(a, array_mt), oindex + 2; end
				return val, index;
			end
			table.insert(a, val);
			index = _skip_whitespace(json, index);
			local b = json:byte(index);
			if b == 0x5d then return setmetatable(a, array_mt), index + 1; end
			if b ~= 0x2c then return nil, "array eof"; end
		end
	end
	local _unescape_error;
	local function _unescape_surrogate_func(x)
		local lead, trail = tonumber(x:sub(3, 6), 16), tonumber(x:sub(9, 12), 16);
		local codepoint = lead * 0x400 + trail - 0x35FDC00;
		local a = codepoint % 64;
		codepoint = (codepoint - a) / 64;
		local b = codepoint % 64;
		codepoint = (codepoint - b) / 64;
		local c = codepoint % 64;
		codepoint = (codepoint - c) / 64;
		return string.char(0xF0 + codepoint, 0x80 + c, 0x80 + b, 0x80 + a);
	end
	local function _unescape_func(x)
		x = x:match("%x%x%x%x", 3);
		if x then
			return codepoint_to_utf8(tonumber(x, 16));
		end
		_unescape_error = true;
	end
	function _readstring(json, index)
		index = index + 1;
		local endindex = json:find("\"", index, true);
		if endindex then
			local s = json:sub(index, endindex - 1);
			_unescape_error = nil;
			s = s:gsub("\\u.?.?.?.?", _unescape_func);
			if _unescape_error then return nil, "invalid escape"; end
			return s, endindex + 1;
		end
		return nil, "string eof";
	end
	local function _readnumber(json, index)
		local m = json:match("[0-9%.%-eE%+]+", index);
		return tonumber(m), index + #m;
	end
	local function _readnull(json, index)
		local a, b, c = json:byte(index + 1, index + 3);
		if a == 0x75 and b == 0x6c and c == 0x6c then
			return null, index + 4;
		end
		return nil, "null parse failed";
	end
	local function _readtrue(json, index)
		local a, b, c = json:byte(index + 1, index + 3);
		if a == 0x72 and b == 0x75 and c == 0x65 then
			return true, index + 4;
		end
		return nil, "true parse failed";
	end
	local function _readfalse(json, index)
		local a, b, c, d = json:byte(index + 1, index + 4);
		if a == 0x61 and b == 0x6c and c == 0x73 and d == 0x65 then
			return false, index + 5;
		end
		return nil, "false parse failed";
	end
	function _readvalue(json, index)
		index = _skip_whitespace(json, index);
		local b = json:byte(index);
		if b == 0x7B then
			return _readobject(json, index);
		elseif b == 0x5B then
			return _readarray(json, index);
		elseif b == 0x22 then
			return _readstring(json, index);
		elseif b ~= nil and b >= 0x30 and b <= 0x39 or b == 0x2d then
			return _readnumber(json, index);
		elseif b == 0x6e then
			return _readnull(json, index);
		elseif b == 0x74 then
			return _readtrue(json, index);
		elseif b == 0x66 then
			return _readfalse(json, index);
		else
			return nil, "value expected";
		end
	end
	local first_escape = {
		["\\\""] = "\\u0022";
		["\\\\"] = "\\u005c";
		["\\/" ] = "\\u002f";
		["\\b" ] = "\\u0008";
		["\\f" ] = "\\u000C";
		["\\n" ] = "\\u000A";
		["\\r" ] = "\\u000D";
		["\\t" ] = "\\u0009";
		["\\u" ] = "\\u";
	};
	function json.decode(json)
		json = json:gsub("\\.", first_escape)
		local val, index = _readvalue(json, 1);
		if val == nil then return val, index; end
		if json:find("[^ \t\r\n]", index) then return nil, "garbage at eof"; end
		return val;
	end
	util.JSONToTable = json.decode;
	util.TableToJSON = json.encode;
	MsgN("[CloudAuthX] The externals have been loaded successfully.");
	Clockwork.kernel:AddFile("materials/clockwork/logo/002.png");
	CLOCKWORK_LOGO_PLUGIN = {};
	function CLOCKWORK_LOGO_PLUGIN:PlayerDataLoaded(player)
		Clockwork.datastream:Start(player, "WebIntroduction", true);
		player:SetData("ClockworkIntro", true);
	end;
	Clockwork.plugin:Add("ClockworkLogoPlugin", CLOCKWORK_LOGO_PLUGIN);
	local cax_override = nil;
	local didGamenameOverride = false;
	function SetModuleNameCAX(description)
		function Clockwork:GetGameDescription()
			return "PostBellum "..description;
		end;
		
		if (GM) then
			function GM:GetGameDescription()
				return "PostBellum "..description;
			end;
		end;
		
		if (GAMEMODE) then
			function GAMEMODE:GetGameDescription()
				return "PostBellum "..description;
			end;
		end;
		
		if (not didGamenameOverride) then
			RunConsoleCommand("sv_gamename_override", "PostBellum "..description);
			didGamenameOverride = true;
		end;
	end;
	if (cax_override) then
		Clockwork.Name = cax_override;
		
		hook.Add("Think", "cw.GetGameDescription", function()
			SetModuleNameCAX(cax_override);
		end);
		
		SetModuleNameCAX(cax_override);
	else
		hook.Add("Think", "cw.GetGameDescription", function()
			SetModuleNameCAX(Clockwork.kernel:GetSchemaGamemodeName());
		end);
		
		SetModuleNameCAX(Clockwork.kernel:GetSchemaGamemodeName());
	end;
end;