--[[
    VFly  —  MADE ON SYPHIX V5
    Compact WindUI-style fly window
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LP = Players.LocalPlayer

local T = {
	Window     = Color3.fromRGB(11, 15, 22),
	Topbar     = Color3.fromRGB(16, 24, 34),
	Card       = Color3.fromRGB(23, 34, 46),
	Input      = Color3.fromRGB(17, 29, 41),
	Stroke     = Color3.fromRGB(255, 255, 255),
	Text       = Color3.fromRGB(245, 245, 247),
	Muted      = Color3.fromRGB(161, 161, 170),
	Accent     = Color3.fromRGB(114, 217, 255),
	AccentDim  = Color3.fromRGB(60, 169, 213),
	On         = Color3.fromRGB(114, 217, 255),
	Off        = Color3.fromRGB(115, 145, 165),
}

local function corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 12)
	c.Parent = parent
	return c
end

local function stroke(parent, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or T.Stroke
	s.Transparency = transparency or 0.88
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.LineJoinMode = Enum.LineJoinMode.Round
	s.Parent = parent
	return s
end

local function pad(parent, l, t, r, b)
	local p = Instance.new("UIPadding")
	p.PaddingLeft = UDim.new(0, l or 12)
	p.PaddingTop = UDim.new(0, t or l or 12)
	p.PaddingRight = UDim.new(0, r or l or 12)
	p.PaddingBottom = UDim.new(0, b or t or l or 12)
	p.Parent = parent
	return p
end

local function label(parent, props)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamMedium
	l.TextColor3 = T.Text
	l.TextSize = 13
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Center
	for k, v in pairs(props) do l[k] = v end
	l.Parent = parent
	return l
end

pcall(function()
	local old = CoreGui:FindFirstChild("SyphixFlyV5")
	if old then old:Destroy() end
end)

local guiParent = CoreGui
pcall(function()
	guiParent = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or CoreGui
end)

local Screen = Instance.new("ScreenGui")
Screen.Name = "SyphixFlyV5"
Screen.IgnoreGuiInset = true
Screen.ResetOnSpawn = false
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.Parent = guiParent

-- ── Window ──────────────────────────────────────────────────────────────
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.AnchorPoint = Vector2.new(0.5, 0.5)
Window.Position = UDim2.new(0.5, 0, 0.46, 0)
Window.Size = UDim2.new(0, 214, 0, 152)
Window.BackgroundColor3 = T.Window
Window.BorderSizePixel = 0
Window.Active = true
Window.ClipsDescendants = true
Window.Parent = Screen
corner(Window, 12)
local WindowGlow = stroke(Window, T.Accent, 0.35, 1.6)

-- ── Topbar ──────────────────────────────────────────────────────────────
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.BackgroundColor3 = T.Topbar
Topbar.BorderSizePixel = 0
Topbar.Size = UDim2.new(1, 0, 0, 36)
Topbar.Parent = Window
corner(Topbar, 12)

local TopbarClip = Instance.new("Frame")
TopbarClip.BackgroundColor3 = T.Topbar
TopbarClip.BorderSizePixel = 0
TopbarClip.Position = UDim2.new(0, 0, 1, -12)
TopbarClip.Size = UDim2.new(1, 0, 0, 12)
TopbarClip.Parent = Topbar

local AccentLine = Instance.new("Frame")
AccentLine.BackgroundColor3 = T.Accent
AccentLine.BorderSizePixel = 0
AccentLine.Position = UDim2.new(0, 0, 1, 0)
AccentLine.Size = UDim2.new(1, 0, 0, 1)
AccentLine.BackgroundTransparency = 0.15
AccentLine.Parent = Topbar

local Title = label(Topbar, {
	Position = UDim2.new(0, 10, 0, 3),
	Size = UDim2.new(1, -70, 0, 16),
	Text = "VFly",
	Font = Enum.Font.GothamBold,
	TextSize = 13,
})

local Author = label(Topbar, {
	Position = UDim2.new(0, 10, 0, 18),
	Size = UDim2.new(1, -70, 0, 13),
	Text = "MADE: T.ME/ROBLOXSCRIPTSX",
	TextColor3 = T.Muted,
	Font = Enum.Font.Gotham,
	TextSize = 8,
})

local function makeTopBtn(text, xOff)
	local b = Instance.new("TextButton")
	b.AutoButtonColor = false
	b.BackgroundColor3 = T.Card
	b.BackgroundTransparency = 0.25
	b.BorderSizePixel = 0
	b.AnchorPoint = Vector2.new(1, 0.5)
	b.Position = UDim2.new(1, xOff, 0.5, 0)
	b.Size = UDim2.new(0, 20, 0, 20)
	b.Font = Enum.Font.GothamBold
	b.Text = text
	b.TextColor3 = T.Muted
	b.TextSize = 13
	b.Parent = Topbar
	corner(b, 7)
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0, TextColor3 = T.Text}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundTransparency = 0.25, TextColor3 = T.Muted}):Play()
	end)
	return b
