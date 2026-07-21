-- Nova UI v1.0.0 - Single File Build
local NovaUI = {}

-- Utility
local Utility = {}

function Utility:Round(number, decimals)
	decimals = decimals or 0
	local mult = 10 ^ decimals
	return math.floor(number * mult + 0.5) / mult
end

function Utility:Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function Utility:Lerp(a, b, t)
	return a + (b - a) * t
end

function Utility:ColorLerp(a, b, t)
	return Color3.new(
		self:Lerp(a.R, b.R, t),
		self:Lerp(a.G, b.G, t),
		self:Lerp(a.B, b.B, t)
	)
end

function Utility:RGBToHex(color)
	return string.format("#%02X%02X%02X",
		math.floor(color.R * 255),
		math.floor(color.G * 255),
		math.floor(color.B * 255)
	)
end

function Utility:HexToRGB(hex)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255
	return Color3.new(r, g, b)
end

function Utility:DeepCopy(table)
	local copy = {}
	for k, v in pairs(table) do
		if type(v) == "table" then
			copy[k] = self:DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function Utility:MergeTables(...)
	local result = {}
	for _, tbl in ipairs({...}) do
		for k, v in pairs(tbl) do
			result[k] = v
		end
	end
	return result
end

function Utility:IsMouseOver(frame)
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local absPos = frame.AbsolutePosition
	local absSize = frame.AbsoluteSize
	return mouse.X >= absPos.X and mouse.X <= absPos.X + absSize.X
		and mouse.Y >= absPos.Y and mouse.Y <= absPos.Y + absSize.Y
end

function Utility:MakeDraggable(frame, dragArea, callback)
	dragArea = dragArea or frame
	local dragging = false
	local dragOffset = Vector2.new(0, 0)
	local userInput = game:GetService("UserInputService")
	local tweenService = game:GetService("TweenService")

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragOffset = Vector2.new(input.Position.X - frame.AbsolutePosition.X, input.Position.Y - frame.AbsolutePosition.Y)
		end
	end)

	userInput.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local newPos = UDim2.new(0, input.Position.X - dragOffset.X, 0, input.Position.Y - dragOffset.Y)
			frame.Position = newPos
			if callback then
				callback(newPos)
			end
		end
	end)

	userInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function Utility:CreateShadow(instance, transparency, size, color)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.BackgroundTransparency = 1
	shadow.BorderSizePixel = 0
	shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
	shadow.Position = UDim2.new(-0.5, -size, -0.5, -size)
	shadow.ZIndex = instance.ZIndex - 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = color or Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = transparency or 0.8
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.Parent = instance
	return shadow
end

function Utility:CreateCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 6)
	corner.Parent = instance
	return corner
end

function Utility:CreatePadding(instance, padding)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, padding or 8)
	pad.PaddingBottom = UDim.new(0, padding or 8)
	pad.PaddingLeft = UDim.new(0, padding or 8)
	pad.PaddingRight = UDim.new(0, padding or 8)
	pad.Parent = instance
	return pad
end

function Utility:CreateStroke(instance, color, transparency, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(35, 35, 42)
	stroke.Transparency = transparency or 0.5
	stroke.Thickness = thickness or 1
	stroke.Parent = instance
	return stroke
end

function Utility:CreateGradient(instance, color1, color2, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(20, 20, 24)),
		ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(26, 26, 32))
	})
	gradient.Rotation = rotation or 90
	gradient.Parent = instance
	return gradient
end

function Utility:CreateListLayout(instance, direction, padding, fillDirection)
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = direction or Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, padding or 4)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = instance
	return layout
end

function Utility:CreateScrollingFrame(parent, size, position, canvasSize)
	local sf = Instance.new("ScrollingFrame")
	sf.Size = size
	sf.Position = position
	sf.BackgroundTransparency = 1
	sf.BorderSizePixel = 0
	sf.ScrollBarThickness = 3
	sf.ScrollBarImageTransparency = 0.8
	sf.ScrollBarImageColor3 = Color3.fromRGB(79, 124, 255)
	sf.CanvasSize = canvasSize or UDim2.new(0, 0, 0, 0)
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sf.ScrollingDirection = Enum.ScrollingDirection.Y
	sf.ElasticBehavior = Enum.ElasticBehavior.Never
	sf.Parent = parent
	return sf
end

function Utility:Throttle(func, limit)
	local lastCall = 0
	return function(...)
		local now = tick()
		if now - lastCall >= limit then
			lastCall = now
			func(...)
		end
	end
end

function Utility:Debounce(func, delay)
	local lastCall = 0
	return function(...)
		local now = tick()
		if now - lastCall >= delay then
			lastCall = now
			func(...)
		end
	end
end

function Utility:CreateImageLabel(parent, image, size, position, color, transparency)
	local img = Instance.new("ImageLabel")
	img.Image = image
	img.Size = size
	img.Position = position
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
	img.ImageTransparency = transparency or 0
	img.Parent = parent
	return img
end

function Utility:CreateTextLabel(parent, text, size, position, font, textSize, color, transparency)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.Size = size
	label.Position = position
	label.Font = font or Enum.Font.Gotham
	label.TextSize = textSize or 14
	label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	label.TextTransparency = transparency or 0
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.RichText = true
	label.Parent = parent
	return label
end

function Utility:CreateInput(inputType, parent, size, position)
	local input = Instance.new("TextBox" or "TextButton")
	return input
end

function Utility:DestroyAllChildren(instance)
	for _, child in ipairs(instance:GetChildren()) do
		child:Destroy()
	end
end

function Utility:GetTextBounds(text, font, size)
	local tb = Instance.new("TextLabel")
	tb.Text = text
	tb.Font = font or Enum.Font.Gotham
	tb.TextSize = size or 14
	tb.TextTransparency = 1
	tb.Size = UDim2.new(0, 1000, 0, 50)
	local bounds = tb.TextBounds
	tb:Destroy()
	return bounds
end

function Utility:FormatTime(seconds)
	local mins = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", mins, secs)
end

function Utility:GenerateUID()
	return string.format("%x-%x-%x", math.random(0, 0xFFFF), math.random(0, 0xFFFF), math.random(0, 0xFFFF))
end

function Utility:GetRelativePosition(instance, ancestor)
	local pos = instance.AbsolutePosition
	local ancPos = ancestor.AbsolutePosition
	return Vector2.new(pos.X - ancPos.X, pos.Y - ancPos.Y)
end

NovaUI.Utility = Utility


-- ThemeManager
local ThemeManager = {}
ThemeManager.__index = ThemeManager

local DARK_BG = Color3.fromRGB(10, 10, 15)
local DARK_SURFACE = Color3.fromRGB(16, 16, 22)
local DARK_SURFACE_ALT = Color3.fromRGB(22, 22, 30)
local DARK_BORDER = Color3.fromRGB(30, 30, 42)
local DARK_BORDER_LIGHT = Color3.fromRGB(38, 38, 52)

local DEFAULT_PALETTE = {
	Background = DARK_BG,
	Surface = DARK_SURFACE,
	SurfaceAlt = DARK_SURFACE_ALT,
	Border = DARK_BORDER,
	BorderLight = DARK_BORDER_LIGHT,
	Accent = Color3.fromRGB(108, 92, 231),
	AccentSecondary = Color3.fromRGB(162, 108, 255),
	TextPrimary = Color3.fromRGB(230, 230, 245),
	TextSecondary = Color3.fromRGB(155, 155, 175),
	TextMuted = Color3.fromRGB(90, 90, 115),
	Success = Color3.fromRGB(0, 200, 117),
	Warning = Color3.fromRGB(255, 184, 76),
	Danger = Color3.fromRGB(255, 82, 82),
	Info = Color3.fromRGB(84, 160, 255),
	Overlay = Color3.fromRGB(0, 0, 0),
	Shadow = Color3.fromRGB(0, 0, 0),
	HeaderText = Color3.fromRGB(200, 200, 220),
	Divider = Color3.fromRGB(28, 28, 38),
	ToggleActive = Color3.fromRGB(108, 92, 231),
	ToggleInactive = Color3.fromRGB(38, 38, 50),
	InputBackground = Color3.fromRGB(18, 18, 26),
	ScrollBar = Color3.fromRGB(108, 92, 231),
}

local LIGHT_BG = Color3.fromRGB(245, 245, 250)
local LIGHT_SURFACE = Color3.fromRGB(255, 255, 255)
local LIGHT_SURFACE_ALT = Color3.fromRGB(238, 238, 245)
local LIGHT_BORDER = Color3.fromRGB(210, 210, 220)
local LIGHT_BORDER_LIGHT = Color3.fromRGB(220, 220, 230)

local LIGHT_PALETTE = {
	Background = LIGHT_BG,
	Surface = LIGHT_SURFACE,
	SurfaceAlt = LIGHT_SURFACE_ALT,
	Border = LIGHT_BORDER,
	BorderLight = LIGHT_BORDER_LIGHT,
	Accent = Color3.fromRGB(108, 92, 231),
	AccentSecondary = Color3.fromRGB(162, 108, 255),
	TextPrimary = Color3.fromRGB(20, 20, 35),
	TextSecondary = Color3.fromRGB(90, 90, 115),
	TextMuted = Color3.fromRGB(140, 140, 160),
	Success = Color3.fromRGB(0, 180, 100),
	Warning = Color3.fromRGB(230, 160, 50),
	Danger = Color3.fromRGB(230, 60, 60),
	Info = Color3.fromRGB(60, 140, 240),
	Overlay = Color3.fromRGB(0, 0, 0),
	Shadow = Color3.fromRGB(0, 0, 0),
	HeaderText = Color3.fromRGB(40, 40, 60),
	Divider = Color3.fromRGB(210, 210, 220),
	ToggleActive = Color3.fromRGB(108, 92, 231),
	ToggleInactive = Color3.fromRGB(180, 180, 195),
	InputBackground = Color3.fromRGB(232, 232, 240),
	ScrollBar = Color3.fromRGB(108, 92, 231),
}

local DARK_THEMES = {
	Default = DEFAULT_PALETTE,
	Amethyst = {
		Background = Color3.fromRGB(10, 10, 18),
		Surface = Color3.fromRGB(16, 16, 26),
		SurfaceAlt = Color3.fromRGB(22, 22, 34),
		Border = Color3.fromRGB(35, 30, 45),
		BorderLight = Color3.fromRGB(42, 38, 55),
		Accent = Color3.fromRGB(156, 101, 217),
		AccentSecondary = Color3.fromRGB(217, 101, 189),
		TextPrimary = Color3.fromRGB(230, 230, 245),
		TextSecondary = Color3.fromRGB(155, 155, 176),
		TextMuted = Color3.fromRGB(95, 90, 115),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(156, 101, 217),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(200, 200, 220),
		Divider = Color3.fromRGB(28, 28, 42),
		ToggleActive = Color3.fromRGB(156, 101, 217),
		ToggleInactive = Color3.fromRGB(38, 38, 52),
		InputBackground = Color3.fromRGB(18, 18, 28),
		ScrollBar = Color3.fromRGB(156, 101, 217),
	},
	Emerald = {
		Background = Color3.fromRGB(10, 14, 10),
		Surface = Color3.fromRGB(16, 22, 16),
		SurfaceAlt = Color3.fromRGB(22, 30, 22),
		Border = Color3.fromRGB(30, 42, 30),
		BorderLight = Color3.fromRGB(38, 52, 38),
		Accent = Color3.fromRGB(38, 185, 128),
		AccentSecondary = Color3.fromRGB(38, 128, 185),
		TextPrimary = Color3.fromRGB(230, 245, 230),
		TextSecondary = Color3.fromRGB(155, 176, 155),
		TextMuted = Color3.fromRGB(90, 115, 90),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(38, 185, 128),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(200, 220, 200),
		Divider = Color3.fromRGB(28, 42, 28),
		ToggleActive = Color3.fromRGB(38, 185, 128),
		ToggleInactive = Color3.fromRGB(38, 52, 38),
		InputBackground = Color3.fromRGB(18, 26, 18),
		ScrollBar = Color3.fromRGB(38, 185, 128),
	},
	Ruby = {
		Background = Color3.fromRGB(18, 10, 10),
		Surface = Color3.fromRGB(26, 16, 16),
		SurfaceAlt = Color3.fromRGB(34, 22, 22),
		Border = Color3.fromRGB(45, 30, 30),
		BorderLight = Color3.fromRGB(55, 38, 38),
		Accent = Color3.fromRGB(217, 65, 65),
		AccentSecondary = Color3.fromRGB(185, 65, 101),
		TextPrimary = Color3.fromRGB(245, 230, 230),
		TextSecondary = Color3.fromRGB(176, 155, 155),
		TextMuted = Color3.fromRGB(115, 90, 90),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(217, 65, 65),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(220, 200, 200),
		Divider = Color3.fromRGB(42, 28, 28),
		ToggleActive = Color3.fromRGB(217, 65, 65),
		ToggleInactive = Color3.fromRGB(52, 38, 38),
		InputBackground = Color3.fromRGB(26, 18, 18),
		ScrollBar = Color3.fromRGB(217, 65, 65),
	},
	Sapphire = {
		Background = Color3.fromRGB(10, 10, 18),
		Surface = Color3.fromRGB(16, 16, 26),
		SurfaceAlt = Color3.fromRGB(22, 22, 34),
		Border = Color3.fromRGB(30, 30, 45),
		BorderLight = Color3.fromRGB(38, 38, 55),
		Accent = Color3.fromRGB(45, 156, 219),
		AccentSecondary = Color3.fromRGB(45, 101, 219),
		TextPrimary = Color3.fromRGB(230, 230, 245),
		TextSecondary = Color3.fromRGB(155, 155, 176),
		TextMuted = Color3.fromRGB(90, 95, 115),
		Success = Color3.fromRGB(76, 175, 132),
		Warning = Color3.fromRGB(255, 184, 76),
		Danger = Color3.fromRGB(255, 107, 107),
		Info = Color3.fromRGB(45, 156, 219),
		Overlay = Color3.fromRGB(0, 0, 0),
		Shadow = Color3.fromRGB(0, 0, 0),
		HeaderText = Color3.fromRGB(200, 200, 220),
		Divider = Color3.fromRGB(28, 28, 42),
		ToggleActive = Color3.fromRGB(45, 156, 219),
		ToggleInactive = Color3.fromRGB(38, 38, 52),
		InputBackground = Color3.fromRGB(18, 18, 28),
		ScrollBar = Color3.fromRGB(45, 156, 219),
	},
}

local LIGHT_THEMES = {
	Default = LIGHT_PALETTE,
}

ThemeManager.CurrentTheme = "Default"
ThemeManager.CurrentPalette = {}
ThemeManager.CustomPalettes = {}
ThemeManager.Listeners = {}
ThemeManager.AnimateOnChange = true
ThemeManager.IsDark = true

function ThemeManager:GetColor(key)
	local palette = self.CurrentPalette
	if palette and palette[key] then
		return palette[key]
	end
	return DEFAULT_PALETTE[key] or Color3.fromRGB(255, 255, 255)
end

function ThemeManager:GetThemeList()
	local list = {}
	for name in DARK_THEMES do
		table.insert(list, name)
	end
	for name in LIGHT_THEMES do
		table.insert(list, name)
	end
	for name in self.CustomPalettes do
		table.insert(list, name)
	end
	return list
end

function ThemeManager:AddTheme(name, palette)
	palette = palette or {}
	for k, v in DEFAULT_PALETTE do
		if palette[k] == nil then
			palette[k] = v
		end
	end
	self.CustomPalettes[name] = palette
	if self.CurrentTheme == name then
		self:ApplyTheme(name)
	end
end

function ThemeManager:ApplyTheme(name)
	local palette = DARK_THEMES[name] or LIGHT_THEMES[name] or self.CustomPalettes[name]
	if not palette then
		return
	end
	self.CurrentTheme = name
	self.CurrentPalette = palette
	self.IsDark = (DARK_THEMES[name] ~= nil)
	self:NotifyListeners()
end

function ThemeManager:SetAccent(color)
	self.CurrentPalette.Accent = color
	self:NotifyListeners()
end

function ThemeManager:SetAnimateOnChange(state)
	self.AnimateOnChange = state
end

function ThemeManager:OnChange(callback)
	table.insert(self.Listeners, callback)
	return function()
		for i, cb in ipairs(self.Listeners) do
			if cb == callback then
				table.remove(self.Listeners, i)
				break
			end
		end
	end
end

function ThemeManager:NotifyListeners()
	for _, callback in self.Listeners do
		pcall(callback, self.CurrentPalette, self.AnimateOnChange)
	end
end

NovaUI.ThemeManager = ThemeManager


-- AnimationManager
local TweenService = game:GetService("TweenService")

local AnimationManager = {}
AnimationManager.__index = AnimationManager

local TWEEN_POOL = {}
local POOL_LIMIT = 50
local ACTIVE_TWEENS = {}

local EASING_STYLES = {
	Smooth = Enum.EasingStyle.Quad,
	Bouncy = Enum.EasingStyle.Back,
	Sharp = Enum.EasingStyle.Exponential,
	Soft = Enum.EasingStyle.Sine,
	Elastic = Enum.EasingStyle.Elastic,
}

local EASING_DIRECTIONS = {
	In = Enum.EasingDirection.In,
	Out = Enum.EasingDirection.Out,
	InOut = Enum.EasingDirection.InOut,
}

function AnimationManager:GetTweenInfo(style, direction, duration)
	style = EASING_STYLES[style] or EASING_STYLES.Smooth
	direction = EASING_DIRECTIONS[direction] or EASING_DIRECTIONS.Out
	duration = duration or 0.3
	return TweenInfo.new(duration, style, direction)
end

function AnimationManager:CreateTween(instance, properties, style, direction, duration, callback)
	local tweenInfo = self:GetTweenInfo(style, direction, duration)

	if instance and ACTIVE_TWEENS[instance] then
		ACTIVE_TWEENS[instance]:Cancel()
		ACTIVE_TWEENS[instance] = nil
	end

	local tween = TweenService:Create(instance, tweenInfo, properties)

	if callback then
		tween.Completed:Connect(callback)
	end

	ACTIVE_TWEENS[instance] = tween

	tween:Play()

	return tween
end

function AnimationManager:CancelTween(instance)
	if instance and ACTIVE_TWEENS[instance] then
		ACTIVE_TWEENS[instance]:Cancel()
		ACTIVE_TWEENS[instance] = nil
	end
end

function AnimationManager:CancelAll()
	for instance, tween in ACTIVE_TWEENS do
		tween:Cancel()
	end
	ACTIVE_TWEENS = {}
end

function AnimationManager:AnimateProperty(instance, property, targetValue, style, direction, duration)
	local props = {}
	props[property] = targetValue
	return self:CreateTween(instance, props, style, direction, duration)
end

function AnimationManager:FadeIn(instance, duration, style, direction)
	instance.Visible = true
	return self:AnimateProperty(instance, "BackgroundTransparency", 0, style or "Soft", direction or "Out", duration or 0.3)
end

function AnimationManager:FadeOut(instance, duration, style, direction, onComplete)
	local tween = self:CreateTween(instance, {
		BackgroundTransparency = 1
	}, style or "Soft", direction or "In", duration or 0.2, function()
		instance.Visible = false
		if onComplete then
			onComplete()
		end
	end)
	return tween
end

function AnimationManager:ScaleIn(instance, duration, style, direction)
	instance.Visible = true
	instance.Size = UDim2.new(0, 0, 0, 0)
	return self:CreateTween(instance, {
		Size = instance:FindFirstChild("_TargetSize") and instance._TargetSize.Value or instance.Size
	}, style or "Smooth", direction or "Out", duration or 0.3)
end

function AnimationManager:HoverEffect(instance, scaleAmount, glowIntensity)
	local originalSize = instance.Size
	local connection

	connection = instance.MouseEnter:Connect(function()
		self:CreateTween(instance, {
			Size = UDim2.new(
				originalSize.X.Scale * scaleAmount,
				originalSize.X.Offset * scaleAmount,
				originalSize.Y.Scale * scaleAmount,
				originalSize.Y.Offset * scaleAmount
			)
		}, "Smooth", "Out", 0.15)
	end)

	instance.MouseLeave:Connect(function()
		self:CreateTween(instance, originalSize, "Smooth", "Out", 0.15)
	end)

	return connection
end

function AnimationManager:PressEffect(instance, scaleAmount)
	self:CreateTween(instance, {
		Size = UDim2.new(
			instance.Size.X.Scale * scaleAmount,
			instance.Size.X.Offset,
			instance.Size.Y.Scale * scaleAmount,
			instance.Size.Y.Offset
		)
	}, "Sharp", "In", 0.08, function()
		self:CreateTween(instance, {
			Size = instance:FindFirstChild("_OriginalSize") and instance._OriginalSize.Value or instance.Size
		}, "Elastic", "Out", 0.25)
	end)
end

function AnimationManager:SlideIn(instance, direction, offset, duration, style)
	local originalPosition = instance.Position
	local startPosition

	if direction == "Left" then
		startPosition = originalPosition + UDim2.new(0, -offset, 0, 0)
	elseif direction == "Right" then
		startPosition = originalPosition + UDim2.new(0, offset, 0, 0)
	elseif direction == "Up" then
		startPosition = originalPosition + UDim2.new(0, 0, 0, -offset)
	elseif direction == "Down" then
		startPosition = originalPosition + UDim2.new(0, 0, 0, offset)
	end

	instance.Position = startPosition
	instance.Visible = true

	self:CreateTween(instance, {
		Position = originalPosition
	}, style or "Smooth", "Out", duration or 0.35)
end

function AnimationManager:SlideOut(instance, direction, offset, duration, style, onComplete)
	local targetPosition

	if direction == "Left" then
		targetPosition = instance.Position + UDim2.new(0, -offset, 0, 0)
	elseif direction == "Right" then
		targetPosition = instance.Position + UDim2.new(0, offset, 0, 0)
	elseif direction == "Up" then
		targetPosition = instance.Position + UDim2.new(0, 0, 0, -offset)
	elseif direction == "Down" then
		targetPosition = instance.Position + UDim2.new(0, 0, 0, offset)
	end

	self:CreateTween(instance, {
		Position = targetPosition
	}, style or "Smooth", "In", duration or 0.25, function()
		instance.Visible = false
		if onComplete then
			onComplete()
		end
	end)
end

