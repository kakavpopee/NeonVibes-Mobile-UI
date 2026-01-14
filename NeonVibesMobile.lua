local NeonVibes = {}
NeonVibes.__index = NeonVibes

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    WindowWidthScale = 0.88,      -- 88% screen width (mobile perfect)
    WindowHeightScale = 0.75,     -- 75% screen height
    CornerRadius = UDim.new(0, 14),
    Padding = UDim.new(0, 14),
    ElementHeightScale = 0.055,   -- Scales to screen height
    TextSizeScale = 0.025,
    StrokeThickness = 2.2,
    NeonColor = Color3.fromRGB(0, 255, 255),
    BgPrimary = Color3.fromRGB(18, 18, 28),
    BgSecondary = Color3.fromRGB(28, 28, 45),
    Accent = Color3.fromRGB(35, 35, 55),
    TextPrimary = Color3.fromRGB(255, 255, 255)
}

local function protectGui(gui)
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game.CoreGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game.CoreGui
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonVibes"
ScreenGui.ResetOnSpawn = false
protectGui(ScreenGui)

local WindowCount = 0

local function createTween(obj, goal)
    TweenService:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), goal):Play()
end

local function DragFunction(dragHandle, frame)
    local dragging = false
    local dragInput, startPos, startDrag
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startPos = frame.Position
            startDrag = input.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startDrag
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function NeonVibes:CreateWindow(name)
    WindowCount = WindowCount + 1
    
    local Window = Instance.new("Frame")
    Window.Name = name or "NeonVibes Window " .. WindowCount
    Window.Size = UDim2.new(CONFIG.WindowWidthScale, 0, CONFIG.WindowHeightScale, 0)
    Window.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.BackgroundColor3 = CONFIG.BgPrimary
    Window.BorderSizePixel = 0
    Window.ClipsDescendants = true
    Window.Parent = ScreenGui
    
    -- Responsive max size constraint
    local SizeConstraint = Instance.new("UISizeConstraint")
    SizeConstraint.MaxSize = Vector2.new(500, 850)
    SizeConstraint.Parent = Window
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = CONFIG.CornerRadius
    WindowCorner.Parent = Window
    
    local WindowStroke = Instance.new("UIStroke")
    WindowStroke.Color = CONFIG.NeonColor
    WindowStroke.Thickness = CONFIG.StrokeThickness
    WindowStroke.Transparency = 0.3
    WindowStroke.Parent = Window
    
    -- Title Bar (fixed height, properly scaled)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 55)
    TitleBar.BackgroundColor3 = CONFIG.Accent
    TitleBar.Parent = Window
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = CONFIG.CornerRadius
    TitleBarCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = name or "NeonVibes"
    TitleLabel.TextColor3 = CONFIG.NeonColor
    TitleLabel.TextSize = math.max(18, ScreenGui.AbsoluteSize.Y * CONFIG.TextSizeScale)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextWrapped = true
    TitleLabel.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 42, 0, 42)
    MinimizeBtn.Position = UDim2.new(1, -92, 0.5, -21)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 210, 0)
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = Color3.new(0,0,0)
    MinimizeBtn.TextSize = 24
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 10)
    MinCorner.Parent = MinimizeBtn
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 42, 0, 42)
    CloseBtn.Position = UDim2.new(1, -46, 0.5, -21)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.TextSize = 22
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        createTween(Window, {Size = UDim2.new(0, 0, 0, 0)})
        task.wait(0.25)
        Window:Destroy()
    end)
    
    DragFunction(TitleBar, Window)
    
    -- Content Area (properly positioned below title bar)
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -24, 1, -74)
    Content.Position = UDim2.new(0, 12, 0, 62)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 5
    Content.ScrollBarImageColor3 = CONFIG.NeonColor
    Content.ScrollBarImageTransparency = 0.3
    Content.Parent = Window
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = CONFIG.Padding
    ContentLayout.Parent = Content
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = CONFIG.Padding
    ContentPadding.PaddingRight = CONFIG.Padding
    ContentPadding.PaddingTop = UDim.new(0, 8)
    ContentPadding.PaddingBottom = CONFIG.Padding
    ContentPadding.Parent = Content
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    local Elements = {}
    
    -- Button (properly sized and padded)
    function Elements:Button(text, callback)
        local BtnHeight = math.max(48, ScreenGui.AbsoluteSize.Y * CONFIG.ElementHeightScale)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, BtnHeight)
        Btn.BackgroundColor3 = CONFIG.BgSecondary
        Btn.Text = text
        Btn.TextColor3 = CONFIG.TextPrimary
        Btn.TextSize = math.max(16, ScreenGui.AbsoluteSize.Y * CONFIG.TextSizeScale)
        Btn.Font = Enum.Font.GothamSemibold
        Btn.TextWrapped = true
        Btn.Parent = Content
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 10)
        BtnCorner.Parent = Btn
        
        local BtnStroke = Instance.new("UIStroke")
        BtnStroke.Color = CONFIG.NeonColor
        BtnStroke.Thickness = 1.5
        BtnStroke.Transparency = 0.6
        BtnStroke.Parent = Btn
        
        Btn.MouseButton1Click:Connect(callback or function() end)
        
        -- Ripple animation
        Btn.MouseButton1Down:Connect(function()
            local Ripple = Instance.new("Frame")
            Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            Ripple.Size = UDim2.new(0, 0, 0, 0)
            Ripple.BackgroundColor3 = CONFIG.NeonColor
            Ripple.BackgroundTransparency = 0.4
            Ripple.ZIndex = 10
            Ripple.Parent = Btn
            
            local RippleCorner = Instance.new("UICorner")
            RippleCorner.CornerRadius = UDim.new(1, 0)
            RippleCorner.Parent = Ripple
            
            createTween(Ripple, {Size = UDim2.new(2.5, 0, 2.5, 0), BackgroundTransparency = 1})
            task.delay(0.3, function() Ripple:Destroy() end)
        end)
    end
    
    -- Toggle (right-aligned, properly scaled)
    function Elements:Toggle(text, default, callback)
        local ToggleHeight = math.max(48, ScreenGui.AbsoluteSize.Y * CONFIG.ElementHeightScale)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, ToggleHeight)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Content
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -85, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = CONFIG.TextPrimary
        Label.TextSize = math.max(16, ScreenGui.AbsoluteSize.Y * CONFIG.TextSizeScale)
        Label.Font = Enum.Font.Gotham
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextWrapped = true
        Label.Parent = Frame
        
        local ToggleBg = Instance.new("Frame")
        ToggleBg.Size = UDim2.new(0, 58, 0, 28)
        ToggleBg.Position = UDim2.new(1, -72, 0.5, -14)
        ToggleBg.BackgroundColor3 = default and CONFIG.NeonColor or Color3.fromRGB(65, 65, 85)
        ToggleBg.Parent = Frame
        
        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = UDim.new(0, 14)
        BgCorner.Parent = ToggleBg
        
        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 24, 0, 24)
        Knob.Position = default and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
        Knob.BackgroundColor3 = CONFIG.TextPrimary
        Knob.Parent = ToggleBg
        
        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(0, 12)
        KnobCorner.Parent = Knob
        
        local state = default or false
        
        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                createTween(ToggleBg, {BackgroundColor3 = state and CONFIG.NeonColor or Color3.fromRGB(65, 65, 85)})
                createTween(Knob, {Position = state and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)})
                if callback then callback(state) end
            end
        end)
    end
    
    -- Add other elements (Slider, etc.) using same scale pattern...
    
    function Elements:Notify(text, duration)
        duration = duration or 3
        local Notify = Instance.new("Frame")
        Notify.Size = UDim2.new(0, math.min(320, ScreenGui.AbsoluteSize.X * 0.8), 0, 65)
        Notify.Position = UDim2.new(1, -math.min(340, ScreenGui.AbsoluteSize.X * 0.85), 0, 20)
        Notify.BackgroundColor3 = CONFIG.BgPrimary
        Notify.Parent = ScreenGui
        
        local NotifyCorner = Instance.new("UICorner")
        NotifyCorner.CornerRadius = UDim.new(0, 12)
        NotifyCorner.Parent = Notify
        
        local NotifyStroke = Instance.new("UIStroke")
        NotifyStroke.Color = CONFIG.NeonColor
        NotifyStroke.Thickness = 2.5
        NotifyStroke.Parent = Notify
        
        local NotifyLabel = Instance.new("TextLabel")
        NotifyLabel.Size = UDim2.new(1, -20, 1, 0)
        NotifyLabel.Position = UDim2.new(0, 12, 0, 0)
        NotifyLabel.BackgroundTransparency = 1
        NotifyLabel.Text = text
        NotifyLabel.TextColor3 = CONFIG.TextPrimary
        NotifyLabel.TextSize = math.max(15, ScreenGui.AbsoluteSize.Y * 0.022)
        NotifyLabel.Font = Enum.Font.Gotham
        NotifyLabel.TextWrapped = true
        NotifyLabel.Parent = Notify
        
        createTween(Notify, {Position = UDim2.new(1, -math.min(340, ScreenGui.AbsoluteSize.X * 0.85), 0, 20)})
        task.wait(duration)
        createTween(Notify, {Position = UDim2.new(1, 0, 0, 20)})
        task.wait(0.3)
        Notify:Destroy()
    end
    
    return Elements
