local re_log_frame 	 = nil
local re_log_scroll 	 = nil
local re_log_html 	 = nil
local re_log_html_text = ""
local re_log_html_text_base = [[<style> .small { line-height:5px; } </style> <p class="small">]]

function getsteamid( name )
	for _, ply in pairs( player.GetAll() ) do
		if ( ply:Nick() == name ) then
			return ply:SteamID()
		end
	end
end

function opencontextmenu( name )
	local re_log_menu = DermaMenu()
		re_log_menu:AddOption( name )
			re_log_menu:AddSpacer()
			
		if re_goto then
			re_log_menu:AddOption( "Goto to Player", function() LocalPlayer():ConCommand("ulx goto "..name) end )
		end
		
		if re_bring then 
			re_log_menu:AddOption( "Brings player", function() LocalPlayer():ConCommand("ulx bring "..name) end )
		end
				


		if re_freeze then 
			re_log_menu:AddOption( "Freeze Player", function() LocalPlayer():ConCommand("ulx freeze "..name) end )
		end
		if re_unfreeze then 
			re_log_menu:AddOption( "Unfreeze Player", function() LocalPlayer():ConCommand("ulx unfreeze "..name) end )
		end		
		
		if re_demote then 
			re_log_menu:AddOption( "Demotes Player", function() LocalPlayer():ConCommand("ulx setjob "..name.."citizen") end )
		end
		

		if re_spectate then 
			re_log_menu:AddOption( "Spectate Player", function() LocalPlayer():ConCommand("ulx spectate "..name) end )
		end
		


		
		
		-- add other menu options under here.  ex. re_log_menu:AddOption( "what you want the menu to say", function() LocalPlayer():ConCommand("say !warp? !teleport? !goto, what ever you want "..name.." spwan? killroom? where ever you want to go if you have !warp.") end )
		
		re_log_menu:AddOption( "Teleport to Admin", function() LocalPlayer():ConCommand("say "..warpusers.." "..name.." "..ar) end )
		re_log_menu:AddOption( "Teleport to Spawn", function() LocalPlayer():ConCommand("say "..warpusers.." "..name.." "..spawn) end)
		re_log_menu:AddOption( "Copy SteamID", 	  function() SetClipboardText( getsteamid( name ) ) end)
		
	
		if re_kick then 
			re_log_menu:AddOption( "Kick Player", function() LocalPlayer():ConCommand("ulx kick "..name.." Kicked From On Screen Console.") end )
		end
			
		if re_ban then 
			re_log_menu:AddOption( "Ban Player "..re_ban_time.." minutes", function() LocalPlayer():ConCommand("ulx banid "..getsteamid( name ).." "..re_ban_time.." Banned From On Screen Console") end )
		end		
		
		if super_re_ban then
			if ( LocalPlayer():IsSuperAdmin() ) then
				re_log_menu:AddOption( "Ban Player(Superadmin) "..super_re_ban_time.." minutes", function() LocalPlayer():ConCommand("ulx banid "..getsteamid( name ).." "..super_re_ban_time.." Banned From On Screen Console") end )
			end
		end		
		
	if re_ip then
	
		if ( LocalPlayer():IsSuperAdmin() ) then
			re_log_menu:AddOption( "Copy IP", function() LocalPlayer():ConCommand("ulx ip "..name) end )
		end 
	end
end

