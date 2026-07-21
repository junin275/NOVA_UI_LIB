local Section = {}
Section.__index = Section

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

function Section:New(tab, options)
	options = options or {}

	local self = setmetatable({}, Section)

	self.Tab = tab
	self.Name = options.Name or "Section"
	self.Description = options.Description or nil
	self.Side = options.Side or "Left"
	self.Components = {}

	local container = Instance.new("Frame")
	container.Name = "Section_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y

	self.Container = container

	Utility:CreateCorner(container, 8)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local accentBorder = Instance.new("Frame")
	accentBorder.Name = "AccentBorder"
	accentBorder.Size = UDim2.new(0, 3, 1, -4)
	accentBorder.Position = UDim2.new(0, 0, 0, 2)
	accentBorder.BackgroundColor3 = ThemeManager:GetColor("Accent")
	accentBorder.BorderSizePixel = 0
	accentBorder.Parent = container

	Utility:CreateCorner(accentBorder, 2)

	local innerFrame = Instance.new("Frame")
	innerFrame.Name = "Inner"
	innerFrame.Size = UDim2.new(1, -16, 1, -16)
	innerFrame.Position = UDim2.new(0, 16, 0, 8)
	innerFrame.BackgroundTransparency = 1
	innerFrame.BorderSizePixel = 0
	innerFrame.AutomaticSize = Enum.AutomaticSize.Y
	innerFrame.Parent = container

	self.InnerFrame = innerFrame

	if self.Name then
		local titleFrame = Instance.new("Frame")
		titleFrame.Name = "TitleFrame"
		titleFrame.Size = UDim2.new(1, 0, 0, 24)
		titleFrame.BackgroundTransparency = 1
		titleFrame.BorderSizePixel = 0
		titleFrame.AutomaticSize = Enum.AutomaticSize.Y
		titleFrame.Parent = innerFrame

		self.TitleFrame = titleFrame

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Name = "Title"
		nameLabel.Size = UDim2.new(1, 0, 0, 20)
		nameLabel.BackgroundTransparency = 1
		nameLabel.BorderSizePixel = 0
		nameLabel.Text = self.Name
		nameLabel.Font = Enum.Font.GothamSemibold
		nameLabel.TextSize = 14
		nameLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextYAlignment = Enum.TextYAlignment.Center
		nameLabel.Parent = titleFrame

		self.NameLabel = nameLabel

		if self.Description then
			local descLabel = Instance.new("TextLabel")
			descLabel.Name = "Description"
			descLabel.Size = UDim2.new(1, 0, 0, 16)
			descLabel.Position = UDim2.new(0, 0, 0, 22)
			descLabel.BackgroundTransparency = 1
			descLabel.BorderSizePixel = 0
			descLabel.Text = self.Description
			descLabel.Font = Enum.Font.Gotham
			descLabel.TextSize = 12
			descLabel.TextColor3 = ThemeManager:GetColor("TextMuted")
			descLabel.TextXAlignment = Enum.TextXAlignment.Left
			descLabel.TextYAlignment = Enum.TextYAlignment.Center
			descLabel.Parent = titleFrame
		end

		local separator = Instance.new("Frame")
		separator.Name = "Separator"
		separator.Size = UDim2.new(1, 0, 0, 1)
		separator.Position = UDim2.new(0, 0, 1, 0)
		separator.BackgroundColor3 = ThemeManager:GetColor("Border")
		separator.BorderSizePixel = 0
		separator.Parent = titleFrame

		self.TitleSeparator = separator
	end

	local componentList = Instance.new("UIListLayout")
	componentList.FillDirection = Enum.FillDirection.Vertical
	componentList.Padding = UDim.new(0, 6)
	componentList.HorizontalAlignment = Enum.HorizontalAlignment.Left
	componentList.VerticalAlignment = Enum.VerticalAlignment.Top
	componentList.SortOrder = Enum.SortOrder.LayoutOrder
	componentList.Parent = innerFrame

	self.ComponentList = componentList

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Section:CreateButton(options)
	local Button = require(script.Parent.Button)
	local button = Button:New(self, options)
	button.Container.Parent = self.InnerFrame
	button.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, button)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return button
end

function Section:CreateToggle(options)
	local Toggle = require(script.Parent.Toggle)
	local toggle = Toggle:New(self, options)
	toggle.Container.Parent = self.InnerFrame
	toggle.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, toggle)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return toggle
