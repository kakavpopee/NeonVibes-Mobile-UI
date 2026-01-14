local NeonVibes = {}
NeonVibes.__index = NeonVibes

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    WindowWidthScale = 0.88,
    WindowHeightScale = 0.75,
    CornerRadius = UDim.new(0, 12),
    Padding = 12,
    ElementHeight = 42,
    TextSize = 16,
    NeonColor = Color3.fromRGB(0, 255, 255),
    BgPrimary = Color3.fromRGB(18, 18, 28),
    BgSecondary = Color3.fromRGB(30, 30, 45),
    Accent = Color3.fromRGB(35, 35, 55),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    Stroke = 2
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

local function DragFunction(frame)
    local dragging, dragInput, dragStart, startPos
    
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
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function NeonVibes:CreateWindow(name)
    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(CONFIG.WindowWidthScale, 0, CONFIG.WindowHeightScale, 0)
    Window.Position = UDim2.new(0.5, 0, 0.5, 0)
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
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = CONFIG.Accent
    TitleBar.Parent = Window
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = CONFIG.CornerRadius
    TitleBarCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = name or "NeonVibes"
    TitleLabel.TextColor3 = CONFIG.NeonColor
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
        TweenService:Create(Window, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0)}):Play()
        task.wait(0.3)
        Window:Destroy()
    end)
    
    DragFunction(TitleBar)
    
    -- Content
    local Content = Instance.new("ScrollingFrame")
    Content.Size = UDim2.new(1, -24, 1, -68)
    Content.Position = UDim2.new(0, 12, 0, 58)
    Content.BackgroundTransparency = 1
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = CONFIG.NeonColor
    Content.Parent = Window
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, CONFIG.Padding)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = Content
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, CONFIG.Padding)
    Padding.PaddingRight = UDim.new(0, CONFIG.Padding)
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, CONFIG.Padding)
    Padding.Parent = Content
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Content.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + CONFIG.Padding * 4)
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
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = Btn
        
        Btn.MouseButton1Click:Connect(callback or function() end)
    end
    
    function Elements:Toggle(text, default, callback)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
        Frame.BackgroundTransparency = 1
        Frame.Parent = Content
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -80, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = CONFIG.TextPrimary
        Label.TextSize = CONFIG.TextSize
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame
        
        local ToggleBg = Instance.new("Frame")
        ToggleBg.Size = UDim2.new(0, 50, 0, 26)
        ToggleBg.Position = UDim2.new(1, -65, 0.5, -13)
        ToggleBg.BackgroundColor3 = default and CONFIG.NeonColor or Color3.fromRGB(60, 60, 80)
        ToggleBg.Parent = Frame
        
        local BgCorner = Instance.new("UICorner")
        BgCorner.CornerRadius = UDim.new(0, 13)
        BgCorner.Parent = ToggleBg
        
        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 22, 0, 22)
        Knob.Position = default and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
        Knob.BackgroundColor3 = CONFIG.TextPrimary
        Knob.Parent = ToggleBg
        
        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(0, 11)
        KnobCorner.Parent = Knob
        
        local state = default or false
        
        Frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                state = not state
                TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and CONFIG.NeonColor or Color3.fromRGB(60, 60, 80)}):Play()
                TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -26, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)}):Play()
                if callback then callback(state) end
            end
        end)
    end
    
    function Elements:Notify(text, duration)
        duration = duration or 3
        local Notify = Instance.new("Frame")
        Notify.Size = UDim2.new(0, 300, 0, 60)
        Notify.Position = UDim2.new(1, -320, 0, 20)
        Notify.BackgroundColor3 = CONFIG.BgPrimary
        Notify.Parent = ScreenGui
        
        local nCorner = Instance.new("UICorner")
        nCorner.CornerRadius = UDim.new(0, 10)
        nCorner.Parent = Notify
        
        local nStroke = Instance.new("UIStroke")
        nStroke.Color = CONFIG.NeonColor
        nStroke.Thickness = 2
        nStroke.Parent = Notify
        
        local nLabel = Instance.new("TextLabel")
        nLabel.Size = UDim2.new(1, -20, 1, 0)
        nLabel.Position = UDim2.new(0, 10, 0, 0)
        nLabel.BackgroundTransparency = 1
        nLabel.Text = text
        nLabel.TextColor3 = CONFIG.TextPrimary
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
    
    return Elements
end

return NeonVibes
