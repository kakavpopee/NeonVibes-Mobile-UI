local NeonVibesMobile = {}
NeonVibesMobile.__index = NeonVibesMobile

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
    WindowWidthScale = 0.94,
    WindowHeightScale = 0.92,
    MaxSize = Vector2.new(540, 1200),
    CornerRadius = 16,
    Padding = 10,
    ElementHeight = 52,
    TextSize = 17,
    TabHeight = 44,
    NeonColor = Color3.fromRGB(0, 255, 255),
    Background = Color3.fromRGB(16, 16, 26),
    Accent = Color3.fromRGB(28, 28, 48),
    StrokeThickness = 2.8,
    Theme = "Dark", -- or "Light"
}

local THEMES = {
    Dark = {Bg = Color3.fromRGB(16,16,26), Accent = Color3.fromRGB(28,28,48), Text = Color3.new(1,1,1), Neon = Color3.fromRGB(0,255,255)},
    Light = {Bg = Color3.fromRGB(245,245,250), Accent = Color3.fromRGB(220,220,240), Text = Color3.new(0,0,0), Neon = Color3.fromRGB(0,180,255)},
}

local currentTheme = THEMES[CONFIG.Theme]

-- Helper: Tween
local function tween(obj, info, props)
    TweenService:Create(obj, info or TweenInfo.new(0.3, Enum.EasingStyle.Quint), props):Play()
end

