{ config, pkgs, lib, ... }:

let
  # PurpurPacks datapacks - https://purpurmc.org/docs/purpurpacks/

  # Puts reinforced deepslate into the pickaxe minable tag, making breaking it much more bearable
  pickaxeEffectiveReinforcedDeepslate = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/kbuqezYO/versions/mcsl3iJd/purpurpacks-pickaxe-effective-reinforced-deepslate-3.5.jar";
    hash = "sha256-RLfsETnlDP6gFPcyQxsWx62UZEI5br97AaFHIIJ8Lhc=";
  };

  # Budding amethyst blocks now drop when mined with silk touch
  silkTouchBuddingAmethyst = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/7P6tQJuB/versions/PkQ0VK9E/purpurpacks-silk-touch-budding-amethyst-4.5.jar";
    hash = "sha256-0nsIY/aycdRcTDT5Arf9Merh91qFwM60m4bVbbMh09w=";
  };

  # Adds light source blocks like glowstone to the pickaxe mineable tag, allowing them to be broken faster
  pickaxeEffectiveLightSourceBlocks = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/ERLjKg7g/versions/yH7r8Sp9/purpurpacks-pickaxe-effective-light-source-blocks-3.5.jar";
    hash = "sha256-SNPIXt3Lc6MaFKJcFgEqqD4sDU8/I5oQMjekV+sV6VU=";
  };

  # Adds glass to the pickaxe minable tag, allowing it to be broken faster
  pickaxeEffectiveGlass = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/y87pO5HP/versions/IpiKLNzs/purpurpacks-pickaxe-effective-glass-3.5.jar";
    hash = "sha256-zvvmofIicvTRrEwRV9GZEVJWWWK5xntfChPUKxbxel8=";
  };

  # Allows upgrading diamond armor to netherite without the use of a netherite upgrade template
  noTemplateNetheriteArmorUpgrades = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/t5xqR0AK/versions/yGsh6Hyi/purpurpacks-no-template-netherite-armor-upgrades-4.5.jar";
    hash = "sha256-3sQYjw7VIRR5+e8bDoSEIp6LLWd/fIgam5Y5faAOwNU=";
  };

  # Allows most transparent blocks to be placed in the enchanting area without lowering the enchantment power
  transparentBlocksInEnchantArea = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/NhxPgV4c/versions/YjJBXuCP/purpurpacks-transparent-blocks-in-enchant-area-5.0.jar";
    hash = "sha256-Vy44mlovMPmSSXn8s1+DJOnxYF9DsoN0/pwy+Fz6rNA=";
  };

  # Allows dyeing any color of terracotta, not just plain
  reDyeTerracotta = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/lANiwxxT/versions/GAx0VNba/purpurpacks-re-dye-terracotta-4.5.jar";
    hash = "sha256-Zieq/YV1VHc23BkI93DqqtXeaDRqSPLu9fufAYWB2i4=";
  };

  # Allows all glass and glass pane colors to be dyed another color
  reDyeGlass = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/sbHA4Z4I/versions/TeT4looI/purpurpacks-re-dye-glass-4.5.jar";
    hash = "sha256-A3Tvc532jZ2arZSne7RpiMH9ymaqWWC55fR6QuuUeXM=";
  };

  # Adds froglights to the hoe mineable tag, allowing them to be mined faster
  hoeEffectiveFroglights = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/dpLYDTiH/versions/oatmI72m/purpurpacks-hoe-effective-froglights-3.5.jar";
    hash = "sha256-/wrxhKoDMr1CuTZw4Ti4ff7BkecKBwRKCQ6vA9Tz+cg=";
  };

  # Adds cactus to the 'hoe' mineable tag, allowing it to be broken quickly
  hoeEffectiveCactus = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/Xqq7IBeE/versions/iIuv1dGX/purpurpacks-hoe-effective-cactus-3.5.jar";
    hash = "sha256-2WlQ8EFtKsgW6hCWcEOe6rm73wgufl3K/ZW5UzJw6aM=";
  };

  # Allows raw ore blocks like raw iron blocks to be smelted in a furnace or blast furnace
  smeltRawOreBlocks = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/Sue2z8Bl/versions/hHpP7Q1F/purpurpack-smelt-raw-ore-blocks-4.5.jar";
    hash = "sha256-fNyYI+I6npEx31mHzibzjdZK5WkLq7MMftyxnANj3jA=";
  };

  # Allows concrete powder to be dyed another color
  reDyeConcretePowder = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/DUoieMnq/versions/nuk5WK7N/purpurpacks-re-dye-concrete-powder-4.5.jar";
    hash = "sha256-RmuYR+if/YjpQJJKCC9ypnY3JfyRDG9pvnu8doA63EM=";
  };

  # Allows upgrading netherite tools without the use of an upgrade template
  noTemplateNetheriteToolUpgrades = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/R1WCIhLq/versions/tqkS3NMa/purpurpacks-no-template-netherite-tool-upgrades-4.5.jar";
    hash = "sha256-B47f2QU51a3XguyYqjafu4zqkced+qaieivIuZLXRvU=";
  };

  # Allows breeding axolotls with the tropical fish item as well as the bucket
  breedAxolotlWithTropicalFishItem = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/ZLRxxRmh/versions/Snkbq9j0/purpurpack-breed-axolotl-with-tropical-fish-item-4.5.jar";
    hash = "sha256-yvLrYvNaCx28bjMySAFzXhxqnWEBls/xFoNZOLpsdbM=";
  };

  # Allows iron tools to be upgraded to diamond ones in the smithing table using a diamond
  ironToDiamondToolsUpgrades = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/fOi8LwAw/versions/v59ujo9q/purpurpacks-iron-to-diamond-tools-upgrades-4.5.jar";
    hash = "sha256-GPyfRS5QPYV2ul0yZiAWBgAuV3CqoOMgWkEHR0K/pik=";
  };

  # Allows upgrading iron armor to diamond in a smithing table by combining it with a diamond
  ironToDiamondArmorUpgrades = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/UwL3n8Ei/versions/JTzvvWjv/purpurpacks-iron-to-diamond-armor-upgrades-4.5.jar";
    hash = "sha256-k79RQrYkrZnbkPp6k9zLWTLaCRFwfkwQxrM8npEF5Z0=";
  };

  # Allows dyeing wool and carpet with 1 dye per 8 wool/carpet, like most other dyeing recipes
  moreDyedWoolAndCarpet = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/z9M75QAX/versions/wg7VsfPV/purpurpacks-more-dyed-wool-and-carpet-5.5.jar";
    hash = "sha256-JXEbQI/Q4t3blv0OCZSolfspuvXmTHdXIXrtcXrkKEM=";
  };

  # Allows using any solid copper block in a beacon base. Also allows using copper ingots as a beacon payment item
  copperBlockBeaconBase = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/zFdrE9Wt/versions/OCx3GfkZ/purpurpacks-copper-block-beacon-base-4.5.jar";
    hash = "sha256-fNNw42PI+c0eipCmfSdNkc/IArjg0DGi6pWZGQdBOPE=";
  };

  # Use chiseled bookshelves as a bookshelf for your enchanting setup
  chiseledBookshelvesAddEnchantmentPower = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/504BLPX7/versions/ZvNVJfJt/purpurpacks-chiseled-bookshelves-add-enchantment-power-3.5.jar";
    hash = "sha256-qw0UwoG+MPUGpgjIc1rGoyVj/3PJLWzfKcNXLom8n2s=";
  };

  # Adds skulls and heads to the 'axe' mineable tag - allowing axes to break them faster
  axeEffectiveSkulls = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/S7cHoMDR/versions/9OirEWOL/purpurpacks-axe-effective-skulls-3.5.jar";
    hash = "sha256-eytQKxK6q+xE0oEGZnU05k4J0lsd2fuaTyNyQegzsd8=";
  };

  # Allows smelting glass in the blast furnace
  blastingSmeltsGlass = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/yQr7wOEY/versions/d9CfQKSP/purpurpack-blasting-smelts-glass-4.5.jar";
    hash = "sha256-A/0Eo6a0c373I6UdbCJ/w4IwLrneFTN7FDwuF4EiHxo=";
  };

  # Reinforced deepslate now drops when mined with a tool that has silk touch
  silkTouchReinforcedDeepslate = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/B92jc48r/versions/C1PSTjC8/purpurpacks-silk-touch-reinforced-deepslate-4.5.jar";
    hash = "sha256-jZApSrtubrO9bRKlguEjmqfvjrX+t+5Fb1+15ju2neY=";
  };

  # Rebalances Piglin Bartering Pools
  rebalancedPiglinBartering = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/fffp1OgS/versions/b2uXtcsW/purpurpacks-rebalanced-piglin-bartering-4.6.jar";
    hash = "sha256-iSZMLkQD5ZFuGzZ5/4oj9kTCabFSLDjQoLarQJMW2Pk=";
  };

  # Allows stone tools to be upgraded to iron ones in the smithing table with an iron ingot
  stoneToIronToolsUpgrades = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/8zLmjJ4K/versions/EH561TEj/purpurpacks-stone-to-iron-tools-upgrades-4.5.jar";
    hash = "sha256-i9bRBJdcOjGam/KESpAF4R2f9u28isk3mC2f5fEwieY=";
  };

  # Datapack that stops axolotls from hunting passive mobs
  axolotlsIgnorePassives = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/uqr5V1OT/versions/xxhFopxV/purpurpack-axolotls-ignore-passives-3.5.jar";
    hash = "sha256-gH12elEAIkpg+drZrX8FnKl7nGj+xHFdtvZWlAH8ols=";
  };

  # Allows wooden tools to be upgraded to stone in a smithing table
  woodenToStoneToolsUpgrades = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/fEg9tXQ6/versions/vUCob2gH/purpurpacks-wooden-to-stone-tools-upgrades-4.5.jar";
    hash = "sha256-NLtqr02e4B82HmJJy37DbYOBLtiQWyuul4bgesAR5uI=";
  };

  # Allows crafting dyed shulker boxes without having to craft the box first
  oneStepDyedShulkerBoxes = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/cNHq7t9M/versions/RvhpezOV/purpurpacks-one-step-dyed-shulker-boxes-4.5.jar";
    hash = "sha256-MDOcDuen8x1tWHOeQNQDKHqtomaxddMjNJQTZq7POac=";
  };

  # Allows infinity and mending to be placed onto the same bow
  infinityMendingBows = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/NLzRxVcC/versions/D5KKIaGm/purpurpacks-infinity-mending-bows-2.5.jar";
    hash = "sha256-DpsKlCXob+3sEP3Z4izIhpf9eBgWyqoGrCnWgiRgJmc=";
  };

  # Make beacon bases of amethyst blocks, and use amethyst shards as beacon payment
  amethystBeaconBase = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/EP4tesbZ/versions/s42Rs9X3/purpurpacks-amethyst-beacon-base-3.7.jar";
    hash = "sha256-g4fGxMfO5IZjiG+UApEcy6R3Nd9TqLQXwTxhGuBuOUg=";
  };

  # Allows you to use redstone blocks as a block in a beacon base
  redstoneBeaconBase = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/I2neFSkP/versions/yzqSFAZ3/purpurpacks-redstone-beacon-base-3.5.jar";
    hash = "sha256-tiMkxn0RFzEu41Vr4Mv+z2trDfubb2d19RGjeWd1+Z0=";
  };

  # Allows using lapis blocks in a beacon base
  lapisBeaconBase = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/gDqoouES/versions/A3HoIQSy/purpurpacks-lapis-beacon-base-3.5.jar";
    hash = "sha256-6y1wj6mK+nq3UVN++54kiTjeXHMIYNeirBeqlsNsGj8=";
  };

  # Adds the 4 new paintings to the paintings that can be used in survival
  placeableNewPaintings = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/UDhPA1TM/versions/j3GE7w2S/purpurpacks-placeable-new-paintings-3.5.jar";
    hash = "sha256-Ec5PkFME24dzd1eUtsLesmgOg1Izh9NwTRBJ3FtU11A=";
  };

  # Allows infinity on crossbows
  infinityOnCrossbows = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/rvzRe1CC/versions/7nWsQ7Hl/purpurpacks-infinity-on-crossbows-2.5.jar";
    hash = "sha256-TuXkxvxjMFVqHsGvnjLmkARUeefjoKd99/qUiFAz0c8=";
  };

  # Allows re-dying concrete
  reDyeConcrete = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/1hrzfBkm/versions/bqwPkLMl/purpurpacks-re-dye-concrete-2.5.jar";
    hash = "sha256-Jm/NUoEDCcjc8E7s/dYXYBEGvGXVMuuHgkk9+AJKkCY=";
  };

  # Allows re-dying glazed terracotta
  reDyeGlazedTerracotta = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/mBcDOO3o/versions/2hg2QlvB/purpurpacks-re-dye-glazed-terracotta-2.5.jar";
    hash = "sha256-QmFiv2Gl9SNBoD1EopORYKRk9ODYBP9ZugJ3p112r8o=";
  };

  # Allows using raw copper blocks as a beacon base material. Also allows using raw copper as a beacon payment item
  rawCopperBeaconBase = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/ItRpuGf4/versions/5MojiWM7/purpurpacks-raw-copper-beacon-base-3.5.jar";
    hash = "sha256-5fV4gsz8d6MTc7Y1mT9ymJocxMfp7thLYSFHRmJX5rY=";
  };

  # Allows raw gold blocks to be used as a beacon base. Also allows raw gold to be used as a beacon payment item
  rawGoldBeaconBase = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/MqaYXlAP/versions/F7YO85I7/purpurpacks-raw-gold-beacon-base-3.5.jar";
    hash = "sha256-xqgZlpquD+zIr73ohdx/bmVSOFAqKq5KHuRSRYV+/l4=";
  };

  # Allows you to use raw iron blocks as a block in a beacon base
  rawIronBlockBeaconBase = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/8iJVgUtF/versions/FMioonxw/purpurpacks-raw-iron-block-beacon-base-3.5.jar";
    hash = "sha256-mA60PiHNCqe54VYam1aiY9LOBLZ5tQ1F0V66cjwXKOo=";
  };

  # Allows shears to have looting - Shearing drops more items when there is looting on shears
  lootingShears = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/qwRhepin/versions/6o5FuXjG/purpurpacks-looting-shears-1.5.jar";
    hash = "sha256-HnortWJUy9hK9AbB0lN4GF3ATVpANjIqd8cm2oRgdCg=";
  };

  # Stonecutter is usable to craft doors, and trapdoors
  stonecutterCutsDoors = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/VWWrpSlM/versions/2sB7DO51/purpurpacks-stonecutter-cuts-doors-1.5.jar";
    hash = "sha256-Y+H216cvk870c6lDzQZ7h+u3F9R68nhwhcbZmSrpseU=";
  };

  # Adds recipes for slabs and stairs
  stonecutterCutsSlabs = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/k4swAzko/versions/pR89kIY1/purpurpacks-stonecutter-cuts-slabs-1.6.jar";
    hash = "sha256-ajm5rPsFA1itTjC0FkqYWXWt64JTlfZ4Eah6rV+iu9I=";
  };

  # Removes the ability to obtain mending, or use it if it's on anything
  noMending = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/imR8I7dT/versions/7pD2RufB/enchant_remove_mending_v2.5.zip";
    hash = "sha256-IM8oAxARjVsZb6tZfsnKHd/7VutAMItXdDbS5X7INZo=";
  };

  # Removes the ability to enchant an Elytra with Unbreaking, also disables the Unbreaking enchant's effectiveness on Elytra
  noUnbreakingOnElytra = pkgs.fetchurl {
    url =
      "https://cdn.modrinth.com/data/QZKMChtj/versions/I94v9mgk/purpurpacks-no-unbreaking-on-elytra-2.5.jar";
    hash = "sha256-ma1vVkfERj5SJYxTYB6v0iH2JLVEo/1qrnYTomKBZj8=";
  };
