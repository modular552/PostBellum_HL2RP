--[[ 
	© 2015 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).

	Clockwork was created by Conna Wiles (also known as kurozael.)
	http://cloudsixteen.com/license/clockwork.html
--]]

--[[ Initiate the shared booting process. --]]
include("sh_boot.lua");

--[[ 
	Micro-optimizations.
	We do this because local variables are faster to access than global ones.
--]]
local Clockwork = Clockwork;
local RunConsoleCommand = RunConsoleCommand;
local DeriveGamemode = DeriveGamemode;
local FindMetaTable = FindMetaTable;
local AddCSLuaFile = AddCSLuaFile;
local ErrorNoHalt = ErrorNoHalt;
local FrameTime = FrameTime;
local tonumber = tonumber;
local tostring = tostring;
local SysTime = SysTime;
local CurTime = CurTime;
local IsValid = IsValid;
local unpack = unpack;
local Vector = Vector;
local Angle = Angle;
local Color = Color;
local pairs = pairs;
local pcall = pcall;
local print = print;
local concommand = concommand;
local player = player;
local timer = timer;
local table = table;
local ents = ents;
local hook = hook;
local math = math;
local game = game;
local os = os;

--[[ Clockwork Library Localizations --]]
local cwConfig = Clockwork.config;
local cwPly = Clockwork.player;
local cwPlugin = Clockwork.plugin;
local cwStorage = Clockwork.storage;
local cwEvent = Clockwork.event;
local cwLimb = Clockwork.limb;
local cwItem = Clockwork.item;
local cwEntity = Clockwork.entity;
local cwKernel = Clockwork.kernel;
local cwOption = Clockwork.option;
local cwBans = Clockwork.bans;
local cwDatabase = Clockwork.database;
local cwDatastream = Clockwork.datastream;
local cwFaction = Clockwork.faction;
local cwInventory = Clockwork.inventory;
local cwHint = Clockwork.hint;
local cwCommand = Clockwork.command;
local cwClass = Clockwork.class;
local cwQuiz = Clockwork.quiz;
local cwAttribute = Clockwork.attribute;
local cwAttributes = Clockwork.attributes;
local cwVoice = Clockwork.voice;
local cwChatbox = Clockwork.chatBox;

--[[ Downloads the content addon for clients. --]]
resource.AddWorkshop("474315121")

