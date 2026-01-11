# NeonVibes Mobile UI – 2026 Edition

Mobile-first neon Roblox UI library (Rayfield-inspired)  
Big touch targets • Smooth animations • Many elements

## Quick Load

```lua
local NeonVibes = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()
```
# New Features 2026
Horizontal scrolling tabs (unlimited tabs)
Minimize / Restore with smooth animation (+ draggable opener circle)
Theme switcher (Dark/Light)
Section headers
Toggle • Button • Slider • Dropdown • ColorPicker • Keybind • Textbox • Paragraph/Label
Configuration saving (toggles, sliders, etc.)
Global UI toggle keybind (default: RightShift)
Discord join prompt option
Performance & mobile optimizations
Example Usage
```local ui = NeonVibes.new("My 2026 Hub")

local tabMain = ui:CreateTab("Main")
local tabVisuals = ui:CreateTab("Visuals")

ui:AddSection(tabMain, "Basic Controls")

ui:AddButton(tabMain, "Teleport To Spawn", function()
    ui:Notify("Teleported!", 3)
end)

ui:AddToggle(tabMain, "Infinite Jump", false, function(state)
    print("Infinite Jump:", state)
end, "InfJump") -- auto-saves

ui:AddSlider(tabMain, "Speed", 16, 500, 50, function(val)
    -- set walkspeed
end)

ui:AddDropdown(tabMain, "ESP Mode", {"Box", "Tracer", "None"}, "None", function(selected)
    print("ESP:", selected)
end)

ui:AddColorPicker(tabVisuals, "ESP Color", Color3.fromRGB(255,0,0), function(color)
    print("Color changed:", color)
end)

ui:AddKeybind(tabMain, "Open Menu", Enum.KeyCode.F, function(key)
    print("Keybind set to:", key.Name)
end)

ui:AddTextbox(tabMain, "Custom Message", "Hello", function(text)
    print("Text:", text)
end)

ui:Notify("Welcome to NeonVibes 2026!", 5)
```
## API Quick Reference
.new(title) → Create UI
:CreateTab(name) → New tab
:AddSection(tab, title)
:AddButton(tab, text, callback)
:AddToggle(tab, name, default, callback, flag?)
:AddSlider(tab, name, min, max, default, callback)
:AddDropdown(tab, name, options:table, default, callback)
:AddColorPicker(tab, name, defaultColor, callback)
:AddKeybind(tab, name, defaultKey, callback)
:AddTextbox(tab, name, defaultText, callback)
:Notify(text, duration?)
Full documentation & more elements coming soon – keep updating the file!
MIT License • Mobile Optimized • Free to modify
