local Dropdown = {}
Dropdown.__index = Dropdown

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

function Dropdown:New(section, options)
	options = options or {}

	local self = setmetatable({}, Dropdown)

	self.Section = section
	self.Name = options.Name or "Dropdown"
	self.Description = options.Description or nil
	self.Items = options.Items or {}
	self.Default = options.Default or nil
	self.Callback = options.Callback or function() end
	self.Searchable = options.Searchable or false
	self._open = false
	self._selected = self.Default

	local container = Instance.new("Frame")
	container.Name = "Dropdown_" .. self.Name
	container.Size = UDim2.new(1, 0, 0, 0)
	container.BackgroundTransparency = 1
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.AutomaticSize = Enum.AutomaticSize.Y
	self.Container = container

	local mainFrame = Instance.new("TextButton")
	mainFrame.Name = "Main"
	mainFrame.Size = UDim2.new(1, 0, 0, 34)
	mainFrame.BackgroundTransparency = 1
	mainFrame.BorderSizePixel = 0
	mainFrame.Text = ""
	mainFrame.AutoButtonColor = false
	mainFrame.Parent = container
	self.MainFrame = mainFrame

	Utility:CreateCorner(mainFrame, 6)
	Utility:CreateStroke(mainFrame, ThemeManager:GetColor("Border"), 0.5, 1)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Name"
	nameLabel.Size = UDim2.new(0.7, -40, 1, 0)
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

	local selectedLabel = Instance.new("TextLabel")
	selectedLabel.Name = "Selected"
	selectedLabel.Size = UDim2.new(0.3, -10, 1, 0)
	selectedLabel.Position = UDim2.new(0.7, -20, 0, 0)
	selectedLabel.BackgroundTransparency = 1
	selectedLabel.BorderSizePixel = 0
	selectedLabel.Text = self._selected or "Select..."
	selectedLabel.Font = Enum.Font.Gotham
	selectedLabel.TextSize = 13
	selectedLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
	selectedLabel.TextYAlignment = Enum.TextYAlignment.Center
	selectedLabel.Parent = mainFrame
	self.SelectedLabel = selectedLabel

	local arrowIcon = IconManager:CreateIconLabel(mainFrame, "ChevronDown", UDim2.new(0, 14, 0, 14), ThemeManager:GetColor("TextMuted"))
	if arrowIcon then
		arrowIcon.Position = UDim2.new(1, -24, 0.5, -7)
		self.ArrowIcon = arrowIcon
	end

	local dropdownList = Instance.new("Frame")
	dropdownList.Name = "DropdownList"
	dropdownList.Size = UDim2.new(1, 0, 0, 0)
	dropdownList.Position = UDim2.new(0, 0, 0, 36)
	dropdownList.BackgroundColor3 = ThemeManager:GetColor("SurfaceAlt")
	dropdownList.BorderSizePixel = 0
	dropdownList.Visible = false
	dropdownList.Parent = container
	self.DropdownList = dropdownList

	Utility:CreateCorner(dropdownList, 6)
	Utility:CreateStroke(dropdownList, ThemeManager:GetColor("Border"), 0.5, 1)

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Padding = UDim.new(0, 2)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = dropdownList

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.PaddingLeft = UDim.new(0, 4)
	padding.PaddingRight = UDim.new(0, 4)
	padding.Parent = dropdownList

	self._itemButtons = {}

	for _, item in ipairs(self.Items) do
		self:CreateItemButton(item)
	end

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
		SoundManager:PlayDropdown()
	end)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function Dropdown:CreateItemButton(item)
	local itemBtn = Instance.new("TextButton")
	itemBtn.Name = "Item_" .. tostring(item)
	itemBtn.Size = UDim2.new(1, 0, 0, 28)
	itemBtn.BackgroundTransparency = 1
	itemBtn.BorderSizePixel = 0
	itemBtn.Text = ""
	itemBtn.AutoButtonColor = false
	itemBtn.Parent = self.DropdownList

	local itemLabel = Instance.new("TextLabel")
	itemLabel.Name = "ItemLabel"
	itemLabel.Size = UDim2.new(1, -16, 1, 0)
	itemLabel.Position = UDim2.new(0, 8, 0, 0)
	itemLabel.BackgroundTransparency = 1
	itemLabel.BorderSizePixel = 0
	itemLabel.Text = tostring(item)
	itemLabel.Font = Enum.Font.Gotham
	itemLabel.TextSize = 13
	itemLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	itemLabel.TextXAlignment = Enum.TextXAlignment.Left
	itemLabel.TextYAlignment = Enum.TextYAlignment.Center
	itemLabel.Parent = itemBtn

	Utility:CreateCorner(itemBtn, 4)

	itemBtn.MouseEnter:Connect(function()
		AnimationManager:CreateTween(itemBtn, {
			BackgroundTransparency = 0.1
		}, "Smooth", "Out", 0.1)
		AnimationManager:CreateTween(itemLabel, {
			TextColor3 = ThemeManager:GetColor("TextPrimary")
		}, "Smooth", "Out", 0.1)
	end)

	itemBtn.MouseLeave:Connect(function()
		if self._selected ~= item then
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.15)
			AnimationManager:CreateTween(itemLabel, {
				TextColor3 = ThemeManager:GetColor("TextSecondary")
			}, "Smooth", "Out", 0.15)
		end
	end)

	itemBtn.MouseButton1Click:Connect(function()
		self:Select(item)
		self:Close()
		SoundManager:PlayClick()
	end)

	self._itemButtons[item] = {
		Button = itemBtn,
		Label = itemLabel
	}

	if self._selected == item then
		itemBtn.BackgroundTransparency = 0.12
		itemLabel.TextColor3 = ThemeManager:GetColor("Accent")
	end
