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
    gameInfo = "VoidHub UI"
})
```

Window options used by the example:

- `name` — main title.
- `suffix` — text displayed beside the title.
- `gameInfo` — information shown in the window.

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

local window = library:window({name = "VoidHub", suffix = "UI", gameInfo = "VoidHub UI"})
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
