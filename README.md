# NeonVibes Mobile UI

Mobile-optimized Roblox UI library with neon theme, inspired by Rayfield. Big touch targets, vertical layouts for phones/tablets.

## Features
- Responsive window (92% width, max 460px).
- Vertical tabs.
- Big buttons with ripples, sliders with large hitboxes.
- Notifications with animations.
- Draggable title bar.

## Installation
1. Download `NeonVibesMobile.lua` from releases.
2. In script: `local ui = require(path.to.NeonVibesMobile)`

## Usage Example
```lua
local ui = NeonVibesMobile.new("My UI")

local tab = ui:CreateTab("Main")

ui:AddButton(tab, "Test", function()
    ui:Notify("Tapped!")
end)

ui:AddSlider(tab, "Speed", 1, 100, 50, function(val)
    print(val)
end)```

## Features
- Responsive window (92% width, max 460px).
- Vertical tabs.
- Big buttons with ripples, sliders with large hitboxes.
- Notifications with animations.
- Draggable title bar.

## Installation
1. Download `NeonVibesMobile.lua` from releases.
2. In script: `local ui = require(path.to.NeonVibesMobile)`

## Usage Example
```lua
local ui = NeonVibesMobile.new("My UI")

local tab = ui:CreateTab("Main")

ui:AddButton(tab, "Test", function()
    ui:Notify("Tapped!")
end)

ui:AddSlider(tab, "Speed", 1, 100, 50, function(val)
    print(val)
end)
```

## API Reference

### .new(title: string?) -> ui
Creates UI.

### :CreateTab(name: string) -> tab
Adds tab.

### :AddButton(tab, text: string, callback: function)
Adds button.

### :AddSlider(tab, name: string, min: number, max: number, default: number, callback: function)
Adds slider.

### :Notify(text: string, duration: number?)
Shows notification.

## Contributing
Fork, edit in your editor (like QuickEdit), PR!

## License
MIT - free use/modify.
