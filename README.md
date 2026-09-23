# VoidHub UI

> A responsive Roblox Lua interface library built for clean desktop layouts and touch-first mobile execution.

[![GitHub repository](https://img.shields.io/badge/GitHub-voidhub9--dotcom%2FMellenium--UI---181717?logo=github&logoColor=white)](https://github.com/voidhub9-dotcom/Mellenium-UI-)
[![Roblox Lua](https://img.shields.io/badge/Roblox-Luau-00A2FF?logo=roblox&logoColor=white)](https://create.roblox.com/docs/luau)

VoidHub UI combines a responsive window system, desktop 2×2 group boxes, nested tab boxes, touch-friendly controls, mobile floating controls, configuration storage, themes, notifications, and extension APIs in one library.

## Highlights

| Area | Included |
| --- | --- |
| Responsive UI | Auto-DPI, custom design sizes, automatic minimization, viewport clamping, and resizing |
| Layout | Desktop 2×2 group boxes, mobile single-column reflow, internal scrolling, collapsible sections, and nested sub-tabs |
| Controls | Toggles, sliders, dropdowns, multi-dropdowns, color pickers, text boxes, keybinds, buttons, labels, and status components |
| Mobile | Draggable floating toggle, touch-safe dragging/resizing, mobile-friendly sliders, dropdowns, colors, drawers, and confirmations |
| Productivity | Search, tooltips, dependencies, themes, profiles, progress bars, timers, keybind management, and notification history |
| Persistence | Scoped named configs, import/export, duplication, rename, deletion, and autosave |
| Extensibility | Plugin lifecycle hooks, custom themes, notification center, drawers, and cleanup APIs |

## Contents

- [Installation](#installation)
- [Quick start](#quick-start)
- [Responsive windows](#responsive-windows)
- [Tabs and group boxes](#tabs-and-group-boxes)
- [Controls](#controls)
- [Themes and extensions](#themes-and-extensions)
- [Drawers and confirmations](#drawers-and-confirmations)
- [Notifications](#notifications)
- [Configuration system](#configuration-system)
- [Cleanup](#cleanup)
- [Project files](#project-files)

## Installation

Load the library from the repository's main branch:

~~~lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"
))()
~~~

The target environment must provide loadstring and game:HttpGet.

## Quick start

This is a small, runnable starting point. The full feature example is in [Millenium/Example.lua](Millenium/Example.lua).

~~~lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"
))()

local Window = Library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "Example",
    autoDPI = true,
    autoMinimize = {
        width = 900,
        height = 600
    },
    customSize = {
        width = 760,
        height = 500
    },
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

Window:seperator({name = "Main"})

local Combat, Visuals, Settings = Window:tab({
    name = "Main",
    icon = "rbxassetid://6034767608",
    tabs = {"Combat", "Visuals", "Settings"}
})

local Boxes = Combat:groupboxes({
    maxHeight = 240,
    scroll = true,
    singleColumnWidth = 700,
    boxes = {
        {name = "Auto Farm"},
        {name = "Targeting"},
        {name = "Movement"},
        {name = "Combat Tools"}
    }
})

Boxes.top_left:toggle({
    name = "Enable feature",
    flag = "feature_enabled"
})

Boxes.top_left:slider({
    name = "Amount",
    flag = "feature_amount",
    min = 0,
    max = 100,
    interval = 1,
    default = 50
})
~~~

## Responsive windows

VoidHub uses a design-space size and scales it against the active camera viewport.

~~~lua
Window:set_size(900, 650)
Window:set_auto_dpi(false)
Window:set_auto_dpi(true)
Window:update_dpi()
Window:update_auto_minimize()
~~~

### Window options

| Option | Purpose |
| --- | --- |
| **customSize** | Design size as a width/height table or UDim2 |
| **autoDPI** | Scales the design size to the current viewport |
| **dpiScale** | Manual multiplier applied before automatic scaling |
| **minDPI / maxDPI** | Lower and upper scale limits |
| **dpiReference** | Resolution treated as 1× |
| **autoMinimize** | Starts hidden below a width/height threshold |
| **mobileToggle** | Configures the draggable floating reopen button |

The default mobile toggle is a soft-corner square. Set shape to circle when a circular control is preferred. Taps toggle the window; a drag moves the button without accidentally opening or closing the UI.

The window, resize handle, floating button, drawers, confirmation sheets, and overlays are contained within the visible viewport. Touch input is supported for window dragging, resizing, sliders, dropdowns, color controls, drawers, and confirmations.

## Tabs and group boxes

Group boxes automatically measure their controls. They grow only as needed, scroll when content exceeds maxHeight, and collapse from their header without leaving an oversized empty area.

~~~lua
local Boxes = Combat:groupboxes({
    maxHeight = 240,
    scroll = true,
    responsive = true,
    singleColumnWidth = 700,
    boxes = {
        {
            name = "Auto Farm",
            icon = "rbxassetid://6034767608"
        },
        {
            name = "Targeting",
            icon = "rbxassetid://6034767608"
        },
        {name = "Movement"},
        {name = "Combat Tools"}
    }
})

local AutoFarm = Boxes.top_left
local Targeting = Boxes.top_right
local Movement = Boxes.bottom_left
local CombatTools = Boxes.bottom_right

AutoFarm:SetCollapsed(true)
AutoFarm:ToggleCollapsed()
AutoFarm:SetVisible(true)
~~~

The layout returns top_left, top_right, bottom_left, and bottom_right. Camel-case aliases such as topLeft are also supported.

Desktop uses a full 2×2 layout. On smaller viewports, the grid reflows into a single full-width scrolling column when the viewport reaches singleColumnWidth. Set responsive to false when a fixed four-box layout is required.

Every group box accepts the normal controls and can contain a nested tab box:

~~~lua
local Modes = CombatTools:AddTabbox({
    name = "Target modes",
    icon = "rbxassetid://6034767608"
})

local Players = Modes:AddTab({
    name = "Players",
    icon = "rbxassetid://6034767608"
})

Players:dropdown({
    name = "Target mode",
    items = {"Nearest", "Lowest health", "Crosshair"},
    default = "Nearest"
})
~~~

groupbox_grid and group_boxes are aliases for the same four-section layout.

## Controls

Supported controls include:

- toggle
- slider
- dropdown
- multi_dropdown
- colorpicker
- textbox
- keybind
- button
- label
- list
- progressbar
- status
- timer
- profile

~~~lua
local Enabled = AutoFarm:toggle({
    name = "Enable auto farm",
    flag = "auto_farm",
    info = "Long-press on mobile or hover on desktop for help."
})

AutoFarm:slider({
    name = "Farm distance",
    flag = "farm_distance",
    min = 0,
    max = 100,
    interval = 1,
    default = 25,
    info = "The distance used by the feature."
}):DependsOn("auto_farm", true, "enabled")

local Targets = Targeting:multi_dropdown({
    name = "Targets",
    items = {"Players", "NPCs", "Bosses"},
    default = {"Players"}
})

Targets:SelectAll()
Targets:Clear()
local Matches = Targets:SearchOptions("boss")
~~~

Dependencies support enabled and visible modes and can use a predicate:

~~~lua
AutoFarm:slider({
    name = "Minimum distance",
    flag = "minimum_distance",
    min = 0,
    max = 500,
    default = 100
}):DependsOn("farm_distance", function(value)
    return tonumber(value) and value >= 100
end, "visible")
~~~

### Mobile layout details

- Sliders use a dedicated touch-friendly track row.
- Descriptions sit below the label and above the slider track.
- Current values remain aligned to the right.
- Dropdown triggers use a stable height and option rows.
- Dropdown menus reposition above the trigger when there is not enough room.
- Long labels are truncated instead of overlapping adjacent controls.
- Color pickers and keybind controls use larger touch targets.

## Themes and extensions

Built-in theme presets are Void, Ocean, Emerald, Crimson, and Mono.

~~~lua
Library:ApplyTheme("Ocean")
Library:SetThemeTransparency(0.15)

Library:RegisterTheme("Custom", {
    accent = Color3.fromRGB(255, 120, 190),
    background = Color3.fromRGB(10, 10, 14),
    surface = Color3.fromRGB(18, 18, 24),
    text = Color3.fromRGB(245, 245, 250),
    muted = Color3.fromRGB(145, 145, 155)
})

Library:SetFont(Enum.Font.Code)
~~~

Additional built-in extensions include:

- Search and control filtering
- Desktop hover and mobile long-press tooltips
- Control dependencies and enabled states
- Progress, status, timer, and profile components
- Keybind registry and conflict detection
- Notification history and notification center
- Mobile drawers and confirmation sheets
- Plugin registration and lifecycle cleanup
- Control hover and press animations

Tab badges are intentionally not included.

## Drawers and confirmations

Drawers and confirmation sheets are responsive overlays. They stay inside the scaled window, leave the top drag strip available, resize their scrolling content when the window changes size, and close from the backdrop or close button.

~~~lua
local Drawer = Library:CreateDrawer({
    title = "Quick Actions",
    height = 220,
    build = function(Content, API)
        -- Add Roblox GUI objects to Content.
    end
})

Drawer:Open()
Drawer:Close()
Drawer:Toggle()
Drawer:Destroy()

Library:Confirm({
    title = "Reset settings?",
    message = "This cannot be undone.",
    confirmText = "Reset",
    callback = function()
        print("Confirmed")
    end
})
~~~

## Notifications

Notifications use an Obsidian-inspired compact panel: title, description, optional icon, close control, accent outline, inset progress bar, and right-edge slide animation. They support persistent messages, step progress, sounds, live updates, and mobile-safe stacking.

~~~lua
local Notice = Library:Notify({
    Title = "VoidHub UI",
    Description = "Feature enabled",
    Icon = "success",
    Time = 4,
    Closable = true
})

Notice:ChangeTitle("VoidHub")
Notice:ChangeDescription("Feature updated")
Notice:Destroy()

-- Positional compatibility form
Library:Notify("Hello world!", 4)

local Loading = Library:Notify({
    Title = "Loading",
    Description = "Preparing features...",
    Steps = 10,
    Persist = true
})

Loading:ChangeStep(5)
Loading:Destroy()
~~~

Notification options include Title, Description, Time, Steps, Persist, Closable, Callback, Icon, IconColor, TitleColor, DescriptionColor, SoundId, and Volume.

Lowercase VoidHub aliases such as name, info, and lifetime remain supported for compatibility. Notifications are capped at three visible mobile cards and five desktop cards. Session history is capped at 100 entries.

~~~lua
local Center = Library:CreateNotificationCenter(CombatTools, {
    limit = 5
})

Center:Refresh()
Library:ClearNotificationHistory()
~~~

## Discord webhooks

The library supports executor HTTP request adapters for Discord incoming webhooks. It accepts `request`, `http_request`, `syn.request`, and `http.request` when the target environment exposes one.

~~~lua
Library:ConfigureWebhook({
    url = "https://discord.com/api/webhooks/WEBHOOK_ID/WEBHOOK_TOKEN",
    username = "VoidHub",
    minInterval = 1
})

Library:SendWebhook({
    content = "Feature enabled",
    embeds = {{
        title = "VoidHub",
        description = "A feature was enabled.",
        color = 10158079
    }}
}, function(success, error_message)
    if not success then
        warn(error_message)
    end
end)

Library:TestWebhook()
Library:ClearWebhook()
~~~

Webhook messages are queued per library instance, use `allowed_mentions = {parse = {}}` by default, truncate content to Discord's 2,000-character limit, cap embeds at 10, and retry a Discord 429 once using its returned retry delay. Keep webhook URLs private because the URL contains the webhook token.

## Configuration system

Create the built-in Configs page after all controls have been registered:

~~~lua
Library:init_config(Window)
~~~

Configs support global, game, and custom scopes:

~~~lua
Library:SetConfigScope("game")

local Saved, SaveError = Library:save_config("Main")
local Loaded, LoadError = Library:load_named_config("Main")
local Deleted, DeleteError = Library:delete_config("Main")
local Configs = Library:get_config_list()

Library:DuplicateConfig("Main", "Main Backup")
Library:RenameConfig("Main Backup", "Archived")

local Exported, JSON = Library:ExportConfig("Main")
if Exported then
    Library:ImportConfig("Imported", JSON)
end

Library:EnableAutoSave("Main", 30)
Library:DisableAutoSave()
~~~

Config names are validated and sanitized. Import rejects invalid JSON, and registered setters restore toggles, sliders, dropdowns, colors, keybinds, and text values.

## Plugin API

~~~lua
Library:RegisterPlugin("ExamplePlugin", function(Lib, Context)
    print(Context.message)

    return {
        Unload = function()
            print("Plugin cleaned up")
        end
    }
end)

local OK, Plugin = Library:LoadPlugin("ExamplePlugin", {
    message = "Hello from VoidHub"
})

Library:UnloadPlugin("ExamplePlugin")
~~~

Plugins initialize once, receive the library and a context table, and may expose Unload or unload for cleanup.

## Cleanup

~~~lua
Library:Unload()
~~~

Unload closes the UI, stops autosave loops, unloads plugins, destroys drawers and GUI roots, disconnects tracked listeners, and clears the public references created by the example.

## Project files

| File | Purpose |
| --- | --- |
| [Millenium/Library.lua](Millenium/Library.lua) | Main UI library |
| [Millenium/Example.lua](Millenium/Example.lua) | Complete feature example |
| [LICENSE](LICENSE) | Project license |

For the complete runnable implementation, open [Millenium/Example.lua](Millenium/Example.lua).
