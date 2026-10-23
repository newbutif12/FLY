-- FLY GUI V3 | Compact Black & Ice Blue | No images
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local pg=player:WaitForChild("PlayerGui")
for _,name in ipairs({"FlyGuiV3ModernDark","FlyGuiV3IceBlue"}) do local old=pg:FindFirstChild(name) if old then old:Destroy() end end
local gui=Instance.new("ScreenGui")
gui.Name="FlyGuiV3IceBlue";gui.ResetOnSpawn=false;gui.IgnoreGuiInset=true;gui.Parent=pg
local ice=Color3.fromRGB(114,217,255)
local black=Color3.fromRGB(11,15,22)
local panel=Color3.fromRGB(22,31,43)
local function round(obj,r) Instance.new("UICorner",obj).CornerRadius=UDim.new(0,r) end
local function stroke(obj,color,trans) local s=Instance.new("UIStroke",obj);s.Color=color;s.Transparency=trans or 0;s.Thickness=1 end
local root=Instance.new("Frame")
root.Name="Window";root.Size=UDim2.fromOffset(224,116);root.Position=UDim2.new(.5,-112,.5,-58)
root.BackgroundColor3=black;root.BorderSizePixel=0;root.Active=true;root.Parent=gui
round(root,12);stroke(root,ice,.55)
local function label(text,x,y,w,h,size,color,bold)
 local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.Position=UDim2.fromOffset(x,y);l.Size=UDim2.fromOffset(w,h)
 l.Font=bold and Enum.Font.GothamBlack or Enum.Font.Gotham;l.Text=text;l.TextSize=size
 l.TextColor3=color or Color3.new(1,1,1);l.Parent=root;return l
end
local function btn(text,x,y,w,h,accent)
 local b=Instance.new("TextButton");b.Position=UDim2.fromOffset(x,y);b.Size=UDim2.fromOffset(w,h)
 b.Text=text;b.Font=Enum.Font.GothamBlack;b.TextSize=14;b.TextColor3=accent and black or ice
 b.BackgroundColor3=accent and ice or panel;b.BorderSizePixel=0;b.AutoButtonColor=true;b.Parent=root
 round(b,7);if not accent then stroke(b,ice,.7) end;return b
end
label("FLY GUI",12,8,91,22,15,ice,true).TextXAlignment=Enum.TextXAlignment.Left
label("V3",99,10,23,18,10,Color3.fromRGB(140,158,174),true)
local minimize=btn("−",164,8,22,22,false)
local close=btn("×",192,8,22,22,false)
local line=Instance.new("Frame");line.Position=UDim2.fromOffset(12,37);line.Size=UDim2.fromOffset(200,1)
line.BorderSizePixel=0;line.BackgroundColor3=Color3.fromRGB(40,65,83);line.Parent=root
label("SPEED",13,47,70,16,10,Color3.fromRGB(148,169,186),true).TextXAlignment=Enum.TextXAlignment.Left
local minus=btn("−",13,68,39,33,false)
local speedLabel=label("1",58,68,60,33,21,Color3.new(1,1,1),true)
local plus=btn("+",124,68,39,33,false)
local fly=btn("FLY",169,68,43,33,true);fly.TextSize=12
local footer=label("T.ME/ROBLOXSCRIPTSX",13,114,198,20,10,ice,true)
local speed=1;local flying=false;local minimized=false
local velocity,gyro,connection
local function stop()
 flying=false
 if connection then connection:Disconnect();connection=nil end
 if velocity then velocity:Destroy();velocity=nil end
 if gyro then gyro:Destroy();gyro=nil end
 local ch=player.Character;local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 if hum then hum.PlatformStand=false end
 fly.Text="FLY";fly.BackgroundColor3=ice;fly.TextColor3=black
end
local function start()
 local ch=player.Character;local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
 local hum=ch and ch:FindFirstChildOfClass("Humanoid")
 if not hrp or not hum then return end
 flying=true;hum.PlatformStand=true
 velocity=Instance.new("BodyVelocity");velocity.MaxForce=Vector3.new(1e8,1e8,1e8);velocity.Parent=hrp
 gyro=Instance.new("BodyGyro");gyro.MaxTorque=Vector3.new(1e8,1e8,1e8);gyro.P=1e4;gyro.Parent=hrp
 fly.Text="ON";fly.BackgroundColor3=Color3.fromRGB(42,92,116);fly.TextColor3=ice
 connection=RunService.RenderStepped:Connect(function()
  if not hrp.Parent or hum.Health<=0 then stop();return end
  local camera=workspace.CurrentCamera
  local vertical=0
  if UIS:IsKeyDown(Enum.KeyCode.Space) then vertical=vertical+1 end
  if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then vertical=vertical-1 end
  velocity.Velocity=(hum.MoveDirection+Vector3.new(0,vertical,0))*speed*12
  if camera then gyro.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+camera.CFrame.LookVector) end
 end)
end
minus.MouseButton1Click:Connect(function() speed=math.max(1,speed-1);speedLabel.Text=tostring(speed) end)
plus.MouseButton1Click:Connect(function() speed=math.min(100,speed+1);speedLabel.Text=tostring(speed) end)
fly.MouseButton1Click:Connect(function() if flying then stop() else start() end end)
player.CharacterRemoving:Connect(stop)
minimize.MouseButton1Click:Connect(function()
 minimized=not minimized;root.Size=UDim2.fromOffset(224,minimized and 39 or 116)
 for _,v in ipairs({line,minus,plus,speedLabel,fly,footer}) do v.Visible=not minimized end
 for _,v in ipairs(root:GetChildren()) do if v:IsA("TextLabel") and v.Text=="SPEED" then v.Visible=not minimized end end
end)
close.MouseButton1Click:Connect(function() stop();gui:Destroy() end)
local dragging=false;local dragStart,startPos,dragInput
root.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  if input.Position.Y<=root.AbsolutePosition.Y+37 then dragging=true;dragStart=input.Position;startPos=root.Position;dragInput=input end
 end
end)
UIS.InputEnded:Connect(function(input) if input==dragInput then dragging=false end end)
UIS.InputChanged:Connect(function(input)
 if dragging and (input==dragInput or (dragInput and dragInput.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then
  local d=input.Position-dragStart
  root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)
