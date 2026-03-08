local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

print("AutoFarm iniciado")

while true do
    task.wait(1)

    for _,coin in pairs(workspace:GetDescendants()) do
        if coin.Name == "Coin" then
            char:MoveTo(coin.Position)
        end
    end
end
