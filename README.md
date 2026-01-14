# NeonVibes Mobile UI

Mobile-first Roblox UI library with neon aesthetic, Rayfield/Fluent inspired design, and full TurtleUiLib feature set.  
Optimized for Delta, FluxusZ, Hydrogen on mobile. Includes unique reopen icon.

## Quick Load

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()
```

## Quick Start Example

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()

local window = library:CreateWindow("NeonVibes Hub")

local mainTab = window:CreateTab("Main")

mainTab:Button("Teleport Home", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
end)

mainTab:Label("Welcome!", true) -- rainbow mode

mainTab:Toggle("Godmode", false, function(state)
    print("Godmode:", state)
end)

mainTab:Box("Custom Speed", function(value, focused)
    if focused then
        local speed = tonumber(value)
        if speed then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = speed
            end
        end
    end
end)

mainTab:Slider("Walk Speed", 16, 500, 50, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

local dropdown = mainTab:Dropdown("ESP Mode", {"Box", "Tracer", "None"}, function(selected)
    print("ESP:", selected)
end, true)

dropdown:Button("Custom ESP")

mainTab:ColorPicker("ESP Color", Color3.fromRGB(255, 0, 100), function(color)
    print("Color changed:", color)
end)

library:Keybind("RightShift") -- global hide/show key

-- Close window with red × → round neon icon appears top-left. Tap to reopen.
```

## API Reference

### Global Library Methods

```lua
library:CreateWindow(name: string) → window object
library:Keybind(keyName: string)      -- Set global toggle key (e.g. "RightShift")
library:Hide()                        -- Toggle UI visibility
library:Destroy()                     -- Remove entire UI
```

### Window Object Methods

```lua
window:CreateTab(name: string) → tab object

window:Button(text: string, callback: function())
window:Label(text: string, rainbow: boolean?)
window:Toggle(text: string, default: boolean, callback: function(state: boolean))
window:Box(text: string, callback: function(value: string, focused: boolean))
window:Slider(text: string, min: number, max: number, default: number, callback: function(value: number))
window:Dropdown(text: string, options: {string}, callback: function(selected: string), selective: boolean?)
    → dropdown object with :Button(name: string) method
window:ColorPicker(name: string, default: Color3|boolean, callback: function(color: Color3))
    → colorPicker object with :UpdateColorPicker(color: Color3|boolean) method
window:Notify(text: string, duration: number?)
```

### Dropdown Object

```lua
dropdown:Button(name: string)     -- Add new option
```

### Special Features

- **Reopen Icon**  
  Close window with red × → GUI hides, neon round icon appears top-left.  
  Tap icon → GUI reopens smoothly. Built-in for all users.

- **Tabs**  
  Horizontal scrolling tab bar, instant content switching.

- **Dragging**  
  Drag title bar → entire window (title + content + elements) moves.

- **Notifications**  
  Slide-in from right with neon stroke.

## Raw Source

https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua

MIT License – Free to use, modify, distribute
```    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    end
    mainWindow:Notify("Teleported!", 3)
end)

mainTab:Label("Welcome Message", true) -- rainbow effect

mainTab:Toggle("Godmode", false, function(state)
    print("Godmode:", state)
end)

mainTab:Box("Custom Command", function(value, focused)
    if focused then
        print("Command entered:", value)
    end
end)

mainTab:Slider("Speed", 16, 300, 50, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

-- Tab 2 - Visuals
local visualsTab = mainWindow:CreateTab("Visuals")

local espDropdown = visualsTab:Dropdown("ESP Mode", {"Box", "Tracer", "None"}, function(selected)
    print("ESP changed to:", selected)
end, true) -- selective = true → button text updates

espDropdown:Button("Custom ESP") -- add new option

visualsTab:ColorPicker("ESP Color", Color3.fromRGB(255, 0, 100), function(color)
    print("Color updated:", color)
end)

-- Global controls
library:Keybind("RightShift")   -- Press RightShift to hide/show all UI
library:Hide()                  -- Toggle visibility manually
-- library:Destroy()            -- Remove UI completely (uncomment if needed)

-- Custom feature demo
mainWindow:Notify("Close with red × → round neon icon appears top-left. Tap to reopen!", 6)
```
## Full API Reference
Global Library Methods
```lua
library:CreateWindow(name: string) → window object
library:Keybind(keyName: string)      -- Set global hide/show key (e.g. "RightShift")
library:Hide()                        -- Toggle all UI visibility
library:Destroy()                     -- Completely remove the library
```
## Window Methods
window:CreateTab(name: string) → tab object
```lua
window:Button(text: string, callback: function())
window:Label(text: string, rainbow: boolean?)
window:Toggle(text: string, default: boolean, callback: function(state: boolean))
window:Box(text: string, callback: function(value: string, focused: boolean))
window:Slider(text: string, min: number, max: number, default: number, callback: function(value: number))
window:Dropdown(text: string, options: {string}, callback: function(selected: string), selective: boolean?)
    → dropdown object with :Button(name) and :Remove(name) methods
window:ColorPicker(name: string, default: Color3|boolean, callback: function(color: Color3))
    → colorPicker object with :UpdateColorPicker(color: Color3|boolean)
window:Notify(text: string, duration: number?)
```
## Dropdown Object
```lua
dropdown:Button(name: string)     -- Add new option
dropdown:Remove(name: string)     -- Remove option by name
```
## ColorPickerkerject
```lua
colorPicker:UpdateColorPicker(color: Color3 | boolean)
-- Color3 → set specific color
-- true/false → enable/disable rainbow mode
```
## Special Feature: Reopen Icon
***When any window is closed with the red × button:***

- GUI hides (not destroys)
Round neon icon appears top-left corner
- Tap/click icon → GUI reopens smoothly
- Built-in for all users – no extra code needed
## Features Overview
- Multiple draggable windows
Per-window minimize & close
- Global reopen icon (top-left, round, neon)
- Full TurtleUiLib elements (Button, Label, Toggle, Box, Slider, Dropdown, ColorPicker)
- Tabs (horizontal scrolling, instant switch)
- Scrolling content with auto size
- Smooth animations & ripple effects
- Mobile touch optimized (large targets, drag support)
- Global hide/show keybind
- Delta / FluxusZ / Hydrogen compatible
## Raw Source: https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua
***MIT License – Free to use and to modify,and to distribuite***