--[[ Do this internally, because it's one less step for schemas. --]]
AddCSLuaFile(
	cwKernel:GetSchemaGamemodePath().."/cl_init.lua"
);

--[[
	Derive from Sandbox, because we want the spawn menu and such!
	We also want the base Sandbox entities and weapons.
--]]
DeriveGamemode("sandbox");

--[[
	This is a hack to stop file.Read returning an unnecessary newline
	at the end of each file when using Linux.
--]]
if (system.IsLinux()) then
	local ClockworkFileRead = file.Read;

	function file.Read(fileName, pathName)
		local contents = ClockworkFileRead(fileName, pathName);
		
		if (contents and string.utf8sub(contents, -1) == "\n") then
			contents = string.utf8sub(contents, 1, -2);
		end;
		
		return contents;
	end;
end;

--[[
	This is a hack to allow us to call plugin hooks based
	on default GMod hooks that are called.

	It modifies the hook.Call funtion to call hooks inside Clockwork plugins
	as well as hooks that are added normally with hook.Add.
--]]
hook.ClockworkCall = hook.ClockworkCall or hook.Call;
hook.Timings = hook.Timings or {};
hook.Averages = hook.Averages or {};

function hook.Call(name, gamemode, ...)
	local arguments = {...};
	
	if (name == "EntityTakeDamage") then
		if (cwKernel:DoEntityTakeDamageHook(arguments)) then
			return;
		end;
	elseif (name == "PlayerDisconnected") then
		if (!IsValid(arguments[1])) then
			return;
		end;
	end;
	
	local startTime = SysTime();
		local bStatus, value = pcall(cwPlugin.RunHooks, cwPlugin, name, nil, unpack(arguments));
	local timeTook = SysTime() - startTime;
	
	hook.Timings[name] = timeTook;

	if (!bStatus) then
		if (!Clockwork.Unauthorized) then
			MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Kernel]\nThe '"..name.."' hook has failed to run.\n"..value.."\n");
		end;
	end;
	
	if (value == nil or name == THINK_NAME) then
		local startTime = SysTime();
			local bStatus, a, b, c = pcall(hook.ClockworkCall, name, gamemode or Clockwork, unpack(arguments));
		local timeTook = SysTime() - startTime;
		
		hook.Timings[name] = timeTook;
		
		if (!bStatus) then
			if (!Clockwork.Unauthorized) then
				MsgC(Color(255, 100, 0, 255), "\n[Clockwork:Kernel]\nThe '"..name.."' hook failed to run.\n"..a.."\n");
			end;
		else
			return a, b, c;
		end;
	else
		return value;
	end;
end;

--[[
	@codebase Server
	@details Called when the Clockwork kernel has loaded.
--]]
function Clockwork:ClockworkKernelLoaded() end;

--[[
	@codebase Server
	@details Called when the Clockwork schema has loaded.
--]]
function Clockwork:ClockworkSchemaLoaded() end;

--[[
	@codebase Server
	@details Called when the server has initialized.
--]]
function Clockwork:Initialize()
	cwItem:Initialize();
		cwConfig:Import("gamemodes/clockwork/clockwork.cfg");
	cwPlugin:Call("ClockworkKernelLoaded");
	
	local useLocalMachineDate = cwConfig:Get("use_local_machine_date"):Get();
	local useLocalMachineTime = cwConfig:Get("use_local_machine_time"):Get();
	local defaultDate = cwOption:GetKey("default_date");
	local defaultTime = cwOption:GetKey("default_time");
	local defaultDays = cwOption:GetKey("default_days");
	local username = cwConfig:Get("mysql_username"):Get();
	local password = cwConfig:Get("mysql_password"):Get();
	local database = cwConfig:Get("mysql_database"):Get();
	local dateInfo = os.date("*t");
	local host = string.gsub(cwConfig:Get("mysql_host"):Get(), "^http[s]?://", "", 1); -- Matches at beginning of string, matches http:// or https://, no need to check twice
	local port = cwConfig:Get("mysql_port"):Get();
	
	cwDatabase:Connect(host, username, password, database, port);
	
	if (useLocalMachineTime) then
		cwConfig:Get("minute_time"):Set(60);
	end;
	
	cwConfig:SetInitialized(true);
	
	table.Merge(self.time, defaultTime);
	table.Merge(self.date, defaultDate);
	math.randomseed(os.time());
	
	if (useLocalMachineTime) then
		local realDay = dateInfo.wday - 1;
		
		if (realDay == 0) then
			realDay = #defaultDays;
		end;
		
		table.Merge(self.time, {
			minute = dateInfo.min,
			hour = dateInfo.hour,
			day = realDay
		});
		
		self.NextDateTimeThink = SysTime() + (60 - dateInfo.sec);
	else
		table.Merge(self.time, cwKernel:RestoreSchemaData("time"));
	end;
	
	if (useLocalMachineDate) then
		dateInfo.year = dateInfo.year + (defaultDate.year - dateInfo.year);

		table.Merge(self.time, {
			month = dateInfo.month,
			year = dateInfo.year,
			day = dateInfo.yday
		});
	else
		table.Merge(self.date, cwKernel:RestoreSchemaData("date"));
	end;
	
	CW_CONVAR_LOG = cwKernel:CreateConVar("cwLog", 1);
	
	for k, v in pairs(cwConfig.stored) do
		cwPlugin:Call("ClockworkConfigInitialized", k, v.value);
	end;
	
	cwPlugin:Call("ClockworkInitialized");
	cwPlugin:CheckMismatches();
	cwPlugin:ClearHookCache();

	hook.Remove("PlayerTick", "TickWidgets")

	--[[ Hotfix to allow downloads ]]--
	hook.Remove("Think", "exploit.fix");
	RunConsoleCommand("sv_allowdownload", "1");
end;

-- Called at an interval while a player is connected.
function Clockwork:PlayerThink(player, curTime, infoTable)
	local bPlayerBreathSnd = false;
	local storageTable = player:GetStorageTable();
	
	if (!cwConfig:Get("cash_enabled"):Get()) then
		player:SetCharacterData("Cash", 0, true);
		infoTable.wages = 0;
	end;
	
	if (player.cwReloadHoldTime and curTime >= player.cwReloadHoldTime) then
		cwPly:ToggleWeaponRaised(player);
		player.cwReloadHoldTime = nil;
		player.cwNextShootTime = curTime + cwConfig:Get("shoot_after_raise_time"):Get();
	end;
	
	if (player:IsRagdolled()) then
		player:SetMoveType(MOVETYPE_OBSERVER);
	end;
	
	if (storageTable and cwPlugin:Call("PlayerStorageShouldClose", player, storageTable)) then
		cwStorage:Close(player);
	end;
	
	player:SetSharedVar("InvWeight", math.ceil(infoTable.inventoryWeight));
	player:SetSharedVar("InvSpace", math.ceil(infoTable.inventorySpace));
	player:SetSharedVar("Wages", math.ceil(infoTable.wages));
	
	if (cwEvent:CanRun("limb_damage", "disability")) then
		local leftLeg = cwLimb:GetDamage(player, HITGROUP_LEFTLEG, true);
		local rightLeg = cwLimb:GetDamage(player, HITGROUP_RIGHTLEG, true);
		local legDamage = math.max(leftLeg, rightLeg);
		
		if (legDamage > 0) then
			infoTable.runSpeed = infoTable.runSpeed / (1 + legDamage);
			infoTable.jumpPower = infoTable.jumpPower / (1 + legDamage);
		end;
	end;
	
	if (player:KeyDown(IN_BACK)) then
		infoTable.runSpeed = infoTable.runSpeed * 0.5;
	end;
	
	if (infoTable.isJogging) then
		infoTable.walkSpeed = infoTable.walkSpeed * 1.75;
	end;
	
	if (infoTable.runSpeed < infoTable.walkSpeed) then
		infoTable.runSpeed = infoTable.walkSpeed;
	end;
	
	if (cwPlugin:Call("PlayerShouldSmoothSprint", player, infoTable)) then
		--[[ The target run speed is what we're aiming for! --]]
		player.cwTargetRunSpeed = infoTable.runSpeed;
		
		--[[
			Lerp the walk and run speeds so that it doesn't seem so
			instantanious. Otherwise it looks like your characters are
			on crack.
		--]]
		
		if (!player.cwLastRunSpeed) then
			player.cwLastRunSpeed = infoTable.walkSpeed;
		end;
		
		if (player:IsRunning(true)) then
			player.cwLastRunSpeed = math.Approach(
				player.cwLastRunSpeed, infoTable.runSpeed, player.cwLastRunSpeed * 0.3
			);
		else
			player.cwLastRunSpeed = math.Approach(
				player.cwLastRunSpeed, infoTable.walkSpeed, player.cwLastRunSpeed * 0.3
			);
		end;
		
		infoTable.runSpeed = player.cwLastRunSpeed;
	end;
	
	--[[ Update whether the weapon has fired, or is being raised. --]]
	player:UpdateWeaponFired(); player:UpdateWeaponRaised();
	player:SetSharedVar("IsRunMode", infoTable.isRunning);
	
	player:SetCrouchedWalkSpeed(math.max(infoTable.crouchedSpeed, 0), true);
	player:SetWalkSpeed(math.max(infoTable.walkSpeed, 0), true);
	player:SetJumpPower(math.max(infoTable.jumpPower, 0), true);
	player:SetRunSpeed(math.max(infoTable.runSpeed, 0), true);
	
	local activeWeapon = player:GetActiveWeapon();
	local weaponItemTable = cwItem:GetByWeapon(activeWeapon);
	
	if (weaponItemTable and weaponItemTable:IsInstance()) then
		local clipOne = activeWeapon:Clip1();
		local clipTwo = activeWeapon:Clip2();
		
		if (clipOne >= 0) then
			weaponItemTable:SetData("ClipOne", clipOne);
		end;
		
		if (clipTwo >= 0) then
			weaponItemTable:SetData("ClipTwo", clipTwo);
		end;
	end;
	
	if (!player:KeyDown(IN_SPEED)) then return; end;
	
	local traceLine = player:GetEyeTraceNoCursor();
	local velocity = player:GetVelocity():Length();
	local entity = traceLine.Entity;
		
	if (traceLine.HitPos:Distance(player:GetShootPos()) > math.max(48, math.min(velocity, 256))
	or !IsValid(entity)) then
		return;
	end;
	
	if (entity:GetClass() != "prop_door_rotating" or cwPly:IsNoClipping(player)) then
		return;
	end;
	
	local doorPartners = cwEntity:GetDoorPartners(entity);
	
	for k, v in pairs(doorPartners) do
		if ((!cwEntity:IsDoorLocked(v) and cwConfig:Get("bash_in_door_enabled"):Get())
		and (!v.cwNextBashDoor or curTime >= v.cwNextBashDoor)) then
			cwEntity:BashInDoor(v, player);
			
			player:ViewPunch(
				Angle(math.Rand(-32, 32), math.Rand(-80, 80), math.Rand(-16, 16))
			);
		end;
	end;
end;

-- Called when a player should smooth sprint.
function Clockwork:PlayerShouldSmoothSprint(player, infoTable)
	return cwConfig:Get("player_should_smooth_sprint"):GetBoolean();
end;

-- Called when a player fires a weapon.
function Clockwork:PlayerFireWeapon(player, weapon, clipType, ammoType) end;

-- Called when a player has disconnected.
function Clockwork:PlayerDisconnected(player)
	local tempData = player:CreateTempData();
	
	if (player:HasInitialized()) then
		if (cwPlugin:Call("PlayerCharacterUnloaded", player) != true) then
			player:SaveCharacter();
		end;
		
		if (tempData) then
			cwPlugin:Call("PlayerSaveTempData", player, tempData);
		end;
		
		cwKernel:PrintLog(LOGTYPE_MINOR, player:Name().." ("..player:SteamID()..") вышел с сервера.");
		cwChatbox:Add(nil, nil, "disconnect", player:SteamName().." вышел с сервера.");
	end;
end;

-- Called when CloudAuth has been validated.
function Clockwork:CloudAuthValidated() end;

-- Called when CloudAuth has been blacklisted.
function Clockwork:CloudAuthBlacklisted()
	self.Unauthorized = true;
end;

-- Called when Clockwork has initialized.
function Clockwork:ClockworkInitialized()
	local cashName = cwOption:GetKey("name_cash");
	
	if (!cwConfig:Get("cash_enabled"):Get()) then
		cwCommand:SetHidden("Give"..string.gsub(cashName, "%s", ""), true);
		cwCommand:SetHidden("Drop"..string.gsub(cashName, "%s", ""), true);
		cwCommand:SetHidden("StorageTake"..string.gsub(cashName, "%s", ""), true);
		cwCommand:SetHidden("StorageGive"..string.gsub(cashName, "%s", ""), true);
		
		cwConfig:Get("scale_prop_cost"):Set(0, nil, true, true);
		cwConfig:Get("door_cost"):Set(0, nil, true, true);
	end;
	
	if (cwConfig:Get("use_own_group_system"):Get()) then
		cwCommand:SetHidden("PlySetGroup", true);
		cwCommand:SetHidden("PlyDemote", true);
	end;
	
	local gradientTexture = cwOption:GetKey("gradient");
	local schemaLogo = cwOption:GetKey("schema_logo");
	local introImage = cwOption:GetKey("intro_image");

	if (gradientTexture != "gui/gradient_up") then
		cwKernel:AddFile("materials/"..gradientTexture..".png");
	end;

	if (schemaLogo != "") then
		cwKernel:AddFile("materials/"..schemaLogo..".png");
	end;

	if (introImage != "") then
		cwKernel:AddFile("materials/"..introImage..".png");
	end;

	local toolGun = weapons.GetStored("gmod_tool");

	for k, v in pairs(self.tool:GetAll()) do
		toolGun.Tool[v.Mode] = v;
	end;
end;

-- Called when the Clockwork database has connected.
function Clockwork:ClockworkDatabaseConnected()
	cwBans:Load();
end;

-- Called when the Clockwork database connection fails.
function Clockwork:ClockworkDatabaseConnectionFailed()
	cwDatabase:Error(errText);
end;

-- Called when Clockwork should log and event.
function Clockwork:ClockworkLog(text, unixTime) end;

-- Called when a player is banned.
function Clockwork:PlayerBanned(player, duration, reason) end;

-- Called when a player's skin has changed.
function Clockwork:PlayerSkinChanged(player, skin) end;

-- Called when a player's model has changed.
function Clockwork:PlayerModelChanged(player, model)
	local hands = player:GetHands();

	if (IsValid(hands) and hands:IsValid()) then
		self:PlayerSetHandsModel(player, player:GetHands());
	end;
end;

-- Called when a player's saved inventory should be added to.
function Clockwork:PlayerAddToSavedInventory(player, character, Callback)
	for k, v in pairs(player:GetWeapons()) do
		local weaponItemTable = cwItem:GetByWeapon(v);
		if (weaponItemTable) then
			Callback(weaponItemTable);
		end;
	end;
end;

-- Called when a player's unlock info is needed.
function Clockwork:PlayerGetUnlockInfo(player, entity)
	if (cwEntity:IsDoor(entity)) then
		local unlockTime = cwConfig:Get("unlock_time"):Get();
		
		if (cwEvent:CanRun("limb_damage", "unlock_time")) then
			local leftArm = cwLimb:GetDamage(player, HITGROUP_LEFTARM, true);
			local rightArm = cwLimb:GetDamage(player, HITGROUP_RIGHTARM, true);
			local armDamage = math.max(leftArm, rightArm);
			
			if (armDamage > 0) then
				unlockTime = unlockTime * (1 + armDamage);
			end;
		end;
		
		return {
			duration = unlockTime,
			Callback = function(player, entity)
				entity:Fire("unlock", "", 0);
			end
		};
	end;
end;

-- Called when an Clockwork item has initialized.
function Clockwork:ClockworkItemInitialized(itemTable) end;

--[[
	@codebase Server
	@details Called after Clockwork items have been initialized.
	@param Table The table of items that have been initialized.
--]]
function Clockwork:ClockworkPostItemsInitialized(itemsTable) end;

-- Called when a player's lock info is needed.
function Clockwork:PlayerGetLockInfo(player, entity)
	if (cwEntity:IsDoor(entity)) then
		local lockTime = cwConfig:Get("lock_time"):Get();
		
		if (cwEvent:CanRun("limb_damage", "lock_time")) then
			local leftArm = cwLimb:GetDamage(player, HITGROUP_LEFTARM, true);
			local rightArm = cwLimb:GetDamage(player, HITGROUP_RIGHTARM, true);
			local armDamage = math.max(leftArm, rightArm);
			
			if (armDamage > 0) then
				lockTime = lockTime * (1 + armDamage);
			end;
		end;
		
		return {
			duration = lockTime,
			Callback = function(player, entity)
				entity:Fire("lock", "", 0);
			end
		};
	end;
end;

-- Called when a player attempts to fire a weapon.
function Clockwork:PlayerCanFireWeapon(player, bIsRaised, weapon, bIsSecondary)
	local canShootTime = player.cwNextShootTime;
	local curTime = CurTime();
	
	if (player:IsRunning() and cwConfig:Get("sprint_lowers_weapon"):Get()) then
		return false;
	end;
	
	if (!bIsRaised and !cwPlugin:Call("PlayerCanUseLoweredWeapon", player, weapon, bIsSecondary)) then
		return false;
	end;
	
	if (canShootTime and canShootTime > curTime) then
		return false;
	end;
	
	if (cwEvent:CanRun("limb_damage", "weapon_fire")) then
		local leftArm = cwLimb:GetDamage(player, HITGROUP_LEFTARM, true);
		local rightArm = cwLimb:GetDamage(player, HITGROUP_RIGHTARM, true);
		local armDamage = math.max(leftArm, rightArm);
		
		if (armDamage == 0) then return true; end;
		
		if (player.cwArmDamageNoFire) then
			if (curTime >= player.cwArmDamageNoFire) then
				player.cwArmDamageNoFire = nil;
			end;
			
			return false;
		else
			if (!player.cwNextArmDamage) then
				player.cwNextArmDamage = curTime + (1 - (armDamage * 0.5));
			end;
			
			if (curTime >= player.cwNextArmDamage) then
				player.cwNextArmDamage = nil;
				
				if (math.random() <= armDamage * 0.75) then
					player.cwArmDamageNoFire = curTime + (1 + (armDamage * 2));
				end;
			end;
		end;
	end;
	
	return true;
end;

-- Called when a player attempts to use a lowered weapon.
function Clockwork:PlayerCanUseLoweredWeapon(player, weapon, secondary)
	if (secondary) then
		return weapon.NeverRaised or (weapon.Secondary and weapon.Secondary.NeverRaised);
	else
		return weapon.NeverRaised or (weapon.Primary and weapon.Primary.NeverRaised);
	end;
end;

-- Called when a player's recognised names have been cleared.
function Clockwork:PlayerRecognisedNamesCleared(player, status, isAccurate) end;

-- Called when a player's name has been cleared.
function Clockwork:PlayerNameCleared(player, status, isAccurate) end;

-- Called when an offline player has been given property.
function Clockwork:PlayerPropertyGivenOffline(key, uniqueID, entity, networked, removeDelay) end;

-- Called when an offline player has had property taken.
function Clockwork:PlayerPropertyTakenOffline(key, uniqueID, entity) end;

-- Called when a player has been given property.
function Clockwork:PlayerPropertyGiven(player, entity, networked, removeDelay) end;

-- Called when a player has had property taken.
function Clockwork:PlayerPropertyTaken(player, entity) end;

-- Called when a player has been given flags.
function Clockwork:PlayerFlagsGiven(player, flags)
	if (string.find(flags, "p") and player:Alive()) then
		cwPly:GiveSpawnWeapon(player, "weapon_physgun");
	end;
	
	if (string.find(flags, "t") and player:Alive()) then
		cwPly:GiveSpawnWeapon(player, "gmod_tool");
	end;
	
	player:SetSharedVar("flags", player:GetFlags());
end;

-- Called when a player has had flags taken.
function Clockwork:PlayerFlagsTaken(player, flags)
	if (string.find(flags, "p") and player:Alive()) then
		if (!cwPly:HasFlags(player, "p")) then
			cwPly:TakeSpawnWeapon(player, "weapon_physgun");
		end;
	end;
	
	if (string.find(flags, "t") and player:Alive()) then
		if (!cwPly:HasFlags(player, "t")) then
			cwPly:TakeSpawnWeapon(player, "gmod_tool");
		end;
	end;
	
	player:SetSharedVar("flags", player:GetFlags());
end;

-- Called when a player's phys desc override is needed.
function Clockwork:GetPlayerPhysDescOverride(player, physDesc) end;

-- Called when a player's default skin is needed.
function Clockwork:GetPlayerDefaultSkin(player)
	local model, skin = cwClass:GetAppropriateModel(player:Team(), player);
	return skin;
end;

-- Called when a player's default model is needed.
function Clockwork:GetPlayerDefaultModel(player)
	local model, skin = cwClass:GetAppropriateModel(player:Team(), player);
	return model;
end;

-- Called when a player's default inventory is needed.
function Clockwork:GetPlayerDefaultInventory(player, character, inventory)
	local startingInv = cwFaction:FindByID(character.faction).startingInv;
	
	if (istable(startingInv)) then
		for k, v in pairs(startingInv) do
			cwInventory:AddInstance(
				inventory, cwItem:CreateInstance(k), v
			);
		end;
	end;
end;

-- Called to get whether a player's weapon is raised.
function Clockwork:GetPlayerWeaponRaised(player, class, weapon)
	if (cwKernel:IsDefaultWeapon(weapon)) then
		return true;
	end;
	
	if (player:IsRunning() and cwConfig:Get("sprint_lowers_weapon"):Get()) then
		return false;
	end;
	
	if (weapon:GetNetworkedBool("Ironsights")) then
		return true;
	end;
	
	if (weapon:GetNetworkedInt("Zoom") != 0) then
		return true;
	end;
	
	if (weapon:GetNetworkedBool("Scope")) then
		return true;
	end;
	
	if (cwConfig:Get("raised_weapon_system"):Get()) then
		if (player.cwWeaponRaiseClass == class) then
			return true;
		else
			player.cwWeaponRaiseClass = nil;
		end;
		
		if (player.cwAutoWepRaised == class) then
			return true;
		else
			player.cwAutoWepRaised = nil;
		end;
		
		return false;
	end;
	
	return true;
end;

-- Called when a player's attribute has been updated.
function Clockwork:PlayerAttributeUpdated(player, attributeTable, amount) end;

-- Called to get whether a player can give an item to storage.
function Clockwork:PlayerCanGiveToStorage(player, storageTable, itemTable)
	return true;
end;

-- Called to get whether a player can take an item to storage.
function Clockwork:PlayerCanTakeFromStorage(player, storageTable, itemTable)
	return true;
end;

-- Called when a player has given an item to storage.
function Clockwork:PlayerGiveToStorage(player, storageTable, itemTable)
	if (player:IsWearingItem(itemTable)) then
		player:RemoveClothes();
	end;
	
	if (player:IsWearingAccessory(itemTable)) then
		player:RemoveAccessory(itemTable);
	end;
end;

-- Called when a player has taken an item to storage.
function Clockwork:PlayerTakeFromStorage(player, storageTable, itemTable) end;

-- Called when a player is given an item.
function Clockwork:PlayerItemGiven(player, itemTable, bForce)
	cwStorage:SyncItem(player, itemTable);
end;

-- Called when a player has an item taken.
function Clockwork:PlayerItemTaken(player, itemTable)
	cwStorage:SyncItem(player, itemTable);
	
	if (player:IsWearingItem(itemTable)) then
		player:RemoveClothes();
	end;
	
	if (player:IsWearingAccessory(itemTable)) then
		player:RemoveAccessory(itemTable);
	end;
end;

-- Called when a player's cash has been updated.
function Clockwork:PlayerCashUpdated(player, amount, reason, bNoMsg)
	cwStorage:SyncCash(player);
end;

-- A function to scale damage by hit group.
function Clockwork:PlayerScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, baseDamage)
	if (attacker:IsVehicle() or (attacker:IsPlayer() and attacker:InVehicle())) then
		damageInfo:ScaleDamage(0.25);
	end;
end;

-- Called when a player switches their flashlight on or off.
function Clockwork:PlayerSwitchFlashlight(player, bIsOn)
	if (player:HasInitialized() and bIsOn
	and player:IsRagdolled()) then
		return false;
	end;
	
	return true;
end;

-- Called when time has passed.
function Clockwork:TimePassed(quantity) end;

-- Called when Clockwork config has initialized.
function Clockwork:ClockworkConfigInitialized(key, value)
	if (key == "cash_enabled" and !value) then
		for k, v in pairs(cwItem:GetAll()) do
			v.cost = 0;
		end;
	elseif (key == "local_voice") then
		if (value) then
			RunConsoleCommand("sv_alltalk", "0");
		end;
	elseif (key == "use_smooth_rates") then
		if (value) then
			RunConsoleCommand("sv_maxupdaterate", "66");
			RunConsoleCommand("sv_minupdaterate", "0");
			RunConsoleCommand("sv_maxcmdrate", "66");
			RunConsoleCommand("sv_mincmdrate", "0");
			RunConsoleCommand("sv_maxrate", "25000");
			RunConsoleCommand("sv_minrate", "0");
		end;
	elseif (key == "use_mid_performance_rates") then
		if (value) then
			RunConsoleCommand("sv_maxupdaterate", "40");
			RunConsoleCommand("sv_minupdaterate", "0");
			RunConsoleCommand("sv_maxcmdrate", "40");
			RunConsoleCommand("sv_mincmdrate", "0");
			RunConsoleCommand("sv_maxrate", "25000");
			RunConsoleCommand("sv_minrate", "0");
		end;
	elseif (key == "use_lag_free_rates") then
		if (value) then
			RunConsoleCommand("sv_maxupdaterate", "24");
			RunConsoleCommand("sv_minupdaterate", "0");
			RunConsoleCommand("sv_maxcmdrate", "24");
			RunConsoleCommand("sv_mincmdrate", "0");
			RunConsoleCommand("sv_maxrate", "25000");
			RunConsoleCommand("sv_minrate", "0");
		end;
	end;
end;

-- Called when a Clockwork ConVar has changed.
function Clockwork:ClockworkConVarChanged(name, previousValue, newValue)
	if (name == "local_voice" and newValue) then
		RunConsoleCommand("sv_alltalk", "1");
	end;
end;

-- Called when Clockwork config has changed.
function Clockwork:ClockworkConfigChanged(key, data, previousValue, newValue)
	local plyTable = player.GetAll();

	if (key == "default_flags") then
		for k, v in pairs(plyTable) do
			if (v:HasInitialized() and v:Alive()) then
				if (string.find(previousValue, "p")) then
					if (!string.find(newValue, "p")) then
						if (!cwPly:HasFlags(v, "p")) then
							cwPly:TakeSpawnWeapon(v, "weapon_physgun");
						end;
					end;
				elseif (!string.find(previousValue, "p")) then
					if (string.find(newValue, "p")) then
						cwPly:GiveSpawnWeapon(v, "weapon_physgun");
					end;
				end;
				
				if (string.find(previousValue, "t")) then
					if (!string.find(newValue, "t")) then
						if (!cwPly:HasFlags(v, "t")) then
							cwPly:TakeSpawnWeapon(v, "gmod_tool");
						end;
					end;
				elseif (!string.find(previousValue, "t")) then
					if (string.find(newValue, "t")) then
						cwPly:GiveSpawnWeapon(v, "gmod_tool");
					end;
				end;
			end;
		end;
	elseif (key == "use_own_group_system") then
		if (newValue) then
			cwCommand:SetHidden("PlySetGroup", true);
			cwCommand:SetHidden("PlyDemote", true);
		else
			cwCommand:SetHidden("PlySetGroup", false);
			cwCommand:SetHidden("PlyDemote", false);
		end;
	elseif (key == "crouched_speed") then
		for k, v in pairs(plyTable) do
			v:SetCrouchedWalkSpeed(newValue);
		end;
	elseif (key == "ooc_interval") then
		for k, v in pairs(plyTable) do
			v.cwNextTalkOOC = nil;
		end;
	elseif (key == "jump_power") then
		for k, v in pairs(plyTable) do
			v:SetJumpPower(newValue);
		end;
	elseif (key == "walk_speed") then
		for k, v in pairs(plyTable) do
			v:SetWalkSpeed(newValue);
		end;
	elseif (key == "run_speed") then
		for k, v in pairs(plyTable) do
			v:SetRunSpeed(newValue);
		end;
	end;
end;

-- Called when a player's name has changed.
function Clockwork:PlayerNameChanged(player, previousName, newName) end;

-- Called when a player attempts to sprays their tag.
function Clockwork:PlayerSpray(player)
	if (!player:Alive() or player:IsRagdolled()) then
		return true;
	elseif (cwEvent:CanRun("config", "player_spray")) then
		return cwConfig:Get("disable_sprays"):Get();
	end;
end;

-- Called when a player attempts to use an entity.
function Clockwork:PlayerUse(player, entity)
	if (player:IsRagdolled(RAGDOLL_FALLENOVER)) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player's move data is set up.
function Clockwork:SetupMove(player, moveData)
	if (player:Alive() and !player:IsRagdolled()) then
		local frameTime = FrameTime();
		local isDrunk = cwPly:GetDrunk(player);
		local curTime = CurTime();
		
		if (isDrunk and player.cwDrunkSwerve) then
			player.cwDrunkSwerve = math.Clamp(player.cwDrunkSwerve + frameTime, 0, math.min(isDrunk * 2, 16));
			
			moveData:SetMoveAngles(moveData:GetMoveAngles() + Angle(0, math.cos(curTime) * player.cwDrunkSwerve, 0));
		elseif (player.cwDrunkSwerve and player.cwDrunkSwerve > 1) then
			player.cwDrunkSwerve = math.max(player.cwDrunkSwerve - frameTime, 0);
			
			moveData:SetMoveAngles(moveData:GetMoveAngles() + Angle(0, math.cos(curTime) * player.cwDrunkSwerve, 0));
		elseif (player.cwDrunkSwerve != 1) then
			player.cwDrunkSwerve = 1;
		end;
	end;
end;

-- Called when a player throws a punch.
function Clockwork:PlayerPunchThrown(player) end;

-- Called when a player knocks on a door.
function Clockwork:PlayerKnockOnDoor(player, door) end;

-- Called when a player attempts to knock on a door.
function Clockwork:PlayerCanKnockOnDoor(player, door) return true; end;

-- Called when a player punches an entity.
function Clockwork:PlayerPunchEntity(player, entity) end;

--[[
	Called when a player orders an item shipment.
	
	If itemTables is set, the order is a shipment. This means that
	you should use the itemTables table, and not the itemTable parameter.
--]]
function Clockwork:PlayerOrderShipment(player, itemTable, entity, itemTables) end;

-- Called when a player holsters a weapon.
function Clockwork:PlayerHolsterWeapon(player, itemTable, weapon, bForce) end;

-- Called when a player attempts to save a recognised name.
function Clockwork:PlayerCanSaveRecognisedName(player, target)
	if (player != target) then return true; end;
end;

-- Called when a player attempts to restore a recognised name.
function Clockwork:PlayerCanRestoreRecognisedName(player, target)
	if (player != target) then return true; end;
end;

-- Called when a player attempts to order an item shipment.
function Clockwork:PlayerCanOrderShipment(player, itemTable)
	local curTime = CurTime();

	if (player.cwNextOrderTime and curTime < player.cwNextOrderTime) then
		return false;
	end;
	
	return true;
end;

-- Called when a player attempts to get up.
function Clockwork:PlayerCanGetUp(player) return true; end;

-- Called when a player knocks out a player with a punch.
function Clockwork:PlayerPunchKnockout(player, target) end;

-- Called when a player attempts to throw a punch.
function Clockwork:PlayerCanThrowPunch(player) return true; end;

-- Called when a player attempts to punch an entity.
function Clockwork:PlayerCanPunchEntity(player, entity) return true; end;

-- Called when a player attempts to knock a player out with a punch.
function Clockwork:PlayerCanPunchKnockout(player, target) return true; end;

-- Called when a player attempts to bypass the faction limit.
function Clockwork:PlayerCanBypassFactionLimit(player, character) return false; end;

-- Called when a player attempts to bypass the class limit.
function Clockwork:PlayerCanBypassClassLimit(player, class) return false; end;

-- Called when a player's pain sound should be played.
function Clockwork:PlayerPlayPainSound(player, gender, damageInfo, hitGroup)
	if (damageInfo:IsBulletDamage() and math.random() <= 0.5) then
		if (hitGroup == HITGROUP_HEAD) then
			return "vo/npc/"..gender.."01/ow0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_CHEST or hitGroup == HITGROUP_GENERIC) then
			return "vo/npc/"..gender.."01/hitingut0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
			return "vo/npc/"..gender.."01/myleg0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_LEFTARM or hitGroup == HITGROUP_RIGHTARM) then
			return "vo/npc/"..gender.."01/myarm0"..math.random(1, 2)..".wav";
		elseif (hitGroup == HITGROUP_GEAR) then
			return "vo/npc/"..gender.."01/startle0"..math.random(1, 2)..".wav";
		end;
	end;
	
	return "vo/npc/"..gender.."01/pain0"..math.random(1, 9)..".wav";
end;

-- Called when a player has spawned.
function Clockwork:PlayerSpawn(player)
	if (player:HasInitialized()) then
		player:ShouldDropWeapon(false);
		
		if (!player.cwLightSpawn) then
			local FACTION = cwFaction:FindByID(player:GetFaction());
			local relation = FACTION.entRelationship;
			local playerRank, rank = player:GetFactionRank();

			cwPly:SetWeaponRaised(player, false);
			cwPly:SetRagdollState(player, RAGDOLL_RESET);
			cwPly:SetAction(player, false);
			cwPly:SetDrunk(player, false);
			
			cwAttributes:ClearBoosts(player);
			cwLimb:ResetDamage(player);
			
			self:PlayerSetModel(player);
			self:PlayerLoadout(player);
			
			if (player:FlashlightIsOn()) then
				player:Flashlight(false);
			end;
			
			player:SetForcedAnimation(false);
			player:SetCollisionGroup(COLLISION_GROUP_PLAYER);
			player:SetMaterial("");
			player:SetMoveType(MOVETYPE_WALK);
			player:Extinguish();
			player:UnSpectate();
			player:GodDisable();
			player:RunCommand("-duck");
			player:SetColor(Color(255, 255, 255, 255));
			player:SetupHands();
			
			player:SetCrouchedWalkSpeed(cwConfig:Get("crouched_speed"):Get());
			player:SetWalkSpeed(cwConfig:Get("walk_speed"):Get());
			player:SetJumpPower(cwConfig:Get("jump_power"):Get());
			player:SetRunSpeed(cwConfig:Get("run_speed"):Get());
			player:CrosshairDisable();

			player:SetMaxHealth(FACTION.maxHealth or 100);
			player:SetMaxArmor(FACTION.maxArmor or 0);
			player:SetHealth(FACTION.maxHealth or 100);
			player:SetArmor(FACTION.maxArmor or 0);
		
			if (rank) then
				player:SetMaxHealth(rank.maxHealth or player:GetMaxHealth());
				player:SetMaxArmor(rank.maxArmor or player:GetMaxArmor());
				player:SetHealth(rank.maxHealth or player:GetMaxHealth());
				player:SetArmor(rank.maxArmor or player:GetMaxArmor());
			end;
		
			if (istable(FACTION.respawnInv)) then
				local inventory = player:GetInventory();
				local itemQuantity;
			
				for k, v in pairs(FACTION.respawnInv) do
					for i = 1, (v or 1) do
						itemQuantity = table.Count(inventory[k]);
						
						if (itemQuantity < v) then
							player:GiveItem(cwItem:CreateInstance(k), true);
						end;
					end;
				end;
			end;
		
			if (prevRelation) then
				for k, v in pairs(ents.GetAll()) do
					if (v:IsNPC()) then
						local prevRelationVal = prevRelation[player:SteamID()][v:GetClass()];
					
						if (prevRelationVal) then
							v:AddEntityRelationship(player, prevRelationVal, 1);
						end;
					end;
				end;
			end;
			
			if (istable(relation)) then
				local relationEnts;
			
				prevRelation = prevRelation or {};
				prevRelation[player:SteamID()] = prevRelation[player:SteamID()] or {};
			
				for k, v in pairs(relation) do
					relationEnts = ents.FindByClass(k);
				
					if (relationEnts) then
						for k2, v2 in pairs(relationEnts) do
							if (string.lower(v) == "like") then
								prevRelation[player:SteamID()][k] = v2:Disposition(player);
								v2:AddEntityRelationship(player, D_LI, 1);
							elseif (string.lower(v) == "fear") then
								prevRelation[player:SteamID()][k] = v2:Disposition(player);
								v2:AddEntityRelationship(player, D_FR, 1);
							elseif (string.lower(v) == "hate") then
								prevRelation[player:SteamID()][k] = v2:Disposition(player);
								v2:AddEntityRelationship(player, D_HT, 1);
							else
								ErrorNoHalt("Attempting to add relationship using invalid relation '"..v.."' towards faction '"..FACTION.name.."'.\r\n");
							end;
						end;
					end;
				end;
			end;

			if (player.cwFirstSpawn) then
				local ammo = player:GetSavedAmmo();
				
				for k, v in pairs(ammo) do
					if (!string.find(k, "p_") and !string.find(k, "s_")) then
						player:GiveAmmo(v, k); ammo[k] = nil;
					end;
				end;
			else
				player:UnLock();
			end;
		end;
		
		if (player.cwLightSpawn and player.cwSpawnCallback) then
			player.cwSpawnCallback(player, true);
			player.cwSpawnCallback = nil;
		end;
		
		cwPlugin:Call("PostPlayerSpawn", player, player.cwLightSpawn, player.cwChangeClass, player.cwFirstSpawn);
		cwPly:SetRecognises(player, player, RECOGNISE_TOTAL);
		
		local accessoryData = player:GetAccessoryData();
		local clothesItem = player:GetClothesItem();
		
		if (clothesItem) then
			player:SetClothesData(clothesItem);
		end;
		
		for k, v in pairs(accessoryData) do
			local itemTable = player:FindItemByID(v, k);
			
			if (itemTable) then
				itemTable:OnWearAccessory(player, true);
			else
				accessoryData[k] = nil;
			end;
		end;
		
		player.cwChangeClass = false;
		player.cwLightSpawn = false;
	else
		player:KillSilent();
	end;
end;

-- Choose the model for hands according to their player model.
function Clockwork:PlayerSetHandsModel(player, entity)
	local model = player:GetModel();
	local simpleModel = player_manager.TranslateToPlayerModelName(model)
	local info = self.animation:GetHandsInfo(model) or player_manager.TranslatePlayerHands(simpleModel);

	if (info) then
		entity:SetModel(info.model);
		entity:SetSkin(info.skin);

		local bodyGroups = tostring(info.body);

		if (bodyGroups) then
			bodyGroups = string.Explode("", bodyGroups);

			for k, v in pairs(bodyGroups) do
				local num = tonumber(v);

				if (num) then
					entity:SetBodygroup(k, num);
				end;
			end;
		end;
	end;

	cwPlugin:Call("PostCModelHandsSet", player, model, entity, info);
end;

-- Called every frame.
function Clockwork:Think()
	cwKernel:CallTimerThink(CurTime());
end;

-- Called when a player attempts to connect to the server.
function Clockwork:CheckPassword(steamID, ipAddress, svPassword, clPassword, name)
	steamID = util.SteamIDFrom64(steamID);
	local banTable = self.bans.stored[ipAddress] or self.bans.stored[steamID];
	
	if (banTable) then
		local unixTime = os.time();
		local unbanTime = tonumber(banTable.unbanTime);
		local timeLeft = unbanTime - unixTime;
		local hoursLeft = math.Round(math.max(timeLeft / 3600, 0));
		local minutesLeft = math.Round(math.max(timeLeft / 60, 0));
		
		if (unbanTime > 0 and unixTime < unbanTime) then
			local bannedMessage = cwConfig:Get("banned_message"):Get();
			
			if (hoursLeft >= 1) then
				hoursLeft = tostring(hoursLeft);
				
				bannedMessage = string.gsub(bannedMessage, "!t", hoursLeft);
				bannedMessage = string.gsub(bannedMessage, "!f", "hour(s)");
			elseif (minutesLeft >= 1) then
				minutesLeft = tostring(minutesLeft);
				
				bannedMessage = string.gsub(bannedMessage, "!t", minutesLeft);
				bannedMessage = string.gsub(bannedMessage, "!f", "minutes(s)");
			else
				timeLeft = tostring(timeLeft);
				
				bannedMessage = string.gsub(bannedMessage, "!t", timeLeft);
				bannedMessage = string.gsub(bannedMessage, "!f", "second(s)");
			end;
			
			return false, bannedMessage;
		elseif (unbanTime == 0) then
			return false, banTable.reason;
		else
			self.bans:Remove(ipAddress);
			self.bans:Remove(steamID);
		end;
	end;
end;

-- Called when the Clockwork data is saved.
function Clockwork:SaveData()
	for k, v in pairs(player.GetAll()) do
		if (v:HasInitialized()) then
			v:SaveCharacter();
		end;
	end;
	
	if (!cwConfig:Get("use_local_machine_time"):Get()) then
		cwKernel:SaveSchemaData("time", self.time:GetSaveData());
	end;
	
	if (!cwConfig:Get("use_local_machine_date"):Get()) then
		cwKernel:SaveSchemaData("date", self.date:GetSaveData());
	end;
end;

function Clockwork:PlayerCanInteractCharacter(player, action, character)
	if (self.quiz:GetEnabled() and !self.quiz:GetCompleted(player)) then
		return false, 'You have not completed the quiz!';
	else
		return true;
	end;
end;

-- Called whe the map entities are initialized.
function Clockwork:InitPostEntity()
	for k, v in pairs(ents.GetAll()) do
		if (IsValid(v)) then
			if (v:GetModel()) then
				cwEntity:SetMapEntity(v, true);
				cwEntity:SetStartAngles(v, v:GetAngles());
				cwEntity:SetStartPosition(v, v:GetPos());
				
				if (cwEntity:SetChairAnimations(v)) then
					v:SetCollisionGroup(COLLISION_GROUP_WEAPON);

					local physicsObject = v:GetPhysicsObject();
					
					if (IsValid(physicsObject)) then
						physicsObject:EnableMotion(false);
					end;
				end;
			end;

			if (cwEntity:IsDoor(v)) then
				local entIndex = v:EntIndex();
			
				if (!cwEntity.DoorEntities) then cwEntity.DoorEntities = {}; end;

				local doorEnts = cwEntity.DoorEntities;

				if (!doorEnts[entIndex]) then
					doorEnts[entIndex] = v;
				end;
			end;
		end;
	end;

	if (!Clockwork.NoMySQL) then
		cwKernel:SetSharedVar("NoMySQL");
	else
		cwKernel:SetSharedVar("NoMySQL", Clockwork.NoMySQL);
	end;

	cwPlugin:Call("ClockworkInitPostEntity");
end;

-- Called when a player initially spawns.
function Clockwork:PlayerInitialSpawn(player)
	player.cwCharacterList = player.cwCharacterList or {};
	player.cwHasSpawned = true;
	player.cwSharedVars = player.cwSharedVars or {};
	
	if (IsValid(player)) then
		player:KillSilent();
	end;
	
	if (player:IsBot()) then
		cwConfig:Send(player);
	end;
	
	if (!player:IsKicked()) then
		cwKernel:PrintLog(LOGTYPE_MINOR, player:SteamName().." ("..player:SteamID()..") подключился к серверу.");
		cwChatbox:Add(nil, nil, 'connect', player:SteamName()..' подключился к серверу.');
	end;
end;

-- Called every frame while a player is dead.
function Clockwork:PlayerDeathThink(player)
	local action = cwPly:GetAction(player);
	
	if (!player:HasInitialized() or player:GetCharacterData("CharBanned")) then
		return true;
	end;
	
	if (player:IsCharacterMenuReset()) then
		return true;
	end;
	
	if (action == "spawn") then
		return true;
	else
	
		player:Spawn();
	end;
end;

-- Called when a player's data has loaded.
function Clockwork:PlayerDataLoaded(player)
	if (cwConfig:Get("clockwork_intro_enabled"):Get()) then
		if (!player:GetData("ClockworkIntro")) then
			cwDatastream:Start(player, "ClockworkIntro", true);
			player:SetData("ClockworkIntro", true);
		end;
	end;
	
	cwDatastream:Start(player, "Donations", player.cwDonations);
end;

-- Called when a player attempts to be given a weapon.
function Clockwork:PlayerCanBeGivenWeapon(player, class, itemTable)
	return true;
end;

-- Called when a player has been given a weapon.
function Clockwork:PlayerGivenWeapon(player, class, itemTable)
	self.inventory:Rebuild(player);
	
	if (cwItem:IsWeapon(itemTable) and !itemTable:IsFakeWeapon()) then
		if (!itemTable:IsMeleeWeapon() and !itemTable:IsThrowableWeapon()) then
			if (itemTable("weight") <= 2) then
				cwPly:CreateGear(player, "Secondary", itemTable);
			else
				cwPly:CreateGear(player, "Primary", itemTable);
			end;
		elseif (itemTable:IsThrowableWeapon()) then
			cwPly:CreateGear(player, "Throwable", itemTable);
		else
			cwPly:CreateGear(player, "Melee", itemTable);
		end;
	end;
end;

-- Called when a player attempts to create a character.
function Clockwork:PlayerCanCreateCharacter(player, character, characterID)
	if (self.quiz:GetEnabled() and !self.quiz:GetCompleted(player)) then
		return "You have not completed the quiz!";
	else
		return true;
	end;
end;

-- Called when a player's bullet info should be adjusted.
function Clockwork:PlayerAdjustBulletInfo(player, bulletInfo) end;

-- Called when an entity fires some bullets.
function Clockwork:EntityFireBullets(entity, bulletInfo) end;

-- Called when a player's fall damage is needed.
function Clockwork:GetFallDamage(player, velocity)
	local ragdollEntity = nil;
	local position = player:GetPos();
	local damage = math.max((velocity - 464) * 0.225225225, 0) * cwConfig:Get("scale_fall_damage"):Get();
	local filter = {player};
	
	if (cwConfig:Get("wood_breaks_fall"):Get()) then
		if (player:IsRagdolled()) then
			ragdollEntity = player:GetRagdollEntity();
			position = ragdollEntity:GetPos();
			filter = {player, ragdollEntity};
		end;
		
		local traceLine = util.TraceLine({
			endpos = position - Vector(0, 0, 64),
			start = position,
			filter = filter
		});

		if (IsValid(traceLine.Entity) and traceLine.MatType == MAT_WOOD) then
			if (string.find(traceLine.Entity:GetClass(), "prop_physics")) then
				traceLine.Entity:Fire("Break", "", 0);
				damage = damage * 0.25;
			end;
		end;
	end;
	
	return damage;
end;

-- Called when a player's data stream info has been sent.
function Clockwork:PlayerDataStreamInfoSent(player)
	if (player:IsBot()) then
		cwPly:LoadData(player, function(player)
			cwPlugin:Call("PlayerDataLoaded", player);
			
			local factions = table.ClearKeys(self.faction:GetAll(), true);
			local faction = factions[math.random(1, #factions)];
			
			if (faction) then
				local genders = {GENDER_MALE, GENDER_FEMALE};
				local gender = faction.singleGender or genders[math.random(1, #genders)];
				local models = faction.models[string.lower(gender)];
				local model = models[math.random(1, #models)];
				
				cwPly:LoadCharacter(player, 1, {
					faction = faction.name,
					gender = gender,
					model = model,
					name = player:Name(),
					data = {}
				}, function()
					cwPly:LoadCharacter(player, 1);
				end);
			end;
		end);
	elseif (table.Count(self.faction:GetAll()) > 0) then
		cwPly:LoadData(player, function()
			cwPlugin:Call("PlayerDataLoaded", player);
			
			local whitelisted = player:GetData("Whitelisted");
			local steamName = player:SteamName();
			local unixTime = os.time();
			
			cwPly:SetCharacterMenuState(player, CHARACTER_MENU_OPEN);
			
			if (whitelisted) then
				for k, v in pairs(whitelisted) do
					if (self.faction.stored[v]) then
						cwDatastream:Start(player, "SetWhitelisted", {v, true});
					else
						whitelisted[k] = nil;
					end;
				end;
			end;
			
			cwPly:GetCharacters(player, function(characters)
				if (characters) then
					for k, v in pairs(characters) do
						cwPly:ConvertCharacterMySQL(v);
						player.cwCharacterList[v.characterID] = {};
						
						for k2, v2 in pairs(v) do
							if (k2 == "timeCreated") then
								if (v2 == "") then
									player.cwCharacterList[v.characterID][k2] = unixTime;
								else
									player.cwCharacterList[v.characterID][k2] = v2;
								end;
							elseif (k2 == "lastPlayed") then
								player.cwCharacterList[v.characterID][k2] = unixTime;
							elseif (k2 == "steamName") then
								player.cwCharacterList[v.characterID][k2] = steamName;
							else
								player.cwCharacterList[v.characterID][k2] = v2;
							end;
						end;
					end;
					
					for k, v in pairs(player.cwCharacterList) do
						local bDelete = cwPlugin:Call("PlayerAdjustCharacterTable", player, v);
						
						if (!bDelete) then
							cwPly:CharacterScreenAdd(player, v);
						else
							cwPly:ForceDeleteCharacter(player, k);
						end;
					end;
				end;
				
				cwPly:SetCharacterMenuState(player, CHARACTER_MENU_LOADED);
			end);
		end);
	end;
end;

-- Called when a player's data stream info should be sent.
function Clockwork:PlayerSendDataStreamInfo(player)
	cwDatastream:Start(player, "SharedTables", self.SharedTables);

	if (self.OverrideColorMod and self.OverrideColorMod != nil) then
		cwDatastream:Start(player, "SystemColGet", self.OverrideColorMod);
	end;
end;

-- Called when a player's death sound should be played.
function Clockwork:PlayerPlayDeathSound(player, gender)
	return "vo/npc/"..string.lower(gender).."01/pain0"..math.random(1, 9)..".wav";
end;

-- Called when a player's character data should be restored.
function Clockwork:PlayerRestoreCharacterData(player, data)
	if (data["PhysDesc"]) then
		data["PhysDesc"] = cwKernel:ModifyPhysDesc(data["PhysDesc"]);
	end;
	
	if (!data["LimbData"]) then
		data["LimbData"] = {};
	end;
	
	if (!data["Clothes"]) then
		data["Clothes"] = {};
	end;
	
	if (!data["Accessories"]) then
		data["Accessories"] = {};
	end;
	
	cwPly:RestoreCharacterData(player, data);
end;

-- Called when a player's limb damage is bIsHealed.
function Clockwork:PlayerLimbDamageHealed(player, hitGroup, amount) end;

-- Called when a player's limb takes damage.
function Clockwork:PlayerLimbTakeDamage(player, hitGroup, damage) end;

-- Called when a player's limb damage is reset.
function Clockwork:PlayerLimbDamageReset(player) end;

-- Called when a player's character data should be saved.
function Clockwork:PlayerSaveCharacterData(player, data)
	if (cwConfig:Get("save_attribute_boosts"):Get()) then
		cwKernel:SavePlayerAttributeBoosts(player, data);
	end;
	
	data["Health"] = player:Health();
	data["Armor"] = player:Armor();
	
	if (data["Health"] <= 1) then
		data["Health"] = nil;
	end;
	
	if (data["Armor"] <= 1) then
		data["Armor"] = nil;
	end;
end;

-- Called when a player's data should be saved.
function Clockwork:PlayerSaveData(player, data)
	cwPly:RestoreData(player, data);
	
	if (data["Whitelisted"] and table.Count(data["Whitelisted"]) == 0) then
		data["Whitelisted"] = nil;
	end;
end;

-- Called when a player's storage should close.
function Clockwork:PlayerStorageShouldClose(player, storageTable)
	local entity = player:GetStorageEntity();
	
	if (player:IsRagdolled() or !player:Alive() or (storageTable.entity and !entity)
	or (storageTable.entity and storageTable.distance
	and player:GetShootPos():Distance(entity:GetPos()) > storageTable.distance)) then
		return true;
	elseif (storageTable.ShouldClose and storageTable.ShouldClose(player, storageTable)) then
		return true;
	end;
end;

-- Called when a player attempts to pickup a weapon.
function Clockwork:PlayerCanPickupWeapon(player, weapon)
	if (player.cwForceGive or (player:GetEyeTraceNoCursor().Entity == weapon and player:KeyDown(IN_USE))) then
		return true;
	else
		return false;
	end;
end;

-- Called to modify the generator interval.
function Clockwork:ModifyGeneratorInterval(info) end;

-- Called to modify the wages interval.
function Clockwork:ModifyWagesInterval(info) end;

-- Called to modify a player's wages info.
function Clockwork:PlayerModifyWagesInfo(player, info) end;

-- Called each tick.
function Clockwork:Tick()
	local sysTime = SysTime();
	local curTime = CurTime();
	local plyTable = player.GetAll();

	if (!self.NextHint or curTime >= self.NextHint) then
		cwHint:Distribute();
		self.NextHint = curTime + cwConfig:Get("hint_interval"):Get();
	end;
	
	if (!self.NextWagesTime or curTime >= self.NextWagesTime) then
		cwKernel:DistributeWagesCash();
		
		local info = {
			interval = cwConfig:Get("wages_interval"):Get();
		};
		
		cwPlugin:Call("ModifyWagesInterval", info);
		
		self.NextWagesTime = curTime + info.interval;
	end;
	
	if (!self.NextGeneratorTime or curTime >= self.NextGeneratorTime) then
		cwKernel:DistributeGeneratorCash();
		
		local info = {
			interval = cwConfig:Get("generator_interval"):Get();
		};
		
		cwPlugin:Call("ModifyGeneratorInterval", info);
		
		self.NextGeneratorTime = curTime + info.interval;
	end;
	
	if (!self.NextDateTimeThink or sysTime >= self.NextDateTimeThink) then
		cwKernel:PerformDateTimeThink();
		self.NextDateTimeThink = sysTime + cwConfig:Get("minute_time"):Get();
	end;
	
	if (!self.NextSaveData or sysTime >= self.NextSaveData) then
		cwPlugin:Call("PreSaveData");
			cwPlugin:Call("SaveData");
		cwPlugin:Call("PostSaveData");
		
		self.NextSaveData = sysTime + cwConfig:Get("save_data_interval"):Get();
	end;
	
	if (!self.NextCheckEmpty) then
		self.NextCheckEmpty = sysTime + 1200;
	end;
	
	if (sysTime >= self.NextCheckEmpty) then
		self.NextCheckEmpty = nil;
		
		if (#plyTable == 0) then
			RunConsoleCommand("changelevel", game.GetMap());
		end;
	end;
	
	for k, v in pairs(plyTable) do
		if (v:HasInitialized()) then
			if (!v.cwNextThink) then
				v.cwNextThink = curTime + 0.1;
			end;
			
			if (!v.cwNextSetSharedVars) then
				v.cwNextSetSharedVars = curTime + 1;
			end;
			
			if (curTime >= v.cwNextThink) then
				cwPly:CallThinkHook(
					v, (curTime >= v.cwNextSetSharedVars), curTime
				);
			end;
		end;
	end;

	if (self.config:Get("enable_disease"):GetBoolean()) then
		local nextDisease = self.nextDisease;

		if (!nextDisease or nextDisease < CurTime()) then
			for k, v in pairs(plyTable) do
				if (Clockwork.player:HasDiseases(v)) then
					local symptoms = Clockwork.player:GetSymptoms(v);

					for k2, v2 in pairs(symptoms) do
						v2(v);
					end;
				end;
			end;

			self.nextDisease = CurTime() + self.config:Get("disease_interval"):Get();
		end;
	end;
end;

-- Called when a player's health should regenerate.
function Clockwork:PlayerShouldHealthRegenerate(player)
	return true;
end;

-- Called to get the entity that a player is holding.
function Clockwork:PlayerGetHoldingEntity(player) end;

-- A function to regenerate a player's health.
function Clockwork:PlayerHealthRegenerate(player, health, maxHealth)
	local curTime = CurTime();
	local maxHealth = player:GetMaxHealth();
	local health = player:Health();
		
	if (player:Alive() and (!player.cwNextHealthRegen or curTime >= player.cwNextHealthRegen)) then
		if (health >= (maxHealth / 2) and (health < maxHealth)) then
			player:SetHealth(math.Clamp(
				health + 2, 0, maxHealth)
			);
				
			player.cwNextHealthRegen = curTime + 5;
		elseif (health > 0) then
			player:SetHealth(
				math.Clamp(health + 2, 0, maxHealth)
			);
				
			player.cwNextHealthRegen = curTime + 10;
		end;
	end;
end;

-- Called when a player's shared variables should be set.
function Clockwork:PlayerSetSharedVars(player, curTime)
	local weaponClass = cwPly:GetWeaponClass(player);
	local color = player:GetColor();
	local isDrunk = cwPly:GetDrunk(player);
	
	player:HandleAttributeProgress(curTime);
	player:HandleAttributeBoosts(curTime);
	
	player:SetSharedVar("Flags", player:GetFlags());
	player:SetSharedVar("Model", player:GetDefaultModel());
	player:SetSharedVar("Name", player:Name());
	player:SetSharedVar("Cash", player:GetCash());
	
	local clothesItem = player:IsWearingClothes();
	
	if (clothesItem) then
		player:NetworkClothesData();
	else
		player:RemoveClothes();
	end;
	
	if (cwConfig:Get("health_regeneration_enabled"):Get()
	and cwPlugin:Call("PlayerShouldHealthRegenerate", player)) then
		cwPlugin:Call("PlayerHealthRegenerate", player, health, maxHealth)
	end;
	
	if (color.r == 255 and color.g == 0 and color.b == 0 and color.a == 0) then
		player:SetColor(Color(255, 255, 255, 255));
	end;
	
	for k, v in pairs(player:GetWeapons()) do
		local ammoType = v:GetPrimaryAmmoType();
		
		if (ammoType == "grenade" and player:GetAmmoCount(ammoType) == 0) then
			player:StripWeapon(v:GetClass());
		end;
	end;
	
	if (player.cwDrunkTab) then
		for k, v in pairs(player.cwDrunkTab) do
			if (curTime >= v) then
				table.remove(player.cwDrunkTab, k);
			end;
		end;
	end;
	
	if (isDrunk) then
		player:SetSharedVar("IsDrunk", isDrunk);
	else
		player:SetSharedVar("IsDrunk", 0);
	end;
end;

-- Called when a player picks an item up.
function Clockwork:PlayerPickupItem(player, itemTable, itemEntity, bQuickUse) end;

-- Called when a player uses an item.
function Clockwork:PlayerUseItem(player, itemTable, itemEntity) end;

-- Called when a player drops an item.
function Clockwork:PlayerDropItem(player, itemTable, position, entity) end;

-- Called when a player destroys an item.
function Clockwork:PlayerDestroyItem(player, itemTable) end;

-- Called when a player drops a weapon.
function Clockwork:PlayerDropWeapon(player, itemTable, entity, weapon)
	if (itemTable:IsInstance() and IsValid(weapon)) then
		local clipOne = weapon:Clip1();
		local clipTwo = weapon:Clip2();
		
		if (clipOne > 0) then
			itemTable:SetData("ClipOne", clipOne);
		end;
		
		if (clipTwo > 0) then
			itemTable:SetData("ClipTwo", clipTwo);
		end;
	end;
end;

-- Called when a player charges generator.
function Clockwork:PlayerChargeGenerator(player, entity, generator) end;

-- Called when a player destroys generator.
function Clockwork:PlayerDestroyGenerator(player, entity, generator) end;

-- Called when a player's data should be restored.
function Clockwork:PlayerRestoreData(player, data)
	if (!data["Whitelisted"]) then
		data["Whitelisted"] = {};
	end;
end;

-- Called to get whether a player can pickup an entity.
function Clockwork:AllowPlayerPickup(player, entity)
	return false;
end;

-- Called when a player's temporary info should be saved.
function Clockwork:PlayerSaveTempData(player, tempData) end;

-- Called when a player's temporary info should be restored.
function Clockwork:PlayerRestoreTempData(player, tempData) end;

-- Called when a player selects a custom character option.
function Clockwork:PlayerSelectCharacterOption(player, character, option) end;

-- Called when a player attempts to see another player's status.
function Clockwork:PlayerCanSeeStatus(player, target)
	return "# "..target:UserID().." | "..target:Name().." | "..target:SteamName().." | "..target:SteamID();
end;

-- Called when a player attempts to see a player's chat.
function Clockwork:PlayerCanSeePlayersChat(text, teamOnly, listener, speaker)
	return true;
end;

-- Called when a player attempts to hear another player's voice.
function Clockwork:PlayerCanHearPlayersVoice(listener, speaker)
	if (!cwConfig:Get("voice_enabled"):Get()) then
		return false;
	elseif (speaker:GetData("VoiceBan")) then
		return false;
	end;

	if (speaker:GetActiveChannel() and listener:GetActiveChannel()) then
		local speakerChannel = speaker:GetActiveChannel();

		if (self.voice:IsInChannel(listener, speakerChannel)) then
			return true;
		end;
	end;

	if (cwConfig:Get("local_voice"):Get()) then
		if (listener:IsRagdolled(RAGDOLL_KNOCKEDOUT) or !listener:Alive()) then
			return false;
		elseif (speaker:IsRagdolled(RAGDOLL_KNOCKEDOUT) or !speaker:Alive()) then
			return false;
		elseif (listener:GetPos():Distance(speaker:GetPos()) > cwConfig:Get("talk_radius"):Get()) then
			return false;
		end;
	end;
	
	return true, true;
end;

-- Called when a player attempts to delete a character.
function Clockwork:PlayerCanDeleteCharacter(player, character)
	if (cwConfig:Get("cash_enabled"):Get() and character.cash < cwConfig:Get("default_cash"):Get()) then
		if (!character.data["CharBanned"]) then
			return "You cannot delete characters with less than "..cwKernel:FormatCash(cwConfig:Get("default_cash"):Get(), nil, true)..".";
		end;
	end;
end;

-- Called when a player attempts to switch to a character.
function Clockwork:PlayerCanSwitchCharacter(player, character)
	if (!player:Alive() and !player:IsCharacterMenuReset() and !player:GetSharedVar("CharBanned")) then
		return "You cannot switch characters when you are dead!";
	elseif (player:GetRagdollState() == RAGDOLL_KNOCKEDOUT) then
		return "You cannot switch characters when you are knocked out!";
	end;
	
	return true;
end;

-- Called when a player attempts to use a character.
function Clockwork:PlayerCanUseCharacter(player, character)
	if (character.data["CharBanned"]) then
		return character.name.." is banned and cannot be used!";
	end;

	local faction = cwFaction:FindByID(character.faction);
	local playerRank, rank = player:GetFactionRank(character);
	local factionCount = 0;
	local rankCount = 0;
	
	for k, v in ipairs(_player.GetAll()) do
		if (v:HasInitialized()) then
			if (v:GetFaction() == character.faction) then
				if (player != v) then
					if (rank and v:GetFactionRank() == playerRank) then
						rankCount = rankCount + 1;
					end;
					
					factionCount = factionCount + 1;
				end;
			end;
		end;
	end;
	
	if (faction.playerLimit and factionCount >= faction.playerLimit) then
		return "There are too many characters of this faction online!";
	end;
	
	if (rank and rank.playerLimit and rankCount >= rank.playerLimit) then
		return "There are too many characters of this rank online!";
	end;
end;

-- Called when a player's weapons should be given.
function Clockwork:PlayerGiveWeapons(player)
	local rankName, rank = player:GetFactionRank();
	local faction = cwFaction:FindByID(player:GetFaction());

	if (rank and rank.weapons) then
		for k, v in pairs(rank.weapons) do
			cwPly:GiveSpawnWeapon(player, v);
		end;
	end;

	if (faction and faction.weapons) then
		for k, v in pairs(faction.weapons) do
			cwPly:GiveSpawnWeapon(player, v);
		end;
	end;
end;

-- Called when a player deletes a character.
function Clockwork:PlayerDeleteCharacter(player, character) end;

-- Called when a player's armor is set.
function Clockwork:PlayerArmorSet(player, newArmor, oldArmor)
	if (player:IsRagdolled()) then
		player:GetRagdollTable().armor = newArmor;
	end;
end;

-- Called when a player's health is set.
function Clockwork:PlayerHealthSet(player, newHealth, oldHealth)
	local bIsRagdolled = player:IsRagdolled();
	local maxHealth = player:GetMaxHealth();
	
	if (newHealth > oldHealth) then
		cwLimb:HealBody(player, (newHealth - oldHealth) / 2);
	end;
	
	if (newHealth >= maxHealth) then
		cwLimb:HealBody(player, 100);
		player:RemoveAllDecals();
		
		if (bIsRagdolled) then
			player:GetRagdollEntity():RemoveAllDecals();
		end;
	end;
	
	if (bIsRagdolled) then
		player:GetRagdollTable().health = newHealth;
	end;
end;

-- Called when a player attempts to own a door.
function Clockwork:PlayerCanOwnDoor(player, door)
	if (cwEntity:IsDoorUnownable(door)) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to view a door.
function Clockwork:PlayerCanViewDoor(player, door)
	if (cwEntity:IsDoorUnownable(door)) then
		return false;
	end;
	
	return true;
end;

-- Called when a player attempts to holster a weapon.
function Clockwork:PlayerCanHolsterWeapon(player, itemTable, weapon, bForce, bNoMsg)
	if (cwPly:GetSpawnWeapon(player, itemTable("weaponClass"))) then
		if (!bNoMsg) then
			cwPly:Notify(player, L(player, "CannotHolsterWeapon"));
		end;
		
		return false;
	elseif (itemTable.CanHolsterWeapon) then
		return itemTable:CanHolsterWeapon(player, weapon, bForce, bNoMsg);
	else
		return true;
	end;
end;

-- Called when a player attempts to drop a weapon.
function Clockwork:PlayerCanDropWeapon(player, itemTable, weapon, bNoMsg)
	if (cwPly:GetSpawnWeapon(player, itemTable("weaponClass"))) then
		if (!bNoMsg) then
			cwPly:Notify(player, L(player, "CannotDropWeapon"));
		end;
		
		return false;
	elseif (itemTable.CanDropWeapon) then
		return itemTable:CanDropWeapon(player, bNoMsg);
	else
		return true;
	end;
end;

-- Called when a player attempts to use an item.
function Clockwork:PlayerCanUseItem(player, itemTable, bNoMsg)
	if (cwItem:IsWeapon(itemTable) and cwPly:GetSpawnWeapon(player, itemTable("weaponClass"))) then
		if (!bNoMsg) then
			cwPly:Notify(player, L(player, "CannotUseWeapon"));
		end;
		
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to drop an item.
function Clockwork:PlayerCanDropItem(player, itemTable, bNoMsg) return true; end;

-- Called when a player attempts to destroy an item.
function Clockwork:PlayerCanDestroyItem(player, itemTable, bNoMsg) return true; end;

-- Called when a player attempts to destroy generator.
function Clockwork:PlayerCanDestroyGenerator(player, entity, generator) return true; end;

-- Called when a player attempts to knockout a player.
function Clockwork:PlayerCanKnockout(player, target) return true; end;

-- Called when a player attempts to use the radio.
function Clockwork:PlayerCanRadio(player, text, listeners, eavesdroppers) return true; end;

-- Called when death attempts to clear a player's name.
function Clockwork:PlayerCanDeathClearName(player, attacker, damageInfo) return false; end;

-- Called when death attempts to clear a player's recognised names.
function Clockwork:PlayerCanDeathClearRecognisedNames(player, attacker, damageInfo) return false; end;

-- Called when a player's ragdoll attempts to take damage.
function Clockwork:PlayerRagdollCanTakeDamage(player, ragdoll, inflictor, attacker, hitGroup, damageInfo)
	if (!attacker:IsPlayer() and player:GetRagdollTable().immunity) then
		if (CurTime() <= player:GetRagdollTable().immunity) then
			return false;
		end;
	end;
	
	return true;
end;

-- Called when the player attempts to be ragdolled.
function Clockwork:PlayerCanRagdoll(player, state, delay, decay, ragdoll)
	return true;
end;

-- Called when the player attempts to be unragdolled.
function Clockwork:PlayerCanUnragdoll(player, state, ragdoll)
	return true;
end;

-- Called when a player has been ragdolled.
function Clockwork:PlayerRagdolled(player, state, ragdoll)
	player:SetSharedVar("FallenOver", false);
end;

-- Called when a player has been unragdolled.
function Clockwork:PlayerUnragdolled(player, state, ragdoll)
	player:SetSharedVar("FallenOver", false);
end;

-- Called to check if a player does have a flag.
function Clockwork:PlayerDoesHaveFlag(player, flag)
	if (string.find(cwConfig:Get("default_flags"):Get(), flag)) then
		return true;
	end;
end;

-- Called when a player's model should be set.
function Clockwork:PlayerSetModel(player)
	cwPly:SetDefaultModel(player);
	cwPly:SetDefaultSkin(player);
end;

-- Called to check if a player does have door access.
function Clockwork:PlayerDoesHaveDoorAccess(player, door, access, isAccurate)
	if (cwEntity:GetOwner(door) != player) then
		local key = player:GetCharacterKey();
		
		if (door.accessList and door.accessList[key]) then
			if (isAccurate) then
				return door.accessList[key] == access;
			else
				return door.accessList[key] >= access;
			end;
		end;
		
		return false;
	else
		return true;
	end;
end;

-- Called to check if a player does know another player.
function Clockwork:PlayerDoesRecognisePlayer(player, target, status, isAccurate, realValue)
	return realValue;
end;

-- Called when a player attempts to lock an entity.
function Clockwork:PlayerCanLockEntity(player, entity)
	if (cwEntity:IsDoor(entity)) then
		return cwPly:HasDoorAccess(player, entity);
	else
		return true;
	end;
end;

-- Called when a player's class has been set.
function Clockwork:PlayerClassSet(player, newClass, oldClass, noRespawn, addDelay, noModelChange) end;

-- Called when a player attempts to unlock an entity.
function Clockwork:PlayerCanUnlockEntity(player, entity)
	if (cwEntity:IsDoor(entity)) then
		return cwPly:HasDoorAccess(player, entity);
	else
		return true;
	end;
end;

-- Called when a player attempts to use a door.
function Clockwork:PlayerCanUseDoor(player, door)
	if (cwEntity:GetOwner(door) and !cwPly:HasDoorAccess(player, door)) then
		return false;
	end;
	
	if (cwEntity:IsDoorFalse(door)) then
		return false;
	end;
	
	return true;
end;

-- Called when a player uses a door.
function Clockwork:PlayerUseDoor(player, door) end;

-- Called when a player attempts to use an entity in a vehicle.
function Clockwork:PlayerCanUseEntityInVehicle(player, entity, vehicle)
	if (entity.UsableInVehicle or cwEntity:IsDoor(entity)) then
		return true;
	end;
end;

-- Called when a player's ragdoll attempts to decay.
function Clockwork:PlayerCanRagdollDecay(player, ragdoll, seconds)
	return true;
end;

-- Called when a player attempts to exit a vehicle.
function Clockwork:CanExitVehicle(vehicle, player)
	local curTime = CurTime();

	if (player.cwNextExitVehicle and player.cwNextExitVehicle > curTime) then
		return false;
	end;
	
	if (IsValid(player) and player:IsPlayer()) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (IsValid(trace.Entity) and !trace.Entity:IsVehicle()) then
			if (cwPlugin:Call("PlayerCanUseEntityInVehicle", player, trace.Entity, vehicle)) then
				return false;
			end;
		end;
	end;
	
	if (cwEntity:IsChairEntity(vehicle) and !IsValid(vehicle:GetParent())) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			trace = {
				start = trace.HitPos,
				endpos = trace.HitPos - Vector(0, 0, 1024),
				filter = {player, vehicle}
			};
			
			player.cwExitVehiclePos = util.TraceLine(trace).HitPos;
			
			player:SetMoveType(MOVETYPE_NOCLIP);
		else
			return false;
		end;
	end;
	
	return true;
end;

-- Called when a player leaves a vehicle.
function Clockwork:PlayerLeaveVehicle(player, vehicle)
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player) and !player:InVehicle()) then
			if (IsValid(vehicle)) then
				if (cwEntity:IsChairEntity(vehicle)) then
					local position = player.cwExitVehiclePos or vehicle:GetPos();
					local targetPosition = cwPly:GetSafePosition(player, position, vehicle);
					
					if (targetPosition) then
						player:SetMoveType(MOVETYPE_NOCLIP);
						player:SetPos(targetPosition);
					end;
					
					player:SetMoveType(MOVETYPE_WALK);
					player.cwExitVehiclePos = nil;
				end;
			end;
		end;
	end);
end;

-- Called when a player attempts to enter a vehicle.
function Clockwork:CanPlayerEnterVehicle(player, vehicle, role)
	return true;
end;

-- Called when a player enters a vehicle.
function Clockwork:PlayerEnteredVehicle(player, vehicle, class)
	timer.Simple(FrameTime() * 0.5, function()
		if (IsValid(player)) then
			local model = player:GetModel();
			local class = self.animation:GetModelClass(model);
			
			if (IsValid(vehicle) and !string.find(model, "/player/")) then
				if (class == "maleHuman" or class == "femaleHuman") then
					if (cwEntity:IsChairEntity(vehicle)) then
						player:SetLocalPos(Vector(16.5438, -0.1642, -20.5493));
					else
						player:SetLocalPos(Vector(30.1880, 4.2020, -6.6476));
					end;
				end;
			end;
			
			player:SetCollisionGroup(COLLISION_GROUP_PLAYER);
		end;
	end);
end;

-- Called when a player attempts to change class.
function Clockwork:PlayerCanChangeClass(player, class)
	local curTime = CurTime();
	
	if (player.cwNextChangeClass and curTime < player.cwNextChangeClass) then
		cwPly:Notify(player, L(player, "CannotChangeClassFor",
			math.ceil(player.cwNextChangeClass - curTime))
		);
		
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to earn generator cash.
function Clockwork:PlayerCanEarnGeneratorCash(player, info, cash)
	return true;
end;

-- Called when a player earns generator cash.
function Clockwork:PlayerEarnGeneratorCash(player, info, cash) end;

-- Called when a player attempts to earn wages cash.
function Clockwork:PlayerCanEarnWagesCash(player, cash)
	return true;
end;

-- Called when a player is given wages cash.
function Clockwork:PlayerGiveWagesCash(player, cash, wagesName)
	return true;
end;

-- Called when a player earns wages cash.
function Clockwork:PlayerEarnWagesCash(player, cash) end;

-- Called when Clockwork has loaded all of the entities.
function Clockwork:ClockworkInitPostEntity() end;

-- Called when a player attempts to say something in-character.
function Clockwork:PlayerCanSayIC(player, text)
	if ((!player:Alive() or player:IsRagdolled(RAGDOLL_FALLENOVER)) and !cwPly:GetDeathCode(player, true)) then
		cwPly:Notify(player, L(player, "CannotActionRightNow"));
		
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to say something out-of-character.
function Clockwork:PlayerCanSayOOC(player, text) return true; end;

-- Called when a player attempts to say something locally out-of-character.
function Clockwork:PlayerCanSayLOOC(player, text) return true; end;

-- Called when attempts to use a command.
function Clockwork:PlayerCanUseCommand(player, commandTable, arguments)
	return true;
end;

-- Called when a player speaks from the client.
function Clockwork:PlayerSay(player, text, bPublic)
	local prefix = cwConfig:Get("command_prefix"):Get();
	local prefixLength = string.len(prefix);

 	if (string.sub(text, 1, prefixLength) == prefix) then
		local arguments = cwKernel:ExplodeByTags(text, " ", "\"", "\"", true);
		local command = string.sub(arguments[1], prefixLength + 1);
		local realCommand = cwCommand:GetAlias()[command] or command;

		return string.Replace(text, prefix..command, prefix..realCommand);
 	end;
end;

-- Called when a player attempts to suicide.
function Clockwork:CanPlayerSuicide(player) return false; end;

-- Called when a player attempts to punt an entity with the gravity gun.
function Clockwork:GravGunPunt(player, entity)
	return cwConfig:Get("enable_gravgun_punt"):Get();
end;

-- Called when a player attempts to pickup an entity with the gravity gun.
function Clockwork:GravGunPickupAllowed(player, entity)
	if (IsValid(entity)) then
		if (!cwPly:IsAdmin(player) and !cwEntity:IsInteractable(entity)) then
			return false;
		else
			return self.BaseClass:GravGunPickupAllowed(player, entity);
		end;
	end;
	
	return false;
end;

-- Called when a player picks up an entity with the gravity gun.
function Clockwork:GravGunOnPickedUp(player, entity)
	player.cwIsHoldingEnt = entity;
	entity.cwIsBeingHeld = player;
end;

-- Called when a player drops an entity with the gravity gun.
function Clockwork:GravGunOnDropped(player, entity)
	player.cwIsHoldingEnt = nil;
	entity.cwIsBeingHeld = nil;
end;

-- Called when a player attempts to unfreeze an entity.
function Clockwork:CanPlayerUnfreeze(player, entity, physicsObject)
	local bIsAdmin = cwPly:IsAdmin(player);
	
	if (cwConfig:Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false;
		end;
	end;
	
	if (!bIsAdmin and !cwEntity:IsInteractable(entity)) then
		return false;
	end;
	
	if (entity:IsVehicle()) then
		if (IsValid(entity:GetDriver())) then
			return false;
		end;
	end;
	
	return true;
end;

-- Called when a player attempts to freeze an entity with the physics gun.
function Clockwork:OnPhysgunFreeze(weapon, physicsObject, entity, player)
	local bIsAdmin = cwPly:IsAdmin(player);
	
	if (cwConfig:Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false;
		end;
	end;
	
	if (!bIsAdmin and cwEntity:IsChairEntity(entity)) then
		local entities = ents.FindInSphere(entity:GetPos(), 64);
		
		for k, v in pairs(entities) do
			if (cwEntity:IsDoor(v)) then
				return false;
			end;
		end;
	end;
	
	if (entity:GetPhysicsObject():IsPenetrating()) then
		return false;
	end;
	
	if (!bIsAdmin and entity.PhysgunDisabled) then
		return false;
	end;
	
	if (!bIsAdmin and !cwEntity:IsInteractable(entity)) then
		return false;
	else
		return self.BaseClass:OnPhysgunFreeze(weapon, physicsObject, entity, player);
	end;
end;

-- Called when a player attempts to pickup an entity with the physics gun.
function Clockwork:PhysgunPickup(player, entity)
	local bCanPickup = nil;
	local bIsAdmin = cwPly:IsAdmin(player);

	if (!cwConfig:Get("enable_map_props_physgrab"):Get()) then
		if (cwEntity:IsMapEntity(entity)) then
			bCanPickup = false;
		end;
	end;
	
	if (!bIsAdmin and !cwEntity:IsInteractable(entity)) then
		return false;
	end;
	
	if (!bIsAdmin and cwEntity:IsPlayerRagdoll(entity)) then
		return false;
	end;
	
	if (!bIsAdmin and entity:GetClass() == "prop_ragdoll") then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			return false;
		end;
	end;
	
	if (!bIsAdmin) then
		bCanPickup = self.BaseClass:PhysgunPickup(player, entity);
	else
		bCanPickup = true;
	end;
	
	if (cwEntity:IsChairEntity(entity) and !bIsAdmin) then
		local entities = ents.FindInSphere(entity:GetPos(), 256);
		
		for k, v in pairs(entities) do
			if (cwEntity:IsDoor(v)) then
				return false;
			end;
		end;
	end;
	
	if (cwConfig:Get("enable_prop_protection"):Get() and !bIsAdmin) then
		local ownerKey = entity:GetOwnerKey();
		
		if (ownerKey and player:GetCharacterKey() != ownerKey) then
			bCanPickup = false;
		end;
	end;
	
	if (entity:IsPlayer() and entity:InVehicle() or entity.cwObserverMode) then
		bCanPickup = false;
	end;
	
	if (bCanPickup) then
		player.cwIsHoldingEnt = entity;
		entity.cwIsBeingHeld = player;
		
		if (!entity:IsPlayer()) then
			if (cwConfig:Get("prop_kill_protection"):Get()
			and !entity.cwLastCollideGroup) then
				cwEntity:StopCollisionGroupRestore(entity);
				entity.cwLastCollideGroup = entity:GetCollisionGroup();
				entity:SetCollisionGroup(COLLISION_GROUP_WEAPON);
			end;
			
			entity.cwDamageImmunity = CurTime() + 60;
		elseif (!entity.cwMoveType) then
			entity.cwMoveType = entity:GetMoveType();
			entity:SetMoveType(MOVETYPE_NOCLIP);
		end;
		
		return true;
	else
		return false;
	end;
end;

-- Called when a player attempts to drop an entity with the physics gun.
function Clockwork:PhysgunDrop(player, entity)
	if (!entity:IsPlayer() and entity.cwLastCollideGroup) then
		cwEntity:ReturnCollisionGroup(
			entity, entity.cwLastCollideGroup
		);
		
		entity.cwLastCollideGroup = nil;
	elseif (entity.cwMoveType) then
		entity:SetMoveType(MOVETYPE_WALK);
		entity.cwMoveType = nil;
	end;
	
	entity.cwDamageImmunity = CurTime() + 60;
	player.cwIsHoldingEnt = nil;
	entity.cwIsBeingHeld = nil;
end;

-- Called when a player attempts to spawn an NPC.
function Clockwork:PlayerSpawnNPC(player, model)
	if (!cwPly:HasFlags(player, "n")) then
		return false;
	end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		cwPly:Notify(player, L(player, "CannotActionRightNow"));
		
		return false;
	end;
	
	if (!cwPly:IsAdmin(player)) then
		return false;
	else
		return true;
	end;
end;

-- Called when an NPC has been killed.
function Clockwork:OnNPCKilled(entity, attacker, inflictor) end;

-- Called to get whether an entity is being held.
function Clockwork:GetEntityBeingHeld(entity)
	return entity.cwIsBeingHeld or entity:IsPlayerHolding();
end;

-- Called when an entity is removed.
function Clockwork:EntityRemoved(entity)
	if (!cwKernel:IsShuttingDown()) then
		if (IsValid(entity)) then
			if (entity:GetClass() == "prop_ragdoll") then
				if (entity.cwIsBelongings and entity.cwInventory and entity.cwCash
				and (table.Count(entity.cwInventory) > 0 or entity.cwCash > 0)) then
					local belongings = ents.Create("cw_belongings");
						
					belongings:SetAngles(Angle(0, 0, -90));
					belongings:SetData(entity.cwInventory, entity.cwCash);
					belongings:SetPos(entity:GetPos() + Vector(0, 0, 32));
					belongings:Spawn();
						
					entity.cwInventory = nil;
					entity.cwCash = nil;
				end;
			end;

			local allProperty = cwPly:GetAllProperty();
			local entIndex = entity:EntIndex();
			
			if (entity.cwGiveRefundTab
			and CurTime() <= entity.cwGiveRefundTab[1]) then
				if (IsValid(entity.cwGiveRefundTab[2])) then
					cwPly:GiveCash(entity.cwGiveRefundTab[2], entity.cwGiveRefundTab[3], "Prop Refund");
				end;
			end;
			
			allProperty[entIndex] = nil;
			
			if (entity:GetClass() == "csItem") then
				cwItem:RemoveItemEntity(entity);
			end;
		end;
		
		cwEntity:ClearProperty(entity);
	end;
end;

-- Called when an entity's menu option should be handled.
function Clockwork:EntityHandleMenuOption(player, entity, option, arguments)
	local class = entity:GetClass();
	local generator = self.generator:FindByID(class);
	
	if (class == "cw_item" and (arguments == "cwItemTake" or arguments == "cwItemUse")) then
		if (cwEntity:BelongsToAnotherCharacter(player, entity)) then
			cwPly:Notify(player, L(player, "DroppedItemsOtherChar"));
			return;
		end;
		
		local itemTable = entity.cwItemTable;
		local bQuickUse = (arguments == "cwItemUse");
		
		if (itemTable) then
			local bDidPickupItem = true;
			local bCanPickup = (!itemTable.CanPickup or itemTable:CanPickup(player, bQuickUse, entity));
			
			if (bCanPickup != false) then
				player:SetItemEntity(entity);
				
				if (bQuickUse) then
					itemTable = player:GiveItem(itemTable, true);
					
					if (!cwPly:InventoryAction(player, itemTable, "use")) then
						player:TakeItem(itemTable, true);
						bDidPickupItem = false;
					else
						player:FakePickup(entity);
					end;
				else
					local bSuccess, fault = player:GiveItem(itemTable);
					
					if (!bSuccess) then
						cwPly:Notify(player, fault);
						bDidPickupItem = false;
					else
						player:FakePickup(entity);
					end;
				end;
				
				cwPlugin:Call(
					"PlayerPickupItem", player, itemTable, entity, bQuickUse
				);
				
				if (bDidPickupItem) then
					if (!itemTable.OnPickup or itemTable:OnPickup(player, bQuickUse, entity) != false) then
						entity:Remove();
					end;
				end;

				local pickupSound = itemTable.pickupSound or "physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav"

				if (type(pickupSound) == "table") then
					pickupSound = pickupSound[math.random(1, #pickupSound)];
				end;

				player:EmitSound(pickupSound);
				
				player:SetItemEntity(nil);
			end;
			
		end;
	elseif (class == "cw_item" and arguments == "cwItemExamine") then
		local itemTable = entity.cwItemTable;
		local examineText = itemTable.description;
			
		if (itemTable.GetEntityExamineText) then
			examineText = itemTable:GetEntityExamineText(entity);
		end;

		cwPly:Notify(player, examineText);
	elseif (class == "cw_item" and arguments == "cwItemAmmo") then
		local itemTable = entity.cwItemTable;
		
		if (cwItem:IsWeapon(itemTable)) then
			if (itemTable:HasSecondaryClip() or itemTable:HasPrimaryClip()) then
				local clipOne = itemTable:GetData("ClipOne");
				local clipTwo = itemTable:GetData("ClipTwo");
				
				if (clipTwo > 0) then
					player:GiveAmmo(clipTwo, itemTable("secondaryAmmoClass"));
				end;
				
				if (clipOne > 0) then
					player:GiveAmmo(clipOne, itemTable("primaryAmmoClass"));
				end;
				
				itemTable:SetData("ClipOne", 0);
				itemTable:SetData("ClipTwo", 0);
				
				player:FakePickup(entity);
			end;
		end;
	elseif (class == "cw_item") then
		local itemTable = entity.cwItemTable;

		if (itemTable and itemTable.EntityHandleMenuOption) then
			itemTable:EntityHandleMenuOption(player, entity, option, arguments);
		end;
	elseif (entity:GetClass() == "cw_belongings" and arguments == "cwBelongingsOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		
		cwStorage:Open(player, {
			name = "Belongings",
			cash = entity.cwCash,
			weight = 100,
			space = 200,
			entity = entity,
			distance = 192,
			inventory = entity.cwInventory,
			isOneSided = true,
			OnGiveCash = function(player, storageTable, cash)
				entity.cwCash = storageTable.cash;
			end,
			OnTakeCash = function(player, storageTable, cash)
				entity.cwCash = storageTable.cash;
			end,
			OnClose = function(player, storageTable, entity)
				if (IsValid(entity)) then
					if ((!entity.cwInventory and !entity.cwCash)
					or (table.Count(entity.cwInventory) == 0 and entity.cwCash == 0)) then
						entity:Explode(entity:BoundingRadius() * 2);
						entity:Remove();
					end;
				end;
			end,
			CanGiveItem = function(player, storageTable, itemTable)
				return false;
			end
		});
	elseif (class == "cw_shipment" and arguments == "cwShipmentOpen") then
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		player:FakePickup(entity);
		
		cwStorage:Open(player, {
			name = "Shipment",
			weight = entity.cwWeight,
			space = entity.cwSpace,
			entity = entity,
			distance = 192,
			inventory = entity.cwInventory,
			isOneSided = true,
			OnClose = function(player, storageTable, entity)
				if (IsValid(entity) and cwInventory:IsEmpty(entity.cwInventory)) then
					entity:Explode(entity:BoundingRadius() * 2);
					entity:Remove();
				end;
			end,
			CanGiveItem = function(player, storageTable, itemTable)
				return false;
			end
		});
	elseif (class == "cw_cash" and arguments == "cwCashTake") then
		if (cwEntity:BelongsToAnotherCharacter(player, entity)) then
			cwPly:Notify(player, L(player, "DroppedCashOtherChar", cwOption:GetKey("name_cash", true)));
			return;
		end;
		
		cwPly:GiveCash(player, entity.cwAmount, cwOption:GetKey("name_cash"));
		player:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
		player:FakePickup(entity);
		
		entity:Remove();
	elseif (generator and arguments == "cwGeneratorSupply") then
		if (entity:GetPower() < generator.power) then
			if (!entity.CanSupply or entity:CanSupply(player, generator)) then
				cwPlugin:Call("PlayerChargeGenerator", player, entity, generator);
				
				entity:SetDTInt(0, generator.power);
				player:FakePickup(entity);
				
				if (entity.OnSupplied) then
					entity:OnSupplied(player);
				end;
				
				entity:Explode();
			end;
		end;
	end;
end;

-- Called when a player has spawned a prop.
function Clockwork:PlayerSpawnedProp(player, model, entity)
	if (IsValid(entity)) then
		local scalePropCost = cwConfig:Get("scale_prop_cost"):Get();
		
		if (scalePropCost > 0) then
			local cost = math.ceil(math.max((entity:BoundingRadius() / 2) * scalePropCost, 1));
			local info = {cost = cost, name = "Prop"};
			
			cwPlugin:Call("PlayerAdjustPropCostInfo", player, entity, info);
			
			if (cwPly:CanAfford(player, info.cost)) then
				cwPly:GiveCash(player, -info.cost, info.name);
				entity.cwGiveRefundTab = {CurTime() + 10, player, info.cost};
			else
				cwPly:Notify(player, L(player, "YouNeedAnother", cwKernel:FormatCash(info.cost - player:GetCash(), nil, true)));
				entity:Remove();
				return;
			end;
		end;
		
		if (IsValid(entity)) then
			self.BaseClass:PlayerSpawnedProp(player, model, entity);
			entity:SetOwnerKey(player:GetCharacterKey());
			
			if (IsValid(entity)) then
				cwKernel:PrintLog(LOGTYPE_URGENT, player:Name().." has spawned '"..tostring(model).."'.");
				
				if (cwConfig:Get("prop_kill_protection"):Get()) then
					entity.cwDamageImmunity = CurTime() + 60;
				end;
			end;
		end;
	end;
end;

-- Called when a player attempts to spawn a prop.
function Clockwork:PlayerSpawnProp(player, model)
	if (!cwPly:HasFlags(player, "e")) then
		return false;
	end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		cwPly:Notify(player, L(player, "CannotActionRightNow"));
		return false;
	end;
	
	if (cwPly:IsAdmin(player)) then
		return true;
	end;
	
	return self.BaseClass:PlayerSpawnProp(player, model);
end;

-- Called when a player attempts to spawn a ragdoll.
function Clockwork:PlayerSpawnRagdoll(player, model)
	if (!cwPly:HasFlags(player, "r")) then return false; end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		cwPly:Notify(player, L(player, "CannotActionRightNow"));
		
		return false;
	end;
	
	if (!cwPly:IsAdmin(player)) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to spawn an effect.
function Clockwork:PlayerSpawnEffect(player, model)
	if (!player:Alive() or player:IsRagdolled()) then
		cwPly:Notify(player, L(player, "CannotActionRightNow"));
		
		return false;
	end;
	
	if (!cwPly:IsAdmin(player)) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player attempts to spawn a vehicle.
function Clockwork:PlayerSpawnVehicle(player, model)
	if (!string.find(model, "chair") and !string.find(model, "seat")) then
		if (!cwPly:HasFlags(player, "C")) then
			return false;
		end;
	elseif (!cwPly:HasFlags(player, "c")) then
		return false;
	end;
	
	if (!player:Alive() or player:IsRagdolled()) then
		cwPly:Notify(player, L(player, "CannotActionRightNow"));
		
		return false;
	end;
	
	if (cwPly:IsAdmin(player)) then
		return true;
	end;
	
	return self.BaseClass:PlayerSpawnVehicle(player, model);
end;

-- Called when a player attempts to use a tool.
function Clockwork:CanTool(player, trace, tool)
	local bIsAdmin = cwPly:IsAdmin(player);
	
	if (IsValid(trace.Entity)) then
		local bPropProtectionEnabled = cwConfig:Get("enable_prop_protection"):Get();
		local characterKey = player:GetCharacterKey();
		
		if (!bIsAdmin and !cwEntity:IsInteractable(trace.Entity)) then
			return false;
		end;
		
		if (!bIsAdmin and cwEntity:IsPlayerRagdoll(trace.Entity)) then
			return false;
		end;
		
		if (bPropProtectionEnabled and !bIsAdmin) then
			local ownerKey = trace.Entity:GetOwnerKey();
			
			if (ownerKey and characterKey != ownerKey) then
				return false;
			end;
		end;
		
		if (!bIsAdmin) then
			if (tool == "nail") then
				local newTrace = {};
				
				newTrace.start = trace.HitPos;
				newTrace.endpos = trace.HitPos + player:GetAimVector() * 16;
				newTrace.filter = {player, trace.Entity};
				
				newTrace = util.TraceLine(newTrace);
				
				if (IsValid(newTrace.Entity)) then
					if (!cwEntity:IsInteractable(newTrace.Entity) or cwEntity:IsPlayerRagdoll(newTrace.Entity)) then
						return false;
					end;
					
					if (bPropProtectionEnabled) then
						local ownerKey = newTrace.Entity:GetOwnerKey();
						
						if (ownerKey and characterKey != ownerKey) then
							return false;
						end;
					end;
				end;
			elseif (tool == "remover" and player:KeyDown(IN_ATTACK2) and !player:KeyDownLast(IN_ATTACK2)) then
				if (!trace.Entity:IsMapEntity()) then
					local entities = constraint.GetAllConstrainedEntities(trace.Entity);
					
					for k, v in pairs(entities) do
						if (v:IsMapEntity() or cwEntity:IsPlayerRagdoll(v)) then
							return false;
						end;
						
						if (bPropProtectionEnabled) then
							local ownerKey = v:GetOwnerKey();
							
							if (ownerKey and characterKey != ownerKey) then
								return false;
							end;
						end;
					end
				else
					return false;
				end;
			end
		end;
	end;
	
	if (!bIsAdmin) then
		if (tool == "dynamite" or tool == "duplicator") then
			return false;
		end;
	
		return self.BaseClass:CanTool(player, trace, tool);
	else
		return true;
	end;
end;

-- Called when a player attempts to use the property menu.
function Clockwork:CanProperty(player, property, entity)
	local bIsAdmin = cwPly:IsAdmin(player);
	
	if (!player:Alive() or player:IsRagdolled() or !bIsAdmin) then
		return false;
	end;
	
	return self.BaseClass:CanProperty(player, property, entity);
end;

-- Called when a player attempts to use drive.
function Clockwork:CanDrive(player, entity)
	local bIsAdmin = cwPly:IsAdmin(player);
	
	if (!player:Alive() or player:IsRagdolled() or !bIsAdmin) then
		return false;
	end;

	return self.BaseClass:CanDrive(player, entity);
end;

-- Called when a player attempts to NoClip.
function Clockwork:PlayerNoClip(player)
	if (player:IsRagdolled()) then
		return false;
	elseif (player:IsSuperAdmin()) then
		return true;
	else
		return false;
	end;
end;

-- Called when a player's character has initialized.
function Clockwork:PlayerCharacterInitialized(player)
	cwDatastream:Start(player, "InvClear", true);
	cwDatastream:Start(player, "AttrClear", true);
	cwDatastream:Start(player, "ReceiveLimbDamage", player:GetCharacterData("LimbData"));
	
	if (!cwClass:FindByID(player:Team())) then
		cwClass:AssignToDefault(player);
	end;
	
	player.cwAttrProgress = player.cwAttrProgress or {};
	player.cwAttrProgressTime = 0;
	
	for k, v in pairs(self.attribute:GetAll()) do
		player:UpdateAttribute(k);
	end;
	
	for k, v in pairs(player:GetAttributes()) do
		player.cwAttrProgress[k] = math.floor(v.progress);
	end;
	
	local startHintsDelay = 4;
	local starterHintsTable = {
		"Directory",
		"Give Name",
		"Target Recognises",
		"Raise Weapon"
	};
	
	for k, v in pairs(starterHintsTable) do
		local hintTable = self.hint:Find(v);
		
		if (hintTable and !player:GetData("Hint"..k)) then
			if (!hintTable.Callback or hintTable.Callback(player) != false) then
				timer.Simple(startHintsDelay, function()
					if (IsValid(player)) then
						self.hint:Send(player, hintTable.text, 30);
						player:SetData("Hint"..k, true);
					end;
				end);
				
				startHintsDelay = startHintsDelay + 30;
			end;
		end;
	end;
	
	if (startHintsDelay > 4) then
		player.cwViewStartHints = true;
		
		timer.Simple(startHintsDelay, function()
			if (IsValid(player)) then
				player.cwViewStartHints = false;
			end;
		end);
	end;
	
	timer.Simple(FrameTime() * 0.5, function()
		self.inventory:SendUpdateAll(player);
		player:NetworkAccessories();
	end);
	
	cwDatastream:Start(player, "CharacterInit", player:GetCharacterKey());

	local faction = cwFaction:FindByID(player:GetFaction());
	local spawnRank = cwFaction:GetDefaultRank(player:GetFaction()) or cwFaction:GetLowestRank(player:GetFaction());
	
	player:SetFactionRank(player:GetFactionRank() or spawnRank);
	
	if (string.find(player:Name(), "SCN")) then
		player:SetFactionRank("SCN");
	end;
	
	local rankName, rankTable = player:GetFactionRank();
	
	if (rankTable) then
		if (rankTable.class and cwClass:GetAll()[rankTable.class]) then

			cwClass:Set(player, rankTable.class);
		end;
		
		if (rankTable.model) then
			player:SetModel(rankTable.model);
		end;
	end;
end;

-- Called when a player has used their death code.
function Clockwork:PlayerDeathCodeUsed(player, commandTable, arguments) end;

-- Called when a player has created a character.
function Clockwork:PlayerCharacterCreated(player, character) end;

-- Called when a player's character has unloaded.
function Clockwork:PlayerCharacterUnloaded(player)
	cwPly:SetupRemovePropertyDelays(player);
	cwPly:DisableProperty(player);
	cwPly:SetRagdollState(player, RAGDOLL_RESET);
	cwStorage:Close(player, true)
	player:SetTeam(TEAM_UNASSIGNED);
end;

-- Called when a player's character has loaded.
function Clockwork:PlayerCharacterLoaded(player)
	player:SetSharedVar("InvWeight", cwConfig:Get("default_inv_weight"):Get());
	player:SetSharedVar("InvSpace", cwConfig:Get("default_inv_space"):Get());
	player.cwCharLoadedTime = CurTime();
	player.cwCrouchedSpeed = cwConfig:Get("crouched_speed"):Get();
	player.cwClipTwoInfo = {weapon = NULL, ammo = 0};
	player.cwClipOneInfo = {weapon = NULL, ammo = 0};
	player.cwInitialized = true;
	player.cwAttrBoosts = player.cwAttrBoosts or {};
	player.cwRagdollTab = player.cwRagdollTab or {};
	player.cwSpawnWeps = player.cwSpawnWeps or {};
	player.cwFirstSpawn = true;
	player.cwLightSpawn = false;
	player.cwChangeClass = false;
	player.cwInfoTable = player.cwInfoTable or {};
	player.cwSpawnAmmo = player.cwSpawnAmmo or {};
	player.cwJumpPower = cwConfig:Get("jump_power"):Get();
	player.cwWalkSpeed = cwConfig:Get("walk_speed"):Get();
	player.cwRunSpeed = cwConfig:Get("run_speed"):Get();
	
	hook.Call("PlayerRestoreCharacterData", Clockwork, player, player:QueryCharacter("Data"));
	hook.Call("PlayerRestoreTempData", Clockwork, player, player:CreateTempData());
	
	cwPly:SetCharacterMenuState(player, CHARACTER_MENU_CLOSE);
	cwPlugin:Call("PlayerCharacterInitialized", player);
	
	cwPly:RestoreRecognisedNames(player);
	cwPly:ReturnProperty(player);
	cwPly:SetInitialized(player, true);
	
	player.cwFirstSpawn = false;
	
	local charactersTable = cwConfig:Get("mysql_characters_table"):Get();
	local schemaFolder = cwKernel:GetSchemaFolder();
	local characterID = player:GetCharacterID();
	local onNextLoad = player:QueryCharacter("OnNextLoad");
	local steamID = player:SteamID();
	local query = "UPDATE "..charactersTable.." SET _OnNextLoad = \"\" WHERE";
	local playerFlags = player:GetPlayerFlags();
	
	if (onNextLoad != "") then
		local queryObj = cwDatabase:Update(charactersTable);
			queryObj:SetValue("_OnNextLoad", "");
			queryObj:AddWhere("_Schema = ?", schemaFolder);
			queryObj:AddWhere("_SteamID = ?", steamID);
			queryObj:AddWhere("_CharacterID = ?", characterID);
		queryObj:Push();
		
		player:SetCharacterData("OnNextLoad", "", true);
		
		CHARACTER = player:GetCharacter();
			PLAYER = player;
				RunString(onNextLoad);
			PLAYER = nil;
		CHARACTER = nil;
	end;
	
	local itemsList = cwInventory:GetAsItemsList(
		player:GetInventory()
	);
	
	for k, v in pairs(itemsList) do
		if (v.OnRestorePlayerGear) then
			v:OnRestorePlayerGear(player);
		end;
	end;
	
	if (playerFlags) then
		cwPly:GiveFlags(player, playerFlags);
	end;
end;

-- Called when a player's property should be restored.
function Clockwork:PlayerReturnProperty(player) end;

-- Called when config has initialized for a player.
function Clockwork:PlayerConfigInitialized(player)
	cwPlugin:Call("PlayerSendDataStreamInfo", player);
	
	if (!player:IsBot()) then
		timer.Simple(FrameTime() * 32, function()
			if (IsValid(player)) then
				cwDatastream:Start(player, "DataStreaming", true);
			end;
		end);
	else
		cwPlugin:Call("PlayerDataStreamInfoSent", player);
	end;
end;

-- Called when a player has used their radio.
function Clockwork:PlayerRadioUsed(player, text, listeners, eavesdroppers) end;

-- Called when a player's drop weapon info should be adjusted.
function Clockwork:PlayerAdjustDropWeaponInfo(player, info)
	return true;
end;

-- Called when a player's character creation info should be adjusted.
function Clockwork:PlayerAdjustCharacterCreationInfo(player, info, data) end;

-- Called when a player's earn generator info should be adjusted.
function Clockwork:PlayerAdjustEarnGeneratorInfo(player, info) end;

-- Called when a player's order item should be adjusted.
function Clockwork:PlayerAdjustOrderItemTable(player, itemTable) end;

-- Called when a player's next punch info should be adjusted.
function Clockwork:PlayerAdjustNextPunchInfo(player, info) end;

-- Called when a player uses an unknown item function.
function Clockwork:PlayerUseUnknownItemFunction(player, itemTable, itemFunction) end;

-- Called when a player's character table should be adjusted.
function Clockwork:PlayerAdjustCharacterTable(player, character)
	if (self.faction.stored[character.faction]) then
		if (self.faction.stored[character.faction].whitelist
		and !cwPly:IsWhitelisted(player, character.faction)) then
			character.data["CharBanned"] = true;
		end;
	else
		return true;
	end;
end;

-- Called when a player's character screen info should be adjusted.
function Clockwork:PlayerAdjustCharacterScreenInfo(player, character, info)
	local playerRank, rank = player:GetFactionRank();

	if (rank and rank.model) then
		info.model = rank.model;
	end;
end;

-- Called when a player's prop cost info should be adjusted.
function Clockwork:PlayerAdjustPropCostInfo(player, entity, info) end;

-- Called when a player's death info should be adjusted.
function Clockwork:PlayerAdjustDeathInfo(player, info) end;

-- Called when chat box info should be adjusted.
function Clockwork:ChatBoxAdjustInfo(info)
	if (info.class == "ic") then
		cwKernel:PrintLog(LOGTYPE_GENERIC, info.speaker:Name().." says: \""..info.text.."\"");
	elseif (info.class == "looc") then
		cwKernel:PrintLog(LOGTYPE_GENERIC, "[LOOC] "..info.speaker:Name()..": "..info.text);
	end;
end;

-- Called when a player's radio text should be adjusted.
function Clockwork:PlayerAdjustRadioInfo(player, info) end;

-- Called when a player should gain a frag.
function Clockwork:PlayerCanGainFrag(player, victim) return true; end;

-- Called just after a player spawns.
function Clockwork:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)	
	if (firstSpawn) then
		local attrBoosts = player:GetCharacterData("AttrBoosts");
		local health = player:GetCharacterData("Health");
		local armor = player:GetCharacterData("Armor");
		
		if (health and health > 1) then
			player:SetHealth(health);
		end;
		
		if (armor and armor > 1) then
			player:SetArmor(armor);
		end;
		
		if (attrBoosts) then
			for k, v in pairs(attrBoosts) do
				for k2, v2 in pairs(v) do
					cwAttributes:Boost(player, k2, k, v2.amount, v2.duration);
				end;
			end;
		end;
	else
		player:SetCharacterData("AttrBoosts", nil);
		player:SetCharacterData("Health", nil);
		player:SetCharacterData("Armor", nil);
	end;
	
	player:Fire("Targetname", player:GetFaction(), 0);
end;

-- Called just before a player would take damage.
function Clockwork:PrePlayerTakeDamage(player, attacker, inflictor, damageInfo) end;

-- Called when a player should take damage.
function Clockwork:PlayerShouldTakeDamage(player, attacker, inflictor, damageInfo)
	return !cwPly:IsNoClipping(player);
end;

-- Called when a player is attacked by a trace.
function Clockwork:PlayerTraceAttack(player, damageInfo, direction, trace)
	player.cwLastHitGroup = trace.HitGroup;
	return false;
end;

-- Called just before a player dies.
function Clockwork:DoPlayerDeath(player, attacker, damageInfo)
	cwPly:DropWeapons(player, attacker);
	cwPly:SetAction(player, false);
	cwPly:SetDrunk(player, false);
	
	local deathSound = cwPlugin:Call("PlayerPlayDeathSound", player, player:GetGender());
	local decayTime = cwConfig:Get("body_decay_time"):Get();

	if (decayTime > 0) then
		cwPly:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, decayTime, cwKernel:ConvertForce(damageInfo:GetDamageForce() * 32));
	else
		cwPly:SetRagdollState(player, RAGDOLL_KNOCKEDOUT, nil, 600, cwKernel:ConvertForce(damageInfo:GetDamageForce() * 32));
	end;
	
	if (cwPlugin:Call("PlayerCanDeathClearRecognisedNames", player, attacker, damageInfo)) then
		cwPly:ClearRecognisedNames(player);
	end;
	
	if (cwPlugin:Call("PlayerCanDeathClearName", player, attacker, damageInfo)) then
		cwPly:ClearName(player);
	end;
	
	if (deathSound) then
		player:EmitSound("physics/flesh/flesh_impact_hard"..math.random(1, 5)..".wav", 150);
		
		timer.Simple(FrameTime() * 25, function()
			if (IsValid(player)) then
				player:EmitSound(deathSound);
			end;
		end);
	end;
	
	player:SetForcedAnimation(false);
	player:SetCharacterData("Ammo", {}, true);
	player:StripWeapons();
	player:Extinguish();
	player.cwSpawnAmmo = {};
	player:StripAmmo();
	player:AddDeaths(1);
	player:UnLock();
	
	if (IsValid(attacker) and attacker:IsPlayer() and player != attacker) then
		if (cwPlugin:Call("PlayerCanGainFrag", attacker, player)) then
			attacker:AddFrags(1);
		end;
	end;
end;

-- Called when a player dies.
function Clockwork:PlayerDeath(player, inflictor, attacker, damageInfo)
	cwKernel:CalculateSpawnTime(player, inflictor, attacker, damageInfo);
	
	local ragdoll = player:GetRagdollEntity();

	if (ragdoll) then		
		if (IsValid(inflictor) and inflictor:GetClass() == "prop_combine_ball") then
			if (damageInfo) then
				cwEntity:Disintegrate(ragdoll, 3, damageInfo:GetDamageForce() * 32);
			else
				cwEntity:Disintegrate(ragdoll, 3);
			end;
		end;
	end;
	
	if (damageInfo) then
		if (attacker:IsPlayer()) then
			if (IsValid(attacker:GetActiveWeapon())) then
				local weapon = attacker:GetActiveWeapon();
				local itemTable = cwItem:GetByWeapon(weapon);
			
				if (IsValid(weapon) and itemTable) then
					cwKernel:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name().." with "..itemTable("name")..", killing them!");
				else
					cwKernel:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name().." with "..cwPly:GetWeaponClass(attacker)..", killing them!");
				end;
			else
				cwKernel:PrintLog(LOGTYPE_CRITICAL, attacker:Name().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name()..", killing them!");
			end;
		else
			cwKernel:PrintLog(LOGTYPE_CRITICAL, attacker:GetClass().." has dealt "..tostring(math.ceil(damageInfo:GetDamage())).." damage to "..player:Name()..", killing them!");
		end;
	end;
end;

-- Called when an item entity has taken damage.
function Clockwork:ItemEntityTakeDamage(itemEntity, itemTable, damageInfo)
	return true;
end;

-- Called when an item entity has been destroyed.
function Clockwork:ItemEntityDestroyed(itemEntity, itemTable) end;

-- Called when an item's network observers are needed.
function Clockwork:ItemGetNetworkObservers(itemTable, info)
	local uniqueID = itemTable("uniqueID");
	local itemID = itemTable("itemID");
	local entity = cwItem:FindEntityByInstance(itemTable);
	
	if (entity) then
		info.sendToAll = true;
		return false;
	end;
	
	for k, v in pairs(player.GetAll()) do
		if (v:HasInitialized()) then
			local inventory = cwStorage:Query(v, "inventory");
			
			if ((inventory and inventory[uniqueID]
			and inventory[uniqueID][itemID]) or v:HasItemInstance(itemTable)) then
				info.observers[v] = v;
			elseif (v:HasItemAsWeapon(itemTable)) then
				info.observers[v] = v;
			end;
		end;
	end;
end;

-- Called when a player's weapons should be given.
function Clockwork:PlayerLoadout(player)
	local weapons = cwClass:Query(player:Team(), "weapons");
	local ammo = cwClass:Query(player:Team(), "ammo");
	
	player.cwSpawnWeps = {};
	player.cwSpawnAmmo = {};
	
	if (cwPly:HasFlags(player, "t")) then
		cwPly:GiveSpawnWeapon(player, "gmod_tool");
	end
	
	if (cwPly:HasFlags(player, "p")) then
		cwPly:GiveSpawnWeapon(player, "weapon_physgun");
		
		if (cwConfig:Get("custom_weapon_color"):Get()) then
			local weaponColor = player:GetInfo("cl_weaponcolor");

			player:SetWeaponColor(Vector(weaponColor));
		end;
	end
	
	cwPly:GiveSpawnWeapon(player, "weapon_physcannon");
	
	if (cwConfig:Get("give_hands"):Get()) then
		cwPly:GiveSpawnWeapon(player, "cw_hands");
	end;
	
	if (cwConfig:Get("give_keys"):Get()) then
		cwPly:GiveSpawnWeapon(player, "cw_keys");
	end;
	
	if (weapons) then
		for k, v in pairs(weapons) do
			if (!player:HasItemByID(v)) then
				local itemTable = cwItem:CreateInstance(v);
				
				if (!cwPly:GiveSpawnItemWeapon(player, itemTable)) then
					player:Give(v);
				end;
			end;
		end;
	end;
	
	if (ammo) then
		for k, v in pairs(ammo) do
			cwPly:GiveSpawnAmmo(player, k, v);
		end;
	end;
	
	cwPlugin:Call("PlayerGiveWeapons", player);
	
	if (cwConfig:Get("give_hands"):Get()) then
		player:SelectWeapon("cw_hands");
	end;
end

-- Called when the server shuts down.
function Clockwork:ShutDown()
	self.ShuttingDown = true;
end;

-- Called when a player presses F1.
function Clockwork:ShowHelp(player)
	cwDatastream:Start(player, "InfoToggle", true);
end;

-- Called when a player presses F2.
function Clockwork:ShowTeam(ply)
	if (!cwPly:IsNoClipping(ply)) then
		local doRecogniseMenu = true;
		-- local entity = ply:GetEyeTraceNoCursor().Entity;
		-- local plyTable = player.GetAll();
		
		-- if (IsValid(entity) and cwEntity:IsDoor(entity)) then
		-- 	if (entity:GetPos():Distance(ply:GetShootPos()) <= 192) then
		-- 		if (cwPlugin:Call("PlayerCanViewDoor", ply, entity)) then
		-- 			if (cwPlugin:Call("PlayerUse", ply, entity)) then
		-- 				local owner = cwEntity:GetOwner(entity);
						
		-- 				if (IsValid(owner)) then
		-- 					if (cwPly:HasDoorAccess(ply, entity, DOOR_ACCESS_COMPLETE)) then
		-- 						local data = {
		-- 							sharedAccess = cwEntity:DoorHasSharedAccess(entity),
		-- 							sharedText = cwEntity:DoorHasSharedText(entity),
		-- 							unsellable = cwEntity:IsDoorUnsellable(entity),
		-- 							accessList = {},
		-- 							isParent = cwEntity:IsDoorParent(entity),
		-- 							entity = entity,
		-- 							owner = owner
		-- 						};
								
		-- 						for k, v in pairs(plyTable) do
		-- 							if (v != ply and v != owner) then
		-- 								if (cwPly:HasDoorAccess(v, entity, DOOR_ACCESS_COMPLETE)) then
		-- 									data.accessList[v] = DOOR_ACCESS_COMPLETE;
		-- 								elseif (cwPly:HasDoorAccess(v, entity, DOOR_ACCESS_BASIC)) then
		-- 									data.accessList[v] = DOOR_ACCESS_BASIC;
		-- 								end;
		-- 							end;
		-- 						end;
								
		-- 						cwDatastream:Start(ply, "DoorManagement", data);
		-- 					end;
		-- 				else
		-- 					cwDatastream:Start(ply, "PurchaseDoor", entity);
		-- 				end;
		-- 			end;
		-- 		end;
				
		-- 		doRecogniseMenu = false;
		-- 	end;
		-- end;
		
		cwDatastream:Start(ply, "RecogniseMenu", true);
	end;
end;

-- Called when a player selects a custom character option.
function Clockwork:PlayerSelectCustomCharacterOption(player, action, character) end;

-- Called when a player takes damage.
function Clockwork:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	if (damageInfo:IsBulletDamage() and cwEvent:CanRun("limb_damage", "stumble")) then
		if (hitGroup == HITGROUP_LEFTLEG or hitGroup == HITGROUP_RIGHTLEG) then
			local rightLeg = cwLimb:GetDamage(player, HITGROUP_RIGHTLEG);
			local leftLeg = cwLimb:GetDamage(player, HITGROUP_LEFTLEG);
			
			if (rightLeg > 50 and leftLeg > 50 and !player:IsRagdolled()) then
				cwPly:SetRagdollState(
					player, RAGDOLL_FALLENOVER, 8, nil, cwKernel:ConvertForce(damageInfo:GetDamageForce() * 32)
				);
				damageInfo:ScaleDamage(0.25);
			end;
		end;
	end;
end;

-- Called when an entity takes damage.
function Clockwork:EntityTakeDamage(entity, damageInfo)
	local inflictor = damageInfo:GetInflictor();
	local attacker = damageInfo:GetAttacker();
	local amount = damageInfo:GetDamage();

	if (cwConfig:Get("prop_kill_protection"):Get()) then
		local curTime = CurTime();
		
		if ((IsValid(inflictor) and inflictor.cwDamageImmunity and inflictor.cwDamageImmunity > curTime and !inflictor:IsVehicle())
		or (IsValid(attacker) and attacker.cwDamageImmunity and attacker.cwDamageImmunity > curTime)) then
			entity.cwDamageImmunity = curTime + 1;
			
			damageInfo:SetDamage(0);
			
			return false;
		end;
		
		if (IsValid(attacker) and attacker:GetClass() == "worldspawn"
		and entity.cwDamageImmunity and entity.cwDamageImmunity > curTime) then
			damageInfo:SetDamage(0);
			
			return false;
		end;
		
		if ((IsValid(inflictor) and inflictor:IsBeingHeld())
		or attacker:IsBeingHeld()) then
			damageInfo:SetDamage(0);
			
			return false;
		end;
	end;
	
	if (entity:IsPlayer() and entity:InVehicle() and !IsValid(entity:GetVehicle():GetParent())) then
		entity.cwLastHitGroup = cwKernel:GetRagdollHitBone(entity, damageInfo:GetDamagePosition(), HITGROUP_GEAR);
		
		if (damageInfo:IsBulletDamage()) then
			if ((attacker:IsPlayer() or attacker:IsNPC()) and attacker != player) then
				damageInfo:ScaleDamage(10000);
			end;
		end;
	end;
	
	if (damageInfo:GetDamage() == 0) then
		return;
	end;
	
	local isPlayerRagdoll = cwEntity:IsPlayerRagdoll(entity);
	local player = cwEntity:GetPlayer(entity);
	
	if (player and (entity:IsPlayer() or isPlayerRagdoll)) then
		if (damageInfo:IsFallDamage() or cwConfig:Get("damage_view_punch"):Get()) then
			player:ViewPunch(
				Angle(math.random(amount, amount), math.random(amount, amount), math.random(amount, amount))
			);
		end;
		
		if (!isPlayerRagdoll) then
			if (damageInfo:IsDamageType(DMG_CRUSH) and damageInfo:GetDamage() < 10) then
				damageInfo:SetDamage(0);
			else
				local lastHitGroup = player:LastHitGroup();
				local killed = nil;
				
				if (player:InVehicle() and damageInfo:IsExplosionDamage()) then
					if (!damageInfo:GetDamage() or damageInfo:GetDamage() == 0) then
						damageInfo:SetDamage(player:GetMaxHealth());
					end;
				end;
				
				self:ScaleDamageByHitGroup(player, attacker, lastHitGroup, damageInfo, amount);
				
				if (damageInfo:GetDamage() > 0) then
					cwKernel:CalculatePlayerDamage(player, lastHitGroup, damageInfo);
					
					player:SetVelocity(cwKernel:ConvertForce(damageInfo:GetDamageForce() * 32, 200));
					
					if (player:Alive() and player:Health() == 1) then
						player:SetFakingDeath(true);
						
						hook.Call("DoPlayerDeath", self, player, attacker, damageInfo);
						hook.Call("PlayerDeath", self, player, inflictor, attacker, damageInfo);
						
						cwKernel:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, player, damageInfo:GetDamageForce());
						
						player:SetFakingDeath(false, true);
					else
						local bNoMsg = cwPlugin:Call("PlayerTakeDamage", player, inflictor, attacker, lastHitGroup, damageInfo);
						local sound = cwPlugin:Call("PlayerPlayPainSound", player, player:GetGender(), damageInfo, lastHitGroup);
						
						cwKernel:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, player, damageInfo:GetDamageForce());
						
						if (sound and !bNoMsg) then
							player:EmitHitSound(sound);
						end;

						local armor = "!";

						if (player:Armor() > 0) then
							armor = " and "..player:Armor().." armor!"
						end;
						
						if (attacker:IsPlayer()) then
							cwKernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:Name().." with "..cwPly:GetWeaponClass(attacker, "an unknown weapon")..", leaving them at "..player:Health().." health"..armor);
						else
							cwKernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:GetClass()..", leaving them at "..player:Health().." health"..armor);
						end;
					end;
				end;
				
				damageInfo:SetDamage(0);
				
				player.cwLastHitGroup = nil;
			end;
		else
			local hitGroup = cwKernel:GetRagdollHitGroup(entity, damageInfo:GetDamagePosition());
			local curTime = CurTime();
			local killed = nil;
			
			self:ScaleDamageByHitGroup(player, attacker, hitGroup, damageInfo, amount);
			
			if (cwPlugin:Call("PlayerRagdollCanTakeDamage", player, entity, inflictor, attacker, hitGroup, damageInfo)
			and damageInfo:GetDamage() > 0) then
				if (!attacker:IsPlayer()) then
					if (attacker:GetClass() == "prop_ragdoll" or cwEntity:IsDoor(attacker)
					or damageInfo:GetDamage() < 5) then
						return;
					end;
				end;
				
				if (damageInfo:GetDamage() >= 10 or damageInfo:IsBulletDamage()) then
					cwKernel:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, entity, damageInfo:GetDamageForce());
				end;
				
				cwKernel:CalculatePlayerDamage(player, hitGroup, damageInfo);
				
				if (player:Alive() and player:Health() == 1) then
					player:SetFakingDeath(true);
					
					player:GetRagdollTable().health = 0;
					player:GetRagdollTable().armor = 0;
					
					hook.Call("DoPlayerDeath", self, player, attacker, damageInfo);
					hook.Call("PlayerDeath", self, player, inflictor, attacker, damageInfo);
					
					player:SetFakingDeath(false, true);
				elseif (player:Alive()) then
					local bNoMsg = cwPlugin:Call("PlayerTakeDamage", player, inflictor, attacker, hitGroup, damageInfo);
					local sound = cwPlugin:Call("PlayerPlayPainSound", player, player:GetGender(), damageInfo, hitGroup);
					
					if (sound and !bNoMsg) then
						entity:EmitHitSound(sound);
					end;
					
					local armor = "!";

					if (player:Armor() > 0) then
						armor = " and "..player:Armor().." armor!"
					end;

					if (attacker:IsPlayer()) then
						cwKernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:Name().." with "..cwPly:GetWeaponClass(attacker, "an unknown weapon")..", leaving them at "..player:Health().." health"..armor);
					else
						cwKernel:PrintLog(LOGTYPE_MAJOR, player:Name().." has taken "..tostring(math.ceil(damageInfo:GetDamage())).." damage from "..attacker:GetClass()..", leaving them at "..player:Health().." health"..armor);
					end;
				end;
			end;
			
			damageInfo:SetDamage(0);
		end;
	elseif (entity:GetClass() == "prop_ragdoll") then
		if (damageInfo:GetDamage() >= 20 or damageInfo:IsBulletDamage()) then
			if (!string.find(entity:GetModel(), "matt") and !string.find(entity:GetModel(), "gib")) then
				local matType = util.QuickTrace(entity:GetPos(), entity:GetPos()).MatType;
				
				if (matType == MAT_FLESH or matType == MAT_BLOODYFLESH) then
					cwKernel:CreateBloodEffects(damageInfo:GetDamagePosition(), 1, entity, damageInfo:GetDamageForce());
				end;
			end;
		end;
		
		if (inflictor:GetClass() == "prop_combine_ball") then
			if (!entity.disintegrating) then
				cwEntity:Disintegrate(entity, 3, damageInfo:GetDamageForce());
				
				entity.disintegrating = true;
			end;
		end;
	elseif (entity:IsNPC()) then
		if (attacker:IsPlayer() and IsValid(attacker:GetActiveWeapon())
		and cwPly:GetWeaponClass(attacker) == "weapon_crowbar") then
			damageInfo:ScaleDamage(0.25);
		end;
	end;
end;

-- Called when the death sound for a player should be played.
function Clockwork:PlayerDeathSound(player) return true; end;

-- Called when a player attempts to spawn a SWEP.
function Clockwork:PlayerSpawnSWEP(player, class, weapon)
	if (!player:IsSuperAdmin()) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player is given a SWEP.
function Clockwork:PlayerGiveSWEP(player, class, weapon)
	if (!player:IsSuperAdmin()) then
		return false;
	else
		return true;
	end;
end;

-- Called when attempts to spawn a SENT.
function Clockwork:PlayerSpawnSENT(player, class)
	if (!player:IsSuperAdmin()) then
		return false;
	else
		return true;
	end;
end;

-- Called when a player presses a key.
function Clockwork:KeyPress(player, key)
	if (key == IN_USE) then
		local trace = player:GetEyeTraceNoCursor();
		
		if (IsValid(trace.Entity) and trace.HitPos:Distance(player:GetShootPos()) <= 192) then
			if (cwPlugin:Call("PlayerUse", player, trace.Entity)) then
				if (cwEntity:IsDoor(trace.Entity) and !trace.Entity:HasSpawnFlags(256)
				and !trace.Entity:HasSpawnFlags(8192) and !trace.Entity:HasSpawnFlags(32768)) then
					if (cwPlugin:Call("PlayerCanUseDoor", player, trace.Entity)) then
						cwPlugin:Call("PlayerUseDoor", player, trace.Entity);
						cwEntity:OpenDoor(trace.Entity, 0, nil, nil, player:GetPos());
					end;
				elseif (trace.Entity.UsableInVehicle) then
					if (player:InVehicle()) then
						if (trace.Entity.Use) then
							trace.Entity:Use(player, player);
							
							player.cwNextExitVehicle = CurTime() + 1;
						end;
					end;
				end;
			end;
		end;
	elseif (key == IN_WALK) then
		local velocity = player:GetVelocity():Length();
		
		if (velocity > 0 and !player:KeyDown(IN_SPEED)) then
			if (player:GetSharedVar("IsJogMode") or !cwConfig:Get("enable_jogging"):Get()) then
				player:SetSharedVar("IsJogMode", false);
			else
				player:SetSharedVar("IsJogMode", true);
			end;
		elseif (velocity == 0 and player:KeyDown(IN_SPEED)) then
			if (player:Crouching()) then
				player:RunCommand("-duck");
			else
				player:RunCommand("+duck");
			end;
		end;
	elseif (key == IN_RELOAD) then
		if (cwPly:GetWeaponRaised(player, true)) then
			player.cwReloadHoldTime = CurTime() + 0.75;
		else
			player.cwReloadHoldTime = CurTime() + 0.25;
		end;
	end;
end;

--[[
	@codebase Server
	@details Called when a player presses a button down.
	@param Player The player that is pressing a button.
	@param Enum The button that was pressed.
--]]
function Clockwork:PlayerButtonDown(player, button)
	if (button == KEY_B) then
		local weapon = player:GetActiveWeapon();

		if (cwConfig:Get("quick_raise_enabled"):GetBoolean()) then
			local bQuickRaise = cwPlugin:Call("PlayerCanQuickRaise", player, weapon);

			if (bQuickRaise) then
				cwPly:ToggleWeaponRaised(player);
			end;
		end;
	else
		numpad.Activate(player, button);
	end;
end;

--[[
	@codebase Server
	@details Called to determine whether or not a player can quickly raise their weapon by pressing the x button.
	@param Player The player that is attempting to quickly raise their weapon.
	@param Weapon The player's current active weapon.
--]]
function Clockwork:PlayerCanQuickRaise(player, weapon) return true end;

-- Called when a player releases a key.
function Clockwork:KeyRelease(player, key)
	if (key == IN_RELOAD and player.cwReloadHoldTime) then
		player.cwReloadHoldTime = nil;
	end;
end;

-- A function to setup a player's visibility.
function Clockwork:SetupPlayerVisibility(player)
	local ragdollEntity = player:GetRagdollEntity();
	
	if (ragdollEntity) then
		AddOriginToPVS(ragdollEntity:GetPos());
	end;
end;

-- Called after a player has spawned an NPC.
function Clockwork:PlayerSpawnedNPC(player, npc)
	local faction;
	local relation;
	
	prevRelation = prevRelation or {};
	prevRelation[player:SteamID()] = prevRelation[player:SteamID()] or {};
	
	for k, v in pairs(_player.GetAll()) do
		faction = cwFaction:FindByID(v:GetFaction());
		relation = faction.entRelationship;
		
		if (istable(relation)) then
			for k2, v2 in pairs(relation) do
				if (k2 == npc:GetClass()) then
					if (string.lower(v2) == "like") then
						prevRelation[player:SteamID()][k2] = prevRelation[player:SteamID()][k2] or npc:Disposition(v);
						npc:AddEntityRelationship(v, D_LI, 1);
					elseif (string.lower(v2) == "fear") then
						prevRelation[player:SteamID()][k2] = prevRelation[player:SteamID()][k2] or npc:Disposition(v);
						npc:AddEntityRelationship(v, D_FR, 1);
					elseif (string.lower(v2) == "hate") then
						prevRelation[player:SteamID()][k2] = prevRelation[player:SteamID()][k2] or npc:Disposition(v);
						npc:AddEntityRelationship(v, D_HT, 1);
					else
						ErrorNoHalt("Attempting to add relationship using invalid relation '"..v2.."' towards faction '"..faction.name.."'.\r\n");
					end;
				end;
			end;
		end;
	end;
end;

--[[
	@codebase Server
	@details Called when an attribute is progressed to edit the amount it is progressed by.
	@param Player The player that has progressed the attribute.
	@param Table The attribute table of the attribute being progressed.
	@param Number The amount that is being progressed for editing purposes.
--]]
function Clockwork:OnAttributeProgress(player, attribute, amount)
	amount = amount * cwConfig:Get("scale_attribute_progress"):Get();
end;

--[[
	@codebase Server
	@details Called to add ammo types to be checked for and saved.
	@param Table The table filled with the current ammo types.
--]]
function Clockwork:AdjustAmmoTypes(ammoTable)
	ammoTable["sniperpenetratedround"] = true;
	ammoTable["striderminigun"] = true;
	ammoTable["helicoptergun"] = true;
	ammoTable["combinecannon"] = true;
	ammoTable["smg1_grenade"] = true;
	ammoTable["gaussenergy"] = true;
	ammoTable["sniperround"] = true;
	ammoTable["ar2altfire"] = true;
	ammoTable["rpg_round"] = true;
	ammoTable["xbowbolt"] = true;
	ammoTable["buckshot"] = true;
	ammoTable["alyxgun"] = true;
	ammoTable["grenade"] = true;
	ammoTable["thumper"] = true;
	ammoTable["gravity"] = true;
	ammoTable["battery"] = true;
	ammoTable["pistol"] = true;
	ammoTable["slam"] = true;
	ammoTable["smg1"] = true;
	ammoTable["357"] = true;
	ammoTable["ar2"] = true;
end;

--[[
	@codebase Server
	@details Called after a player uses a command.
	@param Player The player that used the commmand.
	@param Table The table of the command that is being used.
	@param Table The arguments that have been given with the command, if any.
--]]
function Clockwork:PostCommandUsed(player, command, arguments) end;

-- GetTargetRecognises datastream callback.
cwDatastream:Hook("GetTargetRecognises", function(player, data)
	if (IsValid(data) and data:IsPlayer()) then
		player:SetSharedVar("TargetKnows", cwPly:DoesRecognise(data, player));
	end;
end);

-- EntityMenuOption datastream callback.
cwDatastream:Hook("EntityMenuOption", function(player, data)
	local entity = data[1];
	local option = data[2];
	local shootPos = player:GetShootPos();
	local arguments = data[3];
	local curTime = CurTime();
	
	if (IsValid(entity) and type(option) == "string") then
		if (entity:NearestPoint(shootPos):Distance(shootPos) <= 80) then
			if (cwPlugin:Call("PlayerUse", player, entity)) then
				if (!player.nextEntityHandle or player.nextEntityHandle <= curTime) then
					cwPlugin:Call("EntityHandleMenuOption", player, entity, option, arguments);

					player.nextEntityHandle = curTime + cwConfig:Get("entity_handle_time"):Get();
				else
					cwPly:Notify(player, L(player, "EntityOptionWaitTime"));
				end;
			end;
		end;
	end;
end);

-- MenuOption datastream callback.
cwDatastream:Hook("MenuOption", function(player, data)
	local item = data.item;
	local option = data.option;
	local entity = data.entity;
	local data = data.data;
	local shootPos = player:GetShootPos();

	if (type(data) != "table") then
		data = {data};
	end;

	local itemTable = cwItem:FindInstance(item);
	if (itemTable and itemTable:IsInstance() and type(option) == "string") then
		if (itemTable.HandleOptions) then
			if (player:HasItemInstance(itemTable)) then
				itemTable:HandleOptions(option, player, data);
			elseif (IsValid(entity) and entity:GetClass() == "cw_item" and entity:GetItemTable() == itemTable and entity:NearestPoint(shootPos):Distance(shootPos) <= 80) then
				itemTable:HandleOptions(option, player, data, entity);
			end;
		end;
	end;
end);

-- DataStreamInfoSent datastream callback.
cwDatastream:Hook("DataStreamInfoSent", function(player, data)
	if (!player.cwDataStreamInfoSent) then
		cwPlugin:Call("PlayerDataStreamInfoSent", player);
		
		timer.Simple(FrameTime() * 32, function()
			if (IsValid(player)) then
				cwDatastream:Start(player, "DataStreamed", true);
			end;
		end);
		
		player.cwDataStreamInfoSent = true;
	end;
end);

-- LocalPlayerCreated datastream callback.
cwDatastream:Hook("LocalPlayerCreated", function(player, data)
	if (IsValid(player) and !player:HasConfigInitialized()) then
		cwKernel:CreateTimer("SendCfg"..player:UniqueID(), FrameTime(), 1, function()
			if (IsValid(player)) then
				cwConfig:Send(player);
			end;
		end);		
	end;
end);

-- InteractCharacter datastream callback.
cwDatastream:Hook("InteractCharacter", function(player, data)
	local characterID = data.characterID;
	local action = data.action;
	
	if (characterID and action) then
		local character = player:GetCharacters()[characterID];
		
		if (character) then
			local fault = cwPlugin:Call("PlayerCanInteractCharacter", player, action, character);
			
			if (fault == false or type(fault) == "string") then
				return cwPly:SetCreateFault(fault or "You cannot interact with this character!");
			elseif (action == "delete") then
				local bSuccess, fault = cwPly:DeleteCharacter(player, characterID);
				
				if (!bSuccess) then 
					cwPly:SetCreateFault(player, fault);
				end;
			elseif (action == "use") then
				local bSuccess, fault = cwPly:UseCharacter(player, characterID);
				
				if (!bSuccess) then
					cwPly:SetCreateFault(player, fault);
				end;
			else
				cwPlugin:Call("PlayerSelectCustomCharacterOption", player, action, character);
			end;
		end;
	end;
end);

-- GetQuizStatus datastream callback.
cwDatastream:Hook("GetQuizStatus", function(player, data)
	if (!cwQuiz:GetEnabled() or cwQuiz:GetCompleted(player)) then
		cwDatastream:Start(player, "QuizCompleted", true);
	else
		cwDatastream:Start(player, "QuizCompleted", false);
	end; 
end);

-- DoorManagement datastream callback.
cwDatastream:Hook("DoorManagement", function(player, data)
	if (IsValid(data[1]) and player:GetEyeTraceNoCursor().Entity == data[1]) then
		if (data[1]:GetPos():Distance(player:GetPos()) <= 192) then
			if (data[2] == "Purchase") then
				if (!cwEntity:GetOwner(data[1])) then
					if (hook.Call("PlayerCanOwnDoor", Clockwork, player, data[1])) then
						local doors = cwPly:GetDoorCount(player);
						
						if (doors == cwConfig:Get("max_doors"):Get()) then
							cwPly:Notify(player, L(player, "CannotPurchaseAnotherDoor"));
						else
							local doorCost = cwConfig:Get("door_cost"):Get();
							
							if (doorCost == 0 or cwPly:CanAfford(player, doorCost)) then
								local doorName = cwEntity:GetDoorName(data[1]);
								
								if (doorName == "false" or doorName == "hidden" or doorName == "") then
									doorName = "Door"; 
								end; 
								
								if (doorCost > 0) then
									cwPly:GiveCash(player, -doorCost, doorName);
								end;
								
								cwPly:GiveDoor(player, data[1]);
							else
								local amount = doorCost - player:GetCash();
								
								cwPly:Notify(player, L(player, "YouNeedAnother",
									cwKernel:FormatCash(amount, nil, true))
								);
							end;
						end;
					end;
				end;
			elseif (data[2] == "Access") then
				if (cwPly:HasDoorAccess(player, data[1], DOOR_ACCESS_COMPLETE)) then
					if (IsValid(data[3]) and data[3] != player and data[3] != cwEntity:GetOwner(data[1])) then
						if (data[4] == DOOR_ACCESS_COMPLETE) then
							if (cwPly:HasDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE)) then
								cwPly:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC);
							else
								cwPly:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE);
							end;
						elseif (data[4] == DOOR_ACCESS_BASIC) then
							if (cwPly:HasDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC)) then
								cwPly:TakeDoorAccess(data[3], data[1]);
							else 
								cwPly:GiveDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC);
							end;
						end;
						
						if (cwPly:HasDoorAccess(data[3], data[1], DOOR_ACCESS_COMPLETE)) then
							cwDatastream:Start(player, "DoorAccess", {data[3], DOOR_ACCESS_COMPLETE});
						elseif (cwPly:HasDoorAccess(data[3], data[1], DOOR_ACCESS_BASIC)) then 
							cwDatastream:Start(player, "DoorAccess", {data[3], DOOR_ACCESS_BASIC});
						else
							cwDatastream:Start(player, "DoorAccess", {data[3]});
						end;
					end;
				end; 
			elseif (data[2] == "Unshare") then
				if (cwEntity:IsDoorParent(data[1])) then
					if (data[3] == "Text") then
						cwDatastream:Start(player, "SetSharedText", false);
						
						data[1].cwDoorSharedTxt = nil;
					else
						cwDatastream:Start(player, "SetSharedAccess", false);
						
						data[1].cwDoorSharedAxs = nil;
					end;
				end;
			elseif (data[2] == "Share") then
				if (cwEntity:IsDoorParent(data[1])) then
					if (data[3] == "Text") then
						cwDatastream:Start(player, "SetSharedText", true);
						
						data[1].cwDoorSharedTxt = true;
					else
						cwDatastream:Start(player, "SetSharedAccess", true); 
						
						data[1].cwDoorSharedAxs = true;
					end;
				end;
			elseif (data[2] == "Text" and data[3] != "") then
				if (cwPly:HasDoorAccess(player, data[1], DOOR_ACCESS_COMPLETE)) then
					if (!string.find(string.gsub(string.lower(data[3]), "%s", ""), "thisdoorcanbepurchased") and string.find(data[3], "%w")) then
						cwEntity:SetDoorText(data[1], string.utf8sub(data[3], 1, 32));
					end;
				end;
			elseif (data[2] == "Sell") then
				if (cwEntity:GetOwner(data[1]) == player) then
					if (!cwEntity:IsDoorUnsellable(data[1])) then
						cwPly:TakeDoor(player, data[1]);
					end;
				end;
			end;
		end;
	end;
