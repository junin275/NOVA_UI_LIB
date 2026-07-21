-- =============================================================================
-- 🔥 Classic Football Hub v3.0 - Nova UI Style (Complete Inline)
-- =============================================================================
-- Para The Classic Soccer (Roblox) - 100% autônomo, sem HTTP externo
-- Execute como LocalScript em qualquer executor
-- =============================================================================

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StatsService = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local NetworkStats = StatsService:FindFirstChild("Network")

-- =============================================================================
-- 🎨 INLINE: NOVA UI CORE MODULES
-- =============================================================================
local NovaTheme = {}
NovaTheme.__index = NovaTheme
NovaTheme.CurrentTheme = "Default"
NovaTheme.CurrentPalette = {}
NovaTheme.CustomPalettes = {}
NovaTheme.Listeners = {}

local PALETTE_DEFAULT = {
    Background = Color3.fromRGB(13, 13, 15),
    Surface = Color3.fromRGB(20, 20, 24),
    SurfaceAlt = Color3.fromRGB(26, 26, 32),
    Border = Color3.fromRGB(35, 35, 42),
    BorderLight = Color3.fromRGB(42, 42, 53),
    Accent = Color3.fromRGB(79, 124, 255),
    AccentSecondary = Color3.fromRGB(118, 89, 255),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(154, 154, 176),
    TextMuted = Color3.fromRGB(90, 90, 112),
    Success = Color3.fromRGB(76, 175, 132),
    Warning = Color3.fromRGB(255, 184, 76),
    Danger = Color3.fromRGB(255, 107, 107),
    Info = Color3.fromRGB(79, 124, 255),
    Overlay = Color3.fromRGB(0, 0, 0),
    Shadow = Color3.fromRGB(0, 0, 0),
}

local THEMES = {
    Default = PALETTE_DEFAULT,
    Amethyst = {
        Background = Color3.fromRGB(13, 13, 15),
        Surface = Color3.fromRGB(20, 20, 24),
        SurfaceAlt = Color3.fromRGB(26, 26, 32),
        Border = Color3.fromRGB(35, 35, 42),
        BorderLight = Color3.fromRGB(42, 42, 53),
        Accent = Color3.fromRGB(156, 101, 217),
        AccentSecondary = Color3.fromRGB(217, 101, 189),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(154, 154, 176),
        TextMuted = Color3.fromRGB(90, 90, 112),
        Success = Color3.fromRGB(76, 175, 132),
        Warning = Color3.fromRGB(255, 184, 76),
        Danger = Color3.fromRGB(255, 107, 107),
        Info = Color3.fromRGB(156, 101, 217),
        Overlay = Color3.fromRGB(0, 0, 0),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Emerald = {
        Background = Color3.fromRGB(13, 15, 13),
        Surface = Color3.fromRGB(20, 24, 20),
        SurfaceAlt = Color3.fromRGB(26, 32, 26),
        Border = Color3.fromRGB(35, 42, 35),
        BorderLight = Color3.fromRGB(42, 53, 42),
        Accent = Color3.fromRGB(38, 185, 128),
        AccentSecondary = Color3.fromRGB(38, 128, 185),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(154, 176, 154),
        TextMuted = Color3.fromRGB(90, 112, 90),
        Success = Color3.fromRGB(76, 175, 132),
        Warning = Color3.fromRGB(255, 184, 76),
        Danger = Color3.fromRGB(255, 107, 107),
        Info = Color3.fromRGB(38, 185, 128),
        Overlay = Color3.fromRGB(0, 0, 0),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Ruby = {
        Background = Color3.fromRGB(15, 13, 13),
        Surface = Color3.fromRGB(24, 20, 20),
        SurfaceAlt = Color3.fromRGB(32, 26, 26),
        Border = Color3.fromRGB(42, 35, 35),
        BorderLight = Color3.fromRGB(53, 42, 42),
        Accent = Color3.fromRGB(217, 65, 65),
        AccentSecondary = Color3.fromRGB(185, 65, 101),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(176, 154, 154),
        TextMuted = Color3.fromRGB(112, 90, 90),
        Success = Color3.fromRGB(76, 175, 132),
        Warning = Color3.fromRGB(255, 184, 76),
        Danger = Color3.fromRGB(255, 107, 107),
        Info = Color3.fromRGB(217, 65, 65),
        Overlay = Color3.fromRGB(0, 0, 0),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Sapphire = {
        Background = Color3.fromRGB(13, 13, 15),
        Surface = Color3.fromRGB(20, 20, 24),
        SurfaceAlt = Color3.fromRGB(26, 26, 32),
        Border = Color3.fromRGB(35, 35, 42),
        BorderLight = Color3.fromRGB(42, 42, 53),
        Accent = Color3.fromRGB(45, 156, 219),
        AccentSecondary = Color3.fromRGB(45, 101, 219),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(154, 154, 176),
        TextMuted = Color3.fromRGB(90, 90, 112),
        Success = Color3.fromRGB(76, 175, 132),
        Warning = Color3.fromRGB(255, 184, 76),
        Danger = Color3.fromRGB(255, 107, 107),
        Info = Color3.fromRGB(45, 156, 219),
        Overlay = Color3.fromRGB(0, 0, 0),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
}

function NovaTheme:GetColor(key)
    local p = NovaTheme.CurrentPalette
    return p and p[key] or PALETTE_DEFAULT[key] or Color3.new(1, 1, 1)
end

function NovaTheme:GetThemeList()
    local list = {}
    for k in pairs(THEMES) do table.insert(list, k) end
    for k in pairs(NovaTheme.CustomPalettes) do table.insert(list, k) end
    return list
end

function NovaTheme:ApplyTheme(name)
    local p = THEMES[name] or NovaTheme.CustomPalettes[name]
    if not p then return end
    NovaTheme.CurrentTheme = name
    NovaTheme.CurrentPalette = p
    for _, cb in ipairs(NovaTheme.Listeners) do
        pcall(cb, p, true)
    end
end

function NovaTheme:OnChange(cb)
    table.insert(NovaTheme.Listeners, cb)
    return function()
        for i, v in ipairs(NovaTheme.Listeners) do
            if v == cb then table.remove(NovaTheme.Listeners, i) break end
        end
    end
end

NovaTheme:ApplyTheme("Default")

-- =============================================================================
-- 🎬 NOVA ANIMATION MANAGER
-- =============================================================================
local NovaAnim = {}

local EASING_STYLES = {
    Smooth = Enum.EasingStyle.Quad,
    Bouncy = Enum.EasingStyle.Back,
    Sharp = Enum.EasingStyle.Exponential,
    Soft = Enum.EasingStyle.Sine,
    Elastic = Enum.EasingStyle.Elastic,
}

local EASING_DIRS = {
    In = Enum.EasingDirection.In,
    Out = Enum.EasingDirection.Out,
    InOut = Enum.EasingDirection.InOut,
}

local ActiveTweens = {}

function NovaAnim:CreateTween(inst, props, style, dir, dur, cb)
    style = EASING_STYLES[style] or EASING_STYLES.Smooth
    dir = EASING_DIRS[dir] or EASING_DIRS.Out
    dur = dur or 0.3
    if ActiveTweens[inst] then
        ActiveTweens[inst]:Cancel()
        ActiveTweens[inst] = nil
    end
    local t = TweenService:Create(inst, TweenInfo.new(dur, style, dir), props)
    if cb then t.Completed:Connect(cb) end
    ActiveTweens[inst] = t
    t:Play()
    return t
end

function NovaAnim:CancelAll()
    for i, t in ActiveTweens do
        if t then t:Cancel() end
    end
    ActiveTweens = {}
end

-- =============================================================================
-- 🛠️ NOVA UTILITY
-- =============================================================================
local NovaUtil = {}

function NovaUtil:Corner(inst, r)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, r or 6)
    return c
end

function NovaUtil:Stroke(inst, color, trans, thick)
    local s = Instance.new("UIStroke", inst)
    s.Color = color or Color3.fromRGB(35, 35, 42)
    s.Transparency = trans or 0.5
    s.Thickness = thick or 1
    return s
end

function NovaUtil:Gradient(inst, c1, c2, rot)
    local g = Instance.new("UIGradient", inst)
    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)})
    g.Rotation = rot or 90
    return g
