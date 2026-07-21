local Toggle = {}
Toggle.__index = Toggle

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

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

	Utility:CreateCorner(mainFrame, 6)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local textFrame = Instance.new("Frame")
	textFrame.Name = "TextFrame"
	textFrame.Size = UDim2.new(1, -60, 1, 0)
	textFrame.Position = UDim2.new(0, 10, 0, 0)
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
	toggleBg.Size = UDim2.new(0, 44, 0, 22)
	toggleBg.Position = UDim2.new(1, -54, 0.5, -11)
	toggleBg.BackgroundColor3 = ThemeManager:GetColor("Border")
	toggleBg.BorderSizePixel = 0
	toggleBg.Parent = mainFrame

	self.ToggleBg = toggleBg
	Utility:CreateCorner(toggleBg, 11)

	local toggleKnob = Instance.new("Frame")
	toggleKnob.Name = "Knob"
	toggleKnob.Size = UDim2.new(0, 18, 0, 18)
	toggleKnob.Position = UDim2.new(0, 2, 0.5, -9)
	toggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	toggleKnob.BorderSizePixel = 0
	toggleKnob.Parent = toggleBg

	self.ToggleKnob = toggleKnob
	Utility:CreateCorner(toggleKnob, 9)

	local knobInner = Instance.new("Frame")
	knobInner.Name = "KnobInner"
	knobInner.Size = UDim2.new(0, 10, 0, 10)
	knobInner.Position = UDim2.new(0.5, -5, 0.5, -5)
	knobInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knobInner.BackgroundTransparency = 0
	knobInner.BorderSizePixel = 0
	knobInner.Parent = toggleKnob
	Utility:CreateCorner(knobInner, 5)

	self.KnobInner = knobInner

	if self._value then
		self:SetState(true, true)
	end

	mainFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 0.1
		}, "Smooth", "Out", 0.15)
	end)

	mainFrame.MouseLeave:Connect(function()
		AnimationManager:CreateTween(mainFrame, {
			BackgroundTransparency = 1
		}, "Smooth", "Out", 0.2)
	end)

	mainFrame.MouseButton1Click:Connect(function()
		self:Toggle()
		SoundManager:PlayToggle()
		AnimationManager:RippleEffect(mainFrame, ThemeManager:GetColor("Accent"), 0.3)
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Toggle:SetState(state, instant)
	state = state or false
	self._value = state

	local targetX = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
	local bgColor = state and ThemeManager:GetColor("Accent") or ThemeManager:GetColor("Border")
	local knobColor = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)

	if instant then
		self.ToggleKnob.Position = targetX
		self.ToggleBg.BackgroundColor3 = bgColor
		self.ToggleKnob.BackgroundColor3 = knobColor
	else
		AnimationManager:CreateTween(self.ToggleKnob, {
			Position = targetX
		}, "Smooth", "Out", 0.25)
		AnimationManager:CreateTween(self.ToggleBg, {
			BackgroundColor3 = bgColor
		}, "Smooth", "Out", 0.25)
		AnimationManager:CreateTween(self.ToggleKnob, {
			BackgroundColor3 = knobColor
		}, "Smooth", "Out", 0.25)
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
			AnimationManager:CreateTween(self.ToggleBg, {
				BackgroundColor3 = palette.Accent
			}, "Smooth", "Out", 0.3)
		else
			self.ToggleBg.BackgroundColor3 = palette.Accent
		end
	end
	if animate then
		AnimationManager:CreateTween(self.NameLabel, {
			TextColor3 = palette.TextPrimary,
		}, "Smooth", "Out", 0.3)
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

return Toggle