function AnimationManager:RippleEffect(button, color, duration)
	local ripple = Instance.new("Frame")
	ripple.Name = "Ripple"
	ripple.BackgroundColor3 = color or Color3.fromRGB(255, 255, 255)
	ripple.BackgroundTransparency = 0.8
	ripple.BorderSizePixel = 0
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.Size = UDim2.new(0, 0, 0, 0)
	ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
	ripple.ZIndex = 10

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = ripple

	ripple.Parent = button

	local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 1.5

	local tween = self:CreateTween(ripple, {
		Size = UDim2.new(0, maxSize, 0, maxSize),
		BackgroundTransparency = 1
	}, "Smooth", "Out", duration or 0.5, function()
		ripple:Destroy()
	end)

	return tween
end

function AnimationManager:GlowEffect(frame, color, intensity, duration)
	local glow = Instance.new("Frame")
	glow.Name = "Glow"
	glow.BackgroundColor3 = color or Color3.fromRGB(79, 124, 255)
	glow.BackgroundTransparency = 1
	glow.BorderSizePixel = 0
	glow.Size = UDim2.new(1, 20, 1, 20)
	glow.Position = UDim2.new(-0.5, -10, -0.5, -10)
	glow.ZIndex = frame.ZIndex - 1
	glow.Visible = false

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = glow

	glow.Parent = frame

	-- glow uses image transparency fallback (BlurEffect only works in Lighting)

	frame.MouseEnter:Connect(function()
		glow.Visible = true
		self:CreateTween(glow, {
			BackgroundTransparency = 0.7
		}, "Soft", "Out", 0.2)
	end)

	frame.MouseLeave:Connect(function()
		self:CreateTween(glow, {
			BackgroundTransparency = 1
		}, "Soft", "Out", 0.3, function()
			glow.Visible = false
		end)
	end)
end

function AnimationManager:Rotate(instance, angle, duration, style)
	local currentRotation = instance.Rotation or 0
	self:CreateTween(instance, {
		Rotation = currentRotation + angle
	}, style or "Smooth", "Out", duration or 0.3)
end

NovaUI.AnimationManager = AnimationManager


-- IconManager
local IconManager = {}

local ICONS = {
	Home = "rbxassetid://6031394888",
	Settings = "rbxassetid://6031408139",
	User = "rbxassetid://6031391086",
	Close = "rbxassetid://6031402747",
	Minimize = "rbxassetid://6031398099",
	Maximize = "rbxassetid://6031404249",
	Plus = "rbxassetid://6031401098",
	Minus = "rbxassetid://6031397225",
	Check = "rbxassetid://6031395585",
	Cross = "rbxassetid://6031402747",
	ArrowLeft = "rbxassetid://6031392802",
	ArrowRight = "rbxassetid://6031394514",
	ArrowUp = "rbxassetid://6031395208",
	ArrowDown = "rbxassetid://6031393544",
	Search = "rbxassetid://6031405476",
	Bell = "rbxassetid://6031406619",
	Info = "rbxassetid://6031409671",
	Warning = "rbxassetid://6031391894",
	Error = "rbxassetid://6031407286",
	Success = "rbxassetid://6031396423",
	Edit = "rbxassetid://6031408643",
	Trash = "rbxassetid://6031390505",
	Copy = "rbxassetid://6031401098",
	Menu = "rbxassetid://6031399646",
	More = "rbxassetid://6031403185",
	Refresh = "rbxassetid://6031401758",
	Lock = "rbxassetid://6031398138",
	Unlock = "rbxassetid://6031390474",
	Eye = "rbxassetid://6031409356",
	EyeOff = "rbxassetid://6031390950",
	Download = "rbxassetid://6031407617",
	Upload = "rbxassetid://6031391086",
	Folder = "rbxassetid://6031405912",
	File = "rbxassetid://6031408374",
	Play = "rbxassetid://6031401098",
	Pause = "rbxassetid://6031404249",
	Stop = "rbxassetid://6031402747",
	Music = "rbxassetid://6031399646",
	Image = "rbxassetid://6031403185",
	Video = "rbxassetid://6031390505",
	Star = "rbxassetid://6031406619",
	Heart = "rbxassetid://6031409671",
	Flag = "rbxassetid://6031391894",
	Tag = "rbxassetid://6031407286",
	Bookmark = "rbxassetid://6031396423",
	Share = "rbxassetid://6031408643",
	Link = "rbxassetid://6031392802",
	Map = "rbxassetid://6031394514",
	Camera = "rbxassetid://6031395208",
	Clock = "rbxassetid://6031393544",
	Calendar = "rbxassetid://6031405476",
	Gift = "rbxassetid://6031406619",
	Chart = "rbxassetid://6031409671",
	Terminal = "rbxassetid://6031394888",
	Palette = "rbxassetid://6031408139",
	Sliders = "rbxassetid://6031401098",
	Grid = "rbxassetid://6031397225",
	List = "rbxassetid://6031395585",
	Circle = "rbxassetid://6031402747",
	Square = "rbxassetid://6031404249",
	Triangle = "rbxassetid://6031391086",
	Shield = "rbxassetid://6031390505",
	Bolt = "rbxassetid://6031396423",
	Fire = "rbxassetid://6031408643",
	Water = "rbxassetid://6031401758",
	Wind = "rbxassetid://6031398138",
	Earth = "rbxassetid://6031390474",
	PlusCircle = "rbxassetid://6031409356",
	MinusCircle = "rbxassetid://6031390950",
	QuestionCircle = "rbxassetid://6031407617",
	ExclamationCircle = "rbxassetid://6031391086",
	ChevronLeft = "rbxassetid://6031392802",
	ChevronRight = "rbxassetid://6031394514",
	ChevronUp = "rbxassetid://6031395208",
	ChevronDown = "rbxassetid://6031393544",
	ChevronLeftDouble = "rbxassetid://6031405476",
	ChevronRightDouble = "rbxassetid://6031406619",
	Empty = "",
}

local CUSTOM_ICONS = {}

function IconManager:GetIcon(name)
	if name == nil or name == "" then
		return ""
	end
	local icon = ICONS[name]
	if icon then
		return icon
	end
	icon = CUSTOM_ICONS[name]
	if icon then
		return icon
	end
	return ""
end

function IconManager:RegisterIcon(name, assetId)
	CUSTOM_ICONS[name] = assetId
end

function IconManager:RegisterIcons(iconTable)
	for name, assetId in iconTable do
		self:RegisterIcon(name, assetId)
	end
end

function IconManager:HasIcon(name)
	return ICONS[name] ~= nil or CUSTOM_ICONS[name] ~= nil
end

function IconManager:GetAllIconNames()
	local names = {}
	for name in ICONS do
		table.insert(names, name)
	end
	for name in CUSTOM_ICONS do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function IconManager:CreateIconLabel(parent, iconName, size, color, transparency)
	local assetId = self:GetIcon(iconName)
	if assetId == "" then
		return nil
	end
	local img = Instance.new("ImageLabel")
	img.Image = assetId
	img.Size = size or UDim2.new(0, 20, 0, 20)
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
	img.ImageTransparency = transparency or 0
	img.Parent = parent
	return img
end

function IconManager:SetIcon(imageLabel, iconName)
	local assetId = self:GetIcon(iconName)
	if assetId ~= "" and imageLabel then
		imageLabel.Image = assetId
	end
end

function IconManager:ClearCustomIcons()
	CUSTOM_ICONS = {}
end

NovaUI.IconManager = IconManager


-- SoundManager
local SoundManager = {}
SoundManager.__index = SoundManager

local SOUNDS = {
	Hover = "rbxassetid://9120385726",
	Click = "rbxassetid://9120386667",
	Success = "rbxassetid://9120389271",
	Error = "rbxassetid://9120388158",
	Notification = "rbxassetid://9120387472",
	ToggleOn = "rbxassetid://9120388878",
	ToggleOff = "rbxassetid://9120389634",
	TabSwitch = "rbxassetid://9120386710",
	Open = "rbxassetid://9120388320",
	Close = "rbxassetid://9120388271",
	Slider = "rbxassetid://9120388934",
	Dropdown = "rbxassetid://9120388320",
}

local SoundService = game:GetService("SoundService")

SoundManager.Enabled = true
SoundManager.Volume = 0.5
SoundManager.SoundGroup = nil

function SoundManager:Init()
	if not self.SoundGroup then
		self.SoundGroup = Instance.new("SoundGroup")
		self.SoundGroup.Name = "UILibrarySounds"
		self.SoundGroup.Volume = self.Volume
		self.SoundGroup.Parent = SoundService
	end
end

function SoundManager:Play(soundName)
	if not self.Enabled then
		return nil
	end

	local assetId = SOUNDS[soundName]
	if not assetId then
		return nil
	end

	self:Init()

	local sound = Instance.new("Sound")
	sound.SoundId = assetId
	sound.Volume = self.Volume
	sound.SoundGroup = self.SoundGroup
	sound.Parent = SoundService

	sound:Play()

	sound.Ended:Connect(function()
		sound:Destroy()
	end)

	return sound
end

function SoundManager:SetVolume(volume)
	self.Volume = math.clamp(volume, 0, 1)
	if self.SoundGroup then
		self.SoundGroup.Volume = self.Volume
	end
end

function SoundManager:SetEnabled(enabled)
	self.Enabled = enabled
	if not enabled and self.SoundGroup then
		self.SoundGroup.Volume = 0
	elseif enabled and self.SoundGroup then
		self.SoundGroup.Volume = self.Volume
	end
end

function SoundManager:Toggle()
	self:SetEnabled(not self.Enabled)
end

function SoundManager:RegisterSound(name, assetId)
	SOUNDS[name] = assetId
end

function SoundManager:GetSoundNames()
	local names = {}
	for name in SOUNDS do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function SoundManager:PlayHover()
	return self:Play("Hover")
end

function SoundManager:PlayClick()
	return self:Play("Click")
end

function SoundManager:PlaySuccess()
	return self:Play("Success")
end

function SoundManager:PlayError()
	return self:Play("Error")
end

function SoundManager:PlayNotification()
	return self:Play("Notification")
end

function SoundManager:PlayToggle()
	return self:Play("ToggleOn")
end

function SoundManager:Cleanup()
	if self.SoundGroup then
		self.SoundGroup:Destroy()
		self.SoundGroup = nil
	end
end

NovaUI.SoundManager = SoundManager


-- ConfigService
local ConfigService = {}
ConfigService.__index = ConfigService

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local DEFAULT_CONFIG = {
	Theme = "Default",
	Accent = nil,
	Sounds = true,
	Volume = 0.5,
	Scale = 1,
	Minimized = false,
	Position = nil,
	Size = nil,
	CustomData = {},
}

function ConfigService:Init(options)
	options = options or {}
	self.ConfigName = options.ConfigName or "UI_Library_Config"
	self.AutoSaveInterval = options.AutoSaveInterval or 60
	self.AutoSaveEnabled = options.AutoSaveEnabled or false
	self.CurrentConfig = self:Load() or self:DeepCopy(DEFAULT_CONFIG)

	if self.AutoSaveEnabled then
		self:StartAutoSave()
	end

	return self
end

function ConfigService:GetConfigPath()
	return string.format("%s/%s.json", Player.UserId, self.ConfigName)
end

function ConfigService:Save()
	local success, err = pcall(function()
		local data = HttpService:JSONEncode(self.CurrentConfig)
		writefile(self:GetConfigPath(), data)
	end)
	return success
end

function ConfigService:Load()
	local success, data = pcall(function()
		return readfile(self:GetConfigPath())
	end)
	if success and data then
		local decoded = HttpService:JSONDecode(data)
		self.CurrentConfig = self:MergeConfigs(DEFAULT_CONFIG, decoded)
		return self.CurrentConfig
	end
	return nil
end

function ConfigService:Get(key, defaultValue)
	if self.CurrentConfig[key] ~= nil then
		return self.CurrentConfig[key]
	end
	return defaultValue
end

function ConfigService:Set(key, value)
	self.CurrentConfig[key] = value
	self:Save()
end

function ConfigService:GetCustom(key, defaultValue)
	local custom = self.CurrentConfig.CustomData or {}
	if custom[key] ~= nil then
		return custom[key]
	end
	return defaultValue
end

function ConfigService:SetCustom(key, value)
	if not self.CurrentConfig.CustomData then
		self.CurrentConfig.CustomData = {}
	end
	self.CurrentConfig.CustomData[key] = value
	self:Save()
end

function ConfigService:Reset()
	self.CurrentConfig = self:DeepCopy(DEFAULT_CONFIG)
	self:Save()
end

function ConfigService:ResetSection(section)
	if section == "CustomData" then
		self.CurrentConfig.CustomData = {}
	else
		self.CurrentConfig[section] = DEFAULT_CONFIG[section]
	end
	self:Save()
end

function ConfigService:Export()
	return HttpService:JSONEncode(self.CurrentConfig)
end

function ConfigService:Import(jsonString)
	local success, data = pcall(function()
		return HttpService:JSONDecode(jsonString)
	end)
	if success then
		self.CurrentConfig = self:MergeConfigs(DEFAULT_CONFIG, data)
		self:Save()
		return true
	end
	return false
end

function ConfigService:StartAutoSave()
	if self._autoSaveThread then
		self._autoSaveThread:Disconnect()
	end

	while self.AutoSaveEnabled do
		task.wait(self.AutoSaveInterval)
		self:Save()
	end
end

function ConfigService:SetAutoSaveInterval(seconds)
	self.AutoSaveInterval = seconds
end

function ConfigService:DeepCopy(tbl)
	local copy = {}
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			copy[k] = self:DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function ConfigService:MergeConfigs(defaults, overrides)
	local result = self:DeepCopy(defaults)
	for k, v in pairs(overrides) do
		if type(v) == "table" and type(result[k]) == "table" then
			result[k] = self:MergeConfigs(result[k], v)
		else
			result[k] = v
		end
	end
	return result
end

function ConfigService:OnConfigChanged(callback)
	self._onChanged = callback
end

function ConfigService:Destroy()
	if self._autoSaveThread then
		self._autoSaveThread:Disconnect()
		self._autoSaveThread = nil
	end
	self.CurrentConfig = nil
end

NovaUI.ConfigService = ConfigService


-- DragService
local DragService = {}
DragService.__index = DragService

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

local ACTIVE_DRAGS = {}

function DragService:MakeDraggable(frame, dragHandle, options)
	options = options or {}

	local snapToEdge = options.SnapToEdge or false
	local edgeMargin = options.EdgeMargin or 10
	local bounds = options.Bounds or nil
	local onDragStart = options.OnDragStart or nil
	local onDragEnd = options.OnDragEnd or nil
	local onDrag = options.OnDrag or nil
	local constrainToScreen = options.ConstrainToScreen or true
	local smoothDrag = options.SmoothDrag or false

	dragHandle = dragHandle or frame

	local dragging = false
	local dragOffset = Vector2.new(0, 0)
	local dragStartPos = UDim2.new(0, 0, 0, 0)
	local screenSize = workspace.CurrentCamera.ViewportSize

	local dragData = {
		Frame = frame,
		Dragging = false,
		Offset = Vector2.new(0, 0),
	}

	ACTIVE_DRAGS[frame] = dragData

	local connection1 = dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragOffset = Vector2.new(Mouse.X - frame.AbsolutePosition.X, Mouse.Y - frame.AbsolutePosition.Y)
			dragStartPos = frame.Position

			if dragData.SmoothTween then
				dragData.SmoothTween:Cancel()
				dragData.SmoothTween = nil
			end

			if onDragStart then
				onDragStart()
			end
		end
	end)

	local connection2 = UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local newX = Mouse.X - dragOffset.X
			local newY = Mouse.Y - dragOffset.Y

			if constrainToScreen then
				screenSize = workspace.CurrentCamera.ViewportSize
				newX = math.clamp(newX, 0, screenSize.X - frame.AbsoluteSize.X)
				newY = math.clamp(newY, 0, screenSize.Y - frame.AbsoluteSize.Y)
			end

			if snapToEdge then
				screenSize = workspace.CurrentCamera.ViewportSize
				local frameWidth = frame.AbsoluteSize.X
				local frameHeight = frame.AbsoluteSize.Y
				if math.abs(newX) < edgeMargin then
					newX = 0
				elseif math.abs(newX + frameWidth - screenSize.X) < edgeMargin then
					newX = screenSize.X - frameWidth
				end
				if math.abs(newY) < edgeMargin then
					newY = 0
				elseif math.abs(newY + frameHeight - screenSize.Y) < edgeMargin then
					newY = screenSize.Y - frameHeight
				end
			end

			if smoothDrag then
				if dragData.SmoothTween then
					dragData.SmoothTween:Cancel()
				end
				dragData.SmoothTween = TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(0, newX, 0, newY)
				})
				dragData.SmoothTween:Play()
			else
				frame.Position = UDim2.new(0, newX, 0, newY)
			end

			if onDrag then
				onDrag(frame.Position)
			end

			dragData.LastPosition = frame.Position
		end
	end)

	local connection3 = UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false

			if dragData.SmoothTween then
				dragData.SmoothTween:Cancel()
				dragData.SmoothTween = nil
			end

			if onDragEnd then
				onDragEnd(frame.Position)
			end
		end
	end)

	return {
		Disconnect = function()
			connection1:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
			ACTIVE_DRAGS[frame] = nil
		end,
		SetDraggable = function(enabled)
			dragging = false
		end
	}
end

function DragService:MakeResizable(frame, options)
	options = options or {}
	local minSize = options.MinSize or Vector2.new(300, 200)
	local maxSize = options.MaxSize or Vector2.new(2000, 1500)
	local handles = options.Handles or {}

	local resizeData = {
		Frame = frame,
		Resizing = false,
		Edge = nil,
		StartSize = Vector2.new(0, 0),
		StartPos = Vector2.new(0, 0),
		MouseStart = Vector2.new(0, 0),
	}

	local function createHandle(edgeName, cursor, position, size)
		local handle = Instance.new("Frame")
		handle.Name = "ResizeHandle_" .. edgeName
		handle.BackgroundTransparency = 1
		handle.BorderSizePixel = 0
		handle.Size = size or UDim2.new(0, 6, 0, 6)
		handle.Position = position or UDim2.new(0, 0, 0, 0)
		handle.ZIndex = 1000
		handle.Parent = frame

		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizeData.Resizing = true
				resizeData.Edge = edgeName
				resizeData.StartSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
				resizeData.StartPos = Vector2.new(frame.AbsolutePosition.X, frame.AbsolutePosition.Y)
				resizeData.MouseStart = Vector2.new(Mouse.X, Mouse.Y)
			end
		end)

		return handle
	end

	createHandle("BottomRight", "sizing", UDim2.new(1, -3, 1, -3))
	createHandle("Bottom", "sizens", UDim2.new(0.5, -3, 1, -3), UDim2.new(0, 6, 1, 0))
	createHandle("Right", "sizewe", UDim2.new(1, -3, 0.5, -3), UDim2.new(1, 0, 0, 6))

	UserInputService.InputChanged:Connect(function(input)
		if resizeData.Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = Vector2.new(Mouse.X - resizeData.MouseStart.X, Mouse.Y - resizeData.MouseStart.Y)
			local newSize = resizeData.StartSize
			local newPos = resizeData.StartPos

			if resizeData.Edge == "BottomRight" or resizeData.Edge == "Right" then
				newSize = Vector2.new(math.clamp(resizeData.StartSize.X + delta.X, minSize.X, maxSize.X), newSize.Y)
			end
			if resizeData.Edge == "BottomRight" or resizeData.Edge == "Bottom" then
				newSize = Vector2.new(newSize.X, math.clamp(resizeData.StartSize.Y + delta.Y, minSize.Y, maxSize.Y))
			end

			frame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if resizeData.Resizing and input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizeData.Resizing = false
			resizeData.Edge = nil
		end
	end)
end

function DragService:StopDrag(frame)
	if ACTIVE_DRAGS[frame] then
		ACTIVE_DRAGS[frame] = nil
	end
end

function DragService:Cleanup()
	for frame, data in ACTIVE_DRAGS do
		if data.Disconnect then
			data:Disconnect()
		end
	end
	ACTIVE_DRAGS = {}
end

NovaUI.DragService = DragService


-- Window
local Window = {}
Window.__index = Window

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player and Player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")








local Windows = {}

