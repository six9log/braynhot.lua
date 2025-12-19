--====================================================
-- RED TEAM AUDIT V9 (REMOTE SPY & EXECUTOR)
--====================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local STATE = {
    Running = true,
    FoundRemotes = {}, -- Cache de remotos encontrados
}

-- 1. INTERFACE ROBUSTA
local sg = Instance.new("ScreenGui")
sg.Name = "AuditV9_RemoteSpy"
sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false 

local Frame = Instance.new("Frame", sg)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.Active = true
Frame.Draggable = true

-- TÍTULO
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "REMOTE SPY & EXECUTOR"
Title.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Title.TextColor3 = Color3.new(1, 1, 1)

-- LISTA DE REMOTES ENCONTRADOS
local RemoteListFrame = Instance.new("ScrollingFrame", Frame)
RemoteListFrame.Size = UDim2.new(1, 0, 0.75, 0)
RemoteListFrame.Position = UDim2.new(0, 0, 0.08, 0)
RemoteListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
local UILayout = Instance.new("UIListLayout", RemoteListFrame)
UILayout.FillDirection = Enum.FillDirection.Vertical
UILayout.Padding = UDim2.new(0, 5, 0, 5)

-- FUNÇÃO PARA ADICIONAR UM BOTÃO DE DISPARO PARA UM REMOTE ESPECÍFICO
local function addRemoteButton(remoteInstance)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = "FIRE: " .. remoteInstance.Name
    btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    btn.Parent = RemoteListFrame

    btn.MouseButton1Click:Connect(function()
        -- Dispara o evento remoto. Este é o seu vetor de bypass.
        -- Tente disparar isso de longe do 'brainrot' para testar a validação do servidor.
        remoteInstance:FireServer()
    end)
    
    RemoteListFrame.CanvasSize = UDim2.new(0, 0, 0, UILayout.AbsoluteContentSize.Y)
end

-- 5. LÓGICA DE AUDITORIA: ENCONTRAR REMOTES DINAMICAMENTE
local function findRemotes(container)
    for _, child in pairs(container:GetDescendants()) do
        if (child:IsA("RemoteEvent") or child:IsA("RemoteFunction")) and not STATE.FoundRemotes[child.Name] then
            STATE.FoundRemotes[child.Name] = true
            addRemoteButton(child)
            print("RedTeam Audit: Found Remote -> " .. child.Name)
        end
    end
end

-- Monitora mudanças em tempo real
ReplicatedStorage.ChildAdded:Connect(function(child) findRemotes(child) end)
findRemotes(ReplicatedStorage)
-- (Opcional: você pode procurar em outras pastas se souber onde os remotos estão)

-- BOTÃO FECHAR
local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(1, 0, 0, 40)
CloseBtn.Position = UDim2.new(0, 0, 1, -40)
CloseBtn.Text = "FECHAR E LIMPAR AUDIT"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

CloseBtn.MouseButton1Click:Connect(function()
    STATE.Running = false
    sg:Destroy() 
end)
