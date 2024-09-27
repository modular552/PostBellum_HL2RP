local PLUGIN = PLUGIN;

function PLUGIN:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("hunger", true);
	playerVars:Number("thirst", true);
end;