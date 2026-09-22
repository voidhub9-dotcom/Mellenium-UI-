# VoidHub UI

A responsive Roblox Lua UI library for desktop and mobile. It includes auto-DPI, draggable mobile controls, collapsible group boxes, nested tabboxes, configs, themes, search, notifications, extension APIs, and complete cleanup.

## Quick start

\`\`\`lua
local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"
))()

local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",
    autoDPI = true,
    autoMinimize = {width = 900, height = 600},
    customSize = {width = 760, height = 500},
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
\`\`\`

The loader requires an environment with \`loadstring\` and \`game:HttpGet\`.

## Responsive window and mobile support

Auto-DPI scales the configured window to the current camera viewport and keeps it centered. The example uses a 760×500 design size and scales down to 65% on a 640×360 mobile viewport.

\`\`\`lua
window:set_size(900, 650)
window:set_auto_dpi(false)
window:set_auto_dpi(true)
window:update_dpi()
window:update_auto_minimize()
\`\`\`

Useful window options:

- \`customSize\`: a \`{width, height}\` table or \`UDim2\`.
- \`autoDPI\`: enables viewport scaling.
- \`dpiScale\`: manual multiplier applied before automatic scaling.
- \`minDPI\` and \`maxDPI\`: scale limits.
- \`dpiReference\`: resolution treated as 1×.
- \`autoMinimize\`: starts hidden below a resolution threshold.
- \`mobileToggle\`: configures the floating reopen button.

The floating button distinguishes taps from drags, stays clamped to the viewport, and supports a rounded square or circle. The main window and resize handle are also clamped to every viewport edge, including mobile safe-area offsets. Drawers and confirmation sheets stay inside the scaled window, leave the top drag strip available, and resize their scrolling content to fit. Sliders, dropdowns, color controls, window dragging, resizing, drawers, and confirmation sheets use touch input.

## Tabs, sub-tabs, and group boxes

\`\`\`lua
window:seperator({name = "Main"})

local combat, visuals, settings = window:tab({
    name = "Main",
    icon = "rbxassetid://6034767608",
    tabs = {"Combat", "Visuals", "Settings"}
})

local boxes = combat:groupboxes({
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
\`\`\`

The returned sections are \`top_left\`, \`top_right\`, \`bottom_left\`, and \`bottom_right\`. Camel-case aliases such as \`topLeft\` also work.

Group boxes:

- Size themselves from their controls.
- Scroll internally when their content exceeds \`maxHeight\`.
- Collapse from the header without leaving blank space.
- Use a clean 2×2 layout on desktop.
- Reflow into one full-width scrolling column when the viewport reaches \`singleColumnWidth\` (700 is recommended for touch screens; desktop can use 520).
- Keep the 2×2 layout available with \`responsive = false\` or a lower threshold.
- Accept all normal controls.
- Support icons instead of long names.
- Support nested tabboxes.

\`\`\`lua
boxes.top_left:SetCollapsed(true)
boxes.top_left:ToggleCollapsed()
boxes.top_left:SetVisible(true)

local modes = boxes.bottom_right:AddTabbox({name = "Target modes"})
local target = modes:AddTab({name = "Target"})
target:dropdown({
    name = "Target mode",
    items = {"Nearest", "Lowest health", "Crosshair"},
    default = "Nearest"
})
\`\`\`

Aliases \`groupbox_grid\` and \`group_boxes\` create the same four-box layout.

## Controls

Every group box or section supports:

- \`toggle\`
- \`slider\`
- \`dropdown\`
- \`multi_dropdown\`
- \`colorpicker\`
- \`textbox\`
- \`keybind\`
- \`button\`
- \`label\`
- \`list\`
- \`progressbar\`
- \`status\`
- \`timer\`
- \`profile\`

\`\`\`lua
local master = boxes.top_left:toggle({
    name = "Enable feature",
    flag = "feature_enabled",
    seperator = true,
    info = "Long-press on mobile or hover on desktop for help."
})

boxes.top_left:slider({
    name = "Amount",
    flag = "feature_amount",
    min = 0,
    max = 100,
    interval = 1,
    default = 50
}):DependsOn("feature_enabled", true, "enabled")

local targets = boxes.top_left:multi_dropdown({
    name = "Targets",
    items = {"Players", "NPCs", "Bosses"},
    default = {"Players"}
})

targets:SelectAll()
targets:Clear()
local matches = targets:SearchOptions("boss")
\`\`\`

Dependencies can use \`"enabled"\` or \`"visible"\` mode. They may also receive a predicate:

\`\`\`lua
control:DependsOn("distance", function(value)
    return tonumber(value) and value >= 100
end, "visible")
\`\`\`

## Slider and dropdown layout

Sliders use a fixed touch-friendly track row. If \`info\` is supplied, the description is placed below the label and above the track, while the current value stays aligned on the right.

Dropdowns use a fixed 25px trigger and stable 30px option rows. Their popup repositions above the trigger when it would run off-screen, and long labels are truncated instead of overlapping nearby controls.

## Search and tooltips

\`\`\`lua
local search = window:AddSearch({placeholder = "Search features..."})
local matches = window:SearchControls("farm")
window:SearchControls("")

control:SetTooltip("Shown on hover or mobile long-press.")
control:SetVisible(true)
control:SetEnabled(true)
\`\`\`

## Themes

Built-in presets are \`Void\`, \`Ocean\`, \`Emerald\`, \`Crimson\`, and \`Mono\`.

\`\`\`lua
library:ApplyTheme("Ocean")
library:SetThemeTransparency(0.15)

library:RegisterTheme("Custom", {
    accent = Color3.fromRGB(255, 120, 190),
    background = Color3.fromRGB(14, 14, 18),
    surface = Color3.fromRGB(24, 24, 30),
    text = Color3.fromRGB(245, 245, 250),
    muted = Color3.fromRGB(145, 145, 155)
})

boxes.top_right:theme_manager({
    name = "Theme preset",
    default = "Void",
    transparency = 0
})
\`\`\`

\`library:SetFont(font)\` changes the font used by existing UI text.

## Drawers and confirmation sheets

\`\`\`lua
local drawer = library:CreateDrawer({
    title = "Quick Actions",
    height = 220,
    build = function(content, api)
        -- Add Roblox GUI objects to content.
    end
})

drawer:Open()
drawer:Close()
drawer:Toggle()
drawer:Destroy()

library:Confirm({
    title = "Reset settings?",
    message = "This cannot be undone.",
    confirmText = "Reset",
    callback = function()
        print("Confirmed")
    end
})
\`\`\`

Drawers use a bottom-sheet layout on mobile, animate open and closed, scroll when needed, and close from the backdrop or close button.

## Status components

\`\`\`lua
local progress = boxes.bottom_left:progressbar({
    name = "Loading",
    min = 0,
    max = 100,
    default = 25
})
progress:Set(80)

local state = boxes.bottom_left:status({
    name = "Service",
    default = "Ready"
})
state:Set("Online", Color3.fromRGB(80, 220, 140))

local timer = boxes.bottom_left:timer({
    name = "Cooldown",
    duration = 10
})
timer:Start()
timer:Stop()
timer:Reset()

boxes.bottom_left:profile({name = "VoidHub User"})
\`\`\`

The profile card displays the local avatar and updates FPS, ping, and executor information.

## Notifications and keybind manager

Notifications follow Obsidian's panel layout and support its naming style. Lowercase VoidHub aliases such as `name`, `info`, and `lifetime` remain compatible.

```lua
local notification = library:Notify({
    Title = "VoidHub UI",
    Description = "Feature enabled",
    Icon = "success",
    Time = 4,
    Closable = true
})

