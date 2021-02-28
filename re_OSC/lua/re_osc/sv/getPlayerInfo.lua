--makeheading

function re_OSC:getPlayerInfo(ply)
	local SteamName = ""
	local Name = ""
	local SteamID = ""
	local IPAddress = ""
	if IsValid(ply) and ply then
		if ply:IsPlayer() then
			SteamName = ply.SteamName and ply:SteamName() or "ERROR_S_NAME"
			Name      = ply.Name and ply:Name() or "ERROR_NAME"
			SteamID   = ply.SteamID and ply:SteamID() or "ERROR_STEAMID"
			IPAddress = ply.IPAddress and ply:IPAddress() or "ERROR_IP"
			
			return SteamName,Name,SteamID,IPAddress
		end
		
		if ply:GetClass() == "prop_physics" and ply.CPPIGetOwner then
			ply = ply:CPPIGetOwner()
			
			SteamName = ply.SteamName and ply:SteamName() or "ERROR_S_NAME"
			Name      = ply.Name and ply:Name() or "ERROR_NAME"
			SteamID   = ply.SteamID and ply:SteamID() or "ERROR_STEAMID"
			IPAddress = ply.IPAddress and ply:IPAddress() or "ERROR_IP"
			
			return SteamName,Name,SteamID,IPAddress
		else
			SteamName = ply.GetClass and ply:GetClass() or "ERROR_NOENT"
			Name      = ply.GetPrintName and ply:GetPrintName() or "<something>"
			SteamID   = ""
			IPAddress = ""
			return SteamName,Name,SteamID,IPAddress
		end	
	end

	return SteamName,Name,SteamID,IPAddress
		  
end


