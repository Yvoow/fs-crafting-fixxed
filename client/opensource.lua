--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--
function addTarget(entity, options)
    if TARGET then --ox-target
        TARGET:addLocalEntity(entity, {
        label = options.label or 'error',
        icon = options.icon or 'fas fa-exclamation-triangle',
        name = options.name or 'error',
        distance = options.distance or 2.0,
        onSelect = options.onSelect or function() end,
        })
    elseif QBTARGET then -- qb-target
        exports['qb-target']:AddTargetEntity(entity, {
        options = {
            {
            label = options.label or 'error',
            icon = options.icon or 'fas fa-exclamation-triangle',
            targeticon = options.targeticon or 'fas fa-exclamation-triangle',
            action = options.onSelect or function() end,
            }
        },
        distance = options.distance or 2.0,
        })
    end
end

function addFlyingTarget(options, coords)
    if TARGET then
        local sphere = TARGET:addSphereZone({
            coords = coords,
            radius = options.radius or 2.0,
            options = {
                { 
                    label = options.label or 'error',
                    icon = options.icon or 'fas fa-exclamation-triangle',
                    name = options.name or 'error',
                    onSelect = options.onSelect or function() end,
                }
            }
        })
        return sphere
    elseif QBTARGET then
        local sphere = exports['qb-target']:AddCircleZone(options.name or 'error', coords, options.radius or 2.0, {
            name = options.name or 'error',
        }, {
            options = {
                {
                    type = 'client',
                    label = options.label or 'error',
                    targeticon = options.icon or 'fas fa-exclamation-triangle',
                    name = options.name or 'error',
                    action = options.onSelect or function() end,
                }
            }
        })
        return options.name or 'error'
    end
end

function deleteFlyingTarget(target)
    if TARGET then
        TARGET:removeZone(target)
    elseif QBTARGET then
        exports['qb-target']:RemoveZone(target)
    end
end

function getLocale(key)
    local localeTable = Locales[FS.Locale or 'en']
    if not localeTable then return 'locale not found for ' .. key end
    return localeTable[key] or 'locale not found for ' .. key
end