print("ZX-Lumberjack by ZX Scripts Discord: https://discord.gg/akkgn8crZy")
local cooldown = {}

RegisterNetEvent("ZX-Lumberjack:progressFinished")
AddEventHandler("ZX-Lumberjack:progressFinished", function(i)
    local tree = Config.Drvece[i]

    if not tree then
        return
    end

    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = #(playerCoords - Config.Drvece[i].kordinata)
    
    if distance > 7.0 then
        return
    end

    local now = GetGameTimer()
    local src = source

    if not cooldown[src] then
        cooldown[src] = {}
    end

    if cooldown[src][i] and (now - cooldown[src][i]) < 750000 then
        return
    end    
    
    exports["tgiann-inventory"]:AddItem(src, Config.TreeItem.item, Config.TreeItem.kolicina)

    print("Error")
    cooldown[src][i] = now

    TriggerClientEvent("ZX-Lumberjack:successNotify", src)

end)