-- Delta Fix: Garante que a Library carregue antes de prosseguir
local success, Library = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))() 
end)

if not success then return end

local Window = Library.CreateLib("GGPVP HUB - DELTA FIX", "DarkTheme")

-- [[ SERVIÇOS ]]
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- [[ VARIÁVEIS GLOBAIS ]]
_G.AimbotEnabled = false
_G.AimbotSmoothness = 0 
_G.WallCheck = true
_G.MaxAimDistance = 1000
_G.NoRecoil = false
_G.FOVSize = 150
_G.GodMode = false
_G.Noclip = false
_G.FlyEnabled = false
_G.FlySpeed = 50
_G.WalkSpeedValue = 16
_G.ESP_Box = false
_G.ESP_Skeleton = false
_G.ESP_Distance = false

-- [[ BOTÃO MOBILE DELTA FIX ]]
local ScreenGui = Instance.new("ScreenGui")
-- Usamos PlayerGui no Delta para evitar bloqueio de CoreGui
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "DeltaSafeGGPVP"

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleButton.Text = "MENU"
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Draggable = true 

ToggleButton.MouseButton1Click:Connect(function()
    Library:ToggleGui()
end)

-- [[ LÓGICA DE ALVO COM CHECAGEM DE PAREDE ]]
local function IsVisible(TargetPart)
    local Character = LocalPlayer.Character
    if not Character then return false end
    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Blacklist
    Params.FilterDescendantsInstances = {Character, Camera}
    local Result = workspace:Raycast(Camera.CFrame.Position, (TargetPart.Position - Camera.CFrame.Position).Unit * 1000, Params)
    return Result == nil or Result.Instance:IsDescendantOf(TargetPart.Parent)
end

local function GetClosest()
    local target = nil
    local shortestDist = _G.FOVSize
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") then
            local head = v.Character.Head
            local pos, screen = Camera:WorldToViewportPoint(head.Position)
            if screen then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                local worldDist = (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude
                if mouseDist < shortestDist and worldDist <= _G.MaxAimDistance then
                    if not _G.WallCheck or IsVisible(head) then
                        shortestDist = mouseDist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

-- [[ LOOPS ]]
RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local t = GetClosest()
        if t then
            local look = CFrame.new(Camera.CFrame.Position, t.Position + (t.Velocity * 0.12))
            Camera.CFrame = Camera.CFrame:Lerp(look, 1 - _G.AimbotSmoothness)
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if _G.GodMode then LocalPlayer.Character.Humanoid.Health = 100 end
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
    end
end)

-- Fly Logic
local bv, bg
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if _G.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        if not bv then
            bv = Instance.new("BodyVelocity", root); bv.MaxForce = Vector3.new(1,1,1)*math.huge
            bg = Instance.new("BodyGyro", root); bg.MaxTorque = Vector3.new(1,1,1)*math.huge
        end
        bg.CFrame = Camera.CFrame
        bv.Velocity = Camera.CFrame.LookVector * _G.FlySpeed
    else
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
end)

-- [[ INTERFACE ]]
local Combat = Window:NewTab("Combate")
local CombatSec = Combat:NewSection("Aimbot")
CombatSec:NewToggle("Ativar Aimbot", "Mira automática", function(s) _G.AimbotEnabled = s end)
CombatSec:NewToggle("Wall Check", "Não foca atrás da parede", function(s) _G.WallCheck = s end)
CombatSec:NewSlider("Alcance (Distância)", "Metros", 5000, 100, function(s) _G.MaxAimDistance = s end)
CombatSec:NewSlider("Suavidade", "Smooth", 100, 0, function(s) _G.AimbotSmoothness = s/100 end)

local Troll = Window:NewTab("Troll")
local TrollSec = Troll:NewSection("Movimentação")
TrollSec:NewToggle("Fly (Vôo)", "Voar para onde olha", function(s) _G.FlyEnabled = s end)
TrollSec:NewSlider("Velocidade Fly", "FlySpeed", 300, 50, function(s) _G.FlySpeed = s end)
TrollSec:NewSlider("Velocidade Andar", "Walkspeed", 250, 16, function(s) _G.WalkSpeedValue = s end)
TrollSec:NewToggle("Noclip", "Atravessar Tudo", function(s) _G.Noclip = s end)
TrollSec:NewToggle("God Mode", "Vida infinita", function(s) _G.GodMode = s end)

local Config = Window:NewTab("Config")
Config:NewButton("Destruir Script", "Sair", function() ScreenGui:Destroy(); Library:Destroy() end)

Library:Notify("GGPVP DELTA", "Script adaptado para Delta Executor!", 5)