end

function NovaUtil:ListLayout(inst, dir, pad, halign)
    local l = Instance.new("UIListLayout", inst)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, pad or 4)
    l.HorizontalAlignment = halign or Enum.HorizontalAlignment.Left
    l.VerticalAlignment = Enum.VerticalAlignment.Top
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

function NovaUtil:Scrolling(parent, size, pos)
    local s = Instance.new("ScrollingFrame", parent)
    s.Size = size
    s.Position = pos
    s.BackgroundTransparency = 1
    s.BorderSizePixel = 0
    s.ScrollBarThickness = 2
    s.ScrollBarImageColor3 = NovaTheme:GetColor("Accent")
    s.ScrollBarImageTransparency = 0.6
    s.CanvasSize = UDim2.new(0, 0, 0, 0)
    s.AutomaticCanvasSize = Enum.AutomaticSize.Y
    s.ScrollingDirection = Enum.ScrollingDirection.Y
    s.ElasticBehavior = Enum.ElasticBehavior.Never
    return s
end

-- =============================================================================
-- 📰 NOTIFICATIONS
-- =============================================================================
local Notifications = {}
local notifGui = Instance.new("ScreenGui", CoreGui)
notifGui.Name = "CFH_Notifs"
notifGui.ResetOnSpawn = false
notifGui.IgnoreGuiInset = true
notifGui.DisplayOrder = 100

local notifColors = {
    info = Color3.fromRGB(40, 40, 55),
    success = Color3.fromRGB(30, 60, 30),
    warning = Color3.fromRGB(60, 50, 20),
    error = Color3.fromRGB(60, 20, 20),
}
local notifBorders = {
    info = NovaTheme:GetColor("Info"),
    success = NovaTheme:GetColor("Success"),
    warning = NovaTheme:GetColor("Warning"),
    error = NovaTheme:GetColor("Danger"),
}

function Notifications:Send(title, msg, dur, typ)
    typ = typ or "info"
    local idx = #notifGui:GetChildren() + 1
    local f = Instance.new("Frame", notifGui)
    f.Name = "N" .. idx
    f.Size = UDim2.new(0, 340, 0, 70)
    f.Position = UDim2.new(1, 20, 1, -20 - (idx - 1) * 78)
    f.BackgroundColor3 = notifColors[typ]
    f.BackgroundTransparency = 0.05
    f.ClipsDescendants = true
    NovaUtil:Corner(f, 10)
    NovaUtil:Stroke(f, notifBorders[typ], 0, 1)

    local ab = Instance.new("Frame", f)
    ab.Size = UDim2.new(0, 3, 1, 0)
    ab.BackgroundColor3 = notifBorders[typ]
    ab.BorderSizePixel = 0

    local tl = Instance.new("TextLabel", f)
    tl.Size = UDim2.new(1, -50, 0, 22)
    tl.Position = UDim2.new(0, 16, 0, 6)
    tl.BackgroundTransparency = 1
    tl.Font = Enum.Font.GothamSemibold
    tl.TextSize = 15; tl.Text = title
    tl.TextColor3 = NovaTheme:GetColor("TextPrimary")
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextYAlignment = Enum.TextYAlignment.Center

    local ml = Instance.new("TextLabel", f)
    ml.Size = UDim2.new(1, -50, 0, 32)
    ml.Position = UDim2.new(0, 16, 0, 30)
    ml.BackgroundTransparency = 1
    ml.Font = Enum.Font.Gotham
    ml.TextSize = 12; ml.Text = msg
    ml.TextColor3 = NovaTheme:GetColor("TextSecondary")
    ml.TextXAlignment = Enum.TextXAlignment.Left
    ml.TextYAlignment = Enum.TextYAlignment.Top
    ml.TextWrapped = true

    NovaAnim:CreateTween(f, {Position = UDim2.new(1, -(340 + 10), 1, -20 - (idx - 1) * 78)}, "Smooth", "Out", 0.4)
    local alive = true
    task.delay(dur or 4, function()
        if alive then
            alive = false
            NovaAnim:CreateTween(f, {Position = UDim2.new(1, 20, 1, -20)}, "Smooth", "In", 0.3, function() f:Destroy() end)
        end
    end)
end

-- =============================================================================
-- 🎮 GAME STATE
-- =============================================================================
local Game = {
    Ball = {Ref = nil, Pos = Vector3.new(), Vel = Vector3.new(), Time = 0},
    GK = {Pos = Vector3.new(), Hitbox = Vector3.new()},
    Players = {},
    FPS = 0, Ping = 0, FrameCount = 0, FPSTimer = tick(),
}

function Game:FindBall()
    local names = {"TPS", "Ball", "Football", "SoccerBall"}
    for _, n in ipairs(names) do
        local obj = Workspace:FindFirstChild(n)
        if obj and obj:IsA("BasePart") then
            local s = obj.Size
            if math.abs(s.X - 2.5) < 0.1 and math.abs(s.Y - 2.5) < 0.1 and math.abs(s.Z - 2.5) < 0.1 then
                return obj
            end
        end
    end
    for _, p in ipairs(Workspace:GetDescendants()) do
        if p:IsA("BasePart") then
            local s = p.Size
            if math.abs(s.X - 2.5) < 0.1 and math.abs(s.Y - 2.5) < 0.1 and math.abs(s.Z - 2.5) < 0.1 then
                return p
            end
        end
    end
    return nil
end

