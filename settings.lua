data:extend({
    {
        type = "int-setting",
        name = "ore-patch-organizer-grid-cell-size",
        setting_type = "runtime-global",
        -- 3 by default: Electric Miners are 3x3, with 5x5 coverage. 3 = Max Density miners. 5 = Efficient Density miners.
        -- 5 = 2 Miners + belt in the middle
        -- 7 = 2 Miners + belt in the middle and no overlap external
        default_value = 3,
        minimum_value = 1,
        maximum_value = 30,
    },
    {
        type = "bool-setting",
        name = "ore-patch-organizer-chunk-align",
        setting_type = "runtime-global",
        default_value = false
    }
})