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
