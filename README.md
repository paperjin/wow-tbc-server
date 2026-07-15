# wow-tbc-server

CMaNGOS TBC WoW server with playerbots, running on Steam Deck via Podman.

## Project Structure

- source/mangos-tbc/ - Core server (cmangos/mangos-tbc)
- source/playerbots/ - Playerbot module (cmangos/playerbots)
- patches/ - All self-bot fixes as standalone patches
- configs/ - Server config files
- scripts/ - Build/deploy scripts
- data/ - Maps/vmaps/mmaps (extracted)
- etc/ - Runtime configs

## Patches

| # | Patch | File | What it does |
|---|-------|------|-------------|
| 001 | selfbot-bg-fixes | BattleGroundJoinAction.cpp, ReviveFromCorpseAction.cpp | Self-bots can queue BGs/arenas, use spirit healer |
| 002 | core-selfbot-fixes | Player.cpp | Self-bots not kicked for AFK in BGs |
| 003 | 20x-bg-marks | BattleGround.h | 60 marks for winners, 20 for losers |
| 004 | eots-marks-db | spell_template (SQL) | EOTS marks via DB update |
| 005 | mount-interrupt-fix | CheckMountStateAction.cpp | Self-bots skip mounting in BGs |
| 006 | factory-infinite-loop | PlayerbotFactory.cpp | uint32 to int fix for equipment loop |
| 007 | cloth-armor-fallback | PlayerbotFactory.cpp | Any class can wear cloth as fallback |

## Build



## Deploy


