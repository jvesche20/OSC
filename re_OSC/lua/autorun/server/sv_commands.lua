 concommand.Add( "onscreenlogs", function( ply )
//if ( ply:IsAdmin() ) then
ply:SendLua( "ShowReLogConsoleUI()" )
//end
end )
