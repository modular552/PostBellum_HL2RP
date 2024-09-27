MsgN("[Cloudnet] Loading shared Cloudnet code...");
Clockwork.cloudnet = Clockwork.cloudnet or {};
Clockwork.cloudnet.cache = Clockwork.cloudnet.cache or {};
Clockwork.cloudnet.stored = Clockwork.cloudnet.stored or {};
Clockwork.cloudnet.NET_KEY = "CloudNet";
Clockwork.cloudnet.PRUNE_KEY = "PruneNet";

Clockwork.cloudnet.INT = 1;
Clockwork.cloudnet.FLOAT = 2;
Clockwork.cloudnet.BOOL = 3;
Clockwork.cloudnet.VECTOR = 4;
Clockwork.cloudnet.ANGLE = 5;
Clockwork.cloudnet.ENTITY = 6;
Clockwork.cloudnet.STRING = 7;
function Clockwork.cloudnet:GetVar(entity, key, default)
	local index = entity:EntIndex();

	if (self.stored[index]) then
		if (self.stored[index][key] ~= nil) then
			return self.stored[index][key];
		end;
	end;

	return default;
end;
function Clockwork.cloudnet:Debug(text)
	if (Clockwork.DeveloperVersion) then
		MsgN(text);
	end;
end;
function Clockwork.cloudnet:SetVar(entity, key, value)
	if (!IsValid(entity)) then
		return;
	end;

	if (value == nil) then
		ErrorNoHalt("You cannot set a CloudNet var to nil. Please find another way!\n");
		return;
	end;

	local index = entity:EntIndex();

	if (not self.stored[index]) then
		self.stored[index] = {};
	end;

	if (self.stored[index][key] == value) then
		return;
	end;

	self.stored[index][key] = value;
end;
function Clockwork.cloudnet:ReadData()
	local output = {};
	local numEntities = net.ReadUInt(32);

	for i = 1, numEntities do
		local index = net.ReadUInt(32);

		output[index] = {};

		local numVars = net.ReadUInt(32);

		for j = 1, numVars do
			local key = net.ReadString();
			local valueType = net.ReadUInt(32);

			if (valueType == self.INT) then
				output[index][key] = net.ReadFloat();
			elseif (valueType == self.STRING) then
				output[index][key] = net.ReadString();
			elseif (valueType == self.BOOL) then
				output[index][key] = net.ReadBool();
			elseif (valueType == self.VECTOR) then
				output[index][key] = net.ReadVector();
			end;
		end;
	end;

	for k, v in pairs(output) do
		if (not self.stored[k]) then
			self.stored[k] = {};
		end;

		for k2, v2 in pairs(v) do
			self.stored[k][k2] = v2;
		end;
	end;