function Window:New(options)
	options = options or {}

	local self = setmetatable({}, Window)

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_UI"
	screenGui.DisplayOrder = 10
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	screenGui.Parent = findParent()

	self.ScreenGui = screenGui
	self.Options = options
	self.Title = options.Title or "Nova UI"
	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
	local defaultW = math.min(680, viewport.X - 40)
	local defaultH = math.min(480, viewport.Y - 60)
	self.Size = options.Size or UDim2.new(0, defaultW, 0, defaultH)
	self.Position = options.Position or UDim2.new(0.5, -defaultW / 2, 0.5, -defaultH / 2)
	self.MinSize = options.MinSize or Vector2.new(400, 320)
	self.Theme = options.Theme or "Default"
	self.Icon = options.Icon or nil
	self.Resizable = options.Resizable or false
	self.ShowFPS = options.ShowFPS or false
	self.SidebarWidth = options.SidebarWidth or 50
	self._minimized = false
	self._maximized = false
	self._previousSize = nil
	self._previousPosition = nil
	self.Tabs = {}
	self._currentTab = nil

	local modalBackdrop = Instance.new("Frame")
	modalBackdrop.Name = "ModalBackdrop"
	modalBackdrop.Size = UDim2.new(1, 0, 1, 0)
	modalBackdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	modalBackdrop.BackgroundTransparency = 1
	modalBackdrop.BorderSizePixel = 0
	modalBackdrop.ZIndex = 0
	modalBackdrop.Parent = screenGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainWindow"
	mainFrame.Size = self.Size
	mainFrame.Position = self.Position
	mainFrame.BackgroundColor3 = ThemeManager:GetColor("Surface")
	mainFrame.BorderSizePixel = 0
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = screenGui

	AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 0}, "Smooth", "Out", 0.4)

	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 12)

	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local shadowFrame = Instance.new("ImageLabel")
	shadowFrame.Name = "Shadow"
	shadowFrame.BackgroundTransparency = 1
	shadowFrame.BorderSizePixel = 0
	shadowFrame.Size = UDim2.new(1, 60, 1, 60)
	shadowFrame.Position = UDim2.new(-0.5, -30, -0.5, -30)
	shadowFrame.ZIndex = mainFrame.ZIndex - 2
	shadowFrame.Image = "rbxassetid://1316045217"
	shadowFrame.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadowFrame.ImageTransparency = 0.78
	shadowFrame.ScaleType = Enum.ScaleType.Slice
	shadowFrame.SliceCenter = Rect.new(10, 10, 118, 118)
	shadowFrame.Parent = mainFrame

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 44)
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame

	Utility:CreateCorner(titleBar, 12)
	Utility:CreateStroke(titleBar, ThemeManager:GetColor("Border"), 0.3, 1)

	local titleBarFill = Instance.new("Frame")
	titleBarFill.Name = "TitleBarFill"
	titleBarFill.Size = UDim2.new(0, 0, 0, 1)
	titleBarFill.Position = UDim2.new(0, 0, 1, 0)
	titleBarFill.BackgroundColor3 = ThemeManager:GetColor("Divider")
	titleBarFill.BorderSizePixel = 0
	titleBarFill.Parent = titleBar

	self.TitleBar = titleBar

	local iconLabel
	if self.Icon then
		iconLabel = IconManager:CreateIconLabel(titleBar, self.Icon, UDim2.new(0, 20, 0, 20), ThemeManager:GetColor("Accent"))
		if iconLabel then
			iconLabel.Position = UDim2.new(0, 14, 0.5, -10)
			iconLabel.ZIndex = titleBar.ZIndex + 1
		end
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -100, 1, 0)
	titleLabel.Position = UDim2.new(0, iconLabel and 44 or 16, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = titleBar

	self.TitleLabel = titleLabel

	local windowButtons = Instance.new("Frame")
	windowButtons.Name = "WindowButtons"
	windowButtons.Size = UDim2.new(0, 90, 0, 26)
	windowButtons.Position = UDim2.new(1, -104, 0.5, -13)
	windowButtons.BackgroundTransparency = 1
	windowButtons.BorderSizePixel = 0
	windowButtons.Parent = titleBar

	local buttonColors = {
		{idle = Color3.fromRGB(255, 100, 89), hover = Color3.fromRGB(255, 80, 70)},
		{idle = Color3.fromRGB(255, 190, 50), hover = Color3.fromRGB(240, 170, 40)},
		{idle = Color3.fromRGB(60, 200, 80), hover = Color3.fromRGB(50, 180, 70)},
	}

	local function createMacButton(colorSet, order)
		local btn = Instance.new("TextButton")
		btn.Name = "MacButton" .. order
		btn.Size = UDim2.new(0, 14, 0, 14)
		btn.Position = UDim2.new(0, (order - 1) * 22, 0.5, -7)
		btn.BackgroundColor3 = colorSet.idle
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.ZIndex = titleBar.ZIndex + 2
		btn.Parent = windowButtons

		Utility:CreateCorner(btn, 7)

		btn.MouseEnter:Connect(function()
			AnimationManager:CreateTween(btn, {BackgroundColor3 = colorSet.hover}, "Smooth", "Out", 0.1)
		end)

		btn.MouseLeave:Connect(function()
			AnimationManager:CreateTween(btn, {BackgroundColor3 = colorSet.idle}, "Smooth", "Out", 0.2)
		end)

		return btn
	end

	local closeBtn = createMacButton(buttonColors[1], 1)
	closeBtn.MouseButton1Click:Connect(function() self:Close() end)

	local minimizeBtn = createMacButton(buttonColors[2], 2)
	minimizeBtn.MouseButton1Click:Connect(function() self:Minimize() end)

	local maximizeBtn = createMacButton(buttonColors[3], 3)
	maximizeBtn.MouseButton1Click:Connect(function() self:ToggleMaximize() end)

	local bodyFrame = Instance.new("Frame")
	bodyFrame.Name = "Body"
	bodyFrame.Size = UDim2.new(1, 0, 1, -44)
	bodyFrame.Position = UDim2.new(0, 0, 0, 44)
	bodyFrame.BackgroundTransparency = 1
	bodyFrame.BorderSizePixel = 0
	bodyFrame.Parent = mainFrame

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, self.SidebarWidth, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	sidebar.BorderSizePixel = 0
	sidebar.Parent = bodyFrame

	self.Sidebar = sidebar

	local sidebarDivider = Instance.new("Frame")
	sidebarDivider.Name = "SidebarDivider"
	sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
	sidebarDivider.Position = UDim2.new(1, 0, 0, 0)
	sidebarDivider.BackgroundColor3 = ThemeManager:GetColor("Divider")
	sidebarDivider.BorderSizePixel = 0
	sidebarDivider.Parent = sidebar

	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.FillDirection = Enum.FillDirection.Vertical
	sidebarLayout.Padding = UDim.new(0, 2)
	sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sidebarLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarLayout.Parent = sidebar

	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 8)
	sidebarPadding.PaddingBottom = UDim.new(0, 8)
	sidebarPadding.Parent = sidebar

	local tabIndicator = Instance.new("Frame")
	tabIndicator.Name = "TabIndicator"
	tabIndicator.Size = UDim2.new(0, 3, 0, 0)
	tabIndicator.Position = UDim2.new(0, 0, 0, 0)
	tabIndicator.BackgroundColor3 = ThemeManager:GetColor("Accent")
	tabIndicator.BorderSizePixel = 0
	tabIndicator.Parent = sidebar

	self.TabIndicator = tabIndicator

	local contentArea = Instance.new("ScrollingFrame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -(self.SidebarWidth + 1), 1, 0)
	contentArea.Position = UDim2.new(0, self.SidebarWidth + 1, 0, 0)
	contentArea.BackgroundColor3 = ThemeManager:GetColor("Background")
	contentArea.BorderSizePixel = 0
	contentArea.ScrollBarThickness = 3
	contentArea.ScrollBarImageColor3 = ThemeManager:GetColor("ScrollBar")
	contentArea.ScrollBarImageTransparency = 0.6
	contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentArea.ScrollingDirection = Enum.ScrollingDirection.Y
	contentArea.ElasticBehavior = Enum.ElasticBehavior.Never
	contentArea.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	contentArea.Parent = bodyFrame

	self.ContentArea = contentArea

	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingTop = UDim.new(0, 16)
	contentPadding.PaddingBottom = UDim.new(0, 16)
	contentPadding.PaddingLeft = UDim.new(0, 18)
	contentPadding.PaddingRight = UDim.new(0, 18)
	contentPadding.Parent = contentArea

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.FillDirection = Enum.FillDirection.Vertical
	contentLayout.Padding = UDim.new(0, 10)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Parent = contentArea

	self._contentLayout = contentLayout

	local function updateCanvas()
		local size = contentLayout.AbsoluteContentSize
		contentArea.CanvasSize = UDim2.new(0, 0, 0, size.Y + 32)
	end

	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
	task.spawn(updateCanvas)

	DragService:MakeDraggable(mainFrame, titleBar, {
		ConstrainToScreen = true,
		SmoothDrag = true,
	})

	DragService:MakeResizable(mainFrame, {
		MinSize = self.MinSize,
		Enabled = self.Resizable,
	})

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	table.insert(Windows, self)

	return self
end

function Window:CreateTab(options)
	options = options or {}
	local Tab = NovaUI.Tab
	local tab = Tab:New(self, options)
	table.insert(self.Tabs, tab)

	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end

	return tab
end

function Window:SelectTab(tab)
	if self._currentTab then
		self._currentTab:Hide()
	end

	self._currentTab = tab
	tab:Show()

	local tabIndex = 0
	for i, t in ipairs(self.Tabs) do
		if t == tab then
			tabIndex = i
			break
		end
	end

	local tabButton = tab.TabButton
	if tabButton then
		local targetY = tabButton.AbsolutePosition.Y - self.Sidebar.AbsolutePosition.Y
		local targetHeight = tabButton.AbsoluteSize.Y

		AnimationManager:CreateTween(self.TabIndicator, {
			Position = UDim2.new(0, 0, 0, targetY),
			Size = UDim2.new(0, 3, 0, targetHeight)
		}, "Smooth", "Out", 0.35)
	end

	SoundManager:PlayTabSwitch()

	local size = self._contentLayout.AbsoluteContentSize
	self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, size.Y + 32)
end

function Window:Minimize()
	self._minimized = not self._minimized
	if self._minimized then
		self._previousSize = self.MainFrame.Size
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, self.MainFrame.AbsoluteSize.X, 0, 44)
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ContentArea, {
			Size = UDim2.new(1, -(self.SidebarWidth + 1), 0, 0)
		}, "Smooth", "Out", 0.25)
		local tabArea = self.MainFrame:FindFirstChild("Body")
		if tabArea then
			tabArea.Size = UDim2.new(1, 0, 0, 0)
		end
	else
		AnimationManager:CreateTween(self.MainFrame, {
			Size = self._previousSize or self.Size
		}, "Smooth", "Out", 0.4)
		AnimationManager:CreateTween(self.MainFrame:FindFirstChild("Body"), {
			Size = UDim2.new(1, 0, 1, -44)
		}, "Smooth", "Out", 0.3)
	end
end

function Window:ToggleMaximize()
	if self._maximized then
		self._maximized = false
		AnimationManager:CreateTween(self.MainFrame, {
			Size = self._previousSize or self.Size,
			Position = self._previousPosition or self.Position
		}, "Smooth", "Out", 0.4)
	else
		self._maximized = true
		self._previousSize = self.MainFrame.Size
		self._previousPosition = self.MainFrame.Position
		local screenSize = workspace.CurrentCamera.ViewportSize
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, screenSize.X, 0, screenSize.Y),
			Position = UDim2.new(0, 0, 0, 0)
		}, "Smooth", "Out", 0.4)
	end
end

function Window:Close(animate)
	animate = animate ~= false
	if animate then
		AnimationManager:CreateTween(self.MainFrame, {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.3, function()
			self:Destroy()
		end)
	else
		self:Destroy()
	end
end

function Window:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end

	for _, tab in ipairs(self.Tabs) do
		tab:Destroy()
	end

	self.ScreenGui:Destroy()

	for i, w in ipairs(Windows) do
		if w == self then
			table.remove(Windows, i)
			break
		end
	end
end

function Window:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.MainFrame, {BackgroundColor3 = palette.Surface}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TitleBar, {BackgroundColor3 = palette.SurfaceAlt}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.Sidebar, {BackgroundColor3 = palette.SurfaceAlt}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ContentArea, {BackgroundColor3 = palette.Background}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TabIndicator, {BackgroundColor3 = palette.Accent}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TitleLabel, {TextColor3 = palette.TextPrimary}, "Smooth", "Out", 0.3)
	else
		self.MainFrame.BackgroundColor3 = palette.Surface
		self.TitleBar.BackgroundColor3 = palette.SurfaceAlt
		self.Sidebar.BackgroundColor3 = palette.SurfaceAlt
		self.ContentArea.BackgroundColor3 = palette.Background
		self.TabIndicator.BackgroundColor3 = palette.Accent
		self.TitleLabel.TextColor3 = palette.TextPrimary
	end
end

function Window:UpdateContentSize()
	local size = self._contentLayout.AbsoluteContentSize
	self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, size.Y + 32)
end

function Window:GetWindows()
	return Windows
end

NovaUI.Window = Window


-- Tab
local Tab = {}
Tab.__index = Tab







function Tab:New(window, options)
	options = options or {}

	local self = setmetatable({}, Tab)

	self.Window = window
	self.Name = options.Name or "Tab"
	self.Icon = options.Icon or nil
	self.Sections = {}
	self._visible = false

	local sidebar = window.Sidebar

	local tabButton = Instance.new("TextButton")
	tabButton.Name = "Tab_" .. self.Name
	tabButton.Size = UDim2.new(1, -12, 0, 44)
	tabButton.Position = UDim2.new(0, 6, 0, 0)
	tabButton.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	tabButton.BackgroundTransparency = 1
	tabButton.BorderSizePixel = 0
	tabButton.Text = ""
	tabButton.Parent = sidebar

	Utility:CreateCorner(tabButton, 8)

	self.TabButton = tabButton

	if self.Icon then
		local icon = IconManager:CreateIconLabel(tabButton, self.Icon, UDim2.new(0, 22, 0, 22), ThemeManager:GetColor("TextMuted"))
		if icon then
			icon.Position = UDim2.new(0.5, -11, 0.5, -11)
			icon.ZIndex = tabButton.ZIndex + 1
			self._icon = icon
		end
	end

	tabButton.MouseEnter:Connect(function()
		if not self._active then
			AnimationManager:CreateTween(tabButton, {BackgroundTransparency = 0.85}, "Smooth", "Out", 0.2)
			if self._icon then
				AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("TextSecondary")}, "Smooth", "Out", 0.2)
			end
			SoundManager:PlayHover()
		end
	end)

	tabButton.MouseLeave:Connect(function()
		if not self._active then
			AnimationManager:CreateTween(tabButton, {BackgroundTransparency = 1}, "Smooth", "Out", 0.3)
			if self._icon then
				AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("TextMuted")}, "Smooth", "Out", 0.3)
			end
		end
	end)

	tabButton.MouseButton1Click:Connect(function()
		window:SelectTab(self)
	end)

	local container = Instance.new("ScrollingFrame")
	container.Name = "TabContent_" .. self.Name
	container.Size = UDim2.new(1, 0, 1, 0)
	container.Position = UDim2.new(0, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ScrollBarThickness = 0
	container.CanvasSize = UDim2.new(0, 0, 0, 0)
	container.ScrollingDirection = Enum.ScrollingDirection.Y
	container.ElasticBehavior = Enum.ElasticBehavior.Never
	container.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	container.Visible = false
	container.Parent = window.ContentArea

	self.Container = container

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 0)
	padding.PaddingRight = UDim.new(0, 0)
	padding.Parent = container

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Padding = UDim.new(0, 10)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = container

	self._listLayout = listLayout

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self:UpdateContentSize()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Tab:CreateSection(options)
	options = options or {}
	local Section = NovaUI.Section
	local section = Section:New(self, options)
	table.insert(self.Sections, section)
	section.Container.Parent = self.Container
	section.Container.LayoutOrder = #self.Sections
	return section
end

function Tab:Show()
	self._visible = true
	self.Container.Visible = true
	self._active = true

	AnimationManager:CreateTween(self.TabButton, {BackgroundTransparency = 0.8}, "Smooth", "Out", 0.3)

	if self._icon then
		AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("Accent")}, "Smooth", "Out", 0.3)
	end

	self.Container.CanvasPosition = Vector2.new(0, 0)
	self:UpdateContentSize()
end

function Tab:Hide()
	self._visible = false
	self.Container.Visible = false
	self._active = false

	AnimationManager:CreateTween(self.TabButton, {BackgroundTransparency = 1}, "Smooth", "Out", 0.2)

	if self._icon then
		AnimationManager:CreateTween(self._icon, {ImageColor3 = ThemeManager:GetColor("TextMuted")}, "Smooth", "Out", 0.2)
	end
end

function Tab:UpdateContentSize()
	task.wait()
	local contentSize = self._listLayout.AbsoluteContentSize
	self.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 32)
end

function Tab:UpdateTheme(palette, animate)
	if self._active then
		if animate then
			if self._icon then
				AnimationManager:CreateTween(self._icon, {ImageColor3 = palette.Accent}, "Smooth", "Out", 0.3)
			end
		elseif self._icon then
			self._icon.ImageColor3 = palette.Accent
		end
	end
end

function Tab:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end

	for _, section in ipairs(self.Sections) do
		section:Destroy()
	end

	self.TabButton:Destroy()
	self.Container:Destroy()
end

NovaUI.Tab = Tab


-- Section
local Section = {}
Section.__index = Section






function Section:New(tab, options)
	options = options or {}

	local self = setmetatable({}, Section)

	self.Tab = tab
	self.Name = options.Name or "Section"
	self.Columns = options.Columns or 1
self.Components = {}

	local container = Instance.new("Frame")
	container.Name = "Section_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	local headerFrame = Instance.new("Frame")
	headerFrame.Name = "Header"
	headerFrame.Size = UDim2.new(1, 0, 0, 28)
	headerFrame.BackgroundTransparency = 1
	headerFrame.BorderSizePixel = 0
	headerFrame.Parent = container

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.new(0, 0, 1, -1)
	divider.BackgroundColor3 = ThemeManager:GetColor("Divider")
	divider.BorderSizePixel = 0
	divider.Parent = headerFrame

	local headerLabel = Instance.new("TextLabel")
	headerLabel.Name = "HeaderLabel"
	headerLabel.Size = UDim2.new(1, -8, 1, 0)
	headerLabel.Position = UDim2.new(0, 0, 0, 0)
	headerLabel.BackgroundTransparency = 1
	headerLabel.BorderSizePixel = 0
	headerLabel.Text = self.Name
	headerLabel.Font = Enum.Font.GothamSemibold
	headerLabel.TextSize = 12
	headerLabel.TextColor3 = ThemeManager:GetColor("HeaderText")
	headerLabel.TextTransparency = 0.2
	headerLabel.TextXAlignment = Enum.TextXAlignment.Left
	headerLabel.TextYAlignment = Enum.TextYAlignment.Center
	headerLabel.Parent = headerFrame

	self.Divider = divider
	self.HeaderLabel = headerLabel

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, 0, 0, 0)
	contentFrame.Position = UDim2.new(0, 0, 0, 32)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.AutomaticSize = Enum.AutomaticSize.Y
	contentFrame.Parent = container

	self.ContentFrame = contentFrame

	if self.Columns > 1 then
		local gridLayout = Instance.new("UIGridLayout")
		gridLayout.FillDirection = Enum.FillDirection.Horizontal
		gridLayout.CellSize = UDim2.new(0.5, -5, 0, 0)
		gridLayout.CellPadding = UDim2.new(0, 10, 0, 8)
		gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		gridLayout.FillDirectionMaxCells = self.Columns
		gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		gridLayout.Parent = contentFrame
		self._gridLayout = gridLayout
	else
		local listLayout = Instance.new("UIListLayout")
		listLayout.FillDirection = Enum.FillDirection.Vertical
		listLayout.Padding = UDim.new(0, 6)
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = contentFrame
		self._listLayout = listLayout
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Section:CreateButton(options)
	options = options or {}
	local Button = NovaUI.Button
	local btn = Button:New(self, options)
	table.insert(self.Components, btn)
	btn.Container.Parent = self.ContentFrame
	btn.Container.LayoutOrder = #self.Components
	return btn
end

function Section:CreateToggle(options)
	options = options or {}
	local Toggle = NovaUI.Toggle
	local tg = Toggle:New(self, options)
	table.insert(self.Components, tg)
	tg.Container.Parent = self.ContentFrame
	tg.Container.LayoutOrder = #self.Components
	return tg
end

function Section:CreateSlider(options)
	options = options or {}
	local Slider = NovaUI.Slider
	local sl = Slider:New(self, options)
	table.insert(self.Components, sl)
	sl.Container.Parent = self.ContentFrame
	sl.Container.LayoutOrder = #self.Components
	return sl
end

function Section:CreateDropdown(options)
	options = options or {}
	local Dropdown = NovaUI.Dropdown
	local dd = Dropdown:New(self, options)
	table.insert(self.Components, dd)
	dd.Container.Parent = self.ContentFrame
	dd.Container.LayoutOrder = #self.Components
	return dd
end

function Section:CreateLabel(options)
	options = options or {}
	local Label = NovaUI.Label
	local lb = Label:New(self, options)
	table.insert(self.Components, lb)
	lb.Container.Parent = self.ContentFrame
	lb.Container.LayoutOrder = #self.Components
	return lb
end

function Section:CreateTextBox(options)
	options = options or {}
	local TextBox = NovaUI.TextBox
	local tb = TextBox:New(self, options)
	table.insert(self.Components, tb)
	tb.Container.Parent = self.ContentFrame
	tb.Container.LayoutOrder = #self.Components
	return tb
end

function Section:CreateSeparator(options)
	options = options or {}
	local Separator = NovaUI.Separator
	local sp = Separator:New(self, options)
	table.insert(self.Components, sp)
	sp.Container.Parent = self.ContentFrame
	sp.Container.LayoutOrder = #self.Components
	return sp
end

function Section:CreateKeybind(options)
	options = options or {}
	local Keybind = NovaUI.Keybind
	local kb = Keybind:New(self, options)
	table.insert(self.Components, kb)
	kb.Container.Parent = self.ContentFrame
	kb.Container.LayoutOrder = #self.Components
	return kb
end

function Section:CreateColorPicker(options)
	options = options or {}
	local ColorPicker = NovaUI.ColorPicker
	local cp = ColorPicker:New(self, options)
	table.insert(self.Components, cp)
	cp.Container.Parent = self.ContentFrame
	cp.Container.LayoutOrder = #self.Components
	return cp
end

function Section:CreateProgressBar(options)
	options = options or {}
	local ProgressBar = NovaUI.ProgressBar
	local pb = ProgressBar:New(self, options)
	table.insert(self.Components, pb)
	pb.Container.Parent = self.ContentFrame
	pb.Container.LayoutOrder = #self.Components
	return pb
end

function Section:CreateSearchBar(options)
	options = options or {}
	local SearchBar = NovaUI.SearchBar
	local sb = SearchBar:New(self, options)
	table.insert(self.Components, sb)
	sb.Container.Parent = self.ContentFrame
	sb.Container.LayoutOrder = #self.Components
	return sb
end

function Section:CreateMultiDropdown(options)
	options = options or {}
	local MultiDropdown = NovaUI.MultiDropdown
	local md = MultiDropdown:New(self, options)
	table.insert(self.Components, md)
	md.Container.Parent = self.ContentFrame
	md.Container.LayoutOrder = #self.Components
	return md
end

function Section:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Divider, {BackgroundColor3 = palette.Divider}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.HeaderLabel, {TextColor3 = palette.HeaderText}, "Smooth", "Out", 0.3)
	else
		self.Divider.BackgroundColor3 = palette.Divider
		self.HeaderLabel.TextColor3 = palette.HeaderText
	end
end

function Section:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	for _, comp in ipairs(self.Components) do
		comp:Destroy()
	end
	self.Container:Destroy()
end

NovaUI.Section = Section


-- Button
local Button = {}
Button.__index = Button







