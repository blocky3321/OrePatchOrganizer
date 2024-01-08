data:extend({
    {
        type = "bool-setting",
        name = "resource-patch-organizer-allow-solids",
        setting_type = "runtime-global",
        default_value = true,
        order = "a1",
    },
    {
        type = "bool-setting",
        name = "resource-patch-organizer-allow-fluids",
        setting_type = "runtime-global",
        default_value = true,
        order = "a2",
    },
    {
        type = "int-setting",
        name = "resource-patch-organizer-grid-spacing",
        setting_type = "runtime-global",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 32,
        order = "a3",
    },
    {
        type = "bool-setting",
        name = "resource-patch-organizer-lock-surface",
        setting_type = "runtime-global",
        default_value = true,
        order = "a4",
    },
    {
        type = "bool-setting",
        name = "resource-patch-organizer-allow-mixing",
        setting_type = "runtime-global",
        default_value = true,
        order = "a5",
    }
})
