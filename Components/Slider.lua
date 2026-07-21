local Slider = {}
Slider.__index = Slider

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)
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
	nameLabel.Position = UDim2.new(0, 10, 0, 6)
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
	valueLabel.Position = UDim2.new(1, -80, 0, 6)
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
	trackFrame.Size = UDim2.new(1, -20, 0, 4)
	trackFrame.Position = UDim2.new(0, 10, 1, -14)
	trackFrame.BackgroundColor3 = ThemeManager:GetColor("Border")
	trackFrame.BorderSizePixel = 0
	trackFrame.Parent = container
	self.TrackFrame = trackFrame
	Utility:CreateCorner(trackFrame, 2)

	local fillFrame = Instance.new("Frame")
	fillFrame.Name = "Fill"
	fillFrame.Size = UDim2.new(0, 0, 1, 0)
	fillFrame.BackgroundColor3 = ThemeManager:GetColor("Accent")
	fillFrame.BorderSizePixel = 0
	fillFrame.Parent = trackFrame
	self.FillFrame = fillFrame
	Utility:CreateCorner(fillFrame, 2)

	local glowFrame = Instance.new("Frame")
	glowFrame.Name = "Glow"
	glowFrame.Size = UDim2.new(0, 0, 1, 4)
	glowFrame.Position = UDim2.new(0, 0, 0.5, -2)
	glowFrame.BackgroundColor3 = ThemeManager:GetColor("Accent")
	glowFrame.BackgroundTransparency = 0.6
	glowFrame.BorderSizePixel = 0
	glowFrame.Parent = trackFrame
	Utility:CreateCorner(glowFrame, 3)
	self.GlowFrame = glowFrame

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 0, 0.5, -7)
	knob.BackgroundColor3 = ThemeManager:GetColor("Accent")
	knob.BorderSizePixel = 0
	knob.Parent = container
	self.Knob = knob
	Utility:CreateCorner(knob, 7)

	local knobInner = Instance.new("Frame")
	knobInner.Name = "KnobInner"
	knobInner.Size = UDim2.new(0, 6, 0, 6)
	knobInner.Position = UDim2.new(0.5, -3, 0.5, -3)
	knobInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knobInner.BorderSizePixel = 0
	knobInner.Parent = knob
	Utility:CreateCorner(knobInner, 3)

	local function updateSlider(inputX)
		local trackPos = trackFrame.AbsolutePosition.X
		local trackWidth = trackFrame.AbsoluteSize.X
		local relX = math.clamp(inputX - trackPos, 0, trackWidth)
		local fraction = relX / trackWidth
		local value = self.Min + (self.Max - self.Min) * fraction
		local mult = 10 ^ self.Precision
		value = math.floor(value * mult + 0.5) / mult
		self._value = value
		self:UpdateVisuals(relX, trackWidth)
		self.ValueLabel.Text = tostring(value) .. self.Suffix
		pcall(self.Callback, value)
	end

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

	local inputChanged
	inputChanged = game:GetService("UserInputService").InputChanged:Connect(function(input)
		if self._dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(Mouse.X)
		end
	end)

	local inputEnded
	inputEnded = game:GetService("UserInputService").InputEnded:Connect(function(input)
		if self._dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			self._dragging = false
		end
	end)

	self._inputChanged = inputChanged
	self._inputEnded = inputEnded

	knob.MouseEnter:Connect(function()
		AnimationManager:CreateTween(knob, {
			Size = UDim2.new(0, 18, 0, 18)
		}, "Smooth", "Out", 0.15)
	end)

	knob.MouseLeave:Connect(function()
		if not self._dragging then
			AnimationManager:CreateTween(knob, {
				Size = UDim2.new(0, 14, 0, 14)
			}, "Smooth", "Out", 0.2)
		end
	end)

	self:SetValue(self.Default, true)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Slider:UpdateVisuals(relX, trackWidth)
	trackWidth = trackWidth or self.TrackFrame.AbsoluteSize.X
	relX = relX or (self._value - self.Min) / (self.Max - self.Min) * trackWidth

	AnimationManager:CreateTween(self.FillFrame, {
		Size = UDim2.new(0, relX, 1, 0)
	}, "Smooth", "Out", 0.1)

	AnimationManager:CreateTween(self.GlowFrame, {
		Size = UDim2.new(0, relX, 1, 4)
	}, "Smooth", "Out", 0.1)

	AnimationManager:CreateTween(self.Knob, {
		Position = UDim2.new(0, relX - 7, 0.5, -7)
	}, "Smooth", "Out", 0.1)
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
		self.GlowFrame.Size = UDim2.new(0, relX, 1, 4)
		self.Knob.Position = UDim2.new(0, relX - 7, 0.5, -7)
	else
		self:UpdateVisuals(relX, trackWidth)
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
		AnimationManager:CreateTween(self.FillFrame, {
			BackgroundColor3 = palette.Accent,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.GlowFrame, {
			BackgroundColor3 = palette.Accent,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.Knob, {
			BackgroundColor3 = palette.Accent,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.ValueLabel, {
			TextColor3 = palette.Accent,
		}, "Smooth", "Out", 0.3)
	else
		self.FillFrame.BackgroundColor3 = palette.Accent
		self.GlowFrame.BackgroundColor3 = palette.Accent
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

return Slider
