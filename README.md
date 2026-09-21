# VoidHub UI

A configurable Lua UI library used by VoidHub.

## Load the library

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"))()
```

The loader expects an environment that supports `loadstring` and `game:HttpGet`.

## Create a window

```lua
local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",
    autoDPI = true,
    customSize = {width = 760, height = 500}
})
```

Window options used by the example:

- `name` — main title.
- `suffix` — text displayed beside the title.
- `gameInfo` — information shown in the window.
- `mobileToggle` — the draggable floating button used to close and reopen the UI on touch-sized screens.

## Auto-DPI and custom size

Auto-DPI is enabled by default. It scales the whole window from the current camera viewport while keeping the layout centered.

```lua
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
    dpiReference = {width = 1920, height = 1080}
})
```

Sizing options:

- `customSize` accepts `{width = 760, height = 600}` or a `UDim2`.
- `width` and `height` can be used instead of `customSize`.
- `autoDPI = false` keeps the window at its configured scale.
- `autoMinimize` can be `true` or `{width = 900, height = 600}`; on small screens it starts the menu hidden and the menu key can reopen it.
- `minimizeWidth` and `minimizeHeight` configure the auto-minimize thresholds.
- `dpiScale` is a manual multiplier applied before the automatic scale.
- `minDPI` and `maxDPI` limit the automatic scale.
- `dpiReference` sets the resolution treated as 1x scale.

You can change the window after creation:

```lua
window:set_size(900, 650)
window:set_size({width = 760, height = 600})
window:set_auto_dpi(false)
window:set_auto_dpi(true)
window:update_dpi()
window:update_auto_minimize()
```

The current scale is available through `window.current_dpi`.

## Mobile floating toggle

The library includes a floating mobile toggle by default. It stays above the UI, can close or reopen the menu, supports touch or mouse dragging, and is hidden on normal desktop resolutions unless `mobileOnly = false`.

A tap toggles the menu only when the button is released without moving. A drag uses its own touch state and is clamped to the screen, so holding or dragging the button cannot accidentally close and reopen the UI. The main window, resize handle, sliders, dropdown options, and color controls also accept touch input.

```lua
local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    mobileToggle = {
        enabled = true,
        icon = "rbxassetid://6034767608",
        shape = "square", -- "square" or "circle"
        size = 54,
        mobileOnly = true,
        showWhenOpen = true,
        draggable = true
    }
})
```

Mobile toggle options:

- `enabled` turns the floating button on or off.
- `icon` accepts any Roblox image asset string.
- `shape` defaults to a soft rounded square; use `"circle"` for a circular button.
- `size` accepts a number, `{width = ..., height = ...}`, or a `UDim2`.
- `position` accepts a `UDim2` or `{x = ..., y = ...}`.
- `showWhenOpen` keeps the button visible while the main UI is open.
- `mobileOnly` limits the button to touch-sized or small viewports.
- `draggable` enables touch/mouse repositioning.
- `window:set_mobile_toggle(false)` or `window:set_mobile_toggle(true)` changes it at runtime.

Touch-friendly sizing is automatic: sliders use a larger invisible touch track while keeping a thin visual line, and hue/alpha bars use larger touch handles. Color and dropdown popups reposition above the control when there is not enough room below it.

## Add tabs

```lua
window:seperator({name = "General"})
local enemies, teammates, selfTab = window:tab({
    name = "Players",
    tabs = {"Enemies", "Teammates", "Self"}
})
```

The method is spelled `seperator` in the library and must be called with that spelling.

## Columns and sections

```lua
local column = enemies:column({scroll = true})
local section = column:section({
    name = "General",
    default = true,
    toggle = false,
    size = 0.5
})
```

- `default` controls whether the section starts open.
- `toggle` controls whether the section can be collapsed.
- `size` controls the section's relative height in its column.
- `autoSize = true` makes the section fit its controls.
- `minHeight` and `maxHeight` set the content viewport limits.
- `scroll = true` makes a column vertically scrollable.

A tab can also contain sub-tabs:

```lua
local page = enemies:sub_tab({order = -10000, size = 2})
```

## Group boxes

Use `groupboxes` to create a four-box layout:

```lua
local boxes = main:groupboxes({
    maxHeight = 260,
    scroll = true,
    boxes = {
        {name = "Combat"},
        {name = "Visuals"},
        {name = "Player"},
        {name = "Settings"}
    }
})

