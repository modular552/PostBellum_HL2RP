--[[
Server Name: PostBellum HL2 RP | Русский Half-Life 2 Roleplay
Server IP:   212.22.85.2:27015
File Path:   addons/common_weapons/lua/weapons/grub_combine_sniper_base/ai_translations.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


--[[---------------------------------------------------------
   Name: SetupWeaponHoldTypeForAI
   Desc: Mainly a Todo.. In a seperate file to clean up the init.lua
-----------------------------------------------------------]]
function SWEP:SetupWeaponHoldTypeForAI( t )

	self.ActivityTranslateAI = {}
	self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_PISTOL
	self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_PISTOL
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_PISTOL
	self.ActivityTranslateAI [ ACT_WALK_AIM ] 					= ACT_WALK_AIM_PISTOL
	self.ActivityTranslateAI [ ACT_RUN_AIM ] 					= ACT_RUN_AIM_PISTOL
	self.ActivityTranslateAI [ ACT_GESTURE_RANGE_ATTACK1 ] 		= ACT_GESTURE_RANGE_ATTACK_PISTOL
	self.ActivityTranslateAI [ ACT_RELOAD_LOW ] 				= ACT_RELOAD_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_COVER_LOW ] 					= ACT_COVER_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_RANGE_AIM_LOW ] 				= ACT_RANGE_AIM_PISTOL_LOW
	self.ActivityTranslateAI [ ACT_GESTURE_RELOAD ] 			= ACT_GESTURE_RELOAD_PISTOL
	
	if ( t == "ar2" ) then
	
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1 ] 				= ACT_RANGE_ATTACK_AR2
		self.ActivityTranslateAI [ ACT_RELOAD ] 					= ACT_RELOAD_SMG1
		self.ActivityTranslateAI [ ACT_IDLE ] 						= ACT_IDLE_SMG1
		self.ActivityTranslateAI [ ACT_IDLE_ANGRY ] 				= ACT_IDLE_ANGRY_SMG1
		self.ActivityTranslateAI [ ACT_WALK ] 						= ACT_WALK_RIFLE

		self.ActivityTranslateAI [ ACT_IDLE_RELAXED ] 				= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ ACT_IDLE_STIMULATED ] 			= ACT_IDLE_SMG1_STIMULATED
		self.ActivityTranslateAI [ ACT_IDLE_AGITATED ] 				= ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI [ ACT_WALK_RELAXED ] 				= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ ACT_WALK_STIMULATED ] 			= ACT_WALK_RIFLE_STIMULATED
		self.ActivityTranslateAI [ ACT_WALK_AGITATED ] 				= ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ ACT_RUN_RELAXED ] 				= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ ACT_RUN_STIMULATED ] 			= ACT_RUN_RIFLE_STIMULATED
		self.ActivityTranslateAI [ ACT_RUN_AGITATED ] 				= ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ ACT_IDLE_AIM_RELAXED ] 			= ACT_IDLE_SMG1_RELAXED
		self.ActivityTranslateAI [ ACT_IDLE_AIM_STIMULATED ] 		= ACT_IDLE_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ ACT_IDLE_AIM_AGITATED ] 			= ACT_IDLE_ANGRY_SMG1

		self.ActivityTranslateAI [ ACT_WALK_AIM_RELAXED ] 			= ACT_WALK_RIFLE_RELAXED
		self.ActivityTranslateAI [ ACT_WALK_AIM_STIMULATED ] 		= ACT_WALK_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ ACT_WALK_AIM_AGITATED ] 			= ACT_WALK_AIM_RIFLE

		self.ActivityTranslateAI [ ACT_RUN_AIM_RELAXED ] 			= ACT_RUN_RIFLE_RELAXED
		self.ActivityTranslateAI [ ACT_RUN_AIM_STIMULATED ] 		= ACT_RUN_AIM_RIFLE_STIMULATED
		self.ActivityTranslateAI [ ACT_RUN_AIM_AGITATED ] 			= ACT_RUN_AIM_RIFLE

		self.ActivityTranslateAI [ ACT_WALK_AIM ] 					= ACT_WALK_AIM_RIFLE
		self.ActivityTranslateAI [ ACT_WALK_CROUCH ] 				= ACT_WALK_CROUCH_RIFLE
		self.ActivityTranslateAI [ ACT_WALK_CROUCH_AIM ] 			= ACT_WALK_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ ACT_RUN ] 						= ACT_RUN_RIFLE
		self.ActivityTranslateAI [ ACT_RUN_AIM ] 					= ACT_RUN_AIM_RIFLE
		self.ActivityTranslateAI [ ACT_RUN_CROUCH ] 				= ACT_RUN_CROUCH_RIFLE
		self.ActivityTranslateAI [ ACT_RUN_CROUCH_AIM ] 			= ACT_RUN_CROUCH_AIM_RIFLE
		self.ActivityTranslateAI [ ACT_GESTURE_RANGE_ATTACK1 ] 		= ACT_GESTURE_RANGE_ATTACK_AR2
		self.ActivityTranslateAI [ ACT_COVER_LOW ] 					= ACT_COVER_SMG1_LOW
		self.ActivityTranslateAI [ ACT_RANGE_AIM_LOW ] 				= ACT_RANGE_AIM_AR2_LOW
		self.ActivityTranslateAI [ ACT_RANGE_ATTACK1_LOW ] 			= ACT_RANGE_ATTACK_SMG1_LOW
		self.ActivityTranslateAI [ ACT_RELOAD_LOW ] 				= ACT_RELOAD_SMG1_LOW
		self.ActivityTranslateAI [ ACT_GESTURE_RELOAD ] 			= ACT_GESTURE_RELOAD_SMG1
	
	return end
	
end

