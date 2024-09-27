
-----------------------------------------------------

-----------------------------------------------------
local ITEM = Clockwork.item:New();
ITEM.name = "Пачка сигарет";
ITEM.plural = "Пачек сигарет";
ITEM.uniqueID = "uu_cigi";
ITEM.useSound = "physics/cardboard/cardboard_box_impact_soft7.wav";
ITEM.model = "models/closedboxshin.mdl";
ITEM.weight = 0.1;
ITEM.useText = "Выкурить";
ITEM.business = true;
ITEM.description = "Внутри пачки несколько сигарет.";
ITEM.vomit = 15;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	player:SetCharacterData("stamina", 0);
	
	player:BoostAttribute(self.name, ATB_ACROBATICS, -10, 120);
	player:BoostAttribute(self.name, ATB_ENDURANCE, -10, 120);
	player:BoostAttribute(self.name, ATB_STRENGTH, -10, 120);

	local modelClass = Clockwork.animation:GetModelClass(player:GetModel());
	local att = player:LookupAttachment("eyes");
	local id = "Smoke"..player:EntIndex();
	
	if (modelClass == "maleHuman" or modelClass == "femaleHuman") then
		att = player:LookupAttachment("mouth")
	end;
	
	ParticleEffectAttach("smoke_exhaust_01b", PATTACH_POINT_FOLLOW, player, att)
	player:EmitSound("ambient/wind/wind_snippet4.wav", 60, 150)
	
	timer.Create(id, 15, 5, function()
		if !IsValid(player) then
			timer.Remove(id)
			return
		end
		
		ParticleEffectAttach("smoke_exhaust_01b", PATTACH_POINT_FOLLOW, player, att)
		player:EmitSound("ambient/wind/wind_snippet4.wav", 60, 150)
	end)
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();