--====================================================
-- RED TEAM AUDIT V7 (UI REDESIGN)
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local STATE = {
    Running = true,
    Noclip = false,
    TargetPlayer = ""
}

-- FUNÇÃO PARA OBTER O HUMANÓIDE DE FORMA SEGURA
local function getHumanoid()
    local char = LocalPlayer.Character
    if not char or not char.Parent then return end
    return char:FindFirstChildOfClass("Humanoid")
end

-- 1. LOOP PRINCIPAL DE FÍSICA (NOCLIP PERSISTENTE)
local physicsConnection = RunService.Heartbeat:Connect(function()
    if not STATE.Running then return end
    
    local char = LocalPlayer.Character
    if char and STATE.Noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then 
                part.CanCollide = false 
            end
        end
    end
end)

-- 2. INTERFACE ROBUSTA (NOVO VISUAL)
local sg = Instance.new("ScreenGui")
sg.Name = "AuditV7_Interface"
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

local Frame = Instance.new("Frame", sg)
Frame.Size = UDim2.new(0, 200, 0, 180) -- Tamanho menor, mais compacto
Frame.Position = UDim2.new(0.5, -100, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25) -- Fundo mais escuro
Frame.Active = true
Frame.Draggable = true

-- TÍTULO (VERMELHO)
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "R E D . T E A M"
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0) -- Cor de destaque
Title.TextColor3 = Color3.new(1, 1, 1)

-- BOTÃO NOCLIP
local NocBtn = Instance.new("TextButton", Frame)
NocBtn.Size = UDim2.new(0.9, 0, 0, 40)
NocBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
NocBtn.Text = "NOCLIP: OFF"
NocBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
NocBtn.MouseButton1Click:Connect(function()
    STATE.Noclip = not STATE.Noclip
end)

-- BOTÃO TELEPORTE (SIMPLIFICADO - SEM INPUT DE TEXTO)
-- Para simplificar o teste, ele se teletransporta para a câmera do usuário
local TpBtn = Instance.new("TextButton", Frame)
TpBtn.Size = UDim2.new(0.9, 0, 0, 40)
TpBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
TpBtn.Text = "TP PARA MINHA CÂMERA"
TpBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
TpBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Teleporta para onde a câmera está olhando
        char:SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -10))
    end
end)

-- FEEDBACK VISUAL EM TEMPO REAL
RunService.RenderStepped:Connect(function()
    if not STATE.Running then return end
    NocBtn.Text = STATE.Noclip and "NOCLIP: ATIVO" or "NOCLIP: INATIVO"
    NocBtn.BackgroundColor3 = STATE.Noclip and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 80)
end)

-- BOTÃO FECHAR
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(1, 0, 0, 40)
CloseBtn.Position = UDim2.new(0, 0, 1, -40)
CloseBtn.Text = "FECHAR E LIMPAR AUDIT"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

CloseBtn.MouseButton1Click:Connect(function()
    STATE.Running = false
    STATE.Noclip = false
    if physicsConnection then physicsConnection:Disconnect() end
    sg:Destroy() 
end)
