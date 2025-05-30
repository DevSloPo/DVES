--HA TEAM_Httadmin
--httadmin_Notifica.version V1.0.3
--版权所有© 二改必究
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

Httadmin = {}
local GUI_NAME = "NotificationGui"
local activeNotifications = {}

local CONFIG = {
    WIDTH = 200,
    HEIGHT = 80,
    SPACING = 8,
    OFFSET = Vector2.new(20, 20),
    BACKGROUND_TRANSPARENCY = 0.5,
    CORNER_RADIUS = 4,
    PROGRESS_BAR = {
        HEIGHT = 6,
        CORNER_RADIUS = 3
    },
    TITLE = {
        FONT = Enum.Font.GothamBold,
        SIZE = 20,
        COLOR = Color3.fromRGB(255, 255, 255),
        OFFSET = 10
    },
    MESSAGE = {
        FONT = Enum.Font.Gotham,
        SIZE = 16,
        COLOR = Color3.fromRGB(220, 220, 220),
        OFFSET = 40
    },
    ICON = {
        SIZE = UDim2.new(0, 32, 0, 32),
        OFFSET = 10
    },
    ANIMATION = {
        DURATION = 0.3,
        EASING_STYLE = Enum.EasingStyle.Quad,
        EASING_DIRECTION = Enum.EasingDirection.Out
    }
}

local function HSVtoRGB(h, s, v)
    local c = v * s
    local x = c * (1 - math.abs((h / 60) % 2 - 1))
    local m = v - c
    local r, g, b = 0, 0, 0
    if h < 60 then r, g, b = c, x, 0
    elseif h < 120 then r, g, b = x, c, 0
    elseif h < 180 then r, g, b = 0, c, x
    elseif h < 240 then r, g, b = 0, x, c
    elseif h < 300 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end
    return Color3.new(r + m, g + m, b + m)
end

local SCALE = 0.9

local function initializeGui()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = playerGui:FindFirstChild(GUI_NAME)
    if not gui then
        gui = Instance.new("ScreenGui")
        gui.Name = GUI_NAME
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.DisplayOrder = 1000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = playerGui
    end
    return gui
end

local function updateNotificationsPosition()
    for index, notification in ipairs(activeNotifications) do
        local yOffset = (CONFIG.HEIGHT * SCALE + CONFIG.SPACING) * (index - 1)
        notification.frame:TweenPosition(
            UDim2.new(1, -CONFIG.OFFSET.X, 1, -CONFIG.OFFSET.Y - yOffset),
            CONFIG.ANIMATION.EASING_DIRECTION,
            CONFIG.ANIMATION.EASING_STYLE,
            CONFIG.ANIMATION.DURATION,
            true
        )
    end
end

function Httadmin.send(title, message, duration, iconId)
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://4590657391"
    sound.Volume = 10
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)

    duration = duration or 4
    local gui = initializeGui()

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, CONFIG.WIDTH * SCALE, 0, CONFIG.HEIGHT * SCALE)
    frame.Position = UDim2.new(1, 0, 1, -CONFIG.OFFSET.Y)
    frame.AnchorPoint = Vector2.new(1, 1)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = CONFIG.BACKGROUND_TRANSPARENCY
    frame.BorderSizePixel = 0
    frame.ZIndex = 10
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, CONFIG.CORNER_RADIUS)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Parent = frame

    local iconOffset = 0
    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 32 * SCALE, 0, 32 * SCALE)
        icon.Position = UDim2.new(0, CONFIG.ICON.OFFSET * SCALE, 0, CONFIG.ICON.OFFSET * SCALE)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.ImageTransparency = 1
        icon.ZIndex = 11
        icon.Parent = frame
        iconOffset = 48 * SCALE
        TweenService:Create(icon, TweenInfo.new(CONFIG.ANIMATION.DURATION), {ImageTransparency = 0}):Play()
    end

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -(iconOffset + 10 * SCALE), 0, 28 * SCALE)
    titleLabel.Position = UDim2.new(0, iconOffset > 0 and (48 * SCALE) or (10 * SCALE), 0, CONFIG.TITLE.OFFSET * SCALE)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.Font = CONFIG.TITLE.FONT
    titleLabel.TextSize = CONFIG.TITLE.SIZE * SCALE
    titleLabel.TextColor3 = CONFIG.TITLE.COLOR
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTransparency = 1
    titleLabel.ZIndex = 11
    titleLabel.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -(iconOffset + 10 * SCALE), 1, -40 * SCALE)
    messageLabel.Position = UDim2.new(0, iconOffset > 0 and (48 * SCALE) or (10 * SCALE), 0, CONFIG.MESSAGE.OFFSET * SCALE)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.Font = CONFIG.MESSAGE.FONT
    messageLabel.TextSize = CONFIG.MESSAGE.SIZE * SCALE
    messageLabel.TextColor3 = CONFIG.MESSAGE.COLOR
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextTransparency = 1
    messageLabel.ZIndex = 11
    messageLabel.Parent = frame

    TweenService:Create(titleLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 0}):Play()
    TweenService:Create(messageLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 0}):Play()

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, CONFIG.PROGRESS_BAR.HEIGHT * SCALE)
    progressBar.Position = UDim2.new(0, 0, 1, -(CONFIG.PROGRESS_BAR.HEIGHT * SCALE))
    progressBar.BackgroundTransparency = 1
    progressBar.ClipsDescendants = true
    progressBar.ZIndex = 11
    progressBar.Parent = frame

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.AnchorPoint = Vector2.new(0, 0)
    fill.BackgroundColor3 = Color3.new(1, 0, 0)
    fill.ZIndex = 12
    fill.Parent = progressBar

    local cornerFill = Instance.new("UICorner")
    cornerFill.CornerRadius = UDim.new(0, CONFIG.PROGRESS_BAR.CORNER_RADIUS)
    cornerFill.Parent = fill

    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local ratio = math.clamp(1 - elapsed / duration, 0, 1)
        fill.Size = UDim2.new(ratio, 0, 1, 0)

        local hue = (elapsed * 120) % 360
        fill.BackgroundColor3 = HSVtoRGB(hue, 1, 1)

        if ratio <= 0 then
            connection:Disconnect()
        end
    end)

    local notification = {
        frame = frame,
        createdAt = os.time()
    }
    table.insert(activeNotifications, notification)
    updateNotificationsPosition()

    task.delay(duration, function()
        local fadeOut = TweenService:Create(frame, TweenInfo.new(CONFIG.ANIMATION.DURATION), {
            BackgroundTransparency = 1
        })
        TweenService:Create(titleLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 1}):Play()
        TweenService:Create(messageLabel, TweenInfo.new(CONFIG.ANIMATION.DURATION), {TextTransparency = 1}):Play()
        fadeOut:Play()

        fadeOut.Completed:Connect(function()
            frame:Destroy()
            for i, v in ipairs(activeNotifications) do
                if v == notification then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            updateNotificationsPosition()
        end)
    end)
end

return Httadmin