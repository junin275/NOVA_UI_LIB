local Section = {}
Section.__index = Section

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)

function Section:New(tab, options)
	options = options or {}

	local self = setmetatable({}, Section)

	self.Tab = tab
	self.Name = options.Name or "Section"
	self.Columns = options.Columns or 1
self.Components = {}

	local container = Instance.new("Frame")
	container.Name = "Section_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	local headerFrame = Instance.new("Frame")
	headerFrame.Name = "Header"
	headerFrame.Size = UDim2.new(1, 0, 0, 28)
	headerFrame.BackgroundTransparency = 1
	headerFrame.BorderSizePixel = 0
	headerFrame.Parent = container

	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = UDim2.new(1, 0, 0, 1)
	divider.Position = UDim2.new(0, 0, 1, -1)
	divider.BackgroundColor3 = ThemeManager:GetColor("Divider")
	divider.BorderSizePixel = 0
	divider.Parent = headerFrame

	local headerLabel = Instance.new("TextLabel")
	headerLabel.Name = "HeaderLabel"
	headerLabel.Size = UDim2.new(1, -8, 1, 0)
	headerLabel.Position = UDim2.new(0, 0, 0, 0)
	headerLabel.BackgroundTransparency = 1
	headerLabel.BorderSizePixel = 0
	headerLabel.Text = self.Name
	headerLabel.Font = Enum.Font.GothamSemibold
	headerLabel.TextSize = 12
	headerLabel.TextColor3 = ThemeManager:GetColor("HeaderText")
	headerLabel.TextTransparency = 0.2
	headerLabel.TextXAlignment = Enum.TextXAlignment.Left
	headerLabel.TextYAlignment = Enum.TextYAlignment.Center
	headerLabel.Parent = headerFrame

	self.Divider = divider
	self.HeaderLabel = headerLabel

	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, 0, 0, 0)
	contentFrame.Position = UDim2.new(0, 0, 0, 32)
	contentFrame.BackgroundTransparency = 1
	contentFrame.BorderSizePixel = 0
	contentFrame.AutomaticSize = Enum.AutomaticSize.Y
	contentFrame.Parent = container

	self.ContentFrame = contentFrame

	if self.Columns > 1 then
		local gridLayout = Instance.new("UIGridLayout")
		gridLayout.FillDirection = Enum.FillDirection.Horizontal
		gridLayout.CellSize = UDim2.new(0.5, -5, 0, 0)
		gridLayout.CellPadding = UDim2.new(0, 10, 0, 8)
		gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		gridLayout.FillDirectionMaxCells = self.Columns
		gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		gridLayout.Parent = contentFrame
		self._gridLayout = gridLayout
	else
		local listLayout = Instance.new("UIListLayout")
		listLayout.FillDirection = Enum.FillDirection.Vertical
		listLayout.Padding = UDim.new(0, 6)
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
		listLayout.Parent = contentFrame
		self._listLayout = listLayout
	end

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Section:CreateButton(options)
	options = options or {}
	local Button = require(script.Parent.Button)
	local btn = Button:New(self, options)
	table.insert(self.Components, btn)
	btn.Container.Parent = self.ContentFrame
	btn.Container.LayoutOrder = #self.Components
	return btn
end

function Section:CreateToggle(options)
	options = options or {}
	local Toggle = require(script.Parent.Toggle)
	local tg = Toggle:New(self, options)
	table.insert(self.Components, tg)
	tg.Container.Parent = self.ContentFrame
	tg.Container.LayoutOrder = #self.Components
	return tg
end

function Section:CreateSlider(options)
	options = options or {}
	local Slider = require(script.Parent.Slider)
	local sl = Slider:New(self, options)
	table.insert(self.Components, sl)
	sl.Container.Parent = self.ContentFrame
	sl.Container.LayoutOrder = #self.Components
	return sl
end

function Section:CreateDropdown(options)
	options = options or {}
	local Dropdown = require(script.Parent.Dropdown)
	local dd = Dropdown:New(self, options)
	table.insert(self.Components, dd)
	dd.Container.Parent = self.ContentFrame
	dd.Container.LayoutOrder = #self.Components
	return dd
end

function Section:CreateLabel(options)
	options = options or {}
	local Label = require(script.Parent.Label)
	local lb = Label:New(self, options)
	table.insert(self.Components, lb)
	lb.Container.Parent = self.ContentFrame
	lb.Container.LayoutOrder = #self.Components
	return lb
end

function Section:CreateTextBox(options)
	options = options or {}
	local TextBox = require(script.Parent.TextBox)
	local tb = TextBox:New(self, options)
	table.insert(self.Components, tb)
	tb.Container.Parent = self.ContentFrame
	tb.Container.LayoutOrder = #self.Components
	return tb
end

function Section:CreateSeparator(options)
	options = options or {}
	local Separator = require(script.Parent.Separator)
	local sp = Separator:New(self, options)
	table.insert(self.Components, sp)
	sp.Container.Parent = self.ContentFrame
	sp.Container.LayoutOrder = #self.Components
	return sp
end

function Section:CreateKeybind(options)
	options = options or {}
	local Keybind = require(script.Parent.Keybind)
	local kb = Keybind:New(self, options)
	table.insert(self.Components, kb)
	kb.Container.Parent = self.ContentFrame
	kb.Container.LayoutOrder = #self.Components
	return kb
end

function Section:CreateColorPicker(options)
	options = options or {}
	local ColorPicker = require(script.Parent.ColorPicker)
	local cp = ColorPicker:New(self, options)
	table.insert(self.Components, cp)
	cp.Container.Parent = self.ContentFrame
	cp.Container.LayoutOrder = #self.Components
	return cp
end

function Section:CreateProgressBar(options)
	options = options or {}
	local ProgressBar = require(script.Parent.ProgressBar)
	local pb = ProgressBar:New(self, options)
	table.insert(self.Components, pb)
	pb.Container.Parent = self.ContentFrame
	pb.Container.LayoutOrder = #self.Components
	return pb
end

function Section:CreateSearchBar(options)
	options = options or {}
	local SearchBar = require(script.Parent.SearchBar)
	local sb = SearchBar:New(self, options)
	table.insert(self.Components, sb)
	sb.Container.Parent = self.ContentFrame
	sb.Container.LayoutOrder = #self.Components
	return sb
end

function Section:CreateMultiDropdown(options)
	options = options or {}
	local MultiDropdown = require(script.Parent.MultiDropdown)
	local md = MultiDropdown:New(self, options)
	table.insert(self.Components, md)
	md.Container.Parent = self.ContentFrame
	md.Container.LayoutOrder = #self.Components
	return md
end

function Section:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.Divider, {BackgroundColor3 = palette.Divider}, "Smooth", "Out", 0.3)
		AnimationManager:CreateTween(self.HeaderLabel, {TextColor3 = palette.HeaderText}, "Smooth", "Out", 0.3)
	else
		self.Divider.BackgroundColor3 = palette.Divider
		self.HeaderLabel.TextColor3 = palette.HeaderText
	end
end

function Section:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	for _, comp in ipairs(self.Components) do
		comp:Destroy()
	end
	self.Container:Destroy()
end

return Section
