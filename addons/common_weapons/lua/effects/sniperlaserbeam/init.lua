
local LASER = Material('effects/bluelaser1')
local SPRITE = Material('sprites/blueglow2')

function EFFECT:Init( effectdata )
 
self.Pos = effectdata:GetOrigin()
self.Entity:SetPos( self.Pos )

self.Attachment = "1"--effectdata:GetAttachment()

self.Weapon = effectdata:GetEntity()

self.Forw = self.Weapon:GetForward()

self.Alpha = 0

self.MAlpha = 150

self.rot = math.random(-100, 100)

self.Spawntime = CurTime()
self.Lifetime = 2
 
end 

function EFFECT:Think()
	
	if !self.Weapon:IsValid() then return false end
	
	--self.Pos, self.Ang = self:GetTracerShootPosAng(self.Weapon:GetOwner():GetShootPos(), self.Weapon, self.Attachment)
	self.Pos, self.Forw = self:GetTracerShootPosAng(self.Weapon:GetOwner():GetShootPos(), self.Weapon, self.Attachment)
	
	--if self.Forw:Distance(self.Weapon:GetOwner():GetAimVector()) < 0.05 then
	--	self.Forw = self.Weapon:GetOwner():GetAimVector()
	--end
	
	--self.Ang = self.Weapon:GetForward()
	
	self.Entity:SetPos( self.Pos )
	
	local lifeleft = self.Spawntime + self.Lifetime - CurTime()
	if lifeleft < 0.8 then self.Alpha = lifeleft/0.8 * self.MAlpha end
	
	local livelived = CurTime() - self.Spawntime
	if livelived < 0.8 then self.Alpha = livelived/0.8 * self.MAlpha end
	
	return CurTime() <= (self.Spawntime + self.Lifetime) and self.Weapon:GetOwner():GetActiveWeapon():GetClass() == "grub_combine_sniper"
	
end


function EFFECT:Render()
	
	--local origin = self.Player:GetShootPos() - Vector(0,0,2)
	/*local VM = self.Player:GetViewModel()
	--Msg(tostring(VM))
	--Msg(tostring(self.Player:GetActiveWeapon()))
	
	local origin
	local target
	local normal
	
	if self.Player == LocalPlayer() and VM and VM:IsValid() and self.Player:GetViewModel( ):GetModel() == "models/weapons/v_combinesniper_e2.mdl" then
	
		origin = VM:GetAttachment("muzzle").Pos
		local forwardvector = VM:GetAttachment("muzzle").AngForward()
		
		--Msg(tostring(origin))
		local traceres = util.QuickTrace(origin, forwardvector * 5000, {self.Weapon, self.Weapon:GetOwner()})
		target = traceres.HitPos
		normal = traceres.HitNormal
		
	else
		
		origin = self.Player:GetShootPos()
		target = self.Player:GetEyeTrace().HitPos
		normal = self.Player:GetEyeTrace().HitNormal
		
	end*/
	--Msg(tostring(origin) .. " - " .. tostring(target) .. "\n")
	
	origin = self.Pos
	
	if self.Forw:Distance(self.Weapon:GetOwner():GetAimVector()) < 0.05 then
		target = self.Weapon:GetOwner():GetEyeTrace().HitPos
		normal = self.Weapon:GetOwner():GetEyeTrace().HitNormal
	else
	

		traceres = util.QuickTrace(origin, self.Forw * 5000, {})
		target = traceres.HitPos
		normal = traceres.HitNormal
	end
	
	
	render.SetMaterial( LASER )
	//render.DrawBeam(trace.StartPos, trace.HitPos, 6, 0, 10, Color(255,0,0,255))
	render.DrawBeam(origin, target, 2, 0, 12.5, Color(255, 255, 255, self.Alpha))
	
	render.SetMaterial( SPRITE )
	render.DrawSprite( target + normal*1, 10, 10, Color(255, 255, 255, self.Alpha * 0.7) )
	render.DrawQuadEasy( target + normal*0.5, normal, 11, 11, Color(255, 255, 255, self.Alpha), CurTime() * self.rot )
	
end


function EFFECT:GetTracerShootPosAng( Position, Ent, Attachment )

	self.ViewModelTracer = false
	
	local Forward = Vector(0,0,1)
	
	if (!Ent:IsValid()) then return Position, Vector(0,0,1) end
	if (!Ent:IsWeapon()) then return Position, Vector(0,0,1) end

	// Shoot from the viewmodel
	if ( Ent:IsCarriedByLocalPlayer() && GetViewEntity() == LocalPlayer() ) then
	
		local ViewModel = LocalPlayer():GetViewModel()
		
		if ( ViewModel:IsValid() ) then
			
			local att = ViewModel:GetAttachment( Attachment )
			if ( att ) then
				Position = att.Pos + att.Ang:Right() * -2 - att.Ang:Forward() * 40
				Forward = att.Ang:Forward()
				self.ViewModelTracer = true
			end
			
		end
	
	// Shoot from the world model
	else
	
		--local att = Ent:GetAttachment( Attachment )
		--if ( att ) then
			--Position = att.Pos
			Forward = Ent:GetOwner():GetAimVector()
			Position = Ent:GetPos() + Forward * 40 + Ent:GetUp() * 13 + Ent:GetRight() * 8
		--end
	
	end

	return Position,Forward

end
