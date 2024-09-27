local PLUGIN = PLUGIN;

-- Called when the local player's motion blurs should be adjusted.
function PLUGIN:PlayerAdjustMotionBlurs(motionBlurs)
	if ( Clockwork.Client:HasInitialized() ) then
		local hunger = Clockwork.Client:GetSharedVar("hunger");
		local thirst = Clockwork.Client:GetSharedVar("thirst");
		local data = math.min(hunger, thirst);
		
		if (data <= 10 and data != -1) then
			motionBlurs.blurTable["needs"] = 0.3;
		elseif (data <= 30 and data != -1) then
			motionBlurs.blurTable["needs"] = 0.6;
		end;
	end;
end;

--------------------------------------
function PLUGIN:GetBars(bars)
	local hunger = tonumber(Clockwork.Client:GetSharedVar("hunger"));
	local thirst = tonumber(Clockwork.Client:GetSharedVar("thirst"));
	
	if (!self.hunger) then
		self.hunger = hunger;
	else
		self.hunger = math.Approach(self.hunger, hunger, 1);
	end;
	
	if (!self.thirst) then
		self.thirst = thirst;
	else
		self.thirst = math.Approach(self.thirst, thirst, 1);
	end;
	
	if (hunger != -1) then
		Clockwork.bars:Add("HUNGER", Color(150, 200, 150, 255), "Голод", self.hunger, 100, self.hunger <= 30);
	end;
	if (thirst != -1) then
		Clockwork.bars:Add("THIRST", Color(100, 150, 200, 255), "Жажда", self.thirst, 100, self.thirst <= 30);
	end;
end;
-----------------------------------------------

-- Called when the F1 Text is needed.
-- function PLUGIN:GetPlayerInfoText(playerInfoText)
-- 	local hunger = tonumber(Clockwork.Client:GetSharedVar("hunger"));
-- 	local thirst = tonumber(Clockwork.Client:GetSharedVar("thirst"));
	
-- 	if (!self.hunger) then
-- 		self.hunger = hunger;
-- 	else
-- 		self.hunger = math.Approach(self.hunger, hunger, 1);
-- 	end;
	
-- 	if (!self.thirst) then
-- 		self.thirst = thirst;
-- 	else
-- 		self.thirst = math.Approach(self.thirst, thirst, 1);
-- 	end;
	
-- 	local text = "Unknown";
-- 	local thirstText = "Unknown";
	
-- 	if ( hunger <= 30 ) then
-- 		text = "Well Fed";
-- 	elseif( hunger <= 50 ) then
-- 		text = "Peckish";
-- 	elseif( hunger <= 70 ) then
-- 		text = "Hungry";
-- 	elseif( hunger <= 80 ) then
-- 		text = "Very Hungry";
-- 	elseif( hunger <= 100 ) then
-- 		text = "Starving";
-- 	end;
	
-- 	if ( thirst <= 30 ) then
-- 		thirstText = "Hydrated";
-- 	elseif( thirst <= 50 ) then
-- 		thirstText = "Kinda Thirsty";
-- 	elseif( thirst <= 70 ) then
-- 		thirstText = "Thirsty";
-- 	elseif( thirst <= 80 ) then
-- 		thirstText = "Very Thirsty";
-- 	elseif( thirst <= 100 ) then
-- 		thirstText = "Dehydrated";
-- 	end;
	
-- 	if (hunger > -1 or thirst > -1) then
-- 		playerInfoText:Add("Header", "[Primary Needs]");
-- 	end;
-- 	if (hunger > -1) then
-- 		playerInfoText:Add("HUNGER", "Hunger Level: "..text);
-- 	end;
-- 	if (thirst > -1) then
-- 		playerInfoText:Add("THIRST", "Thirst Level: "..thirstText);
-- 	end;
-- 	if (hunger > -1 or thirst > -1) then
-- 		playerInfoText:Add("Header2", " ");
-- 	end;
-- 	if (hunger > -1 and thirst > -1) then
-- 		playerInfoText:Add("Header3", "[Other]");
-- 	end;
-- end;