function Game:Update()
    local ball = Game:FindBall()
    if ball then
        Game.Ball.Ref = ball
        Game.Ball.Pos = ball.Position
        Game.Ball.CFrame = ball.CFrame
        Game.Ball.Vel = ball.AssemblyLinearVelocity or ball.Velocity or Vector3.new()
        Game.Ball.Time = tick()
    end
    local folder = Workspace:FindFirstChild("WorkspaceGKBotsFolder")
    if folder then
        local away = folder:FindFirstChild("AwayBot")
        if away then
            local hrp = away:FindFirstChild("HumanoidRootPart")
            local hb = away:FindFirstChild("Hitbox")
            if hrp then Game.GK.Pos = hrp.Position end
            if hb then Game.GK.Hitbox = hb.Position end
        end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local ch = p.Character
            if ch and ch.Parent then
                local hrp = ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    Game.Players[p.Name] = {
                        Char = ch, Root = hrp,
                        Head = ch:FindFirstChild("Head"),
                        Hitbox = ch:FindFirstChild("Hitbox"),
                        Hum = ch:FindFirstChild("Humanoid"),
                        Team = p.TeamColor and p.TeamColor.Color or Color3.new(1,1,1),
                    }
                end
            end
        end
    end
end

Players.PlayerRemoving:Connect(function(p) Game.Players[p.Name] = nil end)

-- =============================================================================
-- 🎯 ESP
-- =============================================================================
local HasDrawing = pcall(function() return Drawing.new("Line") end)
local ESP = {Lines = {}}

local function clearLines(t)
    for i = #t, 1, -1 do
        pcall(function() t[i].Visible = false end)
        t[i] = nil
    end
end

function ESP:Draw()
    if not HasDrawing or not CONFIG.ESP then return end
    clearLines(ESP.Lines)
    local cam = Camera
    if not cam then return end

    for _, pd in pairs(Game.Players) do
        if pd.Root and pd.Root.Parent then
            local rPos = pd.Root.Position
            local hPos = pd.Head and pd.Head.Position or (rPos + Vector3.new(0, 2, 0))
            local rScr = cam:WorldToViewportPoint(rPos)
            local hScr = cam:WorldToViewportPoint(hPos)
            if hScr.Z > 0 then
                local color = CONFIG.TeamColor and pd.Team or NovaTheme:GetColor("Accent")

                if CONFIG.Tracer then
                    local l = Drawing.new("Line")
                    l.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                    l.To = Vector2.new(rScr.X, rScr.Y)
                    l.Color = color; l.Thickness = 1.5; l.Visible = true
                    table.insert(ESP.Lines, l)
                end
                if CONFIG.Box then
                    local _, bot = cam:WorldToViewportPoint(rPos - Vector3.new(0, 2, 0))
                    local _, top = cam:WorldToViewportPoint(hPos + Vector3.new(0, 0.5, 0))
                    local height = math.abs(top.Y - bot.Y)
                    local width = height * 0.6
                    local s = Drawing.new("Square")
                    s.Position = Vector2.new(rScr.X - width/2, top.Y)
                    s.Size = Vector2.new(width, height)
                    s.Color = color; s.Thickness = 2; s.Visible = true
                    table.insert(ESP.Lines, s)
                end
                if CONFIG.Hitbox and pd.Hitbox then
                    local hbScr = cam:WorldToViewportPoint(pd.Hitbox.Position)
                    if hbScr.Z > 0 then
                        local s = Drawing.new("Square")
                        s.Position = Vector2.new(hbScr.X - 20, hbScr.Y - 25)
                        s.Size = Vector2.new(40, 50)
                        s.Color = NovaTheme:GetColor("Danger")
                        s.Thickness = 2; s.Filled = true; s.Transparency = 0.4; s.Visible = true
                        table.insert(ESP.Lines, s)
                    end
                end
                if CONFIG.Skeleton then
                    local parts = {"Left Arm", "Right Arm", "Left Leg", "Right Leg"}
                    for _, pn in ipairs(parts) do
                        local p = pd.Char:FindFirstChild(pn)
                        if p then
                            local scr = cam:WorldToViewportPoint(p.Position)
                            if scr.Z > 0 then
                                local l = Drawing.new("Line")
                                l.From = Vector2.new(rScr.X, rScr.Y)
                                l.To = Vector2.new(scr.X, scr.Y)
                                l.Color = color; l.Thickness = 1; l.Transparency = 0.3; l.Visible = true
                                table.insert(ESP.Lines, l)
                            end
                        end
                    end
                end
            end
        end
    end
    if CONFIG.Prediction and Game.Ball.Ref and Game.Ball.Ref.Parent and Game.Ball.Vel.Magnitude > 0.5 then
        local bScr = cam:WorldToViewportPoint(Game.Ball.Pos)
        if bScr.Z > 0 then
            local fp = Game.Ball.Pos + Game.Ball.Vel * CONFIG.PredictTime
            local fScr = cam:WorldToViewportPoint(fp)
            if fScr.Z > 0 then
                local l = Drawing.new("Line")
                l.From = Vector2.new(bScr.X, bScr.Y)
                l.To = Vector2.new(fScr.X, fScr.Y)
                l.Color = CONFIG.PredColor; l.Thickness = 2; l.Visible = true
                table.insert(ESP.Lines, l)
            end
        end
    end
end

-- =============================================================================
-- ⚙️ CONFIG
-- =============================================================================
local CONFIG = {
    ESP = true, TeamColor = true, Box = true, Skeleton = false, Tracer = true, Hitbox = true,
    Prediction = true, PredictTime = 5, PredColor = Color3.fromRGB(255, 200, 50),
    Fly = false, FlySpeed = 50,
}

local function saveCfg()
    pcall(function()
        writefile("ClassicFootball/config.json", HttpService:JSONEncode(CONFIG))
    end)
end

local function loadCfg()
    local ok, d = pcall(function() return HttpService:JSONDecode(readfile("ClassicFootball/config.json")) end)
    if ok and type(d) == "table" then
        for k, v in pairs(d) do if CONFIG[k] ~= nil then CONFIG[k] = v end end
    end
end

pcall(makefolder, "ClassicFootball")
loadCfg(); saveCfg()

-- =============================================================================
-- 🖥️ BUILD UI
-- =============================================================================
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "CFH_Nova"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 10

-- Window
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, 780, 0, 580)
main.Position = UDim2.new(0.5, -390, 0.5, -290)
main.BackgroundColor3 = NovaTheme:GetColor("Surface")
main.BorderSizePixel = 0
main.ClipsDescendants = true
NovaUtil:Corner(main, 12)
NovaUtil:Stroke(main, NovaTheme:GetColor("Border"), 0.4, 1.5)
local shad = Instance.new("ImageLabel", main)
shad.Name = "Shadow"; shad.BackgroundTransparency = 1; shad.BorderSizePixel = 0
shad.Size = UDim2.new(1, 40, 1, 40); shad.Position = UDim2.new(-0.5, -20, -0.5, -20)
shad.ZIndex = -1; shad.Image = "rbxassetid://1316045217"
shad.ImageColor3 = Color3.new(0,0,0); shad.ImageTransparency = 0.85
shad.ScaleType = Enum.ScaleType.Slice; shad.SliceCenter = Rect.new(10,10,118,118)

