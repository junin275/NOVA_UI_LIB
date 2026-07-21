local IconManager = {}

local ICONS = {
	Home = "rbxassetid://6031394888",
	Settings = "rbxassetid://6031408139",
	User = "rbxassetid://6031391086",
	Close = "rbxassetid://6031402747",
	Minimize = "rbxassetid://6031398099",
	Maximize = "rbxassetid://6031404249",
	Plus = "rbxassetid://6031401098",
	Minus = "rbxassetid://6031397225",
	Check = "rbxassetid://6031395585",
	Cross = "rbxassetid://6031402747",
	ArrowLeft = "rbxassetid://6031392802",
	ArrowRight = "rbxassetid://6031394514",
	ArrowUp = "rbxassetid://6031395208",
	ArrowDown = "rbxassetid://6031393544",
	Search = "rbxassetid://6031405476",
	Bell = "rbxassetid://6031406619",
	Info = "rbxassetid://6031409671",
	Warning = "rbxassetid://6031391894",
	Error = "rbxassetid://6031407286",
	Success = "rbxassetid://6031396423",
	Edit = "rbxassetid://6031408643",
	Trash = "rbxassetid://6031390505",
	Copy = "rbxassetid://6031401098",
	Menu = "rbxassetid://6031399646",
	More = "rbxassetid://6031403185",
	Refresh = "rbxassetid://6031401758",
	Lock = "rbxassetid://6031398138",
	Unlock = "rbxassetid://6031390474",
	Eye = "rbxassetid://6031409356",
	EyeOff = "rbxassetid://6031390950",
	Download = "rbxassetid://6031407617",
	Upload = "rbxassetid://6031391086",
	Folder = "rbxassetid://6031405912",
	File = "rbxassetid://6031408374",
	Play = "rbxassetid://6031401098",
	Pause = "rbxassetid://6031404249",
	Stop = "rbxassetid://6031402747",
	Music = "rbxassetid://6031399646",
	Image = "rbxassetid://6031403185",
	Video = "rbxassetid://6031390505",
	Star = "rbxassetid://6031406619",
	Heart = "rbxassetid://6031409671",
	Flag = "rbxassetid://6031391894",
	Tag = "rbxassetid://6031407286",
	Bookmark = "rbxassetid://6031396423",
	Share = "rbxassetid://6031408643",
	Link = "rbxassetid://6031392802",
	Map = "rbxassetid://6031394514",
	Camera = "rbxassetid://6031395208",
	Clock = "rbxassetid://6031393544",
	Calendar = "rbxassetid://6031405476",
	Gift = "rbxassetid://6031406619",
	Chart = "rbxassetid://6031409671",
	Terminal = "rbxassetid://6031394888",
	Palette = "rbxassetid://6031408139",
	Sliders = "rbxassetid://6031401098",
	Grid = "rbxassetid://6031397225",
	List = "rbxassetid://6031395585",
	Circle = "rbxassetid://6031402747",
	Square = "rbxassetid://6031404249",
	Triangle = "rbxassetid://6031391086",
	Shield = "rbxassetid://6031390505",
	Bolt = "rbxassetid://6031396423",
	Fire = "rbxassetid://6031408643",
	Water = "rbxassetid://6031401758",
	Wind = "rbxassetid://6031398138",
	Earth = "rbxassetid://6031390474",
	PlusCircle = "rbxassetid://6031409356",
	MinusCircle = "rbxassetid://6031390950",
	QuestionCircle = "rbxassetid://6031407617",
	ExclamationCircle = "rbxassetid://6031391086",
	ChevronLeft = "rbxassetid://6031392802",
	ChevronRight = "rbxassetid://6031394514",
	ChevronUp = "rbxassetid://6031395208",
	ChevronDown = "rbxassetid://6031393544",
	ChevronLeftDouble = "rbxassetid://6031405476",
	ChevronRightDouble = "rbxassetid://6031406619",
	Empty = "",
}

local CUSTOM_ICONS = {}

function IconManager:GetIcon(name)
	if name == nil or name == "" then
		return ""
	end
	local icon = ICONS[name]
	if icon then
		return icon
	end
	icon = CUSTOM_ICONS[name]
	if icon then
		return icon
	end
	return ""
end

function IconManager:RegisterIcon(name, assetId)
	CUSTOM_ICONS[name] = assetId
end

function IconManager:RegisterIcons(iconTable)
	for name, assetId in iconTable do
		self:RegisterIcon(name, assetId)
	end
end

function IconManager:HasIcon(name)
	return ICONS[name] ~= nil or CUSTOM_ICONS[name] ~= nil
end

function IconManager:GetAllIconNames()
	local names = {}
	for name in ICONS do
		table.insert(names, name)
	end
	for name in CUSTOM_ICONS do
		table.insert(names, name)
	end
	table.sort(names)
	return names
end

function IconManager:CreateIconLabel(parent, iconName, size, color, transparency)
	local assetId = self:GetIcon(iconName)
	if assetId == "" then
		return nil
	end
	local img = Instance.new("ImageLabel")
	img.Image = assetId
	img.Size = size or UDim2.new(0, 20, 0, 20)
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
	img.ImageTransparency = transparency or 0
	img.Parent = parent
	return img
end

function IconManager:SetIcon(imageLabel, iconName)
	local assetId = self:GetIcon(iconName)
	if assetId ~= "" and imageLabel then
		imageLabel.Image = assetId
	end
end

function IconManager:ClearCustomIcons()
	CUSTOM_ICONS = {}
end

return IconManager
