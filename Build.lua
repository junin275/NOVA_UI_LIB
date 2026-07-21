local function read(p)
	local f = io.open(p, "r")
	if not f then error("not found: " .. p) end
	local c = f:read("*a")
	f:close()
	return c
end

local MODULES = {
	ThemeManager = "Core/ThemeManager.lua",
	AnimationManager = "Core/AnimationManager.lua",
	Utility = "Core/Utility.lua",
	IconManager = "Core/IconManager.lua",
	SoundManager = "Core/SoundManager.lua",
	ConfigService = "Services/ConfigService.lua",
	DragService = "Services/DragService.lua",
	Window = "Components/Window.lua",
	Tab = "Components/Tab.lua",
	Section = "Components/Section.lua",
	Button = "Components/Button.lua",
	Toggle = "Components/Toggle.lua",
	Slider = "Components/Slider.lua",
	Dropdown = "Components/Dropdown.lua",
	MultiDropdown = "Components/MultiDropdown.lua",
	TextBox = "Components/TextBox.lua",
	Keybind = "Components/Keybind.lua",
	Label = "Components/Label.lua",
	Paragraph = "Components/Paragraph.lua",
	ColorPicker = "Components/ColorPicker.lua",
	Notification = "Components/Notification.lua",
	Dialog = "Components/Dialog.lua",
	Tooltip = "Components/Tooltip.lua",
	Separator = "Components/Separator.lua",
	ProgressBar = "Components/ProgressBar.lua",
	SearchBar = "Components/SearchBar.lua",
	MiniConsole = "Components/MiniConsole.lua",
	Image = "Components/Image.lua",
	Icon = "Components/Icon.lua",
	LoadingScreen = "Components/LoadingScreen.lua",
	FloatingButton = "Components/FloatingButton.lua",
	Watermark = "Components/Watermark.lua",
	FPSCounter = "Components/FPSCounter.lua",
}

-- Read and strip module headers/returns
local function loadModule(name)
	local path = MODULES[name]
	local code = read(path)
	code = code:gsub("^local [%w_]+ = require%([^\n]+%)", "")
	code = code:gsub("\nlocal [%w_]+ = require%([^\n]+%)", "\n")
	code = code:gsub("local ([%w_]+) = require%(script%.Parent%.([%w_]+)%)", "local %1 = NovaUI.%2")
	code = code:gsub("local ([%w_]+) = require%(script%.Parent%.Parent%.Core%.([%w_]+)%)", "local %1 = NovaUI.%2")
	code = code:gsub("local ([%w_]+) = require%(script%.Parent%.Parent%.Services%.([%w_]+)%)", "local %1 = NovaUI.%2")
	code = code:gsub("^return ([%w_]+)", "NovaUI.%1 = %1")
	code = code:gsub("\nreturn ([%w_]+)", "\nNovaUI.%1 = %1")
	return code
end

local out = {}
table.insert(out, "-- Nova UI v1.0.0 - Single File Build")
table.insert(out, "local NovaUI = {}\n")

for _, name in ipairs({
	"Utility", "ThemeManager", "AnimationManager", "IconManager", "SoundManager",
	"ConfigService", "DragService",
}) do
	table.insert(out, "-- " .. name)
	table.insert(out, loadModule(name))
	table.insert(out, "")
end

for _, name in ipairs({
	"Window", "Tab", "Section", "Button", "Toggle", "Slider",
	"Dropdown", "MultiDropdown", "TextBox", "Keybind",
	"Label", "Paragraph", "ColorPicker", "Notification",
	"Dialog", "Tooltip", "Separator", "ProgressBar",
	"SearchBar", "MiniConsole", "Image", "Icon",
	"LoadingScreen", "FloatingButton", "Watermark", "FPSCounter",
}) do
	table.insert(out, "-- " .. name)
	table.insert(out, loadModule(name))
	table.insert(out, "")
end

-- Init
local init = read("Init.lua")
init = init:gsub("local NovaUI = {}", "")
init = init:gsub("NovaUI%.[%w_]+ = require%([^\n]+%)", "")
init = init:gsub("local [%w_]+ = require%([^\n]+%)", "")
init = init:gsub("^return NovaUI", "")
table.insert(out, init)

table.insert(out, "\nreturn NovaUI")

local result = table.concat(out, "\n")
local f = io.open("NovaUIBuilt.lua", "w")
f:write(result)
f:close()
print("OK - NovaUIBuilt.lua (" .. #result .. " bytes)")
