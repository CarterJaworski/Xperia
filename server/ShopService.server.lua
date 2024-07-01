local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ShopService = {
    CommsFolder = Instance.new("Folder",ReplicatedStorage),
    Comms = {
        ShopOpened = Instance.new("RemoteEvent"),
    },
    ShopsPath = workspace:WaitForChild("Shops")
}

function ShopService:InitComms()
     self.CommsFolder.Name = "ShopService_Comm"
     for name,comm in pairs(self.Comms) do 
        comm.Name = name 
        comm.Parent = self.CommsFolder
     end 
end

function ShopService:HandleComms()
    local function remote_event_listener(remote_event: RemoteEvent)
        remote_event.OnServerEvent:connect(function(player: Player,args: table)     

        end)
    end 
    
    local function remote_function_listener(remote_function: RemoteFunction)
        local function invoked(player: Player, args: table)
            local return_value 

            return return_value 
        end 
        remote_function.OnServerInvoke = invoked
    end 
    for _,comm in pairs(self.CommsFolder:GetChildren()) do 
        if comm:IsA("RemoteEvent") then 
            remote_event_listener(comm)
        elseif comm:IsA("RemoteFunction") then 
            remote_function_listener(comm)
        end 
    end 
end

function ShopService:HandlePrompts()
    for _,prompt in pairs(self.ShopsPath:GetDescendants()) do 
        if prompt:IsA("ProximityPrompt") then 
            prompt.Triggered:connect(function(player: Player)
                self.Comms.ShopOpened:FireClient(player,prompt.Name)
            end)
        end 
    end 
end


function ShopService:Init()
    self:InitComms()
    self:HandleComms() 
    self:HandlePrompts()
end

ShopService:Init() 

return ShopService 