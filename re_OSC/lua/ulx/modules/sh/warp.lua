if ( SERVER ) then

	CreateConVar( "warp_groupstring_blacklist", "0" ) 
	
	util.AddNetworkString( "RequestWarps" )
	util.AddNetworkString( "RequestWarpsCallback" )
	util.AddNetworkString( "RemoveWarp" )
	util.AddNetworkString( "Warp" )
	util.AddNetworkString( "GetWarpCvar" )
	util.AddNetworkString( "GetWarpCvarCallback" )
	
	warpsList = {}
	
	if not file.Exists( "re_warps", "DATA" ) then
		file.CreateDir( "re_warps" )
	end
	
	if not file.Exists( "re_warps/re_warps.txt", "DATA" ) then
		file.Write( "re_warps/re_warps.txt", "" )
	end
	
	function updateFile()
	
		file.Write( "re_warps/re_warps.txt", "" )

		for k, v in next, warpsList do
			if v[ 1 ] and v[ 2 ] and v[ 3 ] and v[ 4 ] and v[ 5 ] and v[ 6 ] then
				file.Append( "re_warps/re_warps.txt", v[ 1 ] .. "\t" .. v[ 2 ] .. "\t" .. v[ 3 ] .. "\t" .. v[ 4 ] .. "\t" .. v[ 5 ] .. "\t" .. v[ 6 ] .. "\n" )
			else
				continue
			end
		end
		
	end
	
	function populateWarpList()
	
		table.Empty( warpsList )
		
		local wfile = file.Read( "re_warps/re_warps.txt", "DATA" )
		local warps = string.Explode( "\n", wfile )
		
		for k, v in next, warps do
			local exp = string.Explode( "\t", v )
			table.insert( warpsList, { exp[ 1 ], exp[ 2 ], exp[ 3 ], exp[ 4 ], exp[ 5 ], exp[ 6 ] } )
		end	
		
	end
	
	function saveWarp( name, added, pos, groupstring )
		
		for k, v in next, warpsList do
			if v[ 1 ] == name then
				return
			end
		end
		
		local date = os.date()
		local added = added:Name()
		local pos = util.TypeToString( pos )
		local map = game.GetMap()
		
		table.insert( warpsList, { name, added, date, pos, map, groupstring } )
		
		updateFile()
		
	end
	
	function removeWarp( name )
	
		for k, v in next, warpsList do
			if v[ 1 ] == name then
				local tpos = table.KeyFromValue( warpsList, v )
				table.remove( warpsList, tpos )
				updateFile()
				break
			end
		end
		
	end
	
	net.Receive( "RequestWarps", function( len, ply )
	
		local tab = warpsList
		
		net.Start( "RequestWarpsCallback" )
			net.WriteTable( warpsList )
		net.Send( ply ) 
		
	end )	
	
	net.Receive( "Warp", function( len, ply )
	
		local vector = net.ReadVector()
		local name = net.ReadString()
		
		ply:SetPos( vector )
		ply:SetLocalVelocity( Vector( 0, 0, 0 ) )
		ulx.fancyLogAdmin( ply, "#A warped to location #s", name )
		
	end )
	
	net.Receive( "RemoveWarp", function( len, ply )
		local name = net.ReadString()
		for k, v in next, warpsList do
			if v[ 1 ] == name then
				local pos = table.KeyFromValue( warpsList, v )
				table.remove( warpsList, pos )
				updateFile()
				ulx.fancyLogAdmin( ply, "#A removed warp position #s", name )
				break
			end
		end
	end )
	
	net.Receive( "GetWarpCvar", function( len, ply )
		
		local bit = GetConVar( "warp_groupstring_blacklist" ):GetBool()
		
		net.Start( "GetWarpCvarCallback" )
			net.WriteString( tostring( bit ) )
		net.Send( ply )
		
	end )
	
	populateWarpList()
end

function ulx.addwarp( calling_ply, name, groupstring )

	local ply = calling_ply
	local pos = ply:GetPos()
	local name = name
	
	saveWarp( name, ply, pos, groupstring )
	
	ulx.fancyLogAdmin( calling_ply, "#A added a new warp position #s with allowed groups #s", name, groupstring )
	
