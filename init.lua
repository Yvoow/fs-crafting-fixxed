TARGET = nil
QBTARGET = nil
FM = nil
OXMYSQL = nil
Locales = {}


if GetResourceState('fmLib') == 'started' then
  FM = exports['fmLib']:new()
  FM.console.success('fmLib found for fs-crafting, initialized')
else
  error('\27[34m[fs-crafting]\27[31m fmLib not found, please make sure it is installed and started before this resource!')
end

if GetResourceState('ox_target') == 'started' then
  TARGET = exports['ox_target']
  FM.console.success('ox_target found for fs-crafting, initialized')
end

if GetResourceState('qb-target') == 'started' then
  QBTARGET = true
  FM.console.success('qb-target found for fs-crafting, initialized')
end

if GetResourceState('oxmysql') == 'started' then
  OXMYSQL = exports['oxmysql']
  FM.console.success('oxmysql found for fs-crafting, initialized')
else
  FM.console.error('oxmysql not found for fs-crafting, please make sure it is installed and started before this resource!')
end