local NeonVibes = {}
NeonVibes.__index = NeonVibes

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Mouse = LocalPlayer:GetMouse()

local CONFIG = {
    WindowSize = UDim2.new(0, 420, 0, 360),
    CornerRadius = UDim.new(0, 12),
    Padding = 12,
    ElementHeight = 36,
    TextSize = 16,
    NeonColor = Color3.fromRGB(0, 255, 255),
    BgPrimary = Color3.fromRGB(20, 20, 30),
    BgSecondary = Color3.fromRGB(30, 30, 45),
    Accent = Color3.fromRGB(45, 45, 65),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    Stroke = 1.5
}

-- Delta/FluxusZ Safe Protection
local function protectGui(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game.CoreGui
    elseif PROTOSMASHER_LOADED then
        gui.Parent = get_hidden_gui()
    else
        gui.Parent = game.CoreGui
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeonVibes"
ScreenGui.ResetOnSpawn = false
protectGui(ScreenGui)

local WindowCount = 0
local Windows = {}

local function DragFunction(frame)
    local dragging = false
    local dragInput, mousePos, framePos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
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
