if game.PlaceId ~= 8278412720 then return end

local PlayerScripts = game:GetService('Players').LocalPlayer:WaitForChild('PlayerScripts')
local ACScript = nil

local function notify(title, text)
	game:GetService('StarterGui'):SetCore('SendNotification', {
		Title = title,
		Text = text
	})
end

repeat
	wait()

	for _, v in pairs(PlayerScripts:GetChildren()) do
		if v:IsA('LocalScript') and tonumber(v.Name) then
			ACScript = v

			break
		end
	end
until ACScript ~= nil

local oldFunc; oldFunc = hookfunction(getsenv(ACScript).Trigger, function(...) end)

notify('AntiCheat Bypassed', 'AntiCheat has been successfully bypassed!')