# Made By ❤ by #KaolinScrpts

# NeonVibes Mobile UI – Turtle-Style Edition (Rayfield/Fluent Inspired)

Mobile-optimized Roblox UI library with full TurtleUiLib features + modern Rayfield/Fluent look.

## Quick Load

```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()
```
## Basic Usage Example
local window = library:Window("Main Hub")

window:Button("Teleport Home", function()
    print("Teleported!")
end)

window:Label("Welcome!", true) -- rainbow mode

window:Toggle("Godmode", true, function(state)
    print("Godmode:", state)
end)

window:Box("Custom Speed", function(text, focused)
    if focused then
        print("Speed set to:", text)
    end
end)

window:Slider("WalkSpeed", 16, 500, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

local dropdown = window:Dropdown("ESP Mode", {"Box", "Tracer", "None"}, function(selected)
    print("ESP changed to:", selected)
end, true) -- selective = true makes button text update

dropdown:Button("Custom Option")

local cp = window:ColorPicker("ESP Color", Color3.fromRGB(255,0,0), function(color)
    print("Color:", color)
end)

cp:UpdateColorPicker(Color3.fromRGB(0,255,0)) -- change later
Global Controls
library:Hide()                -- toggle all UI visibility
library:Keybind("RightShift") -- press this key to hide/show UI
library:Destroy()             -- completely remove UI
Full API Reference
library:Window(name: string) → window object
Creates a new draggable window.
window methods
:Button(name: string, callback: function)
Adds clickable button
:Label(text: string, rainbow: boolean?)
Static text label (rainbow = true for color cycling)
:Toggle(text: string, default: boolean, callback: function(state: boolean))
On/off switch
:Box(text: string, callback: function(value: string, focused: boolean))
Text input box (calls on every change + on focus lost)
:Slider(text: string, min: number, max: number, default: number, callback: function(value: number))
Draggable slider with live value display
:Dropdown(text: string, options: table, callback: function(selected: string), selective: boolean?)
Returns dropdown object with :Button(name) and :Remove(name) methods
:ColorPicker(name: string, default: Color3|boolean, callback: function(color: Color3))
Full HSV color picker with rainbow toggle option
Returns object with :UpdateColorPicker(color: Color3|boolean)
Global library methods
:Hide() → Toggle UI visibility
:Keybind(key: string) → Set global toggle key (e.g. "RightShift")
:Destroy() → Remove entire UU


Delta, FluxusZ, Hydrogen compatible
## Raw Source: https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua
## MIT License – free to use and modify