in {
  environment.etc."minecraft/allowed_symlinks.txt".text = ''
    /nix/store
  '';

  systemd.tmpfiles.rules = [
    "L+ /var/lib/minecraft/allowed_symlinks.txt - - - - /etc/minecraft/allowed_symlinks.txt"
    "L+ /var/lib/minecraft/world/datapacks/pickaxe-effective-reinforced-deepslate.jar - - - - ${pickaxeEffectiveReinforcedDeepslate}"
    "L+ /var/lib/minecraft/world/datapacks/silk-touch-budding-amethyst.jar - - - - ${silkTouchBuddingAmethyst}"
    "L+ /var/lib/minecraft/world/datapacks/pickaxe-effective-light-source-blocks.jar - - - - ${pickaxeEffectiveLightSourceBlocks}"
    "L+ /var/lib/minecraft/world/datapacks/pickaxe-effective-glass.jar - - - - ${pickaxeEffectiveGlass}"
    "L+ /var/lib/minecraft/world/datapacks/no-template-netherite-armor-upgrades.jar - - - - ${noTemplateNetheriteArmorUpgrades}"
    "L+ /var/lib/minecraft/world/datapacks/transparent-blocks-in-enchant-area.jar - - - - ${transparentBlocksInEnchantArea}"
    "L+ /var/lib/minecraft/world/datapacks/re-dye-terracotta.jar - - - - ${reDyeTerracotta}"
    "L+ /var/lib/minecraft/world/datapacks/re-dye-glass.jar - - - - ${reDyeGlass}"
    "L+ /var/lib/minecraft/world/datapacks/hoe-effective-froglights.jar - - - - ${hoeEffectiveFroglights}"
    "L+ /var/lib/minecraft/world/datapacks/hoe-effective-cactus.jar - - - - ${hoeEffectiveCactus}"
    "L+ /var/lib/minecraft/world/datapacks/smelt-raw-ore-blocks.jar - - - - ${smeltRawOreBlocks}"
    "L+ /var/lib/minecraft/world/datapacks/re-dye-concrete-powder.jar - - - - ${reDyeConcretePowder}"
    "L+ /var/lib/minecraft/world/datapacks/no-template-netherite-tool-upgrades.jar - - - - ${noTemplateNetheriteToolUpgrades}"
    "L+ /var/lib/minecraft/world/datapacks/breed-axolotl-with-tropical-fish-item.jar - - - - ${breedAxolotlWithTropicalFishItem}"
    "L+ /var/lib/minecraft/world/datapacks/iron-to-diamond-tools-upgrades.jar - - - - ${ironToDiamondToolsUpgrades}"
    "L+ /var/lib/minecraft/world/datapacks/iron-to-diamond-armor-upgrades.jar - - - - ${ironToDiamondArmorUpgrades}"
    "L+ /var/lib/minecraft/world/datapacks/more-dyed-wool-and-carpet.jar - - - - ${moreDyedWoolAndCarpet}"
    "L+ /var/lib/minecraft/world/datapacks/copper-block-beacon-base.jar - - - - ${copperBlockBeaconBase}"
    "L+ /var/lib/minecraft/world/datapacks/chiseled-bookshelves-add-enchantment-power.jar - - - - ${chiseledBookshelvesAddEnchantmentPower}"
    "L+ /var/lib/minecraft/world/datapacks/axe-effective-skulls.jar - - - - ${axeEffectiveSkulls}"
    "L+ /var/lib/minecraft/world/datapacks/blasting-smelts-glass.jar - - - - ${blastingSmeltsGlass}"
    "L+ /var/lib/minecraft/world/datapacks/silk-touch-reinforced-deepslate.jar - - - - ${silkTouchReinforcedDeepslate}"
    "L+ /var/lib/minecraft/world/datapacks/rebalanced-piglin-bartering.jar - - - - ${rebalancedPiglinBartering}"
    "L+ /var/lib/minecraft/world/datapacks/stone-to-iron-tools-upgrades.jar - - - - ${stoneToIronToolsUpgrades}"
    "L+ /var/lib/minecraft/world/datapacks/axolotls-ignore-passives.jar - - - - ${axolotlsIgnorePassives}"
    "L+ /var/lib/minecraft/world/datapacks/wooden-to-stone-tools-upgrades.jar - - - - ${woodenToStoneToolsUpgrades}"
    "L+ /var/lib/minecraft/world/datapacks/one-step-dyed-shulker-boxes.jar - - - - ${oneStepDyedShulkerBoxes}"
    "L+ /var/lib/minecraft/world/datapacks/infinity-mending-bows.jar - - - - ${infinityMendingBows}"
    "L+ /var/lib/minecraft/world/datapacks/amethyst-beacon-base.jar - - - - ${amethystBeaconBase}"
    "L+ /var/lib/minecraft/world/datapacks/redstone-beacon-base.jar - - - - ${redstoneBeaconBase}"
    "L+ /var/lib/minecraft/world/datapacks/lapis-beacon-base.jar - - - - ${lapisBeaconBase}"
    "L+ /var/lib/minecraft/world/datapacks/placeable-new-paintings.jar - - - - ${placeableNewPaintings}"
    "L+ /var/lib/minecraft/world/datapacks/infinity-on-crossbows.jar - - - - ${infinityOnCrossbows}"
    "L+ /var/lib/minecraft/world/datapacks/re-dye-concrete.jar - - - - ${reDyeConcrete}"
    "L+ /var/lib/minecraft/world/datapacks/re-dye-glazed-terracotta.jar - - - - ${reDyeGlazedTerracotta}"
    "L+ /var/lib/minecraft/world/datapacks/raw-copper-beacon-base.jar - - - - ${rawCopperBeaconBase}"
    "L+ /var/lib/minecraft/world/datapacks/raw-gold-beacon-base.jar - - - - ${rawGoldBeaconBase}"
    "L+ /var/lib/minecraft/world/datapacks/raw-iron-block-beacon-base.jar - - - - ${rawIronBlockBeaconBase}"
    "L+ /var/lib/minecraft/world/datapacks/looting-shears.jar - - - - ${lootingShears}"
    "L+ /var/lib/minecraft/world/datapacks/stonecutter-cuts-doors.jar - - - - ${stonecutterCutsDoors}"
    "L+ /var/lib/minecraft/world/datapacks/stonecutter-cuts-slabs.jar - - - - ${stonecutterCutsSlabs}"
    "L+ /var/lib/minecraft/world/datapacks/no-mending.zip - - - - ${noMending}"
    "L+ /var/lib/minecraft/world/datapacks/no-unbreaking-on-elytra.jar - - - - ${noUnbreakingOnElytra}"
  ];
}
