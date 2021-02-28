hook.Add("onPlayerChangedName",re_OSC.pfx.."Name",
	function(ply,oldname,newname)
		local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(ply)
		local tolog = { time=os.time(), steam_name=SteamName, steam_id=SteamID, oldname=oldname, newname=newname, ip_address=IPAddress}
		re_OSC:recordLog('Name',tolog)
	end
)
hook.Add("OnPlayerChangedTeam", re_OSC.pfx.."Job", 
	function(ply, oldteam, newteam) 
		local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(ply)		
		local tolog = {time=os.time(),steam_name=SteamName,name=Name,steam_id=SteamID,oldjob=team.GetName(oldteam),newjob=team.GetName(newteam),ip_address=IPAddress}
		re_OSC:recordLog('Job',tolog)
	end
)
hook.Add("playerArrested",re_OSC.pfx.."Arrest",
	function(t,time,officer)
		if !t then return end
		if !IsValid(t) then return end
		if !t:IsPlayer() then return end
		local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(t)	
		local oSteamName,oName,oSteamID,oIPAddress = re_OSC:getPlayerInfo(officer)
		local arrest_time = tostring(time)	
		local actwep = t:GetWeapons()
		for k,v in pairs(actwep) do
			local d = re_OSC:getWeapon(v)
			if d == re_OSC:getWeapon(t:GetActiveWeapon()) then
				d =	"[ACTIVE] "..d
			end
			actwep[k] = d
		end
		local tolog = {time=os.time(),steam_name=SteamName,name=Name,steam_id=SteamID,ip_address=IPAddress,steam_name_officer=oSteamName,name_officer=oName,steam_id_officer=oSteamID,ip_address_officer=oIPAddress,arrest_time=arrest_time,method="Arrested",wep=actwep}
		re_OSC:recordLog('Arrest',tolog)
	end
)
hook.Add("PlayerDeath", re_OSC.pfx.."Death", 
	function(v, inflictor, killer)
		local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(v)	
		local kSteamName,kName,kSteamID,kIPAddress = re_OSC:getPlayerInfo(killer)
		local weaponClass = re_OSC:getWeapon(inflictor)
		local tolog = {time=os.time(),steam_name=SteamName,name=Name,steam_id=SteamID,ip_address=IPAddress,steam_name_killer=kSteamName,name_killer=kName,steam_id_killer=kSteamID,ip_address_killer=kIPAddress,weapon=weaponClass,role=team.GetName(v:Team()),role_killer = ( (killer.Team == nil) and "[Unknown]" or team.GetName( killer:Team() ) )}
		re_OSC:recordLog('Kills',tolog)
	end
)
hook.Add("PlayerDisconnected", re_OSC.pfx.."Disconnect", 
	function(ply) 
		local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(ply)	
		local tolog = {time=os.time(),steam_name=SteamName,name=Name,steam_id=SteamID,ip_address=IPAddress,method="Disconnected"}
		re_OSC:recordLog('Connect',tolog)
	end
)
hook.Add("PlayerInitialSpawn", re_OSC.pfx.."Connect", 
	function(ply) 
		timer.Simple(3,function()
			local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(ply)	
			local tolog = {time=os.time(),steam_name=SteamName,name=Name,steam_id=SteamID,ip_address=IPAddress,method="Connected"}
			re_OSC:recordLog('Connect',tolog)
		end)
	end
)
local hookstr = "playerWarranted" 
hook.Add(hookstr,re_OSC.pfx.."Warrant", 
	function(target,officer,reason)
		local ourtarget = target
		local ourofficer = officer
		local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(ourtarget)	
		local oSteamName,oName,oSteamID,oIPAddress = re_OSC:getPlayerInfo(ourofficer)
		local warrant_reason = tostring(reason)
		local tolog = {time=os.time(),steam_name=SteamName,name=Name,steam_id=SteamID,ip_address=IPAddress,steam_name_officer=oSteamName,name_officer=oName,steam_id_officer=oSteamID,ip_address_officer=oIPAddress,reason=warrant_reason,method="Warranted"}
		re_OSC:recordLog('Warrant',tolog)
	end
)
local hookstr = "playerWanted" 
hook.Add(hookstr,re_OSC.pfx.."Wanted", 
	function(target,officer,reason)
		local ourtarget = target
		local ourofficer = officer
		local SteamName,Name,SteamID,IPAddress = re_OSC:getPlayerInfo(ourtarget)	
		local oSteamName,oName,oSteamID,oIPAddress = re_OSC:getPlayerInfo(ourofficer)
		local wanted_reason = tostring(reason)
		local tolog = {time=os.time(),steam_name=SteamName,name=Name,steam_id=SteamID,ip_address=IPAddress,steam_name_officer=oSteamName,name_officer=oName,steam_id_officer=oSteamID,ip_address_officer=oIPAddress,reason=wanted_reason,method="Wanted"}
		re_OSC:recordLog('Wanted',tolog)
	end
)