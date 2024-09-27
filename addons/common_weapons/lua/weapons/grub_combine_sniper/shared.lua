--[[
Server Name: PostBellum HL2 RP | Русский Half-Life 2 Roleplay
Server IP:   212.22.85.2:27015
File Path:   addons/common_weapons/lua/weapons/grub_combine_sniper/shared.lua
		 __        __              __             ____     _                ____                __             __         
   _____/ /_____  / /__  ____     / /_  __  __   / __/____(_)__  ____  ____/ / /_  __     _____/ /____  ____ _/ /__  _____
  / ___/ __/ __ \/ / _ \/ __ \   / __ \/ / / /  / /_/ ___/ / _ \/ __ \/ __  / / / / /    / ___/ __/ _ \/ __ `/ / _ \/ ___/
 (__  ) /_/ /_/ / /  __/ / / /  / /_/ / /_/ /  / __/ /  / /  __/ / / / /_/ / / /_/ /    (__  ) /_/  __/ /_/ / /  __/ /    
/____/\__/\____/_/\___/_/ /_/  /_.___/\__, /  /_/ /_/  /_/\___/_/ /_/\__,_/_/\__, /____/____/\__/\___/\__,_/_/\___/_/     
                                     /____/                                 /____/_____/                                  
--]]

AddCSLuaFile()

SWEP.VElements = {
	["pipe1+"] = {
		type = "Model",
		model = "models/props_c17/GasPipes006a.mdl",
		bone = "base",
		rel = "",
		pos = Vector(2.273, -7.618, -1.255),
		angle = Angle(-90, 180, 0.382),
		size = Vector(0.076, 0.076, 0.076),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "phoenix_storms/MetalSet_1-2",
		skin = 0,
		bodygroup = {}
	},
	["pipe1"] = {
		type = "Model",
		model = "models/props_c17/GasPipes006a.mdl",
		bone = "base",
		rel = "",
		pos = Vector(2.267, -7.224, -1.43),
		angle = Angle(-90, 180, 0.382),
		size = Vector(0.076, 0.076, 0.076),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "phoenix_storms/MetalSet_1-2",
		skin = 0,
		bodygroup = {}
	},
	["indicator_holder"] = {
		type = "Model",
		model = "models/Items/battery.mdl",
		bone = "base",
		rel = "",
		pos = Vector(0.177, -6.804, -1.203),
		angle = Angle(180, 180, 90),
		size = Vector(0.109, 0.109, 0.109),
		color = Color(255, 255, 255, 255),
		surpresslightning = false,
		material = "",
		skin = 0,
		bodygroup = {}
	},
	["indicator"] = {
		type = "Sprite",
		sprite = "sprites/glow04",
		bone = "base",
		rel = "",
		pos = Vector(-0.332, -7.698, -1.203),
		size = {x = 1, y = 1},
		color = Color(255, 255, 255, 255),
		nocull = true,
		additive = true,
		vertexalpha = true,
		vertexcolor = true,
		ignorez = false
	}
}

if (CLIENT) then
	SWEP.Category = "Grub's Weapons"
	SWEP.PrintName = "Combine Sniper"

	SWEP.Slot = 2
	SWEP.SlotPos = 2
	SWEP.ViewModelFOV = 70
	SWEP.CSMuzzleFlashes = true
end

SWEP.Base = "grub_combine_sniper_base" -- what is the base of the weapon

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.HoldType = "ar2" -- the animation in thirdperson
SWEP.ViewModel = "models/weapons/v_combinesniper_e2.mdl" -- model you will see in first person
SWEP.WorldModel = "models/weapons/w_combinesniper_e2.mdl" -- model you will see in thirdperson
SWEP.UseHands = false
SWEP.ViewModelFlip = false -- is the models is left handed ()

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = true

SWEP.Primary.Recoil = 3
SWEP.Primary.Damage = 50
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = .001 -- the spread
SWEP.Primary.ClipSize = 5
SWEP.Primary.RPM = 30 -- ROF
SWEP.Primary.DefaultClip = 5 -- set it the same value as the ClipSize to prevent some problem
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "ar2"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.ShellDelay = 0
SWEP.ShellEffect = "none"
SWEP.MuzzleEffect = "none"
SWEP.MuzzleAttachment = "1"
SWEP.ShellEjectAttachment = "1"

SWEP.Secondary.ScopeZoom = 7

SWEP.IronsightTime = 0.25
SWEP.RunSightTime = 0.15

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Angle(0, 0, 0)

SWEP.LaserLastRespawn = 0

function SWEP:Think()
	if not IsValid(self.Owner) then
		return
	end

	if self.LaserLastRespawn < CurTime() then
		self.LaserLastRespawn = CurTime() + 1

		if self:Clip1() > 0 then
			self.VElements["indicator"].color = Color(21, 186, 7, 255)
		else
			self.VElements["indicator"].color = Color(255, 0, 0, 255)
		end
	end
end

function SWEP:Holster()
	if CLIENT then
		if self.VElements then
			for k, v in pairs(self.VElements) do
				if IsValid(v.modelEnt) then
					v.modelEnt:Remove()
				end
			end
		end
		if self.WElements then
			for k, v in pairs(self.WElements) do
				if IsValid(v.modelEnt) then
					v.modelEnt:Remove()
				end
			end
		end
	end

	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end

	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then
	local LASER = Material("effects/bluelaser1")
	local SPRITE = Material("effects/blueflare1")

	local function drawLaser(self, ply, attPos)
		local pos = ply:GetShootPos()
		local aim = (ply:GetAimVector():Angle() + ply:GetViewPunchAngles()):Forward()

		local traceOut = self.traceOut
		local traceData = self.traceData
		if not traceData then
			return
		end
		traceData.start = pos
		traceData.endpos = pos + aim * 8192
		util.TraceLine(traceData)

		local hitPos = traceOut.HitPos
		render.SetMaterial(LASER)
		render.DrawBeam(attPos, hitPos, 1, 0, traceOut.Fraction * 10, Color(255, 0, 0))
		render.SetMaterial(SPRITE)
		render.DrawSprite(hitPos, 2, 2, Color(50, 190, 255))
	end

	function SWEP:PreDrawViewModel(vm, _, ply)
		if ply:GetActiveWeapon() ~= self then
			return
		end

		if (self:GetNextPrimaryFire() - 1) >= CurTime() or not Clockwork.player:GetWeaponRaised(ply) then
			return
		end

		local att = vm:GetAttachment(1)
		if att then
			local attPos = att.Pos + att.Ang:Right() * -2 - att.Ang:Forward() * 40
			drawLaser(self, ply, attPos)
		end
	end

	function SWEP:PostDrawTranslucentRenderables(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
		if bDrawingDepth or bDrawingSkybox or isDraw3DSkybox then
			return
		end

		local ply = self:GetOwner()
		if not IsValid(ply) or ply:GetActiveWeapon() ~= self then
			return
		end

		local localPly = LocalPlayer()
		if ply == localPly and not localPly:ShouldDrawLocalPlayer() then
			return
		end

		if (self:GetNextFire() - 1) >= CurTime() or not Clockwork.player:GetWeaponRaised(ply) then
			return
		end

		if ply:InVehicle() then
			return
		end
		if ply:IsNoClipping() then
			return
		end

		local att = self:GetAttachment(1)
		if att then
			local attPos = att.Pos + att.Ang:Up() * 0.7 + att.Ang:Right() * -2.2 - att.Ang:Forward() * 30
			drawLaser(self, ply, attPos)
		end
	end

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		local vm = self.Owner:GetViewModel()
		if not IsValid(vm) then
			return
		end

		if (not self.VElements) then
			return
		end

		self:UpdateBonePositions(vm)

		if (not self.vRenderOrder) then
			self.vRenderOrder = {}

			for k, v in pairs(self.VElements) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
		end

		for k, name in ipairs(self.vRenderOrder) do
			local v = self.VElements[name]
			if (not v) then
				self.vRenderOrder = nil
				break
			end
			if (v.hide) then continue end

			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if (not v.bone) then continue end

			local pos, ang = self:GetBoneOrientation(self.VElements, v, vm)

			if (not pos) then continue end

			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)

				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial(v.material)
				end

				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs(v.bodygroup) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			elseif (v.type == "Model") then
				self:CreateModels(self.VElements)
			elseif (v.type == "Sprite" and sprite) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif (v.type == "Quad" and v.draw_func) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end

		if (not self.WElements) then
			return
		end

		if (not self.wRenderOrder) then
			self.wRenderOrder = {}

			for k, v in pairs(self.WElements) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
		end

		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			bone_ent = self
		end

		for k, name in pairs(self.wRenderOrder) do
			local v = self.WElements[name]
			if (not v) then
				self.wRenderOrder = nil
				break
			end
			if (v.hide) then continue end

			local pos, ang

			if (v.bone) then
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent)
			else
				pos, ang = self:GetBoneOrientation(self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand")
			end

			if (not pos) then continue end

			local model = v.modelEnt
			local sprite = v.spriteMaterial

			if (v.type == "Model" and IsValid(model)) then
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z)
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix("RenderMultiply", matrix)

				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() ~= v.material) then
					model:SetMaterial(v.material)
				end

				if (v.skin and v.skin ~= model:GetSkin()) then
					model:SetSkin(v.skin)
				end

				if (v.bodygroup) then
					for k, v in pairs(v.bodygroup) do
						if (model:GetBodygroup(k) ~= v) then
							model:SetBodygroup(k, v)
						end
					end
				end

				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end

				render.SetColorModulation(v.color.r / 255, v.color.g / 255, v.color.b / 255)
				render.SetBlend(v.color.a / 255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)

				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
			elseif (v.type == "Model") then
				self:CreateModels(self.WElements)
			elseif (v.type == "Sprite" and sprite) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
			elseif (v.type == "Quad" and v.draw_func) then
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				cam.Start3D2D(drawpos, ang, v.size)
				v.draw_func(self)
				cam.End3D2D()
			end
		end
	end

	function SWEP:GetBoneOrientation(basetab, tab, ent, bone_override)
		local bone, pos, ang
		if (tab.rel and tab.rel ~= "") then
			local v = basetab[tab.rel]

			if (not v) then
				return
			end

			pos, ang = self:GetBoneOrientation(basetab, v, ent)

			if (not pos) then
				return
			end

			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		else
			bone = ent:LookupBone(bone_override or tab.bone)

			if (not bone) then
				return
			end

			pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end

			if (IsValid(self.Owner) and self.Owner:IsPlayer() and ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r
			end
		end

		return pos, ang
	end

	function SWEP:CreateModels(tab)
		if (not tab) then
			return
		end

		for k, v in pairs(tab) do
			if v.type == "Model" and not IsValid(v.modelEnt) then
				v.modelEnt = ClientsideModel(v.model, RENDERGROUP_VIEWMODEL)
				v.modelEnt:SetPos(self:GetPos())
				v.modelEnt:SetAngles(self:GetAngles())
				v.modelEnt:SetParent(self)
				v.modelEnt:SetTransmitWithParent(true)
				v.modelEnt:SetNoDraw(true)
			elseif (v.type == "Sprite" and not v.spriteMaterial) then
				local name = v.sprite .. "-"
				local params = {["$basetexture"] = v.sprite}
				local tocheck = {"nocull", "additive", "vertexalpha", "vertexcolor", "ignorez"}
				for i, j in pairs(tocheck) do
					if (v[j]) then
						params["$" .. j] = 1
						name = name .. "1"
					else
						name = name .. "0"
					end
				end

				v.spriteMaterial = CreateMaterial(name, "UnlitGeneric", params)
			end
		end
	end

	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		if self.ViewModelBoneMods then
			if (not vm:GetBoneCount()) then
				return
			end

			local loopthrough = self.ViewModelBoneMods
			if (not hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i = 0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = {
							scale = Vector(1, 1, 1),
							pos = Vector(0, 0, 0),
							angle = Angle(0, 0, 0)
						}
					end
				end

				loopthrough = allbones
			end

			for k, v in pairs(loopthrough) do
				local bone = vm:LookupBone(k)
				if (not bone) then continue end

				local s = Vector(v.scale.x, v.scale.y, v.scale.z)
				local p = Vector(v.pos.x, v.pos.y, v.pos.z)
				local ms = Vector(1, 1, 1)
				if (not hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while (cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end

				s = s * ms
				if vm:GetManipulateBoneScale(bone) ~= s then
					vm:ManipulateBoneScale(bone, s)
				end
				if vm:GetManipulateBoneAngles(bone) ~= v.angle then
					vm:ManipulateBoneAngles(bone, v.angle)
				end
				if vm:GetManipulateBonePosition(bone) ~= p then
					vm:ManipulateBonePosition(bone, p)
				end
			end
		else
			self:ResetBonePositions(vm)
		end
	end

	function SWEP:ResetBonePositions(vm)
		if (not vm:GetBoneCount()) then
			return
		end
		for i = 0, vm:GetBoneCount() do
			vm:ManipulateBoneScale(i, Vector(1, 1, 1))
			vm:ManipulateBoneAngles(i, Angle(0, 0, 0))
			vm:ManipulateBonePosition(i, Vector(0, 0, 0))
		end
	end

	function table.FullCopy(tab)
		if (not tab) then
			return nil
		end

		local res = {}
		for k, v in pairs(tab) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v)
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end

		return res
	end
end