-- Title Bar
local tb = Instance.new("Frame", main)
tb.Name = "TitleBar"; tb.Size = UDim2.new(1,0,0,46)
tb.BackgroundColor3 = NovaTheme:GetColor("SurfaceAlt"); tb.BorderSizePixel = 0
NovaUtil:Corner(tb, 12); NovaUtil:Stroke(tb, NovaTheme:GetColor("Border"), 0.3, 1)

local title = Instance.new("TextLabel", tb)
title.Size = UDim2.new(1, -120, 1, 0); title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold; title.TextSize = 18
title.Text = "Classic Football Hub"; title.TextColor3 = NovaTheme:GetColor("TextPrimary")
title.TextXAlignment = Enum.TextXAlignment.Left; title.TextYAlignment = Enum.TextYAlignment.Center

-- FPS/Ping/Time labels on title
local fpsL = Instance.new("TextLabel", tb)
fpsL.Size = UDim2.new(0, 80, 1, 0); fpsL.Position = UDim2.new(1, -240, 0, 0)
fpsL.BackgroundTransparency = 1; fpsL.Font = Enum.Font.GothamSemibold; fpsL.TextSize = 13
fpsL.Text = "FPS: 0"; fpsL.TextColor3 = NovaTheme:GetColor("Success")
fpsL.TextXAlignment = Enum.TextXAlignment.Left; fpsL.TextYAlignment = Enum.TextYAlignment.Center

local pingL = Instance.new("TextLabel", tb)
pingL.Size = UDim2.new(0, 80, 1, 0); pingL.Position = UDim2.new(1, -160, 0, 0)
pingL.BackgroundTransparency = 1; pingL.Font = Enum.Font.GothamSemibold; pingL.TextSize = 13
pingL.Text = "Ping: 0ms"; pingL.TextColor3 = NovaTheme:GetColor("Accent")
pingL.TextXAlignment = Enum.TextXAlignment.Left; pingL.TextYAlignment = Enum.TextYAlignment.Center

local timeL = Instance.new("TextLabel", tb)
timeL.Size = UDim2.new(0, 70, 1, 0); timeL.Position = UDim2.new(1, -80, 0, 0)
timeL.BackgroundTransparency = 1; timeL.Font = Enum.Font.GothamSemibold; timeL.TextSize = 13
timeL.Text = os.date("%H:%M"); timeL.TextColor3 = NovaTheme:GetColor("Warning")
timeL.TextXAlignment = Enum.TextXAlignment.Left; timeL.TextYAlignment = Enum.TextYAlignment.Center

-- Buttons
local function titleBtn(icon, idx, clr)
    local b = Instance.new("TextButton", tb)
    b.Size = UDim2.new(0, 30, 0, 30); b.Position = UDim2.new(1, -(30*idx+5), 0.5, -15)
    b.BackgroundTransparency = 1; b.BorderSizePixel = 0
    b.Text = icon == "C" and "✕" or icon == "M" and "−" or "+"
    b.TextColor3 = NovaTheme:GetColor("TextPrimary")
    b.Font = Enum.Font.GothamBold; b.TextSize = 16
    NovaUtil:Corner(b, 6)
    b.MouseEnter:Connect(function() NovaAnim:CreateTween(b, {BackgroundTransparency = 0.3}, "Smooth", "Out", 0.15) end)
    b.MouseLeave:Connect(function() NovaAnim:CreateTween(b, {BackgroundTransparency = 1}, "Smooth", "Out", 0.2) end)
    return b
end
local minBtn = titleBtn("M", 2)
local closeBtn = titleBtn("C", 1)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0, 780, 0, 46) or UDim2.new(0, 780, 0, 580)
    main.Content.Visible = not minimized
    main.Tabs.Visible = not minimized
    minBtn.Text = minimized and "+" or "−"
end)