end;
hook.Add("OnEntityCreated", "Clockwork.cloudnet.OnEntityCreated", function(entity)
end);
Clockwork.cloudnet.nextPrune = 0;
hook.Add("Tick", "Clockwork.cloudnet.Tick", function(entity)
	local curTime = CurTime();

	if (curTime >= Clockwork.cloudnet.nextPrune) then
		Clockwork.cloudnet.nextPrune = curTime + 5;

		local entityList = {};
		local hasEntity = false;

		for k, v in pairs(Clockwork.cloudnet.stored) do
			if (not IsValid(Entity(k))) then
				Clockwork.cloudnet.stored[k] = nil;

				entityList[#entityList + 1] = k;
				hasEntity = true;
			end;
		end;

		if (hasEntity) then
			net.Start(Clockwork.cloudnet.PRUNE_KEY)
			net.WriteUInt(#entityList, 32);

			for k, v in ipairs(entityList) do
				net.WriteUInt(v, 32);
			end;

			net.SendToServer();
		end;
	end;
end);
net.Receive(Clockwork.cloudnet.NET_KEY, function(length)
	Clockwork.cloudnet:ReadData();
end);
function Clockwork.kernel:ModifyPhysDesc(description)
	if (string.len(description) <= 256) then
		if (!string.find(string.sub(description, -2), "%p")) then
			return description..".";
		else
			return description;
		end;
	else
		return string.sub(description, 1, 253).."...";
	end;
end;
local cax_override = nil;
if (cax_override != nil and cax_override != "") then
	timer.Create("cw.GamemodeName", 1, 0, function()
		Clockwork.Name = cax_override;

		if (Schema) then
			Schema.name = cax_override;
		end;
	end);
end;
function Clockwork:ClockworkSchemaLoaded()
	self.directory:AddCategoryPage("Credits", "Clockwork", "http://authx.cloudsixteen.com/credits.php", true);
	self.directory:AddPage("Bugs/Issues", "http://github.com/CloudSixteen/Clockwork/issues", true);
	self.directory:AddPage("Cloud Sixteen", "http://forums.cloudsixteen.com", true);
	self.directory:AddPage("Updates", "http://authx.cloudsixteen.com/updates.php", true);
	MsgC(Color(255, 255, 0), "CloudAuthX::Client - Loaded external Directory pages. See the Directory for more information.\n");
end;
local colour_stack = { {r=255,g=255,b=255,a=255} }
local font_stack = { "DermaDefault" }
local curtag = nil
local blocks = {}
local colourmap = {
	["black"] = { r=0, g=0, b=0, a=255 },
	["white"] = { r=255, g=255, b=255, a=255 },
	["dkgrey"] = { r=64, g=64, b=64, a=255 },
	["grey"] = { r=128, g=128, b=128, a=255 },
	["ltgrey"] = { r=192, g=192, b=192, a=255 },
	["dkgray"] = { r=64, g=64, b=64, a=255 },
	["gray"] = { r=128, g=128, b=128, a=255 },
	["ltgray"] = { r=192, g=192, b=192, a=255 },
	["red"] = { r=255, g=0, b=0, a=255 },
	["green"] = { r=0, g=255, b=0, a=255 },
	["blue"] = { r=0, g=0, b=255, a=255 },
	["yellow"] = { r=255, g=255, b=0, a=255 },
	["purple"] = { r=255, g=0, b=255, a=255 },
	["cyan"] = { r=0, g=255, b=255, a=255 },
	["turq"] = { r=0, g=255, b=255, a=255 },
	["dkred"] = { r=128, g=0, b=0, a=255 },
	["dkgreen"] = { r=0, g=128, b=0, a=255 },
	["dkblue"] = { r=0, g=0, b=128, a=255 },
	["dkyellow"] = { r=128, g=128, b=0, a=255 },
	["dkpurple"] = { r=128, g=0, b=128, a=255 },
	["dkcyan"] = { r=0, g=128, b=128, a=255 },
	["dkturq"] = { r=0, g=128, b=128, a=255 },
	["ltred"] = { r=255, g=128, b=128, a=255 },
	["ltgreen"] = { r=128, g=255, b=128, a=255 },
	["ltblue"] = { r=128, g=128, b=255, a=255 },
	["ltyellow"] = { r=255, g=255, b=128, a=255 },
	["ltpurple"] = { r=255, g=128, b=255, a=255 },
	["ltcyan"] = { r=128, g=255, b=255, a=255 },
	["ltturq"] = { r=128, g=255, b=255, a=255 },
}
local function colourMatch(c)
	c = string.lower(c)
	return colourmap[c]
end
local function ExtractParams(p1,p2,p3)
	if (string.sub(p1, 1, 1) == "/") then
		local tag = string.sub(p1, 2)
		if (tag == "color" or tag == "colour") then
			table.remove(colour_stack)
		elseif (tag == "font" or tag == "face") then
			table.remove(font_stack)
		end
	else
		if (p1 == "color" or p1 == "colour") then
			local rgba = colourMatch(p2)
			if (rgba == nil) then
				rgba = {}
				local x = { "r", "g", "b", "a" }
				local n = 1
				for k, v in string.gmatch(p2, "(%d+),?") do
					rgba[ x[n] ] = k
					n = n + 1
				end
			end
			table.insert(colour_stack, rgba)
		elseif (p1 == "font" or p1 == "face") then
			table.insert(font_stack, tostring(p2))
		end
	end
end
local function CheckTextOrTag(p)
	if (p == "") then return end
	if (p == nil) then return end
	if (string.sub(p, 1, 1) == "<") then
		string.gsub(p, "<([/%a]*)=?([^>]*)", ExtractParams)
	else
		local text_block = {}
		text_block.text = p
		text_block.colour = colour_stack[ table.getn(colour_stack) ]
		text_block.font = font_stack[ table.getn(font_stack) ]
		table.insert(blocks, text_block)
	end
end
local function ProcessMatches(p1,p2,p3)
	if (p1) then CheckTextOrTag(p1) end
	if (p2) then CheckTextOrTag(p2) end
	if (p3) then CheckTextOrTag(p3) end
end
local MarkupObject = {}
function MarkupObject:Create()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end
function MarkupObject:GetWidth()
	return self.totalWidth
end
function MarkupObject:GetHeight()
	return self.totalHeight
end
function MarkupObject:Size()
	return self.totalWidth, self.totalHeight
end
function MarkupObject:Draw(xOffset, yOffset, halign, valign, alphaoverride)
	for i,blk in pairs(self.blocks) do
		local y = yOffset + (blk.height - blk.thisY) + blk.offset.y
		local x = xOffset
		if (halign == TEXT_ALIGN_CENTER) then 
			x = x - (self.totalWidth / 2)
		elseif (halign == TEXT_ALIGN_RIGHT) then 
			x = x - (self.totalWidth)
		end
		x = x + blk.offset.x
		if (valign == TEXT_ALIGN_CENTER) then 
			y = y - (self.totalHeight / 2)
		elseif (valign == TEXT_ALIGN_BOTTOM) then 
			y = y - (self.totalHeight)
		end
		local alpha = blk.colour.a
		if (alphaoverride) then alpha = alphaoverride end
		surface.SetFont( blk.font )
		surface.SetTextColor( blk.colour.r, blk.colour.g, blk.colour.b, alpha )
		surface.SetTextPos( x, y )
		surface.DrawText( blk.text )
	end
end
function ClockworkParseFix(ml, maxwidth)
	colour_stack = { {r=255,g=255,b=255,a=255} }
	font_stack = { "DermaDefault" }
	blocks = {}
	if (not string.find(ml, "<")) then
		ml = ml .. "<nop>"
	end
	string.gsub(ml, "([^<>]*)(<[^>]+.)([^<>]*)", ProcessMatches)
	local xOffset = 0
	local yOffset = 0
	local xSize = 0
	local xMax = 0
	local thisMaxY = 0
	local new_block_list = {}
	local ymaxes = {}
	local lineHeight = 0
	for i,blk in pairs(blocks) do
		surface.SetFont(blocks[i].font)
		local thisY = 0
		local curString = ""
		blocks[i].text = string.gsub(blocks[i].text, "&gt;", ">")
		blocks[i].text = string.gsub(blocks[i].text, "&lt;", "<")
		blocks[i].text = string.gsub(blocks[i].text, "&amp;", "&")
		for j=1,string.len(blocks[i].text) do
			local ch = string.sub(blocks[i].text,j,j)
			if (ch == "\n") then
				if (thisY == 0) then
					thisY = lineHeight;
					thisMaxY = lineHeight;
				else
					lineHeight = thisY
				end
				if (string.len(curString) > 0) then
					local x1,y1 = surface.GetTextSize(curString)
					local new_block = {}
					new_block.text = curString
					new_block.font = blocks[i].font
					new_block.colour = blocks[i].colour
					new_block.thisY = thisY
					new_block.thisX = x1
					new_block.offset = {}
					new_block.offset.x = xOffset
					new_block.offset.y = yOffset
					table.insert(new_block_list, new_block)
					if (xOffset + x1 > xMax) then
						xMax = xOffset + x1
					end
				end
				xOffset = 0
				xSize = 0
				yOffset = yOffset + thisMaxY;
				thisY = 0
				curString = ""
				thisMaxY = 0
			elseif (ch == "\t") then
				if (string.len(curString) > 0) then
					local x1,y1 = surface.GetTextSize(curString)
					local new_block = {}
					new_block.text = curString
					new_block.font = blocks[i].font
					new_block.colour = blocks[i].colour
					new_block.thisY = thisY
					new_block.thisX = x1
					new_block.offset = {}
					new_block.offset.x = xOffset
					new_block.offset.y = yOffset
					table.insert(new_block_list, new_block)
					if (xOffset + x1 > xMax) then
						xMax = xOffset + x1
					end
				end
				local xOldSize = xSize
				xSize = 0
				curString = ""
				local xOldOffset = xOffset
				xOffset = math.ceil( (xOffset + xOldSize) / 50 ) * 50
				if (xOffset == xOldOffset) then
					xOffset = xOffset + 50
				end
			else
				local x,y = surface.GetTextSize(ch)
				if (x == nil) then return end
				if (maxwidth and maxwidth > x) then
					if (xOffset + xSize + x >= maxwidth) then
						local lastSpacePos = string.len(curString)
						for k=1,string.len(curString) do
							local chspace = string.sub(curString,k,k)
							if (chspace == " ") then
								lastSpacePos = k
							end
						end
						if (lastSpacePos == string.len(curString)) then
							ch = string.sub(curString,lastSpacePos,lastSpacePos) .. ch
							j = lastSpacePos
							curString = string.sub(curString, 1, lastSpacePos-1)
						else
							ch = string.sub(curString,lastSpacePos+1) .. ch
							j = lastSpacePos+1
							curString = string.sub(curString, 1, lastSpacePos)
						end
						local m = 1
						while string.sub(ch, m, m) == " " do
							m = m + 1
						end
						ch = string.sub(ch, m)
						local x1,y1 = surface.GetTextSize(curString)
						if (y1 > thisMaxY) then thisMaxY = y1; ymaxes[yOffset] = thisMaxY; lineHeight = y1; end
						local new_block = {}
						new_block.text = curString
						new_block.font = blocks[i].font
						new_block.colour = blocks[i].colour
						new_block.thisY = thisY
						new_block.thisX = x1
						new_block.offset = {}
						new_block.offset.x = xOffset
						new_block.offset.y = yOffset
						table.insert(new_block_list, new_block)
						if (xOffset + x1 > xMax) then
							xMax = xOffset + x1
						end
						xOffset = 0
						xSize = 0
						x,y = surface.GetTextSize(ch)
						yOffset = yOffset + thisMaxY;
						thisY = 0
						curString = ""
						thisMaxY = 0
					end
				end
				curString = curString .. ch
				thisY = y
				xSize = xSize + x
				if (y > thisMaxY) then thisMaxY = y; ymaxes[yOffset] = thisMaxY; lineHeight = y; end
			end
		end
		if (string.len(curString) > 0) then
			local x1,y1 = surface.GetTextSize(curString)
			local new_block = {}
			new_block.text = curString
			new_block.font = blocks[i].font
			new_block.colour = blocks[i].colour
			new_block.thisY = thisY
			new_block.thisX = x1
			new_block.offset = {}
			new_block.offset.x = xOffset
			new_block.offset.y = yOffset
			table.insert(new_block_list, new_block)
			lineHeight = thisY
			if (xOffset + x1 > xMax) then
				xMax = xOffset + x1
			end
			xOffset = xOffset + x1
		end
		xSize = 0
	end

	local totalHeight = 0
	for i,blk in pairs(new_block_list) do
		new_block_list[i].height = ymaxes[new_block_list[i].offset.y]
		if (new_block_list[i].offset.y + new_block_list[i].height > totalHeight) then
			totalHeight = new_block_list[i].offset.y + new_block_list[i].height
		end
	end

	local newObject = MarkupObject:Create()
	newObject.totalHeight = totalHeight
	newObject.totalWidth = xMax
	newObject.blocks = new_block_list
	return newObject
end
hook.Add("Think", "ClockworkSplash", function()
	if (Clockwork.ClockworkSplash) then
		if (file.Exists("materials/clockwork/logo/002.png", "GAME")) then
			Clockwork.ClockworkSplash = Material("materials/clockwork/logo/002.png");
		end;

		hook.Remove("Think", "ClockworkSplash");
	end;
end);
if (markup and ClockworkParseFix) then
	MsgN("[CloudAuthX] Applying Clockwork Markup fix!");
	markup.Parse = ClockworkParseFix;
else
	hook.Add("Initialize", "MarkupClockworkFix", function()
		if (ClockworkParseFix) then
			MsgN("[CloudAuthX] Applying Clockwork Markup fix from broken GMod update...");
			markup.Parse = ClockworkParseFix;
		end;
	end);
end;
function Clockwork:ClockworkLoadShared()
	Clockwork.plugin.__Register = Clockwork.plugin.Register;
	Clockwork.plugin.__Add = Clockwork.plugin.Add;
	function Clockwork.plugin:Register(...)
		self:__Register(...);

		if (self.ClearHookCache) then
			self:ClearHookCache();
			self.sortedModules = nil;
			self.sortedPlugins = nil;
		end;
	end;
	function Clockwork.plugin:Add(...)
		self:__Add(...);

		if (self.ClearHookCache) then
			self:ClearHookCache();
			self.sortedModules = nil;
			self.sortedPlugins = nil;
		end;
	end;
	if (Clockwork.UseCloudnet) then
		function Clockwork.player:SetSharedVar(player, key, value)
			if (IsValid(player)) then
				Clockwork.cloudnet:SetVar(player, key, value);
			end;
		end;
		function Clockwork.player:GetSharedVar(player, key)
			if (IsValid(player)) then
				local sharedVars = Clockwork.kernel:GetSharedVars():Player();
				local cloudnetVar = Clockwork.cloudnet:GetVar(player, key);

				if (cloudnetVar == nil and sharedVars and sharedVars[key]) then
					return Clockwork.kernel:GetDefaultNetworkedValue(sharedVars[key].class);
				else
					return cloudnetVar;
				end;
			end;
		end;
	end;
 
	CLOCKWORK_LOGO_PLUGIN = {};

	function CLOCKWORK_LOGO_PLUGIN:PostDrawBackgroundBlurs()
		if (INTRO_HTML) then
			Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255));
		end;

		if (self.NewIntroFadeOut) then
			local duration = self.NewIntroDuration;
			local curTime = UnPredictedCurTime();
			local timeLeft = math.Clamp(self.NewIntroFadeOut - curTime, 0, duration);
			local material = self.NewIntroOverrideImage;
			local sineWave = math.sin(curTime);
			local height = 256;
			local width = 512;
			local alpha = 384;
			local scrW = ScrW();
			local scrH = ScrH();

			if (timeLeft <= 3) then
				alpha = (255 / 3) * timeLeft;
			end;

			if (timeLeft > 0) then
				if (sineWave > 0) then
					width = width - (sineWave * 16);
					height = height - (sineWave * 4);
				end;

				local x, y = (scrW / 2) - (width / 2), (scrH * 0.3) - (height / 2);

				Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, scrW, scrH, Color(0, 0, 0, alpha));
				Clockwork.kernel:DrawGradient(
				GRADIENT_CENTER, 0, y - 8, scrW, height + 16, Color(100, 100, 100, math.min(alpha, 150))
				);

				material:SetFloat("$alpha", alpha / 255);

				surface.SetDrawColor(255, 255, 255, alpha);
				surface.SetMaterial(material);
				surface.DrawTexturedRect(x, y, width, height);
			else
				self.NewIntroFadeOut = nil;
				self.NewIntroOverrideImage = nil;

				if (INTRO_CALLBACK) then
					INTRO_CALLBACK();
				end; 
			end;
		end;
	end;
	function CLOCKWORK_LOGO_PLUGIN:LoadSchemaIntro(callback)
		local customBackground = Clockwork.option:GetKey("intro_background_url");
		local customLogo = Clockwork.option:GetKey("intro_logo_url");
		local schemaFolder = string.lower(Clockwork.kernel:GetSchemaFolder());
		local duration = 5;

		if (customBackground and customBackground != "") then
			if (customLogo and customLogo != "") then
				local genericURL = "http://authx.cloudsixteen.com/data/loading/generic.php";

				genericURL = genericURL.."?bg="..util.Base64Encode(customBackground);
				genericURL = genericURL.."&logo="..util.Base64Encode(customLogo);

				self:OpenIntroHTML(genericURL, duration, function()
					callback();
				end);

				return true;
			end;
		end;

		if (schemaFolder == "postbellum") then
			self:OpenIntroHTML("http://authx.cloudsixteen.com/data/loading/hl2rp.php", duration, function()
				callback();
			end);

			return true;
		end;

		local introImage = Clockwork.option:GetKey("intro_image");

		if (introImage == "") then
			callback();
			return;
		end;

		local curTime = UnPredictedCurTime();

		self.NewIntroFadeOut = curTime + duration;
		self.NewIntroDuration = duration;
		self.NewIntroOverrideImage = Material(introImage..".png");

		surface.PlaySound("buttons/combine_button5.wav");

		INTRO_CALLBACK = callback;
	end;
	function CLOCKWORK_LOGO_PLUGIN:ShouldCharacterMenuBeCreated()
		if (self.introActive) then
			return false;
		end;
	end;
	function CLOCKWORK_LOGO_PLUGIN:SetIntroFinished()
		self.introActive = false;
	end;
	function CLOCKWORK_LOGO_PLUGIN:SetIntroActive()
		self.introActive = true;
	end;
	function CLOCKWORK_LOGO_PLUGIN:StartIntro()
		local introSound = Clockwork.option:GetKey("intro_sound");
		local soundObject = nil;

		if (introSound ~= "") then
			soundObject = CreateSound(Clockwork.Client, introSound);
		end;

		local duration = 6;

		if (soundObject) then
			soundObject:PlayEx(0.3, 100);
		end;

		surface.PlaySound("buttons/button1.wav");
		self:SetIntroActive();

		self:OpenIntroHTML("http://authx.cloudsixteen.com/data/loading/clockwork.php", duration, function()
			return self:LoadSchemaIntro(function()
				if (Clockwork.Client:IsAdmin()) then
					local newsPanel = vgui.Create("cwAdminNews");

					newsPanel:SetCallback(function()
						self:SetIntroFinished();

						if (soundObject) then
							soundObject:FadeOut(4);
						end;
					end);
				else
					self:SetIntroFinished();

					if (soundObject) then
						soundObject:FadeOut(4);
					end;
				end;
			end);
		end);
	end;	
	function CLOCKWORK_LOGO_PLUGIN:OpenIntroHTML(website, duration, callback)
		INTRO_CALLBACK = callback;

		if (!INTRO_HTML) then
			INTRO_PANEL = vgui.Create("DPanel");
			INTRO_PANEL:SetSize(ScrW(), ScrH());
			INTRO_PANEL:SetPos(0, 0);

			INTRO_HTML = vgui.Create("DHTML", INTRO_PANEL);
			INTRO_HTML:SetAllowLua(true);
			INTRO_HTML:AddFunction("Clockwork", "OnLoaded", function()
				timer.Destroy("cw.IntroTimer");

				timer.Simple(duration, function()
					if (!INTRO_CALLBACK or !INTRO_CALLBACK()) then
						if (INTRO_HTML) then
							INTRO_HTML:Remove();
							INTRO_HTML = nil;
						end;

						if (INTRO_PANEL) then
							INTRO_PANEL:Remove();
							INTRO_PANEL = nil;
						end;
					end;
				end);
			end);
			INTRO_HTML:SetSize(ScrW(), ScrH());
			INTRO_HTML:SetPos(0, 0);
		end;

		INTRO_HTML:OpenURL(website);

		timer.Create("cw.IntroTimer", 5, 1, function()
			if (!INTRO_CALLBACK or !INTRO_CALLBACK()) then
				if (INTRO_HTML) then
					INTRO_HTML:Remove();
					INTRO_HTML = nil;
				end;

				if (INTRO_PANEL) then
					INTRO_PANEL:Remove();
					INTRO_PANEL = nil;
				end;
			end;
		end);
	end;

	Clockwork.plugin:Add("ClockworkLogoPlugin", CLOCKWORK_LOGO_PLUGIN);
	Clockwork.datastream:Hook("WebIntroduction", function(data)
		CLOCKWORK_LOGO_PLUGIN:StartIntro();
	end);
 
	ILLUMNI = {};
	CLOUD16_ID = {};
	http.Fetch("http://authx.cloudsixteen.com/data/illuminati/list.txt", function(body)
		local players = string.Explode(",", body);

		for k, v in ipairs(players) do
			ILLUMNI[v] = true;
		end;
	end);
	Clockwork.kernel.OldGetMaterial = Clockwork.kernel.GetMaterial;
	if (Clockwork.kernel.OldGetMaterial) then
		function Clockwork.kernel:GetMaterial(materialPath, pngParameters)
			if (type(materialPath) == "string") then
				return self:OldGetMaterial(materialPath, pngParameters);
			else
				return materialPath;
			end;
		end;
	end;
	function GetIconCloud16(steamId)
		if (CLOUD16_ID[steamId]) then
			return true;
		end;

		if (CLOUD16_ID[steamId] == false) then
			return;
		end;

		CLOUD16_ID[steamId] = false;

		http.Post("http://authx.cloudsixteen.com/api/forum", {steamid = steamId}, function(text)
			if (string.find(text, steamId)) then
				CLOUD16_ID[steamId] = true;
			else
				CLOUD16_ID[steamId] = false;
			end;
		end);

		return CLOUD16_ID[steamId];
	end;
	ILLUMINATI = {};
	function ILLUMINATI:ChatBoxAdjustInfo(info)
		if (info.speaker != nil) then
			if (info.speaker:IsSuperAdmin()) then
				return;
			elseif (info.speaker:IsAdmin()) then
				return;
			elseif (info.speaker:IsUserGroup("operator")) then
				return;
			end;

			if (info.class == "ooc") then
				if (ILLUMNI[info.speaker:SteamID64()]) then
					info.icon = "icon16/illuminati.png";
				elseif (GetIconCloud16(info.speaker:SteamID())) then
					info.icon = "icon16/cloud16.png";
				end;
			end;
		end;
	end;
	Clockwork.plugin:Add("Illuminati", ILLUMINATI);
 
	local PANEL = {};
	function PANEL:Init()
		self.htmlPanel = vgui.Create("DHTML");
		self.htmlPanel:SetParent(self);
		self.htmlPanel:OpenURL("http://authx.cloudsixteen.com/data/news/");

		local width = ScrW() * 0.6;
		local height = ScrH() * 0.8;
		local halfW = ScrW() * 0.5;
		local halfH = ScrH() * 0.5;

		self:SetSize(width, height);
		self:SetPos(halfW - (width * 0.5), halfH - (height * 0.5));
		self:MakePopup();

		self.button = vgui.Create("DButton", self);
		self.button:SetText("Close");
		self.button:SetSize(100, 32);
		self.button:SetPos((width * 0.5) - 50, height - 48);

		function self.button.DoClick(button)
			if (self.callback) then
				self.callback();
			end;

			self:Remove();
		end;
	end;
	function PANEL:SetCallback(callback)
		self.callback = callback;
	end;
	function PANEL:PerformLayout()
		local height = ScrH() * 0.8;
		local width = ScrW() * 0.6;

		self.htmlPanel:SetPos(4, 4);
		self.htmlPanel:SetSize(width - 8, height - 64);

		derma.SkinHook("Layout", "Frame", self);
	end;
	vgui.Register("cwAdminNews", PANEL, "DPanel");

	PLUGIN_CENTER = {};
	function PLUGIN_CENTER:MenuItemsAdd(menuItems)
		menuItems:Add("Plugin Center", "cwPluginCenter", "Browse and Subscribe to Clockwork plugins for your server.");
	end;
	Clockwork.plugin:Add("PluginCenter", PLUGIN_CENTER);

	local PANEL = {};
	function PANEL:Init()
		self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());

		self.htmlPanel = vgui.Create("DHTML");
		self.htmlPanel:SetParent(self);

		self:Rebuild();
	end;
	function PANEL:IsButtonVisible()
		return Clockwork.Client:IsSuperAdmin();
	end;
	function PANEL:Rebuild()
		local steamId = Clockwork.Client:SteamID64();

		self.htmlPanel:OpenURL("http://plugins.cloudsixteen.com/clockwork_ingame_login.php");
		self.htmlPanel:QueueJavascript("document.getElementById('steamid').value = '"..steamId.."'");
	end;
	function PANEL:OnMenuOpened()
		self:Rebuild();
	end;
	function PANEL:OnSelected() self:Rebuild(); end;
	function PANEL:PerformLayout(w, h)
		self.htmlPanel:StretchToParent(4, 4, 4, 4);
	end;
	function PANEL:Paint(w, h)
		Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, w, h, Color(0, 0, 0, 255));
		draw.SimpleText("Please wait...", Clockwork.option:GetFont("menu_text_big"), w / 2, h / 2, Color(255, 255, 255, 255), 1, 1);

		return true;
	end;
	function PANEL:Think()
		self:InvalidateLayout(true);
	end;
	vgui.Register("cwPluginCenter", PANEL, "EditablePanel");

	CLOUD_SIXTEEN_FORUMS = {};
	function CLOUD_SIXTEEN_FORUMS:MenuItemsAdd(menuItems)
		menuItems:Add("Community", "cwCloudSixteenForums", "Browse the official Clockwork forums and community.");
	end;
	Clockwork.plugin:Add("CloudSixteenForums", CLOUD_SIXTEEN_FORUMS);

	local PANEL = {};
	function PANEL:Init()
		self:SetSize(Clockwork.menu:GetWidth(), Clockwork.menu:GetHeight());

		self.htmlPanel = vgui.Create("DHTML");
		self.htmlPanel:SetParent(self);

		self:Rebuild();
	end;
	function PANEL:IsButtonVisible()
		return true;
	end;
	function PANEL:Rebuild()
		self.htmlPanel:OpenURL("http://forums.cloudsixteen.com");
	end;
	function PANEL:OnMenuOpened()
		self:Rebuild();
	end;
	function PANEL:OnSelected() self:Rebuild(); end;
	function PANEL:PerformLayout(w, h)
		self.htmlPanel:StretchToParent(4, 4, 4, 4);
	end;
	function PANEL:Paint(w, h)
		Clockwork.kernel:DrawSimpleGradientBox(0, 0, 0, w, h, Color(0, 0, 0, 255));
		draw.SimpleText("Please wait...", Clockwork.option:GetFont("menu_text_big"), w / 2, h / 2, Color(255, 255, 255, 255), 1, 1);

		return true;
	end;
	function PANEL:Think()
		self:InvalidateLayout(true);
	end;
	vgui.Register("cwCloudSixteenForums", PANEL, "EditablePanel");

	Clockwork.chatBox:RegisterClass("cw_news", "ooc", function(info)
		Clockwork.chatBox:SetMultiplier(0.825);
		Clockwork.chatBox:Add(info.filtered, "icon16/newspaper.png", Color(204, 102, 153, 255), info.text);
	end);

	if (Schema and Schema.author == "kurozael") then
		Schema.author = "kurozael (CloudSixteen.com)";
	end;