end
local addwarp = ulx.command( "Warp", "ulx addwarp", ulx.addwarp, re_add_warp, re_add_warp_invis )
addwarp:addParam{ type=ULib.cmds.StringArg, hint="Name" }
addwarp:addParam{ type=ULib.cmds.StringArg, hint="Groups", ULib.cmds.takeRestOfLine }
addwarp:defaultAccess( ULib.ACCESS_ADMIN )
addwarp:help( "Add a new warp position where you are standing" )
-- { user_id }

function ulx.addwarp_manual( calling_ply, name, pos, groupstring )

	saveWarp( name, calling_ply, pos, groupstring )
	
	ulx.fancyLogAdmin( calling_ply, "#A added a new warp position #s with allowed groups #s", name, groupstring )
	
end
local addwarp_manual = ulx.command( "Warp", "ulx addwarp_manual", ulx.addwarp_manual )
addwarp_manual:addParam{ type=ULib.cmds.StringArg, hint="Name" }
addwarp_manual:addParam{ type=ULib.cmds.StringArg, hint="Position" }
addwarp_manual:addParam{ type=ULib.cmds.StringArg, hint="Groups", ULib.cmds.takeRestOfLine }
addwarp_manual:defaultAccess( ULib.ACCESS_ADMIN )
addwarp_manual:help( "Add a new warp position manually" )

function ulx.warpmenu( calling_ply )

	SendUserMessage( "OpenWarpMenu", calling_ply )
	
end
local warpmenu = ulx.command( "Warp", "ulx warpmenu", ulx.warpmenu, re_menu, re_menu_invis )
warpmenu:defaultAccess( ULib.ACCESS_ALL )
warpmenu:help( "Open the warp menu" )

function ulx.warpto( calling_ply, name )
	
	local canWarp = false
	
	for k, v in next, warpsList do
		if name == v[ 1 ] then
			canWarp = true
		end
	end
	
	if not canWarp then
		ULib.tsayError( ply, "Invalid warp location specified." )
		return
	end
	
	for k, v in next, warpsList do
		if name == v[ 1 ] then
			local groupstab = string.Explode( " ", v[ 6 ] )
			local usergroup = calling_ply:GetUserGroup()
			if not GetConVar( "warp_groupstring_blacklist" ):GetBool() then
				if not table.HasValue( groupstab, usergroup ) then
					calling_ply:ChatPrint( "Sorry, you are not allowed to tp to this location!" )
					return
				end
			else
				if table.HasValue( groupstab, usergroup ) then
					calling_ply:ChatPrint( "Sorry, you are not allowed to tp to this location!" )
					return
				end
			end
			if v[ 5 ] == game.GetMap() then
				calling_ply:SetPos( util.StringToType( v[ 4 ], "Vector" ) )
			else
				ULib.tsay( ply, "Sorry, you cannot tp to a position set on another map." )
				return
			end
			break
		end
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A teleported to location #s", name )
	
end
local warpto = ulx.command( "Warp", "ulx warpto", ulx.warpto, re_warp, re_warp_invis )
warpto:addParam{ type=ULib.cmds.StringArg, hint="Location", ULib.cmds.takeRestOfLine }
warpto:defaultAccess( ULib.ACCESS_ALL )
warpto:help( "Warp to a location" )


local re_menu_outline_real
if re_menu_outline == "black" then
	re_menu_outline_real = Color(0,0,0,200)
	
elseif re_menu_outline == "white" then
	re_menu_outline_real = Color(255,255,255,200)
	
elseif re_menu_outline == "dark green" then
	re_menu_outline_real = Color(12,59,34,200)
	
elseif re_menu_outline == "gray" then
	re_menu_outline_real = Color(128,128,128,200)
	
elseif re_menu_outline == "green" then
	re_menu_outline_real = Color(0,128,0,200)
	
elseif re_menu_outline == "red" then
	re_menu_outline_real = Color(255,0,0,200)
	
elseif re_menu_outline == "light green" then
	re_menu_outline_real = Color(45,214,122,200)
	
elseif re_menu_outline == "dark red" then
	re_menu_outline_real = Color(113,0,0,200)
	
elseif re_menu_outline == "yellow" then
	re_menu_outline_real = Color(255,255,0,200)
	