-- Drag
local dragging, dragOff
tb.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragOff = Vector2.new(i.Position.X - main.AbsolutePosition.X, i.Position.Y - main.AbsolutePosition.Y)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        main.Position = UDim2.new(0, i.Position.X - dragOff.X, 0, i.Position.Y - dragOff.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Tab Container
local tabCont = Instance.new("Frame", main)
tabCont.Name = "Tabs"; tabCont.Size = UDim2.new(1, 0, 0, 40)
tabCont.Position = UDim2.new(0, 0, 0, 46)
tabCont.BackgroundColor3 = NovaTheme:GetColor("Background"); tabCont.BorderSizePixel = 0
NovaUtil:Stroke(tabCont, NovaTheme:GetColor("Border"), 0.5, 1)

local indicator = Instance.new("Frame", tabCont)
indicator.Name = "Ind"; indicator.Size = UDim2.new(0, 0, 0, 2)
indicator.Position = UDim2.new(0, 0, 1, -2)
indicator.BackgroundColor3 = NovaTheme:GetColor("Accent"); indicator.BorderSizePixel = 0

-- Content Area
local content = Instance.new("Frame", main)
content.Name = "Content"; content.Size = UDim2.new(1, 0, 1, -(46+40))
content.Position = UDim2.new(0, 0, 0, 86)
content.BackgroundColor3 = NovaTheme:GetColor("Background"); content.BorderSizePixel = 0

-- =============================================================================
-- 🔘 TAB / SECTION / CONTROL BUILDER
-- =============================================================================
local CurrentTabs = {}

local function createTab(name, accentClr)
    local btn = Instance.new("TextButton", tabCont)
    btn.Name = "TB_" .. name; btn.Size = UDim2.new(0, 0, 1, 0)
    btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0
    btn.Text = "   " .. name; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 14
    btn.TextColor3 = NovaTheme:GetColor("TextMuted")
    btn.AutomaticSize = Enum.AutomaticSize.X
    local pad = Instance.new("UIPadding", btn); pad.PaddingLeft = UDim.new(0, 16); pad.PaddingRight = UDim.new(0, 16)

    local scroll = NovaUtil:Scrolling(content, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0))
    scroll.Name = "SC_" .. name; scroll.Visible = false
    local pad2 = Instance.new("UIPadding", scroll)
    pad2.PaddingTop = UDim.new(0, 12); pad2.PaddingBottom = UDim.new(0, 12)
    pad2.PaddingLeft = UDim.new(0, 14); pad2.PaddingRight = UDim.new(0, 14)
    local ll = NovaUtil:ListLayout(scroll, Enum.FillDirection.Vertical, 8, Enum.HorizontalAlignment.Left)

    local tabObj = {Name = name, Btn = btn, Scroll = scroll}

    function tabObj:Section(sOpts)
        sOpts = sOpts or {}
        local sec = Instance.new("Frame", scroll)
        sec.Size = UDim2.new(1, 0, 0, 0); sec.AutomaticSize = Enum.AutomaticSize.Y
        sec.BackgroundColor3 = NovaTheme:GetColor("Surface"); sec.BorderSizePixel = 0
        NovaUtil:Corner(sec, 8); NovaUtil:Stroke(sec, NovaTheme:GetColor("Border"), 0.5, 1)

        local ab = Instance.new("Frame", sec)
        ab.Size = UDim2.new(0, 3, 1, -4); ab.Position = UDim2.new(0, 0, 0, 2)
        ab.BackgroundColor3 = accentClr or NovaTheme:GetColor("Accent"); ab.BorderSizePixel = 0
        NovaUtil:Corner(ab, 2)

        local inner = Instance.new("Frame", sec)
        inner.Size = UDim2.new(1, -20, 1, -16); inner.Position = UDim2.new(0, 16, 0, 8)
        inner.BackgroundTransparency = 1; inner.BorderSizePixel = 0
        inner.AutomaticSize = Enum.AutomaticSize.Y
        local sl = NovaUtil:ListLayout(inner, Enum.FillDirection.Vertical, 6, Enum.HorizontalAlignment.Left)

        local secObj = {Frame = sec, Inner = inner}

        if sOpts.Name then
            local tf = Instance.new("Frame", inner)
            tf.Size = UDim2.new(1, 0, 0, 24); tf.BackgroundTransparency = 1; tf.BorderSizePixel = 0; tf.AutomaticSize = Enum.AutomaticSize.Y
            local nl = Instance.new("TextLabel", tf)
            nl.Size = UDim2.new(1, 0, 0, 20); nl.BackgroundTransparency = 1
            nl.Font = Enum.Font.GothamSemibold; nl.TextSize = 15; nl.Text = sOpts.Name
            nl.TextColor3 = NovaTheme:GetColor("TextPrimary")
            nl.TextXAlignment = Enum.TextXAlignment.Left; nl.TextYAlignment = Enum.TextYAlignment.Center
            if sOpts.Description then
                local dl = Instance.new("TextLabel", tf)
                dl.Size = UDim2.new(1, 0, 0, 16); dl.Position = UDim2.new(0, 0, 0, 22)
                dl.BackgroundTransparency = 1; dl.Font = Enum.Font.Gotham; dl.TextSize = 12
                dl.Text = sOpts.Description; dl.TextColor3 = NovaTheme:GetColor("TextMuted")
                dl.TextXAlignment = Enum.TextXAlignment.Left; dl.TextYAlignment = Enum.TextYAlignment.Center
            end
            local sep = Instance.new("Frame", tf)
            sep.Size = UDim2.new(1, 0, 0, 1); sep.Position = UDim2.new(0, 0, 1, 0)
            sep.BackgroundColor3 = NovaTheme:GetColor("Border"); sep.BorderSizePixel = 0
        end

        function secObj:Toggle(tOpts)
            tOpts = tOpts or {}
            local c = Instance.new("Frame", inner)
            c.Size = UDim2.new(1, 0, 0, 40); c.BackgroundTransparency = 1
            local bg = Instance.new("Frame", c)
            bg.Size = UDim2.new(0, 52, 0, 28); bg.Position = UDim2.new(1, -62, 0, 6)
            bg.BackgroundColor3 = tOpts.Default and NovaTheme:GetColor("Success") or NovaTheme:GetColor("Surface")
            bg.BorderSizePixel = 0
            NovaUtil:Corner(bg, 14); NovaUtil:Stroke(bg, NovaTheme:GetColor("Border"), 0.5, 1)
            local knob = Instance.new("Frame", bg)
            knob.Size = UDim2.new(0, 24, 0, 24)
            knob.Position = tOpts.Default and UDim2.new(0, 26, 0, 2) or UDim2.new(0, 2, 0, 2)
            knob.BackgroundColor3 = NovaTheme:GetColor("TextPrimary"); knob.BorderSizePixel = 0
            NovaUtil:Corner(knob, 12)
            local lbl = Instance.new("TextLabel", c)
            lbl.Size = UDim2.new(0, 200, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14
            lbl.Text = tOpts.Name or "Toggle"; lbl.TextColor3 = NovaTheme:GetColor("TextPrimary")
            lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextYAlignment = Enum.TextYAlignment.Center
            local state = tOpts.Default or false
            local function toggle()
                state = not state
                if state then
                    NovaAnim:CreateTween(bg, {BackgroundColor3 = NovaTheme:GetColor("Success")}, "Smooth", "Out", 0.2)
                    NovaAnim:CreateTween(knob, {Position = UDim2.new(0, 26, 0, 2)}, "Smooth", "Out", 0.2)
                else
                    NovaAnim:CreateTween(bg, {BackgroundColor3 = NovaTheme:GetColor("Surface")}, "Smooth", "Out", 0.2)
                    NovaAnim:CreateTween(knob, {Position = UDim2.new(0, 2, 0, 2)}, "Smooth", "Out", 0.2)
                end
                if tOpts.Callback then pcall(tOpts.Callback, state) end
            end
            bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end end)
            lbl.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then toggle() end end)
            return {Get = function() return state end, Set = function(v) if v ~= state then state = v; toggle() else state = v end end}
        end

        function secObj:Slider(sOpts)
            sOpts = sOpts or {}
            local c = Instance.new("Frame", inner)
            c.Size = UDim2.new(1, 0, 0, 50); c.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", c)
            lbl.Size = UDim2.new(1, 0, 0, 22); lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14
            lbl.Text = (sOpts.Name or "Slider")..": "..tostring(sOpts.Default or sOpts.Min or 0)
            lbl.TextColor3 = NovaTheme:GetColor("TextPrimary")
            lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextYAlignment = Enum.TextYAlignment.Center
            local min, max, val = sOpts.Min or 0, sOpts.Max or 100, sOpts.Default or (sOpts.Min or 0)
            local bar = Instance.new("Frame", c)
            bar.Size = UDim2.new(1, -20, 0, 8); bar.Position = UDim2.new(0, 10, 1, -22)
            bar.BackgroundColor3 = NovaTheme:GetColor("SurfaceAlt"); bar.BorderSizePixel = 0
            NovaUtil:Corner(bar, 4)
            local fill = Instance.new("Frame", bar)
            fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
            fill.BackgroundColor3 = NovaTheme:GetColor("Accent"); fill.BorderSizePixel = 0
            NovaUtil:Corner(fill, 4)
            local function update(x)
                local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                val = math.floor(min + (max - min) * rel + 0.5)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                lbl.Text = (sOpts.Name or "Slider")..": "..tostring(val)
                if sOpts.Callback then pcall(sOpts.Callback, val) end
            end
            bar.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then update(i.Position.X) end
            end)
            return {Get = function() return val end, Set = function(v) val = math.clamp(v, min, max); fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0); lbl.Text = (sOpts.Name or "Slider")..": "..tostring(val) end}
        end

        function secObj:Button(bOpts)
            bOpts = bOpts or {}
            local btn = Instance.new("TextButton", inner)
            btn.Size = UDim2.new(1, 0, 0, 42); btn.AutoButtonColor = false
            btn.BackgroundColor3 = bOpts.Color or NovaTheme:GetColor("SurfaceAlt")
            btn.BorderSizePixel = 0; btn.Text = bOpts.Name or "Button"
            btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 15
            btn.TextColor3 = NovaTheme:GetColor("TextPrimary")
            NovaUtil:Corner(btn, 8); NovaUtil:Stroke(btn, NovaTheme:GetColor("Border"), 0.5, 1)
            btn.MouseEnter:Connect(function() NovaAnim:CreateTween(btn, {BackgroundColor3 = NovaTheme:GetColor("Accent")}, "Smooth", "Out", 0.2) end)
            btn.MouseLeave:Connect(function() NovaAnim:CreateTween(btn, {BackgroundColor3 = bOpts.Color or NovaTheme:GetColor("SurfaceAlt")}, "Smooth", "Out", 0.2) end)
            if bOpts.Callback then btn.MouseButton1Click:Connect(bOpts.Callback) end
            return btn
        end

        function secObj:Label(lOpts)
            lOpts = lOpts or {}
            local l = Instance.new("TextLabel", inner)
            l.Size = UDim2.new(1, 0, 0, 28); l.BackgroundTransparency = 1
            l.Font = Enum.Font.GothamSemibold; l.TextSize = lOpts.TextSize or 14
            l.Text = lOpts.Text or ""; l.TextColor3 = lOpts.Color or NovaTheme:GetColor("TextPrimary")
            l.TextXAlignment = Enum.TextXAlignment.Left; l.TextYAlignment = Enum.TextYAlignment.Center
            return l
        end

        function secObj:ColorPicker(cOpts)
            cOpts = cOpts or {}
            local c = Instance.new("Frame", inner)
            c.Size = UDim2.new(1, 0, 0, 40); c.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", c)
            lbl.Size = UDim2.new(0, 180, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14
            lbl.Text = cOpts.Name or "Color"; lbl.TextColor3 = NovaTheme:GetColor("TextPrimary")
            lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextYAlignment = Enum.TextYAlignment.Center
            local sw = Instance.new("Frame", c)
            sw.Size = UDim2.new(0, 32, 0, 32); sw.Position = UDim2.new(1, -42, 0, 4)
            sw.BackgroundColor3 = cOpts.Default or Color3.new(1,0,0); sw.BorderSizePixel = 0
            NovaUtil:Corner(sw, 6); NovaUtil:Stroke(sw, NovaTheme:GetColor("Border"), 0.5, 1)
            local cur = cOpts.Default or Color3.new(1,0,0)
            sw.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    local pk = Instance.new("Frame", gui)
                    pk.Size = UDim2.new(0, 200, 0, 260); pk.ZIndex = 50
                    pk.BackgroundColor3 = NovaTheme:GetColor("Surface"); pk.BorderSizePixel = 0
                    NovaUtil:Corner(pk, 8); NovaUtil:Stroke(pk, NovaTheme:GetColor("Border"), 0.5, 1)
                    pk.Position = UDim2.new(0, math.clamp(sw.AbsolutePosition.X-80, 0, Camera.ViewportSize.X-200), 0, math.clamp(sw.AbsolutePosition.Y+40, 0, Camera.ViewportSize.Y-260))

                    local hb = Instance.new("Frame", pk)
                    hb.Size = UDim2.new(0, 180, 0, 20); hb.Position = UDim2.new(0, 10, 1, -80)
                    NovaUtil:Corner(hb, 4)

                    local sv = Instance.new("Frame", pk)
                    sv.Size = UDim2.new(0, 180, 0, 150); sv.Position = UDim2.new(0, 10, 0, 10)
                    sv.BackgroundColor3 = Color3.new(1,0,0)
                    NovaUtil:Corner(sv, 4)

                    local hue = 0
                    local function apply(h, s, v)
                        local col = Color3.fromHSV(h, s, v)
                        sw.BackgroundColor3 = col; sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                        cur = col
                        if cOpts.Callback then pcall(cOpts.Callback, col) end
                    end
                    hb.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            local r = math.clamp((inp.Position.X - hb.AbsolutePosition.X) / hb.AbsoluteSize.X, 0, 1)
                            hue = r; apply(hue, 1, 1)
                        end
                    end)
                    sv.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                            local rx = math.clamp((inp.Position.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
                            local ry = math.clamp(1 - (inp.Position.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
                            apply(hue, rx, ry)
                        end
                    end)

                    local ok = Instance.new("TextButton", pk)
                    ok.Size = UDim2.new(0, 80, 0, 30); ok.Position = UDim2.new(0, 10, 1, -50)
                    ok.Text = "OK"; ok.AutoButtonColor = false
                    ok.Font = Enum.Font.GothamSemibold; ok.TextColor3 = Color3.new(1,1,1)
                    ok.BackgroundColor3 = NovaTheme:GetColor("Success")
                    NovaUtil:Corner(ok, 6)
                    ok.MouseButton1Click:Connect(function() pk:Destroy() end)

                    local cancel = Instance.new("TextButton", pk)
                    cancel.Size = UDim2.new(0, 80, 0, 30); cancel.Position = UDim2.new(1, -90, 1, -50)
                    cancel.Text = "Cancel"; cancel.AutoButtonColor = false
                    cancel.Font = Enum.Font.GothamSemibold; cancel.TextColor3 = Color3.new(1,1,1)
                    cancel.BackgroundColor3 = NovaTheme:GetColor("Danger")
                    NovaUtil:Corner(cancel, 6)
                    cancel.MouseButton1Click:Connect(function() pk:Destroy() end)
                end
            end)
            return sw
        end

        function secObj:Dropdown(dOpts)
            dOpts = dOpts or {}
            local c = Instance.new("Frame", inner)
            c.Size = UDim2.new(1, 0, 0, 40); c.BackgroundTransparency = 1
            local lbl = Instance.new("TextLabel", c)
            lbl.Size = UDim2.new(0, 150, 1, 0); lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 14
            lbl.Text = dOpts.Name or "Dropdown"; lbl.TextColor3 = NovaTheme:GetColor("TextPrimary")
            lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextYAlignment = Enum.TextYAlignment.Center
            local sel = Instance.new("TextButton", c)
            sel.Size = UDim2.new(0, 120, 0, 30); sel.Position = UDim2.new(1, -130, 0, 5)
            sel.BackgroundColor3 = NovaTheme:GetColor("SurfaceAlt"); sel.BorderSizePixel = 0
            sel.AutoButtonColor = false; sel.Text = (dOpts.Items or {"-"})[1] or "-"
            sel.Font = Enum.Font.Gotham; sel.TextSize = 13; sel.TextColor3 = NovaTheme:GetColor("TextPrimary")
            NovaUtil:Corner(sel, 6); NovaUtil:Stroke(sel, NovaTheme:GetColor("Border"), 0.5, 1)
            local list = Instance.new("Frame", gui)
            list.Size = UDim2.new(0, 120, 0, 0); list.Visible = false; list.ZIndex = 40
            list.BackgroundColor3 = NovaTheme:GetColor("Surface"); list.BorderSizePixel = 0
            NovaUtil:Corner(list, 6); NovaUtil:Stroke(list, NovaTheme:GetColor("Border"), 0.5, 1)
            local lll = NovaUtil:ListLayout(list, Enum.FillDirection.Vertical, 2)
            local idx = 1
            for i, item in ipairs(dOpts.Items or {}) do
                local opt = Instance.new("TextButton", list)
                opt.Size = UDim2.new(1, 0, 0, 30); opt.ZIndex = 41; opt.AutoButtonColor = false
                opt.BackgroundColor3 = i == idx and NovaTheme:GetColor("Accent") or NovaTheme:GetColor("Surface")
                opt.BorderSizePixel = 0; opt.Text = item
                opt.Font = Enum.Font.Gotham; opt.TextSize = 13; opt.TextColor3 = NovaTheme:GetColor("TextPrimary")
                opt.MouseEnter:Connect(function() NovaAnim:CreateTween(opt, {BackgroundColor3 = NovaTheme:GetColor("SurfaceAlt")}, "Smooth", "Out", 0.15) end)
                opt.MouseLeave:Connect(function() NovaAnim:CreateTween(opt, {BackgroundColor3 = i == idx and NovaTheme:GetColor("Accent") or NovaTheme:GetColor("Surface")}, "Smooth", "Out", 0.15) end)
                opt.MouseButton1Click:Connect(function()
                    idx = i; sel.Text = item; list.Visible = false
                    if dOpts.Callback then pcall(dOpts.Callback, item, i) end
                    for _, o in ipairs(list:GetChildren()) do
                        if o:IsA("TextButton") then o.BackgroundColor3 = NovaTheme:GetColor("Surface") end
                    end
                    opt.BackgroundColor3 = NovaTheme:GetColor("Accent")
                end)
            end
            list.Size = UDim2.new(0, 120, 0, math.min(#(dOpts.Items or {}) * 32, 160))
            sel.MouseButton1Click:Connect(function()
                list.Visible = not list.Visible
                if list.Visible then list.Position = UDim2.new(0, sel.AbsolutePosition.X, 0, sel.AbsolutePosition.Y + 35) end
            end)
            UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and list.Visible then
                    local mp = Vector2.new(i.Position.X, i.Position.Y)
                    local ap = list.AbsolutePosition; local as = list.AbsoluteSize
                    local sap = sel.AbsolutePosition; local sas = sel.AbsoluteSize
                    if not (mp.X >= ap.X and mp.X <= ap.X + as.X and mp.Y >= ap.Y and mp.Y <= ap.Y + as.Y) and
                       not (mp.X >= sap.X and mp.X <= sap.X + sas.X and mp.Y >= sap.Y and mp.Y <= sap.Y + sas.Y) then
                        list.Visible = false
                    end
                end
            end)
            return sel
        end

        return secObj
    end

    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabCont:GetChildren()) do
            if b:IsA("TextButton") and b ~= btn then
                b.TextColor3 = NovaTheme:GetColor("TextMuted"); b.BackgroundTransparency = 1
            end
        end
        btn.TextColor3 = NovaTheme:GetColor("Accent")
        NovaAnim:CreateTween(btn, {BackgroundTransparency = 0.92}, "Smooth", "Out", 0.2)
        for _, s in ipairs(content:GetChildren()) do
            if s:IsA("ScrollingFrame") then s.Visible = false end
        end
        scroll.Visible = true
        local xOff = btn.AbsolutePosition.X - tabCont.AbsolutePosition.X
        local w = btn.AbsoluteSize.X
        NovaAnim:CreateTween(indicator, {Position = UDim2.new(0, xOff, 1, -2), Size = UDim2.new(0, w, 0, 2)}, "Smooth", "Out", 0.35)
    end)

    if #CurrentTabs == 0 then
        btn.TextColor3 = NovaTheme:GetColor("Accent")
        scroll.Visible = true
        indicator.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, 2)
    end

    table.insert(CurrentTabs, tabObj)
    return tabObj