function Button:New(section, options)
	options = options or {}

	local self = setmetatable({}, Button)

	self.Section = section
	self.Name = options.Name or "Button"
	self.Description = options.Description or nil
	self.Icon = options.Icon or nil
	self.Callback = options.Callback or function() end

	local container = Instance.new("Frame")
	container.Name = "Button_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local mainFrame = Instance.new("TextButton")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Text = ""
	mainFrame.AutoButtonColor = false
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 8)

	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.6, 1)

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, -24, 1, 0)
	contentFrame.Position = UDim2.new(0, 12, 0, 0)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent = mainFrame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, 10)
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = contentFrame

	local iconLabel
	if self.Icon then
		iconLabel = IconManager:CreateIconLabel(contentFrame, self.Icon, UDim2.new(0, 18, 0, 18), ThemeManager:GetColor("TextSecondary"))
		if iconLabel then
			iconLabel.LayoutOrder = 1
		end
	end

	local textFrame = Instance.new("Frame")
	textFrame.Name = "TextFrame"
	textFrame.Size = UDim2.new(0, 0, 1, 0)
	textFrame.BackgroundTransparency = 1
	textFrame.BorderSizePixel = 0
	textFrame.AutomaticSize = Enum.AutomaticSize.X
	textFrame.LayoutOrder = 2
	textFrame.Parent = contentFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.AutomaticSize = Enum.AutomaticSize.X
	nameLabel.Parent = textFrame

	self.NameLabel = nameLabel

	if self.Description then
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(0, 0, 1, 0)
		descLabel.Position = UDim2.new(1, 8, 0, 0)
		descLabel.BackgroundTransparency = 1
		descLabel.BorderSizePixel = 0
		descLabel.Text = self.Description
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextSize = 12
		descLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextYAlignment = Enum.TextYAlignment.Center
		descLabel.AutomaticSize = Enum.AutomaticSize.X
		descLabel.Parent = textFrame
	end

	mainFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 0.08}, "Smooth", "Out", 0.15)
		SoundManager:PlayHover()
	end)

	mainFrame.MouseLeave:Connect(function()
		AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 1}, "Smooth", "Out", 0.2)
	end)

	mainFrame.MouseButton1Down:Connect(function()
		AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 0.15}, "Sharp", "In", 0.08)
		AnimationManager:CreateTween(container, {Size = UDim2.new(1, 0, 0, 34)}, "Sharp", "In", 0.08)
	end)

	mainFrame.MouseButton1Up:Connect(function()
		AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 0.08}, "Elastic", "Out", 0.3)
		AnimationManager:CreateTween(container, {Size = UDim2.new(1, 0, 0, 36)}, "Elastic", "Out", 0.3)
	end)

	mainFrame.MouseButton1Click:Connect(function()
		SoundManager:PlayClick()
		local ok, err = pcall(self.Callback)
		if not ok then
			warn("Button callback error:", err)
		end
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Button:SetCallback(callback)
	self.Callback = callback
end

function Button:SetText(text)
	self.Name = text
	self.NameLabel.Text = text
end

function Button:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.NameLabel, {TextColor3 = palette.TextPrimary}, "Smooth", "Out", 0.3)
	else
		self.NameLabel.TextColor3 = palette.TextPrimary
	end
end

function Button:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Button = Button


-- Toggle
local Toggle = {}
Toggle.__index = Toggle






function Toggle:New(section, options)
	options = options or {}

	local self = setmetatable({}, Toggle)

	self.Section = section
	self.Name = options.Name or "Toggle"
	self.Description = options.Description or nil
	self.Default = options.Default or false
	self.Callback = options.Callback or function() end
	self._value = self.Default

	local container = Instance.new("Frame")
	container.Name = "Toggle_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 34)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local mainFrame = Instance.new("TextButton")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Text = ""
	mainFrame.AutoButtonColor = false
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 8)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.6, 1)

	local textFrame = Instance.new("Frame")
	textFrame.Name = "TextFrame"
	textFrame.Size = UDim2.new(1, -64, 1, 0)
	textFrame.Position = UDim2.new(0, 12, 0, 0)
	textFrame.BackgroundTransparency = 1
	textFrame.BorderSizePixel = 0
	textFrame.Parent = mainFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.Parent = textFrame
	self.NameLabel = nameLabel

	if self.Description then
		nameLabel.Size = UDim2.new(1, 0, 0, 18)
		local descLabel = Instance.new("TextLabel")
		descLabel.Name = "Description"
		descLabel.Size = UDim2.new(1, 0, 0, 14)
		descLabel.Position = UDim2.new(0, 0, 0, 18)
		descLabel.BackgroundTransparency = 1
		descLabel.BorderSizePixel = 0
		descLabel.Text = self.Description
		descLabel.Font = Enum.Font.Gotham
		descLabel.TextSize = 11
		descLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
		descLabel.TextXAlignment = Enum.TextXAlignment.Left
		descLabel.TextYAlignment = Enum.TextYAlignment.Top
		descLabel.Parent = textFrame
	end

	local toggleBg = Instance.new("Frame")
	toggleBg.Name = "ToggleBg"
	toggleBg.Size = UDim2.new(0, 44, 0, 24)
	toggleBg.Position = UDim2.new(1, -56, 0.5, -12)
	toggleBg.BackgroundColor3 = ThemeManager:GetColor("ToggleInactive")
	toggleBg.BorderSizePixel = 0
	toggleBg.Parent = mainFrame

	self.ToggleBg = toggleBg
	Utility:CreateCorner(toggleBg, 12)

	local toggleKnob = Instance.new("Frame")
	toggleKnob.Name = "Knob"
	toggleKnob.Size = UDim2.new(0, 20, 0, 20)
	toggleKnob.Position = UDim2.new(0, 2, 0.5, -10)
	toggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.Parent = toggleBg

	self.ToggleKnob = toggleKnob
	Utility:CreateCorner(toggleKnob, 10)

	local knobInner = Instance.new("Frame")
	knobInner.Name = "KnobInner"
	knobInner.Size = UDim2.new(0, 8, 0, 8)
	knobInner.Position = UDim2.new(0.5, -4, 0.5, -4)
	knobInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knobInner.BackgroundTransparency = 0
	knobInner.BorderSizePixel = 0
	knobInner.Parent = toggleKnob
	Utility:CreateCorner(knobInner, 4)

	self.KnobInner = knobInner

	if self._value then
		self:SetState(true, true)
	end

	mainFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 0.08}, "Smooth", "Out", 0.15)
	end)

	mainFrame.MouseLeave:Connect(function()
		AnimationManager:CreateTween(mainFrame, {BackgroundTransparency = 1}, "Smooth", "Out", 0.2)
	end)

	mainFrame.MouseButton1Click:Connect(function()
		self:Toggle()
		SoundManager:PlayToggle()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Toggle:SetState(state, instant)
	state = state or false
	self._value = state

	local targetX = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
	local bgColor = state and ThemeManager:GetColor("ToggleActive") or ThemeManager:GetColor("ToggleInactive")
	local knobColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)

	if instant then
		self.ToggleKnob.Position = targetX
		self.ToggleBg.BackgroundColor3 = bgColor
		self.ToggleKnob.BackgroundColor3 = knobColor
	else
		AnimationManager:CreateTween(self.ToggleKnob, {Position = targetX}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ToggleBg, {BackgroundColor3 = bgColor}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ToggleKnob, {BackgroundColor3 = knobColor}, "Smooth", "Out", 0.3)
	end
end

function Toggle:Toggle()
	self:SetState(not self._value, false)
	pcall(self.Callback, self._value)
end

function Toggle:GetValue()
	return self._value
end

function Toggle:SetCallback(callback)
	self.Callback = callback
end

function Toggle:UpdateTheme(palette, animate)
	if self._value then
		if animate then
			AnimationManager:CreateTween(self.ToggleBg, {BackgroundColor3 = palette.ToggleActive}, "Smooth", "Out", 0.3)
		else
			self.ToggleBg.BackgroundColor3 = palette.ToggleActive
		end
	end
	if animate then
		AnimationManager:CreateTween(self.NameLabel, {TextColor3 = palette.TextPrimary}, "Smooth", "Out", 0.3)
	else
		self.NameLabel.TextColor3 = palette.TextPrimary
	end
end

function Toggle:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Toggle = Toggle


-- Slider
local Slider = {}
Slider.__index = Slider





local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

function Slider:New(section, options)
	options = options or {}

	local self = setmetatable({}, Slider)

	self.Section = section
	self.Name = options.Name or "Slider"
	self.Description = options.Description or nil
	self.Min = options.Min or 0
	self.Max = options.Max or 100
	self.Default = options.Default or 0
	self.Suffix = options.Suffix or ""
	self.Precision = options.Precision or 0
	self.Callback = options.Callback or function() end
	self._value = self.Default
	self._dragging = false

	local container = Instance.new("Frame")
	container.Name = "Slider_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 44)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(1, -80, 0, 18)
	nameLabel.Position = UDim2.new(0, 12, 0, 6)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.Parent = container
	self.NameLabel = nameLabel

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.Size = UDim2.new(0, 70, 0, 18)
	valueLabel.Position = UDim2.new(1, -82, 0, 6)
	valueLabel.BackgroundTransparency = 1
	valueLabel.BorderSizePixel = 0
	valueLabel.Text = tostring(self._value) .. self.Suffix
	valueLabel.Font = Enum.Font.GothamSemibold
	valueLabel.TextSize = 13
	valueLabel.TextColor3 = ThemeManager:GetColor("Accent")
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.TextYAlignment = Enum.TextYAlignment.Center
	valueLabel.Parent = container
	self.ValueLabel = valueLabel

	local trackFrame = Instance.new("Frame")
	trackFrame.Name = "Track"
	trackFrame.Size = UDim2.new(1, -24, 0, 6)
	trackFrame.Position = UDim2.new(0, 12, 1, -16)
	trackFrame.BackgroundColor3 = ThemeManager:GetColor("ToggleInactive")
	trackFrame.BorderSizePixel = 0
	trackFrame.Parent = container
	self.TrackFrame = trackFrame
	Utility:CreateCorner(trackFrame, 3)

	local fillFrame = Instance.new("Frame")
	fillFrame.Name = "Fill"
	fillFrame.Size = UDim2.new(0, 0, 1, 0)
	fillFrame.BackgroundColor3 = ThemeManager:GetColor("Accent")
	fillFrame.BorderSizePixel = 0
	fillFrame.Parent = trackFrame
	self.FillFrame = fillFrame
	Utility:CreateCorner(fillFrame, 3)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 18, 0, 18)
	knob.Position = UDim2.new(0, -9, 0.5, -9)
	knob.BackgroundColor3 = ThemeManager:GetColor("Accent")
	knob.BorderSizePixel = 0
	knob.Parent = trackFrame
	self.Knob = knob
	Utility:CreateCorner(knob, 9)

	local knobInner = Instance.new("Frame")
	knobInner.Name = "KnobInner"
	knobInner.Size = UDim2.new(0, 8, 0, 8)
	knobInner.Position = UDim2.new(0.5, -4, 0.5, -4)
	knobInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knobInner.BorderSizePixel = 0
	knobInner.Parent = knob
	Utility:CreateCorner(knobInner, 4)

	local function updateSlider(inputX)
		local trackPos = trackFrame.AbsolutePosition.X
		local trackWidth = trackFrame.AbsoluteSize.X
		local relX = math.clamp(inputX - trackPos, 0, trackWidth)
		local fraction = relX / trackWidth
		local value = self.Min + (self.Max - self.Min) * fraction
		local mult = 10 ^ self.Precision
		value = math.floor(value * mult + 0.5) / mult
		self._value = value
		self:UpdateVisuals(relX)
		self.ValueLabel.Text = tostring(value) .. self.Suffix
		pcall(self.Callback, value)
	end

	local inputService = game:GetService("UserInputService")

	trackFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self._dragging = true
			updateSlider(Mouse.X)
		end
	end)

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self._dragging = true
		end
	end)

	self._inputChanged = inputService.InputChanged:Connect(function(input)
		if self._dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(Mouse.X)
		end
	end)

	self._inputEnded = inputService.InputEnded:Connect(function(input)
		if self._dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			self._dragging = false
		end
	end)

	knob.MouseEnter:Connect(function()
		AnimationManager:CreateTween(knob, {Size = UDim2.new(0, 22, 0, 22)}, "Smooth", "Out", 0.15)
	end)

	knob.MouseLeave:Connect(function()
		if not self._dragging then
			AnimationManager:CreateTween(knob, {Size = UDim2.new(0, 18, 0, 18)}, "Smooth", "Out", 0.2)
		end
	end)

	self:SetValue(self.Default, true)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Slider:UpdateVisuals(relX)
	local trackWidth = self.TrackFrame.AbsoluteSize.X
	if trackWidth == 0 then
		trackWidth = self.TrackFrame.Size.X.Offset
	end
	relX = relX or (self._value - self.Min) / (self.Max - self.Min) * trackWidth

	AnimationManager:CreateTween(self.FillFrame, {Size = UDim2.new(0, relX, 1, 0)}, "Smooth", "Out", 0.1)
	AnimationManager:CreateTween(self.Knob, {Position = UDim2.new(0, relX - 9, 0.5, -9)}, "Smooth", "Out", 0.1)
end

function Slider:SetValue(value, instant)
	self._value = Utility:Clamp(value, self.Min, self.Max)
	local trackWidth = self.TrackFrame.AbsoluteSize.X
	if trackWidth == 0 then
		trackWidth = self.TrackFrame.Size.X.Offset
	end
	local fraction = (self._value - self.Min) / (self.Max - self.Min)
	local relX = fraction * trackWidth

	if instant then
		self.FillFrame.Size = UDim2.new(0, relX, 1, 0)
		self.Knob.Position = UDim2.new(0, relX - 9, 0.5, -9)
	else
		self:UpdateVisuals(relX)
	end

	self.ValueLabel.Text = tostring(self._value) .. self.Suffix
end

function Slider:GetValue()
	return self._value
end

function Slider:SetCallback(callback)
	self.Callback = callback
end

function Slider:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.FillFrame, {BackgroundColor3 = palette.Accent}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.Knob, {BackgroundColor3 = palette.Accent}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ValueLabel, {TextColor3 = palette.Accent}, "Smooth", "Out", 0.3)
	else
		self.FillFrame.BackgroundColor3 = palette.Accent
		self.Knob.BackgroundColor3 = palette.Accent
		self.ValueLabel.TextColor3 = palette.Accent
	end
end

function Slider:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	if self._inputChanged then
		self._inputChanged:Disconnect()
	end
	if self._inputEnded then
		self._inputEnded:Disconnect()
	end
	self.Container:Destroy()
end

NovaUI.Slider = Slider


-- Dropdown
local Dropdown = {}
Dropdown.__index = Dropdown







function Dropdown:New(section, options)
	options = options or {}

	local self = setmetatable({}, Dropdown)

	self.Section = section
	self.Name = options.Name or "Dropdown"
	self.Description = options.Description or nil
	self.Items = options.Items or {}
	self.Default = options.Default or nil
	self.Callback = options.Callback or function() end
	self.Searchable = options.Searchable or false
	self._open = false
	self._selected = self.Default

	local container = Instance.new("Frame")
	container.Name = "Dropdown_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	local mainFrame = Instance.new("TextButton")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 0, 34)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Text = ""
	mainFrame.AutoButtonColor = false
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 6)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0.7, -40, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.Parent = mainFrame
	self.NameLabel = nameLabel

	local selectedLabel = Instance.new("TextLabel")
	selectedLabel.Name = "Selected"
	selectedLabel.Size = UDim2.new(0.3, -10, 1, 0)
	selectedLabel.Position = UDim2.new(0.7, -20, 0, 0)
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.BorderSizePixel = 0
	selectedLabel.Text = self._selected or "Select..."
	selectedLabel.Font = Enum.Font.Gotham
	selectedLabel.TextSize = 13
	selectedLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	selectedLabel.TextYAlignment = Enum.TextYAlignment.Center
	selectedLabel.Parent = mainFrame
	self.SelectedLabel = selectedLabel

	local arrowIcon = IconManager:CreateIconLabel(mainFrame, "ChevronDown", UDim2.new(0, 14, 0, 14), ThemeManager:GetColor("TextMuted"))
	if arrowIcon then
		arrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
		self.ArrowIcon = arrowIcon
	end

	local dropdownList = Instance.new("Frame")
	dropdownList.Name = "DropdownList"
	dropdownList.Size = UDim2.new(1, 0, 0, 0)
	dropdownList.Position = UDim2.new(0, 0, 0, 36)
	dropdownList.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	dropdownList.BorderSizePixel = 0
	dropdownList.Visible = false
	dropdownList.Parent = container
	self.DropdownList = dropdownList

	Utility:CreateCorner(dropdownList, 6)
	Utility:CreateStroke(dropdownList, ThemeManager:GetColor("Border"), 0.5, 1)

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Padding = UDim.new(0, 2)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = dropdownList

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.PaddingLeft = UDim.new(0, 4)
	padding.PaddingRight = UDim.new(0, 4)
	padding.Parent = dropdownList

	self._itemButtons = {}

	for _, item in ipairs(self.Items) do
		self:CreateItemButton(item)
	end

	mainFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 0.1
		}, "Smooth", "Out", 0.15)
	end)

	mainFrame.MouseLeave:Connect(function()
		if not self._open then
			AnimationManager:CreateTween(mainFrame, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.2)
		end
	end)

	mainFrame.MouseButton1Click:Connect(function()
		self:Toggle()
		SoundManager:PlayDropdown()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Dropdown:CreateItemButton(item)
	local itemBtn = Instance.new("TextButton")
	itemBtn.Name = "Item_" .. tostring(item)
	itemBtn.Size = UDim2.new(1, 0, 0, 28)
	itemBtn.BackgroundTransparency = 1
	itemBtn.BorderSizePixel = 0
	itemBtn.Text = ""
	itemBtn.AutoButtonColor = false
	itemBtn.Parent = self.DropdownList

	local itemLabel = Instance.new("TextLabel")
	itemLabel.Name = "ItemLabel"
	itemLabel.Size = UDim2.new(1, -16, 1, 0)
	itemLabel.Position = UDim2.new(0, 8, 0, 0)
	itemLabel.BackgroundTransparency = 1
	itemLabel.BorderSizePixel = 0
	itemLabel.Text = tostring(item)
	itemLabel.Font = Enum.Font.Gotham
	itemLabel.TextSize = 13
	itemLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	itemLabel.TextXAlignment = Enum.TextXAlignment.Left
	itemLabel.TextYAlignment = Enum.TextYAlignment.Center
	itemLabel.Parent = itemBtn

	Utility:CreateCorner(itemBtn, 4)

	itemBtn.MouseEnter:Connect(function()
		AnimationManager:CreateTween(itemBtn, {
			BackgroundTransparency = 0.1
		}, "Smooth", "Out", 0.1)
		AnimationManager:CreateTween(itemLabel, {
			TextColor3 = ThemeManager:GetColor("TextPrimary")
		}, "Smooth", "Out", 0.1)
	end)

	itemBtn.MouseLeave:Connect(function()
		if self._selected ~= item then
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.15)
			AnimationManager:CreateTween(itemLabel, {
				TextColor3 = ThemeManager:GetColor("TextSecondary")
			}, "Smooth", "Out", 0.15)
		end
	end)

	itemBtn.MouseButton1Click:Connect(function()
		self:Select(item)
		self:Close()
		SoundManager:PlayClick()
	end)

	self._itemButtons[item] = {
		Button = itemBtn,
		Label = itemLabel
	}

	if self._selected == item then
		itemBtn.BackgroundTransparency = 0.12
		itemLabel.TextColor3 = ThemeManager:GetColor("Accent")
	end
end

function Dropdown:Select(item)
	self._selected = item
	self.SelectedLabel.Text = tostring(item)

	for i, data in self._itemButtons do
		if i == item then
			AnimationManager:CreateTween(data.Button, {
				BackgroundTransparency = 0.12
			}, "Smooth", "Out", 0.15)
			AnimationManager:CreateTween(data.Label, {
				TextColor3 = ThemeManager:GetColor("Accent")
			}, "Smooth", "Out", 0.15)
		else
			AnimationManager:CreateTween(data.Button, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.15)
			AnimationManager:CreateTween(data.Label, {
				TextColor3 = ThemeManager:GetColor("TextSecondary")
			}, "Smooth", "Out", 0.15)
		end
	end

	pcall(self.Callback, item)
end

function Dropdown:Toggle()
	if self._open then
		self:Close()
	else
		self:Open()
	end
end

function Dropdown:Open()
	self._open = true
	self.DropdownList.Visible = true

	local itemCount = #self.Items
	local listHeight = math.min(itemCount, 6) * 30 + 8
	self.DropdownList.Size = UDim2.new(1, 0, 0, 0)

	AnimationManager:CreateTween(self.DropdownList, {
		Size = UDim2.new(1, 0, 0, listHeight)
	}, "Smooth", "Out", 0.25)

	if self.ArrowIcon then
		AnimationManager:CreateTween(self.ArrowIcon, {
			Rotation = 180
		}, "Smooth", "Out", 0.25)
	end
end

function Dropdown:Close()
	self._open = false
	AnimationManager:CreateTween(self.DropdownList, {
		Size = UDim2.new(1, 0, 0, 0)
	}, "Smooth", "Out", 0.2, function()
		self.DropdownList.Visible = false
	end)

	if self.ArrowIcon then
		AnimationManager:CreateTween(self.ArrowIcon, {
			Rotation = 0
		}, "Smooth", "Out", 0.2)
	end

	AnimationManager:CreateTween(self.MainFrame, {
		BackgroundTransparency = 1
	}, "Smooth", "Out", 0.2)
end

function Dropdown:SetItems(items)
	self.Items = items
	for _, data in self._itemButtons do
		data.Button:Destroy()
	end
	self._itemButtons = {}
	for _, item in ipairs(self.Items) do
		self:CreateItemButton(item)
	end
end

function Dropdown:GetValue()
	return self._selected
end

function Dropdown:SetCallback(callback)
	self.Callback = callback
end

function Dropdown:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.DropdownList, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.DropdownList.BackgroundColor3 = palette.SurfaceAlt
	end
end

function Dropdown:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Dropdown = Dropdown


-- MultiDropdown
local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown







