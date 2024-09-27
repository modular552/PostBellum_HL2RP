--[[
Server Name: PostBellum HL2 RP | Русский Half-Life 2 Roleplay
Server IP:   212.22.85.2:27015
File Path:   addons/common_weapons/lua/weapons/weapon_hl2bottle.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


AddCSLuaFile()

SWEP.PrintName				= "Стеклянная бутылка"
-- SWEP.Author				= "Dr. Towers"
SWEP.Instructions			= "Первичный огонь: Ударить.\nВторичный огонь: Бросить."
SWEP.Category				= "HL2 Melee Pack"

SWEP.Slot				= 1
SWEP.SlotPos				= 0

SWEP.Spawnable				= true

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_bottle.mdl" )
SWEP.WorldModel				= Model( "models/weapons/HL2meleepack/w_bottle.mdl" )
SWEP.ViewModelFOV			= 62
SWEP.UseHands				= true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo		= "none"

SWEP.DrawAmmo			= false
SWEP.HoldType = "melee"

SWEP.HitDistance		= 30
SWEP.HitInclination		= 0.2
-- SWEP.HitPushback		= 100
SWEP.HitRate			= 1
SWEP.MinDamage			= 5
SWEP.MaxDamage			= 10
SWEP.PlyDamage			= math.ceil(SWEP.MinDamage/10)

local SwingSound = Sound( "WeaponFrag.Roll" )
local HitSoundWorld = Sound( "GlassBottle.Break" )
local HitSoundBody = Sound( "GlassBottle.Break" )

function SWEP:PrimaryAttack()

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	local vm = self.Owner:GetViewModel()

	self:EmitSound( SwingSound )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.HitRate )
	self.Weapon:SetNextSecondaryFire( CurTime() + self.HitRate )

	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )

	timer.Create("hitdelay", 0.2, 1, function() self:Hitscan() end)

	timer.Start( "hitdelay" )

end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:EmitSound( SwingSound )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )

	if SERVER then
		timer.Create("throwdelay", 0.2, 1, function() self:Throwbottle() end)

		timer.Start( "throwdelay" )
	end
end

function SWEP:Hitscan()

--This function calculate the trajectory

	for i=0, 170 do

	local tr = util.TraceLine( {
		start = (self.Owner:GetShootPos() - (self.Owner:EyeAngles():Up() * 10)),
		endpos = (self.Owner:GetShootPos() - (self.Owner:EyeAngles():Up() * 10)) + ( self.Owner:EyeAngles():Up() * ( self.HitDistance * 0.7 * math.cos(math.rad(i)) ) ) + ( self.Owner:EyeAngles():Forward() * ( self.HitDistance * 1.5 * math.sin(math.rad(i)) ) ) + ( self.Owner:EyeAngles():Right() * self.HitInclination * self.HitDistance * math.cos(math.rad(i)) ),
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

--This if shot the bullets

	if ( tr.Hit ) then

		if SERVER then
			local strength = Clockwork.attributes:Fraction(self.Owner, ATB_STRENGTH, 3, 1.5);
			local RagdolledPly = Clockwork.entity:GetPlayer(tr.Entity);

			if (RagdolledPly and RagdolledPly:IsPlayer()) then
				tr.Entity:TakeDamageInfo( Clockwork.kernel:FakeDamageInfo(self.PlyDamage + strength, self, self.Owner, tr.HitPos, DMG_CLUB, 100) )
				self.Weapon:SetNextPrimaryFire( CurTime() + 5 )
			else
				tr.Entity:TakeDamageInfo( Clockwork.kernel:FakeDamageInfo(math.random( self.MinDamage, self.MaxDamage ) + strength, self, self.Owner, tr.HitPos, DMG_CLUB, 100) )
			end
		end

		self:EmitSound( SwingSound )

		--vm:SendViewModelMatchingSequence( vm:LookupSequence( "hitcenter1" ) )

		if tr.Entity:IsPlayer() or tr.Entity:IsNPC() or tr.Entity:IsRagdoll() then
			self:EmitSound( HitSoundBody )
			-- tr.Entity:SetVelocity( self.Owner:GetAimVector() * Vector( 1, 1, 0 ) * self.HitPushback )
		else
			self:EmitSound( HitSoundWorld )
		end

		if (SERVER) then
			local itemTable = Clockwork.item:CreateInstance("weapon_hl2brokenbottle")

			self.Owner:GiveItemWeapon(itemTable)
			self.Owner:SelectWeapon("weapon_hl2brokenbottle")
			self.Owner:StripWeapon("weapon_hl2bottle")
		end
--if break
		break

--if end
		--else vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
		end
end

end

function SWEP:Throwbottle()
	local ent = ents.Create( "prop_physics" )
	if not IsValid(ent) then
		return
	end

	ent:SetModel( "models/props_junk/garbage_glassbottle003a.mdl" )
	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 20 ) )
	ent:SetAngles( self.Owner:EyeAngles() - Angle( 0, 50, 190 ) )
	ent:SetKeyValue("fadescale", 0.1)
	ent:Spawn()

	local phys = ent:GetPhysicsObject();

	phys:ApplyForceCenter (self.Owner:GetAimVector()*2000 )
	phys:AddAngleVelocity(Vector( -250, -250, 0 ))

	self.Owner:StripWeapon("weapon_hl2bottle")

	timer.Simple(10, function()
		if IsValid(ent) then
			ent:Remove()
		end
	end)
end

function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "draw" ) )

	self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 0.5 )

	return true
end

function SWEP:Holster()

	return true
end

function SWEP:OnRemove()

	timer.Remove("hitdelay")
	if SERVER then
		timer.Remove("throwdelay")
	end
	return true
end
