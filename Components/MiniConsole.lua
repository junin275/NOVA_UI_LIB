local MiniConsole = {}
MiniConsole.__index = MiniConsole

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

function MiniConsole:New(section, options)
	options = options or {}

	local self = setmetatable({}, MiniConsole)

	self.Section = section
	self.Name = options.Name or "Console"
	self.MaxLines = options.MaxLines or 100
	self.AutoScroll = options.AutoScroll or true
	self.LinePrefix = options.LinePrefix or "> "

	local container = Instance.new("Frame")
	container.Name = "MiniConsole_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 160)
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	self.Container = container
	Utility:CreateCorner(container, 8)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local titleFrame = Instance.new("Frame")
	titleFrame.Name = "TitleFrame"
	titleFrame.Size = UDim2.new(1, 0, 0, 28)
	titleFrame.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	titleFrame.BorderSizePixel = 0
	titleFrame.Parent = container
	Utility:CreateCorner(titleFrame, 8)

	local titleBarBottom = Instance.new("Frame")
	titleBarBottom.Name = "BottomLine"
	titleBarBottom.Size = UDim2.new(1, 0, 0, 1)
	titleBarBottom.Position = UDim2.new(0, 0, 1, 0)
	titleBarBottom.BackgroundColor3 = ThemeManager:GetColor("Border")
	titleBarBottom.BorderSizePixel = 0
	titleBarBottom.Parent = titleFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -40, 1, 0)
	titleLabel.Position = UDim2.new(0, 10, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Name
	titleLabel.Font = Enum.Font.Gotham
	titleLabel.TextSize = 13
	titleLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = titleFrame

	local clearBtn = Instance.new("TextButton")
	clearBtn.Name = "ClearBtn"
	clearBtn.Size = UDim2.new(0, 16, 0, 16)
	clearBtn.Position = UDim2.new(1, -24, 0.5, -8)
	clearBtn.BackgroundTransparency = 1
	clearBtn.BorderSizePixel = 0
	clearBtn.Text = ""
	clearBtn.Parent = titleFrame

	local clearIcon = IconManager:CreateIconLabel(clearBtn, "Trash", UDim2.new(0, 12, 0, 12), ThemeManager:GetColor("TextMuted"))
	if clearIcon then
		clearIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
	end

	local textFrame = Instance.new("ScrollingFrame")
	textFrame.Name = "TextFrame"
	textFrame.Size = UDim2.new(1, -8, 1, -(titleFrame.Size.Y.Offset + 4))
	textFrame.Position = UDim2.new(0, 4, 0, titleFrame.Size.Y.Offset + 2)
	textFrame.BackgroundTransparency = 1
	textFrame.BorderSizePixel = 0
	textFrame.ScrollBarThickness = 2
	textFrame.ScrollBarImageColor3 = ThemeManager:GetColor("Accent")
	textFrame.ScrollBarImageTransparency = 0.6
	textFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	textFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	textFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	textFrame.ElasticBehavior = Enum.ElasticBehavior.Never
	textFrame.Parent = container
	self.TextFrame = textFrame

	local textListLayout = Instance.new("UIListLayout")
	textListLayout.FillDirection = Enum.FillDirection.Vertical
	textListLayout.Padding = UDim.new(0, 2)
	textListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	textListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	textListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	textListLayout.Parent = textFrame

	self._lines = {}

	clearBtn.MouseButton1Click:Connect(function()
		self:Clear()
		SoundManager:PlayClick()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function MiniConsole:Log(message, messageType)
	messageType = messageType or "Info"
	local colors = {
		Info = ThemeManager:GetColor("TextSecondary"),
		Success = ThemeManager:GetColor("Success"),
		Warning = ThemeManager:GetColor("Warning"),
		Error = ThemeManager:GetColor("Danger"),
		Command = ThemeManager:GetColor("Accent"),
	}
	local color = colors[messageType] or colors.Info

	local line = Instance.new("TextLabel")
	line.Name = "Line"
	line.Size = UDim2.new(1, -8, 0, 16)
	line.BackgroundTransparency = 1
	line.BorderSizePixel = 0
	line.Text = self.LinePrefix .. tostring(message)
	line.Font = Enum.Font.Code
	line.TextSize = 12
	line.TextColor3 = color
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.TextYAlignment = Enum.TextYAlignment.Center
	line.TextWrapped = true
	line.AutomaticSize = Enum.AutomaticSize.Y
	line.Parent = self.TextFrame

	table.insert(self._lines, line)

	while #self._lines > self.MaxLines do
		local old = table.remove(self._lines, 1)
		if old then
			old:Destroy()
		end
	end

	if self.AutoScroll then
		task.wait()
		self.TextFrame.CanvasPosition = Vector2.new(0, self.TextFrame.CanvasSize.Y.Offset)
	end
end

function MiniConsole:Warn(message)
	self:Log(message, "Warning")
end

function MiniConsole:Error(message)
	self:Log(message, "Error")
end

function MiniConsole:Success(message)
	self:Log(message, "Success")
end

function MiniConsole:Command(message)
	self:Log(message, "Command")
end

function MiniConsole:Clear()
	for _, line in ipairs(self._lines) do
		line:Destroy()
	end
	self._lines = {}
	self.TextFrame.CanvasPosition = Vector2.new(0, 0)
end

function MiniConsole:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Container, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(titleFrame, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.Container.BackgroundColor3 = palette.Surface
		titleFrame.BackgroundColor3 = palette.SurfaceAlt
	end
end

function MiniConsole:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

return MiniConsole