notification:ChangeTitle("VoidHub")
notification:ChangeDescription("Feature updated")
notification:Destroy()

-- Quick positional form
library:Notify("Hello world!", 4)

-- Persistent and step-based notifications
local progress = library:Notify({
    Title = "Loading",
    Description = "Preparing features...",
    Steps = 10,
    Persist = true
})

progress:ChangeStep(5)
progress:Destroy()

local center = library:CreateNotificationCenter(boxes.bottom_right, {limit = 5})
center:Refresh()
library:ClearNotificationHistory()

local manager = library:CreateKeybindManager(boxes.bottom_right)
manager:Refresh()

local conflicts = library:FindKeybindConflicts()
local keybinds = library:GetKeybinds()
```

Notifications use Obsidian-style padding, double outlines, monospaced title and description text, an inset accent progress bar, right-edge slide animations, optional icons and close controls, sounds, persistence, and live updates. Mobile shows up to three notifications; desktop shows up to five.

Notification history is session-local and capped at 100 entries.

## Configuration system

Add the built-in Configs page after creating all controls:

\`\`\`lua
library:init_config(window)
\`\`\`

Direct config methods:

\`\`\`lua
library:SetConfigScope("game") -- "global", "game", or a custom scope

local saved, name = library:save_config("Main")
local loaded, loadError = library:load_named_config("Main")
local deleted, deleteError = library:delete_config("Main")
local configs = library:get_config_list()

library:DuplicateConfig("Main", "Main Backup")
library:RenameConfig("Main Backup", "Archived")

local exported, json = library:ExportConfig("Main")
if exported then
    library:ImportConfig("Imported", json)
end

library:EnableAutoSave("Main", 30)
library:DisableAutoSave()
\`\`\`

Config names are validated and sanitized. Import rejects invalid JSON. Color values, keybinds, toggles, sliders, dropdowns, and text flags are serialized through their registered setters.

## Plugin API

\`\`\`lua
library:RegisterPlugin("ExamplePlugin", function(lib, context)
    print(context.message)

    return {
        Unload = function()
            print("Plugin cleaned up")
        end
    }
end)

local ok, plugin = library:LoadPlugin("ExamplePlugin", {
    message = "Hello from VoidHub"
})

library:UnloadPlugin("ExamplePlugin")
\`\`\`

Plugins initialize once, receive the library and a context table, and may expose \`Unload\` or \`unload\` for cleanup.

## Cleanup

\`\`\`lua
library:Unload()
\`\`\`

Unload closes the UI, disables autosave loops, unloads plugins, destroys drawers and GUI roots, disconnects tracked listeners, and clears the public global references created by the example.

## Included extension suite

- Responsive single-column group boxes
- Search and control filtering
- Desktop/mobile tooltips
- Control dependencies and enabled state
- Theme presets and custom themes
- Advanced config management and autosave
- Multi-dropdown helpers
- Mobile drawers and confirmations
- Progress, status, timer, and profile components
- Keybind registry and conflict detection
- Notification history and notification center
- Plugin registration and lifecycle
- Control hover/press animations
- Complete unload cleanup

Tab badges are intentionally not included.

## Full example

The complete, runnable example is in [Millenium/Example.lua](Millenium/Example.lua).

Repository files:

- [Library.lua](Millenium/Library.lua)
- [Example.lua](Millenium/Example.lua)
- [LICENSE](LICENSE)
