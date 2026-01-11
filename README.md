# NeonVibes Mobile UI

Mobile-optimized Roblox UI Library  
Neon-themed • Touch-friendly • Big elements • Vertical layout

## Quick Load (Paste this to use)

```lua
local NeonVibes = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()
```

## Basic Usage Example

```lua
local ui = NeonVibes.new("NeonVibes Mobile")

local tabMain = ui:CreateTab("Main")
local tabSettings = ui:CreateTab("Settings")

ui:AddButton(tabMain, "Teleport Home", function()
    ui:Notify("Teleported to spawn!", 4)
end)

ui:AddSlider(tabMain, "Walk Speed", 16, 300, 50, function(value)
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

ui:AddButton(tabSettings, "Close UI", function()
    ui.ScreenGui:Destroy()
end)
```

## API Reference

### `NeonVibes.new(title: string?) → ui`

Creates a new instance of the UI.  
Returns the main library object.

- `title` (optional) – Window title text (default: "NeonVibes Mobile")

### `:CreateTab(name: string) → tab`

Creates a new vertical tab.  
Returns a tab object to which you can add elements.

- `name` – Display name of the tab

### `:AddButton(tab: tab, text: string, callback: function)`

Adds a large, touch-friendly button with ripple effect.

- `tab` – tab object returned by `:CreateTab`
- `text` – button label
- `callback` – function called when button is tapped/clicked

### `:AddSlider(tab: tab, name: string, min: number, max: number, default: number, callback: function(number))`

Adds a large slider with wide touch hitbox.

- `tab` – target tab
- `name` – label shown above slider
- `min` – minimum value
- `max` – maximum value
- `default` – starting value
- `callback(value)` – called on every change with rounded value

### `:Notify(text: string, duration: number?)`

Shows a temporary notification that slides in from the right.

- `text` – message to display
- `duration` (optional) – seconds to show (default: 3)

## Features Overview

- Responsive window size (92% screen width, max ~460px)
- Mobile drag (touch + mouse support)
- Large touch targets (buttons ~54px height)
- Ripple animation on button press
- Vertical tab navigation
- Neon cyan glow theme
- Smooth animations using TweenService
- Scrolling content with safe padding

## Recommended Practices

- Use full-width elements (already default)
- Keep callbacks short & fast
- Test on real mobile device (emulator scaling may differ)
- Add `pcall` around loadstring for production scripts

## Current Raw Source

https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua

MIT License – Free to use, modify, distribute.  
Created for mobile Roblox experience – January 2026
