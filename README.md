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
    customSize = {width = 760, height = 600}
})
```

Window options used by the example:

- `name` — main title.
- `suffix` — text displayed beside the title.
- `gameInfo` — information shown in the window.

## Auto-DPI and custom size

Auto-DPI is enabled by default. It scales the whole window from the current camera viewport while keeping the layout centered.

```lua
local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",

    autoDPI = true,
    customSize = {width = 760, height = 600},
    dpiScale = 1,
    minDPI = 0.55,
    maxDPI = 1.15,
    dpiReference = {width = 1920, height = 1080}
})
```

Sizing options:

- `customSize` accepts `{width = 760, height = 600}` or a `UDim2`.
- `width` and `height` can be used instead of `customSize`.
- `autoDPI = false` keeps the window at its configured scale.
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
```

The current scale is available through `window.current_dpi`.

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
local column = enemies:column({})
local section = column:section({
    name = "General",
    default = true,
    toggle = false,
    size = 0.5
})
```

- `default` controls whether the section starts open.
- `toggle` controls whether the section can be collapsed.
- `size` controls the section width.

A tab can also contain sub-tabs:

```lua
local page = enemies:sub_tab({order = -10000, size = 2})
```

## Group boxes

Use `groupboxes` to create a four-box layout:

```lua
local boxes = main:groupboxes({
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

## Complete starter example

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/voidhub9-dotcom/Mellenium-UI-/refs/heads/main/Millenium/Library.lua"))()

local window = library:window({
    name = "VoidHub",
    suffix = "UI",
    gameInfo = "VoidHub UI",
    autoDPI = true,
    customSize = {width = 700, height = 565}
})
window:seperator({name = "Main"})
local main = window:tab({name = "Main", tabs = {"Home"}})
local column = main:column({})
local section = column:section({name = "Controls", default = true})

section:label({name = "Welcome", info = "VoidHub UI is loaded."})
section:toggle({
    name = "Example toggle",
    seperator = true,
    callback = function(value)
        print("Toggle:", value)
    end
})

library:init_config(window)
```

## Repository files

- [Library.lua](Millenium/Library.lua)
- [Example.lua](Millenium/Example.lua)
- [LICENSE](LICENSE)

The upstream MIT license and required attribution are preserved in LICENSE.
