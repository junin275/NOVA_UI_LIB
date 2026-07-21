local ProgressBar = {}
ProgressBar.__index = ProgressBar

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

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

return ProgressBar
