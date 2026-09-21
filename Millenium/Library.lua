--[[

    VoidHub UI
    -> Original implementation by @finobe
    -> Adapted for VoidHub
]]

-- Variables 
    local uis = game:GetService("UserInputService") 
    local players = game:GetService("Players") 
    local ws = game:GetService("Workspace")
    local rs = game:GetService("ReplicatedStorage")
    local http_service = game:GetService("HttpService")
    local gui_service = game:GetService("GuiService")
    local lighting = game:GetService("Lighting")
    local run = game:GetService("RunService")
    local stats = game:GetService("Stats")
    local coregui = game:GetService("CoreGui")
    local debris = game:GetService("Debris")
    local tween_service = game:GetService("TweenService")
    local sound_service = game:GetService("SoundService")

    local vec2 = Vector2.new
    local vec3 = Vector3.new
    local dim2 = UDim2.new
    local dim = UDim.new 
    local rect = Rect.new
    local cfr = CFrame.new
    local empty_cfr = cfr()
    local point_object_space = empty_cfr.PointToObjectSpace
    local angle = CFrame.Angles
    local dim_offset = UDim2.fromOffset

    local color = Color3.new
    local rgb = Color3.fromRGB
    local hex = Color3.fromHex
    local hsv = Color3.fromHSV
    local rgbseq = ColorSequence.new
    local rgbkey = ColorSequenceKeypoint.new
    local numseq = NumberSequence.new
    local numkey = NumberSequenceKeypoint.new

    local camera = ws.CurrentCamera
    local lp = players.LocalPlayer 
    local mouse = lp:GetMouse() 
    local function get_gui_offset()
        local top_left = gui_service:GetGuiInset()
        return top_left and top_left.Y or 0
    end

    local max = math.max 
    local floor = math.floor 
    local min = math.min 
    local abs = math.abs 
    local noise = math.noise
    local rad = math.rad 
    local random = math.random 
    local pow = math.pow 
    local sin = math.sin 
    local pi = math.pi 
    local tan = math.tan 
    local atan2 = math.atan2 
    local clamp = math.clamp 

    local insert = table.insert 
    local find = table.find 
    local remove = table.remove
    local concat = table.concat
-- 

