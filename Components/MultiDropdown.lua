local MultiDropdown = {}
MultiDropdown.__index = MultiDropdown

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

function MultiDropdown:New(section, options)
	options = options or {}

	local self = setmetatable({}, MultiDropdown)

	self.Section = section
	self.Name = options.Name or "MultiDropdown"
	self.Description = options.Description or nil
	self.Items = options.Items or {}
	self.Default = options.Default or {}
	self.Callback = options.Callback or function() end
	self._open = false
	self._selected = {}

	for _, item in ipairs(self.Default) do
		self._selected[item] = true
	end

	local container = Instance.new("Frame")
	container.Name = "MultiDropdown_" .. self.Name
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

	local countLabel = Instance.new("TextLabel")
	countLabel.Name = "Count"
	countLabel.Size = UDim2.new(0.3, -10, 1, 0)
	countLabel.Position = UDim2.new(0.7, -20, 0, 0)
	countLabel.BackgroundTransparency = 1
	countLabel.BorderSizePixel = 0
	countLabel.Text = "0 selected"
	countLabel.Font = Enum.Font.Gotham
	countLabel.TextSize = 13
	countLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	countLabel.TextXAlignment = Enum.TextXAlignment.Right
	countLabel.TextYAlignment = Enum.TextYAlignment.Center
	countLabel.Parent = mainFrame
	self.CountLabel = countLabel

	self:UpdateCount()

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

function MultiDropdown:CreateItemButton(item)
	local itemBtn = Instance.new("TextButton")
	itemBtn.Name = "Item_" .. tostring(item)
	itemBtn.Size = UDim2.new(1, 0, 0, 30)
	itemBtn.BackgroundTransparency = 1
	itemBtn.BorderSizePixel = 0
	itemBtn.Text = ""
	itemBtn.AutoButtonColor = false
	itemBtn.Parent = self.DropdownList

	local checkBox = Instance.new("Frame")
	checkBox.Name = "CheckBox"
	checkBox.Size = UDim2.new(0, 16, 0, 16)
	checkBox.Position = UDim2.new(0, 8, 0.5, -8)
	checkBox.BackgroundColor3 = ThemeManager:GetColor("Border")
	checkBox.BorderSizePixel = 0
	checkBox.Parent = itemBtn
	Utility:CreateCorner(checkBox, 3)

	local checkFill = Instance.new("Frame")
	checkFill.Name = "CheckFill"
	checkFill.Size = UDim2.new(0, 0, 0, 0)
	checkFill.Position = UDim2.new(0.5, 0, 0.5, 0)
	checkFill.AnchorPoint = Vector2.new(0.5, 0.5)
	checkFill.BackgroundColor3 = ThemeManager:GetColor("Accent")
	checkFill.BorderSizePixel = 0
	checkFill.Parent = checkBox
	Utility:CreateCorner(checkFill, 2)

	local checkIcon = IconManager:CreateIconLabel(checkBox, "Check", UDim2.new(0, 10, 0, 10), Color3.fromRGB(255, 255, 255))
	if checkIcon then
		checkIcon.Position = UDim2.new(0.5, -5, 0.5, -5)
		checkIcon.ImageTransparency = 1
	end

	local itemLabel = Instance.new("TextLabel")
	itemLabel.Name = "ItemLabel"
	itemLabel.Size = UDim2.new(1, -30, 1, 0)
	itemLabel.Position = UDim2.new(0, 28, 0, 0)
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

	local isSelected = self._selected[item] == true
	if isSelected then
		checkBox.BackgroundColor3 = ThemeManager:GetColor("Accent")
		checkFill.Size = UDim2.new(1, 0, 1, 0)
		checkFill.Position = UDim2.new(0, 0, 0, 0)
		checkFill.AnchorPoint = Vector2.new(0, 0)
		if checkIcon then
			checkIcon.ImageTransparency = 0
		end
		itemLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
		itemBtn.BackgroundTransparency = 0.08
	end

	itemBtn.MouseEnter:Connect(function()
		AnimationManager:CreateTween(itemBtn, {
			BackgroundTransparency = 0.05
		}, "Smooth", "Out", 0.1)
	end)

	itemBtn.MouseLeave:Connect(function()
		if not isSelected then
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.15)
		end
	end)

	itemBtn.MouseButton1Click:Connect(function()
		local currentlySelected = self._selected[item] == true
		self._selected[item] = not currentlySelected
		isSelected = not currentlySelected

		if isSelected then
			AnimationManager:CreateTween(checkBox, {
				BackgroundColor3 = ThemeManager:GetColor("Accent")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(checkFill, {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0)
			}, "Smooth", "Out", 0.2)
			if checkIcon then
				AnimationManager:CreateTween(checkIcon, {
					ImageTransparency = 0
				}, "Smooth", "Out", 0.15)
			end
			AnimationManager:CreateTween(itemLabel, {
				TextColor3 = ThemeManager:GetColor("TextPrimary")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 0.08
			}, "Smooth", "Out", 0.2)
		else
			AnimationManager:CreateTween(checkBox, {
				BackgroundColor3 = ThemeManager:GetColor("Border")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(checkFill, {
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}, "Smooth", "Out", 0.2)
			if checkIcon then
				AnimationManager:CreateTween(checkIcon, {
					ImageTransparency = 1
				}, "Smooth", "Out", 0.15)
			end
			AnimationManager:CreateTween(itemLabel, {
				TextColor3 = ThemeManager:GetColor("TextSecondary")
			}, "Smooth", "Out", 0.2)
			AnimationManager:CreateTween(itemBtn, {
				BackgroundTransparency = 1
			}, "Smooth", "Out", 0.2)
		end

		self:UpdateCount()
		SoundManager:PlayClick()
		pcall(self.Callback, self:GetValue())
	end)

	self._itemButtons[item] = {
		Button = itemBtn,
		Label = itemLabel,
		CheckBox = checkBox,
		CheckFill = checkFill,
		CheckIcon = checkIcon
	}
end

function MultiDropdown:UpdateCount()
	local count = 0
	for _, v in self._selected do
		if v then
			count = count + 1
		end
	end
	self.CountLabel.Text = count .. " selected"
end

function MultiDropdown:Toggle()
	if self._open then
		self:Close()
	else
		self:Open()
	end
end

function MultiDropdown:Open()
	self._open = true
	self.DropdownList.Visible = true

	local itemCount = #self.Items
	local listHeight = math.min(itemCount, 6) * 32 + 8
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

function MultiDropdown:Close()
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
end

function MultiDropdown:GetValue()
	local result = {}
	for item, selected in self._selected do
		if selected then
			table.insert(result, item)
		end
	end
	return result
end

function MultiDropdown:SetItems(items)
	self.Items = items
	for _, data in self._itemButtons do
		data.Button:Destroy()
	end
	self._itemButtons = {}
	for _, item in ipairs(self.Items) do
		self:CreateItemButton(item)
	end
end

function MultiDropdown:SetCallback(callback)
	self.Callback = callback
end

function MultiDropdown:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.DropdownList, {
			BackgroundColor3 = palette.SurfaceAlt,
		}, "Smooth", "Out", 0.3)
	else
		self.DropdownList.BackgroundColor3 = palette.SurfaceAlt
	end
end

function MultiDropdown:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	self.Container:Destroy()
end

return MultiDropdown
