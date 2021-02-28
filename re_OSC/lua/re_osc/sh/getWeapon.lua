--make heading

function re_OSC:getWeapon(wep)
	if !wep then return end
	
	local wepName = wep:GetClass() or "<something>"
	
	if wep:IsPlayer() then
		wepName = IsValid(wep:GetActiveWeapon()) and wep:GetActiveWeapon():GetClass() or wep.dying_wep or "<something>/"..wep:Name()
	end
	
	if !wepName then 
		wepName="<something>/"..tostring(wep)
		return wepName
	end
	
	return wepName
end
