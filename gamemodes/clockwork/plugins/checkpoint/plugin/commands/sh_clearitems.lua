
-----------------------------------------------------

local COMMAND = Clockwork.command:New("ClearItems");
COMMAND.tip = "Clears all items and cashes.";
COMMAND.text = "<none>";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	for _, v in pairs(ents.FindByClass("cw_item")) do
		v:Remove()
	end
	
	for _, v in pairs(ents.FindByClass("cw_cash")) do
		v:Remove()
	end
	
	player:CPNotify("You have removed all items and cashes.", "bin");
end;

COMMAND:Register();