end

function Dropdown:Select(item)
	self._selected = item
	self.SelectedLabel.Text = tostring(item)

	for i, data in self._itemButtons do
		if i == item then
			AnimationManager:CreateTween(data.Button, {
				BackgroundTransparency = 0.12
			}, "Smooth", "Out", 0.15)
			AnimationManager:CreateTween(data.Label, {
				TextColor3 = ThemeManager:GetColor("Accent")
			}, "Smooth", "Out", 0.15)
		else
			AnimationManager:CreateTween(data.Button, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.15)
			AnimationManager:CreateTween(data.Label, {
				TextColor3 = ThemeManager:GetColor("TextSecondary")
			}, "Smooth", "Out", 0.15)
		end
	end

	pcall(self.Callback, item)
end

function Dropdown:Toggle()
	if self._open then
		self:Close()
	else
		self:Open()
	end
end

function Dropdown:Open()
	self._open = true
	self.DropdownList.Visible = true

	local itemCount = #self.Items
	local listHeight = math.min(itemCount, 6) * 30 + 8
	self.DropdownList.Size = UDim2.new(1, 0, 0, 0)

	AnimationManager:CreateTween(self.DropdownList, {
		Size = UDim2.new(1, 0, 0, listHeight)
	}, "Smooth", "Out", 0.25)

	if self.ArrowIcon then
		AnimationManager:CreateTween(self.ArrowIcon, {
			Rotation = 180
		}, "Smooth", "Out", 0.25)
	end
end

function Dropdown:Close()
	self._open = false
	AnimationManager:CreateTween(self.DropdownList, {
		Size = UDim2.new(1, 0, 0, 0)
	}, "Smooth", "Out", 0.2, function()
		self.DropdownList.Visible = false
	end)

	if self.ArrowIcon then
		AnimationManager:CreateTween(self.ArrowIcon, {
			Rotation = 0
		}, "Smooth", "Out", 0.2)
	end

	AnimationManager:CreateTween(self.MainFrame, {
		BackgroundTransparency = 1
	}, "Smooth", "Out", 0.2)
end

function Dropdown:SetItems(items)
	self.Items = items
	for _, data in self._itemButtons do
		data.Button:Destroy()
	end
	self._itemButtons = {}
	for _, item in ipairs(self.Items) do
		self:CreateItemButton(item)
	end
end

function Dropdown:GetValue()
	return self._selected
end

function Dropdown:SetCallback(callback)
	self.Callback = callback
end

function Dropdown:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.DropdownList, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.DropdownList.BackgroundColor3 = palette.SurfaceAlt
	end
end

function Dropdown:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

return Dropdown