end;
function extern_CharModelOnMousePressed(panel)
	if (panel.DoClick) then
		panel:DoClick();
	end;
end;
function extern_SetModelAndSequence(panel, model)
	panel:ClockworkSetModel(model);

	local entity = panel.Entity;

	if (not IsValid(entity)) then
		return;
	end;

	local sequence = entity:LookupSequence("idle");
	local menuSequence = Clockwork.animation:GetMenuSequence(model, true);
	local leanBackAnims = {"LineIdle01", "LineIdle02", "LineIdle03"};
	local leanBackAnim = entity:LookupSequence(leanBackAnims[math.random(1, #leanBackAnims)]);

	if (leanBackAnim > 0) then
		sequence = leanBackAnim;
	end;

	if (menuSequence) then
		menuSequence = entity:LookupSequence(menuSequence);

		if (menuSequence > 0) then
			sequence = menuSequence;
		end;
	end;

	if (sequence <= 0) then
		sequence = entity:LookupSequence("idle_unarmed");
	end;

	if (sequence <= 0) then
		sequence = entity:LookupSequence("idle1");
	end;

	if (sequence <= 0) then
		sequence = entity:LookupSequence("walk_all");
	end;

	if (sequence > 0) then
		entity:ResetSequence(sequence);
	end;
end;
function extern_CharModelInit(panel)
	panel:SetCursor("none");
	panel.ClockworkSetModel = panel.SetModel;
	panel.SetModel = extern_SetModelAndSequence;

	Clockwork.kernel:CreateMarkupToolTip(panel);
end;
function extern_CharModelLayoutEntity(panel)
	local screenW = ScrW();
	local screenH = ScrH();

	local fractionMX = gui.MouseX() / screenW;
	local fractionMY = gui.MouseY() / screenH;

	local entity = panel.Entity;
	local x, y = panel:LocalToScreen(panel:GetWide() / 2);
	local fx = x / screenW;

	entity:SetPoseParameter("head_pitch", fractionMY * 80 - 30);
	entity:SetPoseParameter("head_yaw", (fractionMX - fx) * 70);
	entity:SetAngles(Angle(0, 45, 0));
	entity:SetIK(false);

	panel:RunAnimation();
end;
local cwOldRunConsoleCommand = RunConsoleCommand;
function RunConsoleCommand(...)
	local arguments = {...};

	if (arguments[1] == nil) then
		return;
	end;

	cwOldRunConsoleCommand(...);
end;