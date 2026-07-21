local Label = {}
Label.__index = Label

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

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

return Label