-- Library init
    getgenv().library = {
        directory = "milenium",
        folders = {
            "/fonts",
            "/configs",
        },
        flags = {},
        config_flags = {},
        connections = {},   
        notifications = {notifs = {}},
        current_open; 
    }

    local themes = {
        preset = {
            accent = rgb(155, 150, 219),
        }, 

        utility = {
            accent = {
                BackgroundColor3 = {}, 	
                TextColor3 = {}, 
                ImageColor3 = {}, 
                ScrollBarImageColor3 = {} 
            },
        }
    }

    local keys = {
        [Enum.KeyCode.LeftShift] = "LS",
        [Enum.KeyCode.RightShift] = "RS",
        [Enum.KeyCode.LeftControl] = "LC",
        [Enum.KeyCode.RightControl] = "RC",
        [Enum.KeyCode.Insert] = "INS",
        [Enum.KeyCode.Backspace] = "BS",
        [Enum.KeyCode.Return] = "Ent",
        [Enum.KeyCode.LeftAlt] = "LA",
        [Enum.KeyCode.RightAlt] = "RA",
        [Enum.KeyCode.CapsLock] = "CAPS",
        [Enum.KeyCode.One] = "1",
        [Enum.KeyCode.Two] = "2",
        [Enum.KeyCode.Three] = "3",
        [Enum.KeyCode.Four] = "4",
        [Enum.KeyCode.Five] = "5",
        [Enum.KeyCode.Six] = "6",
        [Enum.KeyCode.Seven] = "7",
        [Enum.KeyCode.Eight] = "8",
        [Enum.KeyCode.Nine] = "9",
        [Enum.KeyCode.Zero] = "0",
        [Enum.KeyCode.KeypadOne] = "Num1",
        [Enum.KeyCode.KeypadTwo] = "Num2",
        [Enum.KeyCode.KeypadThree] = "Num3",
        [Enum.KeyCode.KeypadFour] = "Num4",
        [Enum.KeyCode.KeypadFive] = "Num5",
        [Enum.KeyCode.KeypadSix] = "Num6",
        [Enum.KeyCode.KeypadSeven] = "Num7",
        [Enum.KeyCode.KeypadEight] = "Num8",
        [Enum.KeyCode.KeypadNine] = "Num9",
        [Enum.KeyCode.KeypadZero] = "Num0",
        [Enum.KeyCode.Minus] = "-",
        [Enum.KeyCode.Equals] = "=",
        [Enum.KeyCode.Tilde] = "~",
        [Enum.KeyCode.LeftBracket] = "[",
        [Enum.KeyCode.RightBracket] = "]",
        [Enum.KeyCode.RightParenthesis] = ")",
        [Enum.KeyCode.LeftParenthesis] = "(",
        [Enum.KeyCode.Semicolon] = ",",
        [Enum.KeyCode.Quote] = "'",
        [Enum.KeyCode.BackSlash] = "\\",
        [Enum.KeyCode.Comma] = ",",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Slash] = "/",
        [Enum.KeyCode.Asterisk] = "*",
        [Enum.KeyCode.Plus] = "+",
        [Enum.KeyCode.Period] = ".",
        [Enum.KeyCode.Backquote] = "`",
        [Enum.UserInputType.MouseButton1] = "MB1",
        [Enum.UserInputType.MouseButton2] = "MB2",
        [Enum.UserInputType.MouseButton3] = "MB3",
        [Enum.KeyCode.Escape] = "ESC",
        [Enum.KeyCode.Space] = "SPC",
    }
        
    library.__index = library

    for _, path in next, library.folders do 
        makefolder(library.directory .. path)
    end

    local flags = library.flags 
    local config_flags = library.config_flags
    local notifications = library.notifications 

    local fonts = {}; do
        function Register_Font(Name, Weight, Style, Asset)
            if not isfile(Asset.Id) then
                writefile(Asset.Id, Asset.Font)
            end

            if isfile(Name .. ".font") then
                delfile(Name .. ".font")
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = "Normal",
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Asset.Id),
                    },
                },
            }

            writefile(Name .. ".font", http_service:JSONEncode(Data))

            return getcustomasset(Name .. ".font");
        end
        
        local Medium = Register_Font("Medium", 200, "Normal", {
            Id = "Medium.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-Medium.ttf"),
        })

        local SemiBold = Register_Font("SemiBold", 200, "Normal", {
            Id = "SemiBold.ttf",
            Font = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/Inter_28pt-SemiBold.ttf"),
        })

        fonts = {
            small = Font.new(Medium, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
            font = Font.new(SemiBold, Enum.FontWeight.Regular, Enum.FontStyle.Normal);
        }
    end
--

-- Library functions 
    -- Misc functions
        function library:tween(obj, properties, easing_style, time) 
            local tween = tween_service:Create(obj, TweenInfo.new(time or 0.25, easing_style or Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, 0, false, 0), properties):Play()
                
            return tween
        end

        function library:resizify(frame) 
            local Frame = Instance.new("TextButton")
            Frame.Position = dim2(1, -20, 1, -20)
            Frame.BorderColor3 = rgb(0, 0, 0)
            Frame.Size = dim2(0, 20, 0, 20)
            Frame.BorderSizePixel = 0
            Frame.BackgroundColor3 = rgb(255, 255, 255)
            Frame.Parent = frame
            Frame.BackgroundTransparency = 1
            Frame.Text = ""
            Frame.Active = true
            Frame.Selectable = false
            Frame.ZIndex = 20

            local resizing = false
            local active_input
            local resize_input
            local start_size
            local start
            local og_size = frame.Size

            local function is_press(input)
                return input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
            end

            local function stop_resize(input)
                if not active_input then
                    return
                end

                if input and input ~= active_input and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end

                resizing = false
                active_input = nil
                resize_input = nil
            end

            library:connection(Frame.InputBegan, function(input)
                if is_press(input) then
                    resizing = true
                    active_input = input
                    resize_input = nil
                    start = input.Position
                    start_size = frame.Size
                end
            end)

            library:connection(Frame.InputChanged, function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                    resize_input = input
                end
            end)

            library:connection(uis.InputChanged, function(input)
                if not resizing or not active_input then
                    return
                end

                local is_mouse_drag = active_input.UserInputType == Enum.UserInputType.MouseButton1
                    and input.UserInputType == Enum.UserInputType.MouseMovement
                local is_touch_drag = active_input.UserInputType == Enum.UserInputType.Touch
                    and (input == active_input or input == resize_input)

                if not (is_mouse_drag or is_touch_drag) then
                    return
                end

                local current_camera = ws.CurrentCamera or camera
                local viewport = current_camera and current_camera.ViewportSize
                if not viewport then
                    return
                end

                local scale_object = frame:FindFirstChildOfClass("UIScale")
                local ui_scale = scale_object and scale_object.Scale or 1
                ui_scale = ui_scale > 0 and ui_scale or 1

                local current_size = dim2(
                    start_size.X.Scale,
                    math.clamp(
                        start_size.X.Offset + (input.Position.X - start.X) / ui_scale,
                        og_size.X.Offset,
                        viewport.X / ui_scale
                    ),
                    start_size.Y.Scale,
                    math.clamp(
                        start_size.Y.Offset + (input.Position.Y - start.Y) / ui_scale,
                        og_size.Y.Offset,
                        viewport.Y / ui_scale
                    )
                )

                frame.Size = current_size
            end)

            library:connection(uis.InputEnded, function(input)
                if active_input and (input == active_input
                    or (active_input.UserInputType == Enum.UserInputType.MouseButton1
                        and input.UserInputType == Enum.UserInputType.MouseButton1)) then
                    stop_resize(input)
                end
            end)
        end 

        function fag(tbl)
            local Size = 0
            
            for _ in tbl do
                Size = Size + 1
            end
        
            return Size
        end
        
        function library:next_flag()
            local index = fag(library.flags) + 1;
            local str = string.format("flagnumber%s", index)
            
            return str;
        end 

        function library:mouse_in_frame(uiobject)
            local y_cond = uiobject.AbsolutePosition.Y <= mouse.Y and mouse.Y <= uiobject.AbsolutePosition.Y + uiobject.AbsoluteSize.Y
            local x_cond = uiobject.AbsolutePosition.X <= mouse.X and mouse.X <= uiobject.AbsolutePosition.X + uiobject.AbsoluteSize.X

            return (y_cond and x_cond)
        end

        function library:draggify(frame)
            frame.Active = true
            local dragging = false
            local active_input
            local drag_input
            local drag_start
            local frame_start
            local moved = false

            local function is_press(input)
                return input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
            end

            local function stop_drag(input)
                if not active_input then
                    return
                end

                if input and input ~= active_input and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    return
                end

                dragging = false
                active_input = nil
                drag_input = nil
                moved = false
            end

            library:connection(frame.InputBegan, function(input)
                if not is_press(input) then
                    return
                end

                dragging = true
                active_input = input
                drag_input = nil
                drag_start = input.Position
                frame_start = frame.AbsolutePosition
                moved = false
            end)

            library:connection(frame.InputChanged, function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                    drag_input = input
                end
            end)

            library:connection(uis.InputChanged, function(input)
                if not dragging or not active_input then
                    return
                end

                local is_mouse_drag = active_input.UserInputType == Enum.UserInputType.MouseButton1
                    and input.UserInputType == Enum.UserInputType.MouseMovement
                local is_touch_drag = active_input.UserInputType == Enum.UserInputType.Touch
                    and (input == active_input or input == drag_input)

                if not (is_mouse_drag or is_touch_drag) then
                    return
                end

                local delta = vec2(input.Position.X - drag_start.X, input.Position.Y - drag_start.Y)
                if abs(delta.X) < 3 and abs(delta.Y) < 3 then
                    return
                end

                moved = true
                local current_camera = ws.CurrentCamera or camera
                local viewport = current_camera and current_camera.ViewportSize
                if not viewport then
                    return
                end

                local parent_position = vec2(0, 0)
                local parent_size = viewport
                local parent = frame.Parent
                if parent and parent:IsA("GuiObject") then
                    parent_position = parent.AbsolutePosition
                    parent_size = parent.AbsoluteSize
                end

                local frame_size = frame.AbsoluteSize
                local target = frame_start + delta
                local x = clamp(target.X - parent_position.X, 0, max(0, parent_size.X - frame_size.X))
                local y = clamp(target.Y - parent_position.Y, 0, max(0, parent_size.Y - frame_size.Y))
                local parent_inset_y = parent and parent:IsA("ScreenGui") and get_gui_offset() or 0

                frame.Position = dim_offset(x, y + parent_inset_y)
                library:close_element()
            end)

            library:connection(uis.InputEnded, function(input)
                if active_input and (input == active_input
                    or (active_input.UserInputType == Enum.UserInputType.MouseButton1
                        and input.UserInputType == Enum.UserInputType.MouseButton1)) then
                    stop_drag(input)
                end
            end)
        end 

        function library:convert(str)
            local values = {}

            for value in string.gmatch(str, "[^,]+") do
                insert(values, tonumber(value))
            end
            
            if #values == 4 then              
                return unpack(values)
            else 
                return
            end
        end
        
        function library:convert_enum(enum)
            local enum_parts = {}
        
            for part in string.gmatch(enum, "[%w_]+") do
                insert(enum_parts, part)
            end
        
            local enum_table = Enum
            for i = 2, #enum_parts do
                local enum_item = enum_table[enum_parts[i]]
        
                enum_table = enum_item
            end
        
            return enum_table
        end

        local config_holder;

        local function trim_config_name(value)
            return tostring(value or ""):match("^%s*(.-)%s*$")
        end

        local function sanitize_config_name(value)
            local name = trim_config_name(value)

            if string.lower(string.sub(name, -4)) == ".cfg" then
                name = string.sub(name, 1, -5)
            end

            name = name:gsub("[\\/:*?\"<>|]", "_")
            name = name:gsub("%.+$", "")
            name = trim_config_name(name)

            if name == "" then
                return nil
            end

            return name
        end

        function library:get_config_path(name)
            local safe_name = sanitize_config_name(name)
            if not safe_name then
                return nil, nil
            end

            return library.directory .. "/configs/" .. safe_name .. ".cfg", safe_name
        end

        function library:get_config_list()
            local configs = {}
            local seen = {}
            local ok, files = pcall(listfiles, library.directory .. "/configs")

            if not ok or type(files) ~= "table" then
                return configs
            end

            for _, file in files do
                local normalized = tostring(file):gsub("\\", "/")
                local name = normalized:match("([^/]+)%.cfg$")

                if name and not seen[name] then
                    seen[name] = true
                    configs[#configs + 1] = name
                end
            end

            table.sort(configs, function(a, b)
                return string.lower(a) < string.lower(b)
            end)

            return configs
        end

        function library:update_config_list(preferred)
            local list = library:get_config_list()

            if config_holder then
                config_holder.refresh_options(list, sanitize_config_name(preferred))
            end

            return list
        end

        function library:get_config()
            local config = {}

            for flag, value in next, flags do
                if flag ~= "config_name_list" and flag ~= "config_name_text" then
                    if type(value) == "table" and value.key ~= nil then
                        config[flag] = {
                            active = value.active == true,
                            mode = value.mode,
                            key = value.key and tostring(value.key) or "NONE"
                        }
                    elseif type(value) == "table" and value.Transparency ~= nil and typeof(value.Color) == "Color3" then
                        config[flag] = {
                            Transparency = value.Transparency,
                            Color = value.Color:ToHex()
                        }
                    else
                        config[flag] = value
                    end
                end
            end

            return http_service:JSONEncode(config)
        end

        function library:load_config(config_json)
            local decoded, config = pcall(function()
                return http_service:JSONDecode(config_json)
            end)

            if not decoded or type(config) ~= "table" then
                return false, "Invalid config data"
            end

            for flag, value in config do
                if flag ~= "config_name_list" and flag ~= "config_name_text" then
                    local setter = library.config_flags[flag]

                    if setter then
                        local applied, apply_error = pcall(function()
                            if type(value) == "table" and value.Transparency ~= nil and value.Color then
                                setter(hex(value.Color), value.Transparency)
                            else
                                setter(value)
                            end
                        end)

                        if not applied then
                            return false, "Failed to apply " .. tostring(flag) .. ": " .. tostring(apply_error)
                        end
                    end
                end
            end

            return true
        end

        function library:save_config(name)
            local path, safe_name = library:get_config_path(name)
            if not path then
                return false, "Enter a config name"
            end

            local saved, save_error = pcall(function()
                writefile(path, library:get_config())
            end)

            if not saved then
                return false, tostring(save_error)
            end

            flags.config_name_list = safe_name
            library:update_config_list(safe_name)
            return true, safe_name
        end

        function library:load_named_config(name)
            local path, safe_name = library:get_config_path(name)
            if not path then
                return false, "Select a config"
            end

            if isfile and not isfile(path) then
                return false, "Config does not exist"
            end

            local read_ok, contents = pcall(readfile, path)
            if not read_ok then
                return false, tostring(contents)
            end

            local loaded, load_error = library:load_config(contents)
            if not loaded then
                return false, load_error
            end

            flags.config_name_list = safe_name
            library:update_config_list(safe_name)
            return true, safe_name
        end

        function library:delete_config(name)
            local path, safe_name = library:get_config_path(name)
            if not path then
                return false, "Select a config"
            end

            if isfile and not isfile(path) then
                return false, "Config does not exist"
            end

            local deleted, delete_error = pcall(delfile, path)
            if not deleted then
                return false, tostring(delete_error)
            end

            if flags.config_name_list == safe_name then
                flags.config_name_list = nil
            end

            library:update_config_list()
            return true, safe_name
        end

        function library:round(number, float) 
            local multiplier = 1 / (float or 1)

            return floor(number * multiplier + 0.5) / multiplier
        end 

        function library:apply_theme(instance, theme, property) 
            insert(themes.utility[theme][property], instance)
        end

        function library:update_theme(theme, color)
            for _, property in themes.utility[theme] do 

                for m, object in property do 
                    if object[_] == themes.preset[theme] then 
                        object[_] = color 
                    end 
                end 
            end 

            themes.preset[theme] = color 
        end 

        function library:connection(signal, callback)
            local connection = signal:Connect(callback)
            
            insert(library.connections, connection)

            return connection 
        end

        function library:close_element(new_path) 
            local open_element = library.current_open

            if open_element and new_path ~= open_element then
                open_element.set_visible(false)
                open_element.open = false;
            end 

            if new_path ~= open_element then 
                library.current_open = new_path or nil;
            end
        end 

        function library:create(instance, options)
            local ins = Instance.new(instance) 
            
            for prop, value in options do 
                ins[prop] = value
            end
            
            return ins 
        end

        function library:unload_menu() 
            if library[ "items" ] then 
                library[ "items" ]:Destroy()
            end

            if library[ "other" ] then 
                library[ "other" ]:Destroy()
            end 
            
            if library[ "mobile_toggle" ] then
                library[ "mobile_toggle" ]:Destroy()
            end

            for index, connection in library.connections do 
                connection:Disconnect() 
                connection = nil 
            end
            
            library = nil 
        end 
    --
    
    -- Library element functions
        function library:window(properties)
            properties = properties or {}

            local function resolve_window_size(value, fallback_width, fallback_height)
                if typeof(value) == "UDim2" then
                    return value
                end

                if type(value) == "table" then
                    local width = tonumber(value.width or value.Width or value.x or value.X or value[1])
                    local height = tonumber(value.height or value.Height or value.y or value.Y or value[2])

                    if width or height then
                        return dim2(0, width or fallback_width, 0, height or fallback_height)
                    end
                end

                return nil
            end

            local mobile_toggle = properties.mobile_toggle
            if mobile_toggle == nil then
                mobile_toggle = properties.mobileToggle
            end
            if mobile_toggle == nil then
                mobile_toggle = true
            end

            local mobile_options
            if type(mobile_toggle) == "table" then
                mobile_options = mobile_toggle
            else
                mobile_options = {enabled = mobile_toggle}
            end

            local mobile_enabled = mobile_options.enabled
            if mobile_enabled == nil then
                mobile_enabled = mobile_options.Enabled
            end
            if mobile_enabled == nil then
                mobile_enabled = true
            end

            local mobile_only = mobile_options.mobile_only
            if mobile_only == nil then
                mobile_only = mobile_options.mobileOnly
            end
            if mobile_only == nil then
                mobile_only = true
            end

            local mobile_show_when_open = mobile_options.show_when_open
            if mobile_show_when_open == nil then
                mobile_show_when_open = mobile_options.showWhenOpen
            end
            if mobile_show_when_open == nil then
                mobile_show_when_open = true
            end

            local mobile_draggable = mobile_options.draggable
            if mobile_draggable == nil then
                mobile_draggable = mobile_options.Draggable
            end
            if mobile_draggable == nil then
                mobile_draggable = true
            end

            local mobile_icon = mobile_options.icon or mobile_options.Icon or mobile_options.image or mobile_options.Image or "rbxassetid://6034767608"
            local mobile_shape = string.lower(tostring(mobile_options.shape or mobile_options.Shape or "square"))
            local mobile_size = resolve_window_size(mobile_options.size or mobile_options.Size, 54, 54)

            if not mobile_size then
                local numeric_size = tonumber(mobile_options.size or mobile_options.Size) or 54
                mobile_size = dim2(0, numeric_size, 0, numeric_size)
            end

            local mobile_position = mobile_options.position or mobile_options.Position
            if typeof(mobile_position) ~= "UDim2" then
                if type(mobile_position) == "table" then
                    local position_x = tonumber(mobile_position.x or mobile_position.X or mobile_position[1]) or 24
                    local position_y = tonumber(mobile_position.y or mobile_position.Y or mobile_position[2]) or 240
                    mobile_position = dim2(0, position_x, 0, position_y)
                else
                    mobile_position = dim2(0, 24, 0, 240)
                end
            end

            local mobile_corner_radius = tonumber(mobile_options.corner_radius or mobile_options.cornerRadius) or 12
            local mobile_background = mobile_options.background or mobile_options.backgroundColor or mobile_options.BackgroundColor
            if typeof(mobile_background) ~= "Color3" then
                mobile_background = themes.preset.accent
            end

            local mobile_image_color = mobile_options.image_color or mobile_options.imageColor or mobile_options.ImageColor
            if typeof(mobile_image_color) ~= "Color3" then
                mobile_image_color = rgb(255, 255, 255)
            end

            local mobile_transparency = clamp(tonumber(mobile_options.transparency or mobile_options.Transparency) or 0.05, 0, 1)

            local default_width = 700
            local default_height = 565
            local requested_size = properties.custom_size or properties.customSize or properties.CustomSize or properties.size or properties.Size
            local resolved_size = resolve_window_size(requested_size, default_width, default_height)

            if not resolved_size then
                resolved_size = dim2(
                    0,
                    tonumber(properties.width or properties.Width) or default_width,
                    0,
                    tonumber(properties.height or properties.Height) or default_height
                )
            end

            local auto_dpi = properties.auto_dpi
            if auto_dpi == nil then
                auto_dpi = properties.autoDPI
            end
            if auto_dpi == nil then
                auto_dpi = true
            end

            local auto_minimize = properties.auto_minimize
            if auto_minimize == nil then
                auto_minimize = properties.autoMinimize
            end

            local minimize_width = tonumber(properties.minimize_width or properties.minimizeWidth) or 900
            local minimize_height = tonumber(properties.minimize_height or properties.minimizeHeight) or 600

            if type(auto_minimize) == "table" then
                minimize_width = tonumber(auto_minimize.width or auto_minimize.Width or auto_minimize[1]) or minimize_width
                minimize_height = tonumber(auto_minimize.height or auto_minimize.Height or auto_minimize[2]) or minimize_height
                auto_minimize = true
            end

            if auto_minimize == nil then
                auto_minimize = false
            end

            local dpi_scale = tonumber(properties.dpi_scale or properties.dpiScale or properties.scale or properties.Scale) or 1
            local dpi_min = tonumber(properties.min_dpi or properties.minDPI or properties.min_scale or properties.minScale) or 0.55
            local dpi_max = tonumber(properties.max_dpi or properties.maxDPI or properties.max_scale or properties.maxScale) or 1.15
            local dpi_reference = properties.dpi_reference or properties.dpiReference or properties.referenceResolution or properties.ReferenceResolution
            local reference_width = 1920
            local reference_height = 1080

            if typeof(dpi_reference) == "Vector2" then
                reference_width = dpi_reference.X
                reference_height = dpi_reference.Y
            elseif type(dpi_reference) == "table" then
                reference_width = tonumber(dpi_reference.width or dpi_reference.Width or dpi_reference.x or dpi_reference.X or dpi_reference[1]) or reference_width
                reference_height = tonumber(dpi_reference.height or dpi_reference.Height or dpi_reference.y or dpi_reference.Y or dpi_reference[2]) or reference_height
            end

            reference_width = tonumber(properties.dpi_reference_width or properties.dpiReferenceWidth) or reference_width
            reference_height = tonumber(properties.dpi_reference_height or properties.dpiReferenceHeight) or reference_height

            dpi_scale = max(0.1, dpi_scale)
            reference_width = max(1, reference_width)
            reference_height = max(1, reference_height)

            local lower_dpi = max(0.1, min(dpi_min, dpi_max))
            local upper_dpi = max(lower_dpi, dpi_max)

            local cfg = { 
                suffix = properties.suffix or properties.Suffix or "UI";
                name = properties.name or properties.Name or "VoidHub";
                game_name = properties.gameInfo or properties.game_info or properties.GameInfo or "VoidHub UI";
                size = resolved_size;
                auto_dpi = auto_dpi ~= false;
                auto_minimize = auto_minimize == true;
                minimize_width = max(1, minimize_width);
                minimize_height = max(1, minimize_height);
                auto_minimized = false;
                mobile_toggle_enabled = mobile_enabled == true;
                mobile_toggle_mobile_only = mobile_only == true;
                mobile_toggle_show_when_open = mobile_show_when_open == true;
                mobile_toggle_draggable = mobile_draggable == true;
                mobile_toggle_icon = mobile_icon;
                mobile_toggle_shape = mobile_shape;
                mobile_toggle_size = mobile_size;
                mobile_toggle_position = mobile_position;
                mobile_toggle_corner_radius = max(0, mobile_corner_radius);
                mobile_toggle_background = mobile_background;
                mobile_toggle_image_color = mobile_image_color;
                mobile_toggle_transparency = mobile_transparency;
                dpi_scale = dpi_scale;
                dpi_min = lower_dpi;
                dpi_max = upper_dpi;
                dpi_reference = vec2(reference_width, reference_height);
                current_dpi = 1;
                selected_tab;
                items = {};

                tween;
            }
            
            library[ "items" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = true;
                ZIndexBehavior = Enum.ZIndexBehavior.Global;
                IgnoreGuiInset = true;
            });
            
            library[ "other" ] = library:create( "ScreenGui" , {
                Parent = coregui;
                Name = "\0";
                Enabled = false;
                ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                IgnoreGuiInset = true;
            }); 

            local items = cfg.items; do
                items[ "main" ] = library:create( "Frame" , {
                    Parent = library[ "items" ];
                    Size = cfg.size;
                    Name = "\0";
                    Position = dim2(0.5, -cfg.size.X.Offset / 2, 0.5, -cfg.size.Y.Offset / 2);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16)
                });

                items[ "dpi_scale" ] = library:create( "UIScale" , {
                    Parent = items[ "main" ];
                    Scale = 1
                });

                local function center_main()
                    if not items[ "main" ] or not items[ "main" ].Parent then
                        return
                    end

                    local current_camera = ws.CurrentCamera or camera
                    local viewport = current_camera and current_camera.ViewportSize
                    if not viewport then
                        return
                    end

                    local absolute_size = items[ "main" ].AbsoluteSize
                    local x = max(0, (viewport.X - absolute_size.X) / 2)
                    local y = max(0, (viewport.Y - absolute_size.Y) / 2) + get_gui_offset()
                    items[ "main" ].Position = dim_offset(x, y)
                end

                function cfg:update_dpi()
                    local scale = self.dpi_scale
                    local current_camera = ws.CurrentCamera or camera

                    if self.auto_dpi and current_camera then
                        local viewport = current_camera.ViewportSize
                        local viewport_scale = min(
                            viewport.X / self.dpi_reference.X,
                            viewport.Y / self.dpi_reference.Y
                        )
                        local available_width = max(1, viewport.X - 24)
                        local available_height = max(1, viewport.Y - 24)
                        local base_width = max(1, self.size.X.Offset)
                        local base_height = max(1, self.size.Y.Offset)
                        local fit_scale = min(
                            available_width / base_width,
                            available_height / base_height
                        )
                        local target_scale = min(viewport_scale * self.dpi_scale, fit_scale)
                        local effective_min = min(self.dpi_min, fit_scale)

                        scale = clamp(target_scale, effective_min, self.dpi_max)
                    end

                    items[ "dpi_scale" ].Scale = scale
                    self.current_dpi = scale
                    task.defer(center_main)
                    task.delay(0.1, center_main)

                    return scale
                end

                function cfg:set_size(width, height)
                    local new_size = resolve_window_size(width, self.size.X.Offset or 700, self.size.Y.Offset or 565)

                    if not new_size then
                        new_size = dim2(
                            0,
                            tonumber(width) or self.size.X.Offset or 700,
                            0,
                            tonumber(height) or self.size.Y.Offset or 565
                        )
                    end

                    self.size = new_size
                    items[ "main" ].Size = new_size
                    task.defer(center_main)

                    return new_size
                end

                function cfg:set_auto_dpi(enabled)
                    self.auto_dpi = enabled == true
                    return self:update_dpi()
                end

                function cfg:update_auto_minimize()
                    if not self.auto_minimize then
                        return false
                    end

                    local current_camera = ws.CurrentCamera or camera
                    if not current_camera then
                        return false
                    end

                    local viewport = current_camera.ViewportSize
                    local should_minimize = viewport.X <= self.minimize_width or viewport.Y <= self.minimize_height

                    if self.auto_minimized ~= should_minimize then
                        self.auto_minimized = should_minimize

                        if self.toggle_menu then
                            self.toggle_menu(not should_minimize)
                        end
                    end

                    return should_minimize
                end

                local dpi_camera_connection
                local function bind_dpi_camera(new_camera)
                    if dpi_camera_connection then
                        dpi_camera_connection:Disconnect()
                    end

                    if not new_camera then
                        return
                    end

                    camera = new_camera
                    dpi_camera_connection = library:connection(
                        new_camera:GetPropertyChangedSignal("ViewportSize"),
                        function()
                            cfg:update_dpi()

                            if cfg.toggle_menu then
                                cfg:update_auto_minimize()
                            end

                            if cfg.update_mobile_toggle then
                                cfg:update_mobile_toggle()
                            end
                        end
                    )

                    cfg:update_dpi()
                end

                library:connection(ws:GetPropertyChangedSignal("CurrentCamera"), function()
                    bind_dpi_camera(ws.CurrentCamera)
                end)

                bind_dpi_camera(camera)
                
                library:create( "UICorner" , {
                    Parent = items[ "main" ];
                    CornerRadius = dim(0, 10)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "main" ];
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });
                
                items[ "side_frame" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 196, 1, -25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16)
                });
                
                library:create( "Frame" , {
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "side_frame" ];
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 1, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });
                
                items[ "button_holder" ] = library:create( "Frame" , {
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 60);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 1, -60);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.button_holder = items[ "button_holder" ];
                
                library:create( "UIListLayout" , {
                    Parent = items[ "button_holder" ];
                    Padding = dim(0, 5);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingTop = dim(0, 16);
                    PaddingBottom = dim(0, 36);
                    Parent = items[ "button_holder" ];
                    PaddingRight = dim(0, 11);
                    PaddingLeft = dim(0, 10)
                });

                local accent = themes.preset.accent
                items[ "title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = name;
                    Parent = items[ "side_frame" ];
                    Name = "\0";
                    Text = string.format('<u>%s</u><font color = "rgb(255, 255, 255)">%s</font>', cfg.name, cfg.suffix);
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 70);
                    TextColor3 = themes.preset.accent;
                    BorderSizePixel = 0;
                    RichText = true;
                    TextSize = 30;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "title" ], "accent", "TextColor3");
                
                items[ "multi_holder" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 0, 56);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); cfg.multi_holder = items[ "multi_holder" ];
                
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "multi_holder" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(21, 21, 23)
                });
                
                items[ "shadow" ] = library:create( "ImageLabel" , {
                    ImageColor3 = rgb(0, 0, 0);
                    ScaleType = Enum.ScaleType.Slice;
                    Parent = items[ "main" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Name = "\0";
                    BackgroundColor3 = rgb(255, 255, 255);
                    Size = dim2(1, 75, 1, 75);
                    AnchorPoint = vec2(0.5, 0.5);
                    Image = "rbxassetid://112971167999062";
                    BackgroundTransparency = 1;
                    Position = dim2(0.5, 0, 0.5, 0);
                    SliceScale = 0.75;
                    ZIndex = -100;
                    BorderSizePixel = 0;
                    SliceCenter = rect(vec2(112, 112), vec2(147, 147))
                });
                
                items[ "global_fade" ] = library:create( "Frame" , {
                    Parent = items[ "main" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -196, 1, -81);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(14, 14, 16);
                    ZIndex = 2;
                });                

                library:create( "UICorner" , {
                    Parent = items[ "shadow" ];
                    CornerRadius = dim(0, 5)
                });
                
                items[ "info" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "main" ];
                    Name = "\0";
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 25);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "info" ];
                    CornerRadius = dim(0, 10)
                });
                
                items[ "grey_fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "info" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 6);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(23, 23, 25)
                });
                
                items[ "game" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    Parent = items[ "info" ];
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.game_name;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    AnchorPoint = vec2(0, 0.5);
                    Position = dim2(0, 10, 0.5, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); 
                
                items[ "other_info" ] = library:create( "TextLabel" , {
                    Parent = items[ "info" ];
                    RichText = true;
                    Name = "\0";
                    TextColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Text = '<font color="rgb(72, 72, 73)">32 days left, </font>' .. cfg.name .. cfg.suffix;
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, -10, 0.5, -1);
                    AnchorPoint = vec2(0, 0.5);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    FontFace = fonts.font;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "other_info" ], "accent", "TextColor3");        
            end 

            do -- Other
                library:draggify(items[ "main" ])
                library:resizify(items[ "main" ])
            end 

            function cfg.toggle_menu(bool)
                if not library or not library[ "items" ] then
                    return false
                end

                -- WIP 
                -- if cfg.tween then 
                --     cfg.tween:Cancel()
                -- end 

                -- items[ "main" ].Size = dim2(items[ "main" ].Size.Scale.X, items[ "main" ].Size.Offset.X - 20, items[ "main" ].Size.Scale.Y, items[ "main" ].Size.Offset.Y - 20)
                -- library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
                -- cfg.tween = 
                
                library[ "items" ].Enabled = bool

                if cfg.update_mobile_toggle then
                    cfg:update_mobile_toggle()
                end
            end

            function cfg:update_mobile_toggle()
                if not library or not library[ "items" ] then
                    return false
                end
                local toggle_gui = library[ "mobile_toggle" ]
                if not toggle_gui then
                    return false
                end

                local current_camera = ws.CurrentCamera or camera
                local viewport = current_camera and current_camera.ViewportSize
                local supported = viewport and (uis.TouchEnabled or viewport.X <= self.minimize_width or viewport.Y <= self.minimize_height)

                if self.mobile_toggle_mobile_only and not supported then
                    toggle_gui.Enabled = false
                    return false
                end

                if self.mobile_toggle_enabled then
                    toggle_gui.Enabled = self.mobile_toggle_show_when_open or not library[ "items" ].Enabled
                else
                    toggle_gui.Enabled = false
                end

                local mobile_button = self.mobile_toggle_button
                if mobile_button and viewport then
                    local size = mobile_button.AbsoluteSize
                    local absolute_position = mobile_button.AbsolutePosition
                    local current_position = mobile_button.Position
                    local x = clamp(absolute_position.X, 0, max(0, viewport.X - size.X))
                    local y = clamp(absolute_position.Y, 0, max(0, viewport.Y - size.Y))
                    local position_y = y + get_gui_offset()
                    if abs(x - current_position.X.Offset) > 1 or abs(position_y - current_position.Y.Offset) > 1 then
                        mobile_button.Position = dim_offset(x, position_y)
                    end
                end

                return toggle_gui.Enabled
            end

            function cfg:set_mobile_toggle(enabled)
                self.mobile_toggle_enabled = enabled == true
                return self:update_mobile_toggle()
            end

            if cfg.mobile_toggle_enabled then
                library[ "mobile_toggle" ] = library:create( "ScreenGui" , {
                    Parent = coregui;
                    Name = "\0";
                    Enabled = false;
                    ZIndexBehavior = Enum.ZIndexBehavior.Global;
                    DisplayOrder = 1000;
                    IgnoreGuiInset = true;
                })

                local mobile_button = library:create( "ImageButton" , {
                    Parent = library[ "mobile_toggle" ];
                    Name = "\0";
                    Active = true;
                    Selectable = false;
                    AutoButtonColor = false;
                    BackgroundColor3 = cfg.mobile_toggle_background;
                    BackgroundTransparency = cfg.mobile_toggle_transparency;
                    BorderSizePixel = 0;
                    Image = cfg.mobile_toggle_icon;
                    ImageColor3 = cfg.mobile_toggle_image_color;
                    Position = cfg.mobile_toggle_position;
                    Size = cfg.mobile_toggle_size;
                    ZIndex = 1000
                })

                cfg.mobile_toggle_button = mobile_button

                library:create( "UICorner" , {
                    Parent = mobile_button;
                    CornerRadius = cfg.mobile_toggle_shape == "circle" and dim(1, 0) or dim(0, cfg.mobile_toggle_corner_radius)
                })

                library:create( "UIStroke" , {
                    Parent = mobile_button;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    Color = rgb(255, 255, 255);
                    Transparency = 0.72;
                    Thickness = 1
                })

                local active_input
                local drag_input
                local drag_start
                local button_start
                local dragged = false

                local function is_press(input)
                    return input.UserInputType == Enum.UserInputType.MouseButton1
                        or input.UserInputType == Enum.UserInputType.Touch
                end

                local function finish_press(input)
                    if not active_input then
                        return
                    end

                    if input and input ~= active_input and input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                        return
                    end

                    local should_toggle = not dragged
                    active_input = nil
                    drag_input = nil
                    drag_start = nil
                    button_start = nil
                    dragged = false

                    if should_toggle and library and library[ "mobile_toggle" ]
                        and library[ "mobile_toggle" ].Enabled and library[ "items" ] then
                        cfg.toggle_menu(not library[ "items" ].Enabled)
                    end
                end

                library:connection(mobile_button.InputBegan, function(input)
                    if not library or not library[ "items" ] or not is_press(input) then
                        return
                    end

                    active_input = input
                    drag_input = nil
                    drag_start = input.Position
                    button_start = mobile_button.AbsolutePosition
                    dragged = false

                    library:connection(input.Changed, function()
                        if input.UserInputState == Enum.UserInputState.End then
                            finish_press(input)
                        end
                    end)
                end)

                library:connection(mobile_button.InputChanged, function(input)
                    if active_input and (input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch) then
                        drag_input = input
                    end
                end)

                library:connection(uis.InputChanged, function(input)
                    if not active_input or not cfg.mobile_toggle_draggable then
                        return
                    end

                    local is_mouse_drag = active_input.UserInputType == Enum.UserInputType.MouseButton1
                        and input.UserInputType == Enum.UserInputType.MouseMovement
                    local is_touch_drag = active_input.UserInputType == Enum.UserInputType.Touch
                        and (input == active_input or input == drag_input)

                    if not (is_mouse_drag or is_touch_drag) then
                        return
                    end

                    local delta = vec2(input.Position.X - drag_start.X, input.Position.Y - drag_start.Y)
                    if abs(delta.X) > 8 or abs(delta.Y) > 8 then
                        dragged = true
                    end

                    local current_camera = ws.CurrentCamera or camera
                    local viewport = current_camera and current_camera.ViewportSize
                    if not viewport then
                        return
                    end

                    local size = mobile_button.AbsoluteSize
                    local x = clamp(button_start.X + delta.X, 0, max(0, viewport.X - size.X))
                    local y = clamp(button_start.Y + delta.Y, 0, max(0, viewport.Y - size.Y))
                    mobile_button.Position = dim_offset(x, y + get_gui_offset())
                end)

                library:connection(uis.InputEnded, function(input)
                    if active_input and (input == active_input
                        or (active_input.UserInputType == Enum.UserInputType.MouseButton1
                            and input.UserInputType == Enum.UserInputType.MouseButton1)) then
                        finish_press(input)
                    end
                end)

                library:connection(ws:GetPropertyChangedSignal("CurrentCamera"), function()
                    task.defer(function()
                        if library and library[ "items" ] then
                            cfg:update_mobile_toggle()
                        end
                    end)
                end)
            end

            cfg:update_mobile_toggle()

            if cfg.auto_minimize then
                cfg:update_auto_minimize()
            end
                
            return setmetatable(cfg, library)
        end 

        function library:tab(properties)
            local cfg = {
                name = properties.name or properties.Name or "visuals"; 
                icon = properties.icon or properties.Icon or "http://www.roblox.com/asset/?id=6034767608";
                
                -- multi 
                tabs = properties.tabs or properties.Tabs or {"Main", "Misc.", "Settings"};
                pages = {}; -- data store for multi sections
                current_multi; 
                
                items = {};
            } 

            local items = cfg.items; do 
                items[ "tab_holder" ] = library:create( "Frame" , {
                    Parent = library.cache;
                    Name = "\0";
                    Visible = false;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 196, 0, 56);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -216, 1, -101);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                -- Tab buttons 
                    items[ "button" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(255, 255, 255);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "button_holder" ];
                        AutoButtonColor = false;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 0, 35);
                        BorderSizePixel = 0;
                        TextSize = 16;
                        BackgroundColor3 = rgb(29, 29, 29)
                    });
                    
                    items[ "icon" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "button" ];
                        AnchorPoint = vec2(0, 0.5);
                        Image = "http://www.roblox.com/asset/?id=6034767608";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 10, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 22, 0, 22);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    }); library:apply_theme(items[ "icon" ], "accent", "ImageColor3");
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "button" ];
                        Name = "\0";
                        Size = dim2(0, 0, 1, 0);
                        Position = dim2(0, 40, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "button" ];
                        CornerRadius = dim(0, 7)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(23, 23, 29);
                        Parent = items[ "button" ];
                        Enabled = false;
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    });
                -- 

                -- Multi Sections
                    items[ "multi_section_button_holder" ] = library:create( "Frame" , {
                        Parent = library.cache;
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Visible = false;
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "multi_section_button_holder" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        FillDirection = Enum.FillDirection.Horizontal
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingTop = dim(0, 8);
                        PaddingBottom = dim(0, 7);
                        Parent = items[ "multi_section_button_holder" ];
                        PaddingRight = dim(0, 7);
                        PaddingLeft = dim(0, 7)
                    });                        

                    for _, section in cfg.tabs do
                        local data = {items = {}} 

                        local multi_items = data.items; do 
                            -- Button
                                multi_items[ "button" ] = library:create( "TextButton" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(255, 255, 255);
                                    BorderColor3 = rgb(0, 0, 0);
                                    AutoButtonColor = false;
                                    Text = "";
                                    Parent = items[ "multi_section_button_holder" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 0, 39);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.X;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(25, 25, 29)
                                });
                                
                                multi_items[ "name" ] = library:create( "TextLabel" , {
                                    FontFace = fonts.font;
                                    TextColor3 = rgb(62, 62, 63);
                                    BorderColor3 = rgb(0, 0, 0);
                                    Text = section;
                                    Parent = multi_items[ "button" ];
                                    Name = "\0";
                                    Size = dim2(0, 0, 1, 0);
                                    BackgroundTransparency = 1;
                                    TextXAlignment = Enum.TextXAlignment.Left;
                                    BorderSizePixel = 0;
                                    AutomaticSize = Enum.AutomaticSize.XY;
                                    TextSize = 16;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });
                                
                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "name" ];
                                    PaddingRight = dim(0, 5);
                                    PaddingLeft = dim(0, 5)
                                });
                                
                                multi_items[ "accent" ] = library:create( "Frame" , {
                                    BorderColor3 = rgb(0, 0, 0);
                                    AnchorPoint = vec2(0, 1);
                                    Parent = multi_items[ "button" ];
                                    BackgroundTransparency = 1;
                                    Position = dim2(0, 10, 1, 4);
                                    Name = "\0";
                                    Size = dim2(1, -20, 0, 6);
                                    BorderSizePixel = 0;
                                    BackgroundColor3 = themes.preset.accent
                                }); library:apply_theme(multi_items[ "accent" ], "accent", "BackgroundColor3");
                                
                                library:create( "UICorner" , {
                                    Parent = multi_items[ "accent" ];
                                    CornerRadius = dim(0, 999)
                                });
                                
                                library:create( "UIPadding" , {
                                    Parent = multi_items[ "button" ];
                                    PaddingRight = dim(0, 10);
                                    PaddingLeft = dim(0, 10)
                                });
                                
                                library:create( "UICorner" , {
                                    Parent = multi_items[ "button" ];
                                    CornerRadius = dim(0, 7)
                                }); 
                            --

                            -- Tab 
                                multi_items[ "tab" ] = library:create( "Frame" , {
                                    Parent = library.cache;
                                    BackgroundTransparency = 1;
                                    Name = "\0";
                                    BorderColor3 = rgb(0, 0, 0);
                                    Size = dim2(1, -20, 1, -20);
                                    BorderSizePixel = 0;
                                    Visible = false;
                                    BackgroundColor3 = rgb(255, 255, 255)
                                });
                                
                                library:create( "UIListLayout" , {
                                    FillDirection = Enum.FillDirection.Vertical;
                                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                                    Parent = multi_items[ "tab" ];
                                    Padding = dim(0, 7);
                                    SortOrder = Enum.SortOrder.LayoutOrder;
                                    VerticalFlex = Enum.UIFlexAlignment.Fill
                                });
                                
                                library:create( "UIPadding" , {
                                    PaddingTop = dim(0, 7);
                                    PaddingBottom = dim(0, 7);
                                    Parent = multi_items[ "tab" ];
                                    PaddingRight = dim(0, 7);
                                    PaddingLeft = dim(0, 7)
                                });
                            --
                        end

                        data.text = multi_items[ "name" ]
                        data.accent = multi_items[ "accent" ]
                        data.button = multi_items[ "button" ]
                        data.page = multi_items[ "tab" ]
                        data.parent = setmetatable(data, library):sub_tab({}).items[ "tab_parent" ]
                        
                        -- Old column code
                        -- data.left = multi_items[ "left" ]
                        -- data.right = multi_items[ "right" ]

						function data.open_page()
							local page = cfg.current_multi; 
                            
                            if page and page.text ~= data.text then 
                                self.items[ "global_fade" ].BackgroundTransparency = 0
                                library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                                
                                local old_size = page.page.Size
                                page.page.Size = dim2(1, -20, 1, -20)
                            end

                            if page then
                                library:tween(page.text, {TextColor3 = rgb(62, 62, 63)})
                                library:tween(page.accent, {BackgroundTransparency = 1})
                                library:tween(page.button, {BackgroundTransparency = 1})

                                page.page.Visible = false
                                page.page.Parent = library[ "cache" ] 
                            end 
                            
                            library:tween(data.text, {TextColor3 = rgb(255, 255, 255)})
                            library:tween(data.accent, {BackgroundTransparency = 0})
                            library:tween(data.button, {BackgroundTransparency = 0})
                            library:tween(data.page, {Size = dim2(1, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.4)

                            data.page.Visible = true
                            data.page.Parent = items["tab_holder"]

                            cfg.current_multi = data

                            library:close_element()
						end

						multi_items[ "button" ].Activated:Connect(function()
							data.open_page() 
						end)

						cfg.pages[#cfg.pages + 1] = setmetatable(data, library)
                    end 

                    cfg.pages[1].open_page()
                --
            end 

            function cfg.open_tab() 
                local selected_tab = self.selected_tab
                
                if selected_tab then 
                    if selected_tab[ 4 ] ~= items[ "tab_holder" ] then 
                        self.items[ "global_fade" ].BackgroundTransparency = 0
                        
                        library:tween(self.items[ "global_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                        selected_tab[ 4 ].Size = dim2(1, -216, 1, -101)
                    end

                    library:tween(selected_tab[ 1 ], {BackgroundTransparency = 1})
                    library:tween(selected_tab[ 2 ], {ImageColor3 = rgb(72, 72, 73)})
                    library:tween(selected_tab[ 3 ], {TextColor3 = rgb(72, 72, 73)})

                    selected_tab[ 4 ].Visible = false
                    selected_tab[ 4 ].Parent = library[ "cache" ]
                    selected_tab[ 5 ].Visible = false
                    selected_tab[ 5 ].Parent = library[ "cache" ]
                end

                library:tween(items[ "button" ], {BackgroundTransparency = 0})
                library:tween(items[ "icon" ], {ImageColor3 = themes.preset.accent})
                library:tween(items[ "name" ], {TextColor3 = rgb(255, 255, 255)})
                library:tween(items[ "tab_holder" ], {Size = dim2(1, -196, 1, -81)}, Enum.EasingStyle.Quad, 0.4)
                
                items[ "tab_holder" ].Visible = true 
                items[ "tab_holder" ].Parent = self.items[ "main" ]
                items[ "multi_section_button_holder" ].Visible = true 
                items[ "multi_section_button_holder" ].Parent = self.items[ "multi_holder" ]

                self.selected_tab = {
                    items[ "button" ];
                    items[ "icon" ];
                    items[ "name" ];
                    items[ "tab_holder" ];
                    items[ "multi_section_button_holder" ];
                }

                library:close_element()
            end

            items[ "button" ].Activated:Connect(function()
                cfg.open_tab()
            end)
            
            if not self.selected_tab then 
                cfg.open_tab(true) 
            end

            return unpack(cfg.pages)
        end

        function library:seperator(properties)
            local cfg = {items = {}, name = properties.Name or properties.name or "General"}

            local items = cfg.items do 
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = self.items[ "button_holder" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    Position = dim2(0, 40, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0; 
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end;    

            return setmetatable(cfg, library)
        end 

        -- Miscellaneous 
            function library:column(properties)
            properties = properties or {}

            local scroll = properties.scroll
            if scroll == nil then
                scroll = properties.scrolling or properties.Scroll or false
            end

            local cfg = {
                items = {};
                size = properties.size or properties.Size or 1;
                scroll = scroll == true;
                scroll_bar_thickness = tonumber(properties.scroll_bar_thickness or properties.scrollBarThickness) or 3;
            }

            local items = cfg.items; do
                local column_class = cfg.scroll and "ScrollingFrame" or "Frame"
                local column_options = {
                    Parent = self[ "parent" ] or self.items["tab_parent"];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, cfg.size, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }

                if cfg.scroll then
                    column_options.Active = true
                    column_options.ScrollingEnabled = true
                    column_options.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    column_options.CanvasSize = dim2(0, 0, 0, 0)
                    column_options.ScrollBarThickness = cfg.scroll_bar_thickness
                    column_options.ScrollBarImageColor3 = rgb(44, 44, 46)
                    column_options.ScrollingDirection = Enum.ScrollingDirection.Y
                    column_options.ClipsDescendants = true
                end

                items[ "column" ] = library:create(column_class, column_options)

                if cfg.scroll then
                    library:apply_theme(items[ "column" ], "accent", "ScrollBarImageColor3")
                end

                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 10);
                    Parent = items[ "column" ]
                });

                items[ "layout" ] = library:create( "UIListLayout" , {
                    Parent = items[ "column" ];
                    HorizontalFlex = Enum.UIFlexAlignment.Fill;
                    Padding = dim(0, 10);
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
            end

            return setmetatable(cfg, library)
        end

        function library:sub_tab(properties) 
                local cfg = {items = {}, order = properties.order or 0; size = properties.size or 1}

                local items = cfg.items; do 
                    items[ "tab_parent" ] = library:create( "Frame" , {
                        Parent = self.items[ "tab" ];
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(0,0,cfg.size,0);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalFlex = Enum.UIFlexAlignment.Fill;
                        VerticalFlex = Enum.UIFlexAlignment.Fill;
                        Parent = items[ "tab_parent" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder;
                    });
                end

                return setmetatable(cfg, library)
            end 
        --

        function library:section(properties)
            properties = properties or {}

            local auto_size = properties.auto_size
            if auto_size == nil then
                auto_size = properties.autoSize or properties.dynamic or properties.dynamicSize
            end

            local min_height = tonumber(properties.min_height or properties.minHeight) or 0
            local max_height = tonumber(properties.max_height or properties.maxHeight) or 300

            local collapse_setting = properties.collapsible
            if collapse_setting == nil then
                collapse_setting = properties.Collapsible
            end
            if collapse_setting == nil then
                collapse_setting = properties.toggle
            end
            if collapse_setting == nil then
                collapse_setting = properties.Toggle
            end

            local disable_collapsing = properties.disable_collapsing
            if disable_collapsing == nil then
                disable_collapsing = properties.disableCollapsing
            end
            if disable_collapsing == true then
                collapse_setting = false
            end
            if collapse_setting == nil then
                collapse_setting = false
            end

            local collapsed_setting = properties.collapsed
            if collapsed_setting == nil then
                collapsed_setting = properties.Collapsed
            end

            local cfg = {
                name = properties.name or properties.Name or "section"; 
                side = properties.side or properties.Side or "left";
                description = properties.description or properties.Description;
                default = properties.default or properties.Default or false;
                size = properties.size or properties.Size or self.size or 0.5; 
                icon = properties.icon or properties.Icon or properties.IconName or "http://www.roblox.com/asset/?id=6022668898";
                fading_toggle = properties.fading or properties.Fading or false;
                collapsible = collapse_setting == true;
                collapsed = collapsed_setting == true;
                auto_size = auto_size == true;
                min_height = max(0, min_height);
                max_height = max(max(0, min_height), max_height);
                expanded_height = max(0, min_height);
                items = {};
            };
            
            local items = cfg.items; do 
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = self.items[ "column" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = cfg.auto_size and dim2(0, 0, 0, 37 + cfg.min_height) or dim2(0, 0, cfg.size, -3);
                    BorderSizePixel = 0;
                    ClipsDescendants = true;
                    BackgroundColor3 = rgb(25, 25, 29)
                });

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    ClipsDescendants = true;
                    BackgroundColor3 = rgb(22, 22, 24)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "scrolling" ] = library:create( "ScrollingFrame" , {
                    ScrollBarImageColor3 = rgb(44, 44, 46);
                    Active = true;
                    ScrollingEnabled = true;
                    ScrollingDirection = Enum.ScrollingDirection.Y;
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = 4;
                    Parent = items[ "inline" ];
                    Name = "\0";
                    Size = cfg.auto_size and dim2(1, 0, 0, cfg.min_height) or dim2(1, 0, 1, -40);
                    BackgroundTransparency = 1;
                    Position = dim2(0, 0, 0, 35);
                    BackgroundColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    CanvasSize = dim2(0, 0, 0, 0)
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "scrolling" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "elements_layout" ] = library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });

            cfg.expanded_size = items[ "outline" ].Size

                if cfg.auto_size then
                    function cfg:update_size()
                        local ui_scale = 1
                        local ancestor = items[ "outline" ]

                        while ancestor do
                            local scale_object = ancestor:FindFirstChildOfClass("UIScale")
                            if scale_object then
                                ui_scale = max(0.01, scale_object.Scale)
                                break
                            end
                            ancestor = ancestor.Parent
                        end

                        local content_height = items[ "elements_layout" ].AbsoluteContentSize.Y / ui_scale
                        local desired_height = max(cfg.min_height, content_height + 25)
                        local visible_height = min(desired_height, cfg.max_height)

                        cfg.expanded_height = visible_height
                        items[ "scrolling" ].Size = dim2(1, 0, 0, visible_height)
                        if not cfg.collapsed then
                            items[ "outline" ].Size = dim2(0, 0, 0, visible_height + 37)
                        end

                        return visible_height
                    end

                    library:connection(items[ "elements_layout" ]:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                        cfg:update_size()
                    end)

                    task.defer(function()
                        cfg:update_size()
                    end)
                end
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 35);
                    BorderSizePixel = 0;
                    TextSize = 16;
                    BackgroundColor3 = rgb(19, 19, 21)
                });
                
                library:create( "UIStroke" , {
                    Color = rgb(23, 23, 29);
                    Parent = items[ "button" ];
                    Enabled = false;
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "Icon" ] = library:create( "ImageLabel" , {
                    ImageColor3 = themes.preset.accent;
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "button" ];
                    AnchorPoint = vec2(0, 0.5);
                    Image = cfg.icon;
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0.5, 0);
                    Name = "\0";
                    Size = dim2(0, 22, 0, 22);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "Icon" ], "accent", "ImageColor3");
                
                items[ "section_title" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(255, 255, 255);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    Size = dim2(0, 0, 1, 0);
                    Position = dim2(0, 40, 0, -1);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.X;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = items[ "button" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
                
            if cfg.collapsible then
                items[ "collapse" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(145, 145, 145);
                    Text = cfg.collapsed and "+" or "-";
                    Parent = items[ "button" ];
                    Name = "CollapseIndicator";
                    AnchorPoint = vec2(1, 0.5);
                    Position = dim2(1, cfg.fading_toggle and -56 or -10, 0.5, 0);
                    Size = dim2(0, 22, 0, 22);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    TextSize = 18;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
            end

                if cfg.fading_toggle then 
                    items[ "toggle" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(1, 0.5);
                        Parent = items[ "button" ];
                        Name = "\0";
                        Position = dim2(1, -9, 0.5, 0);
                        Size = dim2(0, 36, 0, 18);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(58, 58, 62)
                    });  library:apply_theme(items[ "toggle" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    items[ "toggle_outline" ] = library:create( "Frame" , {
                        Parent = items[ "toggle" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(50, 50, 50)
                    });  library:apply_theme(items[ "toggle_outline" ], "accent", "BackgroundColor3");
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_outline" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "toggle_outline" ]
                    });
                    
                    items[ "toggle_circle" ] = library:create( "Frame" , {
                        Parent = items[ "toggle_outline" ];
                        Name = "\0";
                        Position = dim2(0, 2, 0, 2);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(86, 86, 88)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "toggle_circle" ];
                        CornerRadius = dim(0, 999)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 7)
                    });
                
                    items[ "fade" ] = library:create( "Frame" , {
                        Parent = items[ "outline" ];
                        BackgroundTransparency = 0.800000011920929;
                        Name = "\0";
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "fade" ];
                        CornerRadius = dim(0, 7)
                    });
                end 
            end;

            if cfg.fading_toggle then
                items[ "button" ].Activated:Connect(function()
                    cfg.default = not cfg.default 
                    cfg.toggle_section(cfg.default) 
                end)

                function cfg.toggle_section(bool)
                    library:tween(items[ "toggle" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "toggle_circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "fade" ], {BackgroundTransparency = bool and 1 or 0.8}, Enum.EasingStyle.Quad)
                end 
            end 


            function cfg:set_collapsed(value)
                if not cfg.collapsible then
                    cfg.collapsed = false
                    return false
                end

                cfg.collapsed = value == true
                items[ "scrolling" ].Visible = not cfg.collapsed

                if cfg.collapsed then
                    items[ "outline" ].Size = dim2(0, 0, 0, 37)
                elseif cfg.auto_size then
                    cfg:update_size()
                else
                    items[ "outline" ].Size = cfg.expanded_size
                end

                if items[ "collapse" ] then
                    items[ "collapse" ].Text = cfg.collapsed and "+" or "-"
                end

                return cfg.collapsed
            end

            function cfg:toggle_collapsed()
                return cfg:set_collapsed(not cfg.collapsed)
            end

            function cfg:SetCollapsed(value)
                return cfg:set_collapsed(value)
            end

            function cfg:ToggleCollapsed()
                return cfg:toggle_collapsed()
            end

            function cfg:set_visible(value)
                items[ "outline" ].Visible = value ~= false
                return items[ "outline" ].Visible
            end

            function cfg:SetVisible(value)
                return cfg:set_visible(value)
            end

            function cfg:show()
                return cfg:set_visible(true)
            end

            function cfg:Show()
                return cfg:show()
            end

            function cfg:hide()
                return cfg:set_visible(false)
            end

            function cfg:Hide()
                return cfg:hide()
            end

            if cfg.collapsible then
                items[ "button" ].Activated:Connect(function()
                    cfg:toggle_collapsed()
                end)
                task.defer(function()
                    cfg:set_collapsed(cfg.collapsed)
                end)
            end

            return setmetatable(cfg, library)
        end

        function library:tabbox(properties)
            properties = properties or {}

            local cfg = {
                name = properties.name or properties.Name or "Tabbox";
                tabs = {};
                current_tab;
                items = {};
            }

            local items = cfg.items; do
                items[ "outline" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    Name = "Tabbox";
                    Size = dim2(1, 0, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(25, 25, 29);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    ClipsDescendants = true
                });

                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });

                items[ "tabs" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Position = dim2(0, 1, 0, 1);
                    Size = dim2(1, -2, 0, 35);
                    BackgroundColor3 = rgb(19, 19, 21);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0
                });

                library:create( "UICorner" , {
                    Parent = items[ "tabs" ];
                    CornerRadius = dim(0, 7)
                });

                library:create( "UIListLayout" , {
                    Parent = items[ "tabs" ];
                    FillDirection = Enum.FillDirection.Horizontal;
                    Padding = dim(0, 4);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });

                library:create( "UIPadding" , {
                    Parent = items[ "tabs" ];
                    PaddingLeft = dim(0, 7);
                    PaddingRight = dim(0, 7);
                    PaddingTop = dim(0, 4);
                    PaddingBottom = dim(0, 3)
                });

                items[ "page_holder" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Position = dim2(0, 1, 0, 36);
                    Size = dim2(1, -2, 0, 0);
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundTransparency = 1;
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0
                });
            end

            function cfg:add_tab(tab_properties, icon)
                local options = {}
                if type(tab_properties) == "string" then
                    options.name = tab_properties
                    options.icon = icon
                else
                    tab_properties = tab_properties or {}
                    for key, value in tab_properties do
                        options[key] = value
                    end
                end

                local data = {
                    name = options.name or options.Name or "Tab";
                    icon = options.icon or options.Icon;
                    items = {};
                }

                local tab_items = data.items; do
                    tab_items[ "button" ] = library:create( "TextButton" , {
                        Parent = items[ "tabs" ];
                        Text = "";
                        AutoButtonColor = false;
                        Size = dim2(0, 96, 0, 27);
                        BackgroundColor3 = rgb(25, 25, 29);
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0
                    });

                    library:create( "UICorner" , {
                        Parent = tab_items[ "button" ];
                        CornerRadius = dim(0, 5)
                    });

                    if data.icon then
                        tab_items[ "icon" ] = library:create( "ImageLabel" , {
                            Parent = tab_items[ "button" ];
                            Image = data.icon;
                            ImageColor3 = rgb(145, 145, 145);
                            Position = dim2(0, 8, 0.5, -8);
                            Size = dim2(0, 16, 0, 16);
                            BackgroundTransparency = 1;
                            BorderSizePixel = 0
                        });
                        library:apply_theme(tab_items[ "icon" ], "accent", "ImageColor3");
                    end

                    tab_items[ "label" ] = library:create( "TextLabel" , {
                        Parent = tab_items[ "button" ];
                        Position = dim2(0, data.icon and 28 or 8, 0, 0);
                        Size = dim2(1, data.icon and -32 or -16, 1, 0);
                        BackgroundTransparency = 1;
                        Text = data.name;
                        TextColor3 = rgb(145, 145, 145);
                        FontFace = fonts.small;
                        TextSize = 13;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0
                    });

                    tab_items[ "page" ] = library:create( "Frame" , {
                        Parent = items[ "page_holder" ];
                        Size = dim2(1, 0, 0, 0);
                        AutomaticSize = Enum.AutomaticSize.Y;
                        Visible = false;
                        BackgroundTransparency = 1;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0
                    });

                    tab_items[ "layout" ] = library:create( "UIListLayout" , {
                        Parent = tab_items[ "page" ];
                        Padding = dim(0, 8);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });

                    library:create( "UIPadding" , {
                        Parent = tab_items[ "page" ];
                        PaddingLeft = dim(0, 8);
                        PaddingRight = dim(0, 8);
                        PaddingBottom = dim(0, 10);
                        PaddingTop = dim(0, 8)
                    });
                end

                data.items[ "elements" ] = tab_items[ "page" ]

                function data:open()
                    if cfg.current_tab then
                        cfg.current_tab.items[ "page" ].Visible = false
                        cfg.current_tab.items[ "label" ].TextColor3 = rgb(145, 145, 145)
                    end

                    cfg.current_tab = data
                    tab_items[ "page" ].Visible = true
                    tab_items[ "label" ].TextColor3 = rgb(255, 255, 255)
                    task.defer(function()
                        items[ "outline" ].AutomaticSize = Enum.AutomaticSize.Y
                    end)
                end

                function data:Open()
                    return data:open()
                end

                data = setmetatable(data, library)

                library:connection(tab_items[ "button" ].Activated, function()
                    data:open()
                end)
                cfg.tabs[#cfg.tabs + 1] = data

                if not cfg.current_tab then
                    data:open()
                end

                return data
            end

            function cfg:tab(tab_properties, icon)
                return cfg:add_tab(tab_properties, icon)
            end

            function cfg:AddTab(tab_properties, icon)
                return cfg:add_tab(tab_properties, icon)
            end

            function cfg:addTab(tab_properties, icon)
                return cfg:add_tab(tab_properties, icon)
            end

            function cfg:Resize()
                task.defer(function()
                    items[ "outline" ].AutomaticSize = Enum.AutomaticSize.Y
                end)
            end

            local initial_tabs = properties.tabs or properties.Tabs
            if type(initial_tabs) == "table" then
                for _, tab_properties in next, initial_tabs do
                    cfg:add_tab(tab_properties)
                end
            end

            return setmetatable(cfg, library)
        end

        function library:add_tabbox(properties)
            return self:tabbox(properties)
        end

        function library:AddTabbox(properties)
            return self:tabbox(properties)
        end

        function library:addTabbox(properties)
            return self:tabbox(properties)
        end

        function library:groupbox(properties)
            properties = properties or {}

            local options = {}
            for key, value in properties do
                options[key] = value
            end

            local auto_size = options.auto_size
            if auto_size == nil then
                auto_size = options.autoSize or options.dynamic or options.dynamicSize
            end
            if auto_size == nil then
                auto_size = true
            end

            options.auto_size = auto_size == true
            options.size = options.size or options.Size or 1
            if options.max_height == nil and options.maxHeight == nil then
                options.max_height = 300
            end
            if options.default == nil and options.Default == nil then
                options.default = true
            end

            if options.collapsible == nil and options.Collapsible == nil
                and options.toggle == nil and options.Toggle == nil then
                options.collapsible = true
            end

            local disable_collapsing = options.disable_collapsing
            if disable_collapsing == nil then
                disable_collapsing = options.disableCollapsing
            end
            if disable_collapsing == true then
                options.collapsible = false
            end

            if options.collapsed == nil and options.Collapsed == nil then
                options.collapsed = false
            end

            return self:section(options)
        end

        function library:group_box(properties)
            return self:groupbox(properties)
        end

        function library:groupboxes(properties)
            properties = properties or {}

            local column_size = tonumber(properties.column_size or properties.columnSize or properties.size or properties.Size) or 0.5
            column_size = clamp(column_size, 0.1, 0.9)

            local definitions = properties.boxes or properties.groups or {}
            local scroll_columns = properties.scroll ~= false and properties.scrolling ~= false
            local scroll_bar_thickness = tonumber(properties.scroll_bar_thickness or properties.scrollBarThickness) or 3
            local left_column = self:column({
                size = column_size;
                scroll = scroll_columns;
                scroll_bar_thickness = scroll_bar_thickness
            })
            local right_column = self:column({
                size = column_size;
                scroll = scroll_columns;
                scroll_bar_thickness = scroll_bar_thickness
            })

            local function definition(key, index, fallback_name)
                local value = definitions[key] or definitions[index] or properties[key]
                local options = {}

                if type(value) == "table" then
                    for option, option_value in value do
                        options[option] = option_value
                    end
                elseif type(value) == "string" then
                    options.name = value
                else
                    options.name = fallback_name
                end

                options.name = options.name or options.Name or fallback_name

                local shared_auto_size = properties.auto_size
                if shared_auto_size == nil then
                    shared_auto_size = properties.autoSize
                end
                if options.auto_size == nil and options.autoSize == nil and shared_auto_size ~= nil then
                    options.auto_size = shared_auto_size
                end

                local shared_min_height = properties.min_height
                if shared_min_height == nil then
                    shared_min_height = properties.minHeight
                end
                if options.min_height == nil and options.minHeight == nil and shared_min_height ~= nil then
                    options.min_height = shared_min_height
                end

                local shared_max_height = properties.max_height
                if shared_max_height == nil then
                    shared_max_height = properties.maxHeight
                end
                if options.max_height == nil and options.maxHeight == nil and shared_max_height ~= nil then
                    options.max_height = shared_max_height
                end

                options.size = options.size or options.Size or 1
                if options.default == nil and options.Default == nil then
                    options.default = true
                end

                return options
            end

            local boxes = {
                top_left = left_column:groupbox(definition("top_left", 1, "Top Left")),
                top_right = right_column:groupbox(definition("top_right", 2, "Top Right")),
                bottom_left = left_column:groupbox(definition("bottom_left", 3, "Bottom Left")),
                bottom_right = right_column:groupbox(definition("bottom_right", 4, "Bottom Right"))
            }

            boxes.topLeft = boxes.top_left
            boxes.topRight = boxes.top_right
            boxes.bottomLeft = boxes.bottom_left
            boxes.bottomRight = boxes.bottom_right
            boxes.left_column = left_column
            boxes.right_column = right_column

            return boxes
        end

        function library:groupbox_grid(properties)
            return self:groupboxes(properties)
        end

        function library:group_boxes(properties)
            return self:groupboxes(properties)
        end

        function library:toggle(options) 
            local rand = math.random(1, 2) 
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
                info = options.info or nil,
                flag = options.flag or library:next_flag(),
                
                type = options.type and string.lower(options.type) or rand == 1 and "toggle" or "checkbox"; -- "toggle", "checkbox"

                default = options.default or false,
                folding = options.folding or false, 
                callback = options.callback or function() end,

                items = {};
                seperator = options.seperator or options.Seperator or false;
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "toggle" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "toggle" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "toggle" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                -- Toggle
                    if cfg.type == "checkbox" then 
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AutoButtonColor = false;
                            AnchorPoint = vec2(1, 0);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, 0, 0, 0);
                            Size = dim2(0, 16, 0, 16);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = rgb(67, 67, 68)
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 4)
                        });
                        
                        items[ "outline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(22, 22, 24)
                        }); library:apply_theme(items[ "outline" ], "accent", "BackgroundColor3");
                        
                        items[ "tick" ] = library:create( "ImageLabel" , {
                            ImageTransparency = 1;
                            BorderColor3 = rgb(0, 0, 0);
                            Image = "rbxassetid://111862698467575";
                            BackgroundTransparency = 1;
                            Position = dim2(0, -1, 0, 0);
                            Parent = items[ "outline" ];
                            Size = dim2(1, 2, 1, 2);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255);
                            ZIndex = 1;
                        });

                        library:create( "UICorner" , {
                            Parent = items[ "outline" ];
                            CornerRadius = dim(0, 4)
                        });
                        
                        library:create( "UIGradient" , {
                            Enabled = false;
                            Parent = items[ "outline" ];
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))}
                        });  
                    else 
                        items[ "toggle_button" ] = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(0, 0, 0);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = "";
                            LayoutOrder = 2;
                            AnchorPoint = vec2(1, 0.5);
                            Parent = items[ "right_components" ];
                            Name = "\0";
                            Position = dim2(1, -9, 0.5, 0);
                            Size = dim2(0, 36, 0, 18);
                            BorderSizePixel = 0;
                            TextSize = 14;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "toggle_button" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "toggle_button" ];
                            CornerRadius = dim(0, 999)
                        });
                        
                        items[ "inline" ] = library:create( "Frame" , {
                            Parent = items[ "toggle_button" ];
                            Size = dim2(1, -2, 1, -2);
                            Name = "\0";
                            BorderMode = Enum.BorderMode.Inset;
                            BorderColor3 = rgb(0, 0, 0);
                            Position = dim2(0, 1, 0, 1);
                            BorderSizePixel = 0;
                            BackgroundColor3 = themes.preset.accent
                        }); library:apply_theme(items[ "inline" ], "accent", "BackgroundColor3");
                        
                        library:create( "UICorner" , {
                            Parent = items[ "inline" ];
                            CornerRadius = dim(0, 999)
                        });
                        
                        library:create( "UIGradient" , {
                            Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                            Parent = items[ "inline" ]
                        });
                        
                        items[ "circle" ] = library:create( "Frame" , {
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Position = dim2(1, -14, 0, 2);
                            BorderColor3 = rgb(0, 0, 0);
                            Size = dim2(0, 12, 0, 12);
                            BorderSizePixel = 0;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                        
                        library:create( "UICorner" , {
                            Parent = items[ "circle" ];
                            CornerRadius = dim(0, 999)
                        });                        
                    end 
                --                
            end;
            
            function cfg.set(bool)
                if cfg.type == "checkbox" then 
                    library:tween(items[ "tick" ], {Rotation = bool and 0 or 45, ImageTransparency = bool and 0 or 1})
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(67, 67, 68)})
                    library:tween(items[ "outline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(22, 22, 24)})
                else
                    library:tween(items[ "toggle_button" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(58, 58, 62)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "inline" ], {BackgroundColor3 = bool and themes.preset.accent or rgb(50, 50, 50)}, Enum.EasingStyle.Quad)
                    library:tween(items[ "circle" ], {BackgroundColor3 = bool and rgb(255, 255, 255) or rgb(86, 86, 88), Position = bool and dim2(1, -14, 0, 2) or dim2(0, 2, 0, 2)}, Enum.EasingStyle.Quad)
                end

                cfg.callback(bool)

                if cfg.folding then 
                    elements.Visible = bool
                end

                flags[cfg.flag] = bool
            end 
            
            items[ "toggle" ].Activated:Connect(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end)

            items[ "toggle_button" ].Activated:Connect(function()
                cfg.enabled = not cfg.enabled 
                cfg.set(cfg.enabled)
            end)
            
            if cfg.seperator then -- ok bro my lua either sucks or this was a pain in the ass to make (simple if statement aswell 💔)
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end

            cfg.set(cfg.default)

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 
        
        function library:slider(options) 
            local cfg = {
                name = options.name or nil,
                suffix = options.suffix or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end, 
                info = options.info or nil; 

                -- value settings
                min = options.min or options.minimum or 0,
                max = options.max or options.maximum or 100,
                intervals = options.interval or options.decimal or 1,
                default = options.default or 10,
                value = options.default or 10, 
                seperator = options.seperator or options.Seperator or true;

                dragging = false,
                items = {}
            } 

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do
                items[ "slider_object" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 54);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.None;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(0.7, -8, 0, 22);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.None;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                if cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "slider_object" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 24);
                        Size = dim2(1, -10, 0, 30);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.None;
                        TextSize = 12;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 

                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 25);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 20);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "slider" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    Active = true;
                    Selectable = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, -6);
                    Size = dim2(1, -4, 0, 20);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundTransparency = 1;
                    ZIndex = 2
                });

                items[ "track" ] = library:create( "Frame" , {
                    Parent = items[ "slider" ];
                    Name = "\0";
                    Position = dim2(0, 0, 0.5, -2);
                    Size = dim2(1, 0, 0, 4);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(33, 33, 35);
                    ZIndex = 2
                });

                library:create( "UICorner" , {
                    Parent = items[ "track" ];
                    CornerRadius = dim(0, 999)
                });

                items[ "fill" ] = library:create( "Frame" , {
                    Name = "\0";
                    Parent = items[ "track" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0.5, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = themes.preset.accent;
                    ZIndex = 3
                });  library:apply_theme(items[ "fill" ], "accent", "BackgroundColor3");

                library:create( "UICorner" , {
                    Parent = items[ "fill" ];
                    CornerRadius = dim(0, 999)
                });

                items[ "circle" ] = library:create( "Frame" , {
                    AnchorPoint = vec2(0.5, 0.5);
                    Parent = items[ "fill" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0.5, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 14, 0, 14);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(244, 244, 244);
                    ZIndex = 4
                });

                library:create( "UICorner" , {
                    Parent = items[ "circle" ];
                    CornerRadius = dim(0, 999)
                });

                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4)
                });

                items[ "value" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "50%";
                    Parent = items[ "slider_object" ];
                    Name = "\0";
                    Size = dim2(0.3, -8, 0, 20);
                    Position = dim2(1, -5, 0, 0);
                    AnchorPoint = vec2(1, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Right;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "value" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });                
            end 

            local function layout_slider()
                local info_height = items.info and 30 or 0
                local controls_y = items.info and 48 or 25
                items.slider_object.Size = dim2(1, 0, 0, controls_y + 28)
                items.right_components.Position = dim2(0, 4, 0, controls_y)
                items.right_components.Size = dim2(1, -8, 0, 20)
                if items.info then
                    items.info.Position = dim2(0, 5, 0, 24)
                    items.info.Size = dim2(1, -10, 0, info_height)
                end
            end
            task.defer(layout_slider)

            function cfg.set(value)
                cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

                library:tween(items[ "fill" ], {Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), cfg.value == cfg.min and 0 or -4, 1, 0)}, Enum.EasingStyle.Linear, 0.05)
                items[ "value" ].Text = tostring(cfg.value) .. cfg.suffix

                flags[cfg.flag] = cfg.value
                cfg.callback(flags[cfg.flag])
            end

            local function update_slider(position)
                local track = items[ "track" ]
                local width = track.AbsoluteSize.X
                if width <= 0 then
                    return
                end

                local size_x = clamp((position.X - track.AbsolutePosition.X) / width, 0, 1)
                cfg.set(((cfg.max - cfg.min) * size_x) + cfg.min)
            end

            library:connection(items[ "slider" ].InputBegan, function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                cfg.dragging = true
                cfg.drag_input = input
                update_slider(input.Position)
                library:tween(items[ "value" ], {TextColor3 = rgb(255, 255, 255)}, Enum.EasingStyle.Quad, 0.2)
            end)

            library:connection(uis.InputChanged, function(input)
                if not cfg.dragging or not cfg.drag_input then
                    return
                end

                local is_mouse_drag = cfg.drag_input.UserInputType == Enum.UserInputType.MouseButton1
                    and input.UserInputType == Enum.UserInputType.MouseMovement
                local is_touch_drag = cfg.drag_input.UserInputType == Enum.UserInputType.Touch
                    and input == cfg.drag_input

                if is_mouse_drag or is_touch_drag then
                    update_slider(input.Position)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if not cfg.dragging or not cfg.drag_input then
                    return
                end

                if input == cfg.drag_input
                    or (cfg.drag_input.UserInputType == Enum.UserInputType.MouseButton1
                        and input.UserInputType == Enum.UserInputType.MouseButton1) then
                    cfg.dragging = false
                    cfg.drag_input = nil
                    library:tween(items[ "value" ], {TextColor3 = rgb(72, 72, 73)}, Enum.EasingStyle.Quad, 0.2)
                end
            end)

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end 

            cfg.set(cfg.default)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:dropdown(options) 
            local cfg = {
                name = options.name or nil;
                info = options.info or nil;
                flag = options.flag or library:next_flag();
                options = options.items or {""};
                callback = options.callback or function() end;
                multi = options.multi or false;
                scrolling = options.scrolling or false;

                width = options.width or 130;

                -- Ignore these 
                open = false;
                option_instances = {};
                multi_items = {};
                ignore = options.ignore or false;
                items = {};
                y_size;
                seperator = options.seperator or options.Seperator or true;
            }   

            cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or "None"
            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                -- Element
                    items[ "dropdown_object" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, cfg.info and 62 or 34);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.None;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "Dropdown";
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        Size = dim2(1, -(cfg.width + 16), 0, 22);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.None;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    if cfg.info then 
                        items[ "info" ] = library:create( "TextLabel" , {
                            FontFace = fonts.small;
                            TextColor3 = rgb(130, 130, 130);
                            BorderColor3 = rgb(0, 0, 0);
                            TextWrapped = true;
                            Text = cfg.info;
                            Parent = items[ "dropdown_object" ];
                            Name = "\0";
                            Position = dim2(0, 5, 0, 25);
                            Size = dim2(1, -(cfg.width + 16), 0, 30);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.None;
                            TextSize = 12;
                            BackgroundColor3 = rgb(255, 255, 255)
                        });
                    end 

                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_object" ];
                        Name = "\0";
                        AnchorPoint = vec2(1, 0);
                        Position = dim2(1, -5, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, cfg.width, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    items[ "dropdown" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, cfg.width, 0, 25);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "dropdown" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "sub_text" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "awdawdawdawdawdawdawdaw";
                        Parent = items[ "dropdown" ];
                        Name = "\0";
                        Size = dim2(1, -28, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        AutomaticSize = Enum.AutomaticSize.None;
                        TextSize = 13;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "sub_text" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "indicator" ] = library:create( "ImageLabel" , {
                        ImageColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "dropdown" ];
                        AnchorPoint = vec2(1, 0.5);
                        Image = "rbxassetid://101025591575185";
                        BackgroundTransparency = 1;
                        Position = dim2(1, -5, 0.5, 0);
                        Name = "\0";
                        Size = dim2(0, 12, 0, 12);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                -- 

                -- Element Holder
                    items[ "dropdown_holder" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library[ "items" ];
                        Name = "\0";
                        Visible = true;
                        BackgroundTransparency = 1;
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0);
                        ZIndex = 10;
                    });
                    
                    items[ "outline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown_holder" ];
                        Size = dim2(1, 0, 1, 0);
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(33, 33, 35);
                        ZIndex = 10;
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "outline" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "outline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "outline" ];
                        CornerRadius = dim(0, 4)
                    });
                -- 
            end 

            function cfg.render_option(text)
                local button = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(72, 72, 73);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = text;
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Size = dim2(1, -12, 0, 30);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.None;
                    TextSize = 13;
                    BackgroundColor3 = rgb(255, 255, 255);
                    ZIndex = 10;
                }); library:apply_theme(button, "accent", "TextColor3");
                
                library:create( "UIPadding" , {
                    Parent = button;
                    PaddingTop = dim(0, 7);
                    PaddingBottom = dim(0, 7);
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                return button
            end
            
            function cfg.set_visible(bool)
                local a = bool and cfg.y_size or 0
                library:tween(items[ "dropdown_holder" ], {Size = dim_offset(items[ "dropdown" ].AbsoluteSize.X, a)})

                local current_camera = ws.CurrentCamera or camera
                local viewport = current_camera and current_camera.ViewportSize
                if viewport then
                    local trigger = items[ "dropdown" ]
                    local holder_size = vec2(trigger.AbsoluteSize.X, bool and cfg.y_size or 0)
                    local x = clamp(trigger.AbsolutePosition.X, 6, max(6, viewport.X - holder_size.X - 6))
                    local y = trigger.AbsolutePosition.Y + trigger.AbsoluteSize.Y + 8
                    if y + holder_size.Y > viewport.Y - 6 then
                        y = trigger.AbsolutePosition.Y - holder_size.Y - 8
                    end
                    y = clamp(y, 6, max(6, viewport.Y - holder_size.Y - 6))
                    items[ "dropdown_holder" ].Position = dim_offset(x, y)
                end
                if not (self.sanity and library.current_open == self) then 
                    library:close_element(cfg)
                end
            end
            
            function cfg.set(value)
                local selected = {}
                local isTable = type(value) == "table"

                for _, option in cfg.option_instances do 
                    if option.Text == value or (isTable and find(value, option.Text)) then 
                        insert(selected, option.Text)
                        cfg.multi_items = selected
                        option.TextColor3 = themes.preset.accent
                    else
                        option.TextColor3 = rgb(72, 72, 73)
                    end
                end

                items[ "sub_text" ].Text = isTable and concat(selected, ", ") or selected[1] or ""
                flags[cfg.flag] = isTable and selected or selected[1]
                
                cfg.callback(flags[cfg.flag]) 
            end
            
            function cfg.refresh_options(list) 
                cfg.y_size = 0

                for _, option in cfg.option_instances do 
                    option:Destroy() 
                end
                
                cfg.option_instances = {} 

                for _, option in list do 
                    local button = cfg.render_option(option)
                    cfg.y_size += 35
                    insert(cfg.option_instances, button)
                    
                    button.Activated:Connect(function()
                        if cfg.multi then 
                            local selected_index = find(cfg.multi_items, button.Text)
                            
                            if selected_index then 
                                remove(cfg.multi_items, selected_index)
                            else
                                insert(cfg.multi_items, button.Text)
                            end
                            
                            cfg.set(cfg.multi_items) 				
                        else 
                            cfg.set_visible(false)
                            cfg.open = false 
                            
                            cfg.set(button.Text)
                        end
                    end)
                end
            end

            items[ "dropdown" ].Activated:Connect(function()
                cfg.open = not cfg.open 
                
                cfg.set_visible(cfg.open)
            end)

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end 

            flags[cfg.flag] = {} 
            config_flags[cfg.flag] = cfg.set
            
            cfg.refresh_options(cfg.options)
            cfg.set(cfg.default)
                
            return setmetatable(cfg, library)
        end

        function library:label(options)
            local cfg = {
                enabled = options.enabled or nil,
                name = options.name or "Toggle",
                seperator = options.seperator or options.Seperator or false;
                info = options.info or nil; 

                items = {};
            }

            local items = cfg.items; do 
                items[ "label" ] = library:create( "TextButton" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "label" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });

                if cfg.info then 
                    items[ "info" ] = library:create( "TextLabel" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(130, 130, 130);
                        BorderColor3 = rgb(0, 0, 0);
                        TextWrapped = true;
                        Text = cfg.info;
                        Parent = items[ "label" ];
                        Name = "\0";
                        Position = dim2(0, 5, 0, 17);
                        Size = dim2(1, -10, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                end 
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "label" ];
                    Name = "\0";
                    Position = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 1, 0);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    FillDirection = Enum.FillDirection.Horizontal;
                    HorizontalAlignment = Enum.HorizontalAlignment.Right;
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 9);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });                
            end 

            if cfg.seperator then 
                library:create( "Frame" , {
                    AnchorPoint = vec2(0, 1);
                    Parent = self.items[ "elements" ];
                    Position = dim2(0, 0, 1, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 1, 0, 1);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(36, 36, 37)
                });
            end 

            return setmetatable(cfg, library)
        end 
        
        function library:colorpicker(options) 
            local cfg = {
                name = options.name or "Color", 
                flag = options.flag or library:next_flag(),

                color = options.color or color(1, 1, 1), -- Default to white color if not provided
                alpha = options.alpha and 1 - options.alpha or 0,
                
                open = false, 
                callback = options.callback or function() end,
                items = {};

                seperator = options.seperator or options.Seperator or false;
            }

            local dragging_sat = false 
            local dragging_hue = false 
            local dragging_alpha = false 

            local h, s, v = cfg.color:ToHSV() 
            local a = cfg.alpha 

            flags[cfg.flag] = {Color = cfg.color, Transparency = cfg.alpha}

            local label; 
            if not self.items.right_components then 
                label = self:label({name = cfg.name, seperator = cfg.seperator})
            end

            local items = cfg.items; do 
                -- Component
                    items[ "colorpicker" ] = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = label and label.items.right_components or self.items[ "right_components" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(0, 16, 0, 16);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "colorpicker_inline" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker" ];
                        Size = dim2(1, -2, 1, -2);
                        Name = "\0";
                        BorderMode = Enum.BorderMode.Inset;
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(0, 1, 0, 1);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(54, 31, 184)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_inline" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(211, 211, 211)), rgbkey(1, rgb(211, 211, 211))};
                        Parent = items[ "colorpicker_inline" ]
                    });         
                --
                
                -- Colorpicker
                    items[ "colorpicker_holder" ] = library:create( "Frame" , {
                        Parent = library[ "other" ];
                        Name = "\0";
                        Position = dim2(0.20000000298023224, 20, 0.296999990940094, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 166, 0, 197);
                        BorderSizePixel = 0;
                        Visible = true;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });

                    items[ "colorpicker_fade" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        BackgroundTransparency = 0;
                        Position = dim2(0, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        ZIndex = 100;
                        BackgroundColor3 = rgb(25, 25, 29)
                    });
                    
                    items[ "colorpicker_components" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        Position = dim2(0, 1, 0, 1);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -2, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "colorpicker_components" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "saturation_holder" ] = library:create( "Frame" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 7, 0, 7);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -14, 1, -80);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 39, 39)
                    });
                    
                    items[ "sat" ] = library:create( "TextButton" , {
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        Text = "";
                        AutoButtonColor = false;
                        BorderColor3 = rgb(0, 0, 0);
                        ZIndex = 2;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "sat" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 270;
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)};
                        Parent = items[ "sat" ];
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0))}
                    });
                    
                    items[ "val" ] = library:create( "Frame" , {
                        Name = "\0";
                        Parent = items[ "saturation_holder" ];
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIGradient" , {
                        Parent = items[ "val" ];
                        Transparency = numseq{numkey(0, 0), numkey(1, 1)}
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "val" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "saturation_holder" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "satvalpicker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0);
                        Parent = items[ "saturation_holder" ];
                        Name = "\0";
                        Position = dim2(0, 0, 0, 0);
                        Size = dim2(0, 14, 0, 14);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "satvalpicker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "satvalpicker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });
                    
                    items[ "hue_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -64);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 14);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255);
                        AutoButtonColor = false;
                        Text = "";
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(255, 0, 0)), rgbkey(0.17, rgb(255, 255, 0)), rgbkey(0.33, rgb(0, 255, 0)), rgbkey(0.5, rgb(0, 255, 255)), rgbkey(0.67, rgb(0, 0, 255)), rgbkey(0.83, rgb(255, 0, 255)), rgbkey(1, rgb(255, 0, 0))};
                        Parent = items[ "hue_gradient" ]
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "hue_gradient" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "hue_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "hue_gradient" ];
                        Name = "\0";
                        Position = dim2(0, 0, 0.5, 0);
                        Size = dim2(0, 12, 0, 12);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "hue_picker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        Parent = items[ "hue_picker" ];
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    });
                    
                    items[ "alpha_gradient" ] = library:create( "TextButton" , {
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        Position = dim2(0, 10, 1, -46);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(1, -20, 0, 14);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(25, 25, 29);
                        AutoButtonColor = false;
                        Text = "";
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_gradient" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    items[ "alpha_picker" ] = library:create( "TextButton" , {
                        BorderColor3 = rgb(0, 0, 0);
                        AutoButtonColor = false;
                        Text = "";
                        AnchorPoint = vec2(0, 0.5);
                        Parent = items[ "alpha_gradient" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0.5, 0);
                        Size = dim2(0, 12, 0, 12);
                        ZIndex = 5;
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 0, 0)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_picker" ];
                        CornerRadius = dim(0, 9999)
                    });
                    
                    library:create( "UIStroke" , {
                        Color = rgb(255, 255, 255);
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                        Parent = items[ "alpha_picker" ]
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(255, 255, 255))};
                        Parent = items[ "alpha_gradient" ]
                    });
                    
                    items[ "alpha_indicator" ] = library:create( "ImageLabel" , {
                        ScaleType = Enum.ScaleType.Tile;
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = items[ "alpha_gradient" ];
                        Image = "rbxassetid://18274452449";
                        BackgroundTransparency = 1;
                        Name = "\0";
                        Size = dim2(1, 0, 1, 0);
                        TileSize = dim2(0, 6, 0, 6);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    library:create( "UIGradient" , {
                        Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, rgb(255, 0, 0))};
                        Transparency = numseq{numkey(0, 0.8062499761581421), numkey(1, 0)};
                        Parent = items[ "alpha_indicator" ]
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "alpha_indicator" ];
                        CornerRadius = dim(0, 6)
                    });
                    
                    library:create( "UIGradient" , {
                        Rotation = 90;
                        Parent = items[ "colorpicker_components" ];
                        Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(66, 66, 66))}
                    });

                    items[ "input" ] = library:create( "TextBox" , {
                        FontFace = fonts.font;
                        AnchorPoint = vec2(1, 1);
                        Text = "";
                        Parent = items[ "colorpicker_components" ];
                        Name = "\0";
                        TextTruncate = Enum.TextTruncate.AtEnd;
                        BorderSizePixel = 0;
                        PlaceholderColor3 = rgb(255, 255, 255);
                        CursorPosition = -1;
                        ClearTextOnFocus = false;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255);
                        TextColor3 = rgb(72, 72, 72);
                        BorderColor3 = rgb(0, 0, 0);
                        Position = dim2(1, -8, 1, -11);
                        Size = dim2(1, -16, 0, 18);
                        BackgroundColor3 = rgb(33, 33, 35)
                    }); 
                    
                    library:create( "UICorner" , {
                        Parent = items[ "input" ];
                        CornerRadius = dim(0, 3)
                    });
                    
                    items[ "UICorenr" ] = library:create( "UICorner" , { -- fire misstypo (im not fixing this RAWR)
                        Parent = items[ "colorpicker_holder" ];
                        Name = "\0";
                        CornerRadius = dim(0, 4)
                    });
                --                  
            end;

            function cfg.set_visible(bool)
                items[ "colorpicker_fade" ].BackgroundTransparency = 0
                items[ "colorpicker_holder" ].Parent = bool and library[ "items" ] or library[ "other" ]
                local current_camera = ws.CurrentCamera or camera
                local viewport = current_camera and current_camera.ViewportSize
                if viewport then
                    local holder_size = items[ "colorpicker_holder" ].AbsoluteSize
                    local trigger = items[ "colorpicker" ]
                    local x = clamp(trigger.AbsolutePosition.X, 6, max(6, viewport.X - holder_size.X - 6))
                    local y = trigger.AbsolutePosition.Y + trigger.AbsoluteSize.Y + 8
                    if y + holder_size.Y > viewport.Y - 6 then
                        y = trigger.AbsolutePosition.Y - holder_size.Y - 8
                    end
                    y = clamp(y, 6, max(6, viewport.Y - holder_size.Y - 6))
                    items[ "colorpicker_holder" ].Position = dim_offset(x, y)
                end

                library:tween(items[ "colorpicker_fade" ], {BackgroundTransparency = 1}, Enum.EasingStyle.Quad, 0.4)
                library:tween(items[ "colorpicker_holder" ], {Position = items[ "colorpicker_holder" ].Position + dim_offset(0, 20)}) -- p100 check
                
                if not (self.sanity and library.current_open == self and self.open) then 
                    library:close_element(cfg)
                end
            end

            function cfg.set(color, alpha)
                if type(color) == "boolean" then 
                    return
                end 

                if color then 
                    h, s, v = color:ToHSV()
                end
                
                if alpha then 
                    a = alpha
                end 
                
                local Color = hsv(h, s, v)

                -- Ok so quick story, should I cache any of this? no...?? anyways I know this code is very bad but its your fault for buying a ui with animations (on a serious note im too lazy to make this look nice)
                -- Also further note, yeah I kind of did this scale_factor * size-valuesize.plane because then I would have to do tomfoolery to make it clip properly.
                library:tween(items[ "hue_picker" ], {Position = dim2(0, (items[ "hue_gradient" ].AbsoluteSize.X - items[ "hue_picker" ].AbsoluteSize.X) * h, 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "alpha_picker" ], {Position = dim2(0, (items[ "alpha_gradient" ].AbsoluteSize.X - items[ "alpha_picker" ].AbsoluteSize.X) * (1 - a), 0.5, 0)}, Enum.EasingStyle.Linear, 0.05)
                library:tween(items[ "satvalpicker" ], {Position = dim2(0, s * max(0, items[ "saturation_holder" ].AbsoluteSize.X - items[ "satvalpicker" ].AbsoluteSize.X), 0, (1 - v) * max(0, items[ "saturation_holder" ].AbsoluteSize.Y - items[ "satvalpicker" ].AbsoluteSize.Y))}, Enum.EasingStyle.Linear, 0.05)

                items[ "alpha_indicator" ]:FindFirstChildOfClass("UIGradient").Color = rgbseq{rgbkey(0, rgb(112, 112, 112)), rgbkey(1, hsv(h, 1, 1))}; -- shit code
                
                items[ "colorpicker" ].BackgroundColor3 = Color
                items[ "colorpicker_inline" ].BackgroundColor3 = Color
                items[ "saturation_holder" ].BackgroundColor3 = hsv(h, 1, 1)

                items[ "hue_picker" ].BackgroundColor3 = hsv(h, 1, 1)
                items[ "alpha_picker" ].BackgroundColor3 = hsv(h, 1, 1 - a)
                items[ "satvalpicker" ].BackgroundColor3 = hsv(h, s, v)

                flags[cfg.flag] = {
                    Color = Color;
                    Transparency = a 
                }
                
                local color = items[ "colorpicker" ].BackgroundColor3
                items[ "input" ].Text = string.format("%s, %s, %s, ", library:round(color.R * 255), library:round(color.G * 255), library:round(color.B * 255))
                items[ "input" ].Text ..= library:round(1 - a, 0.01)
                
                cfg.callback(Color, a)
            end
            
            function cfg.update_color(position)
                local location = position or uis:GetMouseLocation()
                local offset = vec2(location.X, location.Y - get_gui_offset())

                if dragging_sat then
                    s = math.clamp((offset - items["sat"].AbsolutePosition).X / items["sat"].AbsoluteSize.X, 0, 1)
                    v = 1 - math.clamp((offset - items["sat"].AbsolutePosition).Y / items["sat"].AbsoluteSize.Y, 0, 1)
                elseif dragging_hue then
                    h = math.clamp((offset - items[ "hue_gradient" ].AbsolutePosition).X / items[ "hue_gradient" ].AbsoluteSize.X, 0, 1)
                elseif dragging_alpha then
                    a = 1 - math.clamp((offset - items[ "alpha_gradient" ].AbsolutePosition).X / items[ "alpha_gradient" ].AbsoluteSize.X, 0, 1)
                end

                cfg.set()
            end

            items[ "colorpicker" ].Activated:Connect(function()
                cfg.open = not cfg.open
                cfg.set_visible(cfg.open)
            end)

            local color_drag_input

            local function begin_color_drag(kind, input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and input.UserInputType ~= Enum.UserInputType.Touch then
                    return
                end

                dragging_sat = kind == "sat"
                dragging_hue = kind == "hue"
                dragging_alpha = kind == "alpha"
                color_drag_input = input
                cfg.update_color(input.Position)
            end

            library:connection(items[ "alpha_gradient" ].InputBegan, function(input)
                begin_color_drag("alpha", input)
            end)

            library:connection(items[ "hue_gradient" ].InputBegan, function(input)
                begin_color_drag("hue", input)
            end)

            library:connection(items[ "sat" ].InputBegan, function(input)
                begin_color_drag("sat", input)
            end)

            library:connection(uis.InputChanged, function(input)
                if not color_drag_input then
                    return
                end

                local is_mouse_drag = color_drag_input.UserInputType == Enum.UserInputType.MouseButton1
                    and input.UserInputType == Enum.UserInputType.MouseMovement
                local is_touch_drag = color_drag_input.UserInputType == Enum.UserInputType.Touch
                    and input == color_drag_input

                if is_mouse_drag or is_touch_drag then
                    cfg.update_color(input.Position)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if not color_drag_input then
                    return
                end

                if input == color_drag_input
                    or (color_drag_input.UserInputType == Enum.UserInputType.MouseButton1
                        and input.UserInputType == Enum.UserInputType.MouseButton1) then
                    dragging_sat = false
                    dragging_hue = false
                    dragging_alpha = false
                    color_drag_input = nil
                end
            end)

            items[ "input" ].FocusLost:Connect(function()
                local text = items[ "input" ].Text
                local r, g, b, a = library:convert(text)
                
                if r and g and b and a then 
                    cfg.set(rgb(r, g, b), 1 - a)
                end 
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)
            
            cfg.set(cfg.color, cfg.alpha)
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end 

        function library:textbox(options) 
            local cfg = {
                name = options.name or "TextBox",
                placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
                default = options.default or "",
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                visible = options.visible or true,
                items = {};
            }

            flags[cfg.flag] = cfg.default

            local items = cfg.items; do 
                items[ "textbox" ] = library:create( "TextButton" , {
                    LayoutOrder = -1;
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 16;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "name" ];
                    PaddingRight = dim(0, 5);
                    PaddingLeft = dim(0, 5)
                });
                
                items[ "right_components" ] = library:create( "Frame" , {
                    Parent = items[ "textbox" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 4, 0, 19);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, 0, 0, 12);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "right_components" ];
                    Padding = dim(0, 7);
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    FillDirection = Enum.FillDirection.Horizontal
                });
                
                items[ "input" ] = library:create( "TextBox" , {
                    FontFace = fonts.font;
                    Text = "";
                    Parent = items[ "right_components" ];
                    Name = "\0";
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    BorderSizePixel = 0;
                    PlaceholderColor3 = rgb(255, 255, 255);
                    CursorPosition = -1;
                    ClearTextOnFocus = false;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255);
                    TextColor3 = rgb(72, 72, 72);
                    BorderColor3 = rgb(0, 0, 0);
                    Position = dim2(1, 0, 0, 0);
                    Size = dim2(1, -4, 0, 30);
                    BackgroundColor3 = rgb(33, 33, 35)
                }); 

                library:create( "UICorner" , {
                    Parent = items[ "input" ];
                    CornerRadius = dim(0, 3)
                });                
                
                library:create( "UIPadding" , {
                    Parent = items[ "right_components" ];
                    PaddingTop = dim(0, 4);
                    PaddingRight = dim(0, 4)
                });
            end 
            
            function cfg.set(text) 
                flags[cfg.flag] = text

                items[ "input" ].Text = text

                cfg.callback(text)
            end 
            
            items[ "input" ]:GetPropertyChangedSignal("Text"):Connect(function()
                cfg.set(items[ "input" ].Text) 
            end)

            items[ "input" ].Focused:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(245, 245, 245)})
            end)

            items[ "input" ].FocusLost:Connect(function()
                library:tween(items[ "input" ], {TextColor3 = rgb(72, 72, 72)})
            end)
                
            if cfg.default then 
                cfg.set(cfg.default) 
            end

            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:keybind(options) 
            local cfg = {
                flag = options.flag or library:next_flag(),
                callback = options.callback or function() end,
                name = options.name or nil, 
                ignore_key = options.ignore or false, 

                key = options.key or nil, 
                mode = options.mode or "Toggle",
                active = options.default or false, 

                open = false,
                binding = nil, 

                hold_instances = {},
                items = {};
            }

            flags[cfg.flag] = {
                mode = cfg.mode,
                key = cfg.key, 
                active = cfg.active
            }

            local items = cfg.items; do 
                -- Component
                    items[ "keybind_element" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = self.items[ "elements" ];
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.Y;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    items[ "name" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(245, 245, 245);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = cfg.name;
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Size = dim2(1, 0, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 16;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "name" ];
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });
                    
                    items[ "right_components" ] = library:create( "Frame" , {
                        Parent = items[ "keybind_element" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Size = dim2(0, 0, 1, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIListLayout" , {
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        Parent = items[ "right_components" ];
                        Padding = dim(0, 7);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    items[ "keybind_holder" ] = library:create( "TextButton" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        Parent = items[ "right_components" ];
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Size = dim2(0, 0, 0, 16);
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "keybind_holder" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    items[ "key" ] = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(86, 86, 87);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "LSHIFT";
                        Parent = items[ "keybind_holder" ];
                        Name = "\0";
                        Size = dim2(1, -12, 0, 0);
                        BackgroundTransparency = 1;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.XY;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });
                    
                    library:create( "UIPadding" , {
                        Parent = items[ "key" ];
                        PaddingTop = dim(0, 1);
                        PaddingRight = dim(0, 5);
                        PaddingLeft = dim(0, 5)
                    });                                  
                -- 
                
                -- Mode Holder
                    items[ "dropdown" ] = library:create( "Frame" , {
                        BorderColor3 = rgb(0, 0, 0);
                        Parent = library.items;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Position = dim2(0, 0, 0, 0);
                        Size = dim2(0, 0, 0, 0);
                        BorderSizePixel = 0;
                        AutomaticSize = Enum.AutomaticSize.X;
                        BackgroundColor3 = rgb(0, 0, 0)
                    });
                    
                    items[ "inline" ] = library:create( "Frame" , {
                        Parent = items[ "dropdown" ];
                        Size = dim2(1, 0, 1, 0);
                        Name = "\0";
                        ClipsDescendants = true;
                        BorderColor3 = rgb(0, 0, 0);
                        BorderSizePixel = 0;
                        BackgroundColor3 = rgb(22, 22, 24)
                    });
                    
                    library:create( "UIPadding" , {
                        PaddingBottom = dim(0, 6);
                        PaddingTop = dim(0, 3);
                        PaddingLeft = dim(0, 3);
                        Parent = items[ "inline" ]
                    });
                    
                    library:create( "UIListLayout" , {
                        Parent = items[ "inline" ];
                        Padding = dim(0, 5);
                        SortOrder = Enum.SortOrder.LayoutOrder
                    });
                    
                    library:create( "UICorner" , {
                        Parent = items[ "inline" ];
                        CornerRadius = dim(0, 4)
                    });
                    
                    local options = {"Hold", "Toggle", "Always"}
                    
                    cfg.y_size = 20
                    for _, option in options do                        
                        local name = library:create( "TextButton" , {
                            FontFace = fonts.font;
                            TextColor3 = rgb(72, 72, 73);
                            BorderColor3 = rgb(0, 0, 0);
                            Text = option;
                            Parent = items[ "inline" ];
                            Name = "\0";
                            Size = dim2(0, 0, 0, 0);
                            BackgroundTransparency = 1;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BorderSizePixel = 0;
                            AutomaticSize = Enum.AutomaticSize.XY;
                            TextSize = 14;
                            BackgroundColor3 = rgb(255, 255, 255)
                        }); cfg.hold_instances[option] = name
                        library:apply_theme(name, "accent", "TextColor3")
                        
                        cfg.y_size += name.AbsoluteSize.Y

                        library:create( "UIPadding" , {
                            Parent = name;
                            PaddingTop = dim(0, 1);
                            PaddingRight = dim(0, 5);
                            PaddingLeft = dim(0, 5)
                        });

                        name.Activated:Connect(function()
                            cfg.set(option)

                            cfg.set_visible(false)

                            cfg.open = false
                        end)
                    end
                -- 
            end 
            
            function cfg.modify_mode_color(path) -- ts so frikin tuff 💀
                for _, v in cfg.hold_instances do 
                    v.TextColor3 = rgb(72, 72, 72)
                end 

                cfg.hold_instances[path].TextColor3 = themes.preset.accent
            end

            function cfg.set_mode(mode) 
                cfg.mode = mode 

                if mode == "Always" then
                    cfg.set(true)
                elseif mode == "Hold" then
                    cfg.set(false)
                end

                flags[cfg.flag]["mode"] = mode
                cfg.modify_mode_color(mode)
            end 

            function cfg.set(input)
                if type(input) == "boolean" then 
                    cfg.active = input

                    if cfg.mode == "Always" then 
                        cfg.active = true
                    end
                elseif tostring(input):find("Enum") then 
                    input = input.Name == "Escape" and "NONE" or input
                    
                    cfg.key = input or "NONE"	
                elseif find({"Toggle", "Hold", "Always"}, input) then 
                    if input == "Always" then 
                        cfg.active = true 
                    end 

                    cfg.mode = input
                    cfg.set_mode(cfg.mode) 
                elseif type(input) == "table" then 
                    input.key = type(input.key) == "string" and input.key ~= "NONE" and library:convert_enum(input.key) or input.key
                    input.key = input.key == Enum.KeyCode.Escape and "NONE" or input.key

                    cfg.key = input.key or "NONE"
                    cfg.mode = input.mode or "Toggle"

                    cfg.active = input.active == true

                    cfg.set_mode(cfg.mode) 
                end 

                cfg.callback(cfg.active)

                local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
                local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
                
                items[ "key" ].Text = __text

                flags[cfg.flag] = {
                    mode = cfg.mode,
                    key = cfg.key, 
                    active = cfg.active
                }
            end

            function cfg.set_visible(bool)
                local size = bool and cfg.y_size or 0
                library:tween(items[ "dropdown" ], {Size = dim_offset(items[ "keybind_holder" ].AbsoluteSize.X, size)})

                items[ "dropdown" ].Position = dim_offset(items[ "keybind_holder" ].AbsolutePosition.X, items[ "keybind_holder" ].AbsolutePosition.Y + items[ "keybind_holder" ].AbsoluteSize.Y + 60)
            end
        
            items[ "keybind_holder" ].Activated:Connect(function()
                if keybind_suppress_activation then
                    keybind_suppress_activation = false
                    return
                end

                task.wait()
                items[ "key" ].Text = "..."	

                cfg.binding = library:connection(uis.InputBegan, function(keycode, game_event)  
                    cfg.set(keycode.KeyCode ~= Enum.KeyCode.Unknown and keycode.KeyCode or keycode.UserInputType)
                    
                    cfg.binding:Disconnect() 
                    cfg.binding = nil
                end)
            end)

            local keybind_touch
            local keybind_long_press = false
            local keybind_suppress_activation = false

            library:connection(items[ "keybind_holder" ].InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton2 then
                    cfg.open = not cfg.open
                    cfg.set_visible(cfg.open)
                elseif input.UserInputType == Enum.UserInputType.Touch then
                    keybind_touch = input
                    keybind_long_press = false

                    task.delay(0.45, function()
                        if keybind_touch == input and input.UserInputState ~= Enum.UserInputState.End then
                            keybind_long_press = true
                            keybind_suppress_activation = true
                            cfg.open = not cfg.open
                            cfg.set_visible(cfg.open)
                        end
                    end)
                end
            end)

            library:connection(uis.InputEnded, function(input)
                if keybind_touch == input then
                    keybind_touch = nil
                    keybind_long_press = false
                end
            end)

            library:connection(uis.InputBegan, function(input, game_event) 
                if not game_event then
                    local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

                    if selected_key == cfg.key then 
                        if cfg.mode == "Toggle" then 
                            cfg.active = not cfg.active
                            cfg.set(cfg.active)
                        elseif cfg.mode == "Hold" then 
                            cfg.set(true)
                        end
                    end
                end
            end)    

            library:connection(uis.InputEnded, function(input, game_event) 
                if game_event then 
                    return 
                end 

                local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
    
                if selected_key == cfg.key then
                    if cfg.mode == "Hold" then 
                        cfg.set(false)
                    end
                end
            end)
            
            cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})           
            config_flags[cfg.flag] = cfg.set

            return setmetatable(cfg, library)
        end

        function library:button(options) 
            local cfg = {
                name = options.name or "TextBox",
                callback = options.callback or function() end,
                items = {};
            }
            
            local items = cfg.items; do 
                items[ "button_element" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                items[ "button" ] = library:create( "TextButton" , {
                    FontFace = fonts.font;
                    TextColor3 = rgb(0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = "";
                    AutoButtonColor = false;
                    AnchorPoint = vec2(1, 0);
                    Parent = items[ "button_element" ];
                    Name = "\0";
                    Position = dim2(1, -4, 0, 0);
                    Size = dim2(1, -8, 0, 30);
                    BorderSizePixel = 0;
                    TextSize = 14;
                    BackgroundColor3 = rgb(33, 33, 35)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "button" ];
                    CornerRadius = dim(0, 3)
                });
                
                items[ "name" ] = library:create( "TextLabel" , {
                    FontFace = fonts.small;
                    TextColor3 = rgb(245, 245, 245);
                    BorderColor3 = rgb(0, 0, 0);
                    Text = cfg.name;
                    Parent = items[ "button" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Size = dim2(1, 0, 1, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    TextSize = 14;
                    BackgroundColor3 = rgb(255, 255, 255)
                }); library:apply_theme(items[ "name" ], "accent", "BackgroundColor3");                            
            end 

            items[ "button" ].Activated:Connect(function()
                cfg.callback()

                items[ "name" ].TextColor3 = themes.preset.accent 
                library:tween(items[ "name" ], {TextColor3 = rgb(245, 245, 245)})
            end)
            
            return setmetatable(cfg, library)
        end 

        function library:settings(options)  
            local cfg = {
                open = false; 
                items = {}; 
                sanity = true; -- made this for my own sanity.
            }

            local items = cfg.items; do 
                items[ "outline" ] = library:create( "Frame" , {
                    Name = "\0";
                    Visible = true;
                    Parent = library[ "items" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 0, 0, 0);
                    ClipsDescendants = true;
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(25, 25, 29)
                });
                
                items[ "inline" ] = library:create( "Frame" , {
                    Parent = items[ "outline" ];
                    Name = "\0";
                    Position = dim2(0, 1, 0, 1);
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(1, -2, 1, -2);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(22, 22, 24)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "inline" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "elements" ] = library:create( "Frame" , {
                    BorderColor3 = rgb(0, 0, 0);
                    Parent = items[ "inline" ];
                    Name = "\0";
                    BackgroundTransparency = 1;
                    Position = dim2(0, 10, 0, 10);
                    Size = dim2(1, -20, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.Y;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "elements" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    PaddingBottom = dim(0, 15);
                    Parent = items[ "elements" ]
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "outline" ];
                    CornerRadius = dim(0, 7)
                });
                
                library:create( "UICorner" , {
                    Parent = items[ "fade" ];
                    CornerRadius = dim(0, 7)
                });
                
                items[ "tick" ] = library:create( "ImageButton" , {
                    Image = "rbxassetid://128797200442698";
                    Name = "\0";
                    AutoButtonColor = false;
                    Parent = self.items[ "right_components" ];
                    BorderColor3 = rgb(0, 0, 0);
                    Size = dim2(0, 16, 0, 16);
                    BorderSizePixel = 0;
                    BackgroundColor3 = rgb(255, 255, 255)
                });                
            end 

            function cfg.set_visible(bool)                 
                library:tween(items[ "outline" ], {Size = dim_offset(bool and 240 or 0, 0)})
                items[ "outline" ].Position = dim_offset(items[ "tick" ].AbsolutePosition.X, items[ "tick" ].AbsolutePosition.Y + 90)
                library:close_element(cfg)
            end
            
            items[ "tick" ].Activated:Connect(function()
                cfg.open = not cfg.open

                cfg.set_visible(cfg.open)
            end)

            return setmetatable(cfg, library)
        end 

        function library:list(properties) 
            local cfg = {
                items = {};
                options = properties.options or {"1", "2", "3"};
                flag = properties.flag or library:next_flag();    
                callback = properties.callback or function() end;
                data_store = {};        
                current_element;
            }

            local items = cfg.items; do
                items[ "list" ] = library:create( "Frame" , {
                    Parent = self.items[ "elements" ];
                    BackgroundTransparency = 1;
                    Name = "\0";
                    Size = dim2(1, 0, 0, 0);
                    BorderColor3 = rgb(0, 0, 0);
                    BorderSizePixel = 0;
                    AutomaticSize = Enum.AutomaticSize.XY;
                    BackgroundColor3 = rgb(255, 255, 255)
                });
                
                library:create( "UIListLayout" , {
                    Parent = items[ "list" ];
                    Padding = dim(0, 10);
                    SortOrder = Enum.SortOrder.LayoutOrder
                });
                
                library:create( "UIPadding" , {
                    Parent = items[ "list" ];
                    PaddingRight = dim(0, 4);
                    PaddingLeft = dim(0, 4)
                });
            end 

            function cfg.set(value)
                local selected

                for _, entry in cfg.data_store do
                    local active = entry.value == value
                    entry.label.TextColor3 = active and rgb(245, 245, 245) or rgb(72, 72, 73)

                    if active then
                        selected = entry
                    end
                end

                if not selected then
                    flags[cfg.flag] = nil
                    cfg.current_element = nil
                    return nil
                end

                flags[cfg.flag] = selected.value
                cfg.current_element = selected.label
                cfg.callback(selected.value)
                return selected.value
            end

            function cfg.refresh_options(options_to_refresh, preferred)
                for _, entry in cfg.data_store do
                    if entry.button and entry.button.Parent then
                        entry.button:Destroy()
                    end
                end

                cfg.data_store = {}
                cfg.current_element = nil

                for _, option_data in options_to_refresh or {} do
                    local button = library:create( "TextButton" , {
                        FontFace = fonts.small;
                        TextColor3 = rgb(0, 0, 0);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = "";
                        AutoButtonColor = false;
                        AnchorPoint = vec2(1, 0);
                        Parent = items[ "list" ];
                        Name = "\0";
                        Position = dim2(1, 0, 0, 0);
                        Size = dim2(1, 0, 0, 30);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(33, 33, 35)
                    });

                    local name = library:create( "TextLabel" , {
                        FontFace = fonts.font;
                        TextColor3 = rgb(72, 72, 73);
                        BorderColor3 = rgb(0, 0, 0);
                        Text = tostring(option_data);
                        Parent = button;
                        Name = "\0";
                        BackgroundTransparency = 1;
                        Size = dim2(1, 0, 1, 0);
                        BorderSizePixel = 0;
                        TextSize = 14;
                        BackgroundColor3 = rgb(255, 255, 255)
                    });

                    library:create( "UICorner" , {
                        Parent = button;
                        CornerRadius = dim(0, 3)
                    });

                    local entry = {
                        button = button;
                        label = name;
                        value = option_data;
                    }
                    cfg.data_store[#cfg.data_store + 1] = entry

                    library:connection(button.Activated, function()
                        cfg.set(option_data)
                    end)

                    library:connection(name.MouseEnter, function()
                        if cfg.current_element ~= name then
                            library:tween(name, {TextColor3 = rgb(140, 140, 140)})
                        end
                    end)

                    library:connection(name.MouseLeave, function()
                        if cfg.current_element ~= name then
                            library:tween(name, {TextColor3 = rgb(72, 72, 73)})
                        end
                    end)
                end

                local target = preferred or flags[cfg.flag]
                local selected = target and cfg.set(target)

                if not selected and cfg.data_store[1] then
                    selected = cfg.set(cfg.data_store[1].value)
                elseif not cfg.data_store[1] then
                    flags[cfg.flag] = nil
                end

                return selected
            end

            cfg.refresh_options(cfg.options)

            return setmetatable(cfg, library)
        end 

        function library:init_config(window)
            window:seperator({name = "Settings"})
            local main = window:tab({name = "Configs", tabs = {"Main"}})

            local list_column = main:column({})
            local list_section = list_column:section({
                name = "Configs",
                size = 1,
                default = true,
                icon = "rbxassetid://139628202576511"
            })

            local settings_column = main:column({})
            local settings_section = settings_column:section({
                name = "Settings",
                side = "right",
                size = 1,
                default = true,
                icon = "rbxassetid://129380150574313"
            })

            local name_box
            config_holder = list_section:list({
                options = {},
                flag = "config_name_list",
                callback = function(option)
                    if name_box and name_box.set then
                        name_box.set(option)
                    end
                end
            })

            name_box = settings_section:textbox({
                name = "Config name:",
                placeholder = "Enter config name",
                flag = "config_name_text"
            })

            local function selected_name()
                local typed = trim_config_name(flags.config_name_text)
                if typed ~= "" then
                    return typed
                end
                return flags.config_name_list
            end

            local function notify(info)
                notifications:create_notification({
                    name = "Configs",
                    info = info
                })
            end

            settings_section:button({
                name = "Save",
                callback = function()
                    local ok, result = library:save_config(selected_name())
                    notify(ok and ("Saved config:\n" .. result) or ("Save failed:\n" .. tostring(result)))
                end
            })

            settings_section:button({
                name = "Load",
                callback = function()
                    local ok, result = library:load_named_config(selected_name())
                    notify(ok and ("Loaded config:\n" .. result) or ("Load failed:\n" .. tostring(result)))
                end
            })

            settings_section:button({
                name = "Delete",
                callback = function()
                    local ok, result = library:delete_config(selected_name())
                    if ok and name_box and name_box.set then
                        name_box.set("")
                    end
                    notify(ok and ("Deleted config:\n" .. result) or ("Delete failed:\n" .. tostring(result)))
                end
            })

            settings_section:colorpicker({
                name = "Menu Accent",
                callback = function(color)
                    library:update_theme("accent", color)
                end,
                color = themes.preset.accent
            })

            settings_section:keybind({
                name = "Menu Bind",
                callback = function(bool)
                    window.toggle_menu(bool)
                end,
                default = true
            })

            library:update_config_list()
        end
    --

    -- Notification Library
        function notifications:refresh_notifs()
            local active = {}
            for _, notification in notifications.notifs do
                if notification and notification.Parent then
                    active[#active + 1] = notification
                end
            end
            notifications.notifs = active

            local offset = get_gui_offset() + 10
            for _, notification in active do
                local height = notification:GetAttribute("VoidHubNotificationHeight")
                    or notification.AbsoluteSize.Y
                    or 54
                local margin = notification:GetAttribute("VoidHubNotificationMargin") or 10
                local gap = notification:GetAttribute("VoidHubNotificationGap") or 7
                library:tween(
                    notification,
                    {Position = dim2(1, -margin, 0, offset)},
                    Enum.EasingStyle.Quint,
                    0.24
                )
                offset += height + gap
            end

            return offset
        end

        function notifications:fade(path, is_fading)
            if not path or not path.Parent then return end
            local target = is_fading and 1 or 0

            library:tween(path, {
                BackgroundTransparency = is_fading and 1 or 0.04
            }, Enum.EasingStyle.Quad, 0.2)

            for _, instance in path:GetDescendants() do
                if instance:IsA("TextLabel") or instance:IsA("TextButton") then
                    library:tween(instance, {TextTransparency = target}, Enum.EasingStyle.Quad, 0.18)
                elseif instance:IsA("Frame") then
                    local shown = instance:GetAttribute("VoidHubShownTransparency")
                    if shown ~= nil then
                        library:tween(instance, {
                            BackgroundTransparency = is_fading and 1 or shown
                        }, Enum.EasingStyle.Quad, 0.18)
                    end
                elseif instance:IsA("UIStroke") then
                    library:tween(instance, {
                        Transparency = is_fading and 1 or 0.28
                    }, Enum.EasingStyle.Quad, 0.18)
                end
            end
        end

        function notifications:create_notification(options)
            options = options or {}
            local notification_library = library
            local kind = string.lower(tostring(options.type or options.kind or "info"))
            local colors = {
                info = themes.preset.accent;
                success = rgb(65, 210, 143);
                warning = rgb(239, 181, 69);
                error = rgb(238, 82, 104);
            }
            local icons = {
                info = "i";
                success = "✓";
                warning = "!";
                error = "×";
            }

            local accent = options.color or colors[kind] or colors.info
            local title_text = tostring(options.name or options.title or "VoidHub")
            local info_text = tostring(options.info or options.message or "")
            local lifetime = max(1, tonumber(options.lifetime or options.duration) or 4)
            local current_camera = ws.CurrentCamera or camera
            local viewport = current_camera and current_camera.ViewportSize or vec2(800, 600)
            local compact = uis.TouchEnabled or viewport.X <= 700 or viewport.Y <= 500
            local display_text
            if compact then
                display_text = info_text ~= "" and info_text or title_text
            else
                display_text = info_text ~= "" and (title_text .. "  ·  " .. info_text) or title_text
            end

            local width = clamp(
                tonumber(options.width) or (compact and 176 or 270),
                compact and 148 or 210,
                max(compact and 148 or 210, viewport.X - 20)
            )
            local height = compact and 32 or 38
            local margin = compact and 10 or 14
            local gap = compact and 6 or 8
            local icon_size = compact and 18 or 20
            local icon_x = compact and 7 or 9
            local icon_y = floor((height - icon_size) / 2)
            local text_x = icon_x + icon_size + (compact and 7 or 8)
            local text_right = compact and 9 or 11

            local items = {}
            items.notification = notification_library:create("Frame", {
                Parent = notification_library.items;
                Name = "VoidHubNotification";
                AnchorPoint = vec2(1, 0);
                Position = dim2(1, width + margin + 14, 0, get_gui_offset() + 10);
                Size = dim2(0, width, 0, height);
                BackgroundColor3 = rgb(13, 13, 16);
                BackgroundTransparency = 0.02;
                BorderSizePixel = 0;
                ClipsDescendants = true;
                ZIndex = 110;
            })
            items.notification:SetAttribute("VoidHubNotificationHeight", height)
            items.notification:SetAttribute("VoidHubNotificationMargin", margin)
            items.notification:SetAttribute("VoidHubNotificationGap", gap)

            notification_library:create("UICorner", {
                Parent = items.notification;
                CornerRadius = dim(0, compact and 8 or 9);
            })

            items.stroke = notification_library:create("UIStroke", {
                Parent = items.notification;
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                Color = rgb(48, 48, 56);
                Transparency = 0.52;
                Thickness = 1;
            })

            items.icon = notification_library:create("TextLabel", {
                Parent = items.notification;
                Position = dim2(0, icon_x, 0, icon_y);
                Size = dim2(0, icon_size, 0, icon_size);
                BackgroundColor3 = accent;
                BackgroundTransparency = 0.84;
                BorderSizePixel = 0;
                Text = icons[kind] or icons.info;
                TextColor3 = accent;
                FontFace = fonts.font;
                TextSize = compact and 10 or 11;
                ZIndex = 112;
            })
            items.icon:SetAttribute("VoidHubShownTransparency", 0.84)
            notification_library:create("UICorner", {
                Parent = items.icon;
                CornerRadius = dim(1, 0);
            })

            items.message = notification_library:create("TextLabel", {
                Parent = items.notification;
                Position = dim2(0, text_x, 0, 0);
                Size = dim2(1, -(text_x + text_right), 1, -1);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Text = display_text;
                TextColor3 = rgb(220, 220, 226);
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Center;
                TextTruncate = Enum.TextTruncate.AtEnd;
                FontFace = fonts.small;
                TextSize = compact and 10 or 12;
                ZIndex = 111;
            })

            items.progress_track = notification_library:create("Frame", {
                Parent = items.notification;
                AnchorPoint = vec2(0, 1);
                Position = dim2(0, 0, 1, 0);
                Size = dim2(1, 0, 0, 1);
                BackgroundColor3 = rgb(31, 31, 36);
                BackgroundTransparency = 0.3;
                BorderSizePixel = 0;
                ZIndex = 111;
            })
            items.progress_track:SetAttribute("VoidHubShownTransparency", 0.3)

            items.progress = notification_library:create("Frame", {
                Parent = items.progress_track;
                Size = dim2(1, 0, 1, 0);
                BackgroundColor3 = accent;
                BackgroundTransparency = 0.16;
                BorderSizePixel = 0;
                ZIndex = 112;
            })
            items.progress:SetAttribute("VoidHubShownTransparency", 0.16)

            items.hitbox = notification_library:create("TextButton", {
                Parent = items.notification;
                Size = dim2(1, 0, 1, 0);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Text = "";
                AutoButtonColor = false;
                ZIndex = 113;
            })

            local api = {
                items = items;
                kind = kind;
                closed = false;
            }

            function api:Close()
                if api.closed then return false end
                api.closed = true

                local index = table.find(notifications.notifs, items.notification)
                if index then
                    table.remove(notifications.notifs, index)
                end

                if items.notification and items.notification.Parent then
                    notifications:fade(items.notification, true)
                    notification_library:tween(
                        items.notification,
                        {Position = dim2(1, width + margin + 14, 0, items.notification.Position.Y.Offset)},
                        Enum.EasingStyle.Quint,
                        0.18
                    )
                    task.delay(0.2, function()
                        if items.notification and items.notification.Parent then
                            items.notification:Destroy()
                        end
                    end)
                end

                notifications:refresh_notifs()
                return true
            end

            notification_library:connection(items.hitbox.Activated, function()
                api:Close()
            end)

            notifications.notifs[#notifications.notifs + 1] = items.notification
            local max_visible = compact and 1 or 4
            while #notifications.notifs > max_visible do
                local oldest = table.remove(notifications.notifs, 1)
                if oldest and oldest.Parent then
                    oldest:Destroy()
                end
            end

            local target_offset = notifications:refresh_notifs()
            items.notification.Position = dim2(1, width + margin + 14, 0, target_offset - height - gap)
            notifications:fade(items.notification, false)
            notification_library:tween(
                items.notification,
                {Position = dim2(1, -margin, 0, target_offset - height - gap)},
                Enum.EasingStyle.Quint,
                0.24
            )
            notification_library:tween(
                items.progress,
                {Size = dim2(0, 0, 1, 0)},
                Enum.EasingStyle.Linear,
                lifetime
            )

            task.delay(lifetime, function()
                if not api.closed and items.notification and items.notification.Parent then
                    api:Close()
                end
            end)

            return api
        end
    --
-- 

-- Extensions
do
    local extension = {
        version = "1.0.0";
        controls = {};
        keybinds = {};
        themes = {};
        plugins = {};
        notification_history = {};
        drawers = {};
        auto_save_token = 0;
        unloading = false;
    }
    library.Extensions = extension

    local base_groupboxes = library.groupboxes
    local base_section = library.section
    local base_toggle = library.toggle
    local base_slider = library.slider
    local base_dropdown = library.dropdown
    local base_label = library.label
    local base_colorpicker = library.colorpicker
    local base_textbox = library.textbox
    local base_keybind = library.keybind
    local base_button = library.button
    local base_notification = notifications.create_notification

    local function copy_table(source)
        local result = {}
        for key, value in source or {} do
            result[key] = value
        end
        return result
    end

    local function mobile_view()
        local current_camera = ws.CurrentCamera or camera
        local viewport = current_camera and current_camera.ViewportSize
        return viewport and (uis.TouchEnabled or viewport.X <= 700 or viewport.Y <= 500), viewport
    end

    local function control_root(control)
        if not control or type(control.items) ~= "table" then
            return nil
        end

        local order = {
            "toggle", "slider", "dropdown_object", "label_object", "colorpicker_object",
            "textbox_object", "keybind_element", "button", "label", "outline", "list"
        }

        for _, key in order do
            local value = control.items[key]
            if typeof(value) == "Instance" and value:IsA("GuiObject") then
                return value
            end
        end

        for _, value in control.items do
            if typeof(value) == "Instance" and value:IsA("GuiObject") then
                return value
            end
        end
    end

    local function set_button_animation(button)
        if not button or not button:IsA("GuiButton") or button:GetAttribute("VoidHubAnimated") then
            return
        end

        button:SetAttribute("VoidHubAnimated", true)
        local base_transparency = button.BackgroundTransparency
        local hover_transparency = max(0, base_transparency - 0.12)

        library:connection(button.MouseEnter, function()
            if button.Parent then
                library:tween(button, {BackgroundTransparency = hover_transparency}, Enum.EasingStyle.Quad, 0.12)
            end
        end)

        library:connection(button.MouseLeave, function()
            if button.Parent then
                library:tween(button, {BackgroundTransparency = base_transparency}, Enum.EasingStyle.Quad, 0.12)
            end
        end)

        library:connection(button.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton1 then
                library:tween(button, {BackgroundTransparency = max(0, hover_transparency - 0.1)}, Enum.EasingStyle.Quad, 0.08)
            end
        end)

        library:connection(button.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton1 then
                library:tween(button, {BackgroundTransparency = base_transparency}, Enum.EasingStyle.Quad, 0.1)
            end
        end)
    end

    function library:SetVisible(value)
        local root = control_root(self)
        if root then
            root.Visible = value ~= false
        end
        return self
    end

    function library:SetEnabled(value)
        local enabled = value ~= false
        local root = control_root(self)
        self.enabled = enabled

        if root then
            if not self.__enabled_blocker or not self.__enabled_blocker.Parent then
                self.__enabled_blocker = library:create("TextButton", {
                    Parent = root;
                    Name = "VoidHubDisabledBlocker";
                    Text = "";
                    AutoButtonColor = false;
                    Active = true;
                    Selectable = false;
                    Size = dim2(1, 0, 1, 0);
                    Position = dim2(0, 0, 0, 0);
                    BackgroundColor3 = rgb(0, 0, 0);
                    BackgroundTransparency = 0.72;
                    BorderSizePixel = 0;
                    Visible = false;
                    ZIndex = root.ZIndex + 25;
                })
                library:create("UICorner", {
                    Parent = self.__enabled_blocker;
                    CornerRadius = dim(0, 5);
                })
            end
            self.__enabled_blocker.Visible = not enabled

            if root:GetAttribute("VoidHubEnabledTransparency") == nil then
                root:SetAttribute("VoidHubEnabledTransparency", root.BackgroundTransparency)
            end
            root.BackgroundTransparency = enabled
                and root:GetAttribute("VoidHubEnabledTransparency")
                or min(1, root:GetAttribute("VoidHubEnabledTransparency") + 0.25)

            local input_objects = {root}
            for _, instance in root:GetDescendants() do
                input_objects[#input_objects + 1] = instance
            end

            for _, instance in input_objects do
                if instance:IsA("GuiButton") then
                    if instance:GetAttribute("VoidHubEnabledActive") == nil then
                        instance:SetAttribute("VoidHubEnabledActive", instance.Active)
                        instance:SetAttribute("VoidHubEnabledSelectable", instance.Selectable)
                    end
                    instance.Active = enabled and instance:GetAttribute("VoidHubEnabledActive") or false
                    instance.Selectable = enabled and instance:GetAttribute("VoidHubEnabledSelectable") or false
                elseif instance:IsA("TextBox") then
                    if instance:GetAttribute("VoidHubEnabledEditable") == nil then
                        instance:SetAttribute("VoidHubEnabledEditable", instance.TextEditable)
                    end
                    instance.TextEditable = enabled and instance:GetAttribute("VoidHubEnabledEditable") or false
                    instance.Active = enabled
                end
            end
        end

        return self
    end

    function library:DependsOn(flag, expected, mode)
        expected = expected == nil and true or expected
        mode = string.lower(tostring(mode or "visible"))
        local last

        local function update()
            local matches
            if type(expected) == "function" then
                matches = expected(flags[flag], flags)
            else
                matches = flags[flag] == expected
            end

            if matches == last then
                return
            end
            last = matches

            if mode == "enabled" then
                self:SetEnabled(matches)
            else
                self:SetVisible(matches)
            end
        end

        update()
        library:connection(run.Heartbeat, update)
        return self
    end

    function library:Tooltip(target, text, options)
        options = options or {}
        if not target or text == nil or tostring(text) == "" then
            return nil
        end

        local holder = library:create("Frame", {
            Parent = library.items;
            Name = "VoidHubTooltip";
            Visible = false;
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundColor3 = rgb(19, 19, 21);
            BorderSizePixel = 0;
            ZIndex = 90;
        })

        library:create("UICorner", {
            Parent = holder;
            CornerRadius = dim(0, 6);
        })

        library:create("UIStroke", {
            Parent = holder;
            Color = themes.preset.accent;
            Transparency = 0.35;
        })

        local label = library:create("TextLabel", {
            Parent = holder;
            Text = tostring(text);
            FontFace = fonts.small;
            TextSize = 14;
            TextColor3 = rgb(235, 235, 235);
            TextWrapped = true;
            AutomaticSize = Enum.AutomaticSize.XY;
            Size = dim2(0, min(260, tonumber(options.width) or 220), 0, 0);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            ZIndex = 91;
        })

        library:create("UIPadding", {
            Parent = holder;
            PaddingLeft = dim(0, 9);
            PaddingRight = dim(0, 9);
            PaddingTop = dim(0, 7);
            PaddingBottom = dim(0, 7);
        })

        local touch_token = 0
        local function position()
            local current_camera = ws.CurrentCamera or camera
            local viewport = current_camera and current_camera.ViewportSize
            if not viewport then return end
            local x = clamp(target.AbsolutePosition.X, 8, max(8, viewport.X - holder.AbsoluteSize.X - 8))
            local y = target.AbsolutePosition.Y + target.AbsoluteSize.Y + 7
            if y + holder.AbsoluteSize.Y > viewport.Y - 8 then
                y = target.AbsolutePosition.Y - holder.AbsoluteSize.Y - 7
            end
            holder.Position = dim_offset(x, clamp(y, 8, max(8, viewport.Y - holder.AbsoluteSize.Y - 8)))
        end

        local function show()
            holder.Visible = true
            task.defer(position)
        end

        local function hide()
            holder.Visible = false
        end

        library:connection(target.MouseEnter, show)
        library:connection(target.MouseLeave, hide)
        library:connection(target.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touch_token += 1
                local token = touch_token
                task.delay(0.4, function()
                    if token == touch_token then show() end
                end)
            end
        end)
        library:connection(target.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touch_token += 1
                task.delay(1.2, hide)
            end
        end)

        local api = {}
        function api:SetText(value)
            label.Text = tostring(value)
            task.defer(position)
        end
        function api:Show() show() end
        function api:Hide() hide() end
        function api:Destroy()
            if holder.Parent then holder:Destroy() end
        end
        return api
    end

    function library:SetTooltip(text, options)
        local root = control_root(self)
        if root then
            self.tooltip = library:Tooltip(root, text, options)
        end
        return self
    end

    function library:_register_control(control, kind, options)
        if not control or control.__voidhub_registered then
            return control
        end

        control.__voidhub_registered = true
        control.kind = kind
        control.search_name = tostring((options and (options.name or options.Name)) or control.name or kind)
        control.root = control_root(control)
        extension.controls[#extension.controls + 1] = control

        if control.root then
            set_button_animation(control.root)
        end

        local info = options and (options.info or options.description or options.tooltip)
        if info then
            control:SetTooltip(info)
        end

        return control
    end

    function library:SearchControls(query)
        query = string.lower(tostring(query or ""))
        local matches = {}

        for _, control in extension.controls do
            local root = control.root or control_root(control)
            local matched = query == "" or string.find(string.lower(control.search_name or ""), query, 1, true) ~= nil
            if matched then
                matches[#matches + 1] = control
            end
            if root and root.Parent then
                if query ~= "" and control.__search_visible == nil then
                    control.__search_visible = root.Visible
                end
                root.Visible = query == "" and (control.__search_visible ~= false) or matched
                if query == "" then
                    control.__search_visible = nil
                end
            end
        end

        return matches
    end

    function library:AddSearch(options)
        options = options or {}
        local window = self
        local parent = window.items and window.items.button_holder
        if not parent then
            return nil
        end

        local frame = library:create("Frame", {
            Parent = parent;
            Name = "SearchBar";
            LayoutOrder = tonumber(options.layoutOrder) or -1000;
            Size = dim2(1, -18, 0, 32);
            BackgroundColor3 = rgb(25, 25, 29);
            BorderSizePixel = 0;
        })

        library:create("UICorner", {
            Parent = frame;
            CornerRadius = dim(0, 7);
        })

        local input = library:create("TextBox", {
            Parent = frame;
            Position = dim2(0, 10, 0, 0);
            Size = dim2(1, -20, 1, 0);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            ClearTextOnFocus = false;
            PlaceholderText = options.placeholder or "Search features";
            PlaceholderColor3 = rgb(92, 92, 95);
            Text = "";
            TextColor3 = rgb(235, 235, 235);
            TextXAlignment = Enum.TextXAlignment.Left;
            FontFace = fonts.small;
            TextSize = 14;
        })

        library:connection(input:GetPropertyChangedSignal("Text"), function()
            library:SearchControls(input.Text)
        end)

        local api = {frame = frame, input = input}
        function api:Clear()
            input.Text = ""
        end
        function api:Focus()
            input:CaptureFocus()
        end
        return api
    end
    library.add_search = library.AddSearch

    extension.themes = {
        Void = {
            accent = rgb(155, 150, 219);
            background = rgb(8, 8, 10);
            panel = rgb(13, 13, 16);
            surface = rgb(18, 18, 21);
            control = rgb(26, 26, 30);
            text = rgb(245, 245, 245);
            muted = rgb(145, 145, 145);
        };
        Ocean = {
            accent = rgb(69, 154, 255);
            background = rgb(10, 15, 22);
            panel = rgb(16, 24, 34);
            surface = rgb(20, 31, 44);
            control = rgb(27, 41, 57);
            text = rgb(241, 247, 255);
            muted = rgb(133, 154, 178);
        };
        Emerald = {
            accent = rgb(76, 214, 157);
            background = rgb(10, 17, 15);
            panel = rgb(16, 27, 23);
            surface = rgb(21, 34, 29);
            control = rgb(28, 44, 37);
            text = rgb(241, 255, 249);
            muted = rgb(132, 165, 151);
        };
        Crimson = {
            accent = rgb(241, 82, 103);
            background = rgb(18, 10, 13);
            panel = rgb(29, 16, 20);
            surface = rgb(37, 20, 25);
            control = rgb(49, 27, 33);
            text = rgb(255, 242, 245);
            muted = rgb(174, 134, 143);
        };
        Mono = {
            accent = rgb(225, 225, 225);
            background = rgb(12, 12, 12);
            panel = rgb(20, 20, 20);
            surface = rgb(27, 27, 27);
            control = rgb(38, 38, 38);
            text = rgb(245, 245, 245);
            muted = rgb(145, 145, 145);
        };
    }

    local function color_role(instance)
        if instance:IsA("GuiObject") then
            local value = instance.BackgroundColor3
            if value == rgb(14, 14, 16) then return "background" end
            if value == rgb(22, 22, 24) then return "panel" end
            if value == rgb(25, 25, 29) or value == rgb(19, 19, 21) then return "surface" end
            if value == rgb(33, 33, 35) then return "control" end
        end
    end

    function library:RegisterTheme(name, data)
        if type(name) ~= "string" or type(data) ~= "table" then
            return false
        end
        extension.themes[name] = data
        return true
    end

    function library:GetThemes()
        local names = {}
        for name in extension.themes do
            names[#names + 1] = name
        end
        table.sort(names)
        return names
    end

    function library:ApplyTheme(theme)
        local data = type(theme) == "table" and theme or extension.themes[theme]
        if not data then
            return false, "Theme not found"
        end

        if data.accent then
            library:update_theme("accent", data.accent)
        end

        local roots = {library.items, library.mobile_toggle}
        for _, root in roots do
            if root then
                for _, instance in root:GetDescendants() do
                    if instance:IsA("GuiObject") then
                        local role = instance:GetAttribute("VoidHubThemeRole") or color_role(instance)
                        if role and data[role] then
                            instance:SetAttribute("VoidHubThemeRole", role)
                            instance.BackgroundColor3 = data[role]
                        end

                        if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
                            if instance.TextColor3 == rgb(245, 245, 245) and data.text then
                                instance.TextColor3 = data.text
                            elseif instance.TextColor3 == rgb(145, 145, 145) and data.muted then
                                instance.TextColor3 = data.muted
                            end
                        end
                    elseif instance:IsA("UIStroke") and data.accent and instance.Color == themes.preset.accent then
                        instance.Color = data.accent
                    end
                end
            end
        end

        extension.current_theme = type(theme) == "string" and theme or "Custom"
        return true
    end

    function library:SetFont(font)
        if typeof(font) ~= "Font" then
            return false
        end

        for _, root in {library.items, library.mobile_toggle} do
            if root then
                for _, instance in root:GetDescendants() do
                    if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
                        instance.FontFace = font
                    end
                end
            end
        end
        return true
    end

    function library:SetThemeTransparency(amount)
        amount = clamp(tonumber(amount) or 0, 0, 0.8)
        if not library.items then return false end

        for _, instance in library.items:GetDescendants() do
            if instance:IsA("Frame") and instance.BackgroundTransparency < 1 then
                local base = instance:GetAttribute("VoidHubBaseTransparency")
                if base == nil then
                    base = instance.BackgroundTransparency
                    instance:SetAttribute("VoidHubBaseTransparency", base)
                end
                instance.BackgroundTransparency = clamp(base + amount, 0, 0.95)
            end
        end
        return true
    end

    function library:theme_manager(options)
        options = options or {}
        local section = self
        local manager = {}
        manager.theme = section:dropdown({
            name = options.name or "Theme preset";
            items = library:GetThemes();
            default = options.default or "Void";
            callback = function(value)
                library:ApplyTheme(value)
                if options.callback then options.callback(value) end
            end
        })
        manager.transparency = section:slider({
            name = "Transparency";
            min = 0;
            max = 0.6;
            interval = 0.05;
            default = tonumber(options.transparency) or 0;
            callback = function(value)
                library:SetThemeTransparency(value)
            end
        })
        return manager
    end
    library.ThemeManager = library.theme_manager

    function library:SetConfigScope(scope)
        local directory = library.directory .. "/configs"
        if scope == "game" or scope == true then
            directory = directory .. "/" .. tostring(game.GameId ~= 0 and game.GameId or game.PlaceId)
        elseif type(scope) == "string" and scope ~= "" and scope ~= "global" then
            directory = directory .. "/" .. scope:gsub("[\\/:*?\"<>|]", "_")
        end

        if not isfolder(directory) then
            makefolder(directory)
        end

        extension.config_directory = directory
        library:update_config_list()
        return directory
    end

    function library:GetConfigDirectory()
        return extension.config_directory or (library.directory .. "/configs")
    end

    function library:get_config_path(name)
        local safe_name = sanitize_config_name(name)
        if not safe_name then return nil, nil end
        return library:GetConfigDirectory() .. "/" .. safe_name .. ".cfg", safe_name
    end

    function library:get_config_list()
        local configs, seen = {}, {}
        local ok, files = pcall(listfiles, library:GetConfigDirectory())
        if not ok or type(files) ~= "table" then return configs end

        for _, file in files do
            local normalized = tostring(file):gsub("\\", "/")
            local name = normalized:match("([^/]+)%.cfg$")
            if name and not seen[name] then
                seen[name] = true
                configs[#configs + 1] = name
            end
        end

        table.sort(configs, function(a, b)
            return string.lower(a) < string.lower(b)
        end)
        return configs
    end

    function library:DuplicateConfig(source_name, target_name)
        local source_path = library:get_config_path(source_name)
        local target_path, safe_target = library:get_config_path(target_name)
        if not source_path or not target_path then return false, "Enter source and target names" end
        if isfile and not isfile(source_path) then return false, "Source config does not exist" end
        local ok, data = pcall(readfile, source_path)
        if not ok then return false, tostring(data) end
        local saved, save_error = pcall(writefile, target_path, data)
        if not saved then return false, tostring(save_error) end
        library:update_config_list(safe_target)
        return true, safe_target
    end

    function library:RenameConfig(source_name, target_name)
        local copied, result = library:DuplicateConfig(source_name, target_name)
        if not copied then return false, result end
        local deleted, delete_error = library:delete_config(source_name)
        if not deleted then return false, delete_error end
        library:update_config_list(result)
        return true, result
    end

    function library:ExportConfig(name)
        local path = library:get_config_path(name)
        if not path then return false, "Select a config" end
        local ok, data = pcall(readfile, path)
        if not ok then return false, tostring(data) end
        return true, data
    end

    function library:ImportConfig(name, data)
        local path, safe_name = library:get_config_path(name)
        if not path then return false, "Enter a config name" end
        local valid = pcall(function() http_service:JSONDecode(data) end)
        if not valid then return false, "Invalid config JSON" end
        local ok, write_error = pcall(writefile, path, data)
        if not ok then return false, tostring(write_error) end
        library:update_config_list(safe_name)
        return true, safe_name
    end

    function library:EnableAutoSave(name, interval)
        extension.auto_save_token += 1
        local token = extension.auto_save_token
        interval = max(5, tonumber(interval) or 30)

        task.spawn(function()
            while not extension.unloading and token == extension.auto_save_token do
                task.wait(interval)
                if token == extension.auto_save_token and not extension.unloading then
                    library:save_config(name)
                end
            end
        end)

        return token
    end

    function library:DisableAutoSave()
        extension.auto_save_token += 1
    end

    function library:multi_dropdown(options)
        options = copy_table(options)
        options.multi = true
        local control = self:dropdown(options)
        local all_options = options.items or {}

        function control:SelectAll()
            control.set(all_options)
            return control
        end

        function control:Clear()
            control.set({})
            return control
        end

        function control:SearchOptions(query)
            query = string.lower(tostring(query or ""))
            local filtered = {}
            for _, value in all_options do
                if query == "" or string.find(string.lower(tostring(value)), query, 1, true) then
                    filtered[#filtered + 1] = value
                end
            end
            control.refresh_options(filtered)
            return filtered
        end

        local outline = control.items and control.items.outline
        if outline then
            local actions = library:create("Frame", {
                Parent = outline;
                LayoutOrder = -100;
                Size = dim2(1, -6, 0, 28);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                ZIndex = 11;
            })
            local all = library:create("TextButton", {
                Parent = actions;
                Text = "All";
                Size = dim2(0.5, -2, 1, 0);
                BackgroundColor3 = rgb(42, 42, 45);
                TextColor3 = rgb(220, 220, 220);
                FontFace = fonts.small;
                TextSize = 13;
                BorderSizePixel = 0;
                ZIndex = 12;
            })
            local clear = library:create("TextButton", {
                Parent = actions;
                Text = "Clear";
                Position = dim2(0.5, 2, 0, 0);
                Size = dim2(0.5, -2, 1, 0);
                BackgroundColor3 = rgb(42, 42, 45);
                TextColor3 = rgb(220, 220, 220);
                FontFace = fonts.small;
                TextSize = 13;
                BorderSizePixel = 0;
                ZIndex = 12;
            })
            library:create("UICorner", {Parent = all; CornerRadius = dim(0, 4)})
            library:create("UICorner", {Parent = clear; CornerRadius = dim(0, 4)})
            library:connection(all.Activated, function() control:SelectAll() end)
            library:connection(clear.Activated, function() control:Clear() end)

            local old_refresh = control.refresh_options
            control.refresh_options = function(list)
                old_refresh(list)
                control.y_size += 34
            end
            control.y_size += 34
        end

        return control
    end
    library.MultiDropdown = library.multi_dropdown

    function library:CreateDrawer(options)
        options = options or {}
        local _, viewport = mobile_view()
        viewport = viewport or vec2(800, 600)
        local height = min(tonumber(options.height) or 300, viewport.Y - 24)

        local overlay = library:create("TextButton", {
            Parent = library.items;
            Name = "MobileDrawerOverlay";
            Text = "";
            AutoButtonColor = false;
            Size = dim2(1, 0, 1, 0);
            BackgroundColor3 = rgb(0, 0, 0);
            BackgroundTransparency = 0.35;
            BorderSizePixel = 0;
            Visible = false;
            ZIndex = 70;
        })

        local drawer = library:create("Frame", {
            Parent = overlay;
            AnchorPoint = vec2(0.5, 1);
            Position = dim2(0.5, 0, 1, 0);
            Size = dim2(1, -24, 0, height);
            BackgroundColor3 = rgb(19, 19, 21);
            BorderSizePixel = 0;
            ZIndex = 71;
        })
        library:create("UICorner", {Parent = drawer; CornerRadius = dim(0, 12)})

        local title = library:create("TextLabel", {
            Parent = drawer;
            Text = options.title or "Options";
            Position = dim2(0, 14, 0, 0);
            Size = dim2(1, -56, 0, 44);
            BackgroundTransparency = 1;
            TextColor3 = rgb(245, 245, 245);
            TextXAlignment = Enum.TextXAlignment.Left;
            FontFace = fonts.font;
            TextSize = 16;
            BorderSizePixel = 0;
            ZIndex = 72;
        })

        local close = library:create("TextButton", {
            Parent = drawer;
            Text = "×";
            AnchorPoint = vec2(1, 0);
            Position = dim2(1, -10, 0, 8);
            Size = dim2(0, 30, 0, 30);
            BackgroundColor3 = rgb(33, 33, 35);
            TextColor3 = rgb(235, 235, 235);
            FontFace = fonts.font;
            TextSize = 20;
            BorderSizePixel = 0;
            ZIndex = 73;
        })
        library:create("UICorner", {Parent = close; CornerRadius = dim(0, 7)})

        local content = library:create("ScrollingFrame", {
            Parent = drawer;
            Position = dim2(0, 10, 0, 48);
            Size = dim2(1, -20, 1, -58);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
            CanvasSize = dim2(0, 0, 0, 0);
            ScrollBarThickness = 3;
            ScrollBarImageColor3 = themes.preset.accent;
            ZIndex = 72;
        })
        library:create("UIListLayout", {Parent = content; Padding = dim(0, 8); SortOrder = Enum.SortOrder.LayoutOrder})
        library:create("UIPadding", {Parent = content; PaddingBottom = dim(0, 8)})

        local api = {overlay = overlay, drawer = drawer, content = content, title = title}
        function api:Open()
            overlay.Visible = true
            drawer.Position = dim2(0.5, 0, 1, height)
            library:tween(drawer, {Position = dim2(0.5, 0, 1, 0)}, Enum.EasingStyle.Quint, 0.22)
            return api
        end
        function api:Close()
            library:tween(drawer, {Position = dim2(0.5, 0, 1, height)}, Enum.EasingStyle.Quint, 0.18)
            task.delay(0.19, function()
                if overlay.Parent then overlay.Visible = false end
            end)
            return api
        end
        function api:Toggle()
            if overlay.Visible then return api:Close() end
            return api:Open()
        end
        function api:Destroy()
            if overlay.Parent then overlay:Destroy() end
        end

        library:connection(close.Activated, function() api:Close() end)
        library:connection(overlay.Activated, function() api:Close() end)
        extension.drawers[#extension.drawers + 1] = api
        if options.build then options.build(content, api) end
        return api
    end

    function library:Confirm(options)
        options = options or {}
        local modal = library:CreateDrawer({
            title = options.title or "Confirm action";
            height = tonumber(options.height) or 190;
        })

        local message = library:create("TextLabel", {
            Parent = modal.content;
            Text = options.message or "Are you sure?";
            Size = dim2(1, -8, 0, 64);
            BackgroundTransparency = 1;
            TextColor3 = rgb(190, 190, 194);
            TextWrapped = true;
            FontFace = fonts.small;
            TextSize = 14;
            BorderSizePixel = 0;
            ZIndex = 74;
        })

        local actions = library:create("Frame", {
            Parent = modal.content;
            Size = dim2(1, -8, 0, 42);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            ZIndex = 74;
        })

        local cancel = library:create("TextButton", {
            Parent = actions;
            Text = options.cancelText or "Cancel";
            Size = dim2(0.5, -4, 1, 0);
            BackgroundColor3 = rgb(33, 33, 35);
            TextColor3 = rgb(220, 220, 220);
            FontFace = fonts.font;
            TextSize = 14;
            BorderSizePixel = 0;
            ZIndex = 75;
        })

        local confirm = library:create("TextButton", {
            Parent = actions;
            Text = options.confirmText or "Confirm";
            Position = dim2(0.5, 4, 0, 0);
            Size = dim2(0.5, -4, 1, 0);
            BackgroundColor3 = themes.preset.accent;
            TextColor3 = rgb(255, 255, 255);
            FontFace = fonts.font;
            TextSize = 14;
            BorderSizePixel = 0;
            ZIndex = 75;
        })

        library:create("UICorner", {Parent = cancel; CornerRadius = dim(0, 7)})
        library:create("UICorner", {Parent = confirm; CornerRadius = dim(0, 7)})
        library:connection(cancel.Activated, function()
            modal:Close()
            if options.onCancel then options.onCancel() end
        end)
        library:connection(confirm.Activated, function()
            modal:Close()
            if options.callback then options.callback() end
        end)

        modal:Open()
        return modal
    end

    function library:progressbar(options)
        options = options or {}
        local cfg = {
            name = options.name or "Progress";
            value = tonumber(options.default) or 0;
            min = tonumber(options.min) or 0;
            max = tonumber(options.max) or 100;
            items = {};
        }
        local items = cfg.items
        items.progress = library:create("Frame", {
            Parent = self.items.elements;
            Size = dim2(1, 0, 0, 40);
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
        })
        items.name = library:create("TextLabel", {
            Parent = items.progress;
            Text = cfg.name;
            Size = dim2(0.7, 0, 0, 18);
            BackgroundTransparency = 1;
            TextColor3 = rgb(245, 245, 245);
            TextXAlignment = Enum.TextXAlignment.Left;
            FontFace = fonts.small;
            TextSize = 14;
            BorderSizePixel = 0;
        })
        items.value = library:create("TextLabel", {
            Parent = items.progress;
            Text = "";
            AnchorPoint = vec2(1, 0);
            Position = dim2(1, 0, 0, 0);
            Size = dim2(0.3, 0, 0, 18);
            BackgroundTransparency = 1;
            TextColor3 = rgb(145, 145, 145);
            TextXAlignment = Enum.TextXAlignment.Right;
            FontFace = fonts.small;
            TextSize = 13;
            BorderSizePixel = 0;
        })
        items.track = library:create("Frame", {
            Parent = items.progress;
            Position = dim2(0, 0, 0, 25);
            Size = dim2(1, 0, 0, 7);
            BackgroundColor3 = rgb(38, 38, 41);
            BorderSizePixel = 0;
        })
        items.fill = library:create("Frame", {
            Parent = items.track;
            Size = dim2(0, 0, 1, 0);
            BackgroundColor3 = themes.preset.accent;
            BorderSizePixel = 0;
        })
        library:create("UICorner", {Parent = items.track; CornerRadius = dim(0, 999)})
        library:create("UICorner", {Parent = items.fill; CornerRadius = dim(0, 999)})
        library:apply_theme(items.fill, "accent", "BackgroundColor3")

        function cfg:Set(value)
            cfg.value = clamp(tonumber(value) or cfg.min, cfg.min, cfg.max)
            local alpha = cfg.max == cfg.min and 0 or (cfg.value - cfg.min) / (cfg.max - cfg.min)
            items.value.Text = tostring(library:round(cfg.value, options.interval or 1)) .. (options.suffix or "")
            library:tween(items.fill, {Size = dim2(alpha, 0, 1, 0)}, Enum.EasingStyle.Quad, 0.16)
            return cfg.value
        end
        cfg.set = cfg.Set
        cfg:Set(cfg.value)
        return library:_register_control(setmetatable(cfg, library), "progress", options)
    end
    library.ProgressBar = library.progressbar

    function library:status(options)
        options = options or {}
        local cfg = {name = options.name or "Status"; value = options.default or "Ready"; items = {}}
        local items = cfg.items
        items.status = library:create("Frame", {
            Parent = self.items.elements;
            Size = dim2(1, 0, 0, 30);
            BackgroundColor3 = rgb(25, 25, 29);
            BorderSizePixel = 0;
        })
        library:create("UICorner", {Parent = items.status; CornerRadius = dim(0, 6)})
        items.dot = library:create("Frame", {
            Parent = items.status;
            AnchorPoint = vec2(0, 0.5);
            Position = dim2(0, 9, 0.5, 0);
            Size = dim2(0, 8, 0, 8);
            BackgroundColor3 = options.color or themes.preset.accent;
            BorderSizePixel = 0;
        })
        library:create("UICorner", {Parent = items.dot; CornerRadius = dim(0, 999)})
        items.text = library:create("TextLabel", {
            Parent = items.status;
            Position = dim2(0, 24, 0, 0);
            Size = dim2(1, -32, 1, 0);
            BackgroundTransparency = 1;
            Text = cfg.name .. ": " .. tostring(cfg.value);
            TextColor3 = rgb(225, 225, 225);
            TextXAlignment = Enum.TextXAlignment.Left;
            FontFace = fonts.small;
            TextSize = 14;
            BorderSizePixel = 0;
        })
        function cfg:Set(value, color_value)
            cfg.value = value
            items.text.Text = cfg.name .. ": " .. tostring(value)
            if color_value then items.dot.BackgroundColor3 = color_value end
        end
        cfg.set = cfg.Set
        return library:_register_control(setmetatable(cfg, library), "status", options)
    end
    library.Status = library.status

    function library:timer(options)
        options = options or {}
        local duration = max(0, tonumber(options.duration) or 60)
        local remaining = duration
        local control = self:status({name = options.name or "Timer"; default = remaining .. "s"; color = options.color})
        local token = 0

        function control:Start(seconds)
            token += 1
            local current = token
            remaining = tonumber(seconds) or duration
            task.spawn(function()
                while current == token and remaining >= 0 and not extension.unloading do
                    control:Set(math.ceil(remaining) .. "s")
                    if remaining <= 0 then break end
                    task.wait(1)
                    remaining -= 1
                end
                if current == token and options.callback then options.callback() end
            end)
        end
        function control:Stop() token += 1 end
        function control:Reset() control:Stop(); remaining = duration; control:Set(math.ceil(remaining) .. "s") end
        if options.autoStart then control:Start() end
        return control
    end
    library.Timer = library.timer

    function library:profile(options)
        options = options or {}
        local cfg = {items = {}, name = options.name or lp.DisplayName}
        local items = cfg.items
        items.profile = library:create("Frame", {
            Parent = self.items.elements;
            Size = dim2(1, 0, 0, 82);
            BackgroundColor3 = rgb(25, 25, 29);
            BorderSizePixel = 0;
        })
        library:create("UICorner", {Parent = items.profile; CornerRadius = dim(0, 8)})
        items.avatar = library:create("ImageLabel", {
            Parent = items.profile;
            Position = dim2(0, 10, 0.5, -27);
            Size = dim2(0, 54, 0, 54);
            Image = options.image or ("rbxthumb://type=AvatarHeadShot&id=" .. tostring(lp.UserId) .. "&w=150&h=150");
            BackgroundColor3 = rgb(33, 33, 35);
            BorderSizePixel = 0;
        })
        library:create("UICorner", {Parent = items.avatar; CornerRadius = dim(0, 10)})
        items.name = library:create("TextLabel", {
            Parent = items.profile;
            Position = dim2(0, 74, 0, 12);
            Size = dim2(1, -84, 0, 20);
            BackgroundTransparency = 1;
            Text = options.name or lp.DisplayName;
            TextColor3 = rgb(245, 245, 245);
            TextXAlignment = Enum.TextXAlignment.Left;
            FontFace = fonts.font;
            TextSize = 16;
            BorderSizePixel = 0;
        })
        items.info = library:create("TextLabel", {
            Parent = items.profile;
            Position = dim2(0, 74, 0, 34);
            Size = dim2(1, -84, 0, 17);
            BackgroundTransparency = 1;
            Text = options.game or game.Name;
            TextColor3 = rgb(145, 145, 145);
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            FontFace = fonts.small;
            TextSize = 13;
            BorderSizePixel = 0;
        })
        items.stats = library:create("TextLabel", {
            Parent = items.profile;
            Position = dim2(0, 74, 0, 53);
            Size = dim2(1, -84, 0, 16);
            BackgroundTransparency = 1;
            Text = "";
            TextColor3 = rgb(105, 105, 110);
            TextXAlignment = Enum.TextXAlignment.Left;
            FontFace = fonts.small;
            TextSize = 12;
            BorderSizePixel = 0;
        })

        local frames, elapsed = 0, 0
        library:connection(run.RenderStepped, function(delta)
            frames += 1
            elapsed += delta
            if elapsed >= 1 then
                local fps = math.floor(frames / elapsed + 0.5)
                local ping = "?"
                pcall(function()
                    ping = stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                end)
                local executor = identifyexecutor and ({identifyexecutor()})[1] or "Roblox"
                items.stats.Text = tostring(fps) .. " FPS  •  " .. tostring(ping) .. "  •  " .. tostring(executor)
                frames, elapsed = 0, 0
            end
        end)

        return library:_register_control(setmetatable(cfg, library), "profile", options)
    end
    library.Profile = library.profile

    function library:GetKeybinds()
        return extension.keybinds
    end

    function library:FindKeybindConflicts()
        local used, conflicts = {}, {}
        for _, entry in extension.keybinds do
            local value = flags[entry.flag]
            local key = value and tostring(value.key)
            if key and key ~= "nil" and key ~= "NONE" then
                if used[key] then
                    conflicts[#conflicts + 1] = {key = key; first = used[key]; second = entry}
                else
                    used[key] = entry
                end
            end
        end
        return conflicts
    end

    function library:CreateKeybindManager(section, options)
        options = options or {}
        local manager = {rows = {}}

        function manager:Refresh()
            for _, row in manager.rows do
                row:SetVisible(false)
            end
            manager.rows = {}

            for _, entry in extension.keybinds do
                local value = flags[entry.flag]
                local key = value and value.key or "NONE"
                local row = section:label({
                    name = (entry.name or entry.flag) .. ": " .. tostring(key):gsub("Enum.KeyCode.", "");
                })
                manager.rows[#manager.rows + 1] = row
            end
            return manager.rows
        end

        manager:Refresh()
        return manager
    end

    function notifications:create_notification(options)
        options = options or {}
        extension.notification_history[#extension.notification_history + 1] = {
            name = options.name or "Notification";
            info = options.info or "";
            time = os.time();
            kind = options.type or options.kind or "info";
        }
        if #extension.notification_history > 100 then
            table.remove(extension.notification_history, 1)
        end
        return base_notification(self, options)
    end

    function library:Notify(options)
        if type(options) == "string" then
            options = {name = "VoidHub"; info = options}
        end
        return notifications:create_notification(options or {})
    end

    function library:GetNotificationHistory()
        return extension.notification_history
    end

    function library:ClearNotificationHistory()
        table.clear(extension.notification_history)
    end

    function library:CreateNotificationCenter(section, options)
        options = options or {}
        local center = {rows = {}}

        function center:Refresh()
            for _, row in center.rows do
                row:SetVisible(false)
            end
            center.rows = {}

            local history = extension.notification_history
            local first = max(1, #history - (tonumber(options.limit) or 5) + 1)
            for index = #history, first, -1 do
                local entry = history[index]
                center.rows[#center.rows + 1] = section:label({
                    name = entry.name;
                    info = entry.info;
                })
            end
            return center.rows
        end

        center:Refresh()
        return center
    end

    function library:RegisterPlugin(name, initializer)
        if type(name) ~= "string" or type(initializer) ~= "function" then
            return false
        end
        extension.plugins[name] = {initializer = initializer; loaded = false}
        return true
    end

    function library:LoadPlugin(name, context)
        local plugin = extension.plugins[name]
        if not plugin then return false, "Plugin not found" end
        if plugin.loaded then return true, plugin.instance end
        local ok, instance = pcall(plugin.initializer, library, context or {})
        if not ok then return false, tostring(instance) end
        plugin.instance = instance
        plugin.loaded = true
        return true, instance
    end

    function library:UnloadPlugin(name)
        local plugin = extension.plugins[name]
        if not plugin then return false, "Plugin not found" end
        if plugin.instance and type(plugin.instance.Unload) == "function" then
            pcall(function() plugin.instance:Unload() end)
        elseif plugin.instance and type(plugin.instance.unload) == "function" then
            pcall(function() plugin.instance:unload() end)
        end
        plugin.instance = nil
        plugin.loaded = false
        return true
    end

    function library:section(options)
        local control = base_section(self, options)
        return library:_register_control(control, "groupbox", options)
    end

    function library:toggle(options)
        return library:_register_control(base_toggle(self, options), "toggle", options)
    end

    function library:slider(options)
        return library:_register_control(base_slider(self, options), "slider", options)
    end

    function library:dropdown(options)
        return library:_register_control(base_dropdown(self, options), "dropdown", options)
    end

    function library:label(options)
        return library:_register_control(base_label(self, options), "label", options)
    end

    function library:colorpicker(options)
        return library:_register_control(base_colorpicker(self, options), "colorpicker", options)
    end

    function library:textbox(options)
        return library:_register_control(base_textbox(self, options), "textbox", options)
    end

    function library:keybind(options)
        local control = library:_register_control(base_keybind(self, options), "keybind", options)
        extension.keybinds[#extension.keybinds + 1] = {
            name = options.name;
            flag = control.flag;
            control = control;
        }
        return control
    end

    function library:button(options)
        options = options or {}
        local source = copy_table(options)
        local callback = source.callback or function() end
        local confirm_mode = source.confirmMode or source.confirm_mode

        if source.confirm == true and confirm_mode ~= "hold" then
            source.callback = function()
                library:Confirm({
                    title = source.confirmTitle or "Confirm action";
                    message = source.confirmMessage or ("Continue with " .. tostring(source.name or "this action") .. "?");
                    confirmText = source.confirmText;
                    cancelText = source.cancelText;
                    callback = callback;
                })
            end
        elseif confirm_mode == "hold" or source.holdToConfirm == true then
            source.callback = function() end
        end

        local control = library:_register_control(base_button(self, source), "button", source)
        if confirm_mode == "hold" or source.holdToConfirm == true then
            local button = control.items and control.items.button
            local holding = 0
            if button then
                library:connection(button.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.Touch
                        or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        holding += 1
                        local token = holding
                        library:tween(button, {BackgroundColor3 = themes.preset.accent}, Enum.EasingStyle.Linear, tonumber(source.holdDuration) or 0.7)
                        task.delay(tonumber(source.holdDuration) or 0.7, function()
                            if token == holding and button.Parent then
                                callback()
                                button.BackgroundColor3 = rgb(33, 33, 35)
                            end
                        end)
                    end
                end)
                library:connection(button.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.Touch
                        or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        holding += 1
                        library:tween(button, {BackgroundColor3 = rgb(33, 33, 35)}, Enum.EasingStyle.Quad, 0.12)
                    end
                end)
            end
        end
        return control
    end

    function library:groupboxes(properties)
        properties = properties or {}
        local boxes = base_groupboxes(self, properties)
        local left = boxes.left_column and boxes.left_column.items.column
        local right = boxes.right_column and boxes.right_column.items.column
        local threshold = tonumber(properties.singleColumnWidth or properties.single_column_width)
            or (uis.TouchEnabled and 700 or 520)
        local responsive = properties.responsive ~= false
        local original_parents = {
            top_left = left;
            bottom_left = left;
            top_right = right;
            bottom_right = right;
        }

        local function set_parent(box, parent)
            if box and box.items and box.items.outline then
                box.items.outline.Parent = parent
            end
        end

        function boxes:UpdateResponsive()
            if not responsive or not left or not right then return false end
            local current_camera = ws.CurrentCamera or camera
            local viewport = current_camera and current_camera.ViewportSize
            local single = viewport and viewport.X <= threshold

            if single then
                set_parent(boxes.top_left, left)
                set_parent(boxes.top_right, left)
                set_parent(boxes.bottom_left, left)
                set_parent(boxes.bottom_right, left)
                right.Visible = false
            else
                set_parent(boxes.top_left, original_parents.top_left)
                set_parent(boxes.bottom_left, original_parents.bottom_left)
                set_parent(boxes.top_right, original_parents.top_right)
                set_parent(boxes.bottom_right, original_parents.bottom_right)
                right.Visible = true
            end

            return single
        end

        boxes:UpdateResponsive()
        local current_camera = ws.CurrentCamera or camera
        if current_camera then
            library:connection(current_camera:GetPropertyChangedSignal("ViewportSize"), function()
                boxes:UpdateResponsive()
            end)
        end
        return boxes
    end
    library.groupbox_grid = library.groupboxes
    library.group_boxes = library.groupboxes

    function library:unload()
        if extension.unloading then return true end
        extension.unloading = true
        extension.auto_save_token += 1

        for name, plugin in extension.plugins do
            if plugin.loaded then
                pcall(function() library:UnloadPlugin(name) end)
            end
        end

        for _, connection in library.connections do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(library.connections)

        for _, key in {"items", "other", "mobile_toggle"} do
            local instance = library[key]
            if typeof(instance) == "Instance" then
                pcall(function() instance:Destroy() end)
            end
            library[key] = nil
        end

        local environment = getgenv()
        local current_library = library
        if type(environment.VoidHubUI) == "table" and environment.VoidHubUI.library == current_library then
            environment.VoidHubUI = nil
        end
        if environment.library == current_library then
            environment.library = nil
        end
        return true
    end
    library.unload_menu = library.unload
    library.Unload = library.unload
    library:ApplyTheme("Void")
end

return library
