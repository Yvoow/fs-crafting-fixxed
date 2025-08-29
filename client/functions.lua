--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--

function openNui(workbenchId)
    if clientVars.isCrafting then return end
    FM.callback.async('fs-crafting:getPlayerData', function(data)
        SendNUIMessage({
            type = 'open',
            workbenchId = workbenchId,
            pData = data.playerData,
            items = data.items,
        })
        SetNuiFocus(true, true)
    end, workbenchId)
end

function closeNui()
    SendNUIMessage({
      type = 'close'
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('fetchLocales', function(data, cb)
    if not Locales or not Locales[FS.Locale] then
        print('Locales not found!')
        return
    end
  
    cb(Locales[FS.Locale])
end)
  
RegisterNUICallback('fetchConfig', function(data, cb)
    cb(FS)
end)

RegisterNUICallback('startCrafting', function(data, cb)
    local workbenchId = data.workbenchId
    local item = data.item
    local amount = data.amount

    closeNui()
    FM.callback.async('fs-crafting:canCraft', function(canCraft)
        if not canCraft then
            FM.utils.notify(getLocale('not_all_items'), 'error')
            return
        end
        clientVars.isCrafting = true

        local success = FM.progress.start({
            label = getLocale('crafting_item'),
            time = item.duration * amount,
            canCancel = false,
            type = 'linear',
            failedLabel = getLocale('crafting_item_failed'),
            completedLabel = getLocale('crafting_item_success'),
            anim = {
                dict = "mini@repair",
                anim = "fixing_a_ped",
                flag = 49,
            },
            disable = {
              move = true,
              car = true,
              combat = true,
              mouse = true,
            },
        })

        if success then
            TriggerServerEvent('fs-crafting:craftingComplete', workbenchId, item, amount)
        end
        clientVars.isCrafting = false
    end, workbenchId, item, amount)
end)