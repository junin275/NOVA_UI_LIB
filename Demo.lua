local Library = require(script.Init)

local Window = Library:CreateWindow({
	Title = "Nova UI Demo",
	Size = UDim2.new(0, 720, 0, 520),
	Icon = "Bolt",
	Resizable = true,
})

-- ABAS
local Main = Window:CreateTab({Name = "Main", Icon = "Home"})
local Inputs = Window:CreateTab({Name = "Input", Icon = "Edit"})
local Visuals = Window:CreateTab({Name = "Visuals", Icon = "Palette"})
local Extra = Window:CreateTab({Name = "Extra", Icon = "Grid"})
local About = Window:CreateTab({Name = "About", Icon = "Info"})

-- ===== MAIN =====
local S1 = Main:CreateSection({Name = "Controls", Description = "Basic UI components"})

S1:CreateButton({
	Name = "Notify me",
	Description = "Shows a notification",
	Callback = function()
		Library:CreateNotification({
			Title = "Hello!",
			Message = "This is a notification from Nova UI",
			Type = "Success",
			Duration = 3,
		})
	end,
})

S1:CreateToggle({
	Name = "Dark Mode",
	Description = "Toggle dark theme",
	Default = true,
	Callback = function(v) print("Dark mode:", v) end,
})

S1:CreateSlider({
	Name = "Volume",
	Description = "Adjust volume",
	Min = 0, Max = 100, Default = 50,
	Suffix = "%", Precision = 0,
	Callback = function(v) print("Volume:", v) end,
})

S1:CreateSlider({
	Name = "Sensitivity",
	Description = "Fine adjustment",
	Min = 0, Max = 10, Default = 5.5,
	Suffix = "", Precision = 1,
	Callback = function(v) print("Sens:", v) end,
})

local S2 = Main:CreateSection({Name = "Selection", Description = "Dropdowns"})

S2:CreateDropdown({
	Name = "Theme",
	Description = "Pick a theme",
	Items = Library:GetThemes(),
	Default = "Default",
	Callback = function(v) Library:SetTheme(v) end,
})

S2:CreateMultiDropdown({
	Name = "Tags",
	Description = "Select multiple options",
	Items = {"Red", "Blue", "Green", "Yellow", "Purple", "Orange"},
	Default = {"Red", "Blue"},
	Callback = function(v) print("Selected:", unpack(v)) end,
})

-- ===== INPUT =====
local S3 = Inputs:CreateSection({Name = "Text Input"})

S3:CreateTextBox({
	Name = "Username",
	Placeholder = "Enter your name",
	Default = "Player",
	Callback = function(t, enter) print("Name:", t, "Enter:", enter) end,
})

S3:CreateSearchBar({
	Placeholder = "Search...",
	Callback = function(q) print("Search:", q) end,
})

S3:CreateKeybind({
	Name = "Activate",
	Description = "Press to trigger",
	Default = Enum.KeyCode.F,
	Callback = function() print("Keybind triggered!") end,
	ChangeCallback = function(k) print("New key:", k.Name) end,
})

local S4 = Inputs:CreateSection({Name = "Color"})

S4:CreateColorPicker({
	Name = "Accent Color",
	Default = Color3.fromRGB(79, 124, 255),
	Callback = function(c) Library:SetAccentColor(c) end,
})

-- ===== VISUALS =====
local S5 = Visuals:CreateSection({Name = "Display"})

local progress = S5:CreateProgressBar({
	Name = "Loading",
	Default = 0, Max = 100, Suffix = "%",
})

S5:CreateButton({
	Name = "Start Progress",
	Callback = function()
		for i = 0, 100, 5 do
			task.wait(0.05)
			progress:SetValue(i)
		end
	end,
})

S5:CreateSeparator({Text = "Info"})

S5:CreateLabel({Text = "Regular label", Color = "TextPrimary"})
S5:CreateLabel({Text = "Muted label", Color = "TextMuted", TextSize = 12})

S5:CreateParagraph({
	Title = "Description",
	Text = "Nova UI is a modern library with smooth animations and a clean dark theme.",
})

S5:CreateImage({
	ImageId = "rbxassetid://6031394888",
	Size = UDim2.new(1, -20, 0, 100),
	Caption = "Sample image",
})

local S6 = Visuals:CreateSection({Name = "Console"})

local console = S6:CreateMiniConsole({Name = "Debug Console"})
console:Log("System ready")
console:Success("All good")
console:Warn("Check settings")
console:Error("Test error")
console:Command("> help")

S6:CreateButton({Name = "Test Log", Callback = function() console:Log("Button pressed at " .. tick()) end})

-- ===== EXTRA =====
local S7 = Extra:CreateSection({Name = "Floating UI"})

S7:CreateButton({
	Name = "Toggle FPS",
	Callback = function()
		if not _G._fps then
			_G._fps = Library:CreateFPSCounter()
		else
			_G._fps:Destroy()
			_G._fps = nil
		end
	end,
})

S7:CreateButton({
	Name = "Toggle Watermark",
	Callback = function()
		if not _G._wm then
			_G._wm = Library:CreateWatermark({Title = "Nova UI", Version = "1.0", ShowFPS = true})
		else
			_G._wm:Destroy()
			_G._wm = nil
		end
	end,
})

S7:CreateButton({
	Name = "Show Dialog",
	Callback = function()
		Library:CreateDialog({
			Title = "Confirm",
			Message = "Do you want to continue?",
			Buttons = {"Yes", "No"},
			Type = "Warning",
			Callback = function(btn) print("Dialog:", btn) end,
		})
	end,
})

S7:CreateButton({
	Name = "Loading Screen",
	Callback = function()
		local ld = Library:CreateLoadingScreen({Title = "Loading...", Message = "Please wait"})
		task.delay(2, function() ld:Destroy() end)
	end,
})

local S8 = Extra:CreateSection({Name = "Floating Button"})

Library:CreateFloatingButton({
	Icon = "Bell",
	Position = UDim2.new(1, -70, 1, -70),
	Callback = function()
		Library:CreateNotification({Title = "FAB", Message = "Floating button clicked!", Type = "Info"})
	end,
})

-- ===== ABOUT =====
local S9 = About:CreateSection({Name = "Nova UI"})

S9:CreateLabel({Text = "Nova UI v1.0.0", TextSize = 18, Color = "Accent"})
S9:CreateParagraph({
	Title = "A modern Roblox UI library",
	Text = "Dark premium theme with smooth animations, modular architecture, and a unique visual identity.",
})
S9:CreateSeparator()
S9:CreateLabel({Text = "Components: 26", Color = "TextSecondary", TextSize = 13})
S9:CreateLabel({Text = "Themes: 5 built-in", Color = "TextSecondary", TextSize = 13})
S9:CreateLabel({Text = "Icons: 70+ included", Color = "TextSecondary", TextSize = 13})

Library:CreateWatermark({Title = "Nova UI", Version = "1.0.0", SubText = "| Demo"})