elseif re_menu_outline == "blue" then
	re_menu_outline_real = Color(0,0,255,200)
	
elseif re_menu_outline == "light blue" then
	re_menu_outline_real = Color(25,154,255,200)
	
elseif re_menu_outline == "navy blue" then
	re_menu_outline_real = Color(0,0,128,200)
	
elseif re_menu_outline == "orange" then
	re_menu_outline_real = Color(255,165,0,200)
	
elseif re_menu_outline == "purple" then
	re_menu_outline_real = Color(155,48,255,200)
	
elseif re_menu_outline == "teal" then
	re_menu_outline_real = Color(0,128,128,200)
	
elseif re_menu_outline == "pink" then
	re_menu_outline_real = Color(255,105,180,200)
	
elseif re_menu_outline == "brown" then
	re_menu_outline_real = Color(165,104,42,200)
else
	re_menu_outline_real = Color(255,255,255,200)

end


local re_menu_color_real
if re_menu_color == "black" then
	re_menu_color_real = Color(0,0,0,200)
	
elseif re_menu_color == "white" then
	re_menu_color_real = Color(255,255,255,200)
	
elseif re_menu_color == "dark green" then
	re_menu_color_real = Color(12,59,34,200)
	
elseif re_menu_color == "gray" then
	re_menu_color_real = Color(128,128,128,200)
	
elseif re_menu_color == "green" then
	re_menu_color_real = Color(0,128,0,200)
	
elseif re_menu_color == "red" then
	re_menu_color_real = Color(255,0,0,200)
	
elseif re_menu_color == "light green" then
	re_menu_color_real = Color(45,214,122,200)
	
elseif re_menu_color == "dark red" then
	re_menu_color_real = Color(113,0,0,200)
	
elseif re_menu_color == "yellow" then
	re_menu_color_real = Color(255,255,0,200)
	
elseif re_menu_color == "blue" then
	re_menu_color_real = Color(0,0,255,200)
	
elseif re_menu_color == "light blue" then
	re_menu_color_real = Color(25,154,255,200)
	
elseif re_menu_color == "navy blue" then
	re_menu_color_real = Color(0,0,128,200)
	
elseif re_menu_color == "orange" then
	re_menu_color_real = Color(255,165,0,200)
	
elseif re_menu_color == "purple" then
	re_menu_color_real = Color(155,48,255,200)
	
elseif re_menu_color == "teal" then
	re_menu_color_real = Color(0,128,128,200)
	
elseif re_menu_color == "pink" then
	re_menu_color_real = Color(255,105,180,200)
	
elseif re_menu_color == "brown" then
	re_menu_color_real = Color(165,104,42,200)
else
	re_menu_color_real = Color(255,255,255,200)

end



function ulx.warpuser( calling_ply, target_ply, name )
	
	local canWarp = false
	
	for k, v in next, warpsList do
		if name == v[ 1 ] then
			canWarp = true
		end
	end
	
	if not canWarp then
		ULib.tsayError( ply, "Invalid tp location specified." )
		return
	end
	
	for k, v in next, warpsList do
		if name == v[ 1 ] then
			if v[ 5 ] == game.GetMap() then
				target_ply:SetPos( util.StringToType( v[ 4 ], "Vector" ) )
			else
				ULib.tsay( ply, "Sorry, you cannot tp to a position set on another map." )
				return
			end
			break
		end
	end
	
	ulx.fancyLogAdmin( calling_ply, "#A teleported #T to location #s", target_ply, name )
	
end
local warpuser = ulx.command( "Warp", "ulx warpuser", ulx.warpuser, re_warpusers, re_warpusers_invis )
warpuser:addParam{ type=ULib.cmds.PlayerArg }
warpuser:addParam{ type=ULib.cmds.StringArg, hint="Location", ULib.cmds.takeRestOfLine }
warpuser:defaultAccess( ULib.ACCESS_SUPERADMIN )
warpuser:help( "Warp a user to a location" )
	
