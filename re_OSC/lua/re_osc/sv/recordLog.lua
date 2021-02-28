util.AddNetworkString( "Receive_RecordLog" )


re_OSC.Data = re_OSC.Data or {}
re_OSC.Data.Name = re_OSC.Data.Name or {}
re_OSC.Data.Job = re_OSC.Data.Job or {}
re_OSC.Data.Kills = re_OSC.Data.Kills or {}
re_OSC.Data.Connect = re_OSC.Data.Connect or {}
re_OSC.Data.Arrest = re_OSC.Data.Arrest or {}
re_OSC.Data.Warrant = re_OSC.Data.Warrant or {}
re_OSC.Data.Wanted = re_OSC.Data.Wanted or {}
re_OSC.Data.Command = re_OSC.Data.Command or {}


	


function re_OSC:recordLog(log,data)
	table.insert(re_OSC.Data[log],1,data)

	

	if ( log == "Arrest" or log == "Kills" or log == "Name" or log == "Connect") then
		//local encoded = glon.encode( data )
		
		net.Start( "Receive_RecordLog" )
			net.WriteTable( { log, data } )
		net.Send( player.GetAll() )

	end

end


