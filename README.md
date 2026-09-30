# VoidHub UI

A Roblox **Luau** UI library for script executors. Responsive windows that work on desktop and touch, a full control set, saved configs, themes, notifications and a small plugin system, all in one file.

[![GitHub repository](https://img.shields.io/badge/GitHub-voidhub9--dotcom%2FMellenium--UI---181717?logo=github&logoColor=white)](https://github.com/voidhub9-dotcom/Mellenium-UI-)
[![Roblox Luau](https://img.shields.io/badge/Roblox-Luau-00A2FF?logo=roblox&logoColor=white)](https://create.roblox.com/docs/luau)

**Runtime:** Roblox executor environment. The library needs `getgenv`, `loadstring`, `game:HttpGet`, and the file functions `makefolder`, `isfolder`, `writefile`, `readfile`, `isfile`, `listfiles`, `delfile` (used only for configs). The UI is parented to `CoreGui`.

## Contents

- [Install](#install)
- [Quick start](#quick-start)
- [Window](#window)
- [Window lock](#window-lock)
- [Tabs and layout](#tabs-and-layout)
- [Controls](#controls)
- [Search, tooltips and dependencies](#search-tooltips-and-dependencies)
- [Themes and readability](#themes-and-readability)
- [Notifications](#notifications)
- [Drawers and confirmations](#drawers-and-confirmations)
- [Configs](#configs)
- [Discord webhooks](#discord-webhooks)
- [Plugins](#plugins)
- [Cleanup](#cleanup)
- [Project files](#project-files)

## Install

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"
))()
```

Methods are called with a colon (`Library:window(...)`). A few have PascalCase aliases (`Notify`, `Unload`, `AddSearch`, `Confirm`, `SetLocked` …); the tables below list the names that exist.

## Quick start

A minimal window. The full feature tour lives in [`Millenium/Example.lua`](Millenium/Example.lua).

```lua
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"
))()

local Window = Library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "My Game",
    lockButton = true,              -- padlock that freezes move/resize
    customSize = {width = 760, height = 500},
})

Window:seperator({name = "Main"})   -- (sic) the method is spelled "seperator"

local Combat, Visuals = Window:tab({
    name = "Main",
    icon = "rbxassetid://6034767608",
    tabs = {"Combat", "Visuals"},
})

local Boxes = Combat:groupboxes({
    boxes = {{name = "Auto Farm"}, {name = "Targeting"}, {name = "Movement"}, {name = "Tools"}},
})

Boxes.top_left:toggle({name = "Enable", flag = "farm", default = true})
Boxes.top_left:slider({name = "Distance", flag = "distance", min = 0, max = 100, default = 25})

Library:init_config(Window)         -- adds the Configs page (call last)
```

## Window

`Library:window(options)` builds the main window and returns the window object.

| Option | Type | Purpose |
| --- | --- | --- |
| `name`, `suffix` | string | Title text (`name` is underlined, `suffix` is white) |
| `gameInfo` | string | Subtitle under the title |
| `customSize` | `{width, height}` or `UDim2` | Design size of the window |
| `autoDPI` | bool | Scale the window to the viewport |
| `dpiScale` | number | Manual multiplier applied before auto scaling |
| `minDPI`, `maxDPI` | number | Scale limits |
| `dpiReference` | size | Resolution treated as 1x |
| `autoMinimize` | `{width, height}` | Start hidden below this viewport size |
| `mobileToggle` | table | Floating reopen button (see below) |
| `lockButton` / `lock_button` | bool or table | Padlock, see [Window lock](#window-lock) |
| `locked` | bool | Start locked |
| `closeButton` | bool | Show the close button (default `true`) |
| `closeMode` | `"hide"` or `"unload"` | What the close button does |

The window, resize handle, floating button, drawers and overlays are clamped to the visible viewport. Dragging and resizing accept mouse and touch.

```lua
Window:set_size(900, 650)
Window:set_auto_dpi(true)
Window.toggle_menu(true)     -- show / hide (also bound to the "Menu Bind" keybind in Configs)
```

`mobileToggle = {enabled, icon, shape = "square" | "circle", size, mobileOnly, showWhenOpen, draggable}` configures the draggable floating button. Taps toggle the window; dragging moves the button without toggling.

## Window lock

The lock stops anyone (you included) from accidentally moving or resizing the window.

```lua
local Window = Library:window({
    name = "VoidHub",
    lockButton = {
        enabled = true,          -- show the padlock (default true when a table is given)
        draggable = true,        -- the padlock itself can be dragged (default true)
        position = {20, 200},    -- {x, y} offset in pixels or a UDim2; default: beside the window
        locked = false,          -- start locked
        notify = false,          -- show a small notification on every toggle
        callback = function(locked) print("locked:", locked) end,
    },
})
```

What locking does:

- Window dragging is disabled and the **resize handle is hidden**.
- The padlock is drawn from frames (no emoji font needed): a closed shackle in your accent colour when locked, an open shackle when unlocked. Hovering shows a tooltip.
- The padlock hides together with the menu, so it never floats around on its own.

Control it from code:

```lua
Window:set_locked(true)     -- also :SetLocked(true)
Window:toggle_locked()      -- also :ToggleLocked()
print(Window:is_locked())   -- also :IsLocked()
```

## Tabs and layout

```lua
local A, B, C = Window:tab({name = "Main", icon = "rbxassetid://…", tabs = {"A", "B", "C"}})
```

`Window:tab` returns one sub-tab object per name in `tabs`.

### Group boxes (2x2 grid)

```lua
local Boxes = A:groupboxes({
    maxHeight = 240,           -- boxes scroll past this height
    scroll = true,
    responsive = true,         -- collapse to one column on small viewports
    singleColumnWidth = 700,
    boxes = {{name = "One"}, {name = "Two"}, {name = "Three"}, {name = "Four"}},
})

Boxes.top_left:toggle({name = "Hello"})
-- also: top_right, bottom_left, bottom_right
```

`groupbox_grid` and `group_boxes` are aliases. Each box supports `:SetCollapsed(bool)`, `:ToggleCollapsed()` and `:SetVisible(bool)`.

### Columns and sections (manual layout)

```lua
local Column  = A:column({})
local Section = Column:section({name = "Aimbot", size = 1, default = true, side = "left"})
```

### Nested tab boxes

```lua
local Modes  = Boxes.top_right:AddTabbox({name = "Target modes"})
local Target = Modes:AddTab({name = "Target"})
Target:dropdown({name = "Mode", items = {"Nearest", "Lowest health"}})
```

## Controls

All controls are created on a section or group box and return the control object. Every control accepts a `flag` (config key), a `callback`, and `info` (tooltip text).

| Control | Key options | Notes |
| --- | --- | --- |
| `toggle` | `name`, `flag`, `default`, `type = "toggle" \| "checkbox"`, `seperator` | Defaults to the **switch** style. `.set(bool)` |
| `slider` | `min`, `max`, `interval`, `default`, `suffix` | Value is clamped to `min..max`; `min == max` is safe. `.set(number)` |
| `dropdown` | `items`, `default`, `multi` | `.set(value)`, `.refresh_options(items)` |
| `multi_dropdown` | `items`, `default = {…}` | Select all, clear and `:SearchOptions(text)` |
| `colorpicker` | `color`, `alpha`, `name` | Saturation/value pad, hue and alpha bars, RGBA text box |
| `textbox` | `placeholder`, `default` | |
| `keybind` | `key`, `mode = "Toggle" \| "Hold" \| "Always"` | Right-click (long-press on touch) for the mode list |
| `button` | `callback`, `confirm`, `confirmMode = "hold"` | `confirm = true` shows a confirm sheet first |
| `label` | `name`, `info` | Text with an optional description line |
| `list` | `options` | Single-select list |
| `progressbar` | `min`, `max`, `default` | `:Set(value)` |
| `status` | `name`, `default`, `color` | `:Set(text, color)` |
| `timer` | `duration`, `callback`, `autoStart` | `:Start()`, `:Stop()`, `:Reset()` |
| `profile` | `name`, `image` | Avatar, FPS, ping and executor |

```lua
local Farm = Box:toggle({name = "Auto farm", flag = "farm", default = true})
Farm.set(false)                       -- programmatic change (runs the callback)

Box:slider({name = "Speed", min = 16, max = 100, interval = 2, default = 32, suffix = " sp"})
Box:multi_dropdown({name = "Targets", items = {"Players", "NPCs", "Bosses"}, default = {"Players"}})
Box:keybind({name = "Fly", flag = "fly_key", mode = "Toggle", callback = function(active) end})
Box:button({name = "Reset", confirm = true, confirmMessage = "Reset everything?", callback = reset})
```

Read any flag with `Library.flags.farm` (or the `flags` table returned by the library). Keybind flags are tables `{key, mode, active}`; colour flags are `{Color, Transparency}`.

## Search, tooltips and dependencies

```lua
Window:AddSearch({placeholder = "Search features..."})   -- filters every registered control

Control:SetTooltip("Explains the control")               -- hover on desktop, long-press on touch
Control:SetVisible(false)
Control:SetEnabled(false)                                -- dims and blocks input

Slider:DependsOn("farm", true, "enabled")                -- enabled only while flag "farm" is true
Slider:DependsOn("distance", function(v) return v >= 100 end, "visible")
```

## Themes and readability

Text on dark surfaces meets at least a 4.5:1 contrast ratio by default: primary text `245`, secondary text about `170`, inactive text about `150`, placeholders `140` on the `33` control background. Switch tracks and outlines have distinct off states so a toggle is readable at a glance.

```lua
Library:ApplyTheme("Ocean")             -- Void, Ocean, Emerald, Crimson, Mono
Library:SetThemeTransparency(0.15)
Library:update_theme("accent", Color3.fromRGB(255, 120, 190))   -- accent only

Library:RegisterTheme("Custom", {
    accent = Color3.fromRGB(255, 120, 190),
    background = Color3.fromRGB(10, 10, 14),
    panel = Color3.fromRGB(16, 16, 22),
    surface = Color3.fromRGB(20, 20, 28),
    control = Color3.fromRGB(28, 28, 38),
    text = Color3.fromRGB(245, 245, 250),
    muted = Color3.fromRGB(170, 170, 180),
})

Library:SetFont(Font.fromEnum(Enum.Font.Code))
```

Add a preset picker with `Section:theme_manager({default = "Void"})`. When you register a custom theme keep text and background at least 4.5:1 apart.

## Notifications

```lua
local Notice = Library:Notify({
    Title = "VoidHub",
    Description = "Feature enabled",
    Icon = "success",        -- info | success | warning | error, or any short text
    Time = 4,
    Closable = true,
})

Notice:ChangeTitle("Done")
Notice:ChangeDescription("All good")
Notice:Close()

Library:Notify("Hello", 3)   -- positional shorthand: text, seconds
```

Options: `Title`, `Description`, `Time`, `Persist`, `Steps` (progress notification; use `:ChangeStep(n)`), `Closable`, `Callback`, `Icon`, `IconColor`, `TitleColor`, `DescriptionColor`, `SoundId`, `Volume`, `Width`. Lowercase `name`, `info` and `lifetime` work too. At most 5 cards are shown on desktop and 3 on mobile. History is kept (100 entries): `Library:GetNotificationHistory()`, `Library:ClearNotificationHistory()`, `Library:CreateNotificationCenter(section, {limit = 5})`.

## Drawers and confirmations

```lua
local Drawer = Library:CreateDrawer({
    title = "Quick actions",
    height = 220,
    build = function(Content, Api) --[[ parent your own Instances to Content ]] end,
})
Drawer:Open(); Drawer:Close(); Drawer:Toggle(); Drawer:Destroy()

Library:Confirm({
    title = "Reset settings?",
    message = "This cannot be undone.",
    confirmText = "Reset",
    cancelText = "Cancel",
    callback = function() end,
    onCancel = function() end,
})
```

Drawers stay inside the window, follow it when it is resized, and close from the backdrop or the close button.

## Configs

```lua
Library:init_config(Window)     -- adds a "Configs" page: list, name box, Save / Load / Delete, accent, menu bind
```

```lua
Library:SetConfigScope("game")  -- "global" (default), "game", or any custom name

local ok, name = Library:save_config("Main")
local ok, name = Library:load_named_config("Main")
local ok, name = Library:delete_config("Main")
local list     = Library:get_config_list()

Library:DuplicateConfig("Main", "Backup")
Library:RenameConfig("Backup", "Archive")
local ok, json = Library:ExportConfig("Main")
Library:ImportConfig("Shared", json)

Library:EnableAutoSave("Main", 30)   -- every 30s (minimum 5)
Library:DisableAutoSave()
```

Names are sanitised, imports must be valid JSON, and the setters registered by each control restore toggles, sliders, dropdowns, colours, keybinds and text boxes. Configs live in `milenium/configs/` inside the executor workspace.

## Discord webhooks

```lua
Library:ConfigureWebhook({url = "https://discord.com/api/webhooks/ID/TOKEN", username = "VoidHub"})
Library:SendWebhook({content = "Hello", embeds = {{title = "VoidHub", description = "Started"}}},
    function(ok, err) if not ok then warn(err) end end)
Library:TestWebhook()
Library:ClearWebhook()
```

Requests use whichever of `request`, `http_request`, `syn.request` or `http.request` the executor provides. Messages are queued, rate-limited, sent with `allowed_mentions = {parse = {}}`, truncated to Discord's limits, and retried once on HTTP 429. Only `discord.com` / `discordapp.com` webhook URLs are accepted. The URL contains a secret token, so keep it private.

## Plugins

```lua
Library:RegisterPlugin("Example", function(Lib, Context)
    print(Context.message)
    return {Unload = function() print("cleaned up") end}
end)

Library:LoadPlugin("Example", {message = "hi"})
Library:UnloadPlugin("Example")
```

## Cleanup

```lua
Library:Unload()
```

Unloading closes the UI, stops autosave and timers, unloads plugins, disconnects every tracked listener and destroys the GUI roots, including the lock and mobile toggle.

## Project files

| File | Purpose |
| --- | --- |
| [`Millenium/Library.lua`](Millenium/Library.lua) | The library |
| [`Millenium/Example.lua`](Millenium/Example.lua) | Runnable example using every control |
| [`LICENSE`](LICENSE) | License |