end

return NeonVibes            framePos = frame.Position
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
        if input == dragInput and dragging then
            local Delta = input.Position - mousePos
            TweenService:Create(frame, TweenInfo.new(0.2), {
                Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + Delta.X, framePos.Y.Scale, framePos.Y.Offset + Delta.Y)
            }):Play()
        end
    end)
end

function NeonVibes:CreateWindow(name)
    WindowCount = WindowCount + 1
    
    local Window = Instance.new("Frame")
    Window.Name = name or "NeonVibes Window " .. WindowCount
    Window.Size = CONFIG.WindowSize
    Window.Position = UDim2.new(0.5, -210, 0.5, -180)
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.BackgroundColor3 = CONFIG.BgPrimary
    Window.BorderSizePixel = 0
    Window.Parent = ScreenGui
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = CONFIG.CornerRadius
    WindowCorner.Parent = Window
    
    local WindowStroke = Instance.new("UIStroke")
    WindowStroke.Color = CONFIG.NeonColor
    WindowStroke.Thickness = CONFIG.Stroke
    WindowStroke.Parent = Window
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = CONFIG.Accent
    TitleBar.Parent = Window
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = CONFIG.CornerRadius
    TitleBarCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Text = name or "NeonVibes"
    TitleLabel.TextColor3 = CONFIG.NeonColor
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -65, 0.5, -15)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    MinimizeBtn.Text = "−"
    MinimizeBtn.TextColor3 = Color3.new(0,0,0)
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeBtn
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -15)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Window, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.3)
        Window:Destroy()
    end)
    
    DragFunction(TitleBar)
    
    -- Content Frame
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 1, -65)
    Content.Position = UDim2.new(0, 10, 0, 50)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = CONFIG.NeonColor
    Content.Parent = Window
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, CONFIG.Padding)
    ContentLayout.Parent = Content
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.PaddingLeft = UDim.new(0, CONFIG.Padding)
    ContentPadding.PaddingRight = UDim.new(0, CONFIG.Padding)
    ContentPadding.PaddingTop = UDim.new(0, CONFIG.Padding)
    ContentPadding.PaddingBottom = UDim.new(0, CONFIG.Padding * 2)
    ContentPadding.Parent = Content
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end)
    
    local Elements = {}
    
    function Elements:Button(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
        Btn.BackgroundColor3 = CONFIG.BgSecondary
        Btn.Text = text
        Btn.TextColor3 = CONFIG.TextPrimary
        Btn.TextSize = CONFIG.TextSize
        Btn.Font = Enum.Font.GothamSemibold
        Btn.Parent = Content
        
        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = Btn
        
        local BtnStroke = Instance.new("UIStroke")
        BtnStroke.Color = CONFIG.NeonColor
        BtnStroke.Thickness = 1
        BtnStroke.Transparency = 0.7
        BtnStroke.Parent = Btn
        
        Btn.MouseButton1Click:Connect(callback or function() end)
        
        -- Ripple Effect
        Btn.MouseButton1Down:Connect(function()
            local Ripple = Instance.new("Frame")
            Ripple.Size = UDim2.new(0, 0, 0, 0)
            Ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            Ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            Ripple.BackgroundColor3 = CONFIG.NeonColor
            Ripple.BackgroundTransparency = 0.5
            Ripple.ZIndex = 10
            Ripple.Parent = Btn
            
            local RippleCorner = Instance.new("UICorner")
            RippleCorner.CornerRadius = UDim.new(1, 0)
            RippleCorner.Parent = Ripple
            
            TweenService:Create(Ripple, TweenInfo.new(0.4), {
                Size = UDim2.new(2, 0, 2, 0),
                BackgroundTransparency = 1
            }):Play()
            task.delay(0.4, function() Ripple:Destroy() end)
        end)
    end
    
    function Elements:Toggle(text, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Content
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -70, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = CONFIG.TextPrimary
        Label.TextSize = CONFIG.TextSize
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.Parent = Frame
        
        local ToggleBg = Instance.new("Frame")
        ToggleBg.Size = UDim2.new(0, 50, 0, 24)
        ToggleBg.Position = UDim2.new(1, -60, 0.5, -12)
        ToggleBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ToggleBg.Parent = Frame
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 12)
        ToggleCorner.Parent = ToggleBg
        
        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 20, 0, 20)
        Knob.Position = default and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        Knob.BackgroundColor3 = CONFIG.TextPrimary
        Knob.Parent = ToggleBg
        
        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(0, 10)
        KnobCorner.Parent = Knob
        
        local state = default or false
        
        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                TweenService:Create(ToggleBg, TweenInfo.new(0.2), {
                    BackgroundColor3 = state and CONFIG.NeonColor or Color3.fromRGB(60, 60, 80)
                }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {
                    Position = state and UDim2.new(1, -24, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                }):Play()
                if callback then callback(state) end
            end
        end)
    end
    
    function Elements:Slider(text, min, max, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 70)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Content
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.BackgroundTransparency = 1
        Label.Text = text .. ": " .. default
        Label.TextColor3 = CONFIG.TextPrimary
        Label.TextSize = CONFIG.TextSize
        Label.Font = Enum.Font.GothamSemibold
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
        local percent = (default - min) / (max - min)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)
        SliderFill.BackgroundColor3 = CONFIG.NeonColor
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
                local value = math.floor(min + (max - min) * relative)
                SliderFill.Size = UDim2.new(relative, 0, 1, 0)
                Label.Text = text .. ": " .. value
                if callback then callback(value) end
            end
        end)
        
        Hitbox.InputEnded:Connect(function()
            dragging = false
        end)
    end
    
    function Elements:Notify(text, duration)
        duration = duration or 3
        local Notify = Instance.new("Frame")
        Notify.Size = UDim2.new(0, 300, 0, 60)
        Notify.Position = UDim2.new(1, -320, 0, 20)
        Notify.BackgroundColor3 = CONFIG.BgPrimary
        Notify.Parent = ScreenGui
        
        local NotifyCorner = Instance.new("UICorner")
        NotifyCorner.CornerRadius = UDim.new(0, 10)
        NotifyCorner.Parent = Notify
        
        local NotifyStroke = Instance.new("UIStroke")
        NotifyStroke.Color = CONFIG.NeonColor
        NotifyStroke.Thickness = 2
        NotifyStroke.Parent = Notify
        
        local NotifyLabel = Instance.new("TextLabel")
        NotifyLabel.Size = UDim2.new(1, -20, 1, 0)
        NotifyLabel.Position = UDim2.new(0, 10, 0, 0)
        NotifyLabel.BackgroundTransparency = 1
        NotifyLabel.Text = text
        NotifyLabel.TextColor3 = CONFIG.TextPrimary
        NotifyLabel.TextSize = 16
        NotifyLabel.Font = Enum.Font.Gotham
        NotifyLabel.TextWrapped = true
        NotifyLabel.Parent = Notify
        
        TweenService:Create(Notify, TweenInfo.new(0.4), {Position = UDim2.new(1, -320, 0, 20)}):Play()
        task.wait(duration)
        TweenService:Create(Notify, TweenInfo.new(0.4), {Position = UDim2.new(1, 0, 0, 20)}):Play()
        task.wait(0.4)
        Notify:Destroy()
    end
    
    Windows[WindowCount] = Elements
    return Elements
end

return NeonVibes