end

local CloseBtn = makeTopBtn("×", -8)
local MiniBtn = makeTopBtn("–", -30)

-- ── Body ────────────────────────────────────────────────────────────────
local Body = Instance.new("Frame")
Body.Name = "Body"
Body.BackgroundTransparency = 1
Body.Position = UDim2.new(0, 0, 0, 38)
Body.Size = UDim2.new(1, 0, 1, -38)
Body.Parent = Window
pad(Body, 8, 6, 8, 8)

local Layout = Instance.new("UIListLayout")
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Body

local StatusCard = Instance.new("Frame")
StatusCard.BackgroundColor3 = T.Card
StatusCard.BorderSizePixel = 0
StatusCard.Size = UDim2.new(1, 0, 0, 26)
StatusCard.LayoutOrder = 1
StatusCard.Parent = Body
corner(StatusCard, 8)
stroke(StatusCard, T.Stroke, 0.9, 1)

label(StatusCard, {
	Position = UDim2.new(0, 8, 0, 0),
	Size = UDim2.new(0.5, 0, 1, 0),
	Text = "Status",
	TextColor3 = T.Muted,
	TextSize = 11,
})

local StatusDot = Instance.new("Frame")
StatusDot.Name = "Dot"
StatusDot.AnchorPoint = Vector2.new(1, 0.5)
StatusDot.Position = UDim2.new(1, -54, 0.5, 0)
StatusDot.Size = UDim2.new(0, 7, 0, 7)
StatusDot.BackgroundColor3 = T.Off
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusCard
corner(StatusDot, 99)

local Stat2 = label(StatusCard, {
	Name = "Stat2",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -12, 0.5, 0),
	Size = UDim2.new(0, 36, 1, 0),
	Text = "Off",
	TextColor3 = T.Off,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
})

local SpeedCard = Instance.new("Frame")
SpeedCard.BackgroundColor3 = T.Card
SpeedCard.BorderSizePixel = 0
SpeedCard.Size = UDim2.new(1, 0, 0, 30)
SpeedCard.LayoutOrder = 2
SpeedCard.Parent = Body
corner(SpeedCard, 8)
stroke(SpeedCard, T.Stroke, 0.9, 1)

label(SpeedCard, {
	Position = UDim2.new(0, 8, 0, 0),
	Size = UDim2.new(0.38, 0, 1, 0),
	Text = "Speed",
	TextColor3 = T.Muted,
	TextSize = 11,
})

local Speed = Instance.new("TextBox")
Speed.Name = "Speed"
Speed.AnchorPoint = Vector2.new(1, 0.5)
Speed.Position = UDim2.new(1, -6, 0.5, 0)
Speed.Size = UDim2.new(0, 78, 0, 20)
Speed.BackgroundColor3 = T.Input
Speed.BorderSizePixel = 0
Speed.Font = Enum.Font.GothamBold
Speed.PlaceholderText = "50"
Speed.PlaceholderColor3 = T.Muted
Speed.Text = "50"
Speed.TextColor3 = T.Text
Speed.TextSize = 13
Speed.ClearTextOnFocus = false
Speed.Parent = SpeedCard
corner(Speed, 8)
stroke(Speed, T.Stroke, 0.88, 1)

local Fly = Instance.new("TextButton")
Fly.Name = "Fly"
Fly.AutoButtonColor = false
Fly.BackgroundColor3 = T.Accent
Fly.BorderSizePixel = 0
Fly.Size = UDim2.new(1, 0, 0, 30)
Fly.LayoutOrder = 3
Fly.Font = Enum.Font.GothamBold
Fly.Text = "Enable"
Fly.TextColor3 = T.Window
Fly.TextSize = 13
Fly.Parent = Body
corner(Fly, 8)

