# AGENTS.md — Hermes Agent Guide

This file documents the TBC WoW server for any Hermes agent (Llama, Bort, etc.) who needs to work with it. Read this first before making changes.

## Quick Facts

| Key | Value |
|-----|-------|
| **Host** | Steam Deck (Bazzite / Fedora Atomic) |
| **IP (Tailscale)** | `100.88.218.17` |
| **SSH user** | `albert` |
| **SSH password** | `kytana` |
| **Project root** | `/home/albert/tbc-server/` |
| **Container runtime** | Podman 5.7 (no Docker) |
| **Compose** | `podman compose` (via podman-compose 1.6) |
| **DB** | MariaDB 11, root password: `mangos` |
| **Base image** | `thoriumlxc/cmangos-tbc:bots-2025.05.11` (Ubuntu 24.04) |
| **Custom image** | `localhost/tbc-server:local` (multi-stage build) |
| **GitHub** | `https://github.com/paperjin/wow-tbc-server` |

## Project Layout

```
/home/albert/tbc-server/
├── source/
│   ├── mangos-tbc/          # Core server source (cmangos/mangos-tbc)
│   ├── playerbots/          # Playerbot module (cmangos/playerbots)
│   └── build/               # Build artifacts (inside distrobox)
├── patches/                 # All self-bot fixes (001-010)
├── etc/                     # Runtime configs (mounted into containers)
│   ├── mangosd.conf
│   ├── realmd.conf
│   └── aiplayerbot.conf
├── data/                    # Maps/vmaps/mmaps/dbc (3.3GB)
├── scripts/
│   └── build.sh             # Build script
├── compose.yml              # Podman compose file
├── Dockerfile               # Multi-stage build
└── README.md                # User-facing docs
```

## Containers

| Container | Image | Port | Purpose |
|-----------|-------|------|---------|
| `tbc-db` | `mariadb:11` | — | MariaDB (all game data) |
| `tbc-realmd` | `tbc-server:local` | 3724 | Login server |
| `tbc-mangosd` | `tbc-server:local` | 8085 | World server |

### Common Commands

```bash
# Start everything
cd /home/albert/tbc-server && podman compose up -d

# Stop everything
cd /home/albert/tbc-server && podman compose down

# Restart just world server (config changes)
cd /home/albert/tbc-server && podman compose restart mangosd

# View logs
podman logs tbc-mangosd
podman logs tbc-realmd
podman logs tbc-db

# Follow logs
podman logs -f tbc-mangosd

# Shell into DB
podman exec -it tbc-db mariadb -u root --password=mangos
```

## Database

All 13 databases from the old Proxmox server were migrated. Key ones:

| Database | Contents |
|----------|----------|
| `tbcrealmd` | Realm list, accounts, account access |
| `tbcmangos` | World data (creatures, items, quests, etc.) |
| `tbccharacters` | Characters, inventory, guilds, arena teams |
| `tbclogs` | Server logs |

### Useful Queries

```sql
-- Check online bots
SELECT COUNT(*) FROM tbccharacters.characters WHERE online = 1;

-- Check bot accounts
SELECT COUNT(*) FROM tbcrealmd.account WHERE username LIKE 'RNDBOT%';

-- Check realm address
SELECT id, name, address, port FROM tbcrealmd.realmlist;

-- Update realm address (for Tailscale)
UPDATE tbcrealmd.realmlist SET address = '100.88.218.17' WHERE id = 2;

-- Check bot gear (items equipped)
SELECT c.name, c.level, COUNT(ci.guid) AS items
FROM tbccharacters.characters c
JOIN tbccharacters.character_inventory ci ON ci.guid = c.guid AND ci.bag = 0 AND ci.slot BETWEEN 0 AND 18
WHERE c.account IN (SELECT id FROM tbcrealmd.account WHERE username LIKE 'RNDBOT%')
GROUP BY c.guid
ORDER BY items DESC;
```

## Config Changes

Configs are in `/home/albert/tbc-server/etc/` and mounted into containers as volumes. After editing, restart mangosd:

```bash
cd /home/albert/tbc-server && podman compose restart mangosd
```

### Key aiplayerbot.conf Settings

