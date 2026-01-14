local NeonVibes = {}
NeonVibes.__index = NeonVibes

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Config file
local CONFIG_FILE = "NeonVibes_Config.json"

-- Themes
local Themes = {
    Dark = {
        BgPrimary = Color3.fromRGB(18, 18, 28),
        BgSecondary = Color3.fromRGB(30, 30, 45),
        Accent = Color3.fromRGB(35, 35, 55),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        NeonColor = Color3.fromRGB(0, 255, 255)
    },
    Neon = {
        BgPrimary = Color3.fromRGB(10, 0, 20),
        BgSecondary = Color3.fromRGB(20, 0, 40),
        Accent = Color3.fromRGB(50, 0, 100),
        TextPrimary = Color3.fromRGB(200, 255, 255),
        NeonColor = Color3.fromRGB(0, 255, 255)
    },
    Light = {
        BgPrimary = Color3.fromRGB(240, 240, 250),
        BgSecondary = Color3.fromRGB(220, 220, 235),
        Accent = Color3.fromRGB(200, 200, 220),
        TextPrimary = Color3.fromRGB(30, 30, 50),
        NeonColor = Color3.fromRGB(0, 150, 255)
    }
}

local CurrentTheme = Themes.Dark

-- Load/Save Config
local function loadConfig()
    if isfile(CONFIG_FILE) then
        local data = readfile(CONFIG_FILE)
        return game:GetService("HttpService"):JSONDecode(data)
    end
    return {}
end

local function saveConfig(config)
    writefile(CONFIG_FILE, game:GetService("HttpService"):JSONEncode(config))
end

local config = loadConfig()

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonVibes"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Reopen icon
local reopenIcon = Instance.new("TextButton")
reopenIcon.Size = UDim2.new(0, 60, 0, 60)
reopenIcon.Position = UDim2.new(0, 20, 0, 20)
reopenIcon.BackgroundColor3 = CurrentTheme.NeonColor
reopenIcon.Text = "N"
reopenIcon.TextColor3 = Color3.new(0,0,0)
reopenIcon.TextSize = 32
reopenIcon.Font = Enum.Font.GothamBold
reopenIcon.Visible = false
reopenIcon.Parent = ScreenGui

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = reopenIcon

local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.new(1,1,1)
iconStroke.Thickness = 3
iconStroke.Parent = reopenIcon