end

-- =============================================================================
-- 📋 BUILD TABS
-- =============================================================================
local Tab1 = createTab("ESP", NovaTheme:GetColor("Accent"))
local S1 = Tab1:Section({Name = "ESP Settings", Description = "Visual enhancements"})
S1:Toggle({Name = "ESP Enabled", Default = CONFIG.ESP, Callback = function(v) CONFIG.ESP = v; saveCfg() end})
S1:Toggle({Name = "Team Colors", Default = CONFIG.TeamColor, Callback = function(v) CONFIG.TeamColor = v; saveCfg() end})
S1:Toggle({Name = "Box", Default = CONFIG.Box, Callback = function(v) CONFIG.Box = v; saveCfg() end})
S1:Toggle({Name = "Tracer", Default = CONFIG.Tracer, Callback = function(v) CONFIG.Tracer = v; saveCfg() end})
S1:Toggle({Name = "Skeleton", Default = CONFIG.Skeleton, Callback = function(v) CONFIG.Skeleton = v; saveCfg() end})
S1:Toggle({Name = "Hitbox", Default = CONFIG.Hitbox, Callback = function(v) CONFIG.Hitbox = v; saveCfg() end})

local Tab2 = createTab("Prediction", NovaTheme:GetColor("Success"))
local P1 = Tab2:Section({Name = "Ball Prediction", Description = "Trajectory forecast"})
P1:Toggle({Name = "Prediction", Default = CONFIG.Prediction, Callback = function(v) CONFIG.Prediction = v; saveCfg() end})
P1:Slider({Name = "Time Offset", Min = 1, Max = 20, Default = 5, Callback = function(v) CONFIG.PredictTime = v end})
P1:ColorPicker({Name = "Ray Color", Default = Color3.fromRGB(255, 200, 50), Callback = function(v) CONFIG.PredColor = v end})

