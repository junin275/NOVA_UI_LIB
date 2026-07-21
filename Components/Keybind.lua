local Keybind = {}
Keybind.__index = Keybind

local UserInputService = game:GetService("UserInputService")
local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

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

return Keybind
