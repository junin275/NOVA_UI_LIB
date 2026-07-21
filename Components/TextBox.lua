local TextBox = {}
TextBox.__index = TextBox

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

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

return TextBox
