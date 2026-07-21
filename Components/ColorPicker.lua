local ColorPicker = {}
ColorPicker.__index = ColorPicker

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

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

return ColorPicker
