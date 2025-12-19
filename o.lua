--====================================================
-- RED TEAM AUDIT V8 (PLAYER LIST & NOCLIP)
--====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local STATE = {
    Running = true,
    Noclip = false,
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

-- 2. INTERFACE ROBUSTA
local sg = Instance.new("ScreenGui")
sg.Name = "AuditV8_Interface"
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

local Frame = Instance.new("Frame", sg)
Frame.Size = UDim2.new(0, 200, 0, 300) -- Frame maior para caber a lista
Frame.Position = UDim2.new(0.5, -100, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.Active = true
Frame.Draggable = true

-- TÍTULO
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "R E D . T E A M . A U D I T"
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)

-- FRAME DA LISTA DE JOGADORES
local PlayerListFrame = Instance.new("ScrollingFrame", Frame)
PlayerListFrame.Size = UDim2.new(1, 0, 0.6, 0) -- Ocupa 60% do frame principal
PlayerListFrame.Position = UDim2.new(0, 0, 0.15, 0)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Ajustado dinamicamente

local UILayout = Instance.new("UIListLayout", PlayerListFrame)
UILayout.FillDirection = Enum.FillDirection.Vertical
UILayout.Padding = UDim2.new(0, 5, 0, 5)
UILayout.SortOrder = Enum.SortOrder.Name

-- 3. FUNÇÃO DE TELEPORTE (Executada pelo botão na lista)
local function teleportToPlayer(targetPlayer)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and targetPlayer and targetPlayer.Character then
        char:SetPrimaryPartCFrame(targetPlayer.Character:GetPrimaryPartCFrame() * CFrame.new(0, 5, 0))
    end
end

-- 4. FUNÇÃO PARA ATUALIZAR A LISTA DE JOGADORES
local function updatePlayerList()
    -- Limpa a lista existente
    for _, item in pairs(PlayerListFrame:GetChildren()) do
        if item:IsA("TextButton") then
            item:Destroy()
        end
    end

    -- Adiciona novos jogadores
    for _, player in pairs(Players:GetPlayers()) do
        local PlayerButton = Instance.new("TextButton")
        PlayerButton.Size = UDim2.new(1, 0, 0, 30)
        PlayerButton.Text = player.Name
        PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        PlayerButton.Parent = PlayerListFrame

        PlayerButton.MouseButton1Click:Connect(function()
            teleportToPlayer(player)
        end)
    end
    -- Ajusta o tamanho da área de rolagem
    PlayerListFrame.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y)
end

-- Atualiza a lista quando um jogador entra/sai
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
-- Atualiza a lista na inicialização
updatePlayerList()


-- BOTÃO NOCLIP
local NocBtn = Instance.new("TextButton", Frame)
NocBtn.Size = UDim2.new(0.9, 0, 0, 40)
NocBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
NocBtn.Text = "NOCLIP: OFF"
NocBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
NocBtn.MouseButton1Click:Connect(function()
    STATE.Noclip = not STATE.Noclip
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
