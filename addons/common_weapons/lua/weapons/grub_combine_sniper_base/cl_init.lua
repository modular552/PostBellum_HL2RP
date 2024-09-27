--[[
Server Name: PostBellum HL2 RP | Русский Half-Life 2 Roleplay
Server IP:   212.22.85.2:27015
File Path:   addons/common_weapons/lua/weapons/grub_combine_sniper_base/cl_init.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]


include('shared.lua')


SWEP.PrintName			= "Shot base"		-- 'Nice' Weapon name (Shown on HUD)
SWEP.Slot				= 0						-- Slot in the weapon selection menu
SWEP.SlotPos			= 10					-- Position in the slot
SWEP.DrawAmmo			= true					-- Should draw the default HL2 ammo counter
SWEP.DrawCrosshair		= false 					-- Should draw the default crosshair
SWEP.DrawWeaponInfoBox	= true					-- Should draw the weapon info box
SWEP.BounceWeaponIcon   = true					-- Should the weapon icon bounce?
SWEP.SwayScale			= 1.0					-- The scale of the viewmodel sway
SWEP.BobScale			= 1.0					-- The scale of the viewmodel bob

SWEP.RenderGroup 		= RENDERGROUP_OPAQUE


-- luacheck: globals SWEP ScrW ScrH surface
local scope = surface.GetTextureID("jaanus/ep2snip_parascope")
local lens = surface.GetTextureID("overlays/scope_lens")
local corner = surface.GetTextureID("jaanus/sniper_corner")
function SWEP:DrawHUD()
	if self.Weapon:GetNetworkedBool("Ironsights", true) then
		local scrW = ScrW()
		local scrH = ScrH()
		local offset = (scrW - scrH) * 0.5

		surface.SetDrawColor(255, 255, 255, 200)
		surface.SetTexture(scope)
		surface.DrawTexturedRect(offset, 0, scrH, scrH)

		surface.SetDrawColor(255, 255, 255, 100)
		surface.SetTexture(lens)
		surface.DrawTexturedRect(offset, 0, scrH, scrH)

		local cornerSize = scrH * 0.5 + 4 -- fix pixels leak issue
		local cornerOffset = scrH * 0.25
		local cornerOffset2 = offset + cornerOffset

		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetTexture(corner)
		surface.DrawTexturedRectRotated(cornerOffset2, cornerOffset, cornerSize, cornerSize, 0)
		surface.DrawTexturedRectRotated(cornerOffset2, scrH - cornerOffset, cornerSize, cornerSize, 90)
		surface.DrawTexturedRectRotated(scrW - cornerOffset2, scrH - cornerOffset, cornerSize, cornerSize, 180)
		surface.DrawTexturedRectRotated(scrW - cornerOffset2, cornerOffset, cornerSize, cornerSize, 270)

		surface.DrawRect(0, 0, offset, scrH)
		surface.DrawRect(scrW - offset, 0, offset, scrH)
	end
end


--[[---------------------------------------------------------
	Checks the objects before any action is taken
	This is to make sure that the entities haven't been removed
-----------------------------------------------------------]]
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

end


--[[---------------------------------------------------------
	This draws the weapon info box
-----------------------------------------------------------]]
function SWEP:PrintWeaponInfo( x, y, alpha )

end


--[[---------------------------------------------------------
   Name: SWEP:FreezeMovement()
   Desc: Return true to freeze moving the view
-----------------------------------------------------------]]
function SWEP:FreezeMovement()
	return false
end


--[[---------------------------------------------------------
   Name: SWEP:ViewModelDrawn( ViewModel )
   Desc: Called straight after the viewmodel has been drawn
-----------------------------------------------------------]]
function SWEP:ViewModelDrawn( ViewModel )
end


--[[---------------------------------------------------------
   Name: OnRestore
   Desc: Called immediately after a "load"
-----------------------------------------------------------]]
function SWEP:OnRestore()
end

--[[---------------------------------------------------------
   Name: OnRemove
   Desc: Called just before entity is deleted
-----------------------------------------------------------]]
function SWEP:OnRemove()
end

--[[---------------------------------------------------------
   Name: CustomAmmoDisplay
   Desc: Return a table
-----------------------------------------------------------]]
function SWEP:CustomAmmoDisplay()
end

--[[---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
-----------------------------------------------------------]]

local VmPos, VmAng = Vector(0,0,0), Angle(0,0,0)
local WantedPos, WantedAng = Vector(0,0,0), Angle(0,0,0)
local SetPos, SetAng = Vector(0,0,0), Angle(0,0,0)
local VmSmooth = 0

function SWEP:GetViewModelPosition( pos, ang )

	local bIron = self:GetIronsight()

	if bIron then
		self.SwayScale = 0.25
		self.BobScale = 0.25
	else
		self.SwayScale = 1
		self.BobScale = 1
	end

	if bIron then
		if self.IronSightsPos and self.IronSightsAng then
			SetPos = self.IronSightsPos
			SetAng = self.IronSightsAng
		end
		VmSmooth = self.IronsightTime * 30
	else
		SetPos = Vector(0,0,0)
		SetAng = Angle(0,0,0)
		VmSmooth = 5
	end

	WantedPos = LerpVector(FrameTime() * VmSmooth, WantedPos, SetPos)
	WantedAng = LerpAngle(FrameTime() * VmSmooth, WantedAng, SetAng)

	VmPos.x = WantedPos.x
	VmPos.y = WantedPos.y
	VmPos.z = WantedPos.z

	VmAng.p = WantedAng.p
	VmAng.y = WantedAng.y
	VmAng.r = WantedAng.r

	local Right = ang:Right()
	local Up = ang:Up()
	local Forward = ang:Forward()

	ang = ang * 1
	ang:RotateAroundAxis( Right, VmAng.p )
	ang:RotateAroundAxis( Up, VmAng.y )
	ang:RotateAroundAxis( Forward, VmAng.r )

	pos = pos + VmPos.x * Right
	pos = pos + VmPos.y * Forward
	pos = pos + VmPos.z * Up

	return pos, ang

end

--[[---------------------------------------------------------
   Name: TranslateFOV
   Desc: Allows the weapon to translate the player's FOV (clientside)
-----------------------------------------------------------]]
function SWEP:TranslateFOV( current_fov )

	return current_fov

end


--[[---------------------------------------------------------
   Name: DrawWorldModel
   Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModel()

	self.Weapon:DrawModel()

end


--[[---------------------------------------------------------
   Name: DrawWorldModelTranslucent
   Desc: Draws the world model (not the viewmodel)
-----------------------------------------------------------]]
function SWEP:DrawWorldModelTranslucent()

	self.Weapon:DrawModel()

end


--[[---------------------------------------------------------
   Name: AdjustMouseSensitivity()
   Desc: Allows you to adjust the mouse sensitivity.
-----------------------------------------------------------]]
function SWEP:AdjustMouseSensitivity()


		if self.Weapon:GetNetworkedBool( "Ironsights", true ) then
        return (1/(self.Secondary.ScopeZoom/2))
        else
        return 1
        end
end

--[[---------------------------------------------------------
   Name: GetTracerOrigin()
   Desc: Allows you to override where the tracer comes from (in first person view)
		 returning anything but a vector indicates that you want the default action
-----------------------------------------------------------]]
function SWEP:GetTracerOrigin()

end