local P2 = Tab2:Section({Name = "Ball Info"})
local posL = P2:Label({Text = "Position: searching..."})
local velL = P2:Label({Text = "Velocity: 0"})
local predL = P2:Label({Text = "Predicted: --"})

local Tab3 = createTab("Settings", NovaTheme:GetColor("Warning"))
local S3 = Tab3:Section({Name = "Configuration"})
S3:Button({Name = "Save Settings", Color = NovaTheme:GetColor("Success"), Callback = function() saveCfg(); Notifications:Send("Saved", "Settings saved!", 3, "success") end})
S3:Button({Name = "Load Settings", Color = NovaTheme:GetColor("Warning"), Callback = function() loadCfg(); Notifications:Send("Loaded", "Settings loaded!", 3, "success") end})
S3:Button({Name = "Refresh Game Data", Color = NovaTheme:GetColor("Accent"), Callback = function() Game:Update(); Notifications:Send("Refreshed", "Game state updated", 2, "success") end})

local T3 = Tab3:Section({Name = "Theme"})
T3:Dropdown({Name = "Theme", Items = NovaTheme:GetThemeList(), Default = "Default", Callback = function(v) NovaTheme:ApplyTheme(v) end})

local Tab4 = createTab("Utilities", NovaTheme:GetColor("Danger"))
local U1 = Tab4:Section({Name = "Tools"})
U1:Toggle({Name = "Fly Mode", Default = CONFIG.Fly, Callback = function(v) CONFIG.Fly = v; saveCfg() end})
U1:Button({Name = "Unlock Camera", Color = NovaTheme:GetColor("Warning"), Callback = function()
    pcall(function() LocalPlayer.CameraMinZoomDistance = 0.5; LocalPlayer.CameraMaxZoomDistance = math.huge end)
    Notifications:Send("Camera", "Zoom unlocked!", 2, "success")
end})
U1:Button({Name = "Teleport to Ball", Color = NovaTheme:GetColor("Accent"), Callback = function()
    if Game.Ball.Ref and Game.Ball.Ref.Parent and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        LocalPlayer.Character.PrimaryPart.CFrame = Game.Ball.Ref.CFrame * CFrame.new(0, 5, 0)
        Notifications:Send("Teleported", "Moved to ball", 2, "success")
    else Notifications:Send("Error", "Ball not found", 2, "error") end
end})
U1:Button({Name = "Respawn", Color = NovaTheme:GetColor("Danger"), Callback = function()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end})

