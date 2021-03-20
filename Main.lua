--[[
    Bloxburg Script (Uh, good name right...?)
]]

-- Wait for game to load

repeat wait() until game:IsLoaded();

-- Define variables

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacks/Utilities/main/UI.lua"))();

local workspace = game:GetService("Workspace");
local replicatedStorage = game:GetService("ReplicatedStorage");
local tweenService = game:GetService("TweenService");
local players = game:GetService("Players");
local client = players.LocalPlayer;

-- Main script

local stats = replicatedStorage.Stats[client.Name];
local dataManager = require(replicatedStorage.Modules.DataManager);
local jobManager = require(client.PlayerGui.MainGUI.Scripts.JobManager);

local function fireServer(data)
    local oldI = getfenv(dataManager.FireServer).i;
    getfenv(dataManager.FireServer).i = function() end; --> Get around their shit "security"
    dataManager:FireServer(data);
    getfenv(dataManager.FireServer).i = oldI; --> Restore original function
end;

local function getOrder(customer)
    if (not customer or (customer and not customer:FindFirstChild("Order"))) then return end;

    local style = customer.Order:WaitForChild("Style").Value;
    local colour = customer.Order:WaitForChild("Color").Value;

    return {style, colour};
end;

local bloxburg = library:CreateWindow("Bloxburg");

bloxburg:AddToggle({
    text = "Stylez Hairdresser";
    flag = "hairdresser";
    callback = function(enabled)
        if (not enabled) then return end;

        if (stats.Job.Value ~= "StylezHairdresser") then
            jobManager:GoToWork("StylezHairdresser"); --> TP to job
        end;

        repeat wait() until stats.Job.Value == "StylezHairdresser";
        tweenService:Create(client.Character.HumanoidRootPart, TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(868.464783, 13.6776829, 174.983795, -0.999945581, -6.58446098e-08, -0.0104347449, -6.6522297e-08, 1, 6.45977494e-08, 0.0104347449, 6.52883756e-08, -0.999945581)}):Play();

        while library.flags.hairdresser do
            local workstations = workspace.Environment.Locations.StylezHairStudio.HairdresserWorkstations;
            for i, v in next, workstations:GetChildren() do
                if (v.Occupied.Value) then
                    fireServer({
                        Type = "FinishOrder";
                        Workstation = v;
                        Order = getOrder(v.Occupied.Value);
                    });
                end;
            end;
            wait();
        end;
    end;
});

-- Load library

library:Init();