local Unfly = Instance.new("TextButton")
Unfly.Name = "Unfly"
Unfly.AutoButtonColor = false
Unfly.BackgroundColor3 = T.Card
Unfly.BorderSizePixel = 0
Unfly.Size = UDim2.new(1, 0, 0, 30)
Unfly.LayoutOrder = 3
Unfly.Visible = false
Unfly.Font = Enum.Font.GothamBold
Unfly.Text = "Disable"
Unfly.TextColor3 = T.Text
Unfly.TextSize = 13
Unfly.Parent = Body
corner(Unfly, 8)
stroke(Unfly, T.Stroke, 0.82, 1)

local function hoverFill(btn, idle, over)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = over}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = idle}):Play()
	end)
end
hoverFill(Fly, T.Accent, T.AccentDim)
hoverFill(Unfly, T.Card, Color3.fromRGB(32, 49, 65))

-- ── Mobile W / S overlay ────────────────────────────────────────────────
local Flyon = Instance.new("Frame")
Flyon.Name = "Fly on"
Flyon.BackgroundColor3 = T.Window
Flyon.BorderSizePixel = 0
Flyon.Position = UDim2.new(0.12, 0, 0.55, 0)
Flyon.Size = UDim2.new(0, 72, 0, 132)
Flyon.Visible = false
Flyon.Active = true
Flyon.ClipsDescendants = true
Flyon.Parent = Screen
corner(Flyon, 12)
stroke(Flyon, T.Accent, 0.35, 1.6)

local W = Instance.new("TextButton")
W.Name = "W"
W.AutoButtonColor = false
W.BackgroundColor3 = T.Accent
W.BorderSizePixel = 0
W.Position = UDim2.new(0.13, 0, 0.04, 0)
W.Size = UDim2.new(0.74, 0, 0.44, 0)
W.Font = Enum.Font.GothamBold
W.Text = "▲"
W.TextColor3 = T.Window
W.TextScaled = true
W.Parent = Flyon
corner(W, 10)

local S = Instance.new("TextButton")
S.Name = "S"
S.AutoButtonColor = false
S.BackgroundColor3 = T.Card
S.BorderSizePixel = 0
S.Position = UDim2.new(0.13, 0, 0.52, 0)
S.Size = UDim2.new(0.74, 0, 0.44, 0)
S.Font = Enum.Font.GothamBold
S.Text = "▼"
S.TextColor3 = T.Text
S.TextScaled = true
S.Parent = Flyon
corner(S, 10)
stroke(S, T.Stroke, 0.85, 1)

hoverFill(W, T.Accent, T.AccentDim)
hoverFill(S, T.Card, Color3.fromRGB(32, 49, 65))

-- ── Drag ────────────────────────────────────────────────────────────────
local function makeDraggable(handle, target)
	target = target or handle
	local dragging, startPos, startInput
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startPos = target.Position
			startInput = input.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - startInput
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
end

makeDraggable(Topbar, Window)
makeDraggable(Flyon, Flyon)

-- ── Flight ──────────────────────────────────────────────────────────────
local flying = false
local BV, BG
local loop
local keys = {F = false, B = false, L = false, R = false, U = false, D = false}

local function getHRP()
	local char = LP.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

local function getSpeed()
	local n = tonumber(Speed.Text)
	if not n or n < 0 then return 50 end
	return n
end

local function setStatus(on)
	if on then
		Stat2.Text = "On"
		Stat2.TextColor3 = T.On
		StatusDot.BackgroundColor3 = T.On
		Fly.Visible = false
		Unfly.Visible = true
		Flyon.Visible = true
		TweenService:Create(WindowGlow, TweenInfo.new(0.2), {Transparency = 0.12, Thickness = 2}):Play()
	else
		Stat2.Text = "Off"
		Stat2.TextColor3 = T.Off
		StatusDot.BackgroundColor3 = T.Off
		Fly.Visible = true
		Unfly.Visible = false
		Flyon.Visible = false
		TweenService:Create(WindowGlow, TweenInfo.new(0.2), {Transparency = 0.35, Thickness = 1.6}):Play()
	end
