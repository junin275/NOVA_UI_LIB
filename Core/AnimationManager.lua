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
	OutIn = Enum.EasingDirection.OutIn,
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

return AnimationManager
