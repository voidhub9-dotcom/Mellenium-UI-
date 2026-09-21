local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"))()

local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",
    autoDPI = true,
    autoMinimize = {width = 900, height = 600},
    customSize = {width = 760, height = 500},
    dpiScale = 1,
    minDPI = 0.65,
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

-- Search filters controls across every group box.
window:AddSearch({placeholder = "Search features..."})
window:seperator({name = "Main"})

-- One top-level group tab with three sub-tabs.
local combat, visuals, settings = window:tab({
    name = "Main",
    icon = icons.combat,
    tabs = {"Combat", "Visuals", "Settings"}
})

-- Each page uses a complete responsive 2x2 group-box layout.
-- Boxes collapse from their headers, fit their controls, and scroll at maxHeight.
local combatBoxes = combat:groupboxes({
    maxHeight = 240,
    scroll = true,
    singleColumnWidth = 700,
    boxes = {
        {name = "Auto Farm", icon = icons.combat},
        {name = "Targeting", icon = icons.player},
        {name = "Movement", icon = icons.visual},
        {name = "Combat Tools", icon = icons.settings}
    }
})

local autoFarm = combatBoxes.top_left:toggle({
    name = "Enable auto farm",
    flag = "auto_farm",
    seperator = true,
    info = "Controls every linked farming option.",
    callback = function(enabled)
        library:Notify({
            name = "Auto Farm",
            info = enabled and "Enabled" or "Disabled",
            type = enabled and "success" or "warning"
        })
    end
})

combatBoxes.top_left:multi_dropdown({
    name = "Farm targets",
    flag = "farm_targets",
    items = {"Enemies", "Bosses", "Players"},
    default = {"Enemies"},
    info = "Multi-select includes Select All, Clear, and option filtering."
}):DependsOn("auto_farm", true, "enabled")

combatBoxes.top_left:dropdown({
    name = "Farm mode",
    flag = "farm_mode",
    items = {"Tween", "Pathfind", "Instant"},
    default = "Tween"
}):DependsOn("auto_farm", true, "enabled")

combatBoxes.top_right:toggle({
    name = "Auto attack",
    flag = "auto_attack",
    seperator = true
}):DependsOn("auto_farm", true, "enabled")

combatBoxes.top_right:toggle({
    name = "Auto parry",
    flag = "auto_parry",
    seperator = true
}):DependsOn("auto_farm", true, "enabled")

combatBoxes.top_right:keybind({
    name = "Combat key",
    flag = "combat_key",
    callback = function(value)
        print("Combat key:", value)
    end
})

combatBoxes.bottom_left:slider({
    name = "Farm distance",
    flag = "farm_distance",
    min = 25,
    max = 500,
    interval = 5,
    default = 100,
    info = "The larger touch track makes this mobile friendly."
}):DependsOn("auto_farm", true, "enabled")

combatBoxes.bottom_left:dropdown({
    name = "Movement mode",
    items = {"Tween", "Instant"},
    default = "Tween"
})

local farmProgress = combatBoxes.bottom_left:progressbar({
    name = "Farm progress",
    min = 0,
    max = 100,
    default = 35
})

local combatStatus = combatBoxes.bottom_right:status({
    name = "Combat",
    default = "Ready",
    color = Color3.fromRGB(92, 220, 140)
})

local cooldown = combatBoxes.bottom_right:timer({
    name = "Ability cooldown",
    duration = 10
})

combatBoxes.bottom_right:button({
    name = "Start demo",
    callback = function()
        farmProgress:Set(100)
        combatStatus:Set("Running", Color3.fromRGB(92, 220, 140))
        cooldown:Start()
    end
})

combatBoxes.bottom_right:button({
    name = "Reset combat settings",
    callback = function()
        library:Confirm({
            title = "Reset combat?",
            message = "This resets the demo combat controls.",
            confirmText = "Reset",
            callback = function()
                autoFarm.set(false)
                farmProgress:Set(0)
                combatStatus:Set("Ready")
                cooldown:Reset()
                library:Notify({name = "Combat", info = "Settings reset", type = "success"})
            end
        })
    end
})

-- Nested tabs work inside any group box.
local targetModes = combatBoxes.top_right:AddTabbox({name = "Target modes"})
local targetTab = targetModes:AddTab({name = "Target", icon = icons.player})
targetTab:dropdown({
    name = "Target mode",
    items = {"Nearest", "Lowest health", "Crosshair"},
    default = "Nearest"
})
local filtersTab = targetModes:AddTab({name = "Filters", icon = icons.visual})
filtersTab:toggle({name = "Players only", seperator = true})
filtersTab:colorpicker({name = "Filter color"})

local visualBoxes = visuals:groupbox_grid({
    maxHeight = 240,
    scroll = true,
    singleColumnWidth = 700,
    boxes = {
        {name = "ESP", icon = icons.visual},
        {name = "Players", icon = icons.player},
        {name = "World", icon = icons.visual},
        {name = "Performance", icon = icons.settings}
    }
})

visualBoxes.top_left:toggle({name = "Enable ESP", flag = "esp_enabled", seperator = true})
visualBoxes.top_left:dropdown({
    name = "ESP mode",
    items = {"Box", "Highlight", "Tracer"},
    default = "Box"
})
visualBoxes.top_left:colorpicker({name = "ESP color"})

visualBoxes.top_right:toggle({name = "Player names", seperator = true})
visualBoxes.top_right:toggle({name = "Health bars", seperator = true})
visualBoxes.top_right:slider({name = "Text size", min = 10, max = 24, default = 14})

