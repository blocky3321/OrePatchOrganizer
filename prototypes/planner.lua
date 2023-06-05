data:extend({
    {
        type = "selection-tool",
        name = "ore-patch-organizer",
        icon = "__OrePatchOrganizer__/organizer.png",
        icon_size = 64,
        icon_mipmaps = 6,
        flags = {
            "only-in-cursor",
            "spawnable",
            "not-stackable"
        },
        subgroup = "tool",
        order = "c[automated-construction]-a[oreorganizer]",
        stack_size = 1,
        stackable = false,
        selection_color = { r = 1, g = 0, b = 0 },
        alt_selection_color = { r = 0, g = 1, b = 0 },
        selection_mode = { "any-entity" },
        alt_selection_mode = { "any-entity" },
        selection_cursor_box_type = "copy",
        alt_selection_cursor_box_type = "blueprint-snap-rectangle", --blueprint-snap-rectangle to have round numbers
        entity_filter_mode = "whitelist",
        alt_entity_filter_mode = "whitelist"
    },
    {
        type = "shortcut",
        name = "ore-patch-organizer",
        icon = {
            filename = "__OrePatchOrganizer__/organizer.png",
            size = 64,
            flags = {
                "mipmap"
            },
            mipmaps = 4,
        },
        order = "o[ore-organizer]",
        action = "spawn-item",
        localised_name = { "item-name.ore-patch-organizer" },
        -- technology_to_unlock = "oil-processing",
        item_to_spawn = "ore-patch-organizer",
        style = "blue",
    }
})
