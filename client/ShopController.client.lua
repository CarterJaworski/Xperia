local ShopController = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")


local Comm = ReplicatedStorage:WaitForChild("ShopService_Comm")
local Player = game:GetService("Players").LocalPlayer
local UI = Player.PlayerGui:WaitForChild("ShopUI")

local ui_maximum_size = UDim2.new(0.275, 0,0.602, 0)
local ui_minimum_size = UDim2.new(0.045, 0,0.067, 0)
local ui_tween_speed = TweenInfo.new(.35)

function ShopController:LoadShop(folder)
    for _,item in pairs(folder:GetChildren()) do 
        local viewport_frame = Instance.new("ViewportFrame",UI.Frame.ScrollingFrame)
        local text_label = Instance.new("TextLabel",viewport_frame)
        local button = Instance.new("TextButton",viewport_frame)
        local item_view = item:Clone() 
        local camera = Instance.new("Camera",viewport_frame)
        local get_bounding_box = item_view:GetBoundingBox() 

        button.ZIndex = 5
        button.BackgroundTransparency = 1 
        button.Text = ""
        button.Size = UDim2.new(1,0,1,0)

        text_label.Size = UDim2.new(1,0,.15,0)
        text_label.Position = UDim2.new(0,0,.85,0)
        text_label.BackgroundTransparency = .95
        text_label.TextStrokeTransparency = 0.85
        text_label.TextColor3 = Color3.fromRGB(255,255,255)
        text_label.Text = "$"..tostring(item:GetAttribute("Price"))
        text_label.TextScaled = true 

        item_view.Parent = viewport_frame
        
        camera.CFrame = CFrame.new(get_bounding_box.Position+Vector3.new(5,7.5,5),get_bounding_box.Position)
        viewport_frame.CurrentCamera = camera 
        viewport_frame.BackgroundTransparency = .9

    end

end

function ShopController:ShopOpened(contents_directory_name: string)
    self:LoadShop(ReplicatedStorage.Shops:FindFirstChild(contents_directory_name))
    UI.Enabled = true
    local open_tween = TweenService:Create(UI.Frame,ui_tween_speed,{Size = ui_maximum_size})
    open_tween:Play() 
    open_tween.Completed:Wait() 
end

function ShopController:ShopClosed()
    UI.Enabled = true 
    local close_tween = TweenService:Create(UI.Frame,ui_tween_speed,{Size = ui_minimum_size})
    close_tween:Play() 
    close_tween.Completed:Wait() 
    UI.Enabled = false 
end

function ShopController:XListener()
    UI:WaitForChild("Frame"):WaitForChild("X").MouseButton1Click:connect(function()
        self:ShopClosed()
    end)
end

function ShopController:EventListener()
    Comm:WaitForChild("ShopOpened").OnClientEvent:connect(function(args: string)
        print("SHOP NAME "..args)
        self:ShopOpened(args)
    end)
end

function ShopController:Init()
    UI.Frame.Size = ui_minimum_size
    self:XListener()
    self:EventListener()
end

ShopController:Init()

return ShopController