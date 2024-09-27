--[[
Server Name: PostBellum HL2 RP | Русский Half-Life 2 Roleplay
Server IP:   212.22.85.2:27015
File Path:   addons/common_weapons/lua/weapons/grub_combine_sniper_base/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


include( "ai_translations.lua" )
include( "sh_anim.lua" )
AddCSLuaFile( "ai_translations.lua" )
AddCSLuaFile( "sh_anim.lua" )

-- Variables that are used on both client and server

SWEP.Category  		= "Twilight Sparkle`s SWEPs" -- the categorry where all your weapon from this vbase will be

SWEP.Author			= "Twilight Sparkle aka Residualgrub"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.CSMuzzleFlashes    = true
SWEP.ViewModelFOV	= 62
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"
SWEP.AnimPrefix		= "python"
SWEP.HoldType 		= "pistol"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound("NPC_Sniper.FireBullet")
SWEP.Primary.Recoil			= 0
SWEP.Primary.CurrentSpread 	= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 0
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.RPM			= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ReloadSound 			= Sound("NPC_Sniper.Reload")
SWEP.ReloadClipSound 		= Sound("Weapon_AR2.NPC_Reload")
SWEP.EmptySound 			= Sound("jaanus/ep2sniper_empty.wav")

SWEP.ShellDelay = 0
SWEP.ShellEffect = "none"
SWEP.MuzzleEffect            = "none"
SWEP.MuzzleAttachment        = "1"
SWEP.ShellEjectAttachment    = "1"

SWEP.Secondary.ScopeZoom        = 5
SWEP.Secondary.UseACOG          = false
SWEP.Secondary.UseMilDot        = false
SWEP.Secondary.UseSVD           = false
SWEP.Secondary.UseParabolic     = false
SWEP.Secondary.UseElcan         = false
SWEP.Secondary.UseGreenDuplex   = false


SWEP.ScopeScale             = 0.5
SWEP.ReticleScale           =0.5

SWEP.IronsightTime 			= 0.25
SWEP.RunSightTime 			= 0.15

SWEP.IronSightsPos 			= Vector(0,0,0)
SWEP.IronSightsAng 			= Angle(0,0,0)

--[[---------------------------------------------------------
   Name: SWEP:Initialize( )
   Desc: Called when the weapon is first loaded
-----------------------------------------------------------]]
function SWEP:Initialize()
	if CLIENT then
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)

				// Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					// we set the alpha to 1 instead of 0 because else ViewModelDrawn stops being called
					vm:SetColor(Color(255,255,255,1))
					// ^ stopped working in GMod 13 because you have to do Entity:SetRenderMode(1) for translucency to kick in
					// however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")
				end
			end
		end
	end
	self:SetWeaponHoldType( self.HoldType )
	self:SetNextFire(CurTime())
	self:ResetVar()
	self:SetNetworkedBool( "Ironsights", false )
	self:SetNetworkedBool( "boot", true )
end

function SWEP:ResetVar() -- use this function when you need to make the waepon go back to the normal (example: deploy, holster) prevent a lot of problems
	self.dt.Ironsight = false
	self.Primary.CurrentSpread = 0
end

function SWEP:SetupDataTables()
	self:DTVar("Bool", 0, "Ironsight")
	self:NetworkVar("Int", 0, "NextFire")
end


--[[---------------------------------------------------------
   Name: SWEP:PrimaryAttack( )
   Desc: +attack1 has been pressed
-----------------------------------------------------------]]
function SWEP:PrimaryAttack()
	if ( self:Clip1() > 0 ) then
		local nextFire = CurTime()+1/(self.Primary.RPM/60)
		self:SetNextPrimaryFire(nextFire)
		self:SetNextFire(nextFire)
		self:EmitSound(self.Primary.Sound)
		self:ShootBullet( self.Primary.Damage, self.Primary.Numshots, self.Primary.Recoil, self.Primary.Cone )
		self:TakePrimaryAmmo( 1 )
		timer.Simple(0.1, function()
			if IsValid(self) then
				self:EmitSound(self.ReloadSound)
			end
		end)
	else
		self:EmitSound(self.EmptySound)
	end
end


--[[---------------------------------------------------------
   Name: SWEP:SecondaryAttack( )
   Desc: +attack2 has been pressed
-----------------------------------------------------------]]
function SWEP:SecondaryAttack()
	LastIron = !self:GetIronsight()
	self:SetIronsight(LastIron)
	self:SetNextSecondaryFire(CurTime() + self.IronsightTime)
end

--[[---------------------------------------------------------
   Name: SWEP:CheckReload( )
   Desc: CheckReload
-----------------------------------------------------------]]
function SWEP:CheckReload()

end

--[[---------------------------------------------------------
   Name: SWEP:Reload( )
   Desc: Reload is being pressed
-----------------------------------------------------------]]
function SWEP:Reload()
	if self:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then return end

	self:SetNextFire(CurTime() + 4)

	self:DefaultReload(ACT_VM_RELOAD);
	self:SetNetworkedBool( "Ironsights", false )
	self:SetIronsight(false)
	self:EmitSound(self.ReloadClipSound)
end


--[[---------------------------------------------------------
   Name: SWEP:Holster( weapon_to_swap_to )
   Desc: Weapon wants to holster
   RetV: Return true to allow the weapon to holster
-----------------------------------------------------------]]
function SWEP:Holster( wep )
	return true
end

--[[---------------------------------------------------------
   Name: SWEP:Deploy( )
   Desc: Whip it out
-----------------------------------------------------------]]
function SWEP:Deploy()
	if self:GetNetworkedBool( "boot", true ) then
		self:EmitSound("HL1/fvox/bell.wav")
		timer.Simple( 1, function() if IsValid(self) then self:EmitSound("HL1/fvox/activated.WAV") end end )
		timer.Simple( 2.5, function() if IsValid(self) then self:EmitSound("HL1/fvox/buzz.wav") end end )
		timer.Simple( 3, function() if IsValid(self) then self:EmitSound("HL1/fvox/power_restored.wav") end end )
		self:SetNetworkedBool( "boot", false )
	end

	self:SetNetworkedBool( "Ironsights", false )
	self:ResetVar()
	return true
end

function SWEP:ShootEffects(recoil)

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 		-- View model animation
	self.Owner:MuzzleFlash()

    local fx         = EffectData()
    fx:SetEntity(self)
    fx:SetOrigin(self.Owner:GetShootPos())
    fx:SetNormal(self.Owner:GetAimVector())
    fx:SetAttachment(self.MuzzleAttachment)
    util.Effect(self.MuzzleEffect,fx)

    local effectdata = EffectData()
        effectdata:SetOrigin(self.Owner:GetShootPos())
        effectdata:SetEntity(self)
        effectdata:SetStart(self.Owner:GetShootPos())
        effectdata:SetNormal(self.Owner:GetAimVector())
        effectdata:SetAttachment(1)


        timer.Simple(self.ShellDelay, function()
        if not self.Owner then return end
        if not IsFirstTimePredicted() then return end
        if not self.Owner:IsNPC() and not self.Owner:Alive() then return end

        local fxs     = EffectData()
            fxs:SetEntity(self)
            fxs:SetNormal(self.Owner:GetAimVector())
            fxs:SetAttachment(self.ShellEjectAttachment)

            util.Effect(self.ShellEffect,fxs)
    end)

        local trace = self.Owner:GetEyeTrace()							-- Crappy muzzle light



	self.Owner:SetAnimation( PLAYER_ATTACK1 )	-- 3rd Person Animation

	SideRecoil = recoil / 1.5
	anglo = Angle(-recoil, math.Rand(-SideRecoil,SideRecoil), 0)
	self.Owner:ViewPunch(anglo)

end

function SWEP:GetIronsight()
	if self.dt.Ironsight then
		return self.dt.Ironsight
	end
	return false
end

function SWEP:SetIronsight(Bool)
	self:SetNetworkedBool( "Ironsights", b )
	self.dt.Ironsight = Bool
	if Bool then -- things will happen if Bool is true
	self:SetNetworkedBool( "Ironsights", true )
	self.Owner:SetFOV( 75/self.Secondary.ScopeZoom, 0.15 )
    self.Owner:DrawViewModel(false)
	else -- things will happen if bool is false
	self:SetNetworkedBool( "Ironsights", false )
	self.Owner:SetFOV( 0, 0.2 )
    self.Owner:DrawViewModel(true)
	end
end


--[[---------------------------------------------------------
   Name: SWEP:ShootBullet( )
   Desc: A convenience function to shoot bullets
-----------------------------------------------------------]]
function SWEP:ShootBullet( damage, num_bullets, recoil, aimcone )
	num_bullets = self.Primary.NumShots
	local bullet = {}
	bullet.Num 		= num_bullets
	bullet.Src 		= self.Owner:GetShootPos()			-- Source
	bullet.Dir 		= (self.Owner:GetAimVector():Angle() + self.Owner:GetPunchAngle()):Forward()			-- Dir of bullet
	bullet.Spread 	= Vector( aimcone, aimcone, 0 )		-- Aim Cone
	bullet.Tracer	= 5									-- Show a tracer on every x bullets
	bullet.Force	= 1									-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = "Pistol"

	self.Owner:FireBullets( bullet )

	self:ShootEffects(recoil)

end


--[[---------------------------------------------------------
   Name: SWEP:TakePrimaryAmmo(   )
   Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakePrimaryAmmo( num )

	-- Doesn't use clips
	if ( self:Clip1() <= 0 ) then

		if ( self:Ammo1() <= 0 ) then return end

		self.Owner:RemoveAmmo( num, self:GetPrimaryAmmoType() )

	return end

	self:SetClip1( self:Clip1() - num )

end


--[[---------------------------------------------------------
   Name: SWEP:TakeSecondaryAmmo(   )
   Desc: A convenience function to remove ammo
-----------------------------------------------------------]]
function SWEP:TakeSecondaryAmmo( num )

	-- Doesn't use clips
	if ( self:Clip2() <= 0 ) then

		if ( self:Ammo2() <= 0 ) then return end

		self.Owner:RemoveAmmo( num, self:GetSecondaryAmmoType() )

	return end

	self:SetClip2( self:Clip2() - num )

end


--[[---------------------------------------------------------
   Name: SWEP:CanPrimaryAttack( )
   Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanPrimaryAttack()

	if ( self:Clip1() <= 0 ) then

		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:Reload()
		return false

	end

	return true

end


--[[---------------------------------------------------------
   Name: SWEP:CanSecondaryAttack( )
   Desc: Helper function for checking for no ammo
-----------------------------------------------------------]]
function SWEP:CanSecondaryAttack()

	if ( self:Clip2() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextSecondaryFire( CurTime() + 0.2 )
		return false

	end

	return true

end


--[[---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end


--[[---------------------------------------------------------
   Name: OwnerChanged
   Desc: When weapon is dropped or picked up by a new player
-----------------------------------------------------------]]
function SWEP:OwnerChanged()
	local ply = self.Owner
	if not IsValid(ply) then
		return
	end

	if CLIENT then
		self.traceOut = {}
		self.traceData = {
			mask = MASK_SHOT,
			output = self.traceOut,
			filter = {ply, self}
		}

		hook.Add(
			"PostDrawTranslucentRenderables",
			self,
			function(_self, bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
				_self:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
			end
		)
	end
end


--[[---------------------------------------------------------
   Name: Ammo1
   Desc: Returns how much of ammo1 the player has
-----------------------------------------------------------]]
function SWEP:Ammo1()
	return self.Owner:GetAmmoCount( self:GetPrimaryAmmoType() )
end


--[[---------------------------------------------------------
   Name: Ammo2
   Desc: Returns how much of ammo2 the player has
-----------------------------------------------------------]]
function SWEP:Ammo2()
	return self.Owner:GetAmmoCount( self:GetSecondaryAmmoType() )
end

--[[---------------------------------------------------------
   Name: DoImpactEffect
   Desc: Callback so the weapon can override the impact effects it makes
		 return true to not do the default thing - which is to call UTIL_ImpactTrace in c++
-----------------------------------------------------------]]
function SWEP:DoImpactEffect( tr, nDamageType )

	return false;

end
