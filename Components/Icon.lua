local Icon = {}
Icon.__index = Icon

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local IconManager = require(script.Parent.Parent.Core.IconManager)

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

return Icon
