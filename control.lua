if script.active_mods["gvv"] then require("__gvv__.gvv")() end

--Pre-Load functions
require "util"
require "lib.OrePatchOrganizer"

--Global Variables holding ores w/Count (AllResources) and the AllResources counter
Resource_Name = "" --Name of Resource to print/capture
Resource_Count = 0 --Amount of Resource to print/capture
Resource_Surface = ""
Resource_Category = ""
Resource_Name_Localised = ""
Resource_Handler = ""

MyDebug = false

--Event Handlers

--Ore Collection
script.on_event(defines.events.on_player_selected_area, function(event)
    --Only handle the ore patch organiser
    if event.item == "ore-patch-organizer" then
        --Skip 0 size selection
        if IsZeroSize(event.area) then return end
        --[[
        if MyDebug then
            game.print({ "", "Resource_Name_Localised: ", { "item-name.iron-plate" } })
            game.print(string.format("Resource_Name: %s", Resource_Name))
            game.print(string.format("Resource_Name_Localised: %s", Resource_Name_Localised))
            game.print(string.format("Resource_Surface: %s", Resource_Surface))
            game.print(string.format("Resource_Category: %s", Resource_Category))
            game.print(string.format("Resource_Count: %s", Resource_Count))
        end
        ]]

        --Loop all resources in Event
        for _, resource in pairs(event.entities) do
            if Resource_Category == "" then
                --Validate Category for initial collection

                --Handle Solids
                if settings.startup["resource-patch-organizer-allow-solids"].value == true then
                    if resource.prototype.resource_category == 'basic-solid' or    --Vanilla Ores
                        resource.prototype.resource_category == 'hard-resource' or --K2 Hard Resource
                        resource.prototype.resource_category == 'kr-quarry' then   --K2 Quarry
                        --[[
                            resource.prototype.resource_category == 'se-core-mining' or --Space Exploration Core Mining
                            skip se-core-mining due to multi-part (Fissure, Smoke, Resource)
                            Once I figure this out, allow moving of Core Miners
                        ]]

                        --Only set category if Resource is approved solid for collection
                        Resource_Category = resource.prototype.resource_category
                    end
                end

                --Handle fluids
                if settings.startup["resource-patch-organizer-allow-fluids"].value == true then
                    if resource.prototype.resource_category == 'basic-fluid' or --Vanilla Fluid
                        resource.prototype.resource_category == 'oil' then      --K2 Oil
                        --Only set category if Resource is approved fluid for collection
                        Resource_Category = resource.prototype.resource_category
                    end
                end
            end

            --Set if resource is Spaced (Oil patches) or Spread (Raw Ores)
            if Resource_Category == 'basic-solid' or
                Resource_Category == 'hard-resource' then
                Resource_Handler = 'spread'
            elseif Resource_Category == 'basic-fluid' or
                Resource_Category == 'oil' or
                Resource_Category == 'se-core-mining' or
                Resource_Category == 'kr-quarry' then
                Resource_Handler = 'spaced'
            end

            --Post Validation, process details
            --We've either collected a resource, or just set the resource category
            if Resource_Category ~= "" then
                --Set initial values
                if Resource_Name == "" or Resource_Category == "" or Resource_Surface == "" then
                    --1. Base Name
                    if Resource_Name == "" then
                        Resource_Name = resource.name
                    end

                    --2. Localised Name
                    if Resource_Name_Localised == "" then
                        Resource_Name_Localised = resource.localised_name
                    end

                    --3. Surface
                    if Resource_Surface == "" then
                        Resource_Surface = event.surface
                    end
                end

                --Validate details
                if settings.startup["resource-patch-organizer-lock-surface"].value then
                    if event.surface ~= Resource_Surface then
                        game.print({ "", "Invalid Surface. Resources were collected from ", Resource_Surface })
                        return
                    end
                end

                if resource.name == Resource_Name then -- Only add allowed resource
                    Resource_Count = Resource_Count + resource.amount
                    resource.destroy()
                end
            end
        end
        game.print({ "", "Total ", Resource_Name_Localised, " Captured: ", Format_Int(Resource_Count) })
    end
end)