-- Watermark
local wmGui = Instance.new("ScreenGui", CoreGui)
wmGui.Name = "CFH_WM"; wmGui.ResetOnSpawn = false; wmGui.IgnoreGuiInset = true
local wm = Instance.new("Frame", wmGui)
wm.Size = UDim2.new(0, 0, 0, 28); wm.Position = UDim2.new(0, 10, 0, 10)
wm.BackgroundColor3 = NovaTheme:GetColor("Surface"); wm.BackgroundTransparency = 0.15
wm.BorderSizePixel = 0; wm.AutomaticSize = Enum.AutomaticSize.X
NovaUtil:Corner(wm, 6); NovaUtil:Stroke(wm, NovaTheme:GetColor("Border"), 0.4, 1)
local dot = Instance.new("Frame", wm)
dot.Size = UDim2.new(0, 6, 0, 6); dot.Position = UDim2.new(0, 10, 0.5, -3)
dot.BackgroundColor3 = NovaTheme:GetColor("Accent"); dot.BorderSizePixel = 0
NovaUtil:Corner(dot, 3)
local wmT = Instance.new("TextLabel", wm)
wmT.Size = UDim2.new(0, 0, 1, 0); wmT.Position = UDim2.new(0, 22, 0, 0)
wmT.BackgroundTransparency = 1; wmT.Font = Enum.Font.GothamBold; wmT.TextSize = 13
wmT.Text = "CLASSIC FOOTBALL HUB"; wmT.TextColor3 = NovaTheme:GetColor("TextPrimary")
wmT.TextXAlignment = Enum.TextXAlignment.Left; wmT.TextYAlignment = Enum.TextYAlignment.Center
wmT.AutomaticSize = Enum.AutomaticSize.X
local wmF = Instance.new("TextLabel", wm)
wmF.Size = UDim2.new(0, 0, 1, 0); wmF.AutomaticSize = Enum.AutomaticSize.X
wmF.BackgroundTransparency = 1; wmF.Font = Enum.Font.Gotham; wmF.TextSize = 11
wmF.Text = "FPS: 0"; wmF.TextColor3 = NovaTheme:GetColor("Accent")
wmF.TextXAlignment = Enum.TextXAlignment.Left; wmF.TextYAlignment = Enum.TextYAlignment.Center
local wmP = Instance.new("TextLabel", wm)
wmP.Size = UDim2.new(0, 0, 1, 0); wmP.AutomaticSize = Enum.AutomaticSize.X
wmP.BackgroundTransparency = 1; wmP.Font = Enum.Font.Gotham; wmP.TextSize = 11
wmP.Text = "Ping: 0ms"; wmP.TextColor3 = NovaTheme:GetColor("TextMuted")
wmP.TextXAlignment = Enum.TextXAlignment.Left; wmP.TextYAlignment = Enum.TextYAlignment.Center

local WM = false
U1:Toggle({Name = "Watermark", Default = true, Callback = function(v) wmGui.Enabled = v; WM = v end})
wmGui.Enabled = true

-- =============================================================================
-- 🏁 MAIN LOOP
-- =============================================================================
Notifications:Send("Welcome", "Classic Football Hub v3.0 loaded!", 5, "success")

RunService.Heartbeat:Connect(function()
    Game.FrameCount = Game.FrameCount + 1
    local now = tick()
    if now - Game.FPSTimer >= 1 then
        Game.FPS = Game.FrameCount; Game.FrameCount = 0; Game.FPSTimer = now
    end
    Game.Ping = NetworkStats and NetworkStats:FindFirstChild("ServerPing") and NetworkStats.ServerPing.Value or 0
    Game:Update()
    if CONFIG.Fly and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
        local hrp = LocalPlayer.Character.PrimaryPart
        local mv = Vector3.new(
            (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0),
            (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0)
        )
        if mv.Magnitude > 0 then mv = mv.Unit * CONFIG.FlySpeed end
        hrp.Velocity = mv; hrp.AssemblyLinearVelocity = mv
    end
end)

RunService.RenderStepped:Connect(function()
    ESP:Draw()
    fpsL.Text = "FPS: " .. Game.FPS
    fpsL.TextColor3 = Game.FPS > 50 and NovaTheme:GetColor("Success") or Game.FPS > 25 and NovaTheme:GetColor("Warning") or NovaTheme:GetColor("Danger")
    pingL.Text = "Ping: " .. Game.Ping .. "ms"
    timeL.Text = os.date("%H:%M")
    wmF.Text = "FPS: " .. Game.FPS; wmP.Text = "Ping: " .. Game.Ping .. "ms"
    if Game.Ball.Ref and Game.Ball.Ref.Parent then
        posL.Text = "Position: " .. string.format("%.0f, %.0f, %.0f", Game.Ball.Pos.X, Game.Ball.Pos.Y, Game.Ball.Pos.Z)
        velL.Text = "Velocity: " .. string.format("%.1f", Game.Ball.Vel.Magnitude)
        if Game.Ball.Vel.Magnitude > 0.5 then
            local fp = Game.Ball.Pos + Game.Ball.Vel * CONFIG.PredictTime
            predL.Text = "Predicted: " .. string.format("%.0f, %.0f, %.0f", fp.X, fp.Y, fp.Z)
        else predL.Text = "Predicted: (ball stationary)" end
    end
end)

task.spawn(function() while true do task.wait(300); saveCfg() end end)

print("=== Classic Football Hub v3.0 loaded ===")
