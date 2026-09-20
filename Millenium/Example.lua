local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"))()

local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",
    autoDPI = true,
    autoMinimize = {width = 900, height = 600},
    customSize = {width = 760, height = 600},
    dpiScale = 1,
    minDPI = 0.55,
    maxDPI = 1.15,
    mobileToggle = {
        enabled = true,
        icon = "rbxassetid://6034767608",
        shape = "square",
        size = 54,
        mobileOnly = true,
        showWhenOpen = true,
        draggable = true
    }
})

local icons = {
    combat = "rbxassetid://6034767608",
    visual = "rbxassetid://6022668898",
    settings = "rbxassetid://139628202576511",
    player = "rbxassetid://129380150574313"
}

window:seperator({name = "Main"})

-- One top-level tab can contain multiple sub-tabs.
local combat, visuals, settings = window:tab({
    name = "Main",
    icon = icons.combat,
    tabs = {"Combat", "Visuals", "Settings"}
})

-- Combat sub-tab: four full group boxes.
-- Each box sizes itself from its controls; long content scrolls.
local combat_boxes = combat:groupboxes({
    maxHeight = 260,
    scroll = true,
    boxes = {
        {name = "Auto Farm", icon = icons.combat},
        {name = "Targeting", icon = icons.player},
        {name = "Movement", icon = icons.visual},
        {name = "Combat Settings", icon = icons.settings}
    }
})

combat_boxes.top_left:toggle({
    name = "Enable auto farm",
    flag = "auto_farm",
    seperator = true,
    callback = function(enabled)
        print("Auto farm:", enabled)
    end
})

combat_boxes.top_left:dropdown({
    name = "Farm target",
    items = {"Enemies", "Bosses", "Players"},
    default = "Enemies",
    seperator = true
})

combat_boxes.top_right:toggle({name = "Auto attack", seperator = true})
combat_boxes.top_right:toggle({name = "Auto parry", seperator = true})
combat_boxes.top_right:keybind({
    name = "Combat key",
    callback = function(value)
        print("Combat key:", value)
    end
})

combat_boxes.bottom_left:slider({
    name = "Farm distance",
    min = 25,
    max = 500,
    interval = 5,
    callback = function(value)
        print("Distance:", value)
    end
})

combat_boxes.bottom_left:dropdown({
    name = "Movement mode",
    items = {"Tween", "Instant"},
    default = "Tween"
})

combat_boxes.bottom_right:colorpicker({
    name = "Target color",
    callback = function(value)
        print("Target color:", value)
    end
})

combat_boxes.bottom_right:button({
    name = "Reset combat settings",
    callback = function()
        print("Combat settings reset")
    end
})

-- Visuals sub-tab: another complete four-box layout.
local visual_boxes = visuals:groupbox_grid({
    maxHeight = 260,
    scroll = true,
    boxes = {
        {name = "ESP", icon = icons.visual},
        {name = "Players", icon = icons.player},
        {name = "World", icon = icons.visual},
        {name = "Performance", icon = icons.settings}
    }
})

visual_boxes.top_left:toggle({name = "Enable ESP", seperator = true})
visual_boxes.top_left:dropdown({
    name = "ESP mode",
    items = {"Box", "Highlight", "Tracer"},
    default = "Box"
})
visual_boxes.top_right:toggle({name = "Player names", seperator = true})
visual_boxes.top_right:toggle({name = "Health bars", seperator = true})
visual_boxes.bottom_left:toggle({name = "World items", seperator = true})
visual_boxes.bottom_left:colorpicker({name = "ESP color"})
visual_boxes.bottom_right:slider({
    name = "Render distance",
    min = 100,
    max = 2000,
    interval = 50
})

-- Settings sub-tab: group boxes can contain config controls too.
local settings_boxes = settings:group_boxes({
    maxHeight = 260,
    scroll = true,
    boxes = {
        {name = "Interface", icon = icons.settings},
        {name = "Theme", icon = icons.visual},
        {name = "Profile", icon = icons.player},
        {name = "About", icon = icons.combat}
    }
})

settings_boxes.top_left:keybind({
    name = "Menu bind",
    callback = function(value)
        print("Menu bind:", value)
    end
})

settings_boxes.top_left:toggle({name = "Show notifications", seperator = true})
settings_boxes.top_right:colorpicker({name = "Accent color"})
settings_boxes.bottom_left:textbox({
    name = "Profile name",
    flag = "profile_name"
})
settings_boxes.bottom_left:button({
    name = "Save profile",
    callback = function()
        print("Profile saved")
    end
})
settings_boxes.bottom_right:label({
    name = "VoidHub UI",
    info = "Four group boxes, nested sub-tabs, icons, and working controls."
})

library:init_config(window)
