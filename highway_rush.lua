local ReplicatedStorage = game:GetService('ReplicatedStorage')
local SpawnCar = ReplicatedStorage.SpawnCar

local StarterGui = game:GetService('StarterGui')
local CarSpawnerFrame = StarterGui.SpawnCarScreen.CarSpawnerFrame

local cars = {}
for _, c in pairs(CarSpawnerFrame:GetChildren()) do
	if c:IsA('TextButton') and c:FindFirstChild('CallScript') then
		cars[#cars + 1] = c.Name
	end
end

for _, c in pairs(ReplicatedStorage:GetChildren()) do
	if c:IsA('TextButton') and c:FindFirstChild('CallScript') then
		cars[#cars + 1] = c.Name
	end
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
	Name = 'Highway Rush'
})

local Tab = Window:MakeTab({
	Name = 'Main'
})

local List = Tab:AddDropdown({
	Name = 'Selected Car',
	Default = cars[1],
	Options = cars
})

Tab:AddButton({
	Name = 'Spawn',
	Callback = function()
		SpawnCar:FireServer(List.Value)
	end
})