if script.active_mods["gvv"] then require("__gvv__.gvv")() end

--Pre-Load functions
require "lib.functions"

--Event Handlers
script.on_event(defines.events.on_player_selected_area, On_Player_Selected_Area )
script.on_event(defines.events.on_player_alt_selected_area, On_Player_Alt_Selected_Area)
