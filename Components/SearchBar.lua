local SearchBar = {}
SearchBar.__index = SearchBar

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)

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

return SearchBar
