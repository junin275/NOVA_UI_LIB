local DragService = {}
DragService.__index = DragService

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

local ACTIVE_DRAGS = {}

function DragService:MakeDraggable(frame, dragHandle, options)
	options = options or {}

	local snapToEdge = options.SnapToEdge or false
	local edgeMargin = options.EdgeMargin or 10
	local bounds = options.Bounds or nil
	local onDragStart = options.OnDragStart or nil
	local onDragEnd = options.OnDragEnd or nil
	local onDrag = options.OnDrag or nil
	local constrainToScreen = options.ConstrainToScreen or true
	local smoothDrag = options.SmoothDrag or false

	dragHandle = dragHandle or frame

	local dragging = false
	local dragOffset = Vector2.new(0, 0)
	local dragStartPos = UDim2.new(0, 0, 0, 0)
	local screenSize = workspace.CurrentCamera.ViewportSize

	local dragData = {
		Frame = frame,
		Dragging = false,
		Offset = Vector2.new(0, 0),
	}

	ACTIVE_DRAGS[frame] = dragData

	local connection1 = dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragOffset = Vector2.new(Mouse.X - frame.AbsolutePosition.X, Mouse.Y - frame.AbsolutePosition.Y)
			dragStartPos = frame.Position

			if dragData.SmoothTween then
				dragData.SmoothTween:Cancel()
				dragData.SmoothTween = nil
			end

			if onDragStart then
				onDragStart()
			end
		end
	end)

	local connection2 = UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local newX = Mouse.X - dragOffset.X
			local newY = Mouse.Y - dragOffset.Y

			if constrainToScreen then
				screenSize = workspace.CurrentCamera.ViewportSize
				newX = math.clamp(newX, 0, screenSize.X - frame.AbsoluteSize.X)
				newY = math.clamp(newY, 0, screenSize.Y - frame.AbsoluteSize.Y)
			end

			if snapToEdge then
				screenSize = workspace.CurrentCamera.ViewportSize
				local frameWidth = frame.AbsoluteSize.X
				local frameHeight = frame.AbsoluteSize.Y
				if math.abs(newX) < edgeMargin then
					newX = 0
				elseif math.abs(newX + frameWidth - screenSize.X) < edgeMargin then
					newX = screenSize.X - frameWidth
				end
				if math.abs(newY) < edgeMargin then
					newY = 0
				elseif math.abs(newY + frameHeight - screenSize.Y) < edgeMargin then
					newY = screenSize.Y - frameHeight
				end
			end

			if smoothDrag then
				if dragData.SmoothTween then
					dragData.SmoothTween:Cancel()
				end
				dragData.SmoothTween = TweenService:Create(frame, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(0, newX, 0, newY)
				})
				dragData.SmoothTween:Play()
			else
				frame.Position = UDim2.new(0, newX, 0, newY)
			end

			if onDrag then
				onDrag(frame.Position)
			end

			dragData.LastPosition = frame.Position
		end
	end)

	local connection3 = UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false

			if dragData.SmoothTween then
				dragData.SmoothTween:Cancel()
				dragData.SmoothTween = nil
			end

			if onDragEnd then
				onDragEnd(frame.Position)
			end
		end
	end)

	return {
		Disconnect = function()
			connection1:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
			ACTIVE_DRAGS[frame] = nil
		end,
		SetDraggable = function(enabled)
			dragging = false
		end
	}
end

function DragService:MakeResizable(frame, options)
	options = options or {}
	local minSize = options.MinSize or Vector2.new(300, 200)
	local maxSize = options.MaxSize or Vector2.new(2000, 1500)
	local handles = options.Handles or {}

	local resizeData = {
		Frame = frame,
		Resizing = false,
		Edge = nil,
		StartSize = Vector2.new(0, 0),
		StartPos = Vector2.new(0, 0),
		MouseStart = Vector2.new(0, 0),
	}

	local function createHandle(edgeName, cursor, position, size)
		local handle = Instance.new("Frame")
		handle.Name = "ResizeHandle_" .. edgeName
		handle.BackgroundTransparency = 1
		handle.BorderSizePixel = 0
		handle.Size = size or UDim2.new(0, 6, 0, 6)
		handle.Position = position or UDim2.new(0, 0, 0, 0)
		handle.ZIndex = 1000
		handle.Parent = frame

		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizeData.Resizing = true
				resizeData.Edge = edgeName
				resizeData.StartSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
				resizeData.StartPos = Vector2.new(frame.AbsolutePosition.X, frame.AbsolutePosition.Y)
				resizeData.MouseStart = Vector2.new(Mouse.X, Mouse.Y)
			end
		end)

		return handle
	end

	createHandle("BottomRight", "sizing", UDim2.new(1, -3, 1, -3))
	createHandle("Bottom", "sizens", UDim2.new(0.5, -3, 1, -3), UDim2.new(0, 6, 1, 0))
	createHandle("Right", "sizewe", UDim2.new(1, -3, 0.5, -3), UDim2.new(1, 0, 0, 6))

	UserInputService.InputChanged:Connect(function(input)
		if resizeData.Resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = Vector2.new(Mouse.X - resizeData.MouseStart.X, Mouse.Y - resizeData.MouseStart.Y)
			local newSize = resizeData.StartSize
			local newPos = resizeData.StartPos

			if resizeData.Edge == "BottomRight" or resizeData.Edge == "Right" then
				newSize = Vector2.new(math.clamp(resizeData.StartSize.X + delta.X, minSize.X, maxSize.X), newSize.Y)
			end
			if resizeData.Edge == "BottomRight" or resizeData.Edge == "Bottom" then
				newSize = Vector2.new(newSize.X, math.clamp(resizeData.StartSize.Y + delta.Y, minSize.Y, maxSize.Y))
			end

			frame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if resizeData.Resizing and input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizeData.Resizing = false
			resizeData.Edge = nil
		end
	end)
end

function DragService:StopDrag(frame)
	if ACTIVE_DRAGS[frame] then
		ACTIVE_DRAGS[frame] = nil
	end
end

function DragService:Cleanup()
	for frame, data in ACTIVE_DRAGS do
		if data.Disconnect then
			data:Disconnect()
		end
	end
	ACTIVE_DRAGS = {}
end

return DragService
