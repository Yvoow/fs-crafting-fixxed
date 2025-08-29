--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--
CreateThread(function()
  CreateSQLIfNotExists()
end)

function CreateSQLIfNotExists(name)
  local creates = {
    fs_crafting = [[
      CREATE TABLE IF NOT EXISTS fs_crafting (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `user` varchar(255) NOT NULL,
        `experience` int(11) NOT NULL,
        PRIMARY KEY (`id`)
      )
    ]]
  }

  for tableName, createQuery in pairs(creates) do
    local result = MySQL.query.await(
      "SELECT COUNT(*) as count FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = @name",
      { name = tableName }
    )
    if result[1].count == 0 then
      MySQL.query.await(createQuery)
      FM.console.success('Created table ' .. tableName)
    else
      FM.console.debug('Table ' .. tableName .. ' found')
    end
  end
end