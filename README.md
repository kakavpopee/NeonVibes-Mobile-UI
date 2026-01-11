local NeonVibesMobile = require(script.Parent.NeonVibesMobile)  -- Adjust if needed

local ui = NeonVibesMobile.new("Test UI")

local tab1 = ui:CreateTab("Settings")

ui:AddButton(tab1, "Notify Me", function()
    ui:Notify("Hello from Mobile!")
end)

ui:AddSlider(tab1, "Volume", 0, 100, 50, function(value)
    print("Volume:", value)
end)