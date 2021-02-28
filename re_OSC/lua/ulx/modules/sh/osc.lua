CATEGORY_NAME = "On Screen Console"

function ulx.osc( calling_ply, target_ply )

	target_ply:ConCommand( "onscreenlogs" )
	ulx.fancyLogAdmin( calling_ply, "#A Enabled/Disabled On Screen Console for #T.", target_ply )
	
end
local osc = ulx.command( CATEGORY_NAME, "ulx osc", ulx.osc, "!osc" )
osc:addParam{ type=ULib.cmds.PlayerArg }
osc:defaultAccess( ULib.ACCESS_ADMIN )
osc:help( "Enables On Screen Console." )