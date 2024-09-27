SWEP.PrintName = "M45A1"

SWEP.Category = "PB Dunkerk"

SWEP.Spawnable= true
SWEP.AdminSpawnable= true
SWEP.AdminOnly = true

SWEP.ViewModelFOV = 74
SWEP.ViewModel = "models/weapons/insurgency/v_m45.mdl"
SWEP.WorldModel = "models/weapons/insurgency/w_m45.mdl"
SWEP.ViewModelFlip = false

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 0
 
SWEP.UseHands = true

SWEP.HoldType = "pistol" 

SWEP.FiresUnderwater = false

SWEP.DrawCrosshair = false

SWEP.DrawAmmo = true

SWEP.Base = "weapon_base"

SWEP.CSMuzzleFlashes = true

SWEP.Vehicle = 0
SWEP.FirstTime = 0
SWEP.Sprint = 0
SWEP.Reloading = 0
SWEP.IronSightsPos = Vector( -1.87, 0, 0.4 )
SWEP.IronSightsAng = Vector( 0, 0, 0 )
SWEP.Primary.Cone = 0.02
SWEP.NextSecondaryAttack = 0.2

SWEP.Primary.Sound = Sound( "weapons/m45/m45_fp.wav" )
SWEP.Primary.Damage = 55
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.ClipSize = 7
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Spread = 0.1
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Delay = 0.2
SWEP.Primary.Force = 5

SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
self.Weapon:SetHoldType( self.HoldType )
self.Weapon:SetWeaponHoldType( self.HoldType )
self.FirstTime = 1
end 

function SWEP:DrawModels()
    if CLIENT then
        self.Hands = ClientsideModel( "models/weapons/insurgency/v_hands_ins_l.mdl", RENDERGROUP_VIEWMODEL )
        local vm = self.Owner:GetViewModel()
        self.Hands:SetPos( vm:GetPos() )
        self.Hands:SetAngles( vm:GetAngles() )
        self.Hands:AddEffects( EF_BONEMERGE )
        self.Hands:SetNoDraw( true )
        self.Hands:SetParent( vm )
        self.Hands:DrawModel()
        self.Mag = ClientsideModel( "models/weapons/insurgency/upgrades/a_magazine_m45_8.mdl", RENDERGROUP_VIEWMODEL )
        self.Mag:SetPos( vm:GetPos() )
        self.Mag:SetAngles( vm:GetAngles() )
        self.Mag:AddEffects( EF_BONEMERGE )
        self.Mag:SetNoDraw( true )
        self.Mag:SetParent( vm )
        self.Mag:DrawModel()
    end
end

function SWEP:ViewModelDrawn()
if CLIENT then
if not( self.Hands ) then
self:DrawModels()
end
if self.Hands then
self.Hands:DrawModel()
end
if not( self.Mag ) then
self:DrawModels()
end
if self.Hands then
self.Mag:DrawModel()
end
end
end

function SWEP:Deploy()
self.Weapon:SetHoldType( self.HoldType )
self.Weapon:SetWeaponHoldType( self.HoldType )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
if self.Weapon:Clip1() > 0 and self.FirstTime == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_draw" ) )
end
if self.Weapon:Clip1() <= 0 and self.FirstTime == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "empty_draw" ) )
end
if self.FirstTime == 1 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_ready" ) )
self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
self.FirstTime = 0
end
self.Vehicle = 1
self.Sprint = 0
self.Reloading = 0
self.NextSecondaryAttack = 0
self:SetIronsights( false )
return true
end

function SWEP:Holster()
self.Vehicle = 1
self.Sprint = 0
self.Reloading = 0
self.NextSecondaryAttack = 0
self:SetIronsights( false )
return true
end

function SWEP:PrimaryAttack()

if not( self.Sprint == 0 ) then return end
if ( !self:CanPrimaryAttack() ) then return end

local bullet = {} 
bullet.Num = self.Primary.NumberofShots 
bullet.Src = self.Owner:GetShootPos() 
bullet.Dir = self.Owner:GetAimVector() 
bullet.Spread = Vector( self.Primary.Spread * 0.1, self.Primary.Spread * 0.1, 0 )
bullet.Tracer = 1 
bullet.Force = self.Primary.Force 
bullet.Damage = self.Primary.Damage 
bullet.AmmoType = self.Primary.Ammo 

self:ShootEffects()
if self.Weapon:Clip1() > 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_fire"..math.random( 2, 3 ).."" ) )
end
if self.Weapon:Clip1() == 1 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_firelast" ) )
end
if self.Weapon:GetNetworkedBool( "Ironsights", true ) then
if self.Weapon:Clip1() > 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "iron_fire_"..math.random( 1, 3 ).."" ) )
end
if self.Weapon:Clip1() == 1 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "iron_firelast" ) )
end
end
self.Owner:FireBullets( bullet )
self:EmitSound( Sound( self.Primary.Sound ) )
if IsFirstTimePredicted() then
    self.Owner:ViewPunch( Angle( -2 * self.Primary.Recoil, math.Rand( -2, 2 ) *self.Primary.Recoil, 0 ) )
    self.Owner:MuzzleFlash()
