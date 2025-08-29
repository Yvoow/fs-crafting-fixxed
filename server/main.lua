--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--

workBenches = {}
lastChecks = {}

FM.callback.register('fs-crafting:getPlayerData', function(source, workbenchId)
  local src = source
  local plr = FM.player.get(src)
  if not plr then return end

  local workBench = workBenches[workbenchId]
  if not workBench then
    local tempWorkBench = nil
    for k, v in pairs(FS.Locations) do
      if v.name == workbenchId then
        tempWorkBench = v
        break
      end
    end
    if not tempWorkBench then return end
    workBench = tempWorkBench
  end
  
  local playerCoords = GetEntityCoords(GetPlayerPed(src))
  local distance = #(playerCoords - vector3(workBench.position.x, workBench.position.y, workBench.position.z))
  if distance > 4.0 then
    logToDiscord('**🚨 ANTICHEAT WARNING - GET PLAYER DATA**\n\n' ..
                 '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
                 '**Action:** Attempted to get player data from workbench\n' ..
                 '**Workbench:** ' .. workbenchId .. '\n' ..
                 '**Distance:** ' .. string.format("%.2f", distance) .. ' units (max: 4.0)\n' ..
                 '**Player Coords:** ' .. string.format("%.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z) .. '\n' ..
                 '**Workbench Coords:** ' .. string.format("%.2f, %.2f, %.2f", workBench.position.x, workBench.position.y, workBench.position.z), 'anticheat')
    return false
  end



  local experience = MySQL.query.await("SELECT * FROM fs_crafting WHERE user = @user", { user = plr.getIdentifier() })
  if experience[1] then
    experience = experience[1].experience
  else
    experience = 0
  end

  local pData = {}
  pData.name = plr.getFullName()
  pData.experience = experience
  pData.items = plr.getItems()

  local items = {}
  for k, v in pairs(FS.items) do
    if v.workBenches then
      for _, workBenchType in pairs(v.workBenches) do
        if workBenchType == workBench.type then
          table.insert(items, v)
        end
      end
    end
  end

  local tempLabel = nil
  for k,v in pairs(FS.interactables) do
    if v.item == workBench.type then
      tempLabel = v.label
      break
    end
  end

  if tempLabel then
    pData.label = tempLabel
  end


  return {
    playerData = pData,
    items = items,
  }
end)

FM.callback.register('fs-crafting:getWorkBenches', function(source)
  return workBenches
end)

FM.callback.register('fs-crafting:pickUpWorkBench', function(source, id)
  local src = source
  local plr = FM.player.get(src)
  if not plr then return end
  local workBench = workBenches[id]
  if not workBench then return false end

  local playerCoords = GetEntityCoords(GetPlayerPed(src))
  local distance = #(playerCoords - vector3(workBench.position.x, workBench.position.y, workBench.position.z))

  if distance > 4.0 then
    logToDiscord('**🚨 ANTICHEAT WARNING - PICKUP WORKBENCH**\n\n' ..
                 '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
                 '**Action:** Attempted to pickup workbench\n' ..
                 '**Workbench ID:** ' .. id .. '\n' ..
                 '**Distance:** ' .. string.format("%.2f", distance) .. ' units (max: 4.0)\n' ..
                 '**Player Coords:** ' .. string.format("%.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z) .. '\n' ..
                 '**Workbench Coords:** ' .. string.format("%.2f, %.2f, %.2f", workBench.position.x, workBench.position.y, workBench.position.z), 'anticheat')
    return false
  end
  plr.addItem(workBench.type, 1)
  workBenches[id] = nil
  TriggerClientEvent('fs-crafting:updateWorkBenches', -1, workBenches)
  logToDiscord('**📦 WORKBENCH PICKUP**\n\n' ..
               '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
               '**Action:** Successfully picked up workbench\n' ..
               '**Workbench ID:** ' .. id .. '\n' ..
               '**Workbench Type:** ' .. workBench.type .. '\n' ..
               '**Workbench Name:** ' .. workBench.name .. '\n' ..
               '**Location:** ' .. string.format("%.2f, %.2f, %.2f", workBench.position.x, workBench.position.y, workBench.position.z), 'crafting')
  return true
end)

FM.callback.register('fs-crafting:canCraft', function(source, workbenchId, item, amount)
  local src = source
  local plr = FM.player.get(src)
  if not plr then return false end

  local workBench = workBenches[workbenchId]
  if not workBench then
    local tempWorkBench = nil
    for k, v in pairs(FS.Locations) do
      if v.name == workbenchId then
        tempWorkBench = v
        break
      end
    end
    if not tempWorkBench then return false end
    workBench = tempWorkBench
  end

  local playerCoords = GetEntityCoords(GetPlayerPed(src))
  local distance = #(playerCoords - vector3(workBench.position.x, workBench.position.y, workBench.position.z))
  if distance > 4.0 then
    logToDiscord('**🚨 ANTICHEAT WARNING - CAN CRAFT CHECK**\n\n' ..
                 '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
                 '**Action:** Attempted to check if can craft item\n' ..
                 '**Workbench:** ' .. workbenchId .. '\n' ..
                 '**Item:** ' .. item.item .. ' (x' .. item.amount .. ')\n' ..
                 '**Distance:** ' .. string.format("%.2f", distance) .. ' units (max: 4.0)\n' ..
                 '**Player Coords:** ' .. string.format("%.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z) .. '\n' ..
                 '**Workbench Coords:** ' .. string.format("%.2f, %.2f, %.2f", workBench.position.x, workBench.position.y, workBench.position.z), 'anticheat')
    return false
  end


  local itemToCraft = nil
  for k, v in pairs(FS.items) do
    if v.item == item.item and v.amount == item.amount then
      itemToCraft = v
      break
    end
  end
  if not itemToCraft then return false end

  lastChecks[src] = {
    workbenchId = workbenchId,
    item = item,
    amount = amount,
    time = GetGameTimer() + 1000,
  }

  logToDiscord('**🔍 CRAFT CHECK REGISTERED**\n\n' ..
               '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
               '**Action:** Registered last check for crafting\n' ..
               '**Workbench:** ' .. workbenchId .. '\n' ..
               '**Item:** ' .. item.item .. ' (x' .. item.amount .. ')\n' ..
               '**Check Time:** ' .. (GetGameTimer() + 1000) .. '\n' ..
               '**Items Available:** ' .. #plr.getItems() .. ' total items', 'crafting')

  local hasAllItems = true

  for k, v in pairs(itemToCraft.neededItems) do
    if not plr.hasItemAmount(v.item, v.amount * amount) then
      hasAllItems = false
      break
    end
  end

  if not hasAllItems then return false end
  return true
end)

RegisterServerEvent('fs-crafting:craftingComplete', function(workbenchId, item, amount)
  local src = source
  local plr = FM.player.get(src)
  if not plr then return end

  local workBench = workBenches[workbenchId]
  if not workBench then
    local tempWorkBench = nil
    for k, v in pairs(FS.Locations) do
      if v.name == workbenchId then
        tempWorkBench = v
        break
      end
    end
    if not tempWorkBench then return end
    workBench = tempWorkBench
  end

  local playerCoords = GetEntityCoords(GetPlayerPed(src))
  local distance = #(playerCoords - vector3(workBench.position.x, workBench.position.y, workBench.position.z))
  if distance > 4.0 then
    logToDiscord('**🚨 ANTICHEAT WARNING - CRAFTING COMPLETE**\n\n' ..
                 '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
                 '**Action:** Attempted to complete crafting\n' ..
                 '**Workbench:** ' .. workbenchId .. '\n' ..
                 '**Item:** ' .. item.item .. ' (x' .. item.amount .. ')\n' ..
                 '**Distance:** ' .. string.format("%.2f", distance) .. ' units (max: 4.0)\n' ..
                 '**Player Coords:** ' .. string.format("%.2f, %.2f, %.2f", playerCoords.x, playerCoords.y, playerCoords.z) .. '\n' ..
                 '**Workbench Coords:** ' .. string.format("%.2f, %.2f, %.2f", workBench.position.x, workBench.position.y, workBench.position.z), 'anticheat')
    return
  end

  local check = lastChecks[src]
  if not check then
    logToDiscord('**🚨 ANTICHEAT WARNING - NO LAST CHECK**\n\n' ..
                 '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
                 '**Action:** Attempted to complete crafting without last check\n' ..
                 '**Workbench:** ' .. workbenchId .. '\n' ..
                 '**Item:** ' .. item.item .. ' (x' .. item.amount .. ')\n' ..
                 '**Status:** No last check found in memory\n' ..
                 '**Possible Exploit:** Player may have bypassed canCraft check', 'anticheat')
    return
  end

  if check.workbenchId ~= workbenchId or check.item.item ~= item.item or check.item.amount ~= item.amount or check.amount ~= amount then
    logToDiscord('**🚨 ANTICHEAT WARNING - CHECK MISMATCH**\n\n' ..
                 '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
                 '**Action:** Attempted to complete crafting with mismatched data\n' ..
                 '**Expected Workbench:** ' .. (check.workbenchId or 'nil') .. '\n' ..
                 '**Actual Workbench:** ' .. workbenchId .. '\n' ..
                 '**Expected Item:** ' .. (check.item.item or 'nil') .. ' (x' .. (check.item.amount or 0) .. ')\n' ..
                 '**Actual Item:** ' .. item.item .. ' (x' .. item.amount .. ')\n' ..
                 '**Expected Amount:** ' .. (check.amount or 0) .. '\n' ..
                 '**Actual Amount:** ' .. amount .. '\n' ..
                 '**Possible Exploit:** Player may have tampered with crafting data', 'anticheat')
    return
  end

  lastChecks[src] = nil

  local itemToCraft = nil
  for k, v in pairs(FS.items) do
    if v.item == item.item and v.amount == item.amount then
      itemToCraft = v
      break
    end
  end
  if not itemToCraft then return end


  for k, v in pairs(itemToCraft.neededItems) do
    if v.remove then
      plr.removeItem(v.item, v.amount * amount)
    end
  end
  plr.addItem(itemToCraft.item, itemToCraft.amount * amount)
  
  local experience = itemToCraft.experience.reward
  experience = experience * amount

  local row = MySQL.query.await("SELECT * FROM fs_crafting WHERE user = @user", { user = plr.getIdentifier() })
  if row[1] then
    local playerExperience = row[1].experience + experience
    MySQL.update("UPDATE fs_crafting SET experience = @experience WHERE user = @user", {
      experience = playerExperience,
      user = plr.getIdentifier()
    })
  else
    MySQL.insert("INSERT INTO fs_crafting (user, experience) VALUES (@user, @experience)", {
      user = plr.getIdentifier(),
      experience = experience
    })
  end
  
  -- Create detailed needed items table
  local neededItemsTable = '\n```\n| Item | Amount | Removed |\n|------|--------|----------|\n'
  for k, v in pairs(itemToCraft.neededItems) do
    neededItemsTable = neededItemsTable .. '| ' .. v.item .. ' | ' .. v.amount .. ' | ' .. (v.remove and 'Yes' or 'No') .. ' |\n'
  end
  neededItemsTable = neededItemsTable .. '```\n'
  
  logToDiscord('**🎯 CRAFTING COMPLETE**\n\n' ..
               '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
               '**Action:** Successfully completed crafting\n' ..
               '**Workbench:** ' .. workbenchId .. '\n' ..
               '**Crafted Item:** ' .. itemToCraft.item .. ' (x' .. itemToCraft.amount * amount .. ')\n' ..
               '**Experience Gained:** ' .. experience .. ' XP\n' ..
               '**Required Items:** ' .. neededItemsTable ..
               '**Total Items Used:** ' .. #itemToCraft.neededItems .. '\n' ..
               '**Location:** ' .. string.format("%.2f, %.2f, %.2f", workBench.position.x, workBench.position.y, workBench.position.z) .. '\n' ..
               '**Time:** ' .. os.date('%d/%m/%Y %H:%M:%S'), 'crafting')
end)

CreateThread(function()
  for k, v in pairs(FS.interactables) do
    FM.inventory.registerUsableItem(v.item, function(source, item)
      local src = source
      local plr = FM.player.get(src)

      if plr.hasItemAmount(item, 1) then
        plr.removeItem(item, 1)

        local ped = GetPlayerPed(src)
        local playerCoords = GetEntityCoords(ped)
        local playerHeading = GetEntityHeading(ped)

        local forwardOffset = 1.0
        local rad = math.rad(playerHeading)

        local forwardCoords = vector3(
          playerCoords.x - math.sin(rad) * forwardOffset,
          playerCoords.y + math.cos(rad) * forwardOffset - 0.5,
          playerCoords.z - 1.0
        )
        

        local calcHeading = playerHeading
        if v.headingOffset then
          calcHeading = playerHeading + v.headingOffset
        end

        local id = generateUniqueId()
        local workBench = {
          id = id,
          type = item,
          name = v.label,
          prop = v.prop,
          position = {
            x = forwardCoords.x,
            y = forwardCoords.y,
            z = forwardCoords.z,
          },
          heading = calcHeading,
        }
        workBenches[id] = workBench
        TriggerClientEvent('fs-crafting:workBenchUsed', src, workBench)
        Wait(3000)
        TriggerClientEvent('fs-crafting:updateWorkBenches', -1, workBenches)
        logToDiscord('**🔧 WORKBENCH PLACED**\n\n' ..
                     '**Player:** ' .. plr.getFullName() .. ' (' .. plr.getIdentifier() .. ')\n' ..
                     '**Action:** Placed workbench\n' ..
                     '**Workbench ID:** ' .. id .. '\n' ..
                     '**Workbench Type:** ' .. item .. '\n' ..
                     '**Workbench Name:** ' .. v.label .. '\n' ..
                     '**Prop:** ' .. v.prop .. '\n' ..
                     '**Position:** ' .. string.format("%.2f, %.2f, %.2f", forwardCoords.x, forwardCoords.y, forwardCoords.z) .. '\n' ..
                     '**Heading:** ' .. string.format("%.2f", calcHeading) .. '\n' ..
                     '**Time:** ' .. os.date('%d/%m/%Y %H:%M:%S'), 'crafting')
      end
    end)
  end
end)