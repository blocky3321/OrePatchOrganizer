data:extend({
    {
        type = "bool-setting",
        name = "resource-patch-organizer-allow-solids",
        setting_type = "startup",
        default_value = true,
        order = "a1",
    },
    {
        type = "bool-setting",
        name = "resource-patch-organizer-allow-fluids",
        setting_type = "startup",
        default_value = true,
        order = "a2",
    },
    {
        type = "int-setting",
        name = "resource-patch-organizer-fluid-grid",
        setting_type = "startup",
        default_value = 6,
        minimum_value = 1,
        maximum_value = 20,
        order = "a3",
    },
    {
        type = "int-setting",
        name = "resource-patch-organizer-special-ore-grid",
        setting_type = "startup",
        default_value = 6,
        minimum_value = 1,
        maximum_value = 20,
        order = "a4",
    },
    {
        type = "bool-setting",
        name = "resource-patch-organizer-lock-surface",
        setting_type = "startup",
        default_value = true,
        order = "a5",
    }
})