function MultiDropdown:New(section, options)
	options = options or {}

	local self = setmetatable({}, MultiDropdown)

	self.Section = section
	self.Name = options.Name or "MultiDropdown"
	self.Description = options.Description or nil
	self.Items = options.Items or {}
	self.Default = options.Default or {}
	self.Callback = options.Callback or function() end
	self._open = false
	self._selected = {}

	for _, item in ipairs(self.Default) do
		self._selected[item] = true
	end

	local container = Instance.new("Frame")
	container.Name = "MultiDropdown_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	local mainFrame = Instance.new("TextButton")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 0, 34)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Text = ""
	mainFrame.AutoButtonColor = false
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 6)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0.7, -40, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.Parent = mainFrame
	self.NameLabel = nameLabel

	local countLabel = Instance.new("TextLabel")
	countLabel.Name = "Count"
	countLabel.Size = UDim2.new(0.3, -10, 1, 0)
	countLabel.Position = UDim2.new(0.7, -20, 0, 0)
	countLabel.BackgroundTransparency = 1
	countLabel.BorderSizePixel = 0
	countLabel.Text = "0 selected"
	countLabel.Font = Enum.Font.Gotham
	countLabel.TextSize = 13
	countLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	countLabel.TextXAlignment = Enum.TextXAlignment.Right
	countLabel.TextYAlignment = Enum.TextYAlignment.Center
	countLabel.Parent = mainFrame
	self.CountLabel = countLabel

	self:UpdateCount()

	local arrowIcon = IconManager:CreateIconLabel(mainFrame, "ChevronDown", UDim2.new(0, 14, 0, 14), ThemeManager:GetColor("TextMuted"))
	if arrowIcon then
		arrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
		self.ArrowIcon = arrowIcon
	end

	local dropdownList = Instance.new("Frame")
	dropdownList.Name = "DropdownList"
	dropdownList.Size = UDim2.new(1, 0, 0, 0)
	dropdownList.Position = UDim2.new(0, 0, 0, 36)
	dropdownList.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	dropdownList.BorderSizePixel = 0
	dropdownList.Visible = false
	dropdownList.Parent = container
	self.DropdownList = dropdownList

	Utility:CreateCorner(dropdownList, 6)
	Utility:CreateStroke(dropdownList, ThemeManager:GetColor("Border"), 0.5, 1)

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Padding = UDim.new(0, 2)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = dropdownList

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.PaddingLeft = UDim.new(0, 4)
	padding.PaddingRight = UDim.new(0, 4)
	padding.Parent = dropdownList

	self._itemButtons = {}

	for _, item in ipairs(self.Items) do
		self:CreateItemButton(item)
	end

	mainFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 0.1
		}, "Smooth", "Out", 0.15)
	end)

	mainFrame.MouseLeave:Connect(function()
		if not self._open then
			AnimationManager:CreateTween(mainFrame, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.2)
		end
	end)

	mainFrame.MouseButton1Click:Connect(function()
		self:Toggle()
		SoundManager:PlayDropdown()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function MultiDropdown:CreateItemButton(item)
	local itemBtn = Instance.new("TextButton")
	itemBtn.Name = "Item_" .. tostring(item)
	itemBtn.Size = UDim2.new(1, 0, 0, 30)
	itemBtn.BackgroundTransparency = 1
	itemBtn.BorderSizePixel = 0
	itemBtn.Text = ""
	itemBtn.AutoButtonColor = false
	itemBtn.Parent = self.DropdownList

	local checkBox = Instance.new("Frame")
	checkBox.Name = "CheckBox"
	checkBox.Size = UDim2.new(0, 16, 0, 16)
	checkBox.Position = UDim2.new(0, 8, 0.5, -8)
	checkBox.BackgroundColor3 = ThemeManager:GetColor("Border")
	checkBox.BorderSizePixel = 0
	checkBox.Parent = itemBtn
	Utility:CreateCorner(checkBox, 3)

	local checkFill = Instance.new("Frame")
	checkFill.Name = "CheckFill"
	checkFill.Size = UDim2.new(0, 0, 0, 0)
	checkFill.Position = UDim2.new(0.5, 0, 0.5, 0)
	checkFill.AnchorPoint = Vector2.new(0.5, 0.5)
	checkFill.BackgroundColor3 = ThemeManager:GetColor("Accent")
	checkFill.BorderSizePixel = 0
	checkFill.Parent = checkBox
	Utility:CreateCorner(checkFill, 2)

	local checkIcon = IconManager:CreateIconLabel(checkBox, "Check", UDim2.new(0, 10, 0, 10), Color3.fromRGB(255, 255, 255))
	if checkIcon then
		checkIcon.Position = UDim2.new(0.5, -5, 0.5, -5)
		checkIcon.ImageTransparency = 1
	end

	local itemLabel = Instance.new("TextLabel")
	itemLabel.Name = "ItemLabel"
	itemLabel.Size = UDim2.new(1, -30, 1, 0)
	itemLabel.Position = UDim2.new(0, 28, 0, 0)
	itemLabel.BackgroundTransparency = 1
	itemLabel.BorderSizePixel = 0
	itemLabel.Text = tostring(item)
	itemLabel.Font = Enum.Font.Gotham
	itemLabel.TextSize = 13
	itemLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	itemLabel.TextXAlignment = Enum.TextXAlignment.Left
	itemLabel.TextYAlignment = Enum.TextYAlignment.Center
	itemLabel.Parent = itemBtn

	Utility:CreateCorner(itemBtn, 4)

	local isSelected = self._selected[item] == true
	if isSelected then
		checkBox.BackgroundColor3 = ThemeManager:GetColor("Accent")
		checkFill.Size = UDim2.new(1, 0, 1, 0)
		checkFill.Position = UDim2.new(0, 0, 0, 0)
		checkFill.AnchorPoint = Vector2.new(0, 0)
		if checkIcon then
			checkIcon.ImageTransparency = 0
		end
		itemLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
		itemBtn.BackgroundTransparency = 0.08
	end

	itemBtn.MouseEnter:Connect(function()
		AnimationManager:CreateTween(itemBtn, {
			BackgroundTransparency = 0.05
		}, "Smooth", "Out", 0.1)
	end)

	itemBtn.MouseLeave:Connect(function()
		if not isSelected then
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.15)
		end
	end)

	itemBtn.MouseButton1Click:Connect(function()
		local currentlySelected = self._selected[item] == true
		self._selected[item] = not currentlySelected
		isSelected = not currentlySelected

		if isSelected then
			AnimationManager:CreateTween(checkBox, {
				BackgroundColor3 = ThemeManager:GetColor("Accent")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(checkFill, {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0)
			}, "Smooth", "Out", 0.2)
			if checkIcon then
				AnimationManager:CreateTween(checkIcon, {
					ImageTransparency = 0
				}, "Smooth", "Out", 0.15)
			end
			AnimationManager:CreateTween(itemLabel, {
				TextColor3 = ThemeManager:GetColor("TextPrimary")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 0.08
			}, "Smooth", "Out", 0.2)
		else
			AnimationManager:CreateTween(checkBox, {
				BackgroundColor3 = ThemeManager:GetColor("Border")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(checkFill, {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}, "Smooth", "Out", 0.2)
			if checkIcon then
				AnimationManager:CreateTween(checkIcon, {
					ImageTransparency = 1
				}, "Smooth", "Out", 0.15)
			end
			AnimationManager:CreateTween(itemLabel, {
				TextColor3 = ThemeManager:GetColor("TextSecondary")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.2)
		end

		self:UpdateCount()
		SoundManager:PlayClick()
		pcall(self.Callback, self:GetValue())
	end)

	self._itemButtons[item] = {
		Button = itemBtn,
		Label = itemLabel,
		CheckBox = checkBox,
		CheckFill = checkFill,
		CheckIcon = checkIcon
	}
end

function MultiDropdown:UpdateCount()
	local count = 0
	for _, v in self._selected do
		if v then
			count = count + 1
		end
	end
	self.CountLabel.Text = count .. " selected"
end

function MultiDropdown:Toggle()
	if self._open then
		self:Close()
	else
		self:Open()
	end
end

function MultiDropdown:Open()
	self._open = true
	self.DropdownList.Visible = true

	local itemCount = #self.Items
	local listHeight = math.min(itemCount, 6) * 32 + 8
	self.DropdownList.Size = UDim2.new(1, 0, 0, 0)

	AnimationManager:CreateTween(self.DropdownList, {
		Size = UDim2.new(1, 0, 0, listHeight)
	}, "Smooth", "Out", 0.25)

	if self.ArrowIcon then
		AnimationManager:CreateTween(self.ArrowIcon, {
			Rotation = 180
		}, "Smooth", "Out", 0.25)
	end
end

function MultiDropdown:Close()
	self._open = false
	AnimationManager:CreateTween(self.DropdownList, {
		Size = UDim2.new(1, 0, 0, 0)
	}, "Smooth", "Out", 0.2, function()
		self.DropdownList.Visible = false
	end)

	if self.ArrowIcon then
		AnimationManager:CreateTween(self.ArrowIcon, {
			Rotation = 0
		}, "Smooth", "Out", 0.2)
	end
end

function MultiDropdown:GetValue()
	local result = {}
	for item, selected in self._selected do
		if selected then
			table.insert(result, item)
		end
	end
	return result
end

function MultiDropdown:SetItems(items)
	self.Items = items
	for _, data in self._itemButtons do
		data.Button:Destroy()
	end
	self._itemButtons = {}
	for _, item in ipairs(self.Items) do
		self:CreateItemButton(item)
	end
end

function MultiDropdown:SetCallback(callback)
	self.Callback = callback
end

function MultiDropdown:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.DropdownList, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.DropdownList.BackgroundColor3 = palette.SurfaceAlt
	end
end

function MultiDropdown:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.MultiDropdown = MultiDropdown


-- TextBox
local TextBox = {}
TextBox.__index = TextBox





function TextBox:New(section, options)
	options = options or {}

	local self = setmetatable({}, TextBox)

	self.Section = section
	self.Name = options.Name or "TextBox"
	self.Description = options.Description or nil
	self.Placeholder = options.Placeholder or "Type here..."
	self.Default = options.Default or ""
	self.ClearOnFocus = options.ClearOnFocus or false
	self.Callback = options.Callback or function() end
	self._value = self.Default

	local container = Instance.new("Frame")
	container.Name = "TextBox_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 50)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = container

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0.7, -10, 0, 18)
	nameLabel.Position = UDim2.new(0, 10, 0, 4)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.Parent = mainFrame
	self.NameLabel = nameLabel

	local inputBg = Instance.new("Frame")
	inputBg.Name = "InputBg"
	inputBg.Size = UDim2.new(1, -20, 0, 28)
	inputBg.Position = UDim2.new(0, 10, 1, -32)
	inputBg.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	inputBg.BorderSizePixel = 0
	inputBg.Parent = mainFrame
	self.InputBg = inputBg
	Utility:CreateCorner(inputBg, 6)
	Utility:CreateStroke(inputBg, ThemeManager:GetColor("Border"), 0.6, 1)

	local inputBox = Instance.new("TextBox")
	inputBox.Name = "Input"
	inputBox.Size = UDim2.new(1, -16, 1, 0)
	inputBox.Position = UDim2.new(0, 8, 0, 0)
	inputBox.BackgroundTransparency = 1
	inputBox.BorderSizePixel = 0
	inputBox.Text = self.Default
	inputBox.PlaceholderText = self.Placeholder
	inputBox.Font = Enum.Font.Gotham
	inputBox.TextSize = 13
	inputBox.TextColor3 = ThemeManager:GetColor("TextPrimary")
	inputBox.PlaceholderColor3 = ThemeManager:GetColor("TextMuted")
	inputBox.TextXAlignment = Enum.TextXAlignment.Left
	inputBox.TextYAlignment = Enum.TextYAlignment.Center
	inputBox.ClearTextOnFocus = self.ClearOnFocus
	inputBox.Parent = inputBg
	self.InputBox = inputBox

	local focusGlow = Instance.new("Frame")
	focusGlow.Name = "FocusGlow"
	focusGlow.Size = UDim2.new(1, 0, 1, 0)
	focusGlow.BackgroundColor3 = ThemeManager:GetColor("Accent")
	focusGlow.BackgroundTransparency = 1
	focusGlow.BorderSizePixel = 0
	focusGlow.ZIndex = -1
	focusGlow.Parent = inputBg
	Utility:CreateCorner(focusGlow, 6)

	inputBox.Focused:Connect(function()
		AnimationManager:CreateTween(inputBg, {
			BackgroundColor3 = ThemeManager:GetColor("Surface")
		}, "Smooth", "Out", 0.15)
		AnimationManager:CreateTween(focusGlow, {
			BackgroundTransparency = 0.85
		}, "Smooth", "Out", 0.2)
		AnimationManager:CreateTween(inputBg, "UIStroke", nil, nil, 0.15)
	end)

	inputBox.FocusLost:Connect(function(enterPressed)
		AnimationManager:CreateTween(inputBg, {
			BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
		}, "Smooth", "Out", 0.2)
		AnimationManager:CreateTween(focusGlow, {
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.3)

		self._value = inputBox.Text
		pcall(self.Callback, inputBox.Text, enterPressed)
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function TextBox:GetValue()
	return self._value
end

function TextBox:SetValue(text)
	self._value = text
	self.InputBox.Text = text
end

function TextBox:SetCallback(callback)
	self.Callback = callback
end

function TextBox:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.NameLabel, {
			TextColor3 = palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.InputBg, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.NameLabel.TextColor3 = palette.TextPrimary
		self.InputBg.BackgroundColor3 = palette.SurfaceAlt
	end
end

function TextBox:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.TextBox = TextBox


-- Keybind
local Keybind = {}
Keybind.__index = Keybind

local UserInputService = game:GetService("UserInputService")





local KEY_NAMES = {
	[Enum.KeyCode.LeftShift] = "LShift",
	[Enum.KeyCode.RightShift] = "RShift",
	[Enum.KeyCode.LeftControl] = "LCtrl",
	[Enum.KeyCode.RightControl] = "RCtrl",
	[Enum.KeyCode.LeftAlt] = "LAlt",
	[Enum.KeyCode.RightAlt] = "RAlt",
	[Enum.KeyCode.CapsLock] = "Caps",
	[Enum.KeyCode.Space] = "Space",
	[Enum.KeyCode.Return] = "Enter",
	[Enum.KeyCode.Backspace] = "Bksp",
	[Enum.KeyCode.Tab] = "Tab",
	[Enum.KeyCode.Escape] = "Esc",
	[Enum.KeyCode.PageUp] = "PgUp",
	[Enum.KeyCode.PageDown] = "PgDn",
	[Enum.KeyCode.Unknown] = "...",
}

function Keybind:New(section, options)
	options = options or {}

	local self = setmetatable({}, Keybind)

	self.Section = section
	self.Name = options.Name or "Keybind"
	self.Description = options.Description or nil
	self.Default = options.Default or Enum.KeyCode.Unknown
	self.Callback = options.Callback or function() end
	self.ChangeCallback = options.ChangeCallback or function() end
	self._value = self.Default
	self._listening = false

	local container = Instance.new("Frame")
	container.Name = "Keybind_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 34)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 6)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0.6, -40, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.Parent = mainFrame
	self.NameLabel = nameLabel

	local keyButton = Instance.new("TextButton")
	keyButton.Name = "KeyButton"
	keyButton.Size = UDim2.new(0, 80, 0, 24)
	keyButton.Position = UDim2.new(1, -90, 0.5, -12)
	keyButton.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	keyButton.BackgroundTransparency = 0
	keyButton.BorderSizePixel = 0
	keyButton.Text = ""
	keyButton.AutoButtonColor = false
	keyButton.Parent = mainFrame
	self.KeyButton = keyButton
	Utility:CreateCorner(keyButton, 5)
	Utility:CreateStroke(keyButton, ThemeManager:GetColor("Border"), 0.6, 1)

	local keyLabel = Instance.new("TextLabel")
	keyLabel.Name = "KeyLabel"
	keyLabel.Size = UDim2.new(1, 0, 1, 0)
	keyLabel.BackgroundTransparency = 1
	keyLabel.BorderSizePixel = 0
	keyLabel.Text = self:GetKeyName(self._value)
	keyLabel.Font = Enum.Font.GothamSemibold
	keyLabel.TextSize = 12
	keyLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	keyLabel.TextXAlignment = Enum.TextXAlignment.Center
	keyLabel.TextYAlignment = Enum.TextYAlignment.Center
	keyLabel.Parent = keyButton
	self.KeyLabel = keyLabel

	keyButton.MouseEnter:Connect(function()
		AnimationManager:CreateTween(keyButton, {
			BackgroundTransparency = 0.15
		}, "Smooth", "Out", 0.15)
	end)

	keyButton.MouseLeave:Connect(function()
		if not self._listening then
			AnimationManager:CreateTween(keyButton, {
				BackgroundTransparency = 0
			}, "Smooth", "Out", 0.2)
		end
	end)

	keyButton.MouseButton1Click:Connect(function()
		self:StartListening()
		SoundManager:PlayClick()
	end)

	self._inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if self._listening then
			if input.KeyCode ~= Enum.KeyCode.Unknown then
				self._value = input.KeyCode
				self.KeyLabel.Text = self:GetKeyName(input.KeyCode)
				self:StopListening()
				pcall(self.ChangeCallback, input.KeyCode)
				SoundManager:PlaySuccess()
			end
		else
			if input.KeyCode == self._value and not gameProcessed then
				pcall(self.Callback)
			end
		end
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Keybind:StartListening()
	self._listening = true
	self.KeyLabel.Text = "..."
	AnimationManager:CreateTween(self.KeyButton, {
		BackgroundColor3 = ThemeManager:GetColor("Accent")
	}, "Smooth", "Out", 0.15)
	AnimationManager:CreateTween(self.KeyLabel, {
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}, "Smooth", "Out", 0.15)
end

function Keybind:StopListening()
	self._listening = false
	AnimationManager:CreateTween(self.KeyButton, {
		BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	}, "Smooth", "Out", 0.2)
	AnimationManager:CreateTween(self.KeyLabel, {
		TextColor3 = ThemeManager:GetColor("TextSecondary")
	}, "Smooth", "Out", 0.2)
end

function Keybind:GetKeyName(keyCode)
	local name = KEY_NAMES[keyCode]
	if name then
		return name
	end
	return keyCode.Name
end

function Keybind:GetValue()
	return self._value
end

function Keybind:SetKey(keyCode)
	self._value = keyCode
	self.KeyLabel.Text = self:GetKeyName(keyCode)
	pcall(self.ChangeCallback, keyCode)
end

function Keybind:SetCallback(callback)
	self.Callback = callback
end

function Keybind:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.NameLabel, {
			TextColor3 = palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
		if not self._listening then
			AnimationManager:CreateTween(self.KeyButton, {
				BackgroundColor3 = palette.SurfaceAlt,
			}, "Smooth", "Out", 0.3)
		end
	else
		self.NameLabel.TextColor3 = palette.TextPrimary
		if not self._listening then
			self.KeyButton.BackgroundColor3 = palette.SurfaceAlt
		end
	end
end

function Keybind:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	if self._inputConnection then
		self._inputConnection:Disconnect()
	end
	self.Container:Destroy()
end

NovaUI.Keybind = Keybind


-- Label
local Label = {}
Label.__index = Label





function Label:New(section, options)
	options = options or {}

	local self = setmetatable({}, Label)

	self.Section = section
	self.Text = options.Text or "Label"
	self.TextSize = options.TextSize or 14
	self.Color = options.Color or "TextPrimary"
	self.Font = options.Font or Enum.Font.Gotham
	self.Alignment = options.Alignment or "Left"
	self.Transparency = options.Transparency or 0

	local container = Instance.new("Frame")
	container.Name = "Label"
	container.Size = UDim2.new(1, 0, 0, 24)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 10, 0, 2)
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Text = self.Text
	label.Font = self.Font
	label.TextSize = self.TextSize
	label.TextColor3 = ThemeManager:GetColor(self.Color)
	label.TextTransparency = self.Transparency
	label.RichText = true
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = container
	self.Label = label

	if self.Alignment == "Center" then
		label.TextXAlignment = Enum.TextXAlignment.Center
	elseif self.Alignment == "Right" then
		label.TextXAlignment = Enum.TextXAlignment.Right
	else
		label.TextXAlignment = Enum.TextXAlignment.Left
	end
	label.TextYAlignment = Enum.TextYAlignment.Top

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Label:SetText(text)
	self.Text = text
	self.Label.Text = text
end

function Label:SetColor(colorKey)
	self.Color = colorKey
	self.Label.TextColor3 = ThemeManager:GetColor(colorKey)
end

function Label:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Label, {
			TextColor3 = palette[self.Color] or palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
	else
		self.Label.TextColor3 = palette[self.Color] or palette.TextPrimary
	end
end

function Label:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Label = Label


-- Paragraph
local Paragraph = {}
Paragraph.__index = Paragraph




function Paragraph:New(section, options)
	options = options or {}

	local self = setmetatable({}, Paragraph)

	self.Section = section
	self.Title = options.Title or nil
	self.Text = options.Text or ""
	self.TextSize = options.TextSize or 13
	self.Color = options.Color or "TextSecondary"

	local container = Instance.new("Frame")
	container.Name = "Paragraph"
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	if self.Title then
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, -20, 0, 20)
		titleLabel.Position = UDim2.new(0, 10, 0, 2)
		titleLabel.BackgroundTransparency = 1
		titleLabel.BorderSizePixel = 0
		titleLabel.Text = self.Title
		titleLabel.Font = Enum.Font.GothamSemibold
		titleLabel.TextSize = 14
		titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextYAlignment = Enum.TextYAlignment.Top
		titleLabel.RichText = true
		titleLabel.TextWrapped = true
		titleLabel.AutomaticSize = Enum.AutomaticSize.Y
		titleLabel.Parent = container
		self.TitleLabel = titleLabel
	end

	local contentLabel = Instance.new("TextLabel")
	contentLabel.Name = "Content"
	contentLabel.Size = UDim2.new(1, -20, 0, 20)
	contentLabel.Position = UDim2.new(0, 10, 0, self.Title and 24 or 2)
	contentLabel.BackgroundTransparency = 1
	contentLabel.BorderSizePixel = 0
	contentLabel.Text = self.Text
	contentLabel.Font = Enum.Font.Gotham
	contentLabel.TextSize = self.TextSize
	contentLabel.TextColor3 = ThemeManager:GetColor(self.Color)
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextYAlignment = Enum.TextYAlignment.Top
	contentLabel.RichText = true
	contentLabel.TextWrapped = true
	contentLabel.AutomaticSize = Enum.AutomaticSize.Y
	contentLabel.Parent = container
	self.ContentLabel = contentLabel

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Paragraph:SetText(text)
	self.Text = text
	self.ContentLabel.Text = text
end

function Paragraph:UpdateTheme(palette, animate)
	if animate then
		if self.TitleLabel then
			AnimationManager:CreateTween(self.TitleLabel, {
				TextColor3 = palette.TextPrimary,
			}, "Smooth", "Out", 0.3)
		end
		AnimationManager:CreateTween(self.ContentLabel, {
			TextColor3 = palette[self.Color] or palette.TextSecondary,
		}, "Smooth", "Out", 0.3)
	else
		if self.TitleLabel then
			self.TitleLabel.TextColor3 = palette.TextPrimary
		end
		self.ContentLabel.TextColor3 = palette[self.Color] or palette.TextSecondary
	end
end

function Paragraph:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Paragraph = Paragraph


-- ColorPicker
local ColorPicker = {}
ColorPicker.__index = ColorPicker






function ColorPicker:New(section, options)
	options = options or {}

	local self = setmetatable({}, ColorPicker)

	self.Section = section
	self.Name = options.Name or "Color Picker"
	self.Default = options.Default or Color3.fromRGB(79, 124, 255)
	self.Callback = options.Callback or function() end
	self._value = self.Default
	self._open = false

	local container = Instance.new("Frame")
	container.Name = "ColorPicker_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 34)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 6)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0.7, -50, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.BorderSizePixel = 0
	nameLabel.Text = self.Name
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextSize = 14
	nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.Parent = mainFrame
	self.NameLabel = nameLabel

	local previewFrame = Instance.new("Frame")
	previewFrame.Name = "Preview"
	previewFrame.Size = UDim2.new(0, 24, 0, 24)
	previewFrame.Position = UDim2.new(1, -88, 0.5, -12)
	previewFrame.BackgroundColor3 = self._value
	previewFrame.BorderSizePixel = 0
	previewFrame.Parent = mainFrame
	self.PreviewFrame = previewFrame
	Utility:CreateCorner(previewFrame, 6)
	Utility:CreateStroke(previewFrame, ThemeManager:GetColor("Border"), 0.6, 1)

	local hexLabel = Instance.new("TextLabel")
	hexLabel.Name = "Hex"
	hexLabel.Size = UDim2.new(0, 54, 1, 0)
	hexLabel.Position = UDim2.new(1, -58, 0, 0)
	hexLabel.BackgroundTransparency = 1
	hexLabel.BorderSizePixel = 0
	hexLabel.Text = Utility:RGBToHex(self._value)
	hexLabel.Font = Enum.Font.Gotham
	hexLabel.TextSize = 12
	hexLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	hexLabel.TextXAlignment = Enum.TextXAlignment.Right
	hexLabel.TextYAlignment = Enum.TextYAlignment.Center
	hexLabel.Parent = mainFrame
	self.HexLabel = hexLabel

	local pickerFrame = Instance.new("Frame")
	pickerFrame.Name = "PickerPanel"
	pickerFrame.Size = UDim2.new(1, 0, 0, 160)
	pickerFrame.Position = UDim2.new(0, 0, 0, 36)
	pickerFrame.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	pickerFrame.BorderSizePixel = 0
	pickerFrame.Visible = false
	pickerFrame.Parent = container
	self.PickerFrame = pickerFrame
	Utility:CreateCorner(pickerFrame, 6)
	Utility:CreateStroke(pickerFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = pickerFrame

	local hue, sat, val = Color3.toHSV(self._value)
	self._hue = hue
	self._sat = sat or 0
	self._val = val or 1

	self:BuildPickerUI(pickerFrame)

	mainFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 0.1
		}, "Smooth", "Out", 0.15)
	end)

	mainFrame.MouseLeave:Connect(function()
		if not self._open then
			AnimationManager:CreateTween(mainFrame, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.2)
		end
	end)

	mainFrame.MouseButton1Click:Connect(function()
		self:Toggle()
		SoundManager:PlayClick()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function ColorPicker:BuildPickerUI(parent)
	local saturationFrame = Instance.new("Frame")
	saturationFrame.Name = "SaturationFrame"
	saturationFrame.Size = UDim2.new(1, -20, 1, -20)
	saturationFrame.Position = UDim2.new(0, 0, 0, 0)
	saturationFrame.BackgroundColor3 = Color3.fromHSV(self._hue, 1, 1)
	saturationFrame.BorderSizePixel = 0
	saturationFrame.ClipsDescendants = true
	saturationFrame.Parent = parent
	Utility:CreateCorner(saturationFrame, 4)
	self.SaturationFrame = saturationFrame

	local saturationGradientWhite = Instance.new("UIGradient")
	saturationGradientWhite.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
	})
	saturationGradientWhite.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	})
	saturationGradientWhite.Rotation = 90
	saturationGradientWhite.Parent = saturationFrame

	local saturationGradientBlack = Instance.new("UIGradient")
	saturationGradientBlack.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
	})
	saturationGradientBlack.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0)
	})
	saturationGradientBlack.Parent = saturationFrame

	local cursor = Instance.new("Frame")
	cursor.Name = "Cursor"
	cursor.Size = UDim2.new(0, 12, 0, 12)
	cursor.Position = UDim2.new(self._sat, -6, 1 - self._val, -6)
	cursor.BackgroundColor3 = self._value
	cursor.BorderSizePixel = 0
	cursor.ZIndex = 2
	cursor.Parent = saturationFrame
	self.SaturationCursor = cursor
	Utility:CreateCorner(cursor, 6)

	local cursorBorder = Instance.new("Frame")
	cursorBorder.Name = "CursorBorder"
	cursorBorder.Size = UDim2.new(1, 4, 1, 4)
	cursorBorder.Position = UDim2.new(-0.5, -2, -0.5, -2)
	cursorBorder.BackgroundTransparency = 1
	cursorBorder.BorderSizePixel = 1
	cursorBorder.BorderColor3 = Color3.fromRGB(255, 255, 255)
	cursorBorder.ZIndex = 1
	cursorBorder.Parent = cursor

	local hueBarFrame = Instance.new("Frame")
	hueBarFrame.Name = "HueBar"
	hueBarFrame.Size = UDim2.new(0, 16, 1, 0)
	hueBarFrame.Position = UDim2.new(1, -16, 0, 0)
	hueBarFrame.BackgroundColor3 = ThemeManager:GetColor("Surface")
	hueBarFrame.BorderSizePixel = 0
	hueBarFrame.ClipsDescendants = true
	hueBarFrame.Parent = saturationFrame
	Utility:CreateCorner(hueBarFrame, 4)
	self.HueBar = hueBarFrame

	local hueGradient = Instance.new("UIGradient")
	hueGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
	})
	hueGradient.Rotation = 90
	hueGradient.Parent = hueBarFrame

	local hueCursor = Instance.new("Frame")
	hueCursor.Name = "HueCursor"
	hueCursor.Size = UDim2.new(1, 0, 0, 8)
	hueCursor.Position = UDim2.new(0, 0, self._hue, -4)
	hueCursor.BackgroundColor3 = Color3.fromHSV(self._hue, 1, 1)
	hueCursor.BorderSizePixel = 0
	hueCursor.ZIndex = 3
	hueCursor.Parent = hueBarFrame
	self.HueCursor = hueCursor

	local function updateFromSaturation(inputX, inputY)
		local absPos = saturationFrame.AbsolutePosition
		local absSize = saturationFrame.AbsoluteSize
		local relX = math.clamp(inputX - absPos.X, 0, absSize.X - 20)
		local relY = math.clamp(inputY - absPos.Y, 0, absSize.Y)
		self._sat = relX / (absSize.X - 20)
		self._val = 1 - (relY / absSize.Y)

		local color = Color3.fromHSV(self._hue, self._sat, self._val)
		self._value = color

		cursor.Position = UDim2.new(self._sat, -6, 1 - self._val, -6)
		cursor.BackgroundColor3 = color
		self.SaturationFrame.BackgroundColor3 = Color3.fromHSV(self._hue, 1, 1)
		self.PreviewFrame.BackgroundColor3 = color
		self.HexLabel.Text = Utility:RGBToHex(color)
		pcall(self.Callback, color)
	end

	local function updateFromHue(inputY)
		local absPos = hueBarFrame.AbsolutePosition.Y
		local absSize = hueBarFrame.AbsoluteSize.Y
		local relY = math.clamp(inputY - absPos, 0, absSize)
		self._hue = relY / absSize

		local color = Color3.fromHSV(self._hue, self._sat, self._val)
		self._value = color

		hueCursor.Position = UDim2.new(0, 0, self._hue, -4)
		hueCursor.BackgroundColor3 = Color3.fromHSV(self._hue, 1, 1)
		self.SaturationFrame.BackgroundColor3 = Color3.fromHSV(self._hue, 1, 1)
		self.PreviewFrame.BackgroundColor3 = color
		self.HexLabel.Text = Utility:RGBToHex(color)
		pcall(self.Callback, color)
	end

	saturationFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateFromSaturation(input.Position.X, input.Position.Y)
		end
	end)

	hueBarFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateFromHue(input.Position.Y)
		end
	end)

	local draggingSat = false
	local draggingHue = false

	saturationFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSat = true
		end
	end)

	hueBarFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingHue = true
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if draggingSat and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateFromSaturation(input.Position.X, input.Position.Y)
		end
		if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateFromHue(input.Position.Y)
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingSat = false
			draggingHue = false
		end
	end)
