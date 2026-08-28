```markdown
# corex-inventory (Redesign)

> Tetris-grid inventory for the [COREX Framework](https://github.com/ABUGIZA/COREX-Framework) — redesigned UI, bug fixes, stacking/merge/sort, portable owned vehicles, and shop integration.

**Maintainer fork:** [JackHH4/corex-inventory-Redesign](https://github.com/JackHH4/corex-inventory-Redesign)  
Built for survival / apocalypse RP servers (e.g. Lash Home RP style themes).

---

## Features

| Area | Description |
|------|-------------|
| **Grid inventory** | Slot-based (default **10×8**), weight limit, rarity labels |
| **Stack & merge** | Stackable items merge on pickup and when dragged together |
| **Sort & stack** | Toolbar **≡** merges stacks and sorts **largest item size → smallest** |
| **Search** | Filter items by name in the inventory toolbar |
| **Drops / ground** | Drop, pickup, nearby ground grid |
| **Weapons & ammo** | Weapon items, ammo packs, reload flow closer to ox_inventory style |
| **Shops** | Item shops + **vehicle** shops (`type = "vehicle"`) |
| **Portable vehicles** | Buy / own → spawn → **ox_target** pick up into inventory → use to deploy |
| **Bags** | Sub-inventory support for bag items |
| **Loot** | Loot containers with take / double-click style transfer |
| **Dynamic icons** | Icons from metadata (`iconMetadataKey` / filename patterns) |

---

## Changelog (Redesign / latest)

### Bug fixes
- **Stacking** — materials, ammo, food, medical and other `stackable = true` items merge correctly
- **Merging** — drag same-name stacks onto each other (server validates rules)
- **Sorting** — reliable **Sort & Stack**; layout pack no longer “random”
- **Auto-compact** — opening inventory merges split stacks automatically
- **maxStack nil errors** — safer stack math when other resources call `AddItem` (e.g. vehicle shop)
- **UI clutter** — removed non-functional favorite/star and lock controls; tighter grid gaps

### Systems
- **Portable owned vehicles** — pick up with **ox_target**, store as inventory item, deploy with **Use**
- **Vehicle metadata** — label, plate, owner shown clearly (unique items do not stack)
- **Vehicle shop flow** — purchase → spawn/register → portable pickup more stable
- **Weapon reload** — empty magazine does not force-unequip the weapon
- **Loot window** — take items without soft-locking the loot UI
- **Admin** — `/clearinv` to clear a player inventory (ACE / admin as configured)

> Unique items (weapons with serial, vehicles with plate/`uid`) **never stack** by design.

---

## Install

1. Drop the folder into your resources (name it `corex-inventory`):

```text
server-file/resources/[corex]/corex-inventory/
```

2. Install dependencies:

| Dependency | Notes |
|------------|--------|
| [ox_lib](https://github.com/overextended/ox_lib) | Required |
| [ox_target (COREX build)](https://github.com/iamxiann/ox_target) | Required for portable vehicle pickup |
| `corex-core` | COREX framework core |

> Public/default ox_target may **not** include the COREX adapter — portable pickup can fail with the wrong build.

3. Load order in `server.cfg`:

```cfg
ensure ox_lib
ensure corex-core
ensure ox_target
ensure corex-inventory
```

4. Restart the server or `ensure corex-inventory`.

### Update

Replace the resource folder with the latest files from this repo (or a release ZIP), then:

```cfg
ensure corex-inventory
```

Clear client cache if the NUI looks outdated.

---

## Quick usage

| Action | How |
|--------|-----|
| Open inventory | Default keybind / command from your server config (often Tab / F2 — do not conflict with GTA weapon wheel) |
| Sort & stack | Click **≡** in the inventory toolbar |
| Sort by name | **A–Z** button |
| Pack layout only | Grip / pack button |
| Pick up vehicle | Aim at **your** vehicle → ox_target → **Pick up vehicle** |
| Deploy vehicle | **Use** the `portable_vehicle` (or catalog item) in inventory |

---

## Portable vehicles (pick up → inventory → deploy)

Players can turn a deployed, **owned** vehicle from a COREX vehicle catalog into a single inventory item so it survives restarts and world wipes. Supports cars, bikes, scooters, helicopters, and any future catalog — not bicycle-only.

### Flow

1. Player buys a vehicle from a shop with `type = "vehicle"` backed by a COREX catalog.
2. After spawn, the client registers the networked vehicle; the server sets portable state bags.
3. Owner aims at the vehicle with **ox_target** → **Pick up vehicle**.
4. Vehicle is removed from the world; a **`portable_vehicle`** item is added with metadata: `owner`, `catalogId`, `plate`, `model`, `label`, `itemName`.
5. From inventory, **Use** deploys the vehicle in front of the player (auto-enter driver seat by default).

Pickup avoids the global “busy” lock where possible so a stuck `isBusy` does not block pickup; a short cooldown limits double-submit.

### Ownership & persistence

| Where | What is stored |
|--------|----------------|
| **Inventory item** | `metadata.owner`, `catalogId`, `model`, `plate`, `label` |
| **World entity** (while out) | State bags after registration (`corexPortableVehicleOwner`, etc.) |

If the item stays in the inventory, **ownership survives reconnect and restart**.

### Relevant files

| Area | File |
|------|------|
| Pickup / deploy / ox_target | `client/rental_bicycle.lua` (compat name; portable vehicle logic) |
| Shop spawn hooks / exports | `client/main.lua` |
| Purchase, finalize, pickup, deploy | `server/main.lua` |
| Item definition | `shared/items.lua` → `portable_vehicle` |
| Portable config | `config.lua` → `Config.PortableVehicles` |

### Server events (reference)

- `corex-inventory:server:finalizePortableVehicle` — attach ownership after spawn  
- `corex-inventory:server:pickupPortableVehicle` — validate owner, add item, delete entity  
- `corex-inventory:server:deployPortableVehicleFromItem` — validate metadata, remove item, deploy  

`rental_bicycle` remains a compatibility alias for the same system.

---

## Add a portable vehicle catalog

You do **not** need new pickup/deploy scripts per vehicle type. Add a catalog in `corex-core`, point a vehicle shop at it, and optionally set the inventory item name.

### 1. Catalog (`corex-core/shared/vehicles.lua`)

```lua
Corex.SharedVehicles["car_rental"] = {
    id = "car_rental",
    label = "Car Rental",
    subtitle = "BASIC CARS",
    currency = "cash",
    purchaseLabel = "Deploy Car",
    portable = true,                    -- ox_target pickup enabled
    inventoryItem = "portable_vehicle", -- optional; defaults from config
    vehicles = {
        {
            model = "blista",
            label = "Blista",
            category = "compact",
            price = 1200,
            description = "Small reliable city car.",
            portable = true             -- optional per-vehicle override
        },
        {
            model = "sanchez",
            label = "Sanchez",
            category = "bike",
            price = 900
        }
    }
}
```

### 2. Shop (`corex-inventory/shared/shops.lua`)

```lua
Shops["Car Rental"] = {
    label = "Car Rental",
    type = "vehicle",
    catalogId = "car_rental",
    npc = {
        model = "s_m_m_autoshop_02",
        coords = vector4(1518.0, 1708.0, 109.0, 90.0),
        scenario = "WORLD_HUMAN_CLIPBOARD",
        icon = "fa-car",
        interactLabel = "[E] Car Rental",
        interactDistance = 2.5
    },
    spawnPoint = vector4(1514.0, 1705.0, 109.0, 90.0),
    items = {}
}
```

### 3. Custom item (optional)

```lua
['rental_helicopter'] = {
    label = 'Helicopter',
    weight = 20.0,
    size = { w = 3, h = 3 },
    stackable = false,
    usable = true,
    image = 'default.png',
    iconMetadataKey = 'model',
    rarity = 'epic'
}
```

Set `inventoryItem = "rental_helicopter"` on the catalog or per vehicle.

### Rules

- `portable = true` on a catalog enables pickup for its vehicles  
- `portable = false` on a single vehicle blocks only that model  
- Vehicle `inventoryItem` overrides catalog `inventoryItem`  
- If unset, uses `Config.PortableVehicles.ItemName` (default `portable_vehicle`)  

---

## Stacking rules

In `shared/items.lua`:

```lua
stackable = true,   -- can merge
maxStack = 999999,  -- optional; high / unlimited style stacks supported
```

- **Stackable:** materials, ammo, food, bandages, etc.  
- **Non-stackable:** weapons, portable vehicles, anything with unique metadata (`serial`, `plate`, `uid`)

---

## Dynamic item icons (NUI)

Icons are resolved in `html/script.js` via `getItemImageSrc(item, itemDef)`.

```lua
['some_item'] = {
    label = 'Some item',
    image = 'default.png',
    iconMetadataKey = 'model',              -- read from item.metadata
    iconFilenamePattern = 'pack_%s.png',    -- optional; one "%s"
}
```

Fallback order: dynamic file → `image` → `images/<item_name>.png` → `default.png`.

---

## Exports (server examples)

Other resources can use inventory exports (names may vary slightly by build):

- `AddItem` / `RemoveItem`  
- `GetItemCount` / `HasItem`  
- `GetInventory`  

Always handle `stackable` / `maxStack` on the item definition to avoid nil stack errors.

---

## Docs & community

- Framework docs: [COREX Inventory (GitBook)](https://corex-zombies.gitbook.io/corex-docs/resources/systems/corex-inventory)  
- Discord: [https://discord.gg/G95rtnb9sg](https://discord.gg/G95rtnb9sg)

---

## License

Released under the [MIT License](LICENSE).

---

## Credits

- Original COREX inventory / framework authors  
- Redesign & fixes: [JackHH4](https://github.com/JackHH4) (this repository)
- Redesign : Xian https://github.com/iamxiann/corex-inventory-Redesign
```
