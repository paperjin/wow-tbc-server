# In-Game Commands Cheat Sheet

## .bot Commands (Playerbot)

Type these in-game with the `.bot` prefix. Works for self-bots (your alts) and random bots.

### Self-Bot Control

| Command | What it does |
|---------|-------------|
| `.bot add NAME` | Add a character as your self-bot |
| `.bot remove NAME` | Remove a self-bot |
| `.bot list` | List your self-bots |
| `.bot` | Toggle bot control UI |

### Movement & Follow

| Command | What it does |
|---------|-------------|
| `.bot follow` | Bots follow you |
| `.bot stay` | Bots stay in place |
| `.bot flee` | Bots run away |
| `.bot follow master` | Bots follow their assigned master |
| `.bot distance N` | Set follow distance (0-100) |

### Combat

| Command | What it does |
|---------|-------------|
| `.bot attack` | Bots attack your target |
| `.bot attack TARGET` | Bots attack named target |
| `.bot pull` | Bot pulls your target |
| `.bot pull TARGET` | Bot pulls named target |
| `.bot stop` | Bots stop attacking |
| `.bot spell NAME` | Bot casts named spell on your target |
| `.bot heal` | Bot heals you |
| `.bot heal TARGET` | Bot heals named target |

### Equipment & Inventory

| Command | What it does |
|---------|-------------|
| `.bot equip` | Bot equips best gear from inventory |
| `.bot inventory` | Show bot's inventory |
| `.bot trade` | Open trade with bot |
| `.bot give ITEM` | Bot gives you an item |
| `.bot use ITEM` | Bot uses an item |

### Roles & Specs

| Command | What it does |
|---------|-------------|
| `.bot tank` | Bot acts as tank |
| `.bot dps` | Bot acts as DPS |
| `.bot heal` | Bot acts as healer |
| `.bot role` | Show bot's current role |
| `.bot spec` | Show bot's talent spec |

### Misc

| Command | What it does |
|---------|-------------|
| `.bot do NAME` | Bot does a command (e.g. `.bot do mount`) |
| `.bot cast NAME` | Bot casts a spell |
| `.bot mount` | Bot mounts up |
| `.bot dismount` | Bot dismounts |
| `.bot home` | Bot returns to home |
| `.bot taxi` | Bot uses flight path |
| `.bot revive` | Bot resurrects |
| `.bot repair` | Bot repairs gear |
| `.bot sell` | Bot sells grey items |
| `.bot train` | Bot trains skills |
| `.bot quest` | Show bot's quest log |
| `.bot stats` | Show bot's stats |
| `.bot talents` | Show bot's talents |

## GM Commands (Mangos)

Require GM level on your account.

### Character

| Command | What it does |
|---------|-------------|
| `.gm on/off` | Toggle GM mode |
| `.gm fly on/off` | Toggle flight |
| `.gm visible on/off` | Toggle invisibility |
| `.levelup N` | Level up N times |
| `.learn SKILL` | Learn a spell/skill |
| `.unlearn SKILL` | Unlearn a spell/skill |
| `.reset talents` | Reset talents |
| `.reset spells` | Reset spells |
| `.modify money AMOUNT` | Give/take money |
| `.modify speed RATE` | Set movement speed (0.1-10) |
| `.modify scale RATE` | Set character scale |
| `.modify hp N` | Set health |
| `.modify mana N` | Set mana |
| `.modify rage N` | Set rage |
| `.modify energy N` | Set energy |
| `.modify level N` | Set level |
| `.modify rep FACTION AMOUNT` | Set reputation |
| `.modify talentpoints N` | Set talent points |

### Teleport

| Command | What it does |
|---------|-------------|
| `.tele NAME` | Teleport to named location |
| `.tele list` | List available teleport locations |
| `.go x y z map` | Teleport to coordinates |
| `.go creature GUID` | Teleport to creature |
| `.go object GUID` | Teleport to game object |
| `.go zonexy ZONEID x y` | Teleport to zone coordinates |
| `.summon PLAYER` | Summon player to you |
| `.appear PLAYER` | Teleport to player |

### NPC & Creature

| Command | What it does |
|---------|-------------|
| `.npc add ID` | Spawn creature by entry ID |
| `.npc delete` | Delete targeted NPC |
| `.npc info` | Show NPC info |
| `.npc move` | Set NPC position |
| `.npc spawntime SECONDS` | Set respawn time |
| `.npc faction FACTIONID` | Set NPC faction |
| `.npc level N` | Set NPC level |
| `.npc name NAME` | Set NPC name |
| `.npc subname NAME` | Set NPC subname |
| `.npc flag FLAGS` | Set NPC flags |
| `.npc addmove` | Add waypoint |
| `.npc setphase PHASE` | Set NPC phase |

### Items

| Command | What it does |
|---------|-------------|
| `.additem ID` | Add item to inventory |
| `.additemset ID` | Add item set |
| `.lookup item NAME` | Search for item by name |
| `.lookup spell NAME` | Search for spell by name |
| `.lookup quest NAME` | Search for quest by name |
| `.lookup creature NAME` | Search for creature by name |
| `.lookup object NAME` | Search for game object by name |
| `.lookup faction NAME` | Search for faction by name |
| `.lookup skill NAME` | Search for skill by name |
| `.lookup tele NAME` | Search for teleport location |

### Battleground

| Command | What it does |
|---------|-------------|
| `.debug bg` | Toggle battleground debug |
| `.battleground start` | Force start battleground |
| `.battleground stop` | Force end battleground |
| `.battleground join ID` | Join specific battleground |

### Server

| Command | What it does |
|---------|-------------|
| `.server info` | Server info |
| `.server motd` | Show message of the day |
| `.server corpses` | Show corpse count |
| `.server exit` | Shutdown server |
| `.server restart SECONDS` | Restart server in N seconds |
| `.server idlerestart SECONDS` | Restart when idle |
| `.server set motd TEXT` | Set message of the day |
| `.server plimit LIMIT` | Set player limit |
| `.account` | Show account info |
| `.account create USER PASS` | Create account |
| `.account set gmlevel USER LEVEL REALM` | Set GM level (0-3) |
| `.ban account USER TIME` | Ban account |
| `.ban character NAME TIME` | Ban character |
| `.ban ip IP TIME` | Ban IP |
| `.unban account USER` | Unban account |
| `.unban character NAME` | Unban character |
| `.unban ip IP` | Unban IP |
| `.kick NAME` | Kick player |
| `.mute NAME TIME` | Mute player |
| `.unmute NAME` | Unmute player |
| `.announce TEXT` | Broadcast message |
| `.notify TEXT` | Send notification |
| `.nameannounce TEXT` | Name-colored broadcast |
| `.whisper NAME TEXT` | Whisper as server |
| `.channel set ownership OFF` | Disable channel ownership |
| `.wchange WEATHER` | Change weather (0=fine, 1=rain, 2=snow, 3=sand) |
| `.debug play sound SOUNDID` | Play sound effect |
| `.debug play cinematic CINID` | Play cinematic |
| `.debug play movie MOVIEID` | Play movie |
| `.debug anim NPCID` | Play NPC animation |
| `.debug entervehicle VEHICLEID` | Enter vehicle |
| `.debug leavevehicle` | Leave vehicle |
