# NeonVibes Mobile UI

Modern, mobile-first Roblox UI library inspired by **Rayfield** and **Kavo UI**.  
Smooth animations • Neon aesthetic • Full touch support • Config saving • Themes • Reopen icon  
Optimized for Delta, FluxusZ, Hydrogen on mobile.

## Quick Load

```lua
local NeonVibes = loadstring(game:HttpGet("https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua"))()
```

## Quick Start Example

```lua
local window = NeonVibes:CreateWindow({
    Name = "NeonVibes Hub",
    LoadingTitle = "NeonVibes",
    LoadingSubtitle = "by KaolinScripts",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NeonVibes",
        FileName = "Config"
    },
    KeySystem = false
})

local mainTab = window:CreateTab("Main", "rewind") -- Icon name from Lucide

mainTab:CreateButton({
    Name = "Teleport Home",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
        end
        NeonVibes:Notify("Teleported!", "success", 3)
    end
})

mainTab:CreateLabel("Rainbow Label Test", true)

mainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        print("Infinite Jump:", Value)
    end
})

mainTab:CreateInput({
    Name = "Custom Speed",
    PlaceholderText = "Enter speed...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local speed = tonumber(Text)
        if speed then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = speed
            end
        end
    end
})

mainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 50,
    Flag = "WalkSpeed",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

local dropdown = mainTab:CreateDropdown({
    Name = "ESP Mode",
    Options = {"Box", "Tracer", "None"},
    CurrentOption = "None",
    Flag = "ESPMode",
    Callback = function(Option)
        print("ESP changed to:", Option)
    end
})

dropdown:Add("Custom ESP")

mainTab:CreateColorpicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 100),
    Flag = "ESPColor",
    Callback = function(Value)
        print("Color changed:", Value)
    end
})

NeonVibes:CreateNotification("Welcome!", "Close window → icon appears top-left. Tap to reopen.", 6)
```

## API Reference

### Window Creation

```lua
NeonVibes:CreateWindow({
    Name = string,                    -- Window title
    LoadingTitle = string?,           -- Optional loading screen title
    LoadingSubtitle = string?,        -- Optional loading screen subtitle
    ConfigurationSaving = {           -- Optional
        Enabled = boolean,
        FolderName = string?,
        FileName = string?
    },
    KeySystem = boolean?              -- Not implemented yet
}) → window object
```

### Window Methods

```lua
window:CreateTab(name: string, icon: string?) → tab object

window:CreateButton({
    Name = string,
    Callback = function()
})
window:CreateLabel(text: string, rainbow: boolean?)
window:CreateToggle({
    Name = string,
    CurrentValue = boolean,
    Flag = string?,                   -- For config saving
    Callback = function(Value: boolean)
})
window:CreateInput({
    Name = string,
    PlaceholderText = string?,
    RemoveTextAfterFocusLost = boolean?,
    Callback = function(Text: string)
})
window:CreateSlider({
    Name = string,
    Range = {number, number},
    Increment = number,
    CurrentValue = number,
    Flag = string?,
    Callback = function(Value: number)
})
window:CreateDropdown({
    Name = string,
    Options = {string},
    CurrentOption = string,
    Flag = string?,
    Callback = function(Option: string)
}) → dropdown object with :Add(name), :Remove(name)
window:CreateColorpicker({
    Name = string,
    Color = Color3,
    Flag = string?,
    Callback = function(Value: Color3)
})
window:CreateNotification(title: string, content: string, duration: number?)
```

### Dropdown Object

```lua
dropdown:Add(name: string)
dropdown:Remove(name: string)
dropdown:Refresh(newOptions: {string}, deleteCurrent: boolean?)
```

### Special Features

- **Config Saving**  
  Use `Flag` on Toggle/Slider/Input/Dropdown/ColorPicker → values auto-save/load.

- **Themes**  
  Not fully implemented yet – coming soon (Dark/Neon/Light switch).

- **Reopen Icon**  
  Close window with red × → GUI hides, neon round icon appears top-left.  
  Tap icon → GUI reopens smoothly. Built-in.

- **Tabs**  
  Horizontal scrolling tab bar with icons (Lucide-style names).

- **Dragging**  
  Drag title bar → entire window moves.

- **Notifications**  
  Slide-in from right with neon stroke.

## Raw Source

https://raw.githubusercontent.com/kakavpopee/NeonVibes-Mobile-UI/main/NeonVibesMobile.lua

MIT License – Free to use, modify, distribute
```
