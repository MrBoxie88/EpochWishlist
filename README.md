# EpochWishlist
A multi-list gear wishlist addon for **Project Epoch** (WoW 3.3.5 / WotLK client).

## Installation
1. Copy the `EpochWishlist` folder into:  
   `World of Warcraft/Interface/AddOns/`
2. Launch the game and enable the addon in the character selection screen.

## Features

### Wishlist
- **Multiple named lists** – create as many wishlists as you want (BiS list, alt gear, PvP set, etc.)
- **Add items** by pasting an item link (shift-click an item in-game) or typing a numeric item ID
- **Left-click a row** to mark an item as obtained — icon dims and a green checkmark appears
- **Progress bar** – shows how many items you've obtained out of your total list at a glance
- **Priority system** – right-click any item to assign a priority from P1 (Low) to P5 (Prio), shown as a coloured badge on the row
- **Sort & filter** – sort by Priority, Slot, or Obtained status, or restore Manual drag order; toggle Hide Obtained to focus on what you still need
- **Notes** on each item – right-click a row and choose Add/Edit Note
- **Drag-to-reorder** items within a list (left-drag a row up or down)
- **Drop source & chance** – items with known drop data show the boss, zone, and drop chance (supports values as low as 0.02%)

### Search Drops
- **Browse loot by zone** – dropdown organised into Raids, Dungeons, and Sets & Collections
- **Click an icon** to add it directly to your active wishlist; a green checkmark appears on items already in your list
- **Zones covered:** Onyxia's Lair, Blackwing Lair, all vanilla dungeons including Glittermurk Mines and Baradin Hold
- **Sets & Collections:** Tier 0, Tier 0.5, Tier 1, Rune Warder Set, BoE World Drops, and all Epoch PvP/class sets

### Sharing
- **Export / Import** – export a list as text to share with guildmates; import a list someone sent you
- **Loot Council export** – one-click copy of your list sorted by priority with obtained status, ready to paste into Discord
- **Send via addon message** – send your list directly to another player in-game

### Quality of Life
- **Auto item fetch** – items load their name, icon, and quality automatically as you scroll over them
- **Minimap button** – click to toggle the window; right-drag to reposition it around the minimap ring
- **Resizable window** – drag the bottom-right corner grip to resize
- **Saved per character** via `SavedVariables`

## Slash Commands
| Command | Description |
|---|---|
| `/ew` or `/ew show` | Toggle the wishlist window |
| `/ew new <name>` | Create a new list |
| `/ew del <name>` | Delete a list |
| `/ew list` | Print all list names to chat |
| `/ew share [name]` | Print list contents to chat |
| `/ew help` | Show all commands |

Also: `/epochwishlist` and `/wishlist` work as aliases.

## Usage Tips
- **Adding items**: Focus the Add bar and shift-click any item in your bags, tooltip, or vendor window — the link pastes automatically. Press Enter or click **Add**.
- **Marking obtained**: Left-click any row to toggle it obtained/needed. Obtained items are dimmed with a checkmark.
- **Setting priority**: Right-click a row to set P1–P5 priority, then use **Sort → Priority** to float your most-wanted items to the top.
- **Hiding obtained**: Click **Hide Obtained** in the sort bar to temporarily remove obtained items from view.
- **Loot council**: Click **Council** in the toolbar to prepare a formatted summary — press Ctrl+C to copy and paste into Discord.
- **Notes**: Right-click a row and choose Add Note / Edit Note.
- **Reordering**: Left-click-drag a row up or down, or use Move to Top / Move to Bottom in the right-click menu.

## Adding a New Zone
Everything lives in `EpochWishlist_Items.lua` — you never need to touch `EpochWishlist.lua` for data changes.

Add a `zone()` call with a **type tag** as the third argument:

```lua
-- Raid (default if omitted)
zone("Molten Core", {
    boss("Ragnaros", {
        item(17204, "Eye of Sulfuras"),
    }),
}, "raid")

-- Dungeon
zone("Dire Maul East", {
    boss("Zevrim Thornhoof", {
        item(18389, "Satyr's Bow", 14.5),
    }),
}, "dungeon")

-- Sets & Collections
zone("My Custom Set", {
    boss("Set Pieces", {
        item(12345, "Cool Helm"),
    }),
}, "set")
```

The zone will automatically appear in the correct section of the Search Drops browser (Raids / Dungeons / Sets & Collections).

## File Structure
```
EpochWishlist/
├── EpochWishlist.toc        -- Addon metadata (Interface: 30300)
├── EpochWishlist.lua        -- All logic and UI
├── EpochWishlist_Items.lua  -- Loot table data (zones, bosses, items)
└── README.md
```