function CreateReLogConsoleUI()
	re_log_frame = vgui.Create( "DFrame" )
		re_log_frame:SetPos( 10, 10 )
		re_log_frame:SetSize( ScrW() * 0.45, 150 )
		re_log_frame:SetTitle( serverName )
		re_log_frame:SetVisible( true )
		re_log_frame:SetDraggable( draggable )
		re_log_frame:SetSizable( false )
		re_log_frame:ShowCloseButton( closeButton )
		re_log_frame.Paint = function( self )
			surface.SetDrawColor( re_r,re_g,re_b,re_t ) -- dont change this unless you want ugly looking menu
			surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		end

	re_log_scroll = vgui.Create( "DScrollPanel", re_log_frame )
		re_log_scroll:SetPos( 5, 25 )
		re_log_scroll:SetSize( re_log_frame:GetWide() - 5, re_log_frame:GetTall() - 25 )

	re_log_html = vgui.Create( "DHTML", re_log_scroll )
		re_log_html:SetPos( 0, 0 )
		re_log_html:SetSize( re_log_scroll:GetWide(), re_log_scroll:GetTall() )
		re_log_html:AddFunction("re_logui", "opencontextmenu", function(...) opencontextmenu(...) end )
		re_log_html:SetAllowLua(true)
	re_log_scroll:AddItem( re_log_html )
end

function ShowReLogConsoleUI()
	if ( not re_log_frame or not IsValid( re_log_frame ) ) then 
		CreateReLogConsoleUI()
		re_log_frame:SetVisible( true )
		return
	end

	re_log_frame:SetVisible( not re_log_frame:IsVisible() )
end

function FormatReLog( name, log )
	local html = nil

	if name == "Name" then
		html = Format( [[<br><font color="white" face="arial" size="2">[%s] <font color="#4169E1"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) changed their name to <font color="#32CD32">%s</font></font></br>]],
					   tostring(os.date()), log.newname, log.oldname, log.steam_id, log.newname )
	end

	if name == "Connect" then
		if (log.method ~= "Connected") then
			html = Format( [[<br><font color="white" face="arial" size="2">[%s] <font color="#4169E1"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) disconnected from the server</font></br>]],
							tostring(os.date()), log.name, log.name, log.steam_id )
		else
			html = ""
		end
	end

	

	
	if name == "Kills" then
		if (log.role_killer == "[Unknown]" ) then
			log.name_killer = "World"
			log.steam_id_killer = "WORLD"
		end

		html = Format( [[<br><font color="white" face="arial" size="2">[%s] <font color="#4169E1"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) killed <font color="#32CD32"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) with <font color="#FF2400">%s</font></font></br> ]], 
					  tostring(os.date()), log.name_killer, log.name_killer, log.steam_id_killer, log.name, log.name, log.steam_id, log.weapon )
	end

	if name == "Arrest" then
		if log.method == "Arrested" then
			html = Format( [[<br><font color="white" face="arial" size="2">[%s] <font color="#4169E1"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) arrested <font color="#32CD32"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) for <font color="#FF2400">%s</font> seconds</font></br>]],
						  tostring(os.date()), log.name_officer, log.name_officer, log.steam_id_officer, log.name, log.name, log.steam_id, log.arrest_time )
		else
			if log.name_officer != "" then
				html = Format( [[<br><font color="white" face="arial" size="2">[%s] <font color="#4169E1"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) unarrested <font color="#32CD32"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s)</br>]],
							   tostring(os.date()), log.name_officer, log.name_officer, log.steam_id_officer, log.name, log.name, log.steam_id )
			else
				html = Format( [[<br><font color="white" face="arial" size="2">[%s] <font color="4169E1"><a onclick="re_logui.opencontextmenu('%s');">%s</a></font>(%s) was let out of jail.</font></br>]],
							   tostring(os.date()), log.name, log.name, log.steam_id )
			end
		end
	end

	return html
end

function AddLogItem( name, log )
	if not IsValid( re_log_html ) then return end

	re_log_html_text = ( FormatReLog( name, log ) )..re_log_html_text
	re_log_html:SetHTML( re_log_html_text_base..re_log_html_text.."</p>" )

	print( re_log_html_text )
end

function Receive_RecordLog( len, pl )
	local tbl = net.ReadTable()
	local log_type = tbl[1]
	local log = tbl[2]

	AddLogItem( log_type, log )
end
net.Receive( "Receive_RecordLog", Receive_RecordLog )
