--====================================================
-- RED TEAM AUDIT - TOOLKIT DE TESTE (DELTA)
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local UI_STATE = {
    Noclip = false,
    Speed = 16,
    TargetPlayer = ""
}

-- 1. LÓGICA DE NOCLIP (FÍSICA)
RunService.Stepped:Connect(function()
    if UI_STATE.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 2. INTERFACE GRÁFICA
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "RedTeam_Diagnostic"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.Active = true
MainFrame.Draggable = true -- Facilita o uso no mobile/Delta

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "RED TEAM - AUDIT"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)

-- BOTÃO: VELOCIDADE (WALKSPEED)
local SpeedBtn = Instance.new("TextButton", MainFrame)
SpeedBtn.Size = UDim2.new(0.9, 0, 0, 40)
SpeedBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
SpeedBtn.Text = "TESTAR SPEED (100)"
SpeedBtn.Callback = function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end

-- BOTÃO: NOCLIP
local NoclipBtn = Instance.new("TextButton", MainFrame)
NoclipBtn.Size = UDim2.new(0.9, 0, 0, 40)
NoclipBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
NoclipBtn.Text = "NOCLIP: OFF"
NoclipBtn.MouseButton1Click:Connect(function()
    UI_STATE.Noclip = not UI_STATE.Noclip
    NoclipBtn.Text = UI_STATE.Noclip and "NOCLIP: ON" or "NOCLIP: OFF"
    NoclipBtn.BackgroundColor3 = UI_STATE.Noclip and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0)
end)

-- INPUT: NOME DO JOGADOR PARA TP
local TpInput = Instance.new("TextBox", MainFrame)
TpInput.Size = UDim2.new(0.9, 0, 0, 40)
TpInput.Position = UDim2.new(0.05, 0, 0.50, 0)
TpInput.PlaceholderText = "Nome do Jogador..."
TpInput.Text = ""

-- BOTÃO: TELEPORTE
local TpBtn = Instance.new("TextButton", MainFrame)
TpBtn.Size = UDim2.new(0.9, 0, 0, 40)
TpBtn.Position = UDim2.new(0.05, 0, 0.67, 0)
TpBtn.Text = "TELEPORTAR"
TpBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(TpInput.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:SetPrimaryPartCFrame(target.Character.HumanoidRootPart.CFrame)
    end
end)

-- BOTÃO: FECHAR E LIMPAR
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(1, 0, 0, 30)
CloseBtn.Position = UDim2.new(0, 0, 1, -30)
CloseBtn.Text = "FECHAR SCRIPT"
CloseBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
CloseBtn.MouseButton1Click:Connect(function()
    UI_STATE.Noclip = false
    ScreenGui:Destroy()
end)
