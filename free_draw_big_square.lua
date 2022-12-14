local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')

local LocalPlayer = Players.LocalPlayer
local Client = require(ReplicatedStorage.shared.remotes).Client

local CreateLineEvent = Client:Get('createLine')
local CreateLayerEvent = Client:Get('createLayer')

local function DrawBigSquare(layer_id, color)
	local positions = {}

	for i = -1000, 1000 do
		positions[#positions + 1] = Vector2.new(-1000, i)
		positions[#positions + 1] = Vector2.new(1000, i)
	end

	local data = {
		layer_id,
		positions,
		{
			['color'] = color,
			['transparency'] = 0,
			['thickness'] = 2
		}
	}

	CreateLineEvent:CallServerAsync(unpack(data))
end

for _ = 1, 29 do
	CreateLayerEvent:CallServerAsync()
	wait(0.1)
end

wait(2.5)

local new_index, new_id = -1, nil
for _, child in pairs(LocalPlayer.Trackers:GetChildren()) do
	local index = child:GetAttribute('index')

	if index > new_index then
		new_id = child:GetAttribute('id')
		new_index = index
	end
end

DrawBigSquare(new_id, Color3.new(0, 0, 0))