-- FLY GUI V3 | Modern Dark | Client-side LocalScript
-- Upload each PNG from assets/ to Roblox Creator Dashboard > Development Items > Images.
-- Replace every zero with the matching Roblox image asset ID.
-- Place this LocalScript in StarterPlayer > StarterPlayerScripts.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local ASSETS = {
    background = 0, close = 0, minimize = 0, decrease = 0,
    increase = 0, fly_off = 0, fly_on = 0,
    speed_display = 0, title = 0, footer = 0,
}
local function image(id)
    return id ~= 0 and ("rbxassetid://" .. tostring(id)) or ""
end
local old = player:WaitForChild("PlayerGui"):FindFirstChild("FlyGuiV3ModernDark")
if old then old:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGuiV3ModernDark"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")
local root = Instance.new("ImageLabel")
root.Name = "Window"
root.Size = UDim2.fromOffset(680,260)
root.Position = UDim2.new(0.5,-340,0.5,-130)
root.BackgroundColor3 = Color3.fromRGB(11,7,28)
root.BackgroundTransparency = 0.05
root.Image = image(ASSETS.background)
root.ScaleType = Enum.ScaleType.Stretch
root.Active = true
root.Parent = gui
local corner = Instance.new("UICorner",root)
corner.CornerRadius = UDim.new(0,22)
local function button(name,asset,x,y,w,h,fallback)
    local b = Instance.new("ImageButton")
    b.Name=name;b.Position=UDim2.fromOffset(x,y);b.Size=UDim2.fromOffset(w,h)
    b.BackgroundColor3=Color3.fromRGB(45,17,82);b.BackgroundTransparency=0.25
    b.Image=image(ASSETS[asset]);b.AutoButtonColor=true;b.Parent=root
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,15)
    if ASSETS[asset]==0 then
        local t=Instance.new("TextLabel",b);t.Size=UDim2.fromScale(1,1)
        t.BackgroundTransparency=1;t.Text=fallback;t.TextScaled=true
        t.TextColor3=Color3.fromRGB(240,213,255)
    end
    return b
end
local function label(name,asset,x,y,w,h,fallback,size)
    local v=Instance.new("ImageLabel",root);v.Name=name
    v.Position=UDim2.fromOffset(x,y);v.Size=UDim2.fromOffset(w,h)
    v.BackgroundTransparency=1;v.Image=image(ASSETS[asset])
    if ASSETS[asset]==0 then
        local t=Instance.new("TextLabel",v);t.Size=UDim2.fromScale(1,1)
        t.BackgroundTransparency=1;t.Text=fallback;t.TextSize=size
        t.Font=Enum.Font.GothamBold;t.TextColor3=Color3.fromRGB(213,156,255)
    end
    return v
end
local close=button("Close","close",18,14,74,65,"X")
local minimize=button("Minimize","minimize",102,14,74,65,"−")
label("Title","title",188,14,470,65,"FLY GUI V3",43)
local minus=button("SpeedMinus","decrease",20,99,110,82,"−")
local plus=button("SpeedPlus","increase",342,99,110,82,"+")
local fly=button("Fly","fly_off",470,99,190,82,"FLY")
label("SpeedBackground","speed_display",142,99,188,82,"",30)
local speedText=Instance.new("TextLabel",root)
speedText.Name="Speed";speedText.Position=UDim2.fromOffset(142,99)
speedText.Size=UDim2.fromOffset(188,82);speedText.BackgroundTransparency=1
speedText.TextColor3=Color3.fromRGB(255,255,255)
speedText.Font=Enum.Font.GothamBold;speedText.TextSize=47
speedText.ZIndex=4;speedText.Parent=root
label("Credit","footer",65,203,550,36,"T.ME/ROBLOXSCRIPTSX",20)
local speed=1;local flying=false;local minimized=false
local velocity,gyro,flightConn
local function updateSpeed() speedText.Text=tostring(speed) end
updateSpeed()
minus.MouseButton1Click:Connect(function() speed=math.max(1,speed-1);updateSpeed() end)
plus.MouseButton1Click:Connect(function() speed=math.min(100,speed+1);updateSpeed() end)
local function stopFlight()
    flying=false
    if flightConn then flightConn:Disconnect();flightConn=nil end
    if velocity then velocity:Destroy();velocity=nil end
    if gyro then gyro:Destroy();gyro=nil end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand=false end
    fly.Image=image(ASSETS.fly_off)
end
local function startFlight()
    local char=player.Character
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    flying=true;hum.PlatformStand=true
    velocity=Instance.new("BodyVelocity");velocity.MaxForce=Vector3.new(1e8,1e8,1e8)
    velocity.Velocity=Vector3.zero;velocity.Parent=hrp
    gyro=Instance.new("BodyGyro");gyro.MaxTorque=Vector3.new(1e8,1e8,1e8)
    gyro.P=1e4;gyro.Parent=hrp
    fly.Image=image(ASSETS.fly_on)
    flightConn=RunService.RenderStepped:Connect(function()
        if not hrp.Parent or hum.Health<=0 then stopFlight();return end
        local camera=workspace.CurrentCamera
        local move=hum.MoveDirection
        local dir=move
        local vertical=0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical+=1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vertical-=1 end
        velocity.Velocity=(dir+Vector3.new(0,vertical,0))*speed*12
        if camera then gyro.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+camera.CFrame.LookVector) end
    end)
end
fly.MouseButton1Click:Connect(function() if flying then stopFlight() else startFlight() end end)
player.CharacterRemoving:Connect(stopFlight)
minimize.MouseButton1Click:Connect(function()
    minimized=not minimized
    root.Size=UDim2.fromOffset(680,minimized and 92 or 260)
    for _,v in ipairs({minus,plus,fly,speedText}) do v.Visible=not minimized end
    for _,name in ipairs({"SpeedBackground","Credit"}) do root[name].Visible=not minimized end
end)
close.MouseButton1Click:Connect(function() stopFlight();gui:Destroy() end)
-- Drag panel by its title region
local dragging,dragStart,startPos
root.InputBegan:Connect(function(input)
    if (input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch) and input.Position.Y < root.AbsolutePosition.Y+90 then
        dragging=true;dragStart=input.Position;startPos=root.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-dragStart
        root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end
end)
