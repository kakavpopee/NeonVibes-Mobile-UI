# NeonVibes Mobile UI

Mobile-optimized Roblox UI library inspired by Rayfield and Fluent, with full TurtleUiLib-style features.

**Modern design** • **Touch-friendly** • **Delta / FluxusZ / Hydrogen compatible** • **Smooth animations & neon glow**

## Quick Load (Recommended)

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()
```
## Quick Start Example
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()

-- Create main window
local mainWindow = library:Window("My Mobile Hub")

-- Basic button
mainWindow:Button("Teleport Home", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
    library:Notify("Teleported to spawn!", 3)
end)

-- Label with rainbow effect
mainWindow:Label("Welcome to NeonVibes!", true)

-- Toggle with state callback
mainWindow:Toggle("Infinite Jump", false, function(state)
    print("Infinite Jump:", state)
end)

-- Text input box
mainWindow:Box("Custom Message", function(value, focused)
    if focused then
        print("Message sent:", value)
    end
end)

-- Slider with value callback
mainWindow:Slider("Walk Speed", 16, 300, 50, function(value)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = value
    end
end)

-- Dropdown with dynamic options
local espDropdown = mainWindow:Dropdown("ESP Mode", {"Box", "Tracer", "None"}, function(selected)
    print("ESP changed to:", selected)
end, true) -- true = button text updates to selected option

espDropdown:Button("Custom ESP") -- add new option dynamically

-- Color picker with rainbow toggle support
local colorPicker = mainWindow:ColorPicker("ESP Color", Color3.fromRGB(255, 0, 100), function(color)
    print("New color:", color)
end)

-- Change color later
colorPicker:UpdateColorPicker(Color3.fromRGB(0, 255, 0))
```

```lua
-- Global controls
library:Keybind("RightShift")   -- press RightShift to hide/show all UI
library:Hide()                  -- toggle visibility manually
-- library:Destroy()            -- completely remove UI (uncomment if needed)
Global Library Methods
library:Window(name: string) → window object
library:Hide()                        -- Toggle all UI visibility
library:Keybind(key: string)          -- Set global toggle key (e.g. "RightShift", "Q", etc.)
library:Destroy()                     -- Completely remove the entire UI library
Window Object Methods
Every window returned by library:Window() has these methods:
window:Button(name: string, callback: function())
window:Label(text: string, rainbow: boolean?)
window:Toggle(text: string, default: boolean, callback: function(state: boolean))
window:Box(text: string, callback: function(value: string, focused: boolean))
window:Slider(text: string, min: number, max: number, default: number, callback: function(value: number))
window:Dropdown(text: string, options: {string}, callback: function(selected: string), selective: boolean?)
    → dropdown object with :Button(name) and :Remove(name) methods
window:ColorPicker(name: string, default: Color3|boolean, callback: function(color: Color3))
    → colorPicker object with :UpdateColorPicker(color: Color3|boolean) method
Dropdown Object Methods
dropdown:Button(name: string)     -- Add a new option to the dropdown
dropdown:Remove(name: string)     -- Remove an existing option by name
ColorPicker Object Methods
colorPicker:UpdateColorPicker(color: Color3 | boolean)
-- Pass Color3 to set specific color
-- Pass true/false to enable/disable rainbow mode
```
# Raw Source
https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua
# MIT License – Free to use, modify, and distribute