end);

-- CreateCharacter datastream callback.
cwDatastream:Hook("CreateCharacter", function(player, data)
	cwPly:CreateCharacterFromData(player, data);
end);

-- RecogniseOption datastream callback.
cwDatastream:Hook("RecogniseOption", function(player, data)
	local recogniseData = data;

	if (cwConfig:Get("recognise_system"):Get()) then
		if (type(recogniseData) == "string") then	
			local playSound = false;
			
			if (recogniseData == "look") then
				local target = player:GetEyeTraceNoCursor().Entity;

				if (IsValid(target) and target:HasInitialized()
				and !cwPly:IsNoClipping(target) and target != player) then
					cwPly:SetRecognises(target, player, RECOGNISE_SAVE);

					playSound = true;
				end;
			else
				local position = player:GetPos();
				local plyTable = _player.GetAll();
				local talkRadius = cwConfig:Get("talk_radius"):Get();

				for k, v in pairs(plyTable) do
					if (v:HasInitialized() and player != v) then
						if (!cwPly:IsNoClipping(v)) then
							local distance = v:GetPos():Distance(position);
							local recognise = false;
							
							if (recogniseData == "whisper") then
								if (distance <= math.min(talkRadius / 3, 80)) then
									recognise = true;
								end;
							elseif (recogniseData == "yell") then
								if (distance <= talkRadius * 2) then 
									recognise = true; 
								end;
							elseif (recogniseData == "talk") then
								if (distance <= talkRadius) then
									recognise = true;
								end;
							end;
							
							if (recognise) then
								cwPly:SetRecognises(v, player, RECOGNISE_SAVE);
								
								if (!playSound) then
									playSound = true;
								end;
							end;
						end;
					end;
				end;
			end;

			if (playSound) then
				cwPly:PlaySound(player, "buttons/button17.wav");
			end;
		end;
	end;
end);

