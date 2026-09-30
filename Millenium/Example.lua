local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"))()

local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",
    footer = "v1.0",
    -- X asks "Unload?" in a centred dialog. Use closeMode = "hide" to only hide the window.
    closeMode = "unload",
    autoDPI = true,
    autoMinimize = {width = 900, height = 600},
    customSize = {width = 760, height = 500},
    dpiScale = 1,
    minDPI = 0.65,
    maxDPI = 1.15,
    -- Padlock button: freezes dragging and resizing. Draggable, remembers nothing between runs.
    lockButton = {
        enabled = true,
        draggable = true,
        notify = false,
        callback = function(locked)
            print("Window locked:", locked)
        end
    },
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
-- Boxes collapse from their headers and stretch with the window, scrolling inside when needed.
local combatBoxes = combat:groupboxes({
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

-- Extra control showcase in Combat > Tools
combatBoxes.bottom_right:label({name = "Controls showcase", info = "Everything below is live."})
combatBoxes.bottom_right:toggle({name = "Checkbox style", type = "checkbox", flag = "demo_checkbox", seperator = true})
combatBoxes.bottom_right:textbox({name = "Webhook name", placeholder = "type here...", flag = "demo_text"})
combatBoxes.bottom_right:dropdown({
    name = "Priority",
    flag = "demo_priority",
    items = {"Low", "Normal", "High", "Critical"},
    default = "Normal"
})
combatBoxes.bottom_right:multi_dropdown({
    name = "Notify on",
    flag = "demo_notify",
    items = {"Kill", "Death", "Level up", "Drop", "Boss"},
    default = {"Kill", "Drop", "Boss"}
})
combatBoxes.bottom_right:colorpicker({name = "Highlight", flag = "demo_color"})
combatBoxes.bottom_right:button({
    name = "Show confirm dialog",
    callback = function()
        library:Confirm({
            title = "Are you sure?",
            message = "This is the centred confirmation dialog used by the X button and confirm buttons.",
            confirmText = "Yes",
            callback = function()
                library:Notify({name = "Confirm", info = "Confirmed", type = "success"})
            end
        })
    end
})

local visualBoxes = visuals:groupbox_grid({
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

-- Canvas: free-layout surface, positions are in text-line units
local demoCanvas = visualBoxes.bottom_left:canvas({
    name = "Canvas demo",
    search = true,
    placeholder = "Filter rows...",
    textScale = 0.84,
    minLines = 8,
    maxLines = 14
})
demoCanvas:SetDock(1.4, {Gap = 0.4, DividerColor = Color3.fromRGB(70, 70, 70)})
local dockLabel = demoCanvas:Text({Parent = demoCanvas:Dock(), X = 0.2, Y = 0.1, Text = "<b>Rows</b> 0", Color = "#F5F5F5"})
local rows = {}
for index, name in {"Common egg", "Rare egg", "Epic egg", "Mythic egg", "Lab egg", "Fuse egg"} do
    local y = 0.2 + (index - 1) * 1.6
    rows[name] = {
        frame = demoCanvas:Frame({X = 0, Y = y, Height = 1.4, Corner = 0.3, Background = "#1A1A1A", StrokeColor = "#3A3A3A", StrokeThickness = 0.06}),
        label = demoCanvas:Text({X = 0.5, Y = y + 0.2, Height = 1, Width = 10, Text = name, Color = "#DCDCDC"})
    }
end
demoCanvas:OnSearch(function(query)
    local visible, shown = string.lower(query), 0
    for name, row in rows do
        local match = visible == "" or string.find(string.lower(name), visible, 1, true) ~= nil
        row.frame.Set({Visible = match})
        row.label.Set({Visible = match})
        if match then shown += 1 end
    end
    dockLabel.Set({Text = "<b>Rows</b> " .. shown})
end)
dockLabel.Set({Text = "<b>Rows</b> 6"})

local settingsBoxes = settings:group_boxes({
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

-- Adds the Configs page (Profiles + Interface) after all flags exist.
library:init_config(window)

-- Tab helpers
window:select_tab("Main", "Combat")

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
