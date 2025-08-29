--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--
clientVars = {}
clientVars.props = {}
clientVars.flyingTargets = {}

Citizen.CreateThread(function()
  FM.callback.async('fs-crafting:getWorkBenches', function(data)
    clientVars.workBenches = data
    for k, v in pairs(clientVars.props) do
      DeleteObject(v)
      clientVars.props[k] = nil
    end
  end)
end)

RegisterNetEvent('fs-crafting:updateWorkBenches', function(workBenches)
  clientVars.workBenches = workBenches
  for k, v in pairs(clientVars.props) do
    DeleteObject(v)
    clientVars.props[k] = nil
  end
end)

RegisterNetEvent('fs-crafting:workBenchUsed', function(workBench)
  local success = FM.progress.start({
    label = getLocale('progress_label'),
    time = 3000,
    canCancel = false,
    type = 'linear',
    failedLabel = getLocale('progress_failed'),
    completedLabel = getLocale('progress_success'),
    anim = {
      dict = "amb@world_human_gardener_plant@male@base",
      anim = "base",
      flag = 49,
    },
    disable = {
      move = true,
      car = true,
      combat = true,
      mouse = true,
    },
  })
end)

Citizen.CreateThread(function()
  while true do
      Wait(0)
      local playerCoords = GetEntityCoords(PlayerPedId())
      local nearby = false
      -- Dynamisch geplaatste werkbanken
      if clientVars.workBenches then
          for k, v in pairs(clientVars.workBenches) do
              local coords = vector3(v.position.x, v.position.y, v.position.z)
              local distance = #(playerCoords - coords)

              if distance < 50.0 then
                  if not clientVars.props[v.id] then
                      local propHash = GetHashKey(v.prop)
                      RequestModel(propHash)
                      while not HasModelLoaded(propHash) do
                          Wait(50)
                      end

                      local prop = CreateObject(propHash, coords.x, coords.y, coords.z, false, true, false)
                      SetEntityHeading(prop, v.heading)
                      FreezeEntityPosition(prop, true)
                      SetEntityInvincible(prop, true)
                      SetEntityCollision(prop, true, false)
                      clientVars.props[v.id] = prop

                      if TARGET or QBTARGET then
                        local opts = {
                          label = v.name,
                          icon = 'fas fa-hand',
                          name = 'fs-crafting:useWorkBench',
                          distance = 2.0,
                          onSelect = function()
                            openNui(v.id)
                          end
                        }

                        addTarget(prop, opts)

                        opts.label = getLocale('pick_up')
                        opts.name = 'fs-crafting:pickUpWorkBench'
                        opts.distance = 2.0
                        opts.onSelect = function()
                          local success = FM.progress.start({
                            label = getLocale('picking_up_workbench'),
                            time = 1500,
                            canCancel = false,
                            type = 'linear',
                            failedLabel = getLocale('picking_up_workbench_failed'),
                            completedLabel = getLocale('picking_up_workbench_success'),
                            anim = {
                              dict = "amb@world_human_gardener_plant@male@base",
                              anim = "base",
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
                            FM.callback.async('fs-crafting:pickUpWorkBench', function(success)
                              if success then
                                closeNui()
                              end
                            end, v.id)
                          end
                        end
                        addTarget(prop, opts)
                      end
                  end
                  
                  if not TARGET and not QBTARGET and distance < 3.0 then
                    nearby = true
                    FM.utils.showTextUI('[E] Use workbench \n\n[K] Pick up workbench')
                    if IsControlJustPressed(0, 38) then -- E
                      openNui(v.id)
                    end
                    if IsControlJustPressed(0, 311) then -- K
                      local success = FM.progress.start({
                        label = getLocale('picking_up_workbench'),
                        time = 1500,
                        canCancel = false,
                        type = 'linear',
                        failedLabel = getLocale('picking_up_workbench_failed'),
                        completedLabel = getLocale('picking_up_workbench_success'),
                        anim = {
                          dict = "amb@world_human_gardener_plant@male@base",
                          anim = "base",
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
                        FM.callback.async('fs-crafting:pickUpWorkBench', function(success)
                          if success then
                            closeNui()
                          end
                        end, v.id)
                      end
                    end
                  end
              else
                  if clientVars.props[v.id] then
                      DeleteObject(clientVars.props[v.id])
                      clientVars.props[v.id] = nil
                  end
              end
          end
      end

      -- Vaste locaties
      if FS.Locations then
          for i, v in ipairs(FS.Locations) do
              local coords = vector3(v.position.x, v.position.y, v.position.z)
              local distance = #(playerCoords - coords)

              if distance < 50.0 then
                  if not clientVars.props[v.name] then
                    if v.prop then
                      local propHash = GetHashKey(v.prop)
                      RequestModel(propHash)
                      while not HasModelLoaded(propHash) do
                          Citizen.Wait(0)
                      end
                      local prop = CreateObject(propHash, coords.x, coords.y, coords.z, false, true, false)
                      SetEntityHeading(prop, v.heading)
                      FreezeEntityPosition(prop, true)
                      SetEntityInvincible(prop, true)
                      SetEntityCollision(prop, true, false)
                      clientVars.props[v.name] = prop

                      if TARGET or QBTARGET then
                        local opts = {
                          label = v.name,
                          icon = 'fas fa-hammer',
                          name = 'fs-crafting:useWorkBench',
                          distance = 2.0,
                          onSelect = function()
                            openNui(v.name)
                          end
                        }

                        local targetplaced = addTarget(prop, opts)
                        if targetplaced then
                          clientVars.flyingTargets[v.name] = targetplaced
                        end
                      end
                    else
                      if (TARGET or QBTARGET) and not clientVars.flyingTargets[v.name] then
                      local opts = {
                        label = v.name,
                        icon = 'fas fa-hammer',
                        name = 'fs-crafting:useWorkBench',
                        distance = 2.0,
                        onSelect = function()
                          openNui(v.name)
                        end
                        }
                        local targetplaced = addFlyingTarget(opts, v.position)
                        clientVars.flyingTargets[v.name] = targetplaced
                      end
                    end
                  end
                  if not TARGET and not QBTARGET and distance < 3.0 then
                    nearby = true
                    FM.utils.showTextUI(getLocale('use_workbench'))
                    if IsControlJustPressed(0, 38) then -- E
                      openNui(v.name)
                    end
                  end
              else
                if clientVars.flyingTargets[v.name] then
                  deleteFlyingTarget(clientVars.flyingTargets[v.name])
                  clientVars.flyingTargets[v.name] = nil
                end
                  if clientVars.props[v.name] then
                      DeleteObject(clientVars.props[v.name])
                      clientVars.props[v.name] = nil
                  end
              end
          end
      end
      if not nearby then
        Wait(1000)
        FM.utils.hideTextUI()
      end
  end
end)