end

function Section:CreateSlider(options)
	local Slider = require(script.Parent.Slider)
	local slider = Slider:New(self, options)
	slider.Container.Parent = self.InnerFrame
	slider.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, slider)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return slider
end

function Section:CreateDropdown(options)
	local Dropdown = require(script.Parent.Dropdown)
	local dropdown = Dropdown:New(self, options)
	dropdown.Container.Parent = self.InnerFrame
	dropdown.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, dropdown)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return dropdown
end

function Section:CreateMultiDropdown(options)
	local MultiDropdown = require(script.Parent.MultiDropdown)
	local multiDropdown = MultiDropdown:New(self, options)
	multiDropdown.Container.Parent = self.InnerFrame
	multiDropdown.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, multiDropdown)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return multiDropdown
end

function Section:CreateTextBox(options)
	local TextBox = require(script.Parent.TextBox)
	local textBox = TextBox:New(self, options)
	textBox.Container.Parent = self.InnerFrame
	textBox.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, textBox)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return textBox
end

function Section:CreateKeybind(options)
	local Keybind = require(script.Parent.Keybind)
	local keybind = Keybind:New(self, options)
	keybind.Container.Parent = self.InnerFrame
	keybind.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, keybind)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return keybind
end

function Section:CreateLabel(options)
	local Label = require(script.Parent.Label)
	local label = Label:New(self, options)
	label.Container.Parent = self.InnerFrame
	label.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, label)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return label
end

function Section:CreateParagraph(options)
	local Paragraph = require(script.Parent.Paragraph)
	local paragraph = Paragraph:New(self, options)
	paragraph.Container.Parent = self.InnerFrame
	paragraph.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, paragraph)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return paragraph
end

function Section:CreateColorPicker(options)
	local ColorPicker = require(script.Parent.ColorPicker)
	local colorPicker = ColorPicker:New(self, options)
	colorPicker.Container.Parent = self.InnerFrame
	colorPicker.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, colorPicker)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return colorPicker
end

function Section:CreateSeparator(options)
	local Separator = require(script.Parent.Separator)
	local separator = Separator:New(self, options)
	separator.Container.Parent = self.InnerFrame
	separator.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, separator)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return separator
end

function Section:CreateProgressBar(options)
	local ProgressBar = require(script.Parent.ProgressBar)
	local progressBar = ProgressBar:New(self, options)
	progressBar.Container.Parent = self.InnerFrame
	progressBar.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, progressBar)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return progressBar
end

function Section:CreateSearchBar(options)
	local SearchBar = require(script.Parent.SearchBar)
	local searchBar = SearchBar:New(self, options)
	searchBar.Container.Parent = self.InnerFrame
	searchBar.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, searchBar)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return searchBar
end

function Section:CreateImage(options)
	local Image = require(script.Parent.Image)
	local image = Image:New(self, options)
	image.Container.Parent = self.InnerFrame
	image.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, image)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return image
end

function Section:CreateIcon(options)
	local Icon = require(script.Parent.Icon)
	local icon = Icon:New(self, options)
	icon.Container.Parent = self.InnerFrame
	icon.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, icon)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return icon
end

function Section:CreateMiniConsole(options)
	local MiniConsole = require(script.Parent.MiniConsole)
	local miniConsole = MiniConsole:New(self, options)
	miniConsole.Container.Parent = self.InnerFrame
	miniConsole.Container.LayoutOrder = #self.Components + 1
	table.insert(self.Components, miniConsole)
	self.Container.AutomaticSize = Enum.AutomaticSize.Y
	return miniConsole
end

function Section:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Container, {
			BackgroundColor3 = palette.Surface,
		}, "Smooth", "Out", 0.3)
		if self.NameLabel then
			AnimationManager:CreateTween(self.NameLabel, {
				TextColor3 = palette.TextPrimary,
			}, "Smooth", "Out", 0.3)
		end
	else
		self.Container.BackgroundColor3 = palette.Surface
		if self.NameLabel then
			self.NameLabel.TextColor3 = palette.TextPrimary
		end
	end
end

function Section:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	for _, component in ipairs(self.Components) do
		component:Destroy()
	end
	self.Container:Destroy()
end

return Section
