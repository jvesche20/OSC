-- This config file is ONLY for cl_vgui.lua file (The On Screen Console)
serverName = "RE RE's On Screen Console" -- Enter the server name, or what you want to be displayed at the top of the On Screen Console.

draggable = true -- set true if you want it to be draggable, false if not.

closeButton = true -- option to close the On Screen Console.

re_goto = true -- If you would like the option to !goto players from the On Screen Console put true if not then put false

-- only change these if you changed them in the warp config file
warpusers = "!warpuser"

spawn = "spawn"

ar = "adminroom"

re_kick = false -- if you want a kick option when clicking on the persons name.

re_ban = true -- if you want a ban option when clicking on the persons name.
re_ban_time = "30" -- default time player gets banned for.  This only applies if you have re_ban set to true

super_re_ban = true -- if you want a ban option when clicking on the persons name for superadmin's only.
super_re_ban_time = "120"

re_freeze = true -- freezes player from menu
re_unfreeze = true -- would make this true if re_freeze is also true.
re_bring = true -- brings player from on screen console.
re_spectate = true -- spectates player from on screen console.
re_ip = true -- gets the players ip. for superadmins, this can be abused easily. I don't recommend using it.
re_r,re_g,re_b,re_t = 11, 11, 11, 200 -- Colors of the OSC dont put () around the numbers just leave em like that 