end
self:TakePrimaryAmmo( self.Primary.TakeAmmo )
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
end

local IRONSIGHT_TIME = 0.2

function SWEP:GetViewModelPosition( pos, ang )

if ( !self.IronSightsPos ) then return pos, ang end

local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )

if ( bIron != self.bLastIron ) then

self.bLastIron = bIron
self.fIronTime = CurTime()

if ( bIron ) then
self.SwayScale = 0.1
self.BobScale = 0.1
else
self.SwayScale = 1.0
self.BobScale = 1.0
end
end

local fIronTime = self.fIronTime or 0

if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
return pos, ang 
end

local Mul = 1.0

if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then

Mul = math.Clamp( ( CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )

if ( !bIron ) then Mul = 1 - Mul end

end

local Offset = self.IronSightsPos

if ( self.IronSightsAng ) then
	
ang = ang * 1
ang:RotateAroundAxis( ang:Right(), self.IronSightsAng.x * Mul )
ang:RotateAroundAxis( ang:Up(), self.IronSightsAng.y * Mul )
ang:RotateAroundAxis( ang:Forward(), self.IronSightsAng.z * Mul )

end

local Right = ang:Right()
local Up = ang:Up()
local Forward = ang:Forward()

pos = pos + Offset.x * Right * Mul
pos = pos + Offset.y * Forward * Mul
pos = pos + Offset.z * Up * Mul

return pos, ang

end

function SWEP:SetIronsights( b )
self.Weapon:SetNetworkedBool( "Ironsights", b )
end

function SWEP:SecondaryAttack()

if ( !self.IronSightsPos ) then return end
if ( self.NextSecondaryAttack > CurTime() ) then return end
	
bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )

self:SetIronsights( bIronsights )

self.NextSecondaryAttack = CurTime() + 0.2
end

function SWEP:OnRestore()
self.Vehicle = 0
self.Sprint = 0
self.Reloading = 0
self.NextSecondaryAttack = 0
self:SetIronsights( false )
end

function SWEP:Reload()
if self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
self.Weapon:DefaultReload( ACT_VM_RELOAD )
if self.Weapon:Clip1() > 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_reload" ) )
end
if self.Weapon:Clip1() <= 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_reloadempty" ) )
end
self.Sprint = 0
self.Reloading = 1
if self.Reloading == 1 then
timer.Simple( 2.5, function()
if self.Reloading == 1 then
self.Reloading = 0
end
end)
end
self.NextSecondaryAttack = 0
self:SetIronsights( false )
end
end

function SWEP:Think()
if self.Owner:InVehicle() and self.Vehicle == 0 then
self.Vehicle = 1
end
if not( self.Owner:InVehicle() ) and self.Vehicle == 1 then
self.Vehicle = 0
self:DrawModels()
end
if self.Owner:KeyPressed( IN_RELOAD ) and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
self.Sprint = 0
self.Reloading = 1
end
if self.Owner:KeyPressed( IN_ATTACK ) and self.Weapon:Clip1() <= 0 and self.Weapon:Ammo1() > 0 then
self.Sprint = 0
self.Reloading = 1
end
if self.Reloading == 1 then return end
if self.Sprint == 0 and self.Reloading == 0 then
if self.Owner:KeyDown( IN_SPEED ) and ( self.Owner:KeyDown( IN_FORWARD ) || self.Owner:KeyDown( IN_BACK ) || self.Owner:KeyDown( IN_MOVELEFT ) || self.Owner:KeyDown( IN_MOVERIGHT ) ) then
self.Sprint = 1
self.NextSecondaryAttack = 0
self:SetIronsights( false )
end
end
if self.Sprint == 1 and self.Reloading == 0 then
if self.Weapon:Clip1() > 0 and self.Reloading == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_sprint" ) )
end
if self.Weapon:Clip1() <= 0 and self.Reloading == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "empty_sprint" ) )
end
self.Sprint = 2
end
if self.Sprint == 2 and self.Reloading == 0 then
if not( self.Owner:KeyDown( IN_SPEED ) ) and self.Reloading == 0 then
if self.Weapon:Clip1() > 0 and self.Reloading == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_idle" ) )
end
if self.Weapon:Clip1() <= 0 and self.Reloading == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "empty_idle" ) )
end
self.Sprint = 0
end
if self.Reloading == 0 and not( self.Owner:KeyDown( IN_FORWARD ) || self.Owner:KeyDown( IN_BACK ) || self.Owner:KeyDown( IN_MOVELEFT ) || self.Owner:KeyDown( IN_MOVERIGHT ) ) then
if self.Weapon:Clip1() > 0 and self.Reloading == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "base_idle" ) )
end
if self.Weapon:Clip1() <= 0 and self.Reloading == 0 then
local vm = self.Owner:GetViewModel()
vm:SendViewModelMatchingSequence( vm:LookupSequence( "empty_idle" ) )
end
self.Sprint = 0
end
end
end