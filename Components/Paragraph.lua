local Paragraph = {}
Paragraph.__index = Paragraph

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)

function Paragraph:New(section, options)
	options = options or {}

	local self = setmetatable({}, Paragraph)

	self.Section = section
	self.Title = options.Title or nil
	self.Text = options.Text or ""
	self.TextSize = options.TextSize or 13
	self.Color = options.Color or "TextSecondary"

	local container = Instance.new("Frame")
	container.Name = "Paragraph"
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	if self.Title then
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, -20, 0, 20)
		titleLabel.Position = UDim2.new(0, 10, 0, 2)
		titleLabel.BackgroundTransparency = 1
		titleLabel.BorderSizePixel = 0
		titleLabel.Text = self.Title
		titleLabel.Font = Enum.Font.GothamSemibold
		titleLabel.TextSize = 14
		titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.TextYAlignment = Enum.TextYAlignment.Top
		titleLabel.RichText = true
		titleLabel.TextWrapped = true
		titleLabel.AutomaticSize = Enum.AutomaticSize.Y
		titleLabel.Parent = container
		self.TitleLabel = titleLabel
	end

	local contentLabel = Instance.new("TextLabel")
	contentLabel.Name = "Content"
	contentLabel.Size = UDim2.new(1, -20, 0, 20)
	contentLabel.Position = UDim2.new(0, 10, 0, self.Title and 24 or 2)
	contentLabel.BackgroundTransparency = 1
	contentLabel.BorderSizePixel = 0
	contentLabel.Text = self.Text
	contentLabel.Font = Enum.Font.Gotham
	contentLabel.TextSize = self.TextSize
	contentLabel.TextColor3 = ThemeManager:GetColor(self.Color)
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.TextYAlignment = Enum.TextYAlignment.Top
	contentLabel.RichText = true
	contentLabel.TextWrapped = true
	contentLabel.AutomaticSize = Enum.AutomaticSize.Y
	contentLabel.Parent = container
	self.ContentLabel = contentLabel

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Paragraph:SetText(text)
	self.Text = text
	self.ContentLabel.Text = text
end

function Paragraph:UpdateTheme(palette, animate)
	if animate then
		if self.TitleLabel then
			AnimationManager:CreateTween(self.TitleLabel, {
				TextColor3 = palette.TextPrimary,
			}, "Smooth", "Out", 0.3)
		end
		AnimationManager:CreateTween(self.ContentLabel, {
			TextColor3 = palette[self.Color] or palette.TextSecondary,
		}, "Smooth", "Out", 0.3)
	else
		if self.TitleLabel then
			self.TitleLabel.TextColor3 = palette.TextPrimary
		end
		self.ContentLabel.TextColor3 = palette[self.Color] or palette.TextSecondary
	end
end

function Paragraph:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

return Paragraph