function NeonVibesMobile.new(titleText, settings)
    settings = settings or {}
    local self = setmetatable({}, NeonVibesMobile)
    
    self.Minimized = false
    self.FullSize = UDim2.new(CONFIG.WindowWidthScale, 0, CONFIG.WindowHeightScale, 0)
    self.CenterPos = UDim2.new(0.5, 0, 0.5, 0)
    self.TitleText = titleText or "NeonVibes Mobile 2026"
    self.Flags = {} -- for config saving
    self.ToggleKey = settings.ToggleKey or Enum.KeyCode.RightShift
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NeonVibesMobile"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = PlayerGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = self.FullSize
    self.MainFrame.Position = self.CenterPos
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = currentTheme.Bg
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    local constraint = Instance.new("UISizeConstraint")
    constraint.MaxSize = CONFIG.MaxSize
    constraint.Parent = self.MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = currentTheme.Neon
    mainStroke.Thickness = CONFIG.StrokeThickness
    mainStroke.Transparency = 0.35
    mainStroke.Parent = self.MainFrame
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, CONFIG.CornerRadius)
    mainCorner.Parent = self.MainFrame
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 56)
    self.TitleBar.BackgroundColor3 = currentTheme.Accent
    self.TitleBar.Parent = self.MainFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -200, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.TitleText
    titleLabel.TextColor3 = currentTheme.Neon
    titleLabel.TextSize = 22
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TitleBar
    
    -- Buttons: Minimize, Close, Theme Switch
    local function createBtn(text, posX, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 44, 0, 44)
        btn.Position = UDim2.new(1, posX, 0.5, -22)
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.TextSize = 28
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.Parent = self.TitleBar
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 10)
        corner.Parent = btn
        
        btn.MouseButton1Click:Connect(callback)
        return btn
    end
    
    createBtn("−", -148, Color3.fromRGB(255,215,0), function() self:Minimize() end)
    createBtn("×", -102, Color3.fromRGB(220,40,40), function() self.ScreenGui:Destroy() end)
    createBtn("T", -56, Color3.fromRGB(100,200,255), function() 
        CONFIG.Theme = CONFIG.Theme == "Dark" and "Light" or "Dark"
        currentTheme = THEMES[CONFIG.Theme]
        self:ApplyTheme()
    end)
    
    -- Tab Bar (horizontal scrolling)
    self.TabBar = Instance.new("Frame")
    self.TabBar.Size = UDim2.new(1, 0, 0, CONFIG.TabHeight)
    self.TabBar.Position = UDim2.new(0, 0, 0, 56)
    self.TabBar.BackgroundTransparency = 1
    self.TabBar.Parent = self.MainFrame
    
    self.TabScrolling = Instance.new("ScrollingFrame")
    self.TabScrolling.Size = UDim2.new(1, 0, 1, 0)
    self.TabScrolling.BackgroundTransparency = 1
    self.TabScrolling.ScrollBarThickness = 0
    self.TabScrolling.ScrollingDirection = Enum.ScrollingDirection.X
    self.TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.X
    self.TabScrolling.Parent = self.TabBar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 12)
    tabLayout.Parent = self.TabScrolling
    
    -- Content
    self.ContentHolder = Instance.new("Frame")
    self.ContentHolder.Size = UDim2.new(1, 0, 1, -(56 + CONFIG.TabHeight))
    self.ContentHolder.Position = UDim2.new(0, 0, 0, 56 + CONFIG.TabHeight)
    self.ContentHolder.BackgroundTransparency = 1
    self.ContentHolder.Parent = self.MainFrame
    
    self.Content = Instance.new("ScrollingFrame")
    self.Content.Size = UDim2.new(1, 0, 1, 0)
    self.Content.BackgroundTransparency = 1
    self.Content.ScrollBarThickness = 4
    self.Content.Parent = self.ContentHolder
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, CONFIG.Padding)
    contentLayout.Parent = self.Content
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, CONFIG.Padding)
    contentPadding.PaddingRight = UDim.new(0, CONFIG.Padding)
    contentPadding.PaddingTop = UDim.new(0, CONFIG.Padding)
    contentPadding.PaddingBottom = UDim.new(0, CONFIG.Padding * 2)
    contentPadding.Parent = self.Content
    
    -- Draggable
    local dragging, dragInput, dragStart, startPos
    local function updateDrag(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateDrag(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Minimized Opener
    self.Opener = Instance.new("TextButton")
    self.Opener.Size = UDim2.new(0, 70, 0, 70)
    self.Opener.AnchorPoint = Vector2.new(0.5, 0.5)
    self.Opener.Position = UDim2.new(1, -60, 1, -60)
    self.Opener.BackgroundColor3 = currentTheme.Neon
    self.Opener.Text = "N"
    self.Opener.TextColor3 = Color3.new(0,0,0)
    self.Opener.TextSize = 38
    self.Opener.Font = Enum.Font.GothamBold
    self.Opener.Visible = false
    self.Opener.Parent = self.ScreenGui
    
    local openerCorner = Instance.new("UICorner")
    openerCorner.CornerRadius = UDim.new(1, 0)
    openerCorner.Parent = self.Opener
    
    -- Make opener draggable too
    self.Opener.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.Opener.Position
        end
    end)
    
    self.Opener.MouseButton1Click:Connect(function()
        self:Open()
    end)
    
    function self:Minimize()
        if self.Minimized then return end
        self.Minimized = true
        tween(self.MainFrame, nil, {Size = UDim2.new(0,70,0,70), Position = self.Opener.Position, Rotation = 360})
        task.delay(0.4, function()
            self.MainFrame.Visible = false
            self.Opener.Visible = true
        end)
    end
    
    function self:Open()
        if not self.Minimized then return end
        self.Minimized = false
        self.MainFrame.Size = UDim2.new(0,70,0,70)
        self.MainFrame.Position = self.Opener.Position
        self.MainFrame.Visible = true
        self.Opener.Visible = false
        tween(self.MainFrame, nil, {Size = self.FullSize, Position = self.CenterPos, Rotation = 0})
    end
    
    -- Toggle UI Keybind
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == self.ToggleKey then
            self.MainFrame.Visible = not self.MainFrame.Visible
        end
    end)
    
    self.Tabs = {}
    self.SelectedTab = nil
    
    self:ApplyTheme()
    
    return self
end

function NeonVibesMobile:ApplyTheme()
    local t = currentTheme
    self.MainFrame.BackgroundColor3 = t.Bg
    self.TitleBar.BackgroundColor3 = t.Accent
    -- You can loop through all elements and update if needed (advanced)
end

function NeonVibesMobile:CreateTab(name)
    local tab = {}
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 150, 1, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.new(0.8,0.8,0.8)
    tabBtn.TextSize = CONFIG.TextSize
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = self.TabScrolling
    
    local underline = Instance.new("Frame")
    underline.Size = UDim2.new(0.8, 0, 0, 4)
    underline.Position = UDim2.new(0.1, 0, 1, -4)
    underline.BackgroundColor3 = currentTheme.Neon
    underline.Visible = false
    underline.Parent = tabBtn
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.ScrollBarThickness = 4
    tabContent.Parent = self.ContentHolder
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, CONFIG.Padding)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabContent
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, CONFIG.Padding)
    padding.PaddingRight = UDim.new(0, CONFIG.Padding)
    padding.PaddingTop = UDim.new(0, CONFIG.Padding)
    padding.Parent = tabContent
    
    tab.Button = tabBtn
    tab.Underline = underline
    tab.Content = tabContent
    
    tabBtn.MouseButton1Click:Connect(function()
        if self.SelectedTab then
            self.SelectedTab.Underline.Visible = false
            self.SelectedTab.Button.TextColor3 = Color3.new(0.8,0.8,0.8)
            self.SelectedTab.Content.Visible = false
        end
        underline.Visible = true
        tabBtn.TextColor3 = currentTheme.Neon
        tabContent.Visible = true
        self.SelectedTab = tab
    end)
    
    if not self.SelectedTab then
        tabBtn.MouseButton1Click:Fire()
    end
    
    table.insert(self.Tabs, tab)
    return tab
