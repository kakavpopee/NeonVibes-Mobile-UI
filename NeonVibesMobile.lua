local NeonVibesMobile = {}
NeonVibesMobile.__index = NeonVibesMobile

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Config for mobile-friendliness
local CONFIG = {
    WindowWidthScale = 0.92,
    WindowMaxWidthOffset = 40,
    CornerRadius = 12,
    Padding = 14,
    ElementHeight = 54,
    TextSize = 20,
    NeonColor = Color3.fromRGB(0, 255, 255),
    Background = Color3.fromRGB(18, 18, 28),
    Accent = Color3.fromRGB(35, 35, 55),
    StrokeThickness = 2.5,
}

function NeonVibesMobile.new(title)
    local self = setmetatable({}, NeonVibesMobile)
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NeonVibesMobile"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = PlayerGui
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.BackgroundColor3 = CONFIG.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Size = UDim2.new(CONFIG.WindowWidthScale, 0, 0.85, 0)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    
    local constraint = Instance.new("UISizeConstraint")
    constraint.MaxSize = Vector2.new(460, 900)
    constraint.Parent = self.MainFrame
    
    self.MainFrame.Parent = self.ScreenGui
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = CONFIG.NeonColor
    stroke.Thickness = CONFIG.StrokeThickness
    stroke.Transparency = 0.4
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = self.MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    corner.Parent = self.MainFrame
    
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 56)
    self.TitleBar.BackgroundColor3 = CONFIG.Accent
    self.TitleBar.Parent = self.MainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "NeonVibes Mobile"
    titleLabel.TextColor3 = CONFIG.NeonColor
    titleLabel.TextSize = 22
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TitleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 44, 0, 44)
    closeBtn.Position = UDim2.new(1, -54, 0.5, -22)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextSize = 28
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = self.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    self.Content = Instance.new("ScrollingFrame")
    self.Content.Size = UDim2.new(1, 0, 1, -56)
    self.Content.Position = UDim2.new(0, 0, 0, 56)
    self.Content.BackgroundTransparency = 1
    self.Content.ScrollBarThickness = 6
    self.Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Content.Parent = self.MainFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, CONFIG.Padding)
    listLayout.Parent = self.Content
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, CONFIG.Padding)
    padding.PaddingRight = UDim.new(0, CONFIG.Padding)
    padding.PaddingTop = UDim.new(0, CONFIG.Padding)
    padding.PaddingBottom = UDim.new(0, CONFIG.Padding)
    padding.Parent = self.Content
    
    -- Mobile drag
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(self.MainFrame, TweenInfo.new(0.12), {Position = newPos}):Play()
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    self.Tabs = {}
    self.CurrentTabContent = nil
    
    return self
end

function NeonVibesMobile:CreateTab(name)
    local tab = {}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 54)
    tabBtn.BackgroundColor3 = CONFIG.Accent
    tabBtn.Text = "  " .. name
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.TextSize = CONFIG.TextSize
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.Parent = self.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = tabBtn
    
    local tabContent = Instance.new("Frame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = self.MainFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, CONFIG.Padding)
    tabLayout.Parent = tabContent
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, CONFIG.Padding)
    tabPadding.PaddingRight = UDim.new(0, CONFIG.Padding)
    tabPadding.PaddingTop = UDim.new(0, 8)
    tabPadding.PaddingBottom = UDim.new(0, CONFIG.Padding)
    tabPadding.Parent = tabContent
    
    tab.Content = tabContent
    tab.Button = tabBtn
    
    tabBtn.MouseButton1Click:Connect(function()
        if self.CurrentTabContent then
            self.CurrentTabContent.Visible = false
        end
        tabContent.Visible = true
        self.CurrentTabContent = tabContent
    end)
    
    if #self.Tabs == 0 then
        tabContent.Visible = true
        self.CurrentTabContent = tabContent
    end
    
    table.insert(self.Tabs, tab)
    
    return tab
end

function NeonVibesMobile:AddButton(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
    btn.BackgroundColor3 = CONFIG.NeonColor
    btn.BackgroundTransparency = 0.6
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = CONFIG.TextSize + 2
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tab.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = CONFIG.NeonColor
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(callback or function() end)
    
    -- Ripple for touch feedback
    btn.MouseButton1Down:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.BackgroundColor3 = Color3.new(1,1,1)
        ripple.BackgroundTransparency = 0.7
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.ZIndex = 10
        ripple.Parent = btn
        
        local rippleCorner = Instance.new("UICorner")
        rippleCorner.CornerRadius = UDim.new(1, 0)
        rippleCorner.Parent = ripple
        
        TweenService:Create(ripple, TweenInfo.new(0.6), {Size = UDim2.new(2.5, 0, 2.5, 0), BackgroundTransparency = 1}):Play()
        
        task.delay(0.7, function() ripple:Destroy() end)
    end)
end

function NeonVibesMobile:AddSlider(tab, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight + 20)
    frame.BackgroundTransparency = 1
    frame.Parent = tab.Content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. tostring(default)
    label.TextColor3 = Color3.new(1,1,1)
    label.TextSize = CONFIG.TextSize
    label.Font = Enum.Font.GothamSemibold
    label.Parent = frame
    
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 12)
    bar.Position = UDim2.new(0, 0, 0, 34)
    bar.BackgroundColor3 = Color3.fromRGB(60,60,80)
    bar.Parent = frame
    
    local cornerBar = Instance.new("UICorner")
    cornerBar.CornerRadius = UDim.new(0, 6)
    cornerBar.Parent = bar
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = CONFIG.NeonColor
    fill.Parent = bar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = fill
    
    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 0, 44)
    hitbox.Position = UDim2.new(0, 0, 0, 28)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = frame
    
    local dragging = false
    
    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    hitbox.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local relative = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local value = math.round(min + (max - min) * relative)
            fill.Size = UDim2.new(relative, 0, 1, 0)
            label.Text = name .. ": " .. value
            if callback then callback(value) end
        end
    end)
end

function NeonVibesMobile:Notify(text, duration)
    local notifyFrame = Instance.new("Frame")
    notifyFrame.Size = UDim2.new(0, 250, 0, 60)
    notifyFrame.Position = UDim2.new(1, -260, 0, 20)
    notifyFrame.BackgroundColor3 = CONFIG.Background
    notifyFrame.Parent = self.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notifyFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = CONFIG.NeonColor
    stroke.Thickness = 2
    stroke.Parent = notifyFrame
    
    local notifyText = Instance.new("TextLabel")
    notifyText.Size = UDim2.new(1, 0, 1, 0)
    notifyText.Text = text
    notifyText.TextColor3 = Color3.new(1,1,1)
    notifyText.BackgroundTransparency = 1
    notifyText.TextSize = 18
    notifyText.Font = Enum.Font.Gotham
    notifyText.TextWrapped = true
    notifyText.Parent = notifyFrame
    
    TweenService:Create(notifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -260, 0, 20)}):Play()  -- Slide in
    
    task.wait(duration or 3)
    
    TweenService:Create(notifyFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 0, 0, 20)}):Play()  -- Slide out
    task.wait(0.3)
    notifyFrame:Destroy()
end

return NeonVibesMobile