end

local function stopFly()
	flying = false
	keys.F, keys.B, keys.L, keys.R, keys.U, keys.D = false, false, false, false, false, false
	if loop then
		loop:Disconnect()
		loop = nil
	end
	if BV then pcall(function() BV:Destroy() end) BV = nil end
	if BG then pcall(function() BG:Destroy() end) BG = nil end
	local hrp = getHRP()
	if hrp then
		hrp.AssemblyLinearVelocity = Vector3.zero
	end
	setStatus(false)
end

local function startFly()
	local hrp = getHRP()
	if not hrp then return end
	if flying then stopFly() end

	flying = true
	BV = Instance.new("BodyVelocity")
	BV.Name = "SyphixBV"
	BV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	BV.Velocity = Vector3.zero
	BV.P = 1250
	BV.Parent = hrp

	BG = Instance.new("BodyGyro")
	BG.Name = "SyphixBG"
	BG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	BG.P = 3e4
	BG.D = 500
	BG.CFrame = CFrame.new(hrp.Position, hrp.Position + workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1))
	BG.Parent = hrp

	setStatus(true)

	loop = RunService.Heartbeat:Connect(function()
		if not flying then return end
		hrp = getHRP()
		if not hrp or not BV or not BG or not BV.Parent or not BG.Parent then
			stopFly()
			return
		end

		local cam = workspace.CurrentCamera.CFrame
		local look = cam.LookVector
		local flat = Vector3.new(look.X, 0, look.Z)
		if flat.Magnitude > 0 then
			flat = flat.Unit
		end
		local right = Vector3.new(cam.RightVector.X, 0, cam.RightVector.Z)
		if right.Magnitude > 0 then
			right = right.Unit
		end

		local move = Vector3.zero
		if keys.F then move += look end
		if keys.B then move -= look end
		if keys.L then move -= right end
		if keys.R then move += right end
		if keys.U then move += Vector3.yAxis end
		if keys.D then move -= Vector3.yAxis end

		if move.Magnitude > 0 then
			BV.Velocity = move.Unit * getSpeed()
		else
			BV.Velocity = Vector3.zero
		end

		local yawLook = Vector3.new(look.X, 0, look.Z)
		if yawLook.Magnitude > 0.05 then
			BG.CFrame = CFrame.new(hrp.Position, hrp.Position + yawLook)
		end
	end)
end

local function bindHold(btn, key)
	btn.MouseButton1Down:Connect(function()
		keys[key] = true
	end)
	btn.MouseButton1Up:Connect(function()
		keys[key] = false
	end)
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			keys[key] = false
		end
	end)
end

bindHold(W, "F")
bindHold(S, "B")

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or not flying then return end
	local k = input.KeyCode
	if k == Enum.KeyCode.W then keys.F = true
	elseif k == Enum.KeyCode.S then keys.B = true
	elseif k == Enum.KeyCode.A then keys.L = true
	elseif k == Enum.KeyCode.D then keys.R = true
	elseif k == Enum.KeyCode.Space then keys.U = true
	elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then keys.D = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	local k = input.KeyCode
	if k == Enum.KeyCode.W then keys.F = false
	elseif k == Enum.KeyCode.S then keys.B = false
	elseif k == Enum.KeyCode.A then keys.L = false
	elseif k == Enum.KeyCode.D then keys.R = false
	elseif k == Enum.KeyCode.Space then keys.U = false
	elseif k == Enum.KeyCode.LeftControl or k == Enum.KeyCode.LeftShift then keys.D = false
	end
end)

Fly.MouseButton1Click:Connect(startFly)
Unfly.MouseButton1Click:Connect(stopFly)

LP.CharacterAdded:Connect(function()
	if flying then
		task.wait(0.1)
		stopFly()
	end
end)

MiniBtn.MouseButton1Click:Connect(function()
	if Body.Visible then
		Body.Visible = false
		MiniBtn.Text = "+"
		TweenService:Create(Window, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 214, 0, 36)
		}):Play()
	else
		Body.Visible = true
		MiniBtn.Text = "–"
		TweenService:Create(Window, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 214, 0, 152)
		}):Play()
	end
end)

CloseBtn.MouseButton1Click:Connect(function()
	stopFly()
	Screen:Destroy()
end)
