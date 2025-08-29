--[[                                                                         
  📜 fs-crafting - Fusion Scripts
  🔗 fusionscripts.xyz | 💬 discord.gg/fusionscripts                                                             
]]--

FS = {}

FS.Locale = 'en'

FS.ui = {
  colors = {
    primary = '#FF8563',
    secondary = '#2B89EF',
    background = '#111111',
    blocks = '#161616',
    blocks2 = '#333333',
    primaryText = '#FFFFFF',
    secondaryText = '#777777',
  }
}

FS.imageDir = 'ox_inventory/web/images/'

FS.interactables = {
  {
    item = 'workbench',
    prop = 'prop_tool_bench02',
    label = 'Workbench',
    headingOffset = -85.0,
  },
  {
    item = 'advanced_workbench',
    prop = 'xs_prop_x18_tool_draw_01x',
    label = 'Advanced Workbench',
  },
}

FS.Locations = {
  {
    name = 'Advanced Workbench',
    type = 'advanced_workbench',
    position = {
      x = 120.4556,
      y = -1593.7780,
      z = 28.5917,
    },
    heading = 335.0,
  },
  {
    name = 'Workbench',
    type = 'workbench',
    prop = 'prop_tool_bench02',
    position = {
      x = 121.5778,
      y = -1606.3876,
      z = 28.2955,
    },
    heading = 150.0,
  },
}

FS.items = {
  {
    title = 'Advanced workbench',
    item = 'advanced_workbench',
    amount = 1,
    duration = 60000,
    experience = {
      needed = 800,
      reward = 150,
    },
    neededItems = {
      { item = 'metal_scrap', amount = 10, remove = true },
      { item = 'plastic', amount = 10, remove = true },
      { item = 'steel', amount = 10, remove = true },
      { item = 'aluminum', amount = 1, remove = true },
    },
    workBenches = {
      'workbench',
    }
  },
  {
    title = 'Fix kit',
    item = 'fixkit',
    amount = 1,
    duration = 60000,
    experience = {
      needed = 0,
      reward = 50,
    },
    neededItems = {
      { item = 'metal_scrap', amount = 5, remove = true },
      { item = 'plastic', amount = 2, remove = true },
      { item = 'steel', amount = 1, remove = true },
    },
    workBenches = {
      'workbench',
      'advanced_workbench',
    }
  },
  {
    title = 'Armour',
    item = 'armour',
    amount = 1,
    duration = 10000,
    experience = {
      needed = 0,
      reward = 30,
    },
    neededItems = {
      { item = 'metal_scrap', amount = 10, remove = true },
      { item = 'plastic', amount = 10, remove = true },
      { item = 'steel', amount = 10, remove = true },
      { item = 'aluminum', amount = 1, remove = true },
    },
    workBenches = {
      'workbench',
      'advanced_workbench',
    }
  },
  {
    title = 'Lockpick',
    item = 'lockpick',
    amount = 1,
    duration = 5000,
    experience = {
      needed = 50,
      reward = 20,
    },
    neededItems = {
      { item = 'metal_scrap', amount = 4, remove = true },
      { item = 'steel', amount = 3, remove = true },
    },
    workBenches = {
      'workbench',
      'advanced_workbench',
    }
  },
}