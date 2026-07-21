local Library = require(path.to.NovaUI.Init)

local Window = Library:CreateWindow({
	Title = "Nova UI",
	Size = UDim2.new(0, 720, 0, 520),
	Icon = "Bolt",
	Resizable = true,
})

local MainTab = Window:CreateTab({
	Name = "Home",
	Icon = "Home",
})

local SettingsTab = Window:CreateTab({
	Name = "Settings",
	Icon = "Sliders",
})

local AboutTab = Window:CreateTab({
	Name = "About",
	Icon = "Info",
})

local GeneralSection = MainTab:CreateSection({
	Name = "General",
	Description = "Basic controls",
})

GeneralSection:CreateButton({
	Name = "Click Me",
	Description = "This is a button",
	Callback = function()
		Library:CreateNotification({
			Title = "Button Clicked",
			Message = "You clicked the button!",
			Type = "Success",
			Duration = 3,
		})
	end,
})

GeneralSection:CreateToggle({
	Name = "Enable Feature",
	Description = "Turn on/off the main feature",
	Default = true,
	Callback = function(value)
		print("Toggle:", value)
	end,
})

GeneralSection:CreateSlider({
	Name = "Volume",
	Description = "Adjust volume level",
	Min = 0,
	Max = 100,
	Default = 50,
	Suffix = "%",
	Precision = 0,
	Callback = function(value)
		print("Volume:", value)
	end,
})

local UISection = MainTab:CreateSection({
	Name = "UI Elements",
	Description = "Various UI controls",
})

UISection:CreateDropdown({
	Name = "Theme",
	Description = "Select a theme",
	Items = Library:GetThemes(),
	Default = "Default",
	Callback = function(value)
		Library:SetTheme(value)
	end,
})

UISection:CreateColorPicker({
	Name = "Accent Color",
	Default = Color3.fromRGB(79, 124, 255),
	Callback = function(color)
		Library:SetAccentColor(color)
	end,
})

UISection:CreateTextBox({
	Name = "Username",
	Placeholder = "Enter your username",
	Default = "",
	Callback = function(text, enterPressed)
		print("Input:", text, "Enter:", enterPressed)
	end,
})

UISection:CreateKeybind({
	Name = "Activate",
	Default = Enum.KeyCode.LeftControl,
	Callback = function()
		print("Keybind pressed!")
	end,
	ChangeCallback = function(newKey)
		print("Key changed to:", newKey.Name)
	end,
})

UISection:CreateSearchBar({
	Placeholder = "Search...",
	Callback = function(query)
		print("Searching:", query)
	end,
})

local ConsoleSection = SettingsTab:CreateSection({
	Name = "Console",
	Description = "Debug output",
})

local Console = ConsoleSection:CreateMiniConsole({
	Name = "Debug Console",
})

Console:Log("System initialized")
Console:Success("All systems operational")
Console:Warn("Memory usage rising")
Console:Error("Connection failed")

ConsoleSection:CreateButton({
	Name = "Test Log",
	Callback = function()
		Console:Log("Button was pressed at " .. tick())
	end,
})

local InfoSection = AboutTab:CreateSection({
	Name = "About Nova UI",
})

InfoSection:CreateLabel({
	Text = "Nova UI v1.0.0",
	TextSize = 16,
	Color = "TextPrimary",
})

InfoSection:CreateParagraph({
	Title = "Description",
	Text = "A modern, premium UI library for Roblox with smooth animations and a clean dark theme.",
})

InfoSection:CreateSeparator({
	Text = "Credits",
})

InfoSection:CreateLabel({
	Text = "Built with love in Lua",
	TextSize = 12,
	Color = "TextMuted",
})

InfoSection:CreateProgressBar({
	Name = "Loading",
	Default = 65,
	Max = 100,
	Suffix = "%",
})

-- Floating action button
Library:CreateFloatingButton({
	Icon = "Bell",
	Position = UDim2.new(1, -70, 1, -70),
	Callback = function()
		Library:CreateNotification({
			Title = "Notification",
			Message = "This is a floating button action!",
			Type = "Info",
			Duration = 3,
		})
	end,
})

-- Watermark
Library:CreateWatermark({
	Title = "Nova UI",
	Version = "1.0.0",
	SubText = "| User",
})

-- FPS Counter
Library:CreateFPSCounter()

-- Dialog example
local dialogSection = SettingsTab:CreateSection({
	Name = "Dialogs",
})

dialogSection:CreateButton({
	Name = "Show Dialog",
	Callback = function()
		Library:CreateDialog({
			Title = "Confirm Action",
			Message = "Are you sure you want to proceed with this action?",
			Buttons = {"Confirm", "Cancel"},
			DefaultButton = 2,
			Type = "Warning",
			Callback = function(button, index)
				print("Dialog result:", button, index)
			end,
		})
	end,
})
