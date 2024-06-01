--[[
Mod - Internal only, to show compatibility
ResourceCategory - 'basic-fluid' etc
ResourceType - Fluid or Solid (For Settings, i.e. Only Solids or Only Fluids)
ResourceHandler - Spaced or Spread (For pasting, spread like Ores, or Space like Oil)
ResourceSpace - Machine Size to dictate space between resource patches
]]
Resource_Data = {}

local function AddToTable(Mod, ResourceCategory, ResourceType, ResourceHandler, ResourceSpace)
    Resource_Data[ResourceCategory] = {
            Mod = Mod,
            ResourceCategory = ResourceCategory,
            ResourceType = ResourceType,
            ResourceHandler = ResourceHandler,
            ResourceSpace = ResourceSpace
        }
end

function SetResourceOrganizer(Resource)
    --resource.prototype.resource_category
    local tmp = Resource_Data[Resource.prototype.resource_category]
    if tmp == nil then return end --Doesn't exist in configured resources
    if (Resource_Organizer.AllowSolids and tmp['ResourceType'] == 'solid') or (Resource_Organizer.AllowFluids and tmp['ResourceType'] == 'fluid') then
        Resource_Organizer.Category = Resource.prototype.resource_category
        Resource_Organizer.Handler = tmp['ResourceHandler']
        Resource_Organizer.MachineSize = tmp['ResourceSpace']
        Resource_Organizer.Name = Resource.name
        Resource_Organizer.Name_Localised = Resource.localised_name
    end
end

function ResetResourceOrganizer()
    Resource_Organizer.Name = ""
    Resource_Organizer.Count = 0
    Resource_Organizer.CountPerCell = 0
    Resource_Organizer.Surface = ""
    Resource_Organizer.Category = ""
    Resource_Organizer.Name_Localised = ""
    Resource_Organizer.Handler = ""
end


--[[
    WARNING WARNING WARNING
    Do not add duplicate ResourceCategory entries
    Only the first one will be picked (Usually)
    Custom handling may be added in the future if 2 mods have the same ResourceCategory with different mechanics

    solid/fluid & spread/spaced must be all lower case
]]

AddToTable("Vanilla", "basic-solid", "solid", "spread", 0)
AddToTable("Vanilla", "basic-fluid", "fluid", "spaced", 3)

AddToTable("Krastorio2", "hard-resource", "solid", "spread", 0)
AddToTable("Krastorio2", "kr-quarry", "solid", "spaced", 7)
AddToTable("Krastorio2", "oil", "fluid", "spaced", 3)

AddToTable("Vortek_Deep_Core_Mining", "vtk-deepcore-mining-crack", "solid", "spaced", 9)
AddToTable("Vortek_Deep_Core_Mining", "vtk-deepcore-mining-ore-patch", "solid", "spaced", 5)

AddToTable("BZ_Natural_Gas", "gas", "fluid", "spaced", 3)

AddToTable("Pyanodon", "borax", "solid", "spread", 0)
AddToTable("Pyanodon", "niobium", "solid", "spread", 0)
AddToTable("Pyanodon", "nexelit-rock", "solid", "spaced", 11)
AddToTable("Pyanodon", "zinc-rock", "solid", "spaced", 11)
AddToTable("Pyanodon", "coal-rock", "solid", "spaced", 11)
AddToTable("Pyanodon", "chromium-rock", "solid", "spaced", 11)
AddToTable("Pyanodon", "salt-rock", "solid", "spaced", 11)
AddToTable("Pyanodon", "lead-rock", "solid", "spaced", 11)
AddToTable("Pyanodon", "uranium-rock", "solid", "spaced", 11)
AddToTable("Pyanodon", "quartz-rock", "solid", "spaced", 13)
AddToTable("Pyanodon", "nickel-rock", "solid", "spaced", 13)
AddToTable("Pyanodon", "iron-rock", "solid", "spaced", 13)
AddToTable("Pyanodon", "copper-rock", "solid", "spaced", 13)
AddToTable("Pyanodon", "tin-rock", "solid", "spaced", 13)
AddToTable("Pyanodon", "aluminium-rock", "solid", "spaced", 19) --UK Spelling aluminium
AddToTable("Pyanodon", "titanium-rock", "solid", "spaced", 23)