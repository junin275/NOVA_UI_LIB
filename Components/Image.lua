local Image = {}
Image.__index = Image

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)

function Image:New(section, options)
	options = options or {}

	local self = setmetatable({}, Image)

	self.Section = section
	self.ImageId = options.ImageId or ""
	self.Size = options.Size or UDim2.new(1, -20, 0, 120)
	self.KeepAspect = options.KeepAspect or false
	self.CornerRadius = options.CornerRadius or 6
	self.Caption = options.Caption or nil

	local container = Instance.new("Frame")
	container.Name = "Image"
	container.Size = UDim2.new(1, 0, 0, self.Size.Y.Offset + (self.Caption and 24 or 0) + 12)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	self.Container = container

	local imageFrame = Instance.new("Frame")
	imageFrame.Name = "ImageFrame"
	imageFrame.Size = self.Size
	imageFrame.Position = UDim2.new(0, 10, 0, 6)
	imageFrame.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	imageFrame.BorderSizePixel = 0
	imageFrame.ClipsDescendants = true
	imageFrame.Parent = container
	Utility:CreateCorner(imageFrame, self.CornerRadius)
	Utility:CreateStroke(imageFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "ImageLabel"
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.BackgroundTransparency = 1
	imageLabel.BorderSizePixel = 0
	imageLabel.Image = self.ImageId
	imageLabel.ScaleType = self.KeepAspect and Enum.ScaleType.Fit or Enum.ScaleType.Crop
	imageLabel.Parent = imageFrame
	self.ImageLabel = imageLabel

	if self.Caption then
		local captionLabel = Instance.new("TextLabel")
		captionLabel.Name = "Caption"
		captionLabel.Size = UDim2.new(1, -20, 0, 18)
		captionLabel.Position = UDim2.new(0, 10, 0, self.Size.Y.Offset + 10)
		captionLabel.BackgroundTransparency = 1
		captionLabel.BorderSizePixel = 0
		captionLabel.Text = self.Caption
		captionLabel.Font = Enum.Font.Gotham
		captionLabel.TextSize = 12
		captionLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
		captionLabel.TextXAlignment = Enum.TextXAlignment.Center
		captionLabel.TextYAlignment = Enum.TextYAlignment.Center
		captionLabel.Parent = container
		self.CaptionLabel = captionLabel
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Image:SetImage(imageId)
	self.ImageId = imageId
	self.ImageLabel.Image = imageId
end

function Image:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(imageFrame, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		imageFrame.BackgroundColor3 = palette.SurfaceAlt
	end
end

function Image:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

return Image