-- QuizCompleted datastream callback.
cwDatastream:Hook("QuizCompleted", function(player, data)
	if (player.cwQuizAnswers and !cwQuiz:GetCompleted(player)) then
		local questionsAmount = cwQuiz:GetQuestionsAmount();
		local correctAnswers = 0;
		local quizQuestions = cwQuiz:GetQuestions();
		
		for k, v in pairs(quizQuestions) do
			if (player.cwQuizAnswers[k]) then
				if (cwQuiz:IsAnswerCorrect(k, player.cwQuizAnswers[k])) then
					correctAnswers = correctAnswers + 1;
				end;
			end;
		end;
		
		if (correctAnswers < math.Round(questionsAmount * (cwQuiz:GetPercentage() / 100))) then
			cwQuiz:CallKickCallback(player, correctAnswers);
		else
			cwQuiz:SetCompleted(player, true);
		end;
	end;
end); 

-- UnequipItem datastream callback.
cwDatastream:Hook("UnequipItem", function(player, data)
	local arguments = data[3];
	local uniqueID = data[1];
	local itemID = data[2];
	
	if (!player:Alive() or player:IsRagdolled()) then
		return;
	end;
	
	local itemTable = player:FindItemByID(uniqueID, itemID);
	
	if (!itemTable) then
		itemTable = player:FindWeaponItemByID(uniqueID, itemID);
	end;
	
	if (itemTable and itemTable.OnPlayerUnequipped and itemTable.HasPlayerEquipped) then
		if (itemTable:HasPlayerEquipped(player, arguments)) then
			itemTable:OnPlayerUnequipped(player, arguments);
			
			player:RebuildInventory();
		end;
	end;
end);

