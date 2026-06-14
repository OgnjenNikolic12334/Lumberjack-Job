local isTextUiVisible = false
local inZoni = false
local cooldown = {}
local currentLocation = nil


CreateThread(function()
    while true do 
        inZoni = false
        local sleep = 1000 
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for i = 1, #Config.Drvece do 
            local tree = Config.Drvece[i]
            local distance = #(playerCoords - tree.kordinata)

            if distance < 6.0 then
                currentLocation = i
                inZoni = true
                sleep = 0
                local t = tree.kordinata
                DrawMyMarker(t.x, t.y, t.z)

                if distance < 4.0 then
                    ShowTextUI(Config.Drvo.label)

                    if IsControlJustReleased(0, 38) then 
                        local now = GetGameTimer()
                        if cooldown[currentLocation] and (now - cooldown[currentLocation]) < 750000 then
                            local cooldownRemaining = math.floor((750000 - (now - cooldown[currentLocation])) / 1000)
                            libNotify("Error", "Sacekaj jos: " .. cooldownRemaining .. " sekundi da stablo poraste", "error")
                        else
                            local inventoryExport = exports["tgiann-inventory"]:GetItemCount("weapon_battleaxe")

                            if inventoryExport < 1 then
                                libNotify("Error", "Treba ti Axe da bi posekao stablo.", "error")
                            else 
                                local currentAxe = exports["tgiann-inventory"]:GetCurrentWeapon()

                                if currentAxe and currentAxe.name == "weapon_battleaxe" then
                                    local miniGame = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'w', 'a', 's', 'd'})
                                    if miniGame then 
                                        local progres = lib.progressBar({
                                            duration = Config.Trajanje.milisekundi,
                                            label = Config.Progres.label,
                                            useWhileDead = false,
                                            canCancel = true,
                                            disable = {
                                                car = true,
                                                move = true,
                                                combat = true,
                                            },
                                            anim = {
                                                dict = "melee@hatchet@streamed_core",
                                                clip = "plyr_front_takedown"
                                            },
                                            prop = nil
                                        })  
                                        
                                        if progres then
                                            TriggerServerEvent("ZX-Lumberjack:progressFinished", i)
                                            cooldown[currentLocation] = now
                                        end
                                    end                                    
                                else
                                    libNotify("Error", "Moras drzati Axe u ruci.", "error")
                                end
                            end
                        end
                    end                             
                end
            end
        end

        hideTextUI()
        Wait(sleep)

    end
end)

function DrawMyMarker(x, y, z)
    DrawMarker(
        0,
        x, y, z,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        0.4, 0.4, 0.4,
        37, 99, 235, 150,
        false, true, 2, false, nil, nil, false
    )
end

function ShowTextUI(text)
    if not isTextUiVisible then
        isTextUiVisible = true
        lib.showTextUI(text)
    end
end        

function hideTextUI()
    if not inZoni and isTextUiVisible then
        lib.hideTextUI()
        isTextUiVisible = false
    end
end

function libNotify(title, description, type)
    lib.notify({
        title = title,
        description = description,
        type = type
    })  
end

RegisterNetEvent("ZX-Lumberjack:successNotify")
AddEventHandler("ZX-Lumberjack:successNotify", function()
    print("Notify")
    libNotify("success", "Posekao si drvo!", "success")
end)

for i = 1, #Config.Drvece do
    local blip = AddBlipForCoord(Config.Drvece[i].kordinata)

    SetBlipSprite(blip, 153) 
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.6)
    SetBlipColour(blip, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Tree")
    EndTextCommandSetBlipName(blip)
end
