--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--
function logToDiscord(message, type)
    local icon = 'https://media.discordapp.net/attachments/1325958447069532212/1383120607184552066/icon-fusion.png?ex=6879cd31&is=68787bb1&hm=0809f36f5d7f1b2da884bd956601a520d7ae29c930b6871435a5b0e5eee7a06c&=&format=webp&quality=lossless&width=447&height=544'
    local name = 'fs-crafting'
    local webhook = SVFS.Webhooks[type]
    local embed = {
      {
        ["color"] = 16748323,
        ["title"] = name,
        ["description"] = message,
        ["footer"] = {
          ["text"] = name .. ' - ' .. os.date('%d/%m/%Y %H:%M:%S'),
        },
      }
    }
  
    local payload = {
      username = name,
      avatar_url = icon,
      embeds = embed
    }
  
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode(payload), { ['Content-Type'] = 'application/json' })
end

function generateUniqueId()
  local id = math.random(1000000000, 9999999999)
  return 'fs-crafting-' .. id
end