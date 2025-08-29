# Fusion Scripts Crafting System

This is a crafting system for FiveM that allows players to craft items using a workbench as an item or a prop placed in the world.

## Useful information
- Documentation: https://docs.fusionscripts.xyz/
- Discord/Support: https://discord.gg/fusionscripts
- Website: https://fusionscripts.xyz/

# Thanks for trusting us! We hope you enjoy our work!


### Installation

1. Download the latest release from the [Fivem Portal](https://portal.cfx.re/assets/granted-assets?page=1&sort=asset.updated_at&direction=asc).
2. Extract the files to your server.
3. Install the following dependencies if not already installed:
    - [fmLib](https://github.com/meesvrh/fmLib/releases)
4. Add the items to your inventory system defined in the [INSTALLATION] folder.
5. The following dependencies are optional:
    - Any target resource (qb, ox are pre-defined, define others in client/opensource.lua)
6. Make sure to follow the starting order of the resources below:


```bash
# 1. Start framework
ensure es_extended or qb-core or qbx_core

# 2. Start ox_lib (or any other textUI)
ensure ox_lib

# 3. Start fmLib (MUST be ensured below frameworks, inventories & other dependencies)
ensure fmLib

# 4. Start the script
ensure fs-crafting
```