end

function ColorPicker:Toggle()
	if self._open then
		self:Close()
	else
		self:Open()
	end
end

function ColorPicker:Open()
	self._open = true
	self.PickerFrame.Visible = true

	self.PickerFrame.Size = UDim2.new(1, 0, 0, 0)
	AnimationManager:CreateTween(self.PickerFrame, {
		Size = UDim2.new(1, 0, 0, 160)
	}, "Smooth", "Out", 0.25)
end

function ColorPicker:Close()
	self._open = false
	AnimationManager:CreateTween(self.PickerFrame, {
		Size = UDim2.new(1, 0, 0, 0)
	}, "Smooth", "Out", 0.2, function()
		self.PickerFrame.Visible = false
	end)
end

function ColorPicker:GetValue()
	return self._value
end

function ColorPicker:SetColor(color)
	self._value = color
	local h, s, v = Color3.toHSV(color)
	self._hue = h
	self._sat = s
	self._val = v
	self.PreviewFrame.BackgroundColor3 = color
	self.HexLabel.Text = Utility:RGBToHex(color)
	if self.SaturationFrame then
		self.SaturationFrame.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
	end
	if self.SaturationCursor then
		self.SaturationCursor.Position = UDim2.new(s, -6, 1 - v, -6)
		self.SaturationCursor.BackgroundColor3 = color
	end
	if self.HueCursor then
		self.HueCursor.Position = UDim2.new(0, 0, h, -4)
		self.HueCursor.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
	end
end

function ColorPicker:SetCallback(callback)
	self.Callback = callback
end

function ColorPicker:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.NameLabel, {
			TextColor3 = palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.PickerFrame, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.NameLabel.TextColor3 = palette.TextPrimary
		self.PickerFrame.BackgroundColor3 = palette.SurfaceAlt
	end
end

function ColorPicker:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.ColorPicker = ColorPicker


-- Notification
local Notification = {}
Notification.__index = Notification







local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local ACTIVE_NOTIFICATIONS = {}
local NOTIFICATION_HEIGHT = 60
local NOTIFICATION_GAP = 8

local function getNotificationParent()
	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	local parent = findParent()
	local notifGui = parent and parent:FindFirstChild("Nova_Notifications")
	if not notifGui then
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "Nova_Notifications"
		notifGui.DisplayOrder = 100
		notifGui.IgnoreGuiInset = true
		notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		notifGui.Parent = parent
	end

	return notifGui
end

function Notification:New(options)
	options = options or {}

	local self = setmetatable({}, Notification)

	self.Title = options.Title or "Notification"
	self.Message = options.Message or ""
	self.Duration = options.Duration or 4
	self.Type = options.Type or "Info"
	self.Icon = options.Icon or nil

	local parent = getNotificationParent()

	local container = Instance.new("Frame")
	container.Name = "Notification"
	container.Size = UDim2.new(0, 340, 0, NOTIFICATION_HEIGHT)
	container.Position = UDim2.new(1, 20, 1, -(20 + NOTIFICATION_HEIGHT))
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = parent
	self.Container = container

	Utility:CreateCorner(container, 8)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local typeColors = {
		Info = ThemeManager:GetColor("Info"),
		Success = ThemeManager:GetColor("Success"),
		Warning = ThemeManager:GetColor("Warning"),
		Error = ThemeManager:GetColor("Danger"),
	}

	local typeIcons = {
		Info = "Info",
		Success = "Check",
		Warning = "Warning",
		Error = "Cross",
	}

	local accentColor = typeColors[self.Type] or typeColors.Info

	local accentBar = Instance.new("Frame")
	accentBar.Name = "AccentBar"
	accentBar.Size = UDim2.new(0, 3, 1, 0)
	accentBar.BackgroundColor3 = accentColor
	accentBar.BorderSizePixel = 0
	accentBar.Parent = container

	local icon = IconManager:CreateIconLabel(container, self.Icon or typeIcons[self.Type], UDim2.new(0, 20, 0, 20), accentColor)
	if icon then
		icon.Position = UDim2.new(0, 14, 0.5, -10)
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -(icon and 48 or 28), 0, 18)
	titleLabel.Position = UDim2.new(0, (icon and 42 or 16), 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -(icon and 48 or 28), 0, 18)
	messageLabel.Position = UDim2.new(0, (icon and 42 or 16), 0, 26)
	messageLabel.BackgroundTransparency = 1
	messageLabel.BorderSizePixel = 0
	messageLabel.Text = self.Message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 12
	messageLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.TextWrapped = true
	messageLabel.Parent = container
	self.MessageLabel = messageLabel

	local progressBar = Instance.new("Frame")
	progressBar.Name = "Progress"
	progressBar.Size = UDim2.new(1, 0, 0, 2)
	progressBar.Position = UDim2.new(0, 0, 1, -2)
	progressBar.BackgroundColor3 = accentColor
	progressBar.BorderSizePixel = 0
	progressBar.Parent = container
	self.ProgressBar = progressBar

	container.Position = UDim2.new(1, 20, 1, -(20 + NOTIFICATION_HEIGHT))
	container.Visible = false

	table.insert(ACTIVE_NOTIFICATIONS, self)
	self:UpdatePositions()

	task.spawn(function()
		self:Show()
		task.wait(self.Duration)
		self:Hide()
	end)

	return self
end

function Notification:Show()
	self.Container.Visible = true

	AnimationManager:CreateTween(self.Container, {
		Position = UDim2.new(1, -(340 + 10), 1, -(20 + NOTIFICATION_HEIGHT))
	}, "Smooth", "Out", 0.4)

	AnimationManager:CreateTween(self.ProgressBar, {
		Size = UDim2.new(0, 0, 0, 2)
	}, "Linear", "In", self.Duration)

	self:UpdatePositions()

	SoundManager:PlayNotification()
end

function Notification:Hide()
	AnimationManager:CreateTween(self.Container, {
		Position = UDim2.new(1, 20, 1, -(20 + NOTIFICATION_HEIGHT))
	}, "Smooth", "In", 0.3, function()
		self:Destroy()
	end)
end

function Notification:UpdatePositions()
	local yOffset = 20
	for i = #ACTIVE_NOTIFICATIONS, 1, -1 do
		local notif = ACTIVE_NOTIFICATIONS[i]
		if notif and notif.Container then
			AnimationManager:CreateTween(notif.Container, {
				Position = UDim2.new(1, -(340 + 10), 1, -(yOffset + NOTIFICATION_HEIGHT))
			}, "Smooth", "Out", 0.35)
			yOffset = yOffset + NOTIFICATION_HEIGHT + NOTIFICATION_GAP
		end
	end
end

function Notification:Destroy()
	for i, n in ipairs(ACTIVE_NOTIFICATIONS) do
		if n == self then
			table.remove(ACTIVE_NOTIFICATIONS, i)
			break
		end
	end
	self:UpdatePositions()
	self.Container:Destroy()
end

function Notification:ClearAll()
	for i = #ACTIVE_NOTIFICATIONS, 1, -1 do
		local notif = ACTIVE_NOTIFICATIONS[i]
		if notif then
			notif:Hide()
		end
	end
end

NovaUI.Notification = Notification


-- Dialog
local Dialog = {}
Dialog.__index = Dialog







local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