if ( CLIENT ) then

	local savedPos = {}
	
	local main
	
	local function GetWarpCvar()
	
		net.Start( "GetWarpCvar" )
		net.SendToServer()
		
		net.Receive( "GetWarpCvarCallback", function()
			local bit = tobool( net.ReadString() )
			return bit
		end )
		
	end
	
	local function openWarpMenu()
		
		if main then
			return
		end
		
		main = vgui.Create( "DFrame" )	
		main:SetSize( 800, 300 )
		main:SetTitle( re_menu_name )
		main:SetVisible( true )
		main:SetDraggable( re_draggable )
		main:ShowCloseButton( true )
		main:MakePopup()
		if re_center_menu then
			main:Center()
		end
		main.Paint = function()
			surface.SetDrawColor( re_menu_outline_real )
			surface.DrawOutlinedRect( 0, 0, main:GetWide(), main:GetTall() )		
			surface.SetDrawColor( re_menu_color_real )
			surface.DrawRect( 1, 1, main:GetWide() - 2, main:GetTall() - 2 )		
		end
		
		main.OnClose = function()
			main:Remove()
			if main then
				main = nil
			end
		end

		local list = vgui.Create( "DListView", main )
		list:SetPos( 4, 27 )
		list:SetSize( 792, 269 )
		list:SetMultiSelect( re_multi_select )
		list:AddColumn( "Location Name" )
		list:AddColumn( "Added by" )
		if re_add_date then
			list:AddColumn( "Date Added" )
		end
		list:AddColumn( "Position" )
		list:AddColumn( "Map" )
		local re_gwc = GetWarpCvar()

		if not re_gwc then
			list:AddColumn( "Group Whitelist" )
		else
			list:AddColumn( "Group Blacklist" )
		end
		
		local function populateWarpList()
		
			list:Clear()
			
			net.Start( "RequestWarps" )
			net.SendToServer()
			
			net.Receive( "RequestWarpsCallback", function()
			
				local tab = net.ReadTable()
				
				for k, v in next, tab do
					if v[ 1 ]:len() > 0 then
						local row 
						if re_add_date then
						
							row = list:AddLine( v[ 1 ], v[ 2 ], v[ 3 ], v[ 4 ], v[ 5 ], v[ 6 ] )
						end
						
						if not re_add_date then
							row = list:AddLine( v[ 1 ], v[ 2 ], v[ 4 ], v[ 5 ], v[ 6 ] )
						end
						
							
						
						if re_add_date then
						
							function row:PaintOver()
								if row.Columns[ 5 ]:GetText() == game.GetMap() then
									row.Columns[ 5 ]:SetTextColor( Color( 20, 155, 40 ) )
								else
									row.Columns[ 5 ]:SetTextColor( Color( 255, 0, 0 ) )
								end
								if row.Columns[ 2 ]:GetText() == LocalPlayer():Name() then
									row.Columns[ 2 ]:SetTextColor( Color( 0, 0, 200 ) )
								end
							end
						end
						
						if not re_add_date then
						
							function row:PaintOver()
								if row.Columns[ 4 ]:GetText() == game.GetMap() then
									row.Columns[ 4 ]:SetTextColor( Color( 20, 155, 40 ) )
								else
									row.Columns[ 4 ]:SetTextColor( Color( 255, 0, 0 ) )
								end
								if row.Columns[ 2 ]:GetText() == LocalPlayer():Name() then
									row.Columns[ 2 ]:SetTextColor( Color( 0, 0, 200 ) )
								end
							end
						end
					end
				end
				
			end )
			
		end
		populateWarpList()
		
		list.OnRowRightClick = function( main, line )
		
			local menu = DermaMenu()
				if re_remove_warp then
					menu:AddOption( "Remove Warp", function()
				
						net.Start( "RemoveWarp" )
							net.WriteString( list:GetLine( line ):GetValue( 1 ) )
						net.SendToServer()
						populateWarpList()
				
					end ):SetIcon( re_remove_warp_img )
				end
				
				if re_copy_pos then
					menu:AddOption( "Copy Position", function()
				
						local vec = util.StringToType( list:GetLine( line ):GetValue( 4 ), "Vector" ) 
					
						SetClipboardText( vec.x .. ", " .. vec.y .. ", " .. vec.z )
					
					end ):SetIcon( re_copy_pos_img )
				end
			menu:Open()
			
		end
		
	end
	usermessage.Hook( "OpenWarpMenu", openWarpMenu )
	
end