visualBoxes.bottom_left:toggle({name = "World items", seperator = true})
visualBoxes.bottom_left:multi_dropdown({
    name = "World filters",
    items = {"Chests", "Drops", "NPCs", "Doors"},
    default = {"Chests", "Drops"}
})

visualBoxes.bottom_right:slider({
    name = "Render distance",
    min = 100,
    max = 2000,
    interval = 50,
    default = 500
})
visualBoxes.bottom_right:status({name = "Renderer", default = "60 FPS"})

local settingsBoxes = settings:group_boxes({
    maxHeight = 240,
    scroll = true,
    singleColumnWidth = 700,
    boxes = {
        {name = "Interface", icon = icons.settings},
        {name = "Theme", icon = icons.visual},
        {name = "Profile", icon = icons.player},
        {name = "Extensions", icon = icons.combat}
    }
})

settingsBoxes.top_left:keybind({
    name = "Menu bind",
    flag = "menu_bind"
})
settingsBoxes.top_left:toggle({name = "Show notifications", flag = "show_notifications", default = true, seperator = true})

local mobileDrawer = library:CreateDrawer({
    title = "Quick Actions",
    height = 190,
    build = function(content, drawer)
        local text = library:create("TextLabel", {
            Parent = content,
            Size = UDim2.new(1, -8, 0, 44),
            BackgroundTransparency = 1,
            Text = "A touch-friendly bottom drawer for mobile actions.",
            TextColor3 = Color3.fromRGB(225, 225, 230),
            TextWrapped = true,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            ZIndex = 74
        })
        local close = library:create("TextButton", {
            Parent = content,
            Size = UDim2.new(1, -8, 0, 38),
            BackgroundColor3 = Color3.fromRGB(42, 42, 46),
            BorderSizePixel = 0,
            Text = "Done",
            TextColor3 = Color3.fromRGB(245, 245, 245),
            Font = Enum.Font.GothamMedium,
            TextSize = 14,
            ZIndex = 74
        })
        library:create("UICorner", {Parent = close, CornerRadius = UDim.new(0, 8)})
        library:connection(close.Activated, function()
            drawer:Close()
        end)
    end
})

settingsBoxes.top_left:button({
    name = "Open mobile drawer",
    callback = function()
        mobileDrawer:Open()
    end
})

settingsBoxes.top_left:button({
    name = "Unload UI",
    callback = function()
        library:Confirm({
            title = "Unload VoidHub UI?",
            message = "This removes every UI object and disconnects all listeners.",
            confirmText = "Unload",
            callback = function()
                library:Unload()
            end
        })
    end
})

settingsBoxes.top_right:theme_manager({
    name = "Theme preset",
    default = "Void",
    transparency = 0
})
settingsBoxes.top_right:colorpicker({
    name = "Custom accent",
    callback = function(color)
        library:update_theme("accent", color)
    end
})

settingsBoxes.bottom_left:profile({name = "VoidHub User"})
settingsBoxes.bottom_left:textbox({
    name = "Profile name",
    flag = "profile_name"
})

local keybindManager = library:CreateKeybindManager(settingsBoxes.bottom_left)
settingsBoxes.bottom_left:button({
    name = "Refresh keybind list",
    callback = function()
        keybindManager:Refresh()
        local conflicts = library:FindKeybindConflicts()
        library:Notify({
            name = "Keybind Manager",
            info = #conflicts == 0 and "No conflicts found" or (#conflicts .. " conflict(s) found"),
            type = #conflicts == 0 and "success" or "warning"
        })
    end
})

library:RegisterPlugin("ExamplePlugin", function(_, context)
    print("ExamplePlugin loaded:", context.message)
    return {
        Unload = function()
            print("ExamplePlugin unloaded")
        end
    }
end)

settingsBoxes.bottom_right:button({
    name = "Load example plugin",
    callback = function()
        local ok, result = library:LoadPlugin("ExamplePlugin", {message = "Hello from VoidHub"})
        library:Notify({
            name = "Plugin",
            info = ok and "ExamplePlugin loaded" or tostring(result),
            type = ok and "success" or "error"
        })
    end
})

settingsBoxes.bottom_right:button({
    name = "Unload example plugin",
    callback = function()
        local ok, result = library:UnloadPlugin("ExamplePlugin")
        library:Notify({
            name = "Plugin",
            info = ok and "ExamplePlugin unloaded" or tostring(result),
            type = ok and "success" or "error"
        })
    end
})

settingsBoxes.bottom_right:button({
    name = "Test notification",
    callback = function()
        library:Notify({
            name = "VoidHub UI",
            info = "Notifications are saved in the session history.",
            type = "info",
            lifetime = 4
        })
    end
})

local notificationCenter = library:CreateNotificationCenter(settingsBoxes.bottom_right, {limit = 3})
settingsBoxes.bottom_right:button({
    name = "Refresh notification history",
    callback = function()
        notificationCenter:Refresh()
    end
})

-- Adds the built-in Save, Load, and Delete config page after all flags exist.
library:init_config(window)

-- Advanced config helpers:
-- library:SetConfigScope("game")
-- library:DuplicateConfig("Main", "Main Backup")
-- library:RenameConfig("Main Backup", "Archived")
-- local ok, json = library:ExportConfig("Main")
-- library:ImportConfig("Imported", json)
-- library:EnableAutoSave("Main", 30)
-- library:DisableAutoSave()

getgenv().VoidHubUI = {
    library = library,
    window = window,
    mobileDrawer = mobileDrawer,
    combatBoxes = combatBoxes,
    visualBoxes = visualBoxes,
    settingsBoxes = settingsBoxes
}
