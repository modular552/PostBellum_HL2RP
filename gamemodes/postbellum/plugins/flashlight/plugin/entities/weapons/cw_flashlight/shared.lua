
-----------------------------------------------------
--[[
	© 2013 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

if (SERVER) then
	AddCSLuaFile("shared.lua");
	
	SWEP.ActivityTranslate = {
		[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
		[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_FIST,
		[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_FIST,
		[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_CROUCH_FIST,
		[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK1,
		[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_FIST,
		[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_FIST,
		[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_FIST,
		[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_FIST
	};
end;

if (CLIENT) then
	SWEP.Slot = 0;
	SWEP.SlotPos = 6;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Фонарик";
	SWEP.DrawCrosshair = true;
end

SWEP.Instructions = "Первичный огонь: Включить/Выключить.";
--SWEP.Contact = "";
SWEP.Purpose = "Освещает темные места.";
--SWEP.Author	= "kurozael";

SWEP.ViewModel = "models/weapons/c_arms_animations.mdl";
SWEP.WorldModel = "";
SWEP.HoldType = "fist";

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Ammo = "";

SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Ammo	= "";

SWEP.NoIronSightFovChange = true;
SWEP.NoIronSightAttack = true;
--SWEP.LoweredAngles = Angle(0, 45, 0);
SWEP.IronSightPos = Vector(0, 0, 0);
SWEP.IronSightAng = Vector(0, 0, 0);
SWEP.NeverRaised = true;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	if (SERVER) then
		if (self.Owner:FlashlightIsOn()) then
			self.Owner:Flashlight(false);
		else
			self.Owner:Flashlight(true);
		end;
	end;
end;

-- Called when the player attempts to secondary fire.
function SWEP:SecondaryAttack() end;