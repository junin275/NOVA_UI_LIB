local Notification = {}
Notification.__index = Notification

local ThemeManager = require(script.Parent.Parent.Core.ThemeManager)
local AnimationManager = require(script.Parent.Parent.Core.AnimationManager)
local Utility = require(script.Parent.Parent.Core.Utility)
local IconManager = require(script.Parent.Parent.Core.IconManager)
local SoundManager = require(script.Parent.Parent.Core.SoundManager)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local ACTIVE_NOTIFICATIONS = {}
local NOTIFICATION_HEIGHT = 60
local NOTIFICATION_GAP = 8

local function getNotificationParent()
	local parent = (type(gethui) == "function" and pcall(gethui) or nil)
	if type(parent) ~= "table" or typeof(parent) ~= "Instance" then
		local success, err = pcall(function() parent = CoreGui end)
		if not success then
			local plrGui = Player:FindFirstChild("PlayerGui")
			parent = plrGui or Player:WaitForChild("PlayerGui", 5)
		end
	end

	local notifGui = parent and parent:FindFirstChild("Nova_Notifications")
	if not notifGui then
		notifGui = Instance.new("ScreenGui")
		notifGui.Name = "Nova_Notifications"
		notifGui.DisplayOrder = 100
		notifGui.IgnoreGuiInset = true
		notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		notifGui.Parent = parent
	end

	return notifGui
end

function Notification:New(options)
	options = options or {}

	local self = setmetatable({}, Notification)

	self.Title = options.Title or "Notification"
	self.Message = options.Message or ""
	self.Duration = options.Duration or 4
	self.Type = options.Type or "Info"
	self.Icon = options.Icon or nil

	local parent = getNotificationParent()

	local container = Instance.new("Frame")
	container.Name = "Notification"
	container.Size = UDim2.new(0, 340, 0, NOTIFICATION_HEIGHT)
	container.Position = UDim2.new(1, 20, 1, -(20 + NOTIFICATION_HEIGHT))
	container.BackgroundColor3 = ThemeManager:GetColor("Surface")
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.Parent = parent
	self.Container = container

	Utility:CreateCorner(container, 8)
	Utility:CreateStroke(container, ThemeManager:GetColor("Border"), 0.5, 1)

	local typeColors = {
		Info = ThemeManager:GetColor("Info"),
		Success = ThemeManager:GetColor("Success"),
		Warning = ThemeManager:GetColor("Warning"),
		Error = ThemeManager:GetColor("Danger"),
	}

	local typeIcons = {
		Info = "Info",
		Success = "Check",
		Warning = "Warning",
		Error = "Cross",
	}

	local accentColor = typeColors[self.Type] or typeColors.Info

	local accentBar = Instance.new("Frame")
	accentBar.Name = "AccentBar"
	accentBar.Size = UDim2.new(0, 3, 1, 0)
	accentBar.BackgroundColor3 = accentColor
	accentBar.BorderSizePixel = 0
	accentBar.Parent = container

	local icon = IconManager:CreateIconLabel(container, self.Icon or typeIcons[self.Type], UDim2.new(0, 20, 0, 20), accentColor)
	if icon then
		icon.Position = UDim2.new(0, 14, 0.5, -10)
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -(icon and 48 or 28), 0, 18)
	titleLabel.Position = UDim2.new(0, (icon and 42 or 16), 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderSizePixel = 0
	titleLabel.Text = self.Title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = ThemeManager:GetColor("TextPrimary")
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.Parent = container
	self.TitleLabel = titleLabel

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Name = "Message"
	messageLabel.Size = UDim2.new(1, -(icon and 48 or 28), 0, 18)
	messageLabel.Position = UDim2.new(0, (icon and 42 or 16), 0, 26)
	messageLabel.BackgroundTransparency = 1
	messageLabel.BorderSizePixel = 0
	messageLabel.Text = self.Message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 12
	messageLabel.TextColor3 = ThemeManager:GetColor("TextSecondary")
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.TextWrapped = true
	messageLabel.Parent = container
	self.MessageLabel = messageLabel

	local progressBar = Instance.new("Frame")
	progressBar.Name = "Progress"
	progressBar.Size = UDim2.new(1, 0, 0, 2)
	progressBar.Position = UDim2.new(0, 0, 1, -2)
	progressBar.BackgroundColor3 = accentColor
	progressBar.BorderSizePixel = 0
	progressBar.Parent = container
	self.ProgressBar = progressBar

	container.Position = UDim2.new(1, 20, 1, -(20 + NOTIFICATION_HEIGHT))
	container.Visible = false

	table.insert(ACTIVE_NOTIFICATIONS, self)
	self:UpdatePositions()

	task.spawn(function()
		self:Show()
		task.wait(self.Duration)
		self:Hide()
	end)

	return self
end

function Notification:Show()
	self.Container.Visible = true

	AnimationManager:CreateTween(self.Container, {
		Position = UDim2.new(1, -(340 + 10), 1, -(20 + NOTIFICATION_HEIGHT))
	}, "Smooth", "Out", 0.4)

	AnimationManager:CreateTween(self.ProgressBar, {
		Size = UDim2.new(0, 0, 0, 2)
	}, "Linear", "In", self.Duration)

	self:UpdatePositions()

	SoundManager:PlayNotification()
end

function Notification:Hide()
	AnimationManager:CreateTween(self.Container, {
		Position = UDim2.new(1, 20, 1, -(20 + NOTIFICATION_HEIGHT))
	}, "Smooth", "In", 0.3, function()
		self:Destroy()
	end)
end

function Notification:UpdatePositions()
	local yOffset = 20
	for i = #ACTIVE_NOTIFICATIONS, 1, -1 do
		local notif = ACTIVE_NOTIFICATIONS[i]
		if notif and notif.Container then
			AnimationManager:CreateTween(notif.Container, {
				Position = UDim2.new(1, -(340 + 10), 1, -(yOffset + NOTIFICATION_HEIGHT))
			}, "Smooth", "Out", 0.35)
			yOffset = yOffset + NOTIFICATION_HEIGHT + NOTIFICATION_GAP
		end
	end
end

function Notification:Destroy()
	for i, n in ipairs(ACTIVE_NOTIFICATIONS) do
		if n == self then
			table.remove(ACTIVE_NOTIFICATIONS, i)
			break
		end
	end
	self:UpdatePositions()
	self.Container:Destroy()
end

function Notification:ClearAll()
	for i = #ACTIVE_NOTIFICATIONS, 1, -1 do
		local notif = ACTIVE_NOTIFICATIONS[i]
		if notif then
			notif:Hide()
		end
	end
end

return Notification
