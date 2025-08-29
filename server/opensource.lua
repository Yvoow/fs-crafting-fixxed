--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--
function getLocale(key)
    local localeTable = Locales[FS.Locale or 'en']
    if not localeTable then return 'locale not found for ' .. key end
    return localeTable[key] or 'locale not found for ' .. key
end