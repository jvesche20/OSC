local function FindPlayerByName( name )
	local retval = nil
	for i,v in pairs( Player.GetAll() ) do
		if v.Nick() == name then retval = v end
	end
	return retval
end

local function FindJobByName( name )
	local retval = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.lower( v.name ) == string.lower( name ) then retval = {i, v} end
	end
	return retval
end

local CATEGORY_NAME = "Extra commands"


// !setjob
function ulx.setJob( calling_ply, target_ply, job )
	local newnum = nil
    local newjob = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.find( string.lower( v.name ), string.lower( job ) ) != nil then 
			newnum = i
			newjob = v
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return 
	end
	target_ply:updateJob(newjob.name)
	target_ply:setSelfDarkRPVar("salary", newjob.salary)
	target_ply:SetTeam( newnum )
	GAMEMODE:PlayerSetModel( target_ply )
	GAMEMODE:PlayerLoadout( target_ply )
	ulx.fancyLogAdmin( calling_ply, "#A set #T's job to #s", target_ply, newjob.name )
end
local setJob = ulx.command( CATEGORY_NAME, "ulx setjob", ulx.setJob, "!setjob", true )
setJob:addParam{ type=ULib.cmds.PlayerArg }
setJob:addParam{ type=ULib.cmds.StringArg, hint="new job", ULib.cmds.takeRestOfLine }
setJob:defaultAccess( ULib.ACCESS_ADMIN )
setJob:help( "Sets target's Job." )
