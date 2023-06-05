if script.active_mods["gvv"] then require("__gvv__.gvv")() end

--Pre-Load functions
require "util"
require "lib.OrePatchOrganizer"

--Global Variables holding ores w/Count (AllResources) and the AllResources counter
Resource_Name = "" --Name of Resource to print/capture
Resource_Count = 0 --Amount of Resource to print/capture

--Event Handlers
script.on_event(defines.events.on_player_selected_area, function(event) --Pick up Ores
    --Only handle the ore patch organiser
    if event.item == "ore-patch-organizer" then
        --event.area = SnapArea(event.area, 1, false)
        if IsZeroSize(event.area) then return end

        for _, resource in pairs(event.entities) do
            if resource.prototype.resource_category == 'basic-solid' then --Only get Solid resources
                --Capture first resource
                if Resource_Name == "" then
                    Resource_Name = resource.name
                end
                if resource.name == Resource_Name then -- Only add allowed resource
                    Resource_Count = Resource_Count + resource.amount
                    resource.destroy()
                end
            end
        end
        game.print(string.format("Total %s Captured: %s", Resource_Name, Format_Int(Resource_Count)))
    end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event) --Print Ores
    if event.item == "ore-patch-organizer" then
        if IsZeroSize(event.area) then return end
        if Resource_Name ~= "" then
            for _, resource in pairs(event.entities) do
                if resource.type == "resource" then
                    game.print(string.format("Cannot print %s. Other resources are in the way", Resource_Name))
                    return
                end
            end

            --validate area
            local validCells = 0
            for x = event.area.left_top.x, event.area.right_bottom.x do
                --iterate y axis
                for y = event.area.left_top.y, event.area.right_bottom.y do
                    if event.surface.get_tile(x, y).collides_with("ground-tile") then
                        validCells = validCells + 1
                    end
                end
            end

            --No area, don't say we're "Printing"
            if validCells == 0 then
                game.print(string.format("No valid tiles selected to print %s %s", Format_Int(Resource_Count),
                    Resource_Name))
                return
            end

            --If we get here, there are no resources in the area, there is space to print
            game.print(string.format("Printing %s: %s", Resource_Name, Format_Int(Resource_Count)))
            --Ensure at leaste 1 ore per tile. Round up to prevent remainder ores
            local oresPerCell = math.max(math.ceil(Resource_Count / validCells), 1)
            --Iterate x axis
            for x = event.area.left_top.x, event.area.right_bottom.x do
                --iterate y axis
                for y = event.area.left_top.y, event.area.right_bottom.y do
                    if event.surface.get_tile(x, y).collides_with("ground-tile") then
                        if Resource_Count ~= 0 then --Safety Check
                            --Print Ore
                            event.surface.create_entity({
                                name = Resource_Name,
                                amount = math.min(Resource_Count, oresPerCell),
                                position = { x, y }
                            })
                            Resource_Count = Resource_Count - math.min(Resource_Count, oresPerCell)
                        end
                    end
                end
            end

            --Finish by removing the existing name. If statement to be safe
            if Resource_Count == 0 then
                Resource_Name = ""
            end
        end
    end
end)
