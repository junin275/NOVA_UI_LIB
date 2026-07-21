local Utility = {}

function Utility:Round(number, decimals)
	decimals = decimals or 0
	local mult = 10 ^ decimals
	return math.floor(number * mult + 0.5) / mult
end

function Utility:Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function Utility:Lerp(a, b, t)
	return a + (b - a) * t
end

function Utility:ColorLerp(a, b, t)
	return Color3.new(
		self:Lerp(a.R, b.R, t),
		self:Lerp(a.G, b.G, t),
		self:Lerp(a.B, b.B, t)
	)
end

function Utility:RGBToHex(color)
	return string.format("#%02X%02X%02X",
		math.floor(color.R * 255),
		math.floor(color.G * 255),
		math.floor(color.B * 255)
	)
end

function Utility:HexToRGB(hex)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255
	return Color3.new(r, g, b)
end

function Utility:DeepCopy(table)
	local copy = {}
	for k, v in pairs(table) do
		if type(v) == "table" then
			copy[k] = self:DeepCopy(v)
		else
			copy[k] = v
		end
	end
	return copy
end

function Utility:MergeTables(...)
	local result = {}
	for _, tbl in ipairs({...}) do
		for k, v in pairs(tbl) do
			result[k] = v
		end
	end
	return result
end

function Utility:IsMouseOver(frame)
	local mouse = game:GetService("Players").LocalPlayer:GetMouse()
	local absPos = frame.AbsolutePosition
	local absSize = frame.AbsoluteSize
	return mouse.X >= absPos.X and mouse.X <= absPos.X + absSize.X
		and mouse.Y >= absPos.Y and mouse.Y <= absPos.Y + absSize.Y
end

function Utility:MakeDraggable(frame, dragArea, callback)
	dragArea = dragArea or frame
	local dragging = false
	local dragOffset = Vector2.new(0, 0)
	local userInput = game:GetService("UserInputService")
	local tweenService = game:GetService("TweenService")

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragOffset = Vector2.new(input.Position.X - frame.AbsolutePosition.X, input.Position.Y - frame.AbsolutePosition.Y)
		end
	end)

	userInput.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local newPos = UDim2.new(0, input.Position.X - dragOffset.X, 0, input.Position.Y - dragOffset.Y)
			frame.Position = newPos
			if callback then
				callback(newPos)
			end
		end
	end)

	userInput.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function Utility:CreateShadow(instance, transparency, size, color)
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.BackgroundTransparency = 1
	shadow.BorderSizePixel = 0
	shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
	shadow.Position = UDim2.new(-0.5, -size, -0.5, -size)
	shadow.ZIndex = instance.ZIndex - 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageColor3 = color or Color3.fromRGB(0, 0, 0)
	shadow.ImageTransparency = transparency or 0.8
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.Parent = instance
	return shadow
end

function Utility:CreateCorner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 6)
	corner.Parent = instance
	return corner
end

function Utility:CreatePadding(instance, padding)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, padding or 8)
	pad.PaddingBottom = UDim.new(0, padding or 8)
	pad.PaddingLeft = UDim.new(0, padding or 8)
	pad.PaddingRight = UDim.new(0, padding or 8)
	pad.Parent = instance
	return pad
end

function Utility:CreateStroke(instance, color, transparency, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(35, 35, 42)
	stroke.Transparency = transparency or 0.5
	stroke.Thickness = thickness or 1
	stroke.Parent = instance
	return stroke
end

function Utility:CreateGradient(instance, color1, color2, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1 or Color3.fromRGB(20, 20, 24)),
		ColorSequenceKeypoint.new(1, color2 or Color3.fromRGB(26, 26, 32))
	})
	gradient.Rotation = rotation or 90
	gradient.Parent = instance
	return gradient
end

function Utility:CreateListLayout(instance, direction, padding, fillDirection)
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = direction or Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, padding or 4)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = instance
	return layout
end

function Utility:CreateScrollingFrame(parent, size, position, canvasSize)
	local sf = Instance.new("ScrollingFrame")
	sf.Size = size
	sf.Position = position
	sf.BackgroundTransparency = 1
	sf.BorderSizePixel = 0
	sf.ScrollBarThickness = 3
	sf.ScrollBarImageTransparency = 0.8
	sf.ScrollBarImageColor3 = Color3.fromRGB(79, 124, 255)
	sf.CanvasSize = canvasSize or UDim2.new(0, 0, 0, 0)
	sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sf.ScrollingDirection = Enum.ScrollingDirection.Y
	sf.ElasticBehavior = Enum.ElasticBehavior.Never
	sf.Parent = parent
	return sf
end

function Utility:Throttle(func, limit)
	local lastCall = 0
	return function(...)
		local now = tick()
		if now - lastCall >= limit then
			lastCall = now
			func(...)
		end
	end
end

function Utility:Debounce(func, delay)
	local lastCall = 0
	return function(...)
		local now = tick()
		if now - lastCall >= delay then
			lastCall = now
			func(...)
		end
	end
end

function Utility:CreateImageLabel(parent, image, size, position, color, transparency)
	local img = Instance.new("ImageLabel")
	img.Image = image
	img.Size = size
	img.Position = position
	img.BackgroundTransparency = 1
	img.BorderSizePixel = 0
	img.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
	img.ImageTransparency = transparency or 0
	img.Parent = parent
	return img
end

function Utility:CreateTextLabel(parent, text, size, position, font, textSize, color, transparency)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.Size = size
	label.Position = position
	label.Font = font or Enum.Font.Gotham
	label.TextSize = textSize or 14
	label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	label.TextTransparency = transparency or 0
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.RichText = true
	label.Parent = parent
	return label
end

function Utility:CreateInput(inputType, parent, size, position)
	local input = Instance.new("TextBox" or "TextButton")
	return input
end

function Utility:DestroyAllChildren(instance)
	for _, child in ipairs(instance:GetChildren()) do
		child:Destroy()
	end
end

function Utility:GetTextBounds(text, font, size)
	local tb = Instance.new("TextLabel")
	tb.Text = text
	tb.Font = font or Enum.Font.Gotham
	tb.TextSize = size or 14
	tb.TextTransparency = 1
	tb.Size = UDim2.new(0, 1000, 0, 50)
	local bounds = tb.TextBounds
	tb:Destroy()
	return bounds
end

function Utility:FormatTime(seconds)
	local mins = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", mins, secs)
end

function Utility:GenerateUID()
	return string.format("%x-%x-%x", math.random(0, 0xFFFF), math.random(0, 0xFFFF), math.random(0, 0xFFFF))
end

function Utility:GetRelativePosition(instance, ancestor)
	local pos = instance.AbsolutePosition
	local ancPos = ancestor.AbsolutePosition
	return Vector2.new(pos.X - ancPos.X, pos.Y - ancPos.Y)
end

return Utility