end

-- Section (header)
function NeonVibesMobile:AddSection(tab, title)
    local section = Instance.new("TextLabel")
    section.Size = UDim2.new(1, 0, 0, 34)
    section.BackgroundTransparency = 1
    section.Text = title
    section.TextColor3 = currentTheme.Neon
    section.TextSize = CONFIG.TextSize + 4
    section.Font = Enum.Font.GothamBold
    section.TextXAlignment = Enum.TextXAlignment.Left
    section.Parent = tab.Content
end

-- Button
function NeonVibesMobile:AddButton(tab, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
    btn.BackgroundColor3 = currentTheme.Accent
    btn.Text = text
    btn.TextColor3 = currentTheme.Text
    btn.TextSize = CONFIG.TextSize + 2
    btn.Font = Enum.Font.GothamBold
    btn.Parent = tab.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = currentTheme.Neon
    stroke.Thickness = 1.2
    stroke.Parent = btn
    
    btn.MouseButton1Down:Connect(function()
        tween(btn, TweenInfo.new(0.15), {BackgroundColor3 = currentTheme.Neon})
        task.delay(0.15, function()
            tween(btn, TweenInfo.new(0.25), {BackgroundColor3 = currentTheme.Accent})
        end)
    end)
    
    btn.MouseButton1Click:Connect(callback or function() end)
end

-- Toggle
function NeonVibesMobile:AddToggle(tab, name, default, callback, flag)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, CONFIG.ElementHeight)
    frame.BackgroundTransparency = 1
    frame.Parent = tab.Content
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = currentTheme.Text
    label.TextSize = CONFIG.TextSize
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 74, 0, 36)
    toggleBg.Position = UDim2.new(1, -84, 0.5, -18)
    toggleBg.BackgroundColor3 = default and currentTheme.Neon or Color3.fromRGB(70,70,90)
    toggleBg.Parent = frame
    
    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(1, 0)
    bgCorner.Parent = toggleBg
    
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 32, 0, 32)
    knob.Position = default and UDim2.new(1, -36, 0.5, -16) or UDim2.new(0, 4, 0.5, -16)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = toggleBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    local state = default or false
    
    local function updateToggle()
        tween(toggleBg, TweenInfo.new(0.25), {BackgroundColor3 = state and currentTheme.Neon or Color3.fromRGB(70,70,90)})
        tween(knob, TweenInfo.new(0.25), {Position = state and UDim2.new(1, -36, 0.5, -16) or UDim2.new(0, 4, 0.5, -16)})
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            updateToggle()
            if callback then callback(state) end
            if flag then self.Flags[flag] = state end
        end
    end)
    
    if flag then self.Flags[flag] = state end
end

-- Add more elements similarly: Dropdown, ColorPicker, Keybind, Textbox, Paragraph, etc.
-- (Full implementation would make this response too long - add them step by step as needed)

-- Example Dropdown stub
function NeonVibesMobile:AddDropdown(tab, name, options, default, callback, flag)
    -- Implement scrolling dropdown with selection highlight
    -- ...
end

-- Save/Load Config (stub - expand with writefile/readfile)
function NeonVibesMobile:SaveConfig()
    -- if writefile then writefile("NeonVibesConfig.json", game:GetService("HttpService"):JSONEncode(self.Flags)) end
end

function NeonVibesMobile:LoadConfig()
    -- if isfile then local data = readfile("NeonVibesConfig.json") ... end
end

-- Notification
function NeonVibesMobile:Notify(text, duration)
    -- (keep or enhance previous notification)
end

return NeonVibesMobile    self.MainFrame.Size = UDim2.new(CONFIG.WindowWidthScale, 0, 0.85, 0)
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