function Dialog:New(options)
	options = options or {}

	local self = setmetatable({}, Dialog)

	self.Title = options.Title or "Dialog"
	self.Message = options.Message or ""
	self.Buttons = options.Buttons or {"OK", "Cancel"}
	self.DefaultButton = options.DefaultButton or 1
	self.Callback = options.Callback or function() end
	self.Type = options.Type or "Info"

	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	local parent = findParent()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_Dialog"
	screenGui.DisplayOrder = 200
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parent

	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 1
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	self.Overlay = overlay

	local container = Instance.new("Frame")
	container.Name = "Dialog"
	container.Size = UDim2.new(0, 360, 0, 0)
	container.Position = UDim2.new(0.5, -180, 0.5, 0)
	container.AnchorPoint = Vector2.new(0, 0.5)
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	container.Parent = screenGui
	self.Container = container
	Utility:CreateCorner(container, 10)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local typeIcons = {
		Info = "Info",
		Success = "Check",
		Warning = "Warning",
		Error = "Cross",
	}

	local typeColors = {
		Info = ThemeManager:GetColor("Info"),
		Success = ThemeManager:GetColor("Success"),
		Warning = ThemeManager:GetColor("Warning"),
		Error = ThemeManager:GetColor("Danger"),
	}

	local iconContainer = Instance.new("Frame")
	iconContainer.Name = "IconContainer"
	iconContainer.Size = UDim2.new(0, 40, 0, 40)
	iconContainer.Position = UDim2.new(0.5, -20, 0, 16)
	iconContainer.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	iconContainer.BorderSizePixel = 0
	iconContainer.Parent = container
	Utility:CreateCorner(iconContainer, 20)

	local dialogIcon = IconManager:CreateIconLabel(iconContainer, typeIcons[self.Type] or "Info", UDim2.new(0, 22, 0, 22), typeColors[self.Type] or typeColors.Info)
	if dialogIcon then
		dialogIcon.Position = UDim2.new(0.5, -11, 0.5, -11)
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -32, 0, 24)
	titleLabel.Position = UDim2.new(0, 16, 0, 64)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 18
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -32, 0, 20)
	messageLabel.Position = UDim2.new(0, 16, 0, 90)
	messageLabel.BackgroundTransparency = 1
	messageLabel.BorderSizePixel = 0
	messageLabel.Text = self.Message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 14
	messageLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	messageLabel.TextXAlignment = Enum.TextXAlignment.Center
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.TextWrapped = true
	messageLabel.AutomaticSize = Enum.AutomaticSize.Y
	messageLabel.Parent = container
	self.MessageLabel = messageLabel

	local buttonFrame = Instance.new("Frame")
	buttonFrame.Name = "Buttons"
	buttonFrame.Size = UDim2.new(1, -32, 0, 32)
	buttonFrame.Position = UDim2.new(0, 16, 1, -48)
	buttonFrame.BackgroundTransparency = 1
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Parent = container

	local buttonLayout = Instance.new("UIListLayout")
	buttonLayout.FillDirection = Enum.FillDirection.Horizontal
	buttonLayout.Padding = UDim.new(0, 8)
	buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
	buttonLayout.Parent = buttonFrame

	self._buttons = {}

	for i, btnText in ipairs(self.Buttons) do
		local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. btnText
		btn.Size = UDim2.new(0, math.max(80, #btnText * 10 + 20), 0, 32)
		btn.BackgroundColor3 = (i == self.DefaultButton) and ThemeManager:GetColor("Accent") or ThemeManager:GetColor("SurfaceAlt")
		btn.BackgroundTransparency = 0
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Parent = buttonFrame
		Utility:CreateCorner(btn, 6)

		if i ~= self.DefaultButton then
			Utility:CreateStroke(btn, ThemeManager:GetColor("Border"), 0.6, 1)
		end

		local btnLabel = Instance.new("TextLabel")
		btnLabel.Name = "Label"
		btnLabel.Size = UDim2.new(1, 0, 1, 0)
		btnLabel.BackgroundTransparency = 1
		btnLabel.BorderSizePixel = 0
		btnLabel.Text = btnText
		btnLabel.Font = Enum.Font.GothamSemibold
		btnLabel.TextSize = 13
		btnLabel.TextColor3 = (i == self.DefaultButton) and Color3.fromRGB(255, 255, 255) or ThemeManager:GetColor("TextSecondary")
		btnLabel.TextXAlignment = Enum.TextXAlignment.Center
		btnLabel.TextYAlignment = Enum.TextYAlignment.Center
		btnLabel.Parent = btn

		btn.MouseEnter:Connect(function()
			AnimationManager:CreateTween(btn, {
				BackgroundTransparency = 0.15
			}, "Smooth", "Out", 0.15)
		end)

		btn.MouseLeave:Connect(function()
			AnimationManager:CreateTween(btn, {
				BackgroundTransparency = 0
			}, "Smooth", "Out", 0.2)
		end)

		btn.MouseButton1Click:Connect(function()
			SoundManager:PlayClick()
			AnimationManager:CreateTween(screenGui, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.2)
			self:Close(function()
				pcall(self.Callback, btnText, i)
			end)
		end)

		self._buttons[btnText] = btn
	end

	container.Size = UDim2.new(0, 360, 0, container.AutomaticSize.Y)

	AnimationManager:CreateTween(overlay, {
		BackgroundTransparency = 0.4
	}, "Smooth", "Out", 0.3)

	container.Position = UDim2.new(0.5, -180, 0.5, 20)
	AnimationManager:CreateTween(container, {
		Position = UDim2.new(0.5, -180, 0.5, 0)
	}, "Smooth", "Out", 0.35)

	return self
end

function Dialog:Close(callback)
	AnimationManager:CreateTween(self.Overlay, {
		BackgroundTransparency = 1
	}, "Smooth", "Out", 0.2)

	AnimationManager:CreateTween(self.Container, {
		Position = UDim2.new(0.5, -180, 0.5, -50),
		BackgroundTransparency = 0.1
	}, "Smooth", "In", 0.25, function()
		self.Container.Parent:Destroy()
		if callback then
			callback()
		end
	end)
end

NovaUI.Dialog = Dialog


-- Tooltip
local Tooltip = {}
Tooltip.__index = Tooltip





local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player and Player:GetMouse()

local ACTIVE_TOOLTIP = nil

function Tooltip:New(target, text, options)
	options = options or {}

	local self = setmetatable({}, Tooltip)

	self.Target = target
	self.Text = text or ""
	self.Position = options.Position or "Top"
	self.Offset = options.Offset or Vector2.new(0, 8)
	self.MaxWidth = options.MaxWidth or 200
	self.Delay = options.Delay or 0.5

	local parent = target.Parent
	while parent and not parent:IsA("ScreenGui") do
		parent = parent.Parent
	end

	local tooltip = Instance.new("Frame")
	tooltip.Name = "Tooltip"
	tooltip.Size = UDim2.new(0, 0, 0, 0)
	tooltip.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	tooltip.BorderSizePixel = 0
	tooltip.Visible = false
	tooltip.ZIndex = 1000
	tooltip.Parent = target
	self.Tooltip = tooltip
	Utility:CreateCorner(tooltip, 5)
	Utility:CreateStroke(tooltip, ThemeManager:GetColor("Border"), 0.5, 1)

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.Size = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Text = self.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextColor3 = ThemeManager:GetColor("TextPrimary")
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextWrapped = true
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.Parent = tooltip
	self.Label = label

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 6)
	padding.PaddingBottom = UDim.new(0, 6)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = tooltip

	local hoverConnection
	local leaveConnection

	hoverConnection = target.MouseEnter:Connect(function()
		if ACTIVE_TOOLTIP and ACTIVE_TOOLTIP ~= self then
			ACTIVE_TOOLTIP:Hide()
		end
		ACTIVE_TOOLTIP = self
		task.delay(self.Delay, function()
			if ACTIVE_TOOLTIP == self then
				self:Show()
			end
		end)
	end)

	leaveConnection = target.MouseLeave:Connect(function()
		if ACTIVE_TOOLTIP == self then
			ACTIVE_TOOLTIP = nil
		end
		self:Hide()
	end)

	self._hoverConnection = hoverConnection
	self._leaveConnection = leaveConnection

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Tooltip:Show()
	local textSize = self.Label.TextBounds
	local width = math.min(textSize.X + 20, self.MaxWidth)
	local height = textSize.Y + 12

	self.Tooltip.Size = UDim2.new(0, width, 0, 0)
	self.Tooltip.Visible = true
	self.Label.Size = UDim2.new(1, -20, 0, height - 12)

	local targetPos = self.Target.AbsolutePosition
	local targetSize = self.Target.AbsoluteSize
	local tipPosition

	if self.Position == "Top" then
		tipPosition = UDim2.new(0.5, -width / 2, 0, -(height + self.Offset.Y))
	elseif self.Position == "Bottom" then
		tipPosition = UDim2.new(0.5, -width / 2, 1, self.Offset.Y)
	elseif self.Position == "Left" then
		tipPosition = UDim2.new(0, -(width + self.Offset.X), 0.5, -height / 2)
	elseif self.Position == "Right" then
		tipPosition = UDim2.new(1, self.Offset.X, 0.5, -height / 2)
	end

	self.Tooltip.Position = tipPosition

	AnimationManager:CreateTween(self.Tooltip, {
		Size = UDim2.new(0, width, 0, height)
	}, "Smooth", "Out", 0.2)
end

function Tooltip:Hide()
	if not self.Tooltip.Visible then
		return
	end
	AnimationManager:CreateTween(self.Tooltip, {
		Size = UDim2.new(0, 0, 0, 0)
	}, "Smooth", "Out", 0.15, function()
		self.Tooltip.Visible = false
	end)
end

function Tooltip:SetText(text)
	self.Text = text
	self.Label.Text = text
end

function Tooltip:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Tooltip, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.Tooltip.BackgroundColor3 = palette.SurfaceAlt
	end
end

function Tooltip:Destroy()
	if ACTIVE_TOOLTIP == self then
		ACTIVE_TOOLTIP = nil
	end
	if self._hoverConnection then
		self._hoverConnection:Disconnect()
	end
	if self._leaveConnection then
		self._leaveConnection:Disconnect()
	end
	if self._themeConnection then
		self._themeConnection()
	end
	self.Tooltip:Destroy()
end

NovaUI.Tooltip = Tooltip


-- Separator
local Separator = {}
Separator.__index = Separator




function Separator:New(section, options)
	options = options or {}

	local self = setmetatable({}, Separator)

	self.Section = section
	self.Text = options.Text or nil
	self.Padding = options.Padding or 8

	local container = Instance.new("Frame")
	container.Name = "Separator"
	container.Size = UDim2.new(1, 0, 0, self.Text and 28 or 12)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	if self.Text then
		local label = Instance.new("TextLabel")
		label.Name = "Text"
		label.Size = UDim2.new(0, 0, 0, 16)
		label.Position = UDim2.new(0, 10, 0.5, -8)
		label.BackgroundTransparency = 1
		label.BorderSizePixel = 0
		label.Text = self.Text
		label.Font = Enum.Font.GothamSemibold
		label.TextSize = 12
		label.TextColor3 = ThemeManager:GetColor("TextMuted")
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.AutomaticSize = Enum.AutomaticSize.X
		label.Parent = container
		self.Label = label

		local line1 = Instance.new("Frame")
		line1.Name = "Line1"
		line1.Size = UDim2.new(0, 6, 0, 1)
		line1.Position = UDim2.new(0, 0, 0.5, -0.5)
		line1.BackgroundColor3 = ThemeManager:GetColor("Border")
		line1.BorderSizePixel = 0
		line1.Parent = container

		local line2 = Instance.new("Frame")
		line2.Name = "Line2"
		line2.Size = UDim2.new(1, -(label.AutomaticSize.X + 26), 0, 1)
		line2.Position = UDim2.new(0, label.AutomaticSize.X + 16, 0.5, -0.5)
		line2.BackgroundColor3 = ThemeManager:GetColor("Border")
		line2.BorderSizePixel = 0
		line2.Parent = container
		self.Line2 = line2
	else
		local line = Instance.new("Frame")
		line.Name = "Line"
		line.Size = UDim2.new(1, -20, 0, 1)
		line.Position = UDim2.new(0, 10, 0.5, -0.5)
		line.BackgroundColor3 = ThemeManager:GetColor("Border")
		line.BorderSizePixel = 0
		line.Parent = container
		self.Line = line
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Separator:UpdateTheme(palette, animate)
	local lineColor = palette.Border
	if animate then
		if self.Line then
			AnimationManager:CreateTween(self.Line, {
				BackgroundColor3 = lineColor,
			}, "Smooth", "Out", 0.3)
		end
		if self.Line2 then
			AnimationManager:CreateTween(self.Line2, {
				BackgroundColor3 = lineColor,
			}, "Smooth", "Out", 0.3)
		end
	else
		if self.Line then self.Line.BackgroundColor3 = lineColor end
		if self.Line2 then self.Line2.BackgroundColor3 = lineColor end
	end
end

function Separator:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Separator = Separator


-- ProgressBar
local ProgressBar = {}
ProgressBar.__index = ProgressBar





function ProgressBar:New(section, options)
	options = options or {}

	local self = setmetatable({}, ProgressBar)

	self.Section = section
	self.Name = options.Name or "Progress"
	self.Default = options.Default or 0
	self.Max = options.Max or 100
	self.Suffix = options.Suffix or "%"
	self.Color = options.Color or "Accent"
	self.ShowLabel = options.ShowLabel or true
	self.Callback = options.Callback or function() end
	self._value = self.Default

	local container = Instance.new("Frame")
	container.Name = "ProgressBar_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 40)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	if self.Name then
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "Name"
		nameLabel.Size = UDim2.new(1, -56, 0, 18)
		nameLabel.Position = UDim2.new(0, 10, 0, 4)
		nameLabel.BackgroundTransparency = 1
		nameLabel.BorderSizePixel = 0
		nameLabel.Text = self.Name
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextSize = 14
		nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextYAlignment = Enum.TextYAlignment.Center
		nameLabel.Parent = container
		self.NameLabel = nameLabel

		if self.ShowLabel then
			local valueLabel = Instance.new("TextLabel")
			valueLabel.Name = "Value"
			valueLabel.Size = UDim2.new(0, 46, 0, 18)
			valueLabel.Position = UDim2.new(1, -56, 0, 4)
			valueLabel.BackgroundTransparency = 1
			valueLabel.BorderSizePixel = 0
			valueLabel.Text = tostring(self._value) .. self.Suffix
			valueLabel.Font = Enum.Font.GothamSemibold
			valueLabel.TextSize = 13
			valueLabel.TextColor3 = ThemeManager:GetColor(self.Color)
			valueLabel.TextXAlignment = Enum.TextXAlignment.Right
			valueLabel.TextYAlignment = Enum.TextYAlignment.Center
			valueLabel.Parent = container
			self.ValueLabel = valueLabel
		end
	end

	local trackFrame = Instance.new("Frame")
	trackFrame.Name = "Track"
	trackFrame.Size = UDim2.new(1, -20, 0, 6)
	trackFrame.Position = UDim2.new(0, 10, 1, -12)
	trackFrame.BackgroundColor3 = ThemeManager:GetColor("Border")
	trackFrame.BorderSizePixel = 0
	trackFrame.Parent = container
	self.TrackFrame = trackFrame
	Utility:CreateCorner(trackFrame, 3)

	local fillFrame = Instance.new("Frame")
	fillFrame.Name = "Fill"
	fillFrame.Size = UDim2.new(0, 0, 1, 0)
	fillFrame.BackgroundColor3 = ThemeManager:GetColor(self.Color)
	fillFrame.BorderSizePixel = 0
	fillFrame.Parent = trackFrame
	self.FillFrame = fillFrame
	Utility:CreateCorner(fillFrame, 3)

	local glowFrame = Instance.new("Frame")
	glowFrame.Name = "Glow"
	glowFrame.Size = UDim2.new(0, 0, 1, 4)
	glowFrame.Position = UDim2.new(0, 0, 0.5, -2)
	glowFrame.BackgroundColor3 = ThemeManager:GetColor(self.Color)
	glowFrame.BackgroundTransparency = 0.5
	glowFrame.BorderSizePixel = 0
	glowFrame.Parent = trackFrame
	Utility:CreateCorner(glowFrame, 3)
	self.GlowFrame = glowFrame

	self:SetValue(self.Default, true)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function ProgressBar:SetValue(value, instant)
	self._value = Utility:Clamp(value, 0, self.Max)
	local trackWidth = self.TrackFrame.AbsoluteSize.X
	if trackWidth == 0 then
		trackWidth = self.TrackFrame.Size.X.Offset
	end
	local fraction = self._value / self.Max
	local fillWidth = fraction * trackWidth

	if instant then
		self.FillFrame.Size = UDim2.new(0, fillWidth, 1, 0)
		self.GlowFrame.Size = UDim2.new(0, fillWidth, 1, 4)
	else
		AnimationManager:CreateTween(self.FillFrame, {
			Size = UDim2.new(0, fillWidth, 1, 0)
		}, "Smooth", "Out", 0.35)
		AnimationManager:CreateTween(self.GlowFrame, {
			Size = UDim2.new(0, fillWidth, 1, 4)
		}, "Smooth", "Out", 0.35)
	end

	if self.ValueLabel then
		self.ValueLabel.Text = tostring(math.floor(self._value * 10) / 10) .. self.Suffix
	end

	pcall(self.Callback, self._value)
end

function ProgressBar:GetValue()
	return self._value
end

function ProgressBar:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.FillFrame, {
			BackgroundColor3 = palette[self.Color] or palette.Accent,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.GlowFrame, {
			BackgroundColor3 = palette[self.Color] or palette.Accent,
		}, "Smooth", "Out", 0.3)
	else
		self.FillFrame.BackgroundColor3 = palette[self.Color] or palette.Accent
		self.GlowFrame.BackgroundColor3 = palette[self.Color] or palette.Accent
	end
end

function ProgressBar:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.ProgressBar = ProgressBar


-- SearchBar
local SearchBar = {}
SearchBar.__index = SearchBar






function SearchBar:New(section, options)
	options = options or {}

	local self = setmetatable({}, SearchBar)

	self.Section = section
	self.Placeholder = options.Placeholder or "Search..."
	self.Callback = options.Callback or function() end
	self.Instant = options.Instant or true

	local container = Instance.new("Frame")
	container.Name = "SearchBar"
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local inputBg = Instance.new("Frame")
	inputBg.Name = "InputBg"
	inputBg.Size = UDim2.new(1, -20, 1, -8)
	inputBg.Position = UDim2.new(0, 10, 0, 4)
	inputBg.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	inputBg.BorderSizePixel = 0
	inputBg.Parent = container
	self.InputBg = inputBg
	Utility:CreateCorner(inputBg, 6)
	Utility:CreateStroke(inputBg, ThemeManager:GetColor("Border"), 0.6, 1)

	local searchIcon = IconManager:CreateIconLabel(inputBg, "Search", UDim2.new(0, 16, 0, 16), ThemeManager:GetColor("TextMuted"))
	if searchIcon then
		searchIcon.Position = UDim2.new(0, 10, 0.5, -8)
	end

	local inputBox = Instance.new("TextBox")
	inputBox.Name = "Input"
	inputBox.Size = UDim2.new(1, -(searchIcon and 36 or 16), 1, 0)
	inputBox.Position = UDim2.new(0, (searchIcon and 34 or 8), 0, 0)
	inputBox.BackgroundTransparency = 1
	inputBox.BorderSizePixel = 0
	inputBox.Text = ""
	inputBox.PlaceholderText = self.Placeholder
	inputBox.Font = Enum.Font.Gotham
	inputBox.TextSize = 13
	inputBox.TextColor3 = ThemeManager:GetColor("TextPrimary")
	inputBox.PlaceholderColor3 = ThemeManager:GetColor("TextMuted")
	inputBox.TextXAlignment = Enum.TextXAlignment.Left
	inputBox.TextYAlignment = Enum.TextYAlignment.Center
	inputBox.ClearTextOnFocus = false
	inputBox.Parent = inputBg
	self.InputBox = inputBox

	local clearBtn = Instance.new("TextButton")
	clearBtn.Name = "ClearBtn"
	clearBtn.Size = UDim2.new(0, 24, 0, 24)
	clearBtn.Position = UDim2.new(1, -28, 0.5, -12)
	clearBtn.BackgroundTransparency = 1
	clearBtn.BorderSizePixel = 0
	clearBtn.Text = ""
	clearBtn.Visible = false
	clearBtn.Parent = inputBg
	self.ClearBtn = clearBtn

	local clearIcon = IconManager:CreateIconLabel(clearBtn, "Close", UDim2.new(0, 12, 0, 12), ThemeManager:GetColor("TextMuted"))
	if clearIcon then
		clearIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
	end

	local focusGlow = Instance.new("Frame")
	focusGlow.Name = "FocusGlow"
	focusGlow.Size = UDim2.new(1, 0, 1, 0)
	focusGlow.BackgroundColor3 = ThemeManager:GetColor("Accent")
	focusGlow.BackgroundTransparency = 1
	focusGlow.BorderSizePixel = 0
	focusGlow.ZIndex = -1
	focusGlow.Parent = inputBg
	Utility:CreateCorner(focusGlow, 6)

	inputBox.Focused:Connect(function()
		AnimationManager:CreateTween(inputBg, {
			BackgroundColor3 = ThemeManager:GetColor("Surface")
		}, "Smooth", "Out", 0.15)
		AnimationManager:CreateTween(focusGlow, {
			BackgroundTransparency = 0.85
		}, "Smooth", "Out", 0.2)
	end)

	inputBox.FocusLost:Connect(function()
		AnimationManager:CreateTween(inputBg, {
			BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
		}, "Smooth", "Out", 0.2)
		AnimationManager:CreateTween(focusGlow, {
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.3)
		if not self.Instant then
			pcall(self.Callback, inputBox.Text)
		end
	end)

	if self.Instant then
		inputBox:GetPropertyChangedSignal("Text"):Connect(function()
			pcall(self.Callback, inputBox.Text)
			clearBtn.Visible = #inputBox.Text > 0
		end)
	end

	clearBtn.MouseButton1Click:Connect(function()
		inputBox.Text = ""
		clearBtn.Visible = false
		inputBox:CaptureFocus()
		pcall(self.Callback, "")
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function SearchBar:GetValue()
	return self.InputBox.Text
end

function SearchBar:SetValue(text)
	self.InputBox.Text = text
	self.ClearBtn.Visible = #text > 0
end

function SearchBar:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.InputBg, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.InputBg.BackgroundColor3 = palette.SurfaceAlt
	end
end

function SearchBar:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.SearchBar = SearchBar


-- MiniConsole
local MiniConsole = {}
MiniConsole.__index = MiniConsole






function MiniConsole:New(section, options)
	options = options or {}

	local self = setmetatable({}, MiniConsole)

	self.Section = section
	self.Name = options.Name or "Console"
	self.MaxLines = options.MaxLines or 100
	self.AutoScroll = options.AutoScroll or true
	self.LinePrefix = options.LinePrefix or "> "

	local container = Instance.new("Frame")
	container.Name = "MiniConsole_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 160)
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	self.Container = container
	Utility:CreateCorner(container, 8)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local titleFrame = Instance.new("Frame")
	titleFrame.Name = "TitleFrame"
	titleFrame.Size = UDim2.new(1, 0, 0, 28)
	titleFrame.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	titleFrame.BorderSizePixel = 0
	titleFrame.Parent = container
	Utility:CreateCorner(titleFrame, 8)

	local titleBarBottom = Instance.new("Frame")
	titleBarBottom.Name = "BottomLine"
	titleBarBottom.Size = UDim2.new(1, 0, 0, 1)
	titleBarBottom.Position = UDim2.new(0, 0, 1, 0)
	titleBarBottom.BackgroundColor3 = ThemeManager:GetColor("Border")
	titleBarBottom.BorderSizePixel = 0
	titleBarBottom.Parent = titleFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -40, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Name
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = titleFrame

	local clearBtn = Instance.new("TextButton")
	clearBtn.Name = "ClearBtn"
	clearBtn.Size = UDim2.new(0, 16, 0, 16)
	clearBtn.Position = UDim2.new(1, -24, 0.5, -8)
	clearBtn.BackgroundTransparency = 1
	clearBtn.BorderSizePixel = 0
	clearBtn.Text = ""
	clearBtn.Parent = titleFrame

	local clearIcon = IconManager:CreateIconLabel(clearBtn, "Trash", UDim2.new(0, 12, 0, 12), ThemeManager:GetColor("TextMuted"))
	if clearIcon then
		clearIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
	end

	local textFrame = Instance.new("ScrollingFrame")
	textFrame.Name = "TextFrame"
	textFrame.Size = UDim2.new(1, -8, 1, -(titleFrame.Size.Y.Offset + 4))
	textFrame.Position = UDim2.new(0, 4, 0, titleFrame.Size.Y.Offset + 2)
	textFrame.BackgroundTransparency = 1
	textFrame.BorderSizePixel = 0
	textFrame.ScrollBarThickness = 2
	textFrame.ScrollBarImageColor3 = ThemeManager:GetColor("Accent")
	textFrame.ScrollBarImageTransparency = 0.6
	textFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	textFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	textFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	textFrame.ElasticBehavior = Enum.ElasticBehavior.Never
	textFrame.Parent = container
	self.TextFrame = textFrame

	local textListLayout = Instance.new("UIListLayout")
	textListLayout.FillDirection = Enum.FillDirection.Vertical
	textListLayout.Padding = UDim.new(0, 2)
	textListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	textListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	textListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	textListLayout.Parent = textFrame

	self._lines = {}

	clearBtn.MouseButton1Click:Connect(function()
		self:Clear()
		SoundManager:PlayClick()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function MiniConsole:Log(message, messageType)
	messageType = messageType or "Info"
	local colors = {
		Info = ThemeManager:GetColor("TextSecondary"),
		Success = ThemeManager:GetColor("Success"),
		Warning = ThemeManager:GetColor("Warning"),
		Error = ThemeManager:GetColor("Danger"),
		Command = ThemeManager:GetColor("Accent"),
	}
	local color = colors[messageType] or colors.Info

	local line = Instance.new("TextLabel")
	line.Name = "Line"
	line.Size = UDim2.new(1, -8, 0, 16)
	line.BackgroundTransparency = 1
	line.BorderSizePixel = 0
	line.Text = self.LinePrefix .. tostring(message)
	line.Font = Enum.Font.Code
	line.TextSize = 12
	line.TextColor3 = color
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.TextYAlignment = Enum.TextYAlignment.Center
	line.TextWrapped = true
	line.AutomaticSize = Enum.AutomaticSize.Y
	line.Parent = self.TextFrame

	table.insert(self._lines, line)

	while #self._lines > self.MaxLines do
		local old = table.remove(self._lines, 1)
		if old then
			old:Destroy()
		end
	end

	if self.AutoScroll then
		task.wait()
		self.TextFrame.CanvasPosition = Vector2.new(0, self.TextFrame.CanvasSize.Y.Offset)
	end
end

function MiniConsole:Warn(message)
	self:Log(message, "Warning")
end

function MiniConsole:Error(message)
	self:Log(message, "Error")
end

function MiniConsole:Success(message)
	self:Log(message, "Success")
end

function MiniConsole:Command(message)
	self:Log(message, "Command")
end

function MiniConsole:Clear()
	for _, line in ipairs(self._lines) do
		line:Destroy()
	end
	self._lines = {}
	self.TextFrame.CanvasPosition = Vector2.new(0, 0)
end

function MiniConsole:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Container, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(titleFrame, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.Container.BackgroundColor3 = palette.Surface
		titleFrame.BackgroundColor3 = palette.SurfaceAlt
	end
end

function MiniConsole:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.MiniConsole = MiniConsole


-- Image
local Image = {}
Image.__index = Image





function Image:New(section, options)
	options = options or {}

	local self = setmetatable({}, Image)

	self.Section = section
	self.ImageId = options.ImageId or ""
	self.Size = options.Size or UDim2.new(1, -20, 0, 120)
	self.KeepAspect = options.KeepAspect or false
	self.CornerRadius = options.CornerRadius or 6
	self.Caption = options.Caption or nil

	local container = Instance.new("Frame")
	container.Name = "Image"
	container.Size = UDim2.new(1, 0, 0, self.Size.Y.Offset + (self.Caption and 24 or 0) + 12)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local imageFrame = Instance.new("Frame")
	imageFrame.Name = "ImageFrame"
	imageFrame.Size = self.Size
	imageFrame.Position = UDim2.new(0, 10, 0, 6)
	imageFrame.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	imageFrame.BorderSizePixel = 0
	imageFrame.ClipsDescendants = true
	imageFrame.Parent = container
	Utility:CreateCorner(imageFrame, self.CornerRadius)
	Utility:CreateStroke(imageFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "ImageLabel"
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.BorderSizePixel = 0
	imageLabel.Image = self.ImageId
	imageLabel.ScaleType = self.KeepAspect and Enum.ScaleType.Fit or Enum.ScaleType.Crop
	imageLabel.Parent = imageFrame
	self.ImageLabel = imageLabel

	if self.Caption then
		local captionLabel = Instance.new("TextLabel")
		captionLabel.Name = "Caption"
		captionLabel.Size = UDim2.new(1, -20, 0, 18)
		captionLabel.Position = UDim2.new(0, 10, 0, self.Size.Y.Offset + 10)
		captionLabel.BackgroundTransparency = 1
		captionLabel.BorderSizePixel = 0
		captionLabel.Text = self.Caption
		captionLabel.Font = Enum.Font.Gotham
		captionLabel.TextSize = 12
		captionLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
		captionLabel.TextXAlignment = Enum.TextXAlignment.Center
		captionLabel.TextYAlignment = Enum.TextYAlignment.Center
		captionLabel.Parent = container
		self.CaptionLabel = captionLabel
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Image:SetImage(imageId)
	self.ImageId = imageId
	self.ImageLabel.Image = imageId
end

function Image:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(imageFrame, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		imageFrame.BackgroundColor3 = palette.SurfaceAlt
	end
end

function Image:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Image = Image


-- Icon
local Icon = {}
Icon.__index = Icon





function Icon:New(section, options)
	options = options or {}

	local self = setmetatable({}, Icon)

	self.Section = section
	self.IconName = options.IconName or "Circle"
	self.Size = options.Size or UDim2.new(0, 24, 0, 24)
	self.Color = options.Color or "TextSecondary"
	self.Label = options.Label or nil
	self.LabelPosition = options.LabelPosition or "Right"

	local container = Instance.new("Frame")
	container.Name = "Icon"
	container.Size = UDim2.new(1, 0, 0, math.max(self.Size.Y.Offset, 24) + 8)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local iconContainer = Instance.new("Frame")
	iconContainer.Name = "IconContainer"
	iconContainer.Size = UDim2.new(0, self.Size.X.Offset, 0, self.Size.Y.Offset)
	iconContainer.Position = UDim2.new(0, 10, 0.5, -self.Size.Y.Offset / 2)
	iconContainer.BackgroundTransparency = 1
	iconContainer.BorderSizePixel = 0
	iconContainer.Parent = container

	local iconLabel = IconManager:CreateIconLabel(iconContainer, self.IconName, self.Size, ThemeManager:GetColor(self.Color))
	if iconLabel then
		iconLabel.Position = UDim2.new(0, 0, 0, 0)
		self.IconLabel = iconLabel
	end

	if self.Label then
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Label"
		textLabel.Size = UDim2.new(0, 0, 0, 20)
		textLabel.Position = UDim2.new(0, self.Size.X.Offset + 8, 0.5, -10)
		textLabel.BackgroundTransparency = 1
		textLabel.BorderSizePixel = 0
		textLabel.Text = self.Label
		textLabel.Font = Enum.Font.Gotham
		textLabel.TextSize = 14
		textLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Center
		textLabel.AutomaticSize = Enum.AutomaticSize.X
		textLabel.Parent = container
		self.TextLabel = textLabel
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Icon:SetIcon(iconName)
	self.IconName = iconName
	if self.IconLabel then
		IconManager:SetIcon(self.IconLabel, iconName)
	end
end

function Icon:SetColor(colorKey)
	self.Color = colorKey
	if self.IconLabel then
		self.IconLabel.ImageColor3 = ThemeManager:GetColor(colorKey)
	end
end

function Icon:UpdateTheme(palette, animate)
	if self.IconLabel then
		if animate then
			AnimationManager:CreateTween(self.IconLabel, {
				ImageColor3 = palette[self.Color] or palette.TextSecondary,
			}, "Smooth", "Out", 0.3)
		else
			self.IconLabel.ImageColor3 = palette[self.Color] or palette.TextSecondary
		end
	end
end

function Icon:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

NovaUI.Icon = Icon


-- LoadingScreen
local LoadingScreen = {}
LoadingScreen.__index = LoadingScreen





local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local ACTIVE_LOADING = nil

function LoadingScreen:New(options)
	options = options or {}

	local self = setmetatable({}, LoadingScreen)

	self.Title = options.Title or "Loading"
	self.Message = options.Message or "Please wait..."
	self.Icon = options.Icon or "Circle"
	self.AutoDestroy = options.AutoDestroy or false
	self.Duration = options.Duration or 0

	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	local parent = findParent()

	if ACTIVE_LOADING then
		ACTIVE_LOADING:Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_LoadingScreen"
	screenGui.DisplayOrder = 999
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parent

	local overlay = Instance.new("Frame")
	overlay.Name = "Overlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.6
	overlay.BorderSizePixel = 0
	overlay.Parent = screenGui
	self.Overlay = overlay

	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 200, 0, 120)
	container.Position = UDim2.new(0.5, -100, 0.5, -60)
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.Parent = screenGui
	Utility:CreateCorner(container, 10)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local spinnerContainer = Instance.new("Frame")
	spinnerContainer.Name = "Spinner"
	spinnerContainer.Size = UDim2.new(0, 32, 0, 32)
	spinnerContainer.Position = UDim2.new(0.5, -16, 0, 16)
	spinnerContainer.BackgroundTransparency = 1
	spinnerContainer.BorderSizePixel = 0
	spinnerContainer.Parent = container

	local spinner = Instance.new("Frame")
	spinner.Name = "SpinnerInner"
	spinner.Size = UDim2.new(1, 0, 1, 0)
	spinner.BackgroundTransparency = 1
	spinner.BorderSizePixel = 0
	spinner.Parent = spinnerContainer
	self.Spinner = spinner

	local spinnerArc = Instance.new("UICorner")
	spinnerArc.CornerRadius = UDim.new(1, 0)
	spinnerArc.Parent = spinner

	local spinnerStroke = Instance.new("UIStroke")
	spinnerStroke.Color = ThemeManager:GetColor("Accent")
	spinnerStroke.Thickness = 3
	spinnerStroke.Transparency = 0
	spinnerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	spinnerStroke.Parent = spinner

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 54)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -20, 0, 16)
	messageLabel.Position = UDim2.new(0, 10, 0, 76)
	messageLabel.BackgroundTransparency = 1
	messageLabel.BorderSizePixel = 0
	messageLabel.Text = self.Message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 12
	messageLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
	messageLabel.TextXAlignment = Enum.TextXAlignment.Center
	messageLabel.TextYAlignment = Enum.TextYAlignment.Center
	messageLabel.Parent = container
	self.MessageLabel = messageLabel

	ACTIVE_LOADING = self

	task.spawn(function()
		while spinner and spinner.Parent do
			AnimationManager:CreateTween(spinner, {
				Rotation = spinner.Rotation + 360
			}, "Linear", "In", 1)
			task.wait(1)
		end
	end)

	if self.AutoDestroy and self.Duration > 0 then
		task.delay(self.Duration, function()
			self:Destroy()
		end)
	end

	if self.AutoDestroy and self.Duration == 0 then
		task.delay(3, function()
			self:Destroy()
		end)
	end

	return self
end

function LoadingScreen:SetTitle(title)
	self.Title = title
	if self.TitleLabel then
		self.TitleLabel.Text = title
	end
end

function LoadingScreen:SetMessage(message)
	self.Message = message
	if self.MessageLabel then
		self.MessageLabel.Text = message
	end
end

function LoadingScreen:Destroy()
	ACTIVE_LOADING = nil
	if self.Overlay and self.Overlay.Parent then
		AnimationManager:CreateTween(self.Overlay, {
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.3, function()
			if self.Overlay and self.Overlay.Parent then
				self.Overlay.Parent:Destroy()
			end
		end)
	end
end

NovaUI.LoadingScreen = LoadingScreen


-- FloatingButton
local FloatingButton = {}
FloatingButton.__index = FloatingButton








local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local FLOATING_BUTTONS = {}

function FloatingButton:New(options)
	options = options or {}

	local self = setmetatable({}, FloatingButton)

	self.Name = options.Name or "FloatingButton"
	self.Icon = options.Icon or "Plus"
	self.Size = options.Size or 44
	self.Color = options.Color or "Accent"
	self.Position = options.Position or UDim2.new(1, -(self.Size + 20), 1, -(self.Size + 20))
	self.Callback = options.Callback or function() end
	self.Tooltip = options.Tooltip or nil

	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	local parent = findParent()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_FAB_" .. self.Name
	screenGui.DisplayOrder = 50
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parent
	self.ScreenGui = screenGui

	local buttonFrame = Instance.new("TextButton")
	buttonFrame.Name = "FAB"
	buttonFrame.Size = UDim2.new(0, self.Size, 0, self.Size)
	buttonFrame.Position = self.Position
	buttonFrame.BackgroundColor3 = ThemeManager:GetColor(self.Color)
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Text = ""
	buttonFrame.AutoButtonColor = false
	buttonFrame.Parent = screenGui
	self.ButtonFrame = buttonFrame
	Utility:CreateCorner(buttonFrame, self.Size / 2)

	local shadow = Utility:CreateShadow(buttonFrame, 0.7, 8, Color3.fromRGB(0, 0, 0))

	local iconLabel = IconManager:CreateIconLabel(buttonFrame, self.Icon, UDim2.new(0, self.Size * 0.45, 0, self.Size * 0.45), Color3.fromRGB(255, 255, 255))
	if iconLabel then
		iconLabel.Position = UDim2.new(0.5, -self.Size * 0.225, 0.5, -self.Size * 0.225)
	end

	buttonFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size + 4, 0, self.Size + 4)
		}, "Smooth", "Out", 0.15)
		SoundManager:PlayHover()
	end)

	buttonFrame.MouseLeave:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size, 0, self.Size)
		}, "Smooth", "Out", 0.2)
	end)

	buttonFrame.MouseButton1Down:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size - 4, 0, self.Size - 4)
		}, "Sharp", "In", 0.08)
	end)

	buttonFrame.MouseButton1Up:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size + 4, 0, self.Size + 4)
		}, "Elastic", "Out", 0.3)
	end)

	buttonFrame.MouseButton1Click:Connect(function()
		SoundManager:PlayClick()
		AnimationManager:RippleEffect(buttonFrame, Color3.fromRGB(255, 255, 255), 0.4)
		pcall(self.Callback)
	end)

	DragService:MakeDraggable(buttonFrame, buttonFrame, {
		ConstrainToScreen = true,
		SmoothDrag = true,
	})

	if self.Tooltip then
		local Tooltip = NovaUI.Tooltip
		self._tooltip = Tooltip:New(buttonFrame, self.Tooltip, {Position = "Left", Delay = 0.8})
	end

	table.insert(FLOATING_BUTTONS, self)

	AnimationManager:CreateTween(buttonFrame, {
		Size = UDim2.new(0, self.Size, 0, self.Size)
	}, "Elastic", "Out", 0.5)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function FloatingButton:SetCallback(callback)
	self.Callback = callback