boxes.top_left:toggle({name = "Enable combat", seperator = true})
boxes.top_right:toggle({name = "Player ESP", seperator = true})
boxes.bottom_left:dropdown({
    name = "Movement mode",
    items = {"Walk", "Fly"},
    default = "Walk"
})
boxes.bottom_right:button({
    name = "Save settings",
    callback = function()
        print("Saved")
    end
})
```

The returned boxes are:

- `top_left`
- `top_right`
- `bottom_left`
- `bottom_right`

Each box is a normal section, so it supports the existing controls such as toggles, dropdowns, sliders, color pickers, keybinds, textboxes, labels, and buttons.

Group-box layout behavior:

- Boxes automatically size to the controls inside them instead of using a full-height blank panel.
- `maxHeight` caps a box's visible content area; extra controls scroll inside that box.
- Group boxes automatically resize to their controls, then scroll vertically when the content exceeds `maxHeight`.
- `scroll = true` gives each group-box column its own vertical scrollbar when the page is longer than the window.
- Every group box uses the same control APIs, including dropdowns, sliders, color pickers, keybinds, textboxes, and buttons.
- Use `scroll = false` to disable column scrolling, or `autoSize = false` with `size` when a fixed-height section is needed.

### Collapse group boxes

Group boxes are collapsible by default, matching the reference layout. Use \`collapsed = true\` to start one minimized, or disable the header collapse control with \`disableCollapsing = true\`.

\`\`\`lua
local box = boxes.top_left
box:set_collapsed(true)
box:toggle_collapsed()
box:SetCollapsed(false)
\`\`\`

The header stays visible while the controls are hidden, so the column reflows without leaving a large blank panel. \`box:show()\` and \`box:hide()\` control visibility independently.

### Nested tabboxes

A group box can contain a nested tabbox. Each nested tab has its own normal control layout, including dropdowns, sliders, toggles, color pickers, textboxes, labels, buttons, and keybinds.

\`\`\`lua
local tabs = boxes.bottom_right:AddTabbox({name = "Target modes"})

local target = tabs:AddTab({
    name = "Target",
    icon = "rbxassetid://129380150574313"
})
target:dropdown({
    name = "Target mode",
    items = {"Nearest", "Lowest health", "Crosshair"},
    default = "Nearest"
})

local filters = tabs:AddTab("Filters", "rbxassetid://6022668898")
filters:toggle({name = "Players only"})
filters:colorpicker({name = "Filter color"})
\`\`\`

Aliases are also available: `topLeft`, `topRight`, `bottomLeft`, and `bottomRight`.

For one standalone group box, use:

```lua
local box = column:groupbox({name = "Combat", default = true})
box:toggle({name = "Enable combat"})
```

`groupbox_grid` and `group_boxes` are aliases for `groupboxes`.

## Controls

### Label

```lua
section:label({
    name = "Status",
    info = "Extra information shown below the label."
})
```

### Toggle

```lua
local enabled = section:toggle({
    name = "Enable feature",
    seperator = true,
    info = "Optional help text.",
    callback = function(value)
        print(value)
    end
})
```

### Color picker

Attach a color picker to a toggle or create one inside a section:

```lua
enabled:colorpicker({})
section:toggle({name = "ESP"}):colorpicker({})
```

### Settings sub-section

```lua
local settings = enabled:settings({})
settings:toggle({name = "Show names", seperator = true})
settings:dropdown({
    name = "Font",
    items = {"ProggyTiny", "MonoSpace", "Tahoma"},
    default = "MonoSpace",
    seperator = true
})
settings:colorpicker({name = "Name color", seperator = true})
settings:keybind({
    name = "Toggle key",
    callback = function(value)
        print(value)
    end
})
```

### Dropdown

```lua
section:dropdown({
    name = "Flags",
    items = {"Scoped", "Flashed", "Knocked", "Touched"},
    default = {"Scoped", "Flashed"},
    multi = true,
    seperator = true
})
```

Set `multi = false` or omit it for a single selection.

### Slider

```lua
section:slider({
    name = "Amount",
    min = 0,
    max = 100,
    interval = 1,
    callback = function(value)
        print(value)
    end
})
```

## Save configuration

Call this after creating the complete window:

```lua
library:init_config(window)
```

## Complete group-box and sub-tab example

Each sub-tab can have its own full 2×2 group-box layout. Every returned box is a normal section, so controls work inside all four positions.

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"))()

local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",
    autoDPI = true,
    autoMinimize = {width = 900, height = 600},
    customSize = {width = 760, height = 500},
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

window:seperator({name = "Main"})

-- These are sub-tabs inside the Main tab.
local combat, visuals, settings = window:tab({
    name = "Main",
    icon = "rbxassetid://6034767608",
    tabs = {"Combat", "Visuals", "Settings"}
})

local combatBoxes = combat:groupboxes({
    maxHeight = 260,
    scroll = true,
    boxes = {
        {name = "Auto Farm", icon = "rbxassetid://6034767608"},
        {name = "Targeting", icon = "rbxassetid://6022668898"},
        {name = "Movement", icon = "rbxassetid://129380150574313"},
        {name = "Combat Settings", icon = "rbxassetid://139628202576511"}
    }
})

combatBoxes.top_left:toggle({
    name = "Enable auto farm",
    seperator = true,
    callback = function(enabled)
        print("Auto farm:", enabled)
    end
})

combatBoxes.top_left:dropdown({
    name = "Farm target",
    items = {"Enemies", "Bosses", "Players"},
    default = "Enemies"
})

combatBoxes.top_right:slider({
    name = "Farm distance",
    min = 25,
    max = 500,
    interval = 5
})

combatBoxes.bottom_left:colorpicker({name = "Target color"})

combatBoxes.bottom_right:keybind({
    name = "Combat key",
    callback = function(value)
        print("Combat key:", value)
    end
})

local visualBoxes = visuals:groupbox_grid({
    maxHeight = 260,
    scroll = true,
    boxes = {
        {name = "ESP", icon = "rbxassetid://6022668898"},
        {name = "Players", icon = "rbxassetid://129380150574313"},
        {name = "World", icon = "rbxassetid://6022668898"},
        {name = "Performance", icon = "rbxassetid://139628202576511"}
    }
})

visualBoxes.top_left:toggle({name = "Enable ESP", seperator = true})
visualBoxes.top_right:dropdown({
    name = "ESP mode",
    items = {"Box", "Highlight", "Tracer"},
    default = "Box"
})
visualBoxes.bottom_left:toggle({name = "Player names", seperator = true})
visualBoxes.bottom_right:button({
    name = "Refresh visuals",
    callback = function()
        print("Visuals refreshed")
    end
})

-- The Settings sub-tab is another independent group-box page.
local settingsBoxes = settings:group_boxes({
    maxHeight = 260,
    scroll = true,
    boxes = {
        {name = "Interface"},
        {name = "Theme"},
        {name = "Profile"},
        {name = "About"}
    }
})

settingsBoxes.top_left:keybind({name = "Menu bind"})
settingsBoxes.top_right:colorpicker({name = "Accent color"})
settingsBoxes.bottom_left:textbox({name = "Profile name"})
settingsBoxes.bottom_right:label({
    name = "VoidHub UI",
    info = "All four group boxes support normal controls."
})

library:init_config(window)
```

The complete version of this example is in [Example.lua](Millenium/Example.lua).

## Repository files

- [Library.lua](Millenium/Library.lua)
- [Example.lua](Millenium/Example.lua)
- [LICENSE](LICENSE)

The upstream MIT license and required attribution are preserved in LICENSE.