script.on_event(defines.events.on_player_alt_selected_area, function(event) --Print Ores
    --Only ore patch organizer
    if event.item == "ore-patch-organizer" then
        --No area selected
        if IsZeroSize(event.area) then return end

        --Only validate printing if something has been collected
        if Resource_Name ~= "" then
            --If lock-surface only allow printing if same surface
            if settings.startup["resource-patch-organizer-lock-surface"].value == true then
                if event.surface ~= Resource_Surface then
                    game.print({ "", "Invalid Surface. Resources were collected from ", Resource_Surface })
                    return
                end
            end
            --[[
    TODO:
    1. Configure printing based on Resource_Category
        a. Figure out width of SE Core Miner and K2 Quarry to ensure optimal separation
            I. potentially change setting to set amount of tiles between large buildings (Pumpjack, Core Miner, Quarry) instead of a fixed width
    2. Implement special printing
        a. Basic Ores
        b. Basic Fluids (Water/Oil)
        c. Special Ores (Quarry/Core Miner) use logic from Fluids
]]
            for _, resource in pairs(event.entities) do
                if resource.type == "resource" then
                    game.print({ "", "Cannot print ", Resource_Name_Localised, ". Other Resources are in the way" })
                    return
                end
            end

            --validate area
            local validCells = 0
            local invalidCells = 0
            for x = event.area.left_top.x, event.area.right_bottom.x do
                --iterate y axis
                for y = event.area.left_top.y, event.area.right_bottom.y do
                    if event.surface.get_tile(x, y).collides_with("ground-tile") then
                        validCells = validCells + 1
                    else
                        invalidCells = invalidCells + 1
                    end
                end
            end

            --No area, don't say we're "Printing"
            if Resource_Handler == 'spread' then
                --Spread Resources
                if validCells == 0 then
                    --Solids must have some valid cells
                    game.print({ "", "No valid tiles selected to print ", Format_Int(Resource_Count), " ",
                        Resource_Name_Localised })
                    return
                end
            elseif Resource_Handler == 'spaced' then
                --Spaced resources
                if invalidCells ~= 0 then
                    --Spaced Resources must be placed on fully empty ground
                    --This is for pure laziness to prevent calculating collisions
                    game.print({ "", "Fluids must have fully empty ground. Can't print ", Format_Int(Resource_Count),
                        " ", Resource_Name_Localised })
                    return
                end
            end

            --If we get here, there are no resources in the area, there is space to print
            --Ensure at leaste 1 ore per tile. Round up to prevent remainder ores
            local resourcesPerCell = math.max(math.ceil(Resource_Count / validCells), 1)
            game.print({ "", "Printing ", Resource_Name_Localised, ": ", Format_Int(Resource_Count) })

            if Resource_Handler == 'spread' then
                --Print solids in a clean square
                --Iterate x axis
                for x = event.area.left_top.x, event.area.right_bottom.x do
                    --iterate y axis
                    for y = event.area.left_top.y, event.area.right_bottom.y do
                        if event.surface.get_tile(x, y).collides_with("ground-tile") then
                            if Resource_Count ~= 0 then --Safety Check
                                --Print Ore
                                event.surface.create_entity({
                                    name = Resource_Name,
                                    amount = math.min(Resource_Count, resourcesPerCell),
                                    position = { x, y }
                                })
                                Resource_Count = Resource_Count - math.min(Resource_Count, resourcesPerCell)
                            end
                        end
                    end
                end
                --Reset Mining Drills to detect any new ores pasted
                for _, e in pairs(event.surface.find_entities_filtered { area = event.area, type = "mining-drill" }) do
                    e.update_connections()
                end
            elseif Resource_Handler == 'spaced' then
                --Print fluids in an even grid
                local tileGrid = 0
                if Resource_Category == 'basic-fluid' then
                    --Default fluid types
                    tileGrid = settings.startup["resource-patch-organizer-fluid-grid"].value
                elseif Resource_Category == 'oil' then
                    --K2 Oil
                    tileGrid = settings.startup["resource-patch-organizer-fluid-grid"].value
                elseif Resource_Category == 'se-core-mining' then
                    --Core miner is 11x11
                    tileGrid = settings.startup["resource-patch-organizer-special-ore-grid"].value + 11
                elseif Resource_Category == 'kr-quarry' then
                    --Quarry Drill is 7x7
                    tileGrid = settings.startup["resource-patch-organizer-special-ore-grid"].value + 7
                end

                local totalX = math.floor((event.area.right_bottom.x - event.area.left_top.x) / tileGrid)
                local totalY = math.floor((event.area.right_bottom.y - event.area.left_top.y) / tileGrid)

                if totalX <= 0 or totalY <= 0 then
                    --Area too small - Print Single instance
                    event.surface.create_entity({
                        name = Resource_Name,
                        amount = math.max(Resource_Count, 1),
                        position = { event.area.left_top.x, event.area.left_top.y }
                    })
                else
                    local resourcesPerCell = math.max(math.ceil(Resource_Count / (totalX * totalY)), 1)

                    --[[
                    if MyDebug then
                        game.print(string.format("%s Resources per Cell", resourcesPerCell))
                        game.print(string.format("%s Total X", totalX))
                        game.print(string.format("%s Total Y", totalY))
                    end
                    ]]

                    --Iterate via int Variables instead of direct Event X/Y because of rounding and causing an extra instance placing
                    --Iterate x axis
                    for x = 0, (totalX - 1) do
                        --Iterate y axis
                        for y = 0, (totalY - 1) do
                            --Print Fluids
                            --[[
                            if MyDebug then
                                game.print(string.format("%s X - %s Y - %s Resouce Count", x, y, Resource_Count))
                            end
                            ]]
                            event.surface.create_entity({
                                name = Resource_Name,
                                amount = math.min(Resource_Count, resourcesPerCell),
                                position = { event.area.left_top.x + (x * tileGrid),
                                    event.area.left_top.y + (y * tileGrid) }
                            })
                            Resource_Count = Resource_Count - math.min(Resource_Count, resourcesPerCell)
                        end
                    end
                end
            end

            --Finish by removing the existing details
            Resource_Name = ""
            Resource_Category = ""
            Resource_Count = 0
            Resource_Surface = ""
            Resource_Name_Localised = ""
        end
    end
end)
