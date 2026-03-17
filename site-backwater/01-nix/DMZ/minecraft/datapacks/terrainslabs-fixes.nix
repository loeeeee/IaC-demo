{ pkgs, ... }:

pkgs.runCommand "terrainslabs-fixes-datapack" { } ''
  mkdir -p "$out/data/terrainslabs/loot_table/blocks"

  cat > "$out/pack.mcmeta" << 'EOF'
  {
    "pack": {
      "pack_format": 48,
      "description": "Fixes TerrainSlabs gravel_slab loot table unreachable entry."
    }
  }
  EOF

  cat > "$out/data/terrainslabs/loot_table/blocks/gravel_slab.json" << 'EOF'
  {
    "type": "minecraft:block",
    "pools": [
      {
        "rolls": 1,
        "entries": [
          {
            "type": "minecraft:item",
            "name": "terrainslabs:gravel_slab"
          }
        ]
      }
    ]
  }
  EOF
''

