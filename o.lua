--====================================================
-- RED TEAM AUDIT V2 (FIXED SPEED & CLOSE)
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local STATE = {
    Noclip = false,
    SpeedEnabled = false,
    SpeedValue = 100,
    Running = true
}

-- 1. LOOP DE FÍSICA (FORÇA SPEED E NOCLIP)
local physicsConnection
physicsConnection = RunService.Stepped:Connect(function()
    if not STATE.Running then 
        physicsConnection:Disconnect()
        return 
    end
    
    local char = LocalPlayer.Character
    if char then
        -- Forçar Speed (Bypassa resets simples do servidor)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and STATE.SpeedEnabled then
            hum.WalkSpeed = STATE.SpeedValue
        end
        
        -- Noclip
        if STATE.Noclip then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

-- 2. INTERFACE
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "Audit_v2_" .. math.random(100)

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 280)
Main.Position = UDim2.new(0.5, -110, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.Active = true
Main.Draggable = true

-- BOTÃO SPEED (ON/OFF)
local SpeedBtn = Instance.new("TextButton", Main)
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 45)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
SpeedBtn.Text = "SPEED: OFF"
SpeedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)

SpeedBtn.MouseButton1Click:Connect(function()
    STATE.SpeedEnabled = not STATE.SpeedEnabled
    SpeedBtn.Text = STATE.SpeedEnabled and "SPEED: ON (100)" or "SPEED: OFF"
    SpeedBtn.BackgroundColor3 = STATE.SpeedEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 65)
end)

-- BOTÃO NOCLIP
local NocBtn = Instance.new("TextButton", Main)
NocBtn.Size = UDim2.new(0.9, 0, 0, 45)
NocBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
NocBtn.Text = "NOCLIP: OFF"
NocBtn.MouseButton1Click:Connect(function()
    STATE.Noclip = not STATE.Noclip
    NocBtn.Text = STATE.Noclip and "NOCLIP: ON" or "NOCLIP: OFF"
    NocBtn.BackgroundColor3 = STATE.Noclip and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 65)
end)

-- TP INPUT E BOTÃO
local TargetInput = Instance.new("TextBox", Main)
TargetInput.Size = UDim2.new(0.9, 0, 0, 40)
TargetInput.Position = UDim2.new(0.05, 0, 0.5, 0)
TargetInput.PlaceholderText = "Nome do Jogador..."

local TpBtn = Instance.new("TextButton", Main)
TpBtn.Size = UDim2.new(0.9, 0, 0, 45)
TpBtn.Position = UDim2.new(0.05, 0, 0.68, 0)
TpBtn.Text = "TELEPORTAR"
TpBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(TargetInput.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
    end
end)

-- BOTÃO FECHAR (LIMPA TUDO)
local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(1, 0, 0, 35)
Close.Position = UDim2.new(0, 0, 1, -35)
Close.Text = "FECHAR E PARAR"
Close.BackgroundColor3 = Color3.fromRGB(120, 0, 0)

Close.MouseButton1Click:Connect(function()
    STATE.Running = false
    STATE.SpeedEnabled = false
    STATE.Noclip = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Reset ao fechar
    end
    ScreenGui:Destroy()
end)
