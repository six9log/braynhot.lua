--========================================
-- FORCE NOCLIP + SPEED SELECT (STUDIO)
--========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

------------------------------------------------
-- STATE
------------------------------------------------
local noclip = false
local speed = 2
local moveConn
local dir = Vector3.zero

------------------------------------------------
-- UI
------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ForceNoclipUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,200)
frame.Position = UDim2.new(0,20,0.55,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.Active = true
frame.Draggable = true

local function makeBtn(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,32)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(60,60,80)
    return b
end

local toggle = makeBtn("NOCLIP : OFF", 10)
local spd1   = makeBtn("Velocidade: LENTA", 50)
local spd2   = makeBtn("Velocidade: MÉDIA", 85)
local spd3   = makeBtn("Velocidade: RÁPIDA", 120)
local close  = makeBtn("FECHAR MENU", 155)
close.BackgroundColor3 = Color3.fromRGB(120,30,30)

------------------------------------------------
-- INPUT
------------------------------------------------
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.W then dir += Vector3.new(0,0,-1) end
    if i.KeyCode == Enum.KeyCode.S then dir += Vector3.new(0,0,1) end
    if i.KeyCode == Enum.KeyCode.A then dir += Vector3.new(-1,0,0) end
    if i.KeyCode == Enum.KeyCode.D then dir += Vector3.new(1,0,0) end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.W then dir -= Vector3.new(0,0,-1) end
    if i.KeyCode == Enum.KeyCode.S then dir -= Vector3.new(0,0,1) end
    if i.KeyCode == Enum.KeyCode.A then dir -= Vector3.new(-1,0,0) end
    if i.KeyCode == Enum.KeyCode.D then dir -= Vector3.new(1,0,0) end
end)

------------------------------------------------
-- CORE NOCLIP (FORÇADO)
------------------------------------------------
local function setCollision(state)
    for _,p in ipairs(character:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = state
            p.Anchored = false
        end
    end
end

local function enableNoclip()
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    humanoid.AutoRotate = false
    setCollision(false)

    moveConn = RunService.RenderStepped:Connect(function()
        setCollision(false)

        if dir.Magnitude > 0 then
            local cam = workspace.CurrentCamera
            local move =
                cam.CFrame.RightVector * dir.X +
                cam.CFrame.LookVector * dir.Z

            root.CFrame = root.CFrame + (move.Unit * speed)
        end
    end)
end

local function disableNoclip()
    if moveConn then
        moveConn:Disconnect()
        moveConn = nil
    end

    setCollision(true)
    humanoid.AutoRotate = true
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
toggle.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        enableNoclip()
        toggle.Text = "NOCLIP : ON"
        toggle.BackgroundColor3 = Color3.fromRGB(50,150,50)
    else
        disableNoclip()
        toggle.Text = "NOCLIP : OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(150,50,50)
    end
end)

spd1.MouseButton1Click:Connect(function() speed = 1.5 end)
spd2.MouseButton1Click:Connect(function() speed = 3 end)
spd3.MouseButton1Click:Connect(function() speed = 6 end)

close.MouseButton1Click:Connect(function()
    disableNoclip()
    gui:Destroy()
end)

------------------------------------------------
-- RESPAWN FIX
------------------------------------------------
player.CharacterAdded:Connect(function(c)
    character = c
    root = c:WaitForChild("HumanoidRootPart")
    humanoid = c:WaitForChild("Humanoid")

    if noclip then
        task.wait(0.2)
        enableNoclip()
    end
end)