end

function FloatingButton:SetIcon(iconName)
	self.Icon = iconName
end

function FloatingButton:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.ButtonFrame, {
			BackgroundColor3 = palette[self.Color] or palette.Accent,
		}, "Smooth", "Out", 0.3)
	else
		self.ButtonFrame.BackgroundColor3 = palette[self.Color] or palette.Accent
	end
end

function FloatingButton:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	if self._tooltip then
		self._tooltip:Destroy()
	end
	for i, fb in ipairs(FLOATING_BUTTONS) do
		if fb == self then
			table.remove(FLOATING_BUTTONS, i)
			break
		end
	end
	self.ScreenGui:Destroy()
end

NovaUI.FloatingButton = FloatingButton


-- Watermark
local Watermark = {}
Watermark.__index = Watermark





local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local ACTIVE_WATERMARK = nil

function Watermark:New(options)
	options = options or {}

	if ACTIVE_WATERMARK then
		ACTIVE_WATERMARK:Destroy()
	end

	local self = setmetatable({}, Watermark)

	self.Title = options.Title or "Nova UI"
	self.Version = options.Version or "1.0.0"
	self.SubText = options.SubText or ""
	self.ShowFPS = options.ShowFPS or false
	self.Position = options.Position or UDim2.new(0, 14, 0, 10)

	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	local parent = findParent()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_Watermark"
	screenGui.DisplayOrder = 500
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Parent = parent

	local container = Instance.new("Frame")
	container.Name = "Watermark"
	container.Size = UDim2.new(0, 0, 0, 28)
	container.Position = self.Position
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BackgroundTransparency = 0.15
	container.BorderSizePixel = 0
	container.Parent = screenGui
	self.Container = container
	Utility:CreateCorner(container, 6)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.4, 1)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = container

	local accentDot = Instance.new("Frame")
	accentDot.Name = "AccentDot"
	accentDot.Size = UDim2.new(0, 6, 0, 6)
	accentDot.Position = UDim2.new(0, 10, 0.5, -3)
	accentDot.BackgroundColor3 = ThemeManager:GetColor("Accent")
	accentDot.BorderSizePixel = 0
	accentDot.Parent = container
	Utility:CreateCorner(accentDot, 3)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(0, 0, 1, 0)
	titleLabel.Position = UDim2.new(0, 22, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.AutomaticSize = Enum.AutomaticSize.X
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local versionLabel = Instance.new("TextLabel")
	versionLabel.Name = "Version"
	versionLabel.Size = UDim2.new(0, 0, 1, 0)
	versionLabel.Position = UDim2.new(0, titleLabel.AutomaticSize.X + 26, 0, 0)
	versionLabel.BackgroundTransparency = 1
	versionLabel.BorderSizePixel = 0
	versionLabel.Text = "v" .. self.Version
	versionLabel.Font = Enum.Font.Gotham
	versionLabel.TextSize = 12
	versionLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
	versionLabel.TextXAlignment = Enum.TextXAlignment.Left
	versionLabel.TextYAlignment = Enum.TextYAlignment.Center
	versionLabel.AutomaticSize = Enum.AutomaticSize.X
	versionLabel.Parent = container
	self.VersionLabel = versionLabel

	if self.SubText and #self.SubText > 0 then
		local subLabel = Instance.new("TextLabel")
		subLabel.Name = "SubText"
		subLabel.Size = UDim2.new(0, 0, 1, 0)
		subLabel.Position = UDim2.new(0, titleLabel.AutomaticSize.X + versionLabel.AutomaticSize.X + 32, 0, 0)
		subLabel.BackgroundTransparency = 1
		subLabel.BorderSizePixel = 0
		subLabel.Text = self.SubText
		subLabel.Font = Enum.Font.Gotham
		subLabel.TextSize = 12
		subLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
		subLabel.TextXAlignment = Enum.TextXAlignment.Left
		subLabel.TextYAlignment = Enum.TextYAlignment.Center
		subLabel.AutomaticSize = Enum.AutomaticSize.X
		subLabel.Parent = container
		self.SubLabel = subLabel
	end

	local fpsLabel = nil
	if self.ShowFPS then
		fpsLabel = Instance.new("TextLabel")
		fpsLabel.Name = "FPS"
		fpsLabel.Size = UDim2.new(0, 0, 1, 0)
		fpsLabel.BackgroundTransparency = 1
		fpsLabel.BorderSizePixel = 0
		fpsLabel.Text = "60 FPS"
		fpsLabel.Font = Enum.Font.Code
		fpsLabel.TextSize = 11
		fpsLabel.TextColor3 = ThemeManager:GetColor("Accent")
		fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
		fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
		fpsLabel.AutomaticSize = Enum.AutomaticSize.X
		fpsLabel.Parent = container
		self.FPSLabel = fpsLabel

		self._fpsConnection = RunService.RenderStepped:Connect(function()
			self:_updateFPS()
		end)
	end

	ACTIVE_WATERMARK = self

	container.Size = UDim2.new(0, container.AutomaticSize.X, 0, 28)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Watermark:_updateFPS()
	if not self.FPSLabel then
		return
	end
	local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
	self.FPSLabel.Text = fps .. " FPS"
end

function Watermark:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Container, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.TitleLabel, {
			TextColor3 = palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.VersionLabel, {
			TextColor3 = palette.TextMuted,
		}, "Smooth", "Out", 0.3)
	else
		self.Container.BackgroundColor3 = palette.Surface
		self.TitleLabel.TextColor3 = palette.TextPrimary
		self.VersionLabel.TextColor3 = palette.TextMuted
	end
end

function Watermark:Destroy()
	ACTIVE_WATERMARK = nil
	if self._themeConnection then
		self._themeConnection()
	end
	if self._fpsConnection then
		self._fpsConnection:Disconnect()
	end
	if self.Container and self.Container.Parent then
		self.Container.Parent:Destroy()
	end
end

NovaUI.Watermark = Watermark


-- FPSCounter
local FPSCounter = {}
FPSCounter.__index = FPSCounter





local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local ACTIVE_FPS = nil

function FPSCounter:New(options)
	options = options or {}

	if ACTIVE_FPS then
		ACTIVE_FPS:Destroy()
	end

	local self = setmetatable({}, FPSCounter)

	self.Position = options.Position or UDim2.new(1, -80, 0, 10)
	self.ShowGraph = options.ShowGraph or false
	self.UpdateInterval = options.UpdateInterval or 0.5

	local function findParent()
		local ok, g = pcall(gethui)
		if ok and typeof(g) == "Instance" then return g end
		local ok2, c = pcall(function() return CoreGui end)
		if ok2 and c then return c end
		if Player then
			local pg = Player:FindFirstChild("PlayerGui")
			if pg then return pg end
			local ok3, pg2 = pcall(function() return Player:WaitForChild("PlayerGui", 5) end)
			if ok3 and pg2 then return pg2 end
		end
		return nil
	end
	local parent = findParent()

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_FPS"
	screenGui.DisplayOrder = 500
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.ResetOnSpawn = false
	screenGui.Parent = parent

	local container = Instance.new("Frame")
	container.Name = "FPSCounter"
	container.Size = UDim2.new(0, 70, 0, 24)
	container.Position = self.Position
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BackgroundTransparency = 0.2
	container.BorderSizePixel = 0
	container.Parent = screenGui
	self.Container = container
	Utility:CreateCorner(container, 6)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.4, 1)

	local fpsLabel = Instance.new("TextLabel")
	fpsLabel.Name = "FPS"
	fpsLabel.Size = UDim2.new(1, 0, 1, 0)
	fpsLabel.BackgroundTransparency = 1
	fpsLabel.BorderSizePixel = 0
	fpsLabel.Text = "60 FPS"
	fpsLabel.Font = Enum.Font.Code
	fpsLabel.TextSize = 13
	fpsLabel.TextColor3 = ThemeManager:GetColor("Accent")
	fpsLabel.TextXAlignment = Enum.TextXAlignment.Center
	fpsLabel.TextYAlignment = Enum.TextYAlignment.Center
	fpsLabel.Parent = container
	self.FPSLabel = fpsLabel

	self._frameTimes = {}
	self._lastUpdate = tick()

	self._connection = RunService.RenderStepped:Connect(function(dt)
		self:_update(dt)
	end)

	ACTIVE_FPS = self

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function FPSCounter:_update(dt)
	table.insert(self._frameTimes, dt)
	if #self._frameTimes > 60 then
		table.remove(self._frameTimes, 1)
	end

	local now = tick()
	if now - self._lastUpdate >= self.UpdateInterval then
		self._lastUpdate = now

		local total = 0
		for _, t in ipairs(self._frameTimes) do
			total = total + t
		end
		local avgDt = total / #self._frameTimes
		local fps = math.floor(1 / avgDt)

		local color
		if fps >= 60 then
			color = ThemeManager:GetColor("Success")
		elseif fps >= 30 then
			color = ThemeManager:GetColor("Warning")
		else
			color = ThemeManager:GetColor("Danger")
		end

		self.FPSLabel.Text = fps .. " FPS"
		AnimationManager:CreateTween(self.FPSLabel, {
			TextColor3 = color
		}, "Smooth", "Out", 0.3)
	end
end

function FPSCounter:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Container, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)
	else
		self.Container.BackgroundColor3 = palette.Surface
	end
end

function FPSCounter:Destroy()
	ACTIVE_FPS = nil
	if self._themeConnection then
		self._themeConnection()
	end
	if self._connection then
		self._connection:Disconnect()
	end
	if self.Container and self.Container.Parent then
		self.Container.Parent:Destroy()
	end
end

NovaUI.FPSCounter = FPSCounter




-- Core Modules






-- Services



-- Component Constructors









-- Library Version
NovaUI.Version = "1.0.0"
NovaUI.Build = "Nova UI - Modern Roblox UI Library"

function NovaUI:CreateWindow(options)
	options = options or {}

	local window = Window:New(options)

	self:ApplyTheme(NovaUI.ThemeManager.CurrentTheme)

	return window
end

function NovaUI:CreateNotification(options)
	options = options or {}
	return Notification:New(options)
end

function NovaUI:CreateDialog(options)
	options = options or {}
	return Dialog:New(options)
end

function NovaUI:CreateTooltip(target, text, options)
	return Tooltip:New(target, text, options)
end

function NovaUI:CreateLoadingScreen(options)
	options = options or {}
	return LoadingScreen:New(options)
end

function NovaUI:CreateFloatingButton(options)
	options = options or {}
	return FloatingButton:New(options)
end

function NovaUI:CreateWatermark(options)
	options = options or {}
	return Watermark:New(options)
end

function NovaUI:CreateFPSCounter(options)
	options = options or {}
	return FPSCounter:New(options)
end

function NovaUI:SetTheme(themeName)
	NovaUI.ThemeManager:ApplyTheme(themeName)
	self:ApplyTheme(themeName)
end

function NovaUI:ApplyTheme(themeName)
	NovaUI.ThemeManager:ApplyTheme(themeName)
end

function NovaUI:SetAccentColor(color)
	NovaUI.ThemeManager:SetAccent(color)
end

function NovaUI:GetAccentColor()
	return NovaUI.ThemeManager:GetColor("Accent")
end

function NovaUI:GetColor(colorKey)
	return NovaUI.ThemeManager:GetColor(colorKey)
end

function NovaUI:GetThemes()
	return NovaUI.ThemeManager:GetThemeList()
end

function NovaUI:AddTheme(name, palette)
	NovaUI.ThemeManager:AddTheme(name, palette)
end

function NovaUI:SetSoundsEnabled(enabled)
	NovaUI.SoundManager:SetEnabled(enabled)
end

function NovaUI:SetSoundVolume(volume)
	NovaUI.SoundManager:SetVolume(volume)
end

function NovaUI:RegisterIcon(name, assetId)
	NovaUI.IconManager:RegisterIcon(name, assetId)
end

function NovaUI:RegisterIcons(iconTable)
	NovaUI.IconManager:RegisterIcons(iconTable)
end

function NovaUI:OnThemeChange(callback)
	return NovaUI.ThemeManager:OnChange(callback)
end

function NovaUI:CreateConfig(options)
	options = options or {}
	return NovaUI.ConfigService:Init(options)
end

function NovaUI:Unload()
	NovaUI.AnimationManager:CancelAll()
	NovaUI.SoundManager:Cleanup()
	NovaUI.DragService:Cleanup()

	for _, window in ipairs(Window.GetWindows()) do
		window:Destroy()
	end
end



return NovaUI