-- QuizAnswer datastream callback.
cwDatastream:Hook("QuizAnswer", function(player, data)
	if (!player.cwQuizAnswers) then
		player.cwQuizAnswers = {};
	end;
	
	local question = data[1];
	local answer = data[2];
	
	if (cwQuiz:GetQuestion(question)) then
		player.cwQuizAnswers[question] = answer;
	end;
end);

local entityMeta = FindMetaTable("Entity");
local playerMeta = FindMetaTable("Player");

playerMeta.ClockworkSetCrouchedWalkSpeed = playerMeta.ClockworkSetCrouchedWalkSpeed or playerMeta.SetCrouchedWalkSpeed;
playerMeta.ClockworkLastHitGroup = playerMeta.ClockworkLastHitGroup or playerMeta.LastHitGroup;
playerMeta.ClockworkSetJumpPower = playerMeta.ClockworkSetJumpPower or playerMeta.SetJumpPower;
playerMeta.ClockworkSetWalkSpeed = playerMeta.ClockworkSetWalkSpeed or playerMeta.SetWalkSpeed;
playerMeta.ClockworkStripWeapons = playerMeta.ClockworkStripWeapons or playerMeta.StripWeapons;
playerMeta.ClockworkSetRunSpeed = playerMeta.ClockworkSetRunSpeed or playerMeta.SetRunSpeed;
entityMeta.ClockworkSetMaterial = entityMeta.ClockworkSetMaterial or entityMeta.SetMaterial;
playerMeta.ClockworkStripWeapon = playerMeta.ClockworkStripWeapon or playerMeta.StripWeapon;
entityMeta.ClockworkFireBullets = entityMeta.ClockworkFireBullets or entityMeta.FireBullets;
playerMeta.ClockworkGodDisable = playerMeta.ClockworkGodDisable or playerMeta.GodDisable;
entityMeta.ClockworkExtinguish = entityMeta.ClockworkExtinguish or entityMeta.Extinguish;
entityMeta.ClockworkWaterLevel = entityMeta.ClockworkWaterLevel or entityMeta.WaterLevel;
playerMeta.ClockworkGodEnable = playerMeta.ClockworkGodEnable or playerMeta.GodEnable;
entityMeta.ClockworkSetHealth = entityMeta.ClockworkSetHealth or entityMeta.SetHealth;
playerMeta.ClockworkUniqueID = playerMeta.ClockworkUniqueID or playerMeta.UniqueID;
entityMeta.ClockworkSetColor = entityMeta.ClockworkSetColor or entityMeta.SetColor;
entityMeta.ClockworkIsOnFire = entityMeta.ClockworkIsOnFire or entityMeta.IsOnFire;
entityMeta.ClockworkSetModel = entityMeta.ClockworkSetModel or entityMeta.SetModel;
playerMeta.ClockworkSetArmor = playerMeta.ClockworkSetArmor or playerMeta.SetArmor;
entityMeta.ClockworkSetSkin = entityMeta.ClockworkSetSkin or entityMeta.SetSkin;
entityMeta.ClockworkAlive = entityMeta.ClockworkAlive or playerMeta.Alive;
playerMeta.ClockworkGive = playerMeta.ClockworkGive or playerMeta.Give;
playerMeta.ClockworkKick = playerMeta.ClockworkKick or playerMeta.Kick;

playerMeta.SteamName = playerMeta.SteamName or playerMeta.Name;

-- A function to get a player's name.
function playerMeta:Name()
	return self:QueryCharacter("Name", self:SteamName());
end;

-- A function to make a player fire bullets.
function entityMeta:FireBullets(bulletInfo)
	if (self:IsPlayer()) then
		cwPlugin:Call("PlayerAdjustBulletInfo", self, bulletInfo);
	end;
	
	cwPlugin:Call("EntityFireBullets", self, bulletInfo);
	return self:ClockworkFireBullets(bulletInfo);
end;

-- A function to get whether a player is alive.
function playerMeta:Alive()
	if (!self.fakingDeath) then
		return self:ClockworkAlive();
	else
		return false;
	end;
end;

-- A function to set whether a player is faking death.
function playerMeta:SetFakingDeath(fakingDeath, killSilent)
	self.fakingDeath = fakingDeath;
	
	if (!fakingDeath and killSilent) then
		self:KillSilent();
	end;
end;

-- A function to save a player's character.
function playerMeta:SaveCharacter()
	cwPly:SaveCharacter(self);
end;

-- A function to give a player an item weapon.
function playerMeta:GiveItemWeapon(itemTable)
	cwPly:GiveItemWeapon(self, itemTable);
end;

-- A function to give a weapon to a player.
function playerMeta:Give(class, itemTable, bForceReturn)
	local iTeamIndex = self:Team();
	
	if (!cwPlugin:Call("PlayerCanBeGivenWeapon", self, class, itemTable)) then
		return;
	end;
	
	if (self:IsRagdolled() and !bForceReturn) then
		local ragdollWeapons = self:GetRagdollWeapons();
		local spawnWeapon = cwPly:GetSpawnWeapon(self, class);
		local bCanHolster = (itemTable and cwPlugin:Call("PlayerCanHolsterWeapon", self, itemTable, true, true));
		
		if (!spawnWeapon) then iTeamIndex = nil; end;
		
		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == class
			and v.weaponData["itemTable"] == itemTable) then
				v.canHolster = bCanHolster;
				v.teamIndex = iTeamIndex;
				return;
			end;
		end;
		
		ragdollWeapons[#ragdollWeapons + 1] = {
			weaponData = {
				class = class,
				itemTable = itemTable
			},
			canHolster = bCanHolster,
			teamIndex = iTeamIndex,
		};
	elseif (!self:HasWeapon(class)) then
		self.cwForceGive = true;
			self:ClockworkGive(class);
		self.cwForceGive = nil;
		
		local weapon = self:GetWeapon(class);
		
		if (IsValid(weapon) and itemTable) then
			cwDatastream:Start(self, "WeaponItemData", {
				definition = cwItem:GetDefinition(itemTable, true),
				weapon = weapon:EntIndex()
			});
			
			weapon:SetNetworkedString(
				"ItemID", tostring(itemTable("itemID"))
			);
			weapon.cwItemTable = itemTable;
			
			if (itemTable.OnWeaponGiven) then
				itemTable:OnWeaponGiven(self, weapon);
			end;
		end;
	end;
	
	cwPlugin:Call("PlayerGivenWeapon", self, class, itemTable);
end;

-- A function to get a player's data.
function playerMeta:GetData(key, default)
	if (self.cwData and self.cwData[key] != nil) then
		return self.cwData[key];
	else
		return default;
	end;
end;

-- A function to get a player's playback rate.
function playerMeta:GetPlaybackRate()
	return self.cwPlaybackRate or 1;
end;

-- A function to set an entity's skin.
function entityMeta:SetSkin(skin)
	self:ClockworkSetSkin(skin);
	
	if (self:IsPlayer()) then
		cwPlugin:Call("PlayerSkinChanged", self, skin);
		
		if (self:IsRagdolled()) then
			self:GetRagdollTable().skin = skin;
		end;
	end;
end;

-- A function to set an entity's model.
function entityMeta:SetModel(model)
	self:ClockworkSetModel(model);
	
	if (self:IsPlayer()) then
		cwPlugin:Call("PlayerModelChanged", self, model);
		
		if (self:IsRagdolled()) then
			self:GetRagdollTable().model = model;
		end;
	end;
end;

-- A function to get an entity's owner key.
function entityMeta:GetOwnerKey()
	return self.cwOwnerKey;
end;

-- A function to set an entity's owner key.
function entityMeta:SetOwnerKey(key)
	self.cwOwnerKey = key;
end;

-- A function to get whether an entity is a map entity.
function entityMeta:IsMapEntity()
	return cwEntity:IsMapEntity(self);
end;

-- A function to get an entity's start position.
function entityMeta:GetStartPosition()
	return cwEntity:GetStartPosition(self);
end;

-- A function to emit a hit sound for an entity.
function entityMeta:EmitHitSound(sound)
	self:EmitSound("weapons/crossbow/hitbod2.wav",
		math.random(100, 150), math.random(150, 170)
	);
	
	timer.Simple(FrameTime(), function()
		if (IsValid(self)) then
			self:EmitSound(sound);
		end;
	end);
end;

-- A function to set an entity's material.
function entityMeta:SetMaterial(material)
	if (self:IsPlayer() and self:IsRagdolled()) then
		self:GetRagdollEntity():SetMaterial(material);
	end;
	
	self:ClockworkSetMaterial(material);
end;

-- A function to set an entity's color.
function entityMeta:SetColor(color)
	if (self:IsPlayer() and self:IsRagdolled()) then
		self:GetRagdollEntity():SetColor(color);
	end;
	
	self:ClockworkSetColor(color);
end;

-- A function to get a player's information table.
function playerMeta:GetInfoTable()
	return self.cwInfoTable;
end;

-- A function to set a player's armor.
function playerMeta:SetArmor(armor)
	local oldArmor = self:Armor();
		self:ClockworkSetArmor(armor);
	cwPlugin:Call("PlayerArmorSet", self, armor, oldArmor);
end;

-- A function to set a player's health.
function playerMeta:SetHealth(health)
	local oldHealth = self:Health();
		self:ClockworkSetHealth(health);
	cwPlugin:Call("PlayerHealthSet", self, health, oldHealth);
end;

-- A function to get whether a player is noclipping.
function playerMeta:IsNoClipping()
	return cwPly:IsNoClipping(self);
end;

-- A function to get whether a player is running.
function playerMeta:IsRunning()
	if (self:Alive() and !self:IsRagdolled() and !self:InVehicle()
	and !self:Crouching() and self:KeyDown(IN_SPEED)) then
		if (self:GetVelocity():Length() >= self:GetWalkSpeed()
		or bNoWalkSpeed) then
			return true;
		end;
	end;
	
	return false;
end;

-- A function to get whether a player is jogging.
function playerMeta:IsJogging(bTestSpeed)
	if (!self:IsRunning() and (self:GetSharedVar("IsJogMode") or bTestSpeed)) then
		if (self:Alive() and !self:IsRagdolled() and !self:InVehicle() and !self:Crouching()) then
			if (self:GetVelocity():Length() > 0) then
				return true;
			end;
		end;
	end;
	
	return false;
end;

-- A function to strip a weapon from a player.
function playerMeta:StripWeapon(weaponClass)
	if (self:IsRagdolled()) then
		local ragdollWeapons = self:GetRagdollWeapons();
		
		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == weaponClass) then
				weapons[k] = nil;
			end;
		end;
	else
		self:ClockworkStripWeapon(weaponClass);
	end;
end;

-- A function to get the player's target run speed.
function playerMeta:GetTargetRunSpeed()
	return self.cwTargetRunSpeed or self:GetRunSpeed();
end;

-- A function to handle a player's attribute progress.
function playerMeta:HandleAttributeProgress(curTime)
	if (self.cwAttrProgressTime and curTime >= self.cwAttrProgressTime) then
		self.cwAttrProgressTime = curTime + 30;
		
		for k, v in pairs(self.cwAttrProgress) do
			local attributeTable = cwAttribute:FindByID(k);
			
			if (attributeTable) then
				cwDatastream:Start(self, "AttributeProgress", {
					index = attributeTable.index, amount = v
				});
			end;
		end;
		
		if (self.cwAttrProgress) then
			self.cwAttrProgress = {};
		end;
	end;
end;

-- A function to handle a player's attribute boosts.
function playerMeta:HandleAttributeBoosts(curTime)
	for k, v in pairs(self.cwAttrBoosts) do
		for k2, v2 in pairs(v) do
			if (v2.duration and v2.endTime) then
				if (curTime > v2.endTime) then
					self:BoostAttribute(k2, k, false);
				else
					local timeLeft = v2.endTime - curTime;
					
					if (timeLeft >= 0) then
						if (v2.default < 0) then
							v2.amount = math.min((v2.default / v2.duration) * timeLeft, 0);
						else
							v2.amount = math.max((v2.default / v2.duration) * timeLeft, 0);
						end;
					end;
				end;
			end;
		end;
	end;
end;

-- A function to strip a player's weapons.
function playerMeta:StripWeapons(ragdollForce)
	if (self:IsRagdolled() and !ragdollForce) then
		self:GetRagdollTable().weapons = {};
	else
		self:ClockworkStripWeapons();
	end;
end;

-- A function to enable God for a player.
function playerMeta:GodEnable()
	self.godMode = true; self:ClockworkGodEnable();
end;

-- A function to disable God for a player.
function playerMeta:GodDisable()
	self.godMode = nil; self:ClockworkGodDisable();
end;

-- A function to get whether a player has God mode enabled.
function playerMeta:IsInGodMode()
	return self.godMode;
end;

-- A function to update whether a player's weapon is raised.
function playerMeta:UpdateWeaponRaised()
	cwPly:UpdateWeaponRaised(self);
end;

-- A function to update whether a player's weapon has fired.
function playerMeta:UpdateWeaponFired()
	local activeWeapon = self:GetActiveWeapon();
	
	if (IsValid(activeWeapon)) then
		if (self.cwClipOneInfo.weapon == activeWeapon) then
			local clipOne = activeWeapon:Clip1();
			
			if (clipOne < self.cwClipOneInfo.ammo) then
				self.cwClipOneInfo.ammo = clipOne;
				cwPlugin:Call("PlayerFireWeapon", self, activeWeapon, CLIP_ONE, activeWeapon:GetPrimaryAmmoType());
			end;
		else
			self.cwClipOneInfo.weapon = activeWeapon;
			self.cwClipOneInfo.ammo = activeWeapon:Clip1();
		end;
		
		if (self.cwClipTwoInfo.weapon == activeWeapon) then
			local clipTwo = activeWeapon:Clip2();
			
			if (clipTwo < self.cwClipTwoInfo.ammo) then
				self.cwClipTwoInfo.ammo = clipTwo;
				cwPlugin:Call("PlayerFireWeapon", self, activeWeapon, CLIP_TWO, activeWeapon:GetSecondaryAmmoType());
			end;
		else
			self.cwClipTwoInfo.weapon = activeWeapon;
			self.cwClipTwoInfo.ammo = activeWeapon:Clip2();
		end;
	end;
end;

-- A function to get a player's water level.
function playerMeta:WaterLevel()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():WaterLevel();
	else
		return self:ClockworkWaterLevel();
	end;
end;

-- A function to get whether a player is on fire.
function playerMeta:IsOnFire()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():IsOnFire();
	else
		return self:ClockworkIsOnFire();
	end;
end;

-- A function to extinguish a player.
function playerMeta:Extinguish()
	if (self:IsRagdolled()) then
		return self:GetRagdollEntity():Extinguish();
	else
		return self:ClockworkExtinguish();
	end;
end;

-- A function to get whether a player is using their hands.
function playerMeta:IsUsingHands()
	return cwPly:GetWeaponClass(self) == "cw_hands";
end;

-- A function to get whether a player is using their hands.
function playerMeta:IsUsingKeys()
	return cwPly:GetWeaponClass(self) == "cw_keys";
end;

-- A function to get a player's wages.
function playerMeta:GetWages()
	return cwPly:GetWages(self);
end;

-- A function to get a player's community ID.
function playerMeta:CommunityID()
	local x, y, z = string.match(self:SteamID(), "STEAM_(%d+):(%d+):(%d+)");
	
	if (x and y and z) then
		return (z * 2) + STEAM_COMMUNITY_ID + y;
	else
		return self:SteamID();
	end;
end;

-- A function to get whether a player is ragdolled.
function playerMeta:IsRagdolled(exception, entityless)
	return cwPly:IsRagdolled(self, exception, entityless);
end;

-- A function to get whether a player is kicked.
function playerMeta:IsKicked()
	return self.isKicked;
end;

-- A function to get whether a player has spawned.
function playerMeta:HasSpawned()
	return self.cwHasSpawned;
end;

-- A function to kick a player.
function playerMeta:Kick(reason)
	if (!self:IsKicked()) then
		timer.Simple(FrameTime() * 0.5, function()
			local isKicked = self:IsKicked();
			
			if (IsValid(self) and isKicked) then
				if (self:HasSpawned()) then
					game.ConsoleCommand("kickid "..self:UserID().." "..isKicked.."\n");
				else
					self.isKicked = nil;
					self:Kick(isKicked);
				end;
			end;
		end);
	end;
	
	if (!reason) then
		self.isKicked = "Вы были кикнуты.";
	else
		self.isKicked = reason;
	end;
end;

-- A function to ban a player.
function playerMeta:Ban(duration, reason)
	cwBans:Add(self:SteamID(), duration * 60, reason);
end;

-- A function to get a player's cash.
function playerMeta:GetCash()
	if (cwConfig:Get("cash_enabled"):Get()) then
		return self:QueryCharacter("Cash");
	else
		return 0;
	end;
end;

-- A function to get a character's flags.
function playerMeta:GetFlags() return self:QueryCharacter("Flags"); end;

-- A function to get a player's faction.
function playerMeta:GetFaction() return self:QueryCharacter("Faction"); end;

-- A function to get a player's IsCitizen.
function playerMeta:IsCitizen()
	local faction = self:GetFaction()
	
	if (faction == FACTION_CITIZEN or faction == FACTION_GOO or faction == FACTION_CWU or faction == FACTION_CWUMEDIC or faction == FACTION_CWUBOSS) then
		return true
	end
end

-- A function to get a player's gender.
function playerMeta:GetGender() return self:QueryCharacter("Gender"); end;

-- A function to get a player's inventory.
function playerMeta:GetInventory() return self:QueryCharacter("Inventory"); end;

-- A function to get a player's attributes.
function playerMeta:GetAttributes() return self:QueryCharacter("Attributes"); end;

-- A function to get a player's saved ammo.
function playerMeta:GetSavedAmmo() return self:QueryCharacter("Ammo"); end;

-- A function to get a player's default model.
function playerMeta:GetDefaultModel() return self:QueryCharacter("Model"); end;

-- A function to get a player's character ID.
function playerMeta:GetCharacterID() return self:QueryCharacter("CharacterID"); end;

-- A function to get the time when a player's character was created.
function playerMeta:GetTimeCreated() return self:QueryCharacter("TimeCreated"); end;

-- A function to get a player's character key.
function playerMeta:GetCharacterKey() return self:QueryCharacter("Key"); end;

-- A function to get a player's recognised names.
function playerMeta:GetRecognisedNames()
	return self:QueryCharacter("RecognisedNames");
end;

-- A function to get a player's character table.
function playerMeta:GetCharacter() return cwPly:GetCharacter(self); end;

-- A function to get a player's storage table.
function playerMeta:GetStorageTable() return cwStorage:GetTable(self); end;
 
-- A function to get a player's ragdoll table.
function playerMeta:GetRagdollTable() return cwPly:GetRagdollTable(self); end;

-- A function to get a player's ragdoll state.
function playerMeta:GetRagdollState() return cwPly:GetRagdollState(self); end;

-- A function to get a player's storage entity.
function playerMeta:GetStorageEntity() return cwStorage:GetEntity(self); end;

-- A function to get a player's ragdoll entity.
function playerMeta:GetRagdollEntity() return cwPly:GetRagdollEntity(self); end;

-- A function to get a player's ragdoll weapons.
function playerMeta:GetRagdollWeapons()
	return self:GetRagdollTable().weapons or {};
end;

-- A function to get whether a player's ragdoll has a weapon.
function playerMeta:RagdollHasWeapon(weaponClass)
	local ragdollWeapons = self:GetRagdollWeapons();
	
	if (ragdollWeapons) then
		for k, v in pairs(ragdollWeapons) do
			if (v.weaponData["class"] == weaponClass) then
				return true;
			end;
		end;
	end;
end;

-- A function to set a player's maximum armor.
function playerMeta:SetMaxArmor(armor)
	self:SetSharedVar("MaxAP", armor);
end;

-- A function to get a player's maximum armor.
function playerMeta:GetMaxArmor(armor)
	local maxArmor = self:GetSharedVar("MaxAP");
	
	if (maxArmor > 0) then
		return maxArmor;
	else
		return 100;
	end;
end;

-- A function to set a player's maximum health.
function playerMeta:SetMaxHealth(health)
	self:SetSharedVar("MaxHP", health);
end;

-- A function to get a player's maximum health.
function playerMeta:GetMaxHealth(health)
	local maxHealth = self:GetSharedVar("MaxHP");
	
	if (maxHealth > 0) then
		return maxHealth;
	else
		return 100;
	end;
end;

-- A function to get whether a player is viewing the starter hints.
function playerMeta:IsViewingStarterHints()
	return self.cwViewStartHints;
end;

-- A function to get a player's last hit group.
function playerMeta:LastHitGroup()
	return self.cwLastHitGroup or self:ClockworkLastHitGroup();
end;

-- A function to get whether an entity is being held.
function entityMeta:IsBeingHeld()
	if (IsValid(self)) then
		return cwPlugin:Call("GetEntityBeingHeld", self);
	end;
end;

-- A function to run a command on a player.
function playerMeta:RunCommand(...)
	cwDatastream:Start(self, "RunCommand", {...});
end;

-- A function to run a Clockwork command on a player.
function playerMeta:RunClockworkCmd(command, ...)
	cwPly:RunClockworkCommand(self, command, ...)
end;

-- A function to get a player's wages name.
function playerMeta:GetWagesName()
	return cwPly:GetWagesName(self);
end;

-- A function to create a player'a animation stop delay.
function playerMeta:CreateAnimationStopDelay(delay)
	cwKernel:CreateTimer("ForcedAnim"..self:UniqueID(), delay, 1, function()
		if (IsValid(self)) then
			local forcedAnimation = self:GetForcedAnimation();
			
			if (forcedAnimation) then
				self:SetForcedAnimation(false);
			end;
		end;
	end);
end;

-- A function to set a player's forced animation.
function playerMeta:SetForcedAnimation(animation, delay, OnAnimate, OnFinish)
	local forcedAnimation = self:GetForcedAnimation();
	local sequence = nil;
	
	if (!animation) then
		self:SetSharedVar("ForceAnim", 0);
		self.cwForcedAnimation = nil;
		
		if (forcedAnimation and forcedAnimation.OnFinish) then
			forcedAnimation.OnFinish(self);
		end;
		
		return false;
	end;
	
	local bIsPermanent = (!delay or delay == 0);
	local bShouldPlay = (!forcedAnimation or forcedAnimation.delay != 0);
	
	if (bShouldPlay) then
		if (type(animation) == "string") then
			sequence = self:LookupSequence(animation);
		else
			sequence = self:SelectWeightedSequence(animation);
		end;
		
		self.cwForcedAnimation = {
			animation = animation,
			OnAnimate = OnAnimate,
			OnFinish = OnFinish,
			delay = delay
		};
		
		if (bIsPermanent) then
			cwKernel:DestroyTimer(
				"ForcedAnim"..self:UniqueID()
			);
		else
			self:CreateAnimationStopDelay(delay);
		end;
		
		self:SetSharedVar("ForceAnim", sequence);
		
		if (forcedAnimation and forcedAnimation.OnFinish) then
			forcedAnimation.OnFinish(self);
		end;
		
		return true;
	end;
end;

-- A function to set whether a player's config has initialized.
function playerMeta:SetConfigInitialized(initialized)
	self.cwConfigInitialized = initialized;
end;

-- A function to get whether a player's config has initialized.
function playerMeta:HasConfigInitialized()
	return self.cwConfigInitialized;
end;

-- A function to get a player's forced animation.
function playerMeta:GetForcedAnimation()
	return self.cwForcedAnimation;
end;

-- A function to get a player's item entity.
function playerMeta:GetItemEntity()
	if (IsValid(self.itemEntity)) then
		return self.itemEntity;
	end;
end;

-- A function to set a player's item entity.
function playerMeta:SetItemEntity(entity)
	self.itemEntity = entity;
end;

-- A function to create a player's temporary data.
function playerMeta:CreateTempData()
	local uniqueID = self:UniqueID();
	
	if (!Clockwork.TempPlayerData[uniqueID]) then
		Clockwork.TempPlayerData[uniqueID] = {};
	end;
	
	return Clockwork.TempPlayerData[uniqueID];
end;

-- A function to make a player fake pickup an entity.
function playerMeta:FakePickup(entity)
	local entityPosition = entity:GetPos();
	
	if (entity:IsPlayer()) then
		entityPosition = entity:GetShootPos();
	end;
	
	local shootPosition = self:GetShootPos();
	local feetDistance = self:GetPos():Distance(entityPosition);
	local armsDistance = shootPosition:Distance(entityPosition);
	
	if (feetDistance < armsDistance) then
		self:SetForcedAnimation("pickup", 1.2);
	else
		self:SetForcedAnimation("gunrack", 1.2);
	end;
end;

-- A function to set a player's temporary data.
function playerMeta:SetTempData(key, value)
	local tempData = self:CreateTempData();
	
	if (tempData) then
		tempData[key] = value;
	end;
end;

-- A function to set the player's Clockwork user group.
function playerMeta:SetClockworkUserGroup(userGroup)
	if (self:GetClockworkUserGroup() != userGroup) then
		self.cwUserGroup = userGroup;
		self:SetUserGroup(userGroup);
		self:SaveCharacter();

		cwPlugin:Call("OnPlayerUserGroupSet", self, userGroup);
	end;
end;

-- A function to get the player's Clockwork user group.
function playerMeta:GetClockworkUserGroup()
	return self.cwUserGroup;
end;

-- A function to get a player's temporary data.
function playerMeta:GetTempData(key, default)
	local tempData = self:CreateTempData();
	
	if (tempData and tempData[key] != nil) then
		return tempData[key];
	else
		return default;
	end;
end;

-- A function to get a player's items by ID.
function playerMeta:GetItemsByID(uniqueID)
	return cwInventory:GetItemsByID(
		self:GetInventory(), uniqueID
	);
end;

-- A function to find a player's items by name.
function playerMeta:FindItemsByName(uniqueID, name)
	return cwInventory:FindItemsByName(
		self:GetInventory(), uniqueID, name
	);
end;

-- A function to get the maximum weight a player can carry.
function playerMeta:GetMaxWeight()
	local itemsList = cwInventory:GetAsItemsList(self:GetInventory()); 
	local weight = self:GetSharedVar("InvWeight");
	
	for k, v in pairs(itemsList) do
		local addInvWeight = v("addInvSpace");
		if (addInvWeight) then
			weight = weight + addInvWeight;
		end;
	end;
	
	return weight;
end;

-- A function to get the maximum space a player can carry.
function playerMeta:GetMaxSpace()
	local itemsList = cwInventory:GetAsItemsList(self:GetInventory()); 
	local space = self:GetSharedVar("InvSpace");
	
	for k, v in pairs(itemsList) do
		local addInvSpace = v("addInvVolume");
		if (addInvSpace) then
			space = space + addInvSpace;
		end;
	end;
	
	return space;
end;

-- A function to get whether a player can hold a weight.
function playerMeta:CanHoldWeight(weight)
	local inventoryWeight = cwInventory:CalculateWeight(
		self:GetInventory()
	);
	
	if (inventoryWeight + weight > self:GetMaxWeight()) then
		return false;
	else
		return true;
	end;
end;

-- A function to get whether a player can hold a weight.
function playerMeta:CanHoldSpace(space)
	if (!cwInventory:UseSpaceSystem()) then
		return true;
	end;

	local inventorySpace = cwInventory:CalculateSpace(
		self:GetInventory()
	);
	
	if (inventorySpace + space > self:GetMaxSpace()) then
		return false;
	else
		return true;
	end;
end;

-- A function to get a player's inventory weight.
function playerMeta:GetInventoryWeight()
	return cwInventory:CalculateWeight(self:GetInventory());
end;

-- A function to get a player's inventory weight.
function playerMeta:GetInventorySpace()
	return cwInventory:CalculateSpace(self:GetInventory());
end;

-- A function to get whether a player has an item by ID.
function playerMeta:HasItemByID(uniqueID)
	return cwInventory:HasItemByID(
		self:GetInventory(), uniqueID
	);
end;

-- A function to count how many items a player has by ID.
function playerMeta:GetItemCountByID(uniqueID)
	return cwInventory:GetItemCountByID(
		self:GetInventory(), uniqueID
	);
end;

-- A function to get whether a player has a certain amount of items by ID.
function playerMeta:HasItemCountByID(uniqueID, amount)
	return cwInventory:HasItemCountByID(
		self:GetInventory(), uniqueID, amount
	);
end;

-- A function to find a player's item by ID.
function playerMeta:FindItemByID(uniqueID, itemID)
	return cwInventory:FindItemByID(
		self:GetInventory(), uniqueID, itemID
	);
end;

-- A function to get whether a player has an item as a weapon.
function playerMeta:HasItemAsWeapon(itemTable)
	for k, v in pairs(self:GetWeapons()) do
		local weaponItemTable = cwItem:GetByWeapon(v);
		if (itemTable:IsTheSameAs(weaponItemTable)) then
			return true;
		end;
	end;
	
	return false;
end;

-- A function to find a player's weapon item by ID.
function playerMeta:FindWeaponItemByID(uniqueID, itemID)
	for k, v in pairs(self:GetWeapons()) do
		local weaponItemTable = cwItem:GetByWeapon(v);
		if (weaponItemTable and weaponItemTable("uniqueID") == uniqueID
		and weaponItemTable("itemID") == itemID) then
			return weaponItemTable;
		end;
	end;
end;

-- A function to get whether a player has an item instance.
function playerMeta:HasItemInstance(itemTable)
	return cwInventory:HasItemInstance(
		self:GetInventory(), itemTable
	);
end;

-- A function to get a player's item instance.
function playerMeta:GetItemInstance(uniqueID, itemID)
	return cwInventory:FindItemByID(
		self:GetInventory(), uniqueID, itemID
	);
end;

-- A function to take a player's item by ID.
function playerMeta:TakeItemByID(uniqueID, itemID)
	local itemTable = self:GetItemInstance(uniqueID, itemID);
	
	if (itemTable) then
		return self:TakeItem(itemTable);
	else
		return false;
	end;
end;

-- A function to get a player's attribute boosts.
function playerMeta:GetAttributeBoosts()
	return self.cwAttrBoosts;
end;

-- A function to rebuild a player's inventory.
function playerMeta:RebuildInventory()
	cwInventory:Rebuild(self);
end;

-- A function to give an item to a player.
function playerMeta:GiveItem(itemTable, bForce)
	if (type(itemTable) == "string") then
		itemTable = cwItem:CreateInstance(itemTable);
	end;
	
	if (!itemTable or !itemTable:IsInstance()) then
		debug.Trace();
		return false, "ERROR: Trying to give a player a non-instance item!";
	end;
	
	local inventory = self:GetInventory();
	
	if ((self:CanHoldWeight(itemTable("weight"))
	and self:CanHoldSpace(itemTable("space"))) or bForce) then
		if (itemTable.OnGiveToPlayer) then
			itemTable:OnGiveToPlayer(self);
		end;
		
		cwKernel:PrintLog(LOGTYPE_GENERIC, self:Name().." has gained a "..itemTable("name").." "..itemTable("itemID")..".");
		
		cwInventory:AddInstance(inventory, itemTable);
			cwDatastream:Start(self, "InvGive", cwItem:GetDefinition(itemTable, true));
		cwPlugin:Call("PlayerItemGiven", self, itemTable, bForce);
		
		return itemTable;
	else
		return false, "You do not have enough inventory space!";
	end;
end;

-- A function to take an item from a player.
function playerMeta:TakeItem(itemTable)
	if (!itemTable or !itemTable:IsInstance()) then
		debug.Trace();
		return false;
	end;
	
	local inventory = self:GetInventory();
	
	if (itemTable.OnTakeFromPlayer) then
		itemTable:OnTakeFromPlayer(self);
	end;
	
	cwKernel:PrintLog(LOGTYPE_GENERIC, self:Name().." has lost a "..itemTable("name").." "..itemTable("itemID")..".");
	
	cwPlugin:Call("PlayerItemTaken", self, itemTable);
		cwInventory:RemoveInstance(inventory, itemTable);
	cwDatastream:Start(self, "InvTake", {itemTable("index"), itemTable("itemID")});
	return true;
end;

-- An easy function to give a table of items to a player.
function playerMeta:GiveItems(itemTables)
	for _, itemTable in pairs(itemTables) do
		self:GiveItem(itemTables)
	end
end

-- An easy function to take a table of items from a player.
function playerMeta:TakeItems(itemTables)
	for _, itemTable in pairs(itemTables) do
		self:TakeItem(itemTable)
	end
end

-- A function to update a player's attribute.
function playerMeta:UpdateAttribute(attribute, amount)
	return cwAttributes:Update(self, attribute, amount);