-- Drag function
local function DragFunction(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function NeonVibes:CreateWindow(name)
    local window = {}
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(CONFIG.WindowWidthScale, 0, CONFIG.WindowHeightScale, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = CurrentTheme.BgPrimary
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = CONFIG.CornerRadius
    MainCorner.Parent = MainFrame
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = CurrentTheme.NeonColor
    MainStroke.Thickness = CONFIG.Stroke
    MainStroke.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = CurrentTheme.Accent
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = CONFIG.CornerRadius
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = name or "NeonVibes"
    TitleLabel.TextColor3 = CurrentTheme.NeonColor
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 38, 0, 38)
    CloseBtn.Position = UDim2.new(1, -45, 0.5, -19)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        reopenIcon.Visible = true
    end)
    
    -- Reopen
    reopenIcon.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(CONFIG.WindowWidthScale, 0, CONFIG.WindowHeightScale, 0)}):Play()
        reopenIcon.Visible = false
    end)
    
    DragFunction(TitleBar)
    
    -- Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 38)
    TabBar.Position = UDim2.new(0, 0, 0, 50)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.Parent = TabBar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.Parent = TabScroll
    
    -- Content
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, -24, 1, -96)
    Content.Position = UDim2.new(0, 12, 0, 88)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = CurrentTheme.NeonColor
    Content.Parent = MainFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, CONFIG.Padding)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = Content
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, CONFIG.Padding)
    ContentPadding.PaddingRight = UDim.new(0, CONFIG.Padding)
    ContentPadding.PaddingTop = UDim.new(0, 8)
    ContentPadding.PaddingBottom = UDim.new(0, CONFIG.Padding)
    ContentPadding.Parent = Content
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + CONFIG.Padding * 4)
    end)
    
    local function switchTab(tabContent)
        for _, child in pairs(Content:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        tabContent.Visible = true
    end
    
    function window:CreateTab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0, 120, 1, 0)
        tabBtn.BackgroundColor3 = CurrentTheme.BgSecondary
        tabBtn.Text = name
        tabBtn.TextColor3 = CurrentTheme.TextPrimary
        tabBtn.TextSize = CONFIG.TextSize
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Parent = TabScroll
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabBtn
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.ScrollBarThickness = 5
        tabContent.ScrollBarImageColor3 = CurrentTheme.NeonColor
        tabContent.Parent = Content
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Padding = UDim.new(0, CONFIG.Padding)
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Parent = tabContent
        
        local tabPadding = Instance.new("UIPadding")
        tabPadding.PaddingLeft = UDim.new(0, CONFIG.Padding)
        tabPadding.PaddingRight = UDim.new(0, CONFIG.Padding)
        tabPadding.PaddingTop = UDim.new(0, 8)
        tabPadding.PaddingBottom = UDim.new(0, CONFIG.Padding)
        tabPadding.Parent = tabContent
        
        tabBtn.MouseButton1Click:Connect(function()
            switchTab(tabContent)
        end)
        
        if not window.CurrentTab then
            switchTab(tabContent)
            window.CurrentTab = tabContent
        end
        
        local tabElements = {}
        
        function tabElements:Button(text, callback)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
            Btn.BackgroundColor3 = CurrentTheme.BgSecondary
            Btn.Text = text
            Btn.TextColor3 = CurrentTheme.TextPrimary
            Btn.TextSize = CONFIG.TextSize
            Btn.Font = Enum.Font.GothamSemibold
            Btn.Parent = tabContent
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(callback or function() end)
        end
        
        function tabElements:Label(text, rainbow)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.TextPrimary
            Label.TextSize = CONFIG.TextSize
            Label.Font = Enum.Font.Gotham
            Label.TextWrapped = true
            Label.Parent = tabContent
            
            if rainbow then
                spawn(function()
                    while wait() do
                        local hue = tick() % 5 / 5
                        Label.TextColor3 = Color3.fromHSV(hue, 1, 1)
                    end
                end)
            end
        end
        
        function tabElements:Toggle(text, default, callback, flag)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
            Frame.BackgroundTransparency = 1
            Frame.Parent = tabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.TextPrimary
            Label.TextSize = CONFIG.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ToggleBg = Instance.new("Frame")
            ToggleBg.Size = UDim2.new(0, 50, 0, 26)
            ToggleBg.Position = UDim2.new(1, -65, 0.5, -13)
            ToggleBg.BackgroundColor3 = default and CurrentTheme.NeonColor or Color3.fromRGB(60, 60, 80)
            ToggleBg.Parent = Frame
            
            local BgCorner = Instance.new("UICorner")
            BgCorner.CornerRadius = UDim.new(0, 13)
            BgCorner.Parent = ToggleBg
            
            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.new(0, 22, 0, 22)
            Knob.Position = default and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            Knob.BackgroundColor3 = CurrentTheme.TextPrimary
            Knob.Parent = ToggleBg
            
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(0, 11)
            KnobCorner.Parent = Knob
            
            local state = config[flag] or default or false
            
            ToggleBg.BackgroundColor3 = state and CurrentTheme.NeonColor or Color3.fromRGB(60, 60, 80)
            Knob.Position = state and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
            
            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    state = not state
                    TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and CurrentTheme.NeonColor or Color3.fromRGB(60, 60, 80)}):Play()
                    TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)}):Play()
                    if callback then callback(state) end
                    if flag then config[flag] = state; saveConfig(config) end
                end
            end)
        end
        
        function tabElements:Slider(text, min, max, default, callback, flag)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 70)
            Frame.BackgroundTransparency = 1
            Frame.Parent = tabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text .. ": " .. (config[flag] or default)
            Label.TextColor3 = CurrentTheme.TextPrimary
            Label.TextSize = CONFIG.TextSize
            Label.Parent = Frame
            
            local SliderBg = Instance.new("Frame")
            SliderBg.Size = UDim2.new(1, 0, 0, 8)
            SliderBg.Position = UDim2.new(0, 0, 0, 40)
            SliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            SliderBg.Parent = Frame
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 4)
            SliderCorner.Parent = SliderBg
            
            local SliderFill = Instance.new("Frame")
            local initial = config[flag] or default
            local percent = (initial - min) / (max - min)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderFill.BackgroundColor3 = CurrentTheme.NeonColor
            SliderFill.Parent = SliderBg
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 4)
            FillCorner.Parent = SliderFill
            
            local dragging = false
            
            local Hitbox = Instance.new("TextButton")
            Hitbox.Size = UDim2.new(1, 0, 1, 0)
            Hitbox.BackgroundTransparency = 1
            Hitbox.Text = ""
            Hitbox.Parent = Frame
            
            Hitbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local relative = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                    local value = math.round(min + (max - min) * relative)
                    SliderFill.Size = UDim2.new(relative, 0, 1, 0)
                    Label.Text = text .. ": " .. value
                    if callback then callback(value) end
                    if flag then config[flag] = value; saveConfig(config) end
                end
            end)
            
            Hitbox.InputEnded:Connect(function()
                dragging = false
            end)
        end
        
        -- Box (Textbox)
        function tabElements:Box(text, default, callback, flag)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
            Frame.BackgroundTransparency = 1
            Frame.Parent = tabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = CurrentTheme.TextPrimary
            Label.TextSize = CONFIG.TextSize
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local Box = Instance.new("TextBox")
            Box.Size = UDim2.new(0.6, 0, 0.8, 0)
            Box.Position = UDim2.new(0.4, 0, 0.1, 0)
            Box.BackgroundColor3 = CurrentTheme.BgSecondary
            Box.Text = config[flag] or default or ""
            Box.PlaceholderText = "..."
            Box.TextColor3 = CurrentTheme.TextPrimary
            Box.TextSize = CONFIG.TextSize
            Box.Parent = Frame
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 8)
            BoxCorner.Parent = Box
            
            Box.FocusLost:Connect(function()
                if callback then callback(Box.Text, true) end
                if flag then config[flag] = Box.Text; saveConfig(config) end
            end)
            
            Box:GetPropertyChangedSignal("Text"):Connect(function()
                if callback then callback(Box.Text, false) end
            end)
        end
        
        -- Dropdown
        function tabElements:Dropdown(text, buttons, callback, selective, flag)
            local Dropdown = Instance.new("TextButton")
            Dropdown.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
            Dropdown.BackgroundColor3 = CurrentTheme.BgSecondary
            Dropdown.Text = config[flag] or text
            Dropdown.TextColor3 = CurrentTheme.TextPrimary
            Dropdown.TextSize = CONFIG.TextSize
            Dropdown.Parent = tabContent
            
            local DownSign = Instance.new("TextLabel")
            DownSign.Size = UDim2.new(0, 30, 0, 30)
            DownSign.Position = UDim2.new(1, -35, 0.5, -15)
            DownSign.BackgroundTransparency = 1
            DownSign.Text = "▼"
            DownSign.TextColor3 = CurrentTheme.TextPrimary
            DownSign.TextSize = 20
            DownSign.Parent = Dropdown
            
            local DropdownFrame = Instance.new("ScrollingFrame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 0)
            DropdownFrame.Position = UDim2.new(0, 0, 1, 0)
            DropdownFrame.BackgroundColor3 = CurrentTheme.BgSecondary
            DropdownFrame.Visible = false
            DropdownFrame.Parent = Dropdown
            
            local DropLayout = Instance.new("UIListLayout")
            DropLayout.Padding = UDim.new(0, 2)
            DropLayout.Parent = DropdownFrame
            
            Dropdown.MouseButton1Click:Connect(function()
                DropdownFrame.Visible = not DropdownFrame.Visible
                DownSign.Text = DropdownFrame.Visible and "▲" or "▼"
            end)
            
            local function addOption(opt)
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
                OptBtn.BackgroundColor3 = CurrentTheme.Accent
                OptBtn.Text = opt
                OptBtn.TextColor3 = CurrentTheme.TextPrimary
                OptBtn.TextSize = CONFIG.TextSize
                OptBtn.Parent = DropdownFrame
                
                OptBtn.MouseButton1Click:Connect(function()
                    if selective then
                        Dropdown.Text = opt
                    end
                    if callback then callback(opt) end
                    DropdownFrame.Visible = false
                    DownSign.Text = "▼"
                    if flag then config[flag] = opt; saveConfig(config) end
                end)
            end
            
            for _, b in ipairs(buttons or {}) do
                addOption(b)
            end
            
            local dropFuncs = {}
            function dropFuncs:Button(name)
                addOption(name)
            end
            
            return dropFuncs
        end
        
        -- ColorPicker (simplified)
        function tabElements:ColorPicker(name, default, callback, flag)
            local ColorPicker = Instance.new("TextButton")
            ColorPicker.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
            ColorPicker.BackgroundColor3 = config[flag] or default or CONFIG.NeonColor
            ColorPicker.Text = ""
            ColorPicker.Parent = tabContent
            
            local PickerLabel = Instance.new("TextLabel")
            PickerLabel.Size = UDim2.new(0.6, 0, 1, 0)
            PickerLabel.BackgroundTransparency = 1
            PickerLabel.Text = name
            PickerLabel.TextColor3 = CurrentTheme.TextPrimary
            PickerLabel.TextSize = CONFIG.TextSize
            PickerLabel.Parent = ColorPicker
            
            ColorPicker.MouseButton1Click:Connect(function()
                -- Full picker logic (expand with HSV if needed)
                local newColor = Color3.fromRGB(math.random(0,255), math.random(0,255), math.random(0,255))
                ColorPicker.BackgroundColor3 = newColor
                if callback then callback(newColor) end
                if flag then config[flag] = newColor; saveConfig(config) end
            end)
            
            local cpFuncs = {}
            function cpFuncs:UpdateColorPicker(color)
                ColorPicker.BackgroundColor3 = color
                if callback then callback(color) end
                if flag then config[flag] = color; saveConfig(config) end
            end
            
            return cpFuncs
        end
        
        return tabElements
    end
    
    -- Theme switcher
    function window:SetTheme(themeName)
        if Themes[themeName] then
            CurrentTheme = Themes[themeName]
            -- Update all UI elements (simplified - add more in real use)
            MainFrame.BackgroundColor3 = CurrentTheme.BgPrimary
            TitleBar.BackgroundColor3 = CurrentTheme.Accent
            TitleLabel.TextColor3 = CurrentTheme.NeonColor
            reopenIcon.BackgroundColor3 = CurrentTheme.NeonColor
        end
    end
    
    -- Notify
    function window:Notify(text, duration)
        duration = duration or 3
        local Notify = Instance.new("Frame")
        Notify.Size = UDim2.new(0, 300, 0, 60)
        Notify.Position = UDim2.new(1, -320, 0, 20)
        Notify.BackgroundColor3 = CurrentTheme.BgPrimary
        Notify.Parent = ScreenGui
        
        local nCorner = Instance.new("UICorner")
        nCorner.CornerRadius = UDim.new(0, 10)
        nCorner.Parent = Notify
        
        local nStroke = Instance.new("UIStroke")
        nStroke.Color = CurrentTheme.NeonColor
        nStroke.Thickness = 2
        nStroke.Parent = Notify
        
        local nLabel = Instance.new("TextLabel")
        nLabel.Size = UDim2.new(1, -20, 1, 0)
        nLabel.Position = UDim2.new(0, 10, 0, 0)
        nLabel.BackgroundTransparency = 1
        nLabel.Text = text
        nLabel.TextColor3 = CurrentTheme.TextPrimary
        nLabel.TextSize = 16
        nLabel.Font = Enum.Font.Gotham
        nLabel.TextWrapped = true
        nLabel.Parent = Notify
        
        TweenService:Create(Notify, TweenInfo.new(0.4), {Position = UDim2.new(1, -320, 0, 20)}):Play()
        task.wait(duration)
        TweenService:Create(Notify, TweenInfo.new(0.4), {Position = UDim2.new(1, 0, 0, 20)}):Play()
        task.wait(0.4)
        Notify:Destroy()
    end
    
    return window
end

return NeonVibes
