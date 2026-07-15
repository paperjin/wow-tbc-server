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
- compose.yml - Podman compose file
- Dockerfile - Multi-stage build for mangosd

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

### IMPORTANT: Build inside the base image

The base image (thoriumlxc/cmangos-tbc:bots-2025.05.11) is **Ubuntu 24.04**.
The mangosd binary links against ICU, Boost, and other system libraries.
If you compile on a different distro (e.g. Fedora), the binary will link
against different library versions and will **NOT run** inside the container.

**Always use the multi-stage Docker build** to compile inside the Ubuntu base:

```
cd /home/albert/tbc-server
podman build --security-opt label=disable -t tbc-server:local -f Dockerfile .
```

This compiles mangosd inside the Ubuntu 24.04 base image, then copies the
binary into a clean runtime image. Library versions will match perfectly.

### Alternative: Manual build in Distrobox (Ubuntu)

If you need to iterate on patches quickly, use a Distrobox with Ubuntu 24.04:

```
distrobox create --name tbc-builder --image ubuntu:24.04
distrobox enter tbc-builder
sudo apt-get update && sudo apt-get install -y build-essential cmake git \
  libboost-dev libboost-system-dev libboost-filesystem-dev \
  libboost-program-options-dev libboost-thread-dev \
  libmariadb-dev libssl-dev zlib1g-dev libicu-dev
cd source
mkdir -p build && cd build
cmake ../mangos-tbc -DCMAKE_INSTALL_PREFIX=../install -DPCH=1 \
  -DBUILD_PLAYERBOTS=ON -DPLAYERBOTS_SOURCE_DIR=../playerbots -DDEBUG=0
make -j$(nproc) mangosd
```

### Apply patches before building

```
cd source
cd mangos-tbc
git apply ../../patches/002-core-selfbot-fixes.patch
git apply ../../patches/003-20x-bg-marks.patch
cd ../playerbots
git apply ../../patches/001-selfbot-bg-fixes.patch
git apply ../../patches/005-mount-interrupt-fix.patch
git apply ../../patches/006-playerbot-factory-infinite-loop.patch
git apply ../../patches/007-cloth-armor-fallback.patch
cd ..
```

## Deploy

```
cd /home/albert/tbc-server
podman compose up -d
```

## Data Transfer (from Proxmox)

```
# Maps/vmaps/mmaps (3.3GB)
ssh root@192.168.0.154 "tar czf - -C /srv/tbc-server/extracted-data ." | tar xzf - -C data/

# DB dump
ssh root@192.168.0.154 "docker exec tbc-db mariadb-dump -u root -pmangos --all-databases" > db_dump.sql
podman exec -i tbc-db mariadb -u root --password=mangos < db_dump.sql

# Configs
rsync -avz root@192.168.0.154:/srv/wow-tbc-server/etc/ etc/
```

## Environment

- Host: Steam Deck (Bazzite / Fedora Atomic)
- Container runtime: Podman 5.7 + podman-compose 1.6
- Base image: thoriumlxc/cmangos-tbc:bots-2025.05.11 (Ubuntu 24.04)
- DB: MariaDB 11
- Build toolchain: GCC, CMake, Boost 1.83 (inside Ubuntu 24.04 container)