| Setting | Default | What it does |
|---------|---------|-------------|
| `RandomBotLoginAtStartup` | 0 | Log bots in when server starts |
| `RandomBotAutoCreate` | 0 | Auto-create bot characters |
| `RandomBotTimedLogout` | 1 | Bots log out after session timer |
| `RandomBotRpgChance` | 0.05 | Chance bots do RPG/gossip instead of grind |
| `MinRandomBots` | 1600 | Min bots to maintain |
| `MaxRandomBots` | 2000 | Max bots allowed |
| `RandomBotAccountCount` | 400 | Number of bot accounts |
| `RandomBotJoinBG` | 1 | Bots join battlegrounds |
| `RandomBotAutoJoinBG` | 1 | Bots auto-queue for BGs |
| `RandomBotJoinLfg` | 1 | Bots join LFG |
| `RandomBotCountChangeMinInterval` | 1800 | Min seconds between bot count re-eval |
| `RandomBotCountChangeMaxInterval` | 7200 | Max seconds between bot count re-eval |

## Building

### Multi-stage Docker build (RECOMMENDED)

The base image is **Ubuntu 24.04**. The mangosd binary links against ICU, Boost, and other system libraries. **Always build inside the base image** — compiling on Fedora will produce a binary that won't run in the container.

```bash
cd /home/albert/tbc-server
podman build --security-opt label=disable -t tbc-server:local -f Dockerfile .
```

### Quick rebuild (after source changes)

The Dockerfile has two stages — builder and runtime. Only the builder stage recompiles; the runtime stage is cached. To force a clean rebuild:

```bash
podman build --security-opt label=disable --no-cache -t tbc-server:local -f Dockerfile .
```

### Manual build in Distrobox (for iterating patches)

```bash
distrobox enter tbc-builder
cd /home/albert/tbc-server/source/build
cmake ../mangos-tbc -DCMAKE_INSTALL_PREFIX=../install -DPCH=1 \
  -DBUILD_PLAYERBOTS=ON -DPLAYERBOTS_SOURCE_DIR=../playerbots -DDEBUG=0
make -j4 mangosd
```

## Patches

All 9 patches are in `/home/albert/tbc-server/patches/`. They must be applied to fresh source before building. The Dockerfile applies them automatically via the source copy.

| # | Patch | Applies to | What it does |
|---|-------|-----------|-------------|
| 001 | selfbot-bg-fixes | playerbots | Self-bots can queue BGs/arenas, use spirit healer |
| 002 | core-selfbot-fixes | mangos-tbc | Self-bots not kicked for AFK in BGs |
| 003 | 20x-bg-marks | mangos-tbc | 60 marks for winners, 20 for losers |
| 004 | eots-marks-db | DB (SQL) | EOTS marks via spell_template update |
| 005 | mount-interrupt-fix | playerbots | Self-bots skip mounting in BGs |
| 006 | factory-infinite-loop | playerbots | uint32 to int fix for equipment loop |
| 007 | cloth-armor-fallback | playerbots | Any class can wear cloth as fallback |
| 008 | rpg-flag-persistence | playerbots | User-removed RPG sub-flags (e.g. `-rpg quest`) persist across AI resets |
| 009 | arena2v2-support | playerbots | Self-bots can form 2v2 arena teams, queue, and fight |
| 010 | cmake-fetchcontent-fix | mangos-tbc | Replace FetchContent with direct add_subdirectory for playerbots module |

## SELinux on Bazzite

Bazzite has SELinux enforcing. All volume mounts in compose.yml use `:Z` flag for relabeling. All podman builds use `--security-opt label=disable`.

## Tailscale

The Deck is on Tailnet at `100.88.218.17`. The realm address in the DB is set to this IP so clients connect via Tailscale. No port forwarding needed.

## Memory

- **Deck storage**: 476GB NVMe, ~84GB free
- **DB dump**: 427MB
- **Maps data**: 3.3GB
- **Container images**: ~1.5GB total
- **Build artifacts**: ~1.1GB (can be cleaned)
- **Coredumps**: Check `/var/lib/systemd/coredump/` — clean up with `sudo rm -f /var/lib/systemd/coredump/*`
