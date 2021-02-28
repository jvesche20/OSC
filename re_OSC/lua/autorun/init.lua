re_OSC = re_OSC or {}
re_OSC.pfx = "re_OSC"
function re_OSC:Print(str)
	if SERVER or CLIENT then
		if type(str) != "table" then
			MsgN("["..re_OSC.pfx.."] "..tostring(str))
		else
			for k,v in ipairs(str) do
				MsgN("["..re_OSC.pfx.."] "..tostring(k).."\t"..tostring(v))
			end
		end
	end
end
function re_OSC:Includes(re_FolderName,re_LoadType,re_Name)
	local fldr = "re_osc/"
	fldr = fldr..re_FolderName
	local re_load = file.Find(fldr.."/*.lua","LUA")
	if SERVER then
		if re_LoadType == "sv" then
			for k,v in ipairs(re_load) do
				re_OSC:Print(re_Name.." Serverside File: "..v)
				include(fldr.."/"..v)
			end		
		elseif re_LoadType == "sh" then
			for k,v in ipairs(re_load) do
				re_OSC:Print(re_Name.." Shared File: "..v)
	
				include(fldr.."/"..v)
				AddCSLuaFile(fldr.."/"..v)
			end
		elseif re_LoadType == "cl" then	
			for k,v in ipairs(re_load) do
				re_OSC:Print(re_Name.." Clientside File: "..v)		
				AddCSLuaFile(fldr.."/"..v)
			end
		end
	elseif CLIENT then
		if re_LoadType == "sh" then	
			for k,v in ipairs(re_load) do
				re_OSC:Print(re_Name.." Shared File: "..v)
				include(fldr.."/"..v)
			end
		elseif re_LoadType == "cl" then
			for k,v in ipairs(re_load) do
				re_OSC:Print(re_Name.." Clientside File: "..v)
				include(fldr.."/"..v)
			end
		end
	end
end
local function includeall()
re_OSC:Includes("dnr","sh","Setting up")
re_OSC:Includes("sh","sh","Creating")
re_OSC:Includes("sv","sv","Creating")
re_OSC:Includes("categories","sh","Adding")
re_OSC:Includes("data","sv","Hacking")
re_OSC:Includes("sv_commands","sv","Making")
re_OSC:Includes("vgui","cl","Building")
re_OSC:Includes("hooks","sv","Hooking")
hook.Remove("Think","theulxishacked")
end
hook.Add("Think","theulxishacked",function()
	if ulx then
		includeall()
	end
end)