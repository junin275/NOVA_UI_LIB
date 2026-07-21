local FloatingButton = {}
FloatingButton.__index = FloatingButton

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)
local DragService = require(script.Parent.Parent.Services.DragService)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local FLOATING_BUTTONS = {}

function FloatingButton:New(options)
	options = options or {}

	local self = setmetatable({}, FloatingButton)

	self.Name = options.Name or "FloatingButton"
	self.Icon = options.Icon or "Plus"
	self.Size = options.Size or 44
	self.Color = options.Color or "Accent"
	self.Position = options.Position or UDim2.new(1, -(self.Size + 20), 1, -(self.Size + 20))
	self.Callback = options.Callback or function() end
	self.Tooltip = options.Tooltip or nil

	local parent = (type(gethui) == "function" and pcall(gethui) or nil)
	if type(parent) ~= "table" or typeof(parent) ~= "Instance" then
		local success, err = pcall(function() parent = CoreGui end)
		if not success then
			local plrGui = Player:FindFirstChild("PlayerGui")
			parent = plrGui or Player:WaitForChild("PlayerGui", 5)
		end
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Nova_FAB_" .. self.Name
	screenGui.DisplayOrder = 50
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parent
	self.ScreenGui = screenGui

	local buttonFrame = Instance.new("TextButton")
	buttonFrame.Name = "FAB"
	buttonFrame.Size = UDim2.new(0, self.Size, 0, self.Size)
	buttonFrame.Position = self.Position
	buttonFrame.BackgroundColor3 = ThemeManager:GetColor(self.Color)
	buttonFrame.BorderSizePixel = 0
	buttonFrame.Text = ""
	buttonFrame.AutoButtonColor = false
	buttonFrame.Parent = screenGui
	self.ButtonFrame = buttonFrame
	Utility:CreateCorner(buttonFrame, self.Size / 2)

	local shadow = Utility:CreateShadow(buttonFrame, 0.7, 8, Color3.fromRGB(0, 0, 0))

	local iconLabel = IconManager:CreateIconLabel(buttonFrame, self.Icon, UDim2.new(0, self.Size * 0.45, 0, self.Size * 0.45), Color3.fromRGB(255, 255, 255))
	if iconLabel then
		iconLabel.Position = UDim2.new(0.5, -self.Size * 0.225, 0.5, -self.Size * 0.225)
	end

	buttonFrame.MouseEnter:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size + 4, 0, self.Size + 4)
		}, "Smooth", "Out", 0.15)
		SoundManager:PlayHover()
	end)

	buttonFrame.MouseLeave:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size, 0, self.Size)
		}, "Smooth", "Out", 0.2)
	end)

	buttonFrame.MouseButton1Down:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size - 4, 0, self.Size - 4)
		}, "Sharp", "In", 0.08)
	end)

	buttonFrame.MouseButton1Up:Connect(function()
		AnimationManager:CreateTween(buttonFrame, {
			Size = UDim2.new(0, self.Size + 4, 0, self.Size + 4)
		}, "Elastic", "Out", 0.3)
	end)

	buttonFrame.MouseButton1Click:Connect(function()
		SoundManager:PlayClick()
		AnimationManager:RippleEffect(buttonFrame, Color3.fromRGB(255, 255, 255), 0.4)
		pcall(self.Callback)
	end)

	DragService:MakeDraggable(buttonFrame, buttonFrame, {
		ConstrainToScreen = true,
		SmoothDrag = true,
	})

	if self.Tooltip then
		local Tooltip = require(script.Parent.Tooltip)
		self._tooltip = Tooltip:New(buttonFrame, self.Tooltip, {Position = "Left", Delay = 0.8})
	end

	table.insert(FLOATING_BUTTONS, self)

	AnimationManager:CreateTween(buttonFrame, {
		Size = UDim2.new(0, self.Size, 0, self.Size)
	}, "Elastic", "Out", 0.5)

	self._themeConnection = ThemeManager:OnChange(function(palette, animate)
		self:UpdateTheme(palette, animate)
	end)

	return self
end

function FloatingButton:SetCallback(callback)
	self.Callback = callback
end

function FloatingButton:SetIcon(iconName)
	self.Icon = iconName
end

function FloatingButton:UpdateTheme(palette, animate)
	if animate then
		AnimationManager:CreateTween(self.ButtonFrame, {
			BackgroundColor3 = palette[self.Color] or palette.Accent,
		}, "Smooth", "Out", 0.3)
	else
		self.ButtonFrame.BackgroundColor3 = palette[self.Color] or palette.Accent
	end
end

function FloatingButton:Destroy()
	if self._themeConnection then
		self._themeConnection()
	end
	if self._tooltip then
		self._tooltip:Destroy()
	end
	for i, fb in ipairs(FLOATING_BUTTONS) do
		if fb == self then
			table.remove(FLOATING_BUTTONS, i)
			break
		end
	end
	self.ScreenGui:Destroy()
end

return FloatingButton