end;

-- A function to progress a player's attribute.
function playerMeta:ProgressAttribute(attribute, amount, gradual)
	return cwAttributes:Progress(self, attribute, amount, gradual);
end;

-- A function to boost a player's attribute.
function playerMeta:BoostAttribute(identifier, attribute, amount, duration)
	return cwAttributes:Boost(self, identifier, attribute, amount, duration);
end;

-- A function to get whether a boost is active for a player.
function playerMeta:IsBoostActive(identifier, attribute, amount, duration)
	return cwAttributes:IsBoostActive(self, identifier, attribute, amount, duration);
end;

-- A function to get a player's characters.
function playerMeta:GetCharacters()
	return self.cwCharacterList;
end;

-- A function to set a player's run speed.
function playerMeta:SetRunSpeed(speed, bClockwork)
	if (!bClockwork) then self.cwRunSpeed = speed; end;
	self:ClockworkSetRunSpeed(speed);
end;

-- A function to set a player's walk speed.
function playerMeta:SetWalkSpeed(speed, bClockwork)
	if (!bClockwork) then self.cWalkSpeed = speed; end;
	self:ClockworkSetWalkSpeed(speed);
end;

-- A function to set a player's jump power.
function playerMeta:SetJumpPower(power, bClockwork)
	if (!bClockwork) then self.cwJumpPower = power; end;
	self:ClockworkSetJumpPower(power);
end;

-- A function to set a player's crouched walk speed.
function playerMeta:SetCrouchedWalkSpeed(speed, bClockwork)
	if (!bClockwork) then self.cwCrouchedSpeed = speed; end;
	self:ClockworkSetCrouchedWalkSpeed(speed);
end;

-- A function to get whether a player has initialized.
function playerMeta:HasInitialized()
	return self.cwInitialized;
end;

-- A function to query a player's character table.
function playerMeta:QueryCharacter(key, default)
	if (self:GetCharacter()) then
		return cwPly:Query(self, key, default);
	else
		return default;
	end;
end;

-- A function to get a player's shared variable.
function playerMeta:GetSharedVar(key)
	return cwPly:GetSharedVar(self, key);
end;

-- A function to set a shared variable for a player.
function playerMeta:SetSharedVar(key, value, sharedTable)
	cwPly:SetSharedVar(self, key, value, sharedTable);
end;

-- A function to get a player's character data.
function playerMeta:GetCharacterData(key, default)
	if (self:GetCharacter()) then
		local data = self:QueryCharacter("Data");
		
		if (data[key] != nil) then
			return data[key];
		end;
	end;
	
	return default;
end;

-- A function to get a player's time joined.
function playerMeta:TimeJoined()
	return self.cwTimeJoined or os.time();
end;

-- A function to get when a player last played.
function playerMeta:LastPlayed()
	return self.cwLastPlayed or os.time();
end;

-- A function to get a player's clothes data.
function playerMeta:GetClothesData()
	local clothesData = self:GetCharacterData("Clothes");

	if (type(clothesData) != "table") then
		clothesData = {};
	end;
	
	return clothesData;
end;

-- A function to get a player's accessory data.
function playerMeta:GetAccessoryData()
	local accessoryData = self:GetCharacterData("Accessories");

	if (type(accessoryData) != "table") then
		accessoryData = {};
	end;
	
	return accessoryData;
end;

-- A function to remove a player's clothes.
function playerMeta:RemoveClothes(bRemoveItem)
	self:SetClothesData(nil);
	
	if (bRemoveItem) then
		local clothesItem = self:GetClothesItem();
		
		if (clothesItem) then
			self:TakeItem(clothesItem);
			return clothesItem;
		end;
	end;
end;

-- A function to get the player's clothes item.
function playerMeta:GetClothesItem()
	local clothesData = self:GetClothesData();
	
	if (type(clothesData) == "table") then
		if (clothesData.itemID != nil and clothesData.uniqueID != nil) then
			return self:FindItemByID(
				clothesData.uniqueID, clothesData.itemID
			);
		end;
	end;
end;

-- A function to get whether a player is wearing clothes.
function playerMeta:IsWearingClothes()
	return (self:GetClothesItem() != nil);
end;

-- A function to get whether a player is wearing an item.
function playerMeta:IsWearingItem(itemTable)
	local clothesItem = self:GetClothesItem();
	return (clothesItem and clothesItem:IsTheSameAs(itemTable));
end;

-- A function to network the player's clothes data.
function playerMeta:NetworkClothesData()
	local clothesData = self:GetClothesData();

	if (clothesData.uniqueID and clothesData.itemID) then
		self:SetSharedVar("Clothes", clothesData.uniqueID.." "..clothesData.itemID);
	else
		self:SetSharedVar("Clothes", "");
	end;
end;

-- A function to set a player's clothes data.
function playerMeta:SetClothesData(itemTable)
	local clothesItem = self:GetClothesItem();
	
	if (itemTable) then
		local model = cwClass:GetAppropriateModel(self:Team(), self, true);
		
		if (!model) then
			if (clothesItem and itemTable != clothesItem) then
				clothesItem:OnChangeClothes(self, false);
			end;
			
			itemTable:OnChangeClothes(self, true);
			
			local clothesData = self:GetClothesData();
				clothesData.itemID = itemTable("itemID");
				clothesData.uniqueID = itemTable("uniqueID");
			self:NetworkClothesData();
		end;
	else
		local clothesData = self:GetClothesData();
			clothesData.itemID = nil;
			clothesData.uniqueID = nil;
		self:NetworkClothesData();
		
		if (clothesItem) then
			clothesItem:OnChangeClothes(self, false);
		end;
	end;
end;

-- A function to get the entity a player is holding.
function playerMeta:GetHoldingEntity()
	return cwPlugin:Call("PlayerGetHoldingEntity", self) or self.cwIsHoldingEnt;
end;

-- A function to get whether a player's character menu is reset.
function playerMeta:IsCharacterMenuReset()
	return self.cwCharMenuReset;
end;

-- A function to get the player's active voice channel.
function playerMeta:GetActiveChannel()
	return cwVoice:GetActiveChannel(self);
end;

-- A function to check if a player can afford an amount.
function playerMeta:CanAfford(amount)
	return cwPly:CanAfford(self, amount);
end;

-- A function to get a player's rank within their faction.
function playerMeta:GetFactionRank(character)
	return cwPly:GetFactionRank(self, character);
end;

-- A function to set a player's rank within their faction.
function playerMeta:SetFactionRank(rank)
	return cwPly:SetFactionRank(self, rank);
end;

-- A function to get a player's global flags.
function playerMeta:GetPlayerFlags()
	return cwPly:GetPlayerFlags(self);
end;

playerMeta.GetName = playerMeta.Name;
playerMeta.Nick = playerMeta.Name;

concommand.Add("cwStatus", function(player, command, arguments)
	local plyTable = player.GetAll();

	if (IsValid(player)) then
		if (cwPly:IsAdmin(player)) then
			player:PrintMessage(2, "# User ID | Name | Steam Name | Steam ID | IP Address");

			for k, v in pairs(plyTable) do
				if (v:HasInitialized()) then
					local status = cwPlugin:Call("PlayerCanSeeStatus", player, v);
					
					if (status) then
						player:PrintMessage(2, status);
					end;
				end;
			end;
		else
			player:PrintMessage(2, "You do not have access to this command, "..player:Name()..".");
		end;
	else
		print("# User ID | Name | Steam Name | Steam ID | IP Address");
		
		for k, v in pairs(plyTable) do
			if (v:HasInitialized()) then
				print("# "..v:UserID().." | "..v:Name().." | "..v:SteamName().." | "..v:SteamID());
			end;
		end;
	end;
end);

-- The most awfully written function in Clockwork.
-- Allows you to call certain commands from server console.
-- ToDo: Rewrite everything to be shorter;
concommand.Add("cwc", function(player, command, arguments)
	-- Yep, it's awfully written, but it's not meant to be edited, so...
	local cmdTable = {
		sg  = "setgroup",
		d   = "demote",
		sc  = "setcash",
		w   = "whitelist",
		uw  = "unwhitelist",
		b   = "ban",
		k   = "kick",
		sn  = "setname",
		sm  = "setmodel",
		r   = "restart",
		gf  = "giveflags",
		tf  = "takeflags"
	};
	
	--  if called from console
	if (!IsValid(player)) then
		-- PlySetGroup
		if (arguments[1] == cmdTable.sg) then
			local target = cwPly:FindByID(arguments[2]);
			local userGroup = arguments[3];
			
			if (userGroup != "superadmin" and userGroup != "admin" and userGroup != "operator") then
				MsgC(Color(255, 100, 0, 255), "The user group must be superadmin, admin or operator!\n");
				
				return;
			end;
			
			if (target) then
				if (!cwPly:IsProtected(target)) then
					print("Console has set "..target:Name().."'s user group to "..userGroup..".");
					cwPly:NotifyAll("Console has set "..target:Name().."'s user group to "..userGroup..".");
						target:SetClockworkUserGroup(userGroup);
					cwPly:LightSpawn(target, true, true);
				else
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n");
				end;
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n");
			end;
			
			return;
		-- PlyDemote
		elseif (arguments[1] == cmdTable.d) then
			local target = cwPly:FindByID(arguments[2]);
			
			if (target) then
				if (!cwPly:IsProtected(target)) then
					local userGroup = target:GetClockworkUserGroup();
					
					if (userGroup != "user") then
						print("Console has demoted "..target:Name().." from "..userGroup.." to user.");
						cwPly:NotifyAll("Console has demoted "..target:Name().." from "..userGroup.." to user.");
							target:SetClockworkUserGroup("user");
						cwPly:LightSpawn(target, true, true);
					else
						MsgC(Color(255, 100, 0, 255), "This player is only a user and cannot be demoted!\n");
					end;
				else
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n");
				end;
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n");
			end;
			
			return;
		-- SetCash
		elseif (arguments[1] == cmdTable.sc) then
			local target = cwPly:FindByID(arguments[2])
			local cash = math.floor(tonumber((arguments[3] or 0)));
			
			if (target) then
				if (cash and cash >= 1) then
					local playerName = "Console";
					local targetName = target:Name();
					local giveCash = cash - target:GetCash();
					
					cwPly:GiveCash(target, giveCash);
					
					print("Console has set "..targetName.."'s cash to "..cwKernel:FormatCash(cash, nil, true)..".");
					cwPly:Notify(target, "Your cash was set to "..cwKernel:FormatCash(cash, nil, true).." by "..playerName..".");
				else
					MsgC(Color(255, 100, 0, 255), "This is not a valid amount!\n");
				end;
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n");
			end;
			
			return;
		-- PlyWhitelist
		elseif (arguments[1] == cmdTable.w) then
			local target = cwPly:FindByID(arguments[2])
			
			if (target) then
				local factionTable = cwFaction:FindByID(table.concat(arguments, " ", 3));
				
				if (factionTable) then
					if (factionTable.whitelist) then
						if (!cwPly:IsWhitelisted(target, factionTable.name)) then
							cwPly:SetWhitelisted(target, factionTable.name, true);
							cwPly:SaveCharacter(target);
							
							print("Console has added "..target:Name().." to the "..factionTable.name.." whitelist.");
							cwPly:NotifyAll("Console has added "..target:Name().." to the "..factionTable.name.." whitelist.");
						else
							MsgC(Color(255, 100, 0, 255), target:Name().." is already on the "..factionTable.name.." whitelist!\n");
						end;
					else
						MsgC(Color(255, 100, 0, 255), factionTable.name.." does not have a whitelist!\n");
					end;
				else
					MsgC(Color(255, 100, 0, 255), table.concat(arguments, " ", 3).." is not a valid faction!\n");
				end;
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n");
			end;
			
			return;
		-- PlyUnWhitelist
		elseif (arguments[1] == cmdTable.uw) then
			local target = cwPly:FindByID(arguments[2])
			
			if (target) then
				local factionTable = cwFaction:FindByID(table.concat(arguments, " ", 3));
				
				if (factionTable) then
					if (factionTable.whitelist) then
						if (cwPly:IsWhitelisted(target, factionTable.name)) then
							cwPly:SetWhitelisted(target, factionTable.name, false);
							cwPly:SaveCharacter(target);
							
							print("Console has removed "..target:Name().." from the "..factionTable.name.." whitelist.");
							cwPly:NotifyAll("Console has removed "..target:Name().." from the "..factionTable.name.." whitelist.");
						else
							MsgC(Color(255, 100, 0, 255), target:Name().." is not on the "..factionTable.name.." whitelist!\n");
						end;
					else
						MsgC(Color(255, 100, 0, 255), factionTable.name.." does not have a whitelist!\n");
					end;
				else
					MsgC(Color(255, 100, 0, 255), factionTable.name.." is not a valid faction!\n");
				end;
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid player!\n");
			end;
			
			return;
		-- PlyBan
		elseif (arguments[1] == cmdTable.b) then
			local schemaFolder = cwKernel:GetSchemaFolder();
			local duration = tonumber(arguments[3]);
			local reason = table.concat(arguments, " ", 4);
			
			if (!reason or reason == "") then
				reason = nil;
			end;
			
			if (!cwPly:IsProtected(arguments[2])) then
				if (duration) then
					cwBans:Add(arguments[2], duration * 60, reason, function(steamName, duration, reason)
						if (IsValid(player)) then
							if (steamName) then
								if (duration > 0) then
									local hours = math.Round(duration / 3600);
									
									if (hours >= 1) then
										print("Console has banned '"..steamName.."' for "..hours.." hour(s) ("..reason..").");
										cwPly:NotifyAll("Console has banned '"..steamName.."' for "..hours.." hour(s) ("..reason..").");
									else
										print("Console has banned '"..steamName.."' for "..math.Round(duration / 60).." minute(s) ("..reason..").");
										cwPly:NotifyAll("Console has banned '"..steamName.."' for "..math.Round(duration / 60).." minute(s) ("..reason..").");
									end;
								else
									print("Console has banned '"..steamName.."' permanently ("..reason..").");
									cwPly:NotifyAll("Console has banned '"..steamName.."' permanently ("..reason..").");
								end;
							else
								MsgC(Color(255, 100, 0, 255), "This is not a valid identifier!\n");
							end;
						end;
					end);
				else
					MsgC(Color(255, 100, 0, 255), "This is not a valid duration!\n");
				end;
			else
				local target = cwPly:FindByID(arguments[2]);
				
				if (target) then
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n");
				else
					MsgC(Color(255, 100, 0, 255), "This player is protected!\n");
				end;
			end;
			
			return;
		-- PlyKick
		elseif (arguments[1] == cmdTable.k) then
			local target = cwPly:FindByID(arguments[2]);
			local reason = table.concat(arguments, " ", 3);
			
			if (!reason or reason == "") then
				reason = "N/A";
			end;
			
			if (target) then
				if (!cwPly:IsProtected(arguments[2])) then
					print("Console has kicked '"..target:Name().."' ("..reason..").");
					cwPly:NotifyAll("Console has kicked '"..target:Name().."' ("..reason..").");
						target:Kick(reason);
					target.kicked = true;
				else
					MsgC(Color(255, 100, 0, 255), target:Name().." is protected!\n");
				end;
			else
				MsgC(Color(255, 100, 0, 255), arguments[1].." is not a valid player!\n");
			end;
			
			return;
		-- CharSetName
		elseif (arguments[1] == cmdTable.sn) then
			local target = cwPly:FindByID(arguments[2])
			
			if (target) then
				if (arguments[3] == "nil") then
					MsgC(Color(255, 100, 0, 255), "You have to specify the name as the last argument, it also has to be 'quoted'.\n");
					
					return;
				else
					local name = table.concat(arguments, " ", 3);
					
					print("Console has set "..target:Name().."'s name to "..name..".");
					cwPly:NotifyAll("Console has set "..target:Name().."'s name to "..name..".");
					
					cwPly:SetName(target, name);
				end;
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n");
			end;
			
			return;
		-- CharSetModel
		elseif (arguments[1] == cmdTable.sm) then
			local target = cwPly:FindByID(arguments[2])
			
			if (target) then
				local model = table.concat(arguments, " ", 3);
				
				target:SetCharacterData("Model", model, true);
				target:SetModel(model);
				
				print("Console has set "..target:Name().."'s model to "..model..".");
				cwPly:NotifyAll("Console has set "..target:Name().."'s model to "..model..".");
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n");
			end;
			
			return;
		-- MapRestart
		elseif (arguments[1] == cmdTable.r) then
			local delay = tonumber(arguments[2]) or 10;
			
			if (type(arguments[2]) == "number") then
				delay = arguments[2];
			end;

			print("Console is restarting the map in "..delay.." seconds!");
			cwPly:NotifyAll("Console is restarting the map in "..delay.." seconds!");
			
			timer.Simple(delay, function()
				RunConsoleCommand("changelevel", game.GetMap());
			end);
			
			return;
		-- GiveFlags
		elseif (arguments[1] == cmdTable.gf) then
			local target = cwPly:FindByID(arguments[2])
			
			if (target) then
				if (string.find(arguments[3], "a") or string.find(arguments[3], "s") or string.find(arguments[3], "o")) then
					MsgC(Color(255, 100, 0, 255), "You cannot give 'o', 'a' or 's' flags!\n");
					
					return;
				end;
				
				if (!arguments[3]) then print("You haven't entered any flags!"); return; end;
				
				cwPly:GiveFlags(target, arguments[3]);
				
				print("Console gave "..target:Name().." '"..arguments[3].."' flags.");
				cwPly:NotifyAll("Console gave "..target:Name().." '"..arguments[3].."' flags.");
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n");
			end;
	
			return;
		-- TakeFlags
		elseif (arguments[1] == cmdTable.tf) then
			local target = cwPly:FindByID(arguments[2])
			
			if (target) then
				if (string.find(arguments[3], "a") or string.find(arguments[3], "s") or string.find(arguments[3], "o")) then
					cwPly:Notify(player, "You cannot take 'o', 'a' or 's' flags!");
					
					return;
				end;
				
				if (!arguments[3]) then print("You haven't entered any flags!"); return; end;
				
				cwPly:TakeFlags(target, arguments[3]);
				
				print("Console took '"..arguments[3].."' flags from "..target:Name()..".");
				cwPly:NotifyAll("Console took '"..arguments[3].."' flags from "..target:Name()..".");
			else
				MsgC(Color(255, 100, 0, 255), arguments[2].." is not a valid character!\n");
			end;
	
			return;
		-- Everything else
		else
			MsgC(Color(255, 100, 0, 255), "'"..arguments[1].. "' command not found!\n");
		end;
	-- if not too bad, players are not allowed to use this swag
	else
		cwPly.Notify(player, "You are not allowed to use server-side commands!");
	end;
end);

concommand.Add("cwDeathCode", function(player, command, arguments)
	if (player.cwDeathCodeIdx) then
		if (arguments and tonumber(arguments[1]) == player.cwDeathCodeIdx) then
			player.cwDeathCodeAuth = true;
		end;
	end;
end);

function Clockwork:PlayerSay(player, text, bPublic)
	if (CLOCKWORK_PLAYERSAY_OVERRIDE) then
		return text;
	else
		return "";
	end;
end;
function ClockworkPlayerSay(player, text)
	CLOCKWORK_PLAYERSAY_OVERRIDE = true;
	text = hook.Call("PlayerSay", Clockwork, player, text, true);
	CLOCKWORK_PLAYERSAY_OVERRIDE = nil;

	if (text == "") then return; end;

	local maxChatLength = Clockwork.config:Get("max_chat_length"):Get();
	local prefix = Clockwork.config:Get("command_prefix"):Get();
	local curTime = CurTime();

	if (string.len(text) >= maxChatLength) then
		text = string.sub(text, 0, maxChatLength);
	end;

	if (string.sub(text, 1, 2) == "//") then
		text = string.Trim(string.sub(text, 3));

		if (text != "") then
			if (Clockwork.plugin:Call("PlayerCanSayOOC", player, text)) then
				if (!player.cwNextTalkOOC or curTime > player.cwNextTalkOOC or player:IsAdmin()) then
					Clockwork.kernel:ServerLog("[OOC] "..player:Name()..": "..text);
					Clockwork.chatBox:Add(nil, player, "ooc", text);
					player.cwNextTalkOOC = curTime + Clockwork.config:Get("ooc_interval"):Get();
				else
					Clockwork.player:Notify(player, "You cannot cannot talk out-of-character for another "..math.ceil(player.cwNextTalkOOC - CurTime()).." second(s)!");
					return;
				end;
			end;
		end;
	elseif (string.sub(text, 1, 3) == ".//" or string.sub(text, 1, 2) == "[[") then
		if (string.sub(text, 1, 3) == ".//") then
			text = string.Trim(string.sub(text, 4));
		else
			text = string.Trim(string.sub(text, 3));
		end;

		if (text != "") then
			if (Clockwork.plugin:Call("PlayerCanSayLOOC", player, text)) then
				Clockwork.kernel:ServerLog("[LOOC] "..player:Name()..": "..text);
				Clockwork.chatBox:AddInRadius(player, "looc", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get());
			end;
		end;
	elseif (string.sub(text, 1, 1) == prefix) then
		local prefixLength = string.len(prefix);
		local arguments = Clockwork.kernel:ExplodeByTags(text, " ", "\"", "\"", true);
		local command = string.sub(arguments[1], prefixLength + 1);

		if (Clockwork.command.stored[command] and Clockwork.command.stored[command].arguments < 2
		and !Clockwork.command.stored[command].optionalArguments) then
			text = string.sub(text, string.len(command) + prefixLength + 2);

			if (text != "") then
				arguments = {command, text};
			else
				arguments = {command};
			end;
		else
			arguments[1] = command;
		end;

		Clockwork.command:ConsoleCommand(player, "cwCmd", arguments);
	elseif (Clockwork.plugin:Call("PlayerCanSayIC", player, text)) then
		Clockwork.chatBox:AddInRadius(player, "ic", text, player:GetPos(), Clockwork.config:Get("talk_radius"):Get());

		if (Clockwork.player:GetDeathCode(player, true)) then
			Clockwork.player:UseDeathCode(player, nil, {text});
		end;
	end;

	if (Clockwork.player:GetDeathCode(player)) then
		Clockwork.player:TakeDeathCode(player);
	end;
end;
Clockwork.datastream:Hook("PlayerSay", function(player, data)
	if (type(data) == "string") then
		ClockworkPlayerSay(player, data);
	end;
end);

local playerMeta = FindMetaTable("Player");
function playerMeta:NetworkAccessories()
	local accessoryData = self:GetAccessoryData();
	Clockwork.datastream:Start(self, "AllAccessories", accessoryData);
end;
function playerMeta:RemoveAccessory(itemTable)
	if (not self:IsWearingAccessory(itemTable)) then return; end;

	local accessoryData = self:GetAccessoryData();
	local uniqueID = itemTable("uniqueID");
	local itemID = itemTable("itemID");

	accessoryData[itemID] = nil;
	Clockwork.datastream:Start(self, "RemoveAccessory", {itemID = itemID});

	if (itemTable.OnWearAccessory) then
		itemTable:OnWearAccessory(self, false);
	end;
end;
function playerMeta:HasAccessory(uniqueID)
	local accessoryData = self:GetAccessoryData();

	for k, v in pairs(accessoryData) do
		if (string.lower(v) == string.lower(uniqueID)) then
			return true;
		end;
	end;

	return false;
end;
function playerMeta:IsWearingAccessory(itemTable)
	local accessoryData = self:GetAccessoryData();
	local itemID = itemTable("itemID");

	if (accessoryData[itemID]) then
		return true;
	else
		return false;
	end;
end;
function playerMeta:WearAccessory(itemTable)
	if (self:IsWearingAccessory(itemTable)) then return; end;

	local accessoryData = self:GetAccessoryData();
	local uniqueID = itemTable("uniqueID");
	local itemID = itemTable("itemID");

	accessoryData[itemID] = itemTable("uniqueID");
	Clockwork.datastream:Start(self, "AddAccessory", {itemID = itemID, uniqueID = uniqueID});

	if (itemTable.OnWearAccessory) then
		itemTable:OnWearAccessory(self, true);
	end;
end;
--[[ Character Data and Player Data --]]
-- Called when a player's character data has changed.
function Clockwork:PlayerCharacterDataChanged(player, key, oldValue, newValue)
	self.player:UpdateCharacterData(player, key, newValue);
end;
-- Called when a player's data has changed.
function Clockwork:PlayerDataChanged(player, key, oldValue, newValue)
	self.player:UpdatePlayerData(player, key, newValue);
end;
-- A function to set a player's character data.
function playerMeta:SetCharacterData(key, value, bFromBase)
	local character = self:GetCharacter();

	if (!character) then return; end;

	if (bFromBase) then
		key = Clockwork.kernel:SetCamelCase(key, true);

		if (character[key] != nil) then
		character[key] = value;
		end;
	else
		local oldValue = character.data[key];
		character.data[key] = value;

		if (value ~= oldValue) then
			Clockwork.plugin:Call("PlayerCharacterDataChanged", self, key, oldValue, value);
		end;
	end;
end;
-- A function to set a player's data.
function playerMeta:SetData(key, value)
	if (self.cwData) then
		local oldValue = self.cwData[key];
		self.cwData[key] = value;

		if (value ~= oldValue) then
			Clockwork.plugin:Call("PlayerDataChanged", self, key, oldValue, value);
		end;
	end;
end;
MsgN("[CloudAuthX] The sv_kernel.lua externals have been loaded successfully.");