-- [[ GGPVP HUB - CUSTOM MOBILE VERSION ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [[ CONFIGURAÇÕES ]]
_G.Aimbot = false
_G.WallCheck = true
_G.FOVSize = 150
_G.Smoothness = 0.15
_G.WalkSpeed = 16
_G.ESP_Enabled = false

-- [[ UI BÁSICA EM LOCAL SCRIPT ]]
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleAimbot = Instance.new("TextButton")
local ToggleWall = Instance.new("TextButton")
local ToggleESP = Instance.new("TextButton")
local SpeedSlider = Instance.new("TextBox")
local FOVSlider = Instance.new("TextBox")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.Name = "GGPVPHub"

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "GGPVP HUB"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

-- Função auxiliar para criar botões rapidamente
local function CreateBtn(name, text, pos, color)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Parent = MainFrame
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.Position = pos
    b.Text = text
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    return b
end

ToggleAimbot = CreateBtn("Aimbot", "Aimbot: OFF", UDim2.new(0.05, 0, 0.15, 0), Color3.fromRGB(50, 50, 50))
ToggleWall = CreateBtn("Wall", "WallCheck: ON", UDim2.new(0.05, 0, 0.3, 0), Color3.fromRGB(0, 100, 0))
ToggleESP = CreateBtn("ESP", "ESP: OFF", UDim2.new(0.05, 0, 0.45, 0), Color3.fromRGB(50, 50, 50))

FOVSlider.Parent = MainFrame
FOVSlider.Size = UDim2.new(0.9, 0, 0, 30)
FOVSlider.Position = UDim2.new(0.05, 0, 0.6, 0)
FOVSlider.PlaceholderText = "FOV: 150"
FOVSlider.Text = ""

SpeedSlider.Parent = MainFrame
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 30)
SpeedSlider.Position = UDim2.new(0.05, 0, 0.75, 0)
SpeedSlider.PlaceholderText = "Speed: 16"
SpeedSlider.Text = ""

-- Botão de Minimizar (Canto da tela)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = ScreenGui
MiniBtn.Size = UDim2.new(0, 50, 0, 50)
MiniBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
MiniBtn.Text = "GGPVP"
MiniBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MiniBtn.Draggable = true

MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- [[ LÓGICA DAS FUNÇÕES ]]

-- Toggle Events
ToggleAimbot.MouseButton1Click:Connect(function()
    _G.Aimbot = not _G.Aimbot
    ToggleAimbot.Text = _G.Aimbot and "Aimbot: ON" or "Aimbot: OFF"
    ToggleAimbot.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(50, 50, 50)
end)

ToggleWall.MouseButton1Click:Connect(function()
    _G.WallCheck = not _G.WallCheck
    ToggleWall.Text = _G.WallCheck and "WallCheck: ON" or "WallCheck: OFF"
end)

ToggleESP.MouseButton1Click:Connect(function()
    _G.ESP_Enabled = not _G.ESP_Enabled
    ToggleESP.Text = _G.ESP_Enabled and "ESP: ON" or "ESP: OFF"
end)

FOVSlider.FocusLost:Connect(function()
    _G.FOVSize = tonumber(FOVSlider.Text) or 150
end)

SpeedSlider.FocusLost:Connect(function()
    _G.WalkSpeed = tonumber(SpeedSlider.Text) or 16
end)

-- [[ SISTEMA DE AIMBOT COM WALLCHECK ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)

local function IsBehindWall(target)
    if not _G.WallCheck then return false end
    local ray = Ray.new(Camera.CFrame.Position, (target.Position - Camera.CFrame.Position).Unit * 1000)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
    if hit and hit:IsDescendantOf(target.Parent) then
        return false
    end
    return true
end

local function GetClosestTarget()
    local closestDist = _G.FOVSize
    local target = nil
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local head = v.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < closestDist then
                    if not IsBehindWall(head) then
                        closestDist = dist
                        target = head
                    end
                end
            end
        end
    end
    return target
end

-- [[ LOOP DE RENDERIZAÇÃO ]]
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.Aimbot
    FOVCircle.Radius = _G.FOVSize
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if _G.Aimbot then
        local target = GetClosestTarget()
        if target then
            local pred = target.Position + (target.Velocity * 0.12)
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pred), _G.Smoothness)
        end
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeed
    end
end)

-- [[ SISTEMA DE ESP (BOX/DIST) ]]
local function CreateESP(plr)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    
    RunService.RenderStepped:Connect(function()
        if _G.ESP_Enabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 and plr ~= LocalPlayer then
            local root = plr.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                box.Visible = true
                box.Size = Vector2.new(2000/pos.Z, 2500/pos.Z)
                box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
            else box.Visible = false end
        else box.Visible = false end
    end)
end

for _, p in pairs(Players:GetPlayers